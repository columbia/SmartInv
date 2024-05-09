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
23 
24 contract ReentrancyHandlingContract{
25 
26     bool locked;
27 
28     modifier noReentrancy() {
29         require(!locked);
30         locked = true;
31         _;
32         locked = false;
33     }
34 }
35 
36 contract Owned {
37     address public owner;
38     address public newOwner;
39 
40     function Owned() {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         assert(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     function acceptOwnership() public {
55         require(msg.sender == newOwner);
56         OwnerUpdate(owner, newOwner);
57         owner = newOwner;
58         newOwner = 0x0;
59     }
60 
61     event OwnerUpdate(address _prevOwner, address _newOwner);
62 }
63 
64 contract Lockable is Owned {
65 
66     uint256 public lockedUntilBlock;
67 
68     event ContractLocked(uint256 _untilBlock, string _reason);
69 
70     modifier lockAffected {
71         require(block.number > lockedUntilBlock);
72         _;
73     }
74 
75     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
76         lockedUntilBlock = _untilBlock;
77         ContractLocked(_untilBlock, _reason);
78     }
79 
80 
81     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
82         lockedUntilBlock = _untilBlock;
83         ContractLocked(_untilBlock, _reason);
84     }
85 }
86 
87 contract ERC20TokenInterface {
88   function totalSupply() public constant returns (uint256 _totalSupply);
89   function balanceOf(address _owner) public constant returns (uint256 balance);
90   function transfer(address _to, uint256 _value) public returns (bool success);
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
92   function approve(address _spender, uint256 _value) public returns (bool success);
93   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
94 
95   event Transfer(address indexed _from, address indexed _to, uint256 _value);
96   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 
99 contract InsurePalTokenInterface {
100     function mint(address _to, uint256 _amount) public;
101 }
102 
103 contract tokenRecipientInterface {
104   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
105 }
106 
107 contract KycContractInterface {
108     function isAddressVerified(address _address) public view returns (bool);
109 }
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 contract KycContract is Owned {
120     
121     mapping (address => bool) verifiedAddresses;
122     
123     function isAddressVerified(address _address) public view returns (bool) {
124         return verifiedAddresses[_address];
125     }
126     
127     function addAddress(address _newAddress) public onlyOwner {
128         require(!verifiedAddresses[_newAddress]);
129         
130         verifiedAddresses[_newAddress] = true;
131     }
132     
133     function removeAddress(address _oldAddress) public onlyOwner {
134         require(verifiedAddresses[_oldAddress]);
135         
136         verifiedAddresses[_oldAddress] = false;
137     }
138     
139     function batchAddAddresses(address[] _addresses) public onlyOwner {
140         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
141             assert(!verifiedAddresses[_addresses[cnt]]);
142             verifiedAddresses[_addresses[cnt]] = true;
143         }
144     }
145     
146     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner{
147         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
148     }
149     
150     function killContract() public onlyOwner {
151         selfdestruct(owner);
152     }
153 }
154 
155 
156 
157 
158 
159 
160 
161 contract Crowdsale is ReentrancyHandlingContract, Owned {
162 
163   struct ContributorData {
164     uint contributionAmount;
165     uint tokensIssued;
166   }
167 
168   mapping(address => ContributorData) public contributorList;
169   uint nextContributorIndex;
170   mapping(uint => address) contributorIndexes;
171 
172   state public crowdsaleState = state.pendingStart;
173   enum state { pendingStart, crowdsale, crowdsaleEnded }
174 
175   uint public crowdsaleStartBlock;
176   uint public crowdsaleEndedBlock;
177 
178   event CrowdsaleStarted(uint blockNumber);
179   event CrowdsaleEnded(uint blockNumber);
180   event ErrorSendingETH(address to, uint amount);
181   event MinCapReached(uint blockNumber);
182   event MaxCapReached(uint blockNumber);
183 
184   address tokenAddress = 0x0;
185   address kycAddress = 0x0;
186   uint decimals = 18;
187 
188   uint public minCap; //InTokens
189   uint public maxCap; //InTokens
190   uint public ethRaised;
191   uint public tokenTotalSupply = 300000000 * 10**decimals;
192   uint public tokensIssued = 0;
193 
194   address public multisigAddress;
195   uint blocksInADay;
196 
197   uint nextContributorToClaim;
198   mapping(address => bool) hasClaimedEthWhenFail;
199 
200   uint crowdsaleTokenCap =          201000000 * 10**decimals;
201   uint founders =                    30000000 * 10**decimals;
202   uint insurePalTeam =               18000000 * 10**decimals;
203   uint tcsSupportTeam =              18000000 * 10**decimals;
204   uint advisorsAndAmbassadors =      18000000 * 10**decimals;
205   uint incentives =                   9000000 * 10**decimals;
206   uint earlyInvestors =               6000000 * 10**decimals;
207   bool foundersTokensClaimed = false;
208   bool insurePalTeamTokensClaimed = false;
209   bool tcsSupportTeamTokensClaimed = false;
210   bool advisorsAndAmbassadorsTokensClaimed = false;
211   bool incentivesTokensClaimed = false;
212   bool earlyInvestorsTokensClaimed = false;
213 
214   //
215   // Unnamed function that runs when eth is sent to the contract
216   //
217   function() noReentrancy payable public {
218     require(msg.value != 0);                        // Throw if value is 0
219     require(crowdsaleState != state.crowdsaleEnded);// Check if crowdsale has ended
220     require(KycContractInterface(kycAddress).isAddressVerified(msg.sender));
221 
222     bool stateChanged = checkCrowdsaleState();      // Check blocks and calibrate crowdsale state
223 
224     if (crowdsaleState == state.crowdsale) {
225       processTransaction(msg.sender, msg.value);    // Process transaction and issue tokens
226     } else {
227       refundTransaction(stateChanged);              // Set state and return funds or throw
228     }
229   }
230 
231   //
232   // Check crowdsale state and calibrate it
233   //
234   function checkCrowdsaleState() internal returns (bool) {
235     if (tokensIssued == maxCap && crowdsaleState != state.crowdsaleEnded) {                     // Check if max cap is reached
236       crowdsaleState = state.crowdsaleEnded;
237       CrowdsaleEnded(block.number);                                                             // Raise event
238       return true;
239     }
240 
241     if (block.number >= crowdsaleStartBlock && block.number <= crowdsaleEndedBlock) {            // Check if we are in crowdsale state
242       if (crowdsaleState != state.crowdsale) {                                                  // Check if state needs to be changed
243         crowdsaleState = state.crowdsale;                                                       // Set new state
244         CrowdsaleStarted(block.number);                                                         // Raise event
245         return true;
246       }
247     } else {
248       if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock) {       // Check if crowdsale is over
249         crowdsaleState = state.crowdsaleEnded;                                                  // Set new state
250         CrowdsaleEnded(block.number);                                                           // Raise event
251         return true;
252       }
253     }
254     return false;
255   }
256 
257   //
258   // Decide if throw or only return ether
259   //
260   function refundTransaction(bool _stateChanged) internal {
261     if (_stateChanged) {
262       msg.sender.transfer(msg.value);
263     } else {
264       revert();
265     }
266   }
267 
268   function calculateEthToToken(uint _eth, uint _blockNumber) constant public returns(uint) {
269     if (_blockNumber < crowdsaleStartBlock + blocksInADay * 4) {
270       return _eth * 12817;
271     }
272     if (_eth >= 50*10**decimals) {
273       return _eth * 12817;
274     }
275     if (_blockNumber > crowdsaleStartBlock) {
276       return _eth * 11652;
277     }
278   }
279 
280   function calculateTokenToEth(uint _token, uint _blockNumber) constant public returns(uint) {
281     if (_blockNumber < crowdsaleStartBlock + blocksInADay * 4) {
282       return _token * 10000 / 12817;
283     }
284     if (_token >= 50*12817*10**decimals) {
285       return _token * 10000 / 12817;
286     }
287     if (_blockNumber > crowdsaleStartBlock) {
288       return _token * 10000 / 11652;
289     }
290   }
291 
292   //
293   // Issue tokens and return if there is overflow
294   //
295 
296   function processTransaction(address _contributor, uint _amount) internal {
297     uint contributionAmount = _amount;
298     uint returnAmount = 0;
299     uint tokensToGive = calculateEthToToken(contributionAmount, block.number);
300 
301     if (tokensToGive > (maxCap - tokensIssued)) {                                     // Check if max contribution is lower than _amount sent
302       contributionAmount = calculateTokenToEth(maxCap - tokensIssued, block.number) / 10000;  // Set that user contibutes his maximum alowed contribution
303       returnAmount = _amount - contributionAmount;                                    // Calculate howmuch he must get back
304       tokensToGive = maxCap - tokensIssued;
305       MaxCapReached(block.number);
306     }
307 
308     if (contributorList[_contributor].contributionAmount == 0) {
309         contributorIndexes[nextContributorIndex] = _contributor;
310         nextContributorIndex += 1;
311     }
312 
313     contributorList[_contributor].contributionAmount += contributionAmount;
314     ethRaised += contributionAmount;                                              // Add to eth raised
315 
316     if (tokensToGive > 0) {
317       InsurePalTokenInterface(tokenAddress).mint(_contributor, tokensToGive);       // Issue new tokens
318       contributorList[_contributor].tokensIssued += tokensToGive;                  // log token issuance
319       tokensIssued += tokensToGive;
320     }
321     if (returnAmount != 0) {
322       _contributor.transfer(returnAmount);
323     } 
324   }
325 
326   function pushAngelInvestmentData(address _address, uint _ethContributed) onlyOwner public {
327       processTransaction(_address, _ethContributed);
328   }
329 
330   function depositAngelInvestmentEth() payable onlyOwner public {}
331   
332 
333   //
334   // Method is needed for recovering tokens accedentaly sent to token address
335   //
336   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
337     ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
338   }
339 
340   //
341   // withdrawEth when minimum cap is reached
342   //
343   function withdrawEth() onlyOwner public {
344     require(this.balance != 0);
345     require(tokensIssued >= minCap);
346 
347     multisigAddress.transfer(this.balance);
348   }
349 
350   //
351   // Users can claim their contribution if min cap is not raised
352   //
353   function claimEthIfFailed() public {
354     require(block.number > crowdsaleEndedBlock && tokensIssued < minCap);    // Check if crowdsale has failed
355     require(contributorList[msg.sender].contributionAmount > 0);          // Check if contributor has contributed to crowdsaleEndedBlock
356     require(!hasClaimedEthWhenFail[msg.sender]);                          // Check if contributor has already claimed his eth
357 
358     uint ethContributed = contributorList[msg.sender].contributionAmount; // Get contributors contribution
359     hasClaimedEthWhenFail[msg.sender] = true;                             // Set that he has claimed
360     if (!msg.sender.send(ethContributed)) {                                // Refund eth
361       ErrorSendingETH(msg.sender, ethContributed);                        // If there is an issue raise event for manual recovery
362     }
363   }
364 
365   //
366   // Owner can batch return contributors contributions(eth)
367   //
368   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
369     require(block.number > crowdsaleEndedBlock && tokensIssued < minCap);                // Check if crowdsale has failed
370     address currentParticipantAddress;
371     uint contribution;
372     for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
373       currentParticipantAddress = contributorIndexes[nextContributorToClaim];         // Get next unclaimed participant
374       if (currentParticipantAddress == 0x0) {
375         return;                                                                       // Check if all the participants were compensated
376       }
377       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {                        // Check if participant has already claimed
378         contribution = contributorList[currentParticipantAddress].contributionAmount; // Get contribution of participant
379         hasClaimedEthWhenFail[currentParticipantAddress] = true;                      // Set that he has claimed
380         if (!currentParticipantAddress.send(contribution)) {                          // Refund eth
381           ErrorSendingETH(currentParticipantAddress, contribution);                   // If there is an issue raise event for manual recovery
382         }
383       }
384       nextContributorToClaim += 1;                                                    // Repeat
385     }
386   }
387 
388   //
389   // If there were any issue/attach with refund owner can withraw eth at the end for manual recovery
390   //
391   function withdrawRemainingBalanceForManualRecovery() onlyOwner public {
392     require(this.balance != 0);                                  // Check if there are any eth to claim
393     require(block.number > crowdsaleEndedBlock);                 // Check if crowdsale is over
394     require(contributorIndexes[nextContributorToClaim] == 0x0);  // Check if all the users were refunded
395     multisigAddress.transfer(this.balance);                      // Withdraw to multisig
396   }
397 
398   function claimTeamTokens(address _to, uint _choice) onlyOwner public {
399     require(crowdsaleState == state.crowdsaleEnded);
400     require(tokensIssued >= minCap);
401 
402     uint mintAmount;
403     if (_choice == 1) {
404       assert(!insurePalTeamTokensClaimed);
405       mintAmount = insurePalTeam;
406       insurePalTeamTokensClaimed = true;
407     } else if (_choice == 2) {
408       assert(!tcsSupportTeamTokensClaimed);
409       mintAmount = tcsSupportTeam;
410       tcsSupportTeamTokensClaimed = true;
411     } else if (_choice == 3) {
412       assert(!advisorsAndAmbassadorsTokensClaimed);
413       mintAmount = advisorsAndAmbassadors;
414       advisorsAndAmbassadorsTokensClaimed = true;
415     } else if (_choice == 4) {
416       assert(!incentivesTokensClaimed);
417       mintAmount = incentives;
418       incentivesTokensClaimed = true;
419     } else if (_choice == 5) {
420       assert(!earlyInvestorsTokensClaimed);
421       mintAmount = earlyInvestors;
422       earlyInvestorsTokensClaimed = true;
423     } else if (_choice == 6) {
424       assert(!foundersTokensClaimed);
425       assert(insurePalTeamTokensClaimed);
426       assert(tcsSupportTeamTokensClaimed);
427       assert(advisorsAndAmbassadorsTokensClaimed);
428       assert(incentivesTokensClaimed);
429       assert(earlyInvestorsTokensClaimed);
430       assert(tokenTotalSupply > ERC20TokenInterface(tokenAddress).totalSupply());
431       mintAmount = tokenTotalSupply - ERC20TokenInterface(tokenAddress).totalSupply();
432       foundersTokensClaimed = true;
433     } else {
434       revert();
435     }
436     InsurePalTokenInterface(tokenAddress).mint(_to, mintAmount);
437   }
438 
439   //
440   // Owner can set multisig address for crowdsale
441   //
442   function setMultisigAddress(address _newAddress) onlyOwner public {
443     multisigAddress = _newAddress;
444   }
445 
446   //
447   // Owner can set token address where mints will happen
448   //
449   function setToken(address _newAddress) onlyOwner public {
450     tokenAddress = _newAddress;
451   }
452 
453   function setKycAddress(address _newAddress) onlyOwner public {
454     kycAddress = _newAddress;
455   }
456 
457   function getTokenAddress() constant public returns(address) {
458     return tokenAddress;
459   }
460 
461   function investorCount() constant public returns(uint) {
462     return nextContributorIndex;
463   }
464 
465   function setCrowdsaleStartBlock(uint _block) onlyOwner public {
466     crowdsaleStartBlock = _block;
467   }
468 }
469 
470 
471 
472 contract InsurePalCrowdsale is Crowdsale {
473   
474   function InsurePalCrowdsale() {
475 
476     crowdsaleStartBlock = 4918135;
477     crowdsaleEndedBlock = 5031534; 
478 
479     minCap = 50000000 * 10**18;
480     maxCap = 201000000 * 10**18;
481 
482     blocksInADay = 5400;
483   }
484 }