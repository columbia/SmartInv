1 pragma solidity ^0.4.21;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     function Owned() public {
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
30 
31 contract ReentrancyHandlingContract{
32 
33     bool locked;
34 
35     modifier noReentrancy() {
36         require(!locked);
37         locked = true;
38         _;
39         locked = false;
40     }
41 }
42 
43 contract KycContractInterface {
44     function isAddressVerified(address _address) public view returns (bool);
45 }
46 
47 contract MintingContractInterface {
48 
49     address public crowdsaleContractAddress;
50     address public tokenContractAddress;
51     uint public tokenTotalSupply;
52 
53     event MintMade(address _to, uint _ethAmount, uint _tokensMinted, string _message);
54 
55     function doPresaleMinting(address _destination, uint _tokensAmount) public;
56     function doCrowdsaleMinting(address _destination, uint _tokensAmount) public;
57     function doTeamMinting(address _destination) public;
58     function setTokenContractAddress(address _newAddress) public;
59     function setCrowdsaleContractAddress(address _newAddress) public;
60     function killContract() public;
61 }
62 
63 contract ERC20TokenInterface {
64     function totalSupply() public constant returns (uint256 _totalSupply);
65     function balanceOf(address _owner) public constant returns (uint256 balance);
66     function transfer(address _to, uint256 _value) public returns (bool success);
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
68     function approve(address _spender, uint256 _value) public returns (bool success);
69     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 }
74 
75 contract Crowdsale is ReentrancyHandlingContract, Owned {
76     
77     enum state { pendingStart, crowdsale, crowdsaleEnded }
78     struct ContributorData {
79         uint contributionAmount;
80         uint tokensIssued;
81     }
82 
83     state public crowdsaleState = state.pendingStart;
84     
85     address public multisigAddress = 0x0;
86     address public kycAddress = 0x0;
87     address public mintingContractAddress = 0x0;
88 
89     uint public startPhaseLength = 720;
90     uint public startPhaseMaximumcontribution = 10 * 10**18;
91 
92     uint public crowdsaleStartBlock;
93     uint public crowdsaleEndedBlock;
94 
95     mapping(address => ContributorData) public contributorList;
96     uint nextContributorIndex;
97     mapping(uint => address) contributorIndexes;
98 
99     uint public minCap;
100     uint public maxCap;
101     uint public ethRaised;
102     uint public tokensIssued = 0;
103 
104     event CrowdsaleStarted(uint blockNumber);
105     event CrowdsaleEnded(uint blockNumber);
106     event ErrorSendingETH(address to, uint amount);
107     event MinCapReached(uint blockNumber);
108     event MaxCapReached(uint blockNumber);
109 
110     uint nextContributorToClaim;
111     mapping(address => bool) hasClaimedEthWhenFail;
112 
113     function() noReentrancy payable public {
114         require(msg.value >= 100000000000000000);
115         require(crowdsaleState != state.crowdsaleEnded);
116         require(KycContractInterface(kycAddress).isAddressVerified(msg.sender));
117 
118         bool stateChanged = checkCrowdsaleState();
119 
120         if (crowdsaleState == state.crowdsale) {
121             processTransaction(msg.sender, msg.value);
122         } else {
123             refundTransaction(stateChanged);
124         }
125     }
126 
127     function checkCrowdsaleState() internal returns (bool) {
128         if (tokensIssued == maxCap && crowdsaleState != state.crowdsaleEnded) {
129             crowdsaleState = state.crowdsaleEnded;
130             emit CrowdsaleEnded(block.number);
131             return true;
132         }
133 
134         if (block.number >= crowdsaleStartBlock && block.number <= crowdsaleEndedBlock) {
135             if (crowdsaleState != state.crowdsale) {
136                 crowdsaleState = state.crowdsale;
137                 emit CrowdsaleStarted(block.number);
138                 return true;
139             }
140         } else {
141             if (crowdsaleState != state.crowdsaleEnded && block.number > crowdsaleEndedBlock) {
142                 crowdsaleState = state.crowdsaleEnded;
143                 emit CrowdsaleEnded(block.number);
144                 return true;
145             }
146         }
147         return false;
148     }
149 
150     function refundTransaction(bool _stateChanged) internal {
151         if (_stateChanged) {
152             msg.sender.transfer(msg.value);
153         } else {
154             revert();
155         }
156     }
157 
158     function calculateEthToToken(uint _eth, uint _blockNumber) constant public returns(uint) {
159         if (tokensIssued <= 20000000 * 10**18) {
160             return _eth * 8640;
161         } else if(tokensIssued <= 40000000 * 10**18) {
162             return _eth * 8480;
163         } else if(tokensIssued <= 60000000 * 10**18) {
164             return _eth * 8320;
165         } else if(tokensIssued <= 80000000 * 10**18) {
166             return _eth * 8160;
167         } else {
168             return _eth * 8000;
169         }
170     }
171 
172     function calculateTokenToEth(uint _token, uint _blockNumber) constant public returns(uint) {
173         uint tempTokenAmount;
174         if (tokensIssued <= 20000000 * 10**18) {
175             tempTokenAmount = (_token * 1000) / 1008640;
176         } else if(tokensIssued <= 40000000 * 10**18) {
177             tempTokenAmount = (_token * 1000) / 8480;
178         } else if(tokensIssued <= 60000000 * 10**18) {
179             tempTokenAmount = (_token * 1000) / 8320;
180         } else if(tokensIssued <= 80000000 * 10**18) {
181             tempTokenAmount = (_token * 1000) / 8160;
182         } else {
183             tempTokenAmount = (_token * 1000) / 8000;
184         }
185         return tempTokenAmount / 1000;
186     }
187 
188     function processTransaction(address _contributor, uint _amount) internal {
189         uint contributionAmount = 0;
190         uint returnAmount = 0;
191         uint tokensToGive = 0;
192 
193         if (block.number < crowdsaleStartBlock + startPhaseLength) {
194             if((_amount + contributorList[_contributor].contributionAmount) > startPhaseMaximumcontribution) {
195                 if (contributorList[_contributor].contributionAmount < startPhaseMaximumcontribution) {
196                     contributionAmount = startPhaseMaximumcontribution - contributorList[_contributor].contributionAmount;
197                     returnAmount = _amount - contributionAmount;
198                 } else {
199                     revert();
200                 }
201             } else {
202                 contributionAmount = _amount;
203             }
204         } else {
205             contributionAmount = _amount;
206         }
207         
208         tokensToGive = calculateEthToToken(contributionAmount, block.number);
209 
210         if (tokensToGive > (maxCap - tokensIssued)) {
211             contributionAmount = calculateTokenToEth(maxCap - tokensIssued, block.number);
212             returnAmount = _amount - contributionAmount;
213             tokensToGive = maxCap - tokensIssued;
214             emit MaxCapReached(block.number);
215         }
216 
217         if (contributorList[_contributor].contributionAmount == 0) {
218             contributorIndexes[nextContributorIndex] = _contributor;
219             nextContributorIndex += 1;
220         }
221 
222         contributorList[_contributor].contributionAmount += contributionAmount;
223         ethRaised += contributionAmount;
224 
225         if (tokensToGive > 0) {
226             MintingContractInterface(mintingContractAddress).doCrowdsaleMinting(_contributor, tokensToGive);
227             contributorList[_contributor].tokensIssued += tokensToGive;
228             tokensIssued += tokensToGive;
229         }
230         if (returnAmount != 0) {
231             _contributor.transfer(returnAmount);
232         } 
233     }
234 
235     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
236         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
237     }
238 
239     function withdrawEth() onlyOwner public {
240         require(address(this).balance != 0);
241         require(tokensIssued >= minCap);
242 
243         multisigAddress.transfer(address(this).balance);
244     }
245 
246     function claimEthIfFailed() public {
247         require(block.number > crowdsaleEndedBlock && tokensIssued < minCap);
248         require(contributorList[msg.sender].contributionAmount > 0);
249         require(!hasClaimedEthWhenFail[msg.sender]);
250 
251         uint ethContributed = contributorList[msg.sender].contributionAmount;
252         hasClaimedEthWhenFail[msg.sender] = true;
253         if (!msg.sender.send(ethContributed)) {
254             emit ErrorSendingETH(msg.sender, ethContributed);
255         }
256     }
257 
258     function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner public {
259         require(block.number > crowdsaleEndedBlock && tokensIssued < minCap);
260         address currentParticipantAddress;
261         uint contribution;
262         for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
263             currentParticipantAddress = contributorIndexes[nextContributorToClaim];
264             if (currentParticipantAddress == 0x0) {
265                 return;
266             }
267             if (!hasClaimedEthWhenFail[currentParticipantAddress]) {
268                 contribution = contributorList[currentParticipantAddress].contributionAmount;
269                 hasClaimedEthWhenFail[currentParticipantAddress] = true;
270                 if (!currentParticipantAddress.send(contribution)) {
271                     emit ErrorSendingETH(currentParticipantAddress, contribution);
272                 }
273             }
274             nextContributorToClaim += 1;
275         }
276     }
277 
278     function withdrawRemainingBalanceForManualRecovery() onlyOwner public {
279         require(address(this).balance != 0);
280         require(block.number > crowdsaleEndedBlock);
281         require(contributorIndexes[nextContributorToClaim] == 0x0);
282         multisigAddress.transfer(address(this).balance);
283     }
284 
285     function setMultisigAddress(address _newAddress) onlyOwner public {
286         multisigAddress = _newAddress;
287     }
288 
289     function setMintingContractAddress(address _newAddress) onlyOwner public {
290         mintingContractAddress = _newAddress;
291     }
292 
293     function setKycAddress(address _newAddress) onlyOwner public {
294         kycAddress = _newAddress;
295     }
296 
297     function investorCount() constant public returns(uint) {
298         return nextContributorIndex;
299     }
300 
301     function setCrowdsaleStartBlock(uint _block) onlyOwner public {
302         crowdsaleStartBlock = _block;
303     }
304 }
305 
306 contract EligmaCrowdsaleContract is Crowdsale {
307   
308     function EligmaCrowdsaleContract() public {
309 
310         crowdsaleStartBlock = 5456462;
311         crowdsaleEndedBlock = 5584081; 
312 
313         minCap = 0 * 10**18;
314         maxCap = 161054117 * 10**18;
315     }
316 }