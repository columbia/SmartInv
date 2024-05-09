1 pragma solidity ^0.4.23;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         assert(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address _newOwner) public onlyOwner {
17         require(_newOwner != owner);
18         newOwner = _newOwner;
19     }
20 
21     function acceptOwnership() public {
22         require(msg.sender == newOwner);
23         emit OwnerUpdate(owner, newOwner);
24         owner = newOwner;
25         newOwner = 0x0;
26     }
27 
28     event OwnerUpdate(address _prevOwner, address _newOwner);
29 }
30 contract ReentrancyHandlingContract{
31 
32     bool locked;
33 
34     modifier noReentrancy() {
35         require(!locked);
36         locked = true;
37         _;
38         locked = false;
39     }
40 }
41 
42 contract ERC20TokenInterface {
43     function totalSupply() public constant returns (uint256 _totalSupply);
44     function balanceOf(address _owner) public constant returns (uint256 balance);
45     function transfer(address _to, uint256 _value) public returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47     function approve(address _spender, uint256 _value) public returns (bool success);
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 contract Crowdsale is ReentrancyHandlingContract, Owned {
55     
56     enum state { pendingStart, crowdsale, crowdsaleEnded }
57     struct ContributorData {
58         uint contributionAmount;
59         uint tokensIssued;
60     }
61     struct Tier {
62         uint minContribution;
63         uint maxContribution;
64         uint bonus;
65         bool tierActive;
66     }
67     mapping (address => uint) public verifiedAddresses;
68     mapping(uint => Tier) public tierList;
69     uint public nextFreeTier = 1;
70     
71 
72     state public crowdsaleState = state.pendingStart;
73     
74     address public multisigAddress;
75 
76     uint public crowdsaleStartBlock;
77     uint public crowdsaleEndedBlock;
78 
79     mapping(address => ContributorData) public contributorList;
80     uint public nextContributorIndex;
81     mapping(uint => address) public contributorIndexes;
82 
83     uint public minCap;
84     uint public maxCap;
85     uint public ethRaised;
86     uint public tokensIssued = 0;
87     uint public blocksInADay;
88     uint public ethToTokenConversion;
89 
90     event CrowdsaleStarted(uint blockNumber);
91     event CrowdsaleEnded(uint blockNumber);
92     event ErrorSendingETH(address to, uint amount);
93     event MinCapReached(uint blockNumber);
94     event MaxCapReached(uint blockNumber);
95 
96     function() noReentrancy payable public {
97         require(crowdsaleState != state.crowdsaleEnded);
98         require(isAddressVerified(msg.sender));
99         
100         bool stateChanged = checkCrowdsaleState();
101 
102         if (crowdsaleState == state.crowdsale) {
103             processTransaction(msg.sender, msg.value);
104         } else {
105             refundTransaction(stateChanged);
106         }
107     }
108 
109     function checkCrowdsaleState() internal returns (bool) {
110         if (tokensIssued == maxCap && crowdsaleState != state.crowdsaleEnded) {
111             crowdsaleState = state.crowdsaleEnded;
112             emit CrowdsaleEnded(block.number);
113             return true;
114         }
115 
116         if (block.number >= crowdsaleStartBlock && block.number <= crowdsaleEndedBlock) {
117             if (crowdsaleState != state.crowdsale) {
118                 crowdsaleState = state.crowdsale;
119                 emit CrowdsaleStarted(block.number);
120                 return true;
121             }
122         } else {
123             if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock) {
124                 crowdsaleState = state.crowdsaleEnded;
125                 emit CrowdsaleEnded(block.number);
126                 return true;
127             }
128         }
129         return false;
130     }
131 
132     function refundTransaction(bool _stateChanged) internal {
133         if (_stateChanged) {
134             msg.sender.transfer(msg.value);
135         } else {
136             revert();
137         }
138     }
139     
140     function setEthToTokenConversion(uint _ratio) onlyOwner public {
141         require(crowdsaleState == state.pendingStart);
142         ethToTokenConversion = _ratio;
143     }
144     
145     function setMaxCap(uint _maxCap) onlyOwner public {
146         require(crowdsaleState == state.pendingStart);
147         maxCap = _maxCap;
148     }
149     
150     function calculateEthToToken(uint _eth, uint _bonus) constant public returns(uint) {
151         uint bonusTokens;
152         if (_bonus != 0) {
153             bonusTokens = ((_eth * ethToTokenConversion) * _bonus) / 100;
154         } 
155         return (_eth * ethToTokenConversion) + bonusTokens;
156     }
157 
158     function calculateTokenToEth(uint _token, uint _bonus) constant public returns(uint) {
159         uint ethTokenWithBonus = ethToTokenConversion;
160         if (_bonus != 0){
161             ethTokenWithBonus = ((ethToTokenConversion * _bonus) / 100) + ethToTokenConversion;
162         }
163         return _token / ethTokenWithBonus;
164     }
165 
166     function processTransaction(address _contributor, uint _amount) internal {
167         uint contributionAmount = 0;
168         uint returnAmount = 0;
169         uint tokensToGive = 0;
170         uint contributorTier;
171         uint minContribution;
172         uint maxContribution;
173         uint bonus;
174         (contributorTier, minContribution, maxContribution, bonus) = getContributorData(_contributor); 
175 
176         if (block.number >= crowdsaleStartBlock && block.number < crowdsaleStartBlock + blocksInADay){
177             require(_amount >= minContribution);
178             require(contributorTier == 1 || contributorTier == 2 || contributorTier == 5 || contributorTier == 6 || contributorTier == 7 || contributorTier == 8);
179             if (_amount > maxContribution && maxContribution != 0){
180                 contributionAmount = maxContribution;
181                 returnAmount = _amount - maxContribution;
182             } else {
183                 contributionAmount = _amount;
184             }
185             tokensToGive = calculateEthToToken(contributionAmount, bonus);
186         } else if (block.number >= crowdsaleStartBlock + blocksInADay && block.number < crowdsaleStartBlock + 2 * blocksInADay) {
187             require(_amount >= minContribution);
188             require(contributorTier == 3 || contributorTier == 5 || contributorTier == 6 || contributorTier == 7 || contributorTier == 8);
189             if (_amount > maxContribution && maxContribution != 0) {
190                 contributionAmount = maxContribution;
191                 returnAmount = _amount - maxContribution;
192             } else {
193                 contributionAmount = _amount;
194             }
195             tokensToGive = calculateEthToToken(contributionAmount, bonus);
196         } else {
197             require(_amount >= minContribution);
198             if (_amount > maxContribution && maxContribution != 0) {
199                 contributionAmount = maxContribution;
200                 returnAmount = _amount - maxContribution;
201             } else {
202                 contributionAmount = _amount;
203             }
204             if(contributorTier == 5 || contributorTier == 6 || contributorTier == 7 || contributorTier == 8){
205                 tokensToGive = calculateEthToToken(contributionAmount, bonus);
206             }else{
207                 tokensToGive = calculateEthToToken(contributionAmount, 0);
208             }
209         }
210 
211         if (tokensToGive > (maxCap - tokensIssued)) {
212             if (block.number >= crowdsaleStartBlock && block.number < crowdsaleStartBlock + blocksInADay){
213                 contributionAmount = calculateTokenToEth(maxCap - tokensIssued, bonus);
214             }else if (block.number >= crowdsaleStartBlock + blocksInADay && block.number < crowdsaleStartBlock + 2 * blocksInADay) {
215                 contributionAmount = calculateTokenToEth(maxCap - tokensIssued, bonus);
216             }else{
217                 if(contributorTier == 5 || contributorTier == 6 || contributorTier == 7 || contributorTier == 8){
218                     contributionAmount = calculateTokenToEth(maxCap - tokensIssued, bonus);
219                 }else{
220                     contributionAmount = calculateTokenToEth(maxCap - tokensIssued, 0);
221                 }
222             }
223 
224             returnAmount = _amount - contributionAmount;
225             tokensToGive = maxCap - tokensIssued;
226             emit MaxCapReached(block.number);
227         }
228 
229         if (contributorList[_contributor].contributionAmount == 0) {
230             contributorIndexes[nextContributorIndex] = _contributor;
231             nextContributorIndex += 1;
232         }
233 
234         contributorList[_contributor].contributionAmount += contributionAmount;
235         ethRaised += contributionAmount;
236 
237         if (tokensToGive > 0) {
238             contributorList[_contributor].tokensIssued += tokensToGive;
239             tokensIssued += tokensToGive;
240         }
241         if (returnAmount != 0) {
242             _contributor.transfer(returnAmount);
243         } 
244     }
245 
246     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
247         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
248     }
249 
250     function withdrawEth() onlyOwner public {
251         require(address(this).balance != 0);
252         require(tokensIssued >= minCap);
253 
254         multisigAddress.transfer(address(this).balance);
255     }
256 
257     function investorCount() constant public returns(uint) {
258         return nextContributorIndex;
259     }
260 
261     function setCrowdsaleStartBlock(uint _block) onlyOwner public {
262         require(crowdsaleState == state.pendingStart);
263         crowdsaleStartBlock = _block;
264     }
265 
266     function setCrowdsaleEndBlock(uint _block) onlyOwner public {
267         require(crowdsaleState == state.pendingStart);
268         crowdsaleEndedBlock = _block;
269     }
270     
271     function isAddressVerified(address _address) public view returns (bool) {
272         if (verifiedAddresses[_address] == 0){
273             return false;
274         } else {
275             return true;
276         }
277     }
278 
279     function getContributorData(address _contributor) public view returns (uint, uint, uint, uint) {
280         uint contributorTier = verifiedAddresses[_contributor];
281         return (contributorTier, tierList[contributorTier].minContribution, tierList[contributorTier].maxContribution, tierList[contributorTier].bonus);
282     }
283     
284     function addAddress(address _newAddress, uint _tier) public onlyOwner {
285         require(verifiedAddresses[_newAddress] == 0);
286         
287         verifiedAddresses[_newAddress] = _tier;
288     }
289     
290     function removeAddress(address _oldAddress) public onlyOwner {
291         require(verifiedAddresses[_oldAddress] != 0);
292         
293         verifiedAddresses[_oldAddress] = 0;
294     }
295     
296     function batchAddAddresses(address[] _addresses, uint[] _tiers) public onlyOwner {
297         require(_addresses.length == _tiers.length);
298         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
299             assert(verifiedAddresses[_addresses[cnt]] != 0);
300             verifiedAddresses[_addresses[cnt]] = _tiers[cnt];
301         }
302     }
303 }
304 
305 contract MoneyRebelCrowdsaleContract is Crowdsale {
306   
307     constructor() public {
308 
309         crowdsaleStartBlock = 5578000;
310         crowdsaleEndedBlock = 5618330;
311 
312         minCap = 0 * 10**18;
313         maxCap = 744428391 * 10**18;
314 
315         ethToTokenConversion = 13888;
316 
317         blocksInADay = 5760;
318 
319         multisigAddress = 0x352C30f3092556CD42fE39cbCF585f33CE1C20bc;
320  
321         tierList[1] = Tier(2*10**17,35*10**18,10, true);
322         tierList[2] = Tier(2*10**17,35*10**18,10, true);
323         tierList[3] = Tier(2*10**17,25*10**18,0, true);
324         tierList[4] = Tier(2*10**17,100000*10**18,0, true);
325         tierList[5] = Tier(2*10**17,100000*10**18,8, true);
326         tierList[6] = Tier(2*10**17,100000*10**18,10, true); 
327         tierList[7] = Tier(2*10**17,100000*10**18,12, true);
328         tierList[8] = Tier(2*10**17,100000*10**18,15, true);
329     }
330 }