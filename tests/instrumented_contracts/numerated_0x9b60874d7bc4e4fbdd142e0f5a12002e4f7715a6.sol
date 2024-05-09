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
27 contract IToken {
28   function totalSupply() constant returns (uint256 totalSupply);
29   function mintTokens(address _to, uint256 _amount) {}
30 }
31 contract IMintableToken {
32   function mintTokens(address _to, uint256 _amount){}
33 }
34 contract IERC20Token {
35   function totalSupply() constant returns (uint256 totalSupply);
36   function balanceOf(address _owner) constant returns (uint256 balance) {}
37   function transfer(address _to, uint256 _value) returns (bool success) {}
38   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
39   function approve(address _spender, uint256 _value) returns (bool success) {}
40   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42   event Transfer(address indexed _from, address indexed _to, uint256 _value);
43   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract ItokenRecipient {
47   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
48 }
49 
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     function Owned() {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         assert(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         require(_newOwner != owner);
65         newOwner = _newOwner;
66     }
67 
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         OwnerUpdate(owner, newOwner);
71         owner = newOwner;
72         newOwner = 0x0;
73     }
74 
75     event OwnerUpdate(address _prevOwner, address _newOwner);
76 }
77 contract ReentrnacyHandlingContract{
78 
79     bool locked;
80 
81     modifier noReentrancy() {
82         require(!locked);
83         locked = true;
84         _;
85         locked = false;
86     }
87 }
88 
89 contract Lockable is Owned{
90 
91   uint256 public lockedUntilBlock;
92 
93   event ContractLocked(uint256 _untilBlock, string _reason);
94 
95   modifier lockAffected {
96       require(block.number > lockedUntilBlock);
97       _;
98   }
99 
100   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
101     lockedUntilBlock = _untilBlock;
102     ContractLocked(_untilBlock, _reason);
103   }
104 
105 
106   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
107     lockedUntilBlock = _untilBlock;
108     ContractLocked(_untilBlock, _reason);
109   }
110 }
111 
112 contract Crowdsale is ReentrnacyHandlingContract, Owned{
113 
114   struct ContributorData{
115     uint priorityPassAllowance;
116     bool isActive;
117     uint contributionAmount;
118     uint tokensIssued;
119   }
120 
121   mapping(address => ContributorData) public contributorList;
122   uint nextContributorIndex;
123   mapping(uint => address) contributorIndexes;
124 
125   state public crowdsaleState = state.pendingStart;
126   enum state { pendingStart, priorityPass, openedPriorityPass, crowdsale, crowdsaleEnded }
127 
128   uint public presaleStartBlock;
129   uint public presaleUnlimitedStartBlock;
130   uint public crowdsaleStartBlock;
131   uint public crowdsaleEndedBlock;
132 
133   event PresaleStarted(uint blockNumber);
134   event PresaleUnlimitedStarted(uint blockNumber);
135   event CrowdsaleStarted(uint blockNumber);
136   event CrowdsaleEnded(uint blockNumber);
137   event ErrorSendingETH(address to, uint amount);
138   event MinCapReached(uint blockNumber);
139   event MaxCapReached(uint blockNumber);
140 
141   IToken token = IToken(0x0);
142   uint ethToTokenConversion;
143 
144   uint public minCap;
145   uint public maxP1Cap;
146   uint public maxCap;
147   uint public ethRaised;
148 
149   address public multisigAddress;
150 
151   uint nextContributorToClaim;
152   mapping(address => bool) hasClaimedEthWhenFail;
153 
154   uint maxTokenSupply;
155   bool ownerHasClaimedTokens;
156   uint cofounditReward;
157   address cofounditAddress;
158   bool cofounditHasClaimedTokens;
159 
160   //
161   // Unnamed function that runs when eth is sent to the contract
162   //
163   function() noReentrancy payable{
164     require(msg.value != 0);                        // Throw if value is 0
165     require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
166 
167     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
168 
169     if (crowdsaleState == state.priorityPass){
170       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
171         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
172       }else{
173         refundTransaction(stateChanged);            // Set state and return funds or throw
174       }
175     }
176     else if(crowdsaleState == state.openedPriorityPass){
177       if (contributorList[msg.sender].isActive){    // Check if contributor is in priorityPass
178         processTransaction(msg.sender, msg.value);  // Process transaction and issue tokens
179       }else{
180         refundTransaction(stateChanged);            // Set state and return funds or throw
181       }
182     }
183     else if(crowdsaleState == state.crowdsale){
184       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
185     }
186     else{
187       refundTransaction(stateChanged);              // Set state and return funds or throw
188     }
189   }
190 
191   //
192   // Check crowdsale state and calibrate it
193   //
194   function checkCrowdsaleState() internal returns (bool){
195     if (ethRaised == maxCap && crowdsaleState != state.crowdsaleEnded){                         // Check if max cap is reached
196       crowdsaleState = state.crowdsaleEnded;
197       MaxCapReached(block.number);                                                              // Close the crowdsale
198       CrowdsaleEnded(block.number);                                                             // Raise event
199       return true;
200     }
201 
202     if (block.number > presaleStartBlock && block.number <= presaleUnlimitedStartBlock){  // Check if we are in presale phase
203       if (crowdsaleState != state.priorityPass){                                          // Check if state needs to be changed
204         crowdsaleState = state.priorityPass;                                              // Set new state
205         PresaleStarted(block.number);                                                     // Raise event
206         return true;
207       }
208     }else if(block.number > presaleUnlimitedStartBlock && block.number <= crowdsaleStartBlock){ // Check if we are in presale unlimited phase
209       if (crowdsaleState != state.openedPriorityPass){                                          // Check if state needs to be changed
210         crowdsaleState = state.openedPriorityPass;                                              // Set new state
211         PresaleUnlimitedStarted(block.number);                                                  // Raise event
212         return true;
213       }
214     }else if(block.number > crowdsaleStartBlock && block.number <= crowdsaleEndedBlock){        // Check if we are in crowdsale state
215       if (crowdsaleState != state.crowdsale){                                                   // Check if state needs to be changed
216         crowdsaleState = state.crowdsale;                                                       // Set new state
217         CrowdsaleStarted(block.number);                                                         // Raise event
218         return true;
219       }
220     }else{
221       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock){        // Check if crowdsale is over
222         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
223         CrowdsaleEnded(block.number);                                                           // Raise event
224         return true;
225       }
226     }
227     return false;
228   }
229 
230   //
231   // Decide if throw or only return ether
232   //
233   function refundTransaction(bool _stateChanged) internal{
234     if (_stateChanged){
235       msg.sender.transfer(msg.value);
236     }else{
237       revert();
238     }
239   }
240 
241   //
242   // Calculate how much user can contribute
243   //
244   function calculateMaxContribution(address _contributor) constant returns (uint maxContribution){
245     uint maxContrib;
246     if (crowdsaleState == state.priorityPass){    // Check if we are in priority pass
247       maxContrib = contributorList[_contributor].priorityPassAllowance - contributorList[_contributor].contributionAmount;
248       if (maxContrib > (maxP1Cap - ethRaised)){   // Check if max contribution is more that max cap
249         maxContrib = maxP1Cap - ethRaised;        // Alter max cap
250       }
251     }
252     else{
253       maxContrib = maxCap - ethRaised;            // Alter max cap
254     }
255     return maxContrib;
256   }
257 
258   //
259   // Issue tokens and return if there is overflow
260   //
261   function processTransaction(address _contributor, uint _amount) internal{
262     uint maxContribution = calculateMaxContribution(_contributor);              // Calculate max users contribution
263     uint contributionAmount = _amount;
264     uint returnAmount = 0;
265     if (maxContribution < _amount){                                             // Check if max contribution is lower than _amount sent
266       contributionAmount = maxContribution;                                     // Set that user contibutes his maximum alowed contribution
267       returnAmount = _amount - maxContribution;                                 // Calculate howmuch he must get back
268     }
269 
270     if (ethRaised + contributionAmount > minCap && minCap > ethRaised) MinCapReached(block.number);
271 
272     if (contributorList[_contributor].isActive == false){                       // Check if contributor has already contributed
273       contributorList[_contributor].isActive = true;                            // Set his activity to true
274       contributorList[_contributor].contributionAmount = contributionAmount;    // Set his contribution
275       contributorIndexes[nextContributorIndex] = _contributor;                  // Set contributors index
276       nextContributorIndex++;
277     }
278     else{
279       contributorList[_contributor].contributionAmount += contributionAmount;   // Add contribution amount to existing contributor
280     }
281     ethRaised += contributionAmount;                                            // Add to eth raised
282 
283     uint tokenAmount = contributionAmount * ethToTokenConversion;               // Calculate how much tokens must contributor get
284     if (tokenAmount > 0){
285       token.mintTokens(_contributor, tokenAmount);                                // Issue new tokens
286       contributorList[_contributor].tokensIssued += tokenAmount;                  // log token issuance
287     }
288     if (returnAmount != 0) _contributor.transfer(returnAmount);                 // Return overflow of ether
289   }
290 
291   //
292   // Push contributor data to the contract before the crowdsale so that they are eligible for priorit pass
293   //
294   function editContributors(address[] _contributorAddresses, uint[] _contributorPPAllowances) onlyOwner{
295     require(_contributorAddresses.length == _contributorPPAllowances.length); // Check if input data is correct
296 
297     for(uint cnt = 0; cnt < _contributorAddresses.length; cnt++){
298       if (contributorList[_contributorAddresses[cnt]].isActive){
299         contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];
300       }
301       else{
302         contributorList[_contributorAddresses[cnt]].isActive = true;
303         contributorList[_contributorAddresses[cnt]].priorityPassAllowance = _contributorPPAllowances[cnt];
304         contributorIndexes[nextContributorIndex] = _contributorAddresses[cnt];
305         nextContributorIndex++;
306       }
307     }
308   }
309 
310   //
311   // Method is needed for recovering tokens accedentaly sent to token address
312   //
313   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
314     IERC20Token(_tokenAddress).transfer(_to, _amount);
315   }
316 
317   //
318   // withdrawEth when minimum cap is reached
319   //
320   function withdrawEth() onlyOwner{
321     require(this.balance != 0);
322     require(ethRaised >= minCap);
323 
324     pendingEthWithdrawal = this.balance;
325   }
326   uint pendingEthWithdrawal;
327   function sanityCheck(){
328     require(msg.sender == multisigAddress);
329     require(pendingEthWithdrawal > 0);
330 
331     multisigAddress.transfer(pendingEthWithdrawal);
332     pendingEthWithdrawal = 0;
333   }
334 
335   //
336   // Users can claim their contribution if min cap is not raised
337   //
338   function claimEthIfFailed(){
339     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);    // Check if crowdsale has failed
340     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
341     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
342 
343     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
344     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
345     if (!msg.sender.send(ethContributed)){                                // Refund eth
346       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
347     }
348   }
349 
350   //
351   // Owner can batch return contributors contributions(eth)
352   //
353   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner{
354     require(block.number > crowdsaleEndedBlock && ethRaised < minCap);                // Check if crowdsale has failed
355     address currentParticipantAddress;
356     uint contribution;
357     for (uint cnt = 0; cnt < _numberOfReturns; cnt++){
358       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
359       if (currentParticipantAddress == 0x0) return;                                   // Check if all the participants were compensated
360       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
361         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
362         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
363         if (!currentParticipantAddress.send(contribution)){                           // Refund eth
364           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
365         }
366       }
367       nextContributorToClaim += 1;                                                    // Repeat
368     }
369   }
370 
371   //
372   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
373   //
374   function withdrawRemainingBalanceForManualRecovery() onlyOwner{
375     require(this.balance != 0);                                  // Check if there are any eth to claim
376     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
377     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
378     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
379   }
380 
381   //
382   // Owner can set multisig address for crowdsale
383   //
384   function setMultisigAddress(address _newAddress) onlyOwner{
385     multisigAddress = _newAddress;
386   }
387 
388   //
389   // Owner can set token address where mints will happen
390   //
391   function setToken(address _newAddress) onlyOwner{
392     token = IToken(_newAddress);
393   }
394 
395   //
396   // Owner can claim teams tokens when crowdsale has successfully ended
397   //
398   function claimCoreTeamsTokens(address _to) onlyOwner{
399     require(crowdsaleState == state.crowdsaleEnded);              // Check if crowdsale has ended
400     require(!ownerHasClaimedTokens);                              // Check if owner has allready claimed tokens
401 
402     uint devReward = maxTokenSupply - token.totalSupply();
403     if (!cofounditHasClaimedTokens) devReward -= cofounditReward; // If cofoundit has claimed tokens its ok if not set aside cofounditReward
404     token.mintTokens(_to, devReward);                             // Issue Teams tokens
405     ownerHasClaimedTokens = true;                                 // Block further mints from this method
406   }
407 
408   //
409   // Cofoundit can claim their tokens
410   //
411   function claimCofounditTokens(address _to){
412     require(msg.sender == cofounditAddress);            // Check if sender is cofoundit
413     require(crowdsaleState == state.crowdsaleEnded);    // Check if crowdsale has ended
414     require(!cofounditHasClaimedTokens);                // Check if cofoundit has allready claimed tokens
415 
416     token.mintTokens(_to, cofounditReward);             // Issue cofoundit tokens
417     cofounditHasClaimedTokens = true;                   // Block further mints from this method
418   }
419 
420   function getTokenAddress() constant returns(address){
421     return address(token);
422   }
423 }
424 
425 
426 
427 contract MaecenasCrowdsale is Crowdsale {
428   function MaecenasCrowdsale(){
429     presaleStartBlock = 4241483;
430     presaleUnlimitedStartBlock = 4245055;
431     crowdsaleStartBlock = 4248627;
432     crowdsaleEndedBlock = 4348635;
433 
434     minCap = 9375 * 10**18;
435     maxP1Cap = 31250 * 10**18;
436     maxCap = 62500 * 10**18;
437 
438     ethToTokenConversion = 480;
439 
440     maxTokenSupply = 100000000 * 10**18;
441     cofounditReward = 4000000 * 10**18;
442     cofounditAddress = 0x988c3eA5554f3D2fB5ECB4dC5c35126eEf3B8a5D;
443   }
444 }