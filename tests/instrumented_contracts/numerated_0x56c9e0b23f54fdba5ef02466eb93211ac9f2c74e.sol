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
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     function Owned() {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         assert(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address _newOwner) public onlyOwner {
49         require(_newOwner != owner);
50         newOwner = _newOwner;
51     }
52 
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         OwnerUpdate(owner, newOwner);
56         owner = newOwner;
57         newOwner = 0x0;
58     }
59 
60     event OwnerUpdate(address _prevOwner, address _newOwner);
61 }
62 
63 contract Lockable is Owned {
64 
65     uint256 public lockedUntilBlock;
66 
67     event ContractLocked(uint256 _untilBlock, string _reason);
68 
69     modifier lockAffected {
70         require(block.number > lockedUntilBlock);
71         _;
72     }
73 
74     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
75         lockedUntilBlock = _untilBlock;
76         ContractLocked(_untilBlock, _reason);
77     }
78 
79 
80     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
81         lockedUntilBlock = _untilBlock;
82         ContractLocked(_untilBlock, _reason);
83     }
84 }
85 
86 contract LinkedList {
87 
88 	struct Element {
89     	uint previous;
90     	uint next;
91 
92     	address data;
93   	}
94 
95   	uint public size;
96   	uint public tail;
97   	uint public head;
98   	mapping(uint => Element) elements;
99   	mapping(address => uint) elementLocation;
100 
101 	function addItem(address _newItem) returns (bool) {
102 		Element memory elem = Element(0, 0, _newItem);
103 
104 		if (size == 0) {
105         	head = 1;
106       	} else {
107         	elements[tail].next = tail + 1;
108         	elem.previous = tail;
109       	}
110 
111       	elementLocation[_newItem] = tail + 1;
112       	elements[tail + 1] = elem;
113       	size++;
114       	tail++;
115       	return true;
116 	}
117 
118     function removeItem(address _item) returns (bool) {
119         uint key;
120         if (elementLocation[_item] == 0) {
121             return false;
122         }else {
123             key = elementLocation[_item];
124         }
125 
126         if (size == 1) {
127             tail = 0;
128             head = 0;
129         }else if (key == head) {
130             head = elements[head].next;
131         }else if (key == tail) {
132             tail = elements[tail].previous;
133             elements[tail].next = 0;
134         }else {
135             elements[key - 1].next = elements[key].next;
136             elements[key + 1].previous = elements[key].previous;
137         }
138 
139         size--;
140         delete elements[key];
141         elementLocation[_item] = 0;
142         return true;
143     }
144 
145     function getAllElements() constant returns(address[]) {
146         address[] memory tempElementArray = new address[](size);
147         uint cnt = 0;
148         uint currentElemId = head;
149         while (cnt < size) {
150             tempElementArray[cnt] = elements[currentElemId].data;
151             currentElemId = elements[currentElemId].next;
152             cnt += 1;
153         }
154         return tempElementArray;
155     }
156 
157     function getElementAt(uint _index) constant returns (address) {
158         return elements[_index].data;
159     }
160 
161     function getElementLocation(address _element) constant returns (uint) {
162         return elementLocation[_element];
163     }
164 
165     function getNextElement(uint _currElementId) constant returns (uint) {
166         return elements[_currElementId].next;
167     }
168 }
169 
170 contract RootDonationsContract is Owned {
171 
172     LinkedList donationsList = new LinkedList();
173 
174     function addNewDonation(address _donationAddress) public onlyOwner {
175         require(donationsList.getElementLocation(_donationAddress) != 0);
176         donationsList.addItem(_donationAddress);
177     }
178 
179     function removeDonation(address _donationAddress) public onlyOwner {
180         require(donationsList.getElementLocation(_donationAddress) == 0);
181         donationsList.removeItem(_donationAddress);
182     }
183 
184     function getDonations() constant public returns (address[]) {
185         address[] memory tempElementArray = new address[](donationsList.size());
186         uint cnt = 0;
187         uint tempArrayCnt = 0;
188         uint currentElemId = donationsList.head();
189         while (cnt < donationsList.size()) {
190             tempElementArray[tempArrayCnt] = donationsList.getElementAt(currentElemId);
191             
192             currentElemId = donationsList.getNextElement(currentElemId);
193             cnt++;
194             return tempElementArray;
195         }
196         
197     }
198 }
199 
200 contract DonationContract is Owned {
201 
202     struct ContributorData {
203         bool active;
204         uint contributionAmount;
205         bool hasVotedForDisable;
206     }
207     mapping(address => ContributorData) public contributorList;
208     uint public nextContributorIndex;
209     mapping(uint => address) public contributorIndexes;
210     uint public nextContributorToReturn;
211 
212     enum phase { pendingStart, started, EndedFail, EndedSucess, disabled, finished}
213     phase public donationPhase;
214 
215     uint public maxCap;
216     uint public minCap;
217 
218     uint public donationsStartTime;
219     uint public donationsEndedTime;
220 
221     address tokenAddress;
222     uint public tokensDonated;
223 
224     event MinCapReached(uint blockNumber);
225     event MaxCapReached(uint blockNumber);
226     event FundsClaimed(address athlete, uint _value, uint blockNumber);
227 
228     uint public athleteCanClaimPercent;
229     uint public tick;
230     uint public lastClaimed;
231     uint public athleteAlreadyClaimed;
232     address public athlete;
233     uint public contractFee;
234     address public feeWallet;
235 
236     uint public tokensVotedForDisable;
237 
238 
239 
240 
241 
242 
243 
244 
245 
246 
247     function DonationContract(  address _tokenAddress,
248                                 uint _minCap,
249                                 uint _maxCap,
250                                 uint _donationsStartTime,
251                                 uint _donationsEndedTime,
252                                 uint _athleteCanClaimPercent,
253                                 uint _tick,
254                                 address _athlete,
255                                 uint _contractFee,
256                                 address _feeWallet) {
257         tokenAddress = _tokenAddress;
258         minCap = _minCap;
259         maxCap = _maxCap;
260         donationsStartTime = _donationsStartTime;
261         donationsEndedTime = _donationsEndedTime;
262         donationPhase = phase.pendingStart;
263         require(_athleteCanClaimPercent <= 100);
264         athleteCanClaimPercent = _athleteCanClaimPercent;
265         tick = _tick;
266         athlete = _athlete;
267         require(_athleteCanClaimPercent <= 100);
268         contractFee = _contractFee;
269         feeWallet = _feeWallet;
270     }
271 
272     function receiveApproval(address _from, uint256 _value, address _to, bytes _extraData) public {
273         require(_to == tokenAddress);
274         require(_value != 0);
275 
276         if (donationPhase == phase.pendingStart) {
277             if (now >= donationsStartTime) {
278                 donationPhase = phase.started;
279             } else {
280                 revert();
281             }
282         }
283 
284         if(donationPhase == phase.started) {
285             if (now > donationsEndedTime){
286                 if(tokensDonated >= minCap){
287                     donationPhase = phase.EndedSucess;
288                 }else{
289                     donationPhase = phase.EndedFail;
290                 }
291             }else{
292                 uint tokensToTake = processTransaction(_from, _value);
293                 ERC20TokenInterface(tokenAddress).transferFrom(_from, address(this), tokensToTake);
294             }
295         }else{
296             revert();
297         }
298     }
299 
300     function processTransaction(address _from, uint _value) internal returns (uint) {
301         uint valueToProcess = 0;
302         if (tokensDonated + _value >= maxCap) {
303             valueToProcess = maxCap - tokensDonated;
304             donationPhase = phase.EndedSucess;
305             MaxCapReached(block.number);
306         } else {
307             valueToProcess = _value;
308             if (tokensDonated < minCap && tokensDonated + valueToProcess >= minCap) {
309                 MinCapReached(block.number);
310             }
311         }
312         if (!contributorList[_from].active) {
313             contributorList[_from].active = true;
314             contributorList[_from].contributionAmount = valueToProcess;
315             contributorIndexes[nextContributorIndex] = _from;
316             nextContributorIndex++;
317         }else{
318             contributorList[_from].contributionAmount += valueToProcess;
319         }
320         tokensDonated += valueToProcess;
321         return valueToProcess;
322     }
323 
324     function manuallyProcessTransaction(address _from, uint _value) onlyOwner public {
325         require(_value != 0);
326         require(ERC20TokenInterface(tokenAddress).balanceOf(address(this)) >= _value + tokensDonated);
327 
328         if (donationPhase == phase.pendingStart) {
329             if (now >= donationsStartTime) {
330                 donationPhase = phase.started;
331             } else {
332                 ERC20TokenInterface(tokenAddress).transfer(_from, _value);
333             }
334         }
335 
336         if(donationPhase == phase.started) {
337             uint tokensToTake = processTransaction(_from, _value);
338             ERC20TokenInterface(tokenAddress).transfer(_from, _value - tokensToTake);
339         }else{
340             ERC20TokenInterface(tokenAddress).transfer(_from, _value);
341         }
342     }
343 
344     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
345         require(_tokenAddress != tokenAddress);
346         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
347     }
348 
349     function claimFunds() public {
350         require(donationPhase == phase.EndedSucess);
351         require(athleteAlreadyClaimed < tokensDonated);
352         require(athlete == msg.sender);
353         if (lastClaimed == 0) {
354             lastClaimed = now;
355         } else {
356             require(lastClaimed + tick <= now);
357         }
358         uint claimAmount = (athleteCanClaimPercent * tokensDonated) / 100;
359         if (athleteAlreadyClaimed + claimAmount >= tokensDonated) {
360             claimAmount = tokensDonated - athleteAlreadyClaimed;
361             donationPhase = phase.finished;
362         }
363         athleteAlreadyClaimed += claimAmount;
364         lastClaimed += tick;
365         uint fee = (claimAmount * contractFee) / 100;
366         ERC20TokenInterface(tokenAddress).transfer(athlete, claimAmount - fee);
367         ERC20TokenInterface(tokenAddress).transfer(feeWallet, fee);
368         FundsClaimed(athlete, claimAmount, block.number);
369     }
370 
371     function disableDonationContract() public {
372         require(msg.sender == athlete);
373         require(donationPhase == phase.EndedSucess);
374 
375         donationPhase = phase.disabled;
376     }
377 
378     function voteForDisable() public {
379         require(donationPhase == phase.EndedSucess);
380         require(contributorList[msg.sender].active);
381         require(!contributorList[msg.sender].hasVotedForDisable);
382 
383         tokensVotedForDisable += contributorList[msg.sender].contributionAmount;
384         contributorList[msg.sender].hasVotedForDisable = true;
385 
386         if (tokensVotedForDisable >= tokensDonated/2) {
387             donationPhase = phase.disabled;
388         }
389     }
390 
391     function batchReturnTokensIfFailed(uint _numberOfReturns) public {
392         require(donationPhase == phase.EndedFail);
393         address currentParticipantAddress;
394         uint contribution;
395         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
396             currentParticipantAddress = contributorIndexes[nextContributorToReturn];
397             if (currentParticipantAddress == 0x0) {
398                 donationPhase = phase.finished;
399                 return;
400             }
401             contribution = contributorList[currentParticipantAddress].contributionAmount;
402             ERC20TokenInterface(tokenAddress).transfer(currentParticipantAddress, contribution);
403             nextContributorToReturn += 1;
404         }
405     }
406 
407     function batchReturnTokensIfDisabled(uint _numberOfReturns) public {
408         require(donationPhase == phase.disabled);
409         address currentParticipantAddress;
410         uint contribution;
411         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
412             currentParticipantAddress = contributorIndexes[nextContributorToReturn];
413             if (currentParticipantAddress == 0x0) {
414                 donationPhase = phase.finished;
415                 return;
416             }
417             contribution = (contributorList[currentParticipantAddress].contributionAmount * (tokensDonated - athleteAlreadyClaimed)) / tokensDonated;
418             ERC20TokenInterface(tokenAddress).transfer(currentParticipantAddress, contribution);
419             nextContributorToReturn += 1;
420         }
421     }
422 
423     function getSaleFinancialData() public constant returns(uint,uint){
424         return (tokensDonated, maxCap);
425     }
426 
427     function getClaimedFinancialData() public constant returns(uint,uint){
428         return (athleteAlreadyClaimed, tokensDonated);
429     }
430 }
431 
432 
433 contract ERC20TokenInterface {
434   function totalSupply() public constant returns (uint256 _totalSupply);
435   function balanceOf(address _owner) public constant returns (uint256 balance);
436   function transfer(address _to, uint256 _value) public returns (bool success);
437   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
438   function approve(address _spender, uint256 _value) public returns (bool success);
439   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
440 
441   event Transfer(address indexed _from, address indexed _to, uint256 _value);
442   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
443 }
444 contract tokenRecipientInterface {
445   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
446 }
447 contract SportifyTokenInterface {
448     function mint(address _to, uint256 _amount) public;
449 }