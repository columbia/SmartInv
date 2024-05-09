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
23 contract ERC20TokenInterface {
24     function totalSupply() public constant returns (uint256 _totalSupply);
25     function balanceOf(address _owner) public constant returns (uint256 balance);
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 contract tokenRecipientInterface {
35     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
36 }
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         assert(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         require(_newOwner != owner);
52         newOwner = _newOwner;
53     }
54 
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = 0x0;
60     }
61 
62     event OwnerUpdate(address _prevOwner, address _newOwner);
63 }
64 
65 contract MintableTokenInterface {
66     function mint(address _to, uint256 _amount) public;
67 }
68 contract ReentrancyHandlingContract{
69 
70     bool locked;
71 
72     modifier noReentrancy() {
73         require(!locked);
74         locked = true;
75         _;
76         locked = false;
77     }
78 }
79 contract KycContractInterface {
80     function isAddressVerified(address _address) public view returns (bool);
81 }
82 contract MintingContractInterface {
83 
84     address public crowdsaleContractAddress;
85     address public tokenContractAddress;
86     uint public tokenTotalSupply;
87 
88     event MintMade(address _to, uint _ethAmount, uint _tokensMinted, string _message);
89 
90     function doPresaleMinting(address _destination, uint _tokensAmount, uint _ethAmount) public;
91     function doCrowdsaleMinting(address _destination, uint _tokensAmount, uint _ethAmount) public;
92     function doTeamMinting(address _destination) public;
93     function setTokenContractAddress(address _newAddress) public;
94     function setCrowdsaleContractAddress(address _newAddress) public;
95     function killContract() public;
96 }
97 contract Lockable is Owned {
98 
99     uint256 public lockedUntilBlock;
100 
101     event ContractLocked(uint256 _untilBlock, string _reason);
102 
103     modifier lockAffected {
104         require(block.number > lockedUntilBlock);
105         _;
106     }
107 
108     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
109         lockedUntilBlock = _untilBlock;
110         emit ContractLocked(_untilBlock, _reason);
111     }
112 
113 
114     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
115         lockedUntilBlock = _untilBlock;
116         emit ContractLocked(_untilBlock, _reason);
117     }
118 }
119 
120 contract Crowdsale is ReentrancyHandlingContract, Owned {
121     
122     enum state { pendingStart, crowdsale, crowdsaleEnded }
123     struct ContributorData {
124         uint contributionAmount;
125         uint tokensIssued;
126     }
127 
128     state public crowdsaleState = state.pendingStart;
129     
130     address public multisigAddress;
131     address public tokenAddress = 0x0;
132     address public kycAddress = 0x0;
133     address public mintingContractAddress = 0x0;
134 
135     uint public startPhaseLength = 720;
136     uint public startPhaseMinimumContribution = 0.1 * 10**18;
137     uint public startPhaseMaximumcontribution = 40 * 10**18;
138 
139     uint public crowdsaleStartBlock;
140     uint public crowdsaleEndedBlock;
141 
142     mapping(address => ContributorData) public contributorList;
143     uint nextContributorIndex;
144     mapping(uint => address) contributorIndexes;
145 
146     uint public minCap;
147     uint public maxCap;
148     uint public ethRaised;
149     uint public tokenTotalSupply = 300000000 * 10**18;
150     uint public tokensIssued = 0;
151     uint blocksInADay;
152 
153     event CrowdsaleStarted(uint blockNumber);
154     event CrowdsaleEnded(uint blockNumber);
155     event ErrorSendingETH(address to, uint amount);
156     event MinCapReached(uint blockNumber);
157     event MaxCapReached(uint blockNumber);
158 
159     uint nextContributorToClaim;
160     mapping(address => bool) hasClaimedEthWhenFail;
161 
162     function() noReentrancy payable public {
163         require(msg.value != 0);
164         require(crowdsaleState != state.crowdsaleEnded);
165         require(KycContractInterface(kycAddress).isAddressVerified(msg.sender));
166 
167         bool stateChanged = checkCrowdsaleState();
168 
169         if (crowdsaleState == state.crowdsale) {
170             processTransaction(msg.sender, msg.value);
171         } else {
172             refundTransaction(stateChanged);
173         }
174     }
175 
176     function checkCrowdsaleState() internal returns (bool) {
177         if (tokensIssued == maxCap && crowdsaleState != state.crowdsaleEnded) {
178             crowdsaleState = state.crowdsaleEnded;
179             emit CrowdsaleEnded(block.number);
180             return true;
181         }
182 
183         if (block.number >= crowdsaleStartBlock && block.number <= crowdsaleEndedBlock) {
184             if (crowdsaleState != state.crowdsale) {
185                 crowdsaleState = state.crowdsale;
186                 emit CrowdsaleStarted(block.number);
187                 return true;
188             }
189         } else {
190             if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock) {
191                 crowdsaleState = state.crowdsaleEnded;
192                 emit CrowdsaleEnded(block.number);
193                 return true;
194             }
195         }
196         return false;
197     }
198 
199     function refundTransaction(bool _stateChanged) internal {
200         if (_stateChanged) {
201             msg.sender.transfer(msg.value);
202         } else {
203             revert();
204         }
205     }
206 
207     function calculateEthToToken(uint _eth, uint _blockNumber) constant public returns(uint) {
208         if (tokensIssued <= 20000000 * 10**18) {
209             return _eth * 8640;
210         } else if(tokensIssued <= 40000000 * 10**18) {
211             return _eth * 8480;
212         } else if(tokensIssued <= 60000000 * 10**18) {
213             return _eth * 8320;
214         } else if(tokensIssued <= 80000000 * 10**18) {
215             return _eth * 8160;
216         } else {
217             return _eth * 8000;
218         }
219     }
220 
221     function calculateTokenToEth(uint _token, uint _blockNumber) constant public returns(uint) {
222         uint tempTokenAmount;
223         if (tokensIssued <= 20000000 * 10**18) {
224             tempTokenAmount = _token * 1000 / 1008640;
225         } else if(tokensIssued <= 40000000 * 10**18) {
226             tempTokenAmount = _token * 1000 / 8480;
227         } else if(tokensIssued <= 60000000 * 10**18) {
228             tempTokenAmount = _token * 1000 / 8320;
229         } else if(tokensIssued <= 80000000 * 10**18) {
230             tempTokenAmount = _token * 1000 / 8160;
231         } else {
232             tempTokenAmount = _token * 1000 / 8000;
233         }
234         return tempTokenAmount / 1000;
235     }
236 
237     function processTransaction(address _contributor, uint _amount) internal {
238         uint contributionAmount = 0;
239         uint returnAmount = 0;
240         uint tokensToGive = 0;
241 
242         if (block.number < crowdsaleStartBlock + startPhaseLength && _amount > startPhaseMaximumcontribution) {
243             contributionAmount = startPhaseMaximumcontribution;
244             returnAmount = _amount - startPhaseMaximumcontribution;
245         } else {
246             contributionAmount = _amount;
247         }
248         tokensToGive = calculateEthToToken(contributionAmount, block.number);
249 
250         if (tokensToGive > (maxCap - tokensIssued)) {
251             contributionAmount = calculateTokenToEth(maxCap - tokensIssued, block.number);
252             returnAmount = _amount - contributionAmount;
253             tokensToGive = maxCap - tokensIssued;
254             emit MaxCapReached(block.number);
255         }
256 
257         if (contributorList[_contributor].contributionAmount == 0) {
258             contributorIndexes[nextContributorIndex] = _contributor;
259             nextContributorIndex += 1;
260         }
261 
262         contributorList[_contributor].contributionAmount += contributionAmount;
263         ethRaised += contributionAmount;
264 
265         if (tokensToGive > 0) {
266             MintingContractInterface(mintingContractAddress).doCrowdsaleMinting(_contributor, tokensToGive, contributionAmount);
267             contributorList[_contributor].tokensIssued += tokensToGive;
268             tokensIssued += tokensToGive;
269         }
270         if (returnAmount != 0) {
271             _contributor.transfer(returnAmount);
272         } 
273     }
274 
275     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
276         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
277     }
278 
279     function withdrawEth() onlyOwner public {
280         require(this.balance != 0);
281         require(tokensIssued >= minCap);
282 
283         multisigAddress.transfer(this.balance);
284     }
285 
286     function claimEthIfFailed() public {
287         require(block.number > crowdsaleEndedBlock && tokensIssued < minCap);
288         require(contributorList[msg.sender].contributionAmount > 0);
289         require(!hasClaimedEthWhenFail[msg.sender]);
290 
291         uint ethContributed = contributorList[msg.sender].contributionAmount;
292         hasClaimedEthWhenFail[msg.sender] = true;
293         if (!msg.sender.send(ethContributed)) {
294             emit ErrorSendingETH(msg.sender, ethContributed);
295         }
296     }
297 
298     function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
299         require(block.number > crowdsaleEndedBlock && tokensIssued < minCap);
300         address currentParticipantAddress;
301         uint contribution;
302         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
303             currentParticipantAddress = contributorIndexes[nextContributorToClaim];
304             if (currentParticipantAddress == 0x0) {
305                 return;
306             }
307             if (!hasClaimedEthWhenFail[currentParticipantAddress]) {
308                 contribution = contributorList[currentParticipantAddress].contributionAmount;
309                 hasClaimedEthWhenFail[currentParticipantAddress] = true;
310                 if (!currentParticipantAddress.send(contribution)) {
311                     emit ErrorSendingETH(currentParticipantAddress, contribution);
312                 }
313             }
314             nextContributorToClaim += 1;
315         }
316     }
317 
318     function withdrawRemainingBalanceForManualRecovery() onlyOwner public {
319         require(this.balance != 0);
320         require(block.number > crowdsaleEndedBlock);
321         require(contributorIndexes[nextContributorToClaim] == 0x0);
322         multisigAddress.transfer(this.balance);
323     }
324 
325     function setMultisigAddress(address _newAddress) onlyOwner public {
326         multisigAddress = _newAddress;
327     }
328 
329     function setToken(address _newAddress) onlyOwner public {
330         tokenAddress = _newAddress;
331     }
332 
333     function setKycAddress(address _newAddress) onlyOwner public {
334         kycAddress = _newAddress;
335     }
336 
337     function investorCount() constant public returns(uint) {
338         return nextContributorIndex;
339     }
340 
341     function setCrowdsaleStartBlock(uint _block) onlyOwner public {
342         crowdsaleStartBlock = _block;
343     }
344 }
345 
346 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
347 
348     string public standard;
349     string public name;
350     string public symbol;
351     uint8 public decimals;
352 
353     address public mintingContractAddress;
354 
355     uint256 supply = 0;
356     mapping (address => uint256) balances;
357     mapping (address => mapping (address => uint256)) allowances;
358 
359     event Mint(address indexed _to, uint256 _value);
360     event Burn(address indexed _from, uint _value);
361 
362     function totalSupply() constant public returns (uint256) {
363         return supply;
364     }
365 
366     function balanceOf(address _owner) constant public returns (uint256 balance) {
367         return balances[_owner];
368     }
369 
370     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
371         require(_to != 0x0 && _to != address(this));
372         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
373         balances[_to] = safeAdd(balanceOf(_to), _value);
374         emit Transfer(msg.sender, _to, _value);
375         return true;
376     }
377 
378     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
379         allowances[msg.sender][_spender] = _value;
380         emit Approval(msg.sender, _spender, _value);
381         return true;
382     }
383 
384     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
385         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
386         approve(_spender, _value);
387         spender.receiveApproval(msg.sender, _value, this, _extraData);
388         return true;
389     }
390 
391     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
392         require(_to != 0x0 && _to != address(this));
393         balances[_from] = safeSub(balanceOf(_from), _value);
394         balances[_to] = safeAdd(balanceOf(_to), _value);
395         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
396         emit Transfer(_from, _to, _value);
397         return true;
398     }
399 
400     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
401         return allowances[_owner][_spender];
402     }
403 
404     function mint(address _to, uint256 _amount) public {
405         require(msg.sender == mintingContractAddress);
406         supply = safeAdd(supply, _amount);
407         balances[_to] = safeAdd(balances[_to], _amount);
408         emit Mint(_to, _amount);
409         emit Transfer(0x0, _to, _amount);
410     }
411 
412     function burn(uint _amount) public {
413         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
414         supply = safeSub(supply, _amount);
415         emit Burn(msg.sender, _amount);
416         emit Transfer(msg.sender, 0x0, _amount);
417     }
418 
419     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
420         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
421     }
422 
423     function killContract() public onlyOwner {
424         selfdestruct(owner);
425     }
426 }
427 
428 contract EligmaMintingContract is Owned{
429 
430     address public crowdsaleContractAddress;
431     address public tokenContractAddress;
432     uint public tokenTotalSupply;
433 
434     event MintMade(address _to, uint _tokensMinted, string _message);
435 
436     function EligmaMintingContract() public {
437         tokenTotalSupply = 500000000 * 10 ** 18;
438     }
439 
440     function doPresaleMinting(address _destination, uint _tokensAmount) public onlyOwner {
441         require(ERC20TokenInterface(tokenContractAddress).totalSupply() + _tokensAmount <= tokenTotalSupply);
442         MintableTokenInterface(tokenContractAddress).mint(_destination, _tokensAmount);
443         emit MintMade(_destination, _tokensAmount, "Presale mint");
444     }
445 
446     function doCrowdsaleMinting(address _destination, uint _tokensAmount) public {
447         require(msg.sender == crowdsaleContractAddress);
448         require(ERC20TokenInterface(tokenContractAddress).totalSupply() + _tokensAmount <= tokenTotalSupply);
449         MintableTokenInterface(tokenContractAddress).mint(_destination, _tokensAmount);
450         emit MintMade(_destination, _tokensAmount, "Crowdsale mint");
451     }
452 
453     function doTeamMinting(address _destination) public onlyOwner {
454         require(ERC20TokenInterface(tokenContractAddress).totalSupply() < tokenTotalSupply);
455         uint amountToMint = tokenTotalSupply - ERC20TokenInterface(tokenContractAddress).totalSupply();
456         MintableTokenInterface(tokenContractAddress).mint(_destination, amountToMint);
457         emit MintMade(_destination, amountToMint, "Team mint");
458     }
459 
460     function setTokenContractAddress(address _newAddress) public onlyOwner {
461         tokenContractAddress = _newAddress;
462     }
463 
464     function setCrowdsaleContractAddress(address _newAddress) public onlyOwner {
465         crowdsaleContractAddress = _newAddress;
466     }
467 
468     function killContract() public onlyOwner {
469         selfdestruct(owner);
470     }
471 }