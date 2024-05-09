1 pragma solidity ^0.4.13;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract Controlled {
52     modifier onlyController() {
53         require(msg.sender == controller);
54         _;
55     }
56 
57     address public controller;
58 
59     function Controlled() {
60         controller = msg.sender;
61     }
62 
63     address public newController;
64 
65     function changeOwner(address _newController) onlyController {
66         newController = _newController;
67     }
68 
69     function acceptOwnership() {
70         if (msg.sender == newController) {
71             controller = newController;
72         }
73     }
74 }
75 
76 
77 contract SphereTokenFactory{
78 	function mint(address target, uint amount);
79 }
80 /*
81  * Haltable
82  *
83  * Abstract contract that allows children to implement an
84  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
85  *
86  *
87  * Originally envisioned in FirstBlood ICO contract.
88  */
89 contract Haltable is Controlled {
90   bool public halted;
91 
92   modifier stopInEmergency {
93     if (halted) throw;
94     _;
95   }
96 
97   modifier onlyInEmergency {
98     if (!halted) throw;
99     _;
100   }
101 
102   // called by the owner on emergency, triggers stopped state
103   function halt() external onlyController {
104     halted = true;
105   }
106 
107   // called by the owner on end of emergency, returns to normal state
108   function unhalt() external onlyController onlyInEmergency {
109     halted = false;
110   }
111 
112 }
113 
114 contract PricingMechanism is Haltable, SafeMath{
115     uint public decimals;
116     PriceTier[] public priceList;
117     uint8 public numTiers;
118     uint public currentTierIndex;
119     uint public totalDepositedEthers;
120     
121     struct  PriceTier {
122         uint costPerToken;
123         uint ethersDepositedInTier;
124         uint maxEthersInTier;
125     }
126     function setPricing() onlyController{
127         uint factor = 10 ** decimals;
128         priceList.push(PriceTier(uint(safeDiv(1 ether, 400 * factor)),0,5000 ether));
129         priceList.push(PriceTier(uint(safeDiv(1 ether, 400 * factor)),0,1 ether));
130         numTiers = 2;
131     }
132     function allocateTokensInternally(uint value) internal constant returns(uint numTokens){
133         if (numTiers == 0) return 0;
134         numTokens = 0;
135         uint8 tierIndex = 0;
136         for (uint8 i = 0; i < numTiers; i++){
137             if (priceList[i].ethersDepositedInTier < priceList[i].maxEthersInTier){
138                 uint ethersToDepositInTier = min256(priceList[i].maxEthersInTier - priceList[i].ethersDepositedInTier, value);
139                 numTokens = safeAdd(numTokens, ethersToDepositInTier / priceList[i].costPerToken);
140                 priceList[i].ethersDepositedInTier = safeAdd(ethersToDepositInTier, priceList[i].ethersDepositedInTier);
141                 totalDepositedEthers = safeAdd(ethersToDepositInTier, totalDepositedEthers);
142                 value = safeSub(value, ethersToDepositInTier);
143                 if (priceList[i].ethersDepositedInTier > 0)
144                     tierIndex = i;
145             }
146         }
147         currentTierIndex = tierIndex;
148         return numTokens;
149     }
150     
151 }
152 
153 contract DAOController{
154     address public dao;
155     modifier onlyDAO{
156         if (msg.sender != dao) throw;
157         _;
158     }
159 }
160 
161 contract CrowdSalePreICO is PricingMechanism, DAOController{
162     SphereTokenFactory public tokenFactory;
163     uint public hardCapAmount;
164     bool public isStarted = false;
165     bool public isFinalized = false;
166     uint public duration = 7 days;
167     uint public startTime;
168     address public multiSig;
169     bool public finalizeSet = false;
170     
171     modifier onlyStarted{
172         if (!isStarted) throw;
173         _;
174     }
175     modifier notFinalized{
176         if (isFinalized) throw;
177         _;
178     }
179     modifier afterFinalizeSet{
180         if (!finalizeSet) throw;
181         _;
182     }
183     function CrowdSalePreICO(){
184         tokenFactory = SphereTokenFactory(0xf961eb0acf690bd8f92c5f9c486f3b30848d87aa);
185         decimals = 4;
186         setPricing();
187         hardCapAmount = 5000 ether;
188     }
189     function startCrowdsale() onlyController {
190         if (isStarted) throw;
191         isStarted = true;
192         startTime = now;
193     }
194     function setDAOAndMultiSig(address _dao, address _multiSig) onlyController{
195         dao = _dao;
196         multiSig = _multiSig;
197         finalizeSet = true;
198     }
199     function() payable stopInEmergency onlyStarted notFinalized{
200         if (totalDepositedEthers >= hardCapAmount) throw;
201         uint contribution = msg.value;
202         if (safeAdd(totalDepositedEthers, msg.value) > hardCapAmount){
203             contribution = safeSub(hardCapAmount, totalDepositedEthers);
204         }
205         uint excess = safeSub(msg.value, contribution);
206         uint numTokensToAllocate = allocateTokensInternally(contribution);
207         tokenFactory.mint(msg.sender, numTokensToAllocate);
208         if (excess > 0){
209             msg.sender.send(excess);
210         }
211     }
212     
213     function finalize() payable onlyController afterFinalizeSet{
214         if (hardCapAmount == totalDepositedEthers || (now - startTime) > duration){
215             dao.call.gas(150000).value(totalDepositedEthers * 2 / 10)();
216             multiSig.call.gas(150000).value(this.balance)();
217             isFinalized = true;
218         }
219     }
220     function emergency() payable onlyStarted onlyInEmergency onlyController afterFinalizeSet{
221         isFinalized = true;
222         isStarted = false;
223         multiSig.call.gas(150000).value(this.balance)();
224     }
225 }