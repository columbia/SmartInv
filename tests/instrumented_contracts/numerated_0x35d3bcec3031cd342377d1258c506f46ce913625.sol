1 pragma solidity ^0.4.11;
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
51 contract Owned {
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     address public owner;
58 
59     function Owned() {
60         owner = msg.sender;
61     }
62 
63     address public newOwner;
64 
65     function changeOwner(address _newOwner) onlyOwner {
66         newOwner = _newOwner;
67     }
68 
69     function acceptOwnership() {
70         if (msg.sender == newOwner) {
71             owner = newOwner;
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
89 contract Haltable is Owned {
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
103   function halt() external onlyOwner {
104     halted = true;
105   }
106 
107   // called by the owner on end of emergency, returns to normal state
108   function unhalt() external onlyOwner onlyInEmergency {
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
126     function setPricing() onlyOwner{
127         uint factor = 10 ** decimals;
128         priceList.push(PriceTier(uint(safeDiv(1 ether, 400 * factor)),0,5000 ether));
129         priceList.push(PriceTier(uint((1 ether - (10 wei * factor)) / (90 * factor)),0,5000 ether));
130         priceList.push(PriceTier(uint(1 ether / (80* factor)),0,5000 ether));
131         priceList.push(PriceTier(uint((1 ether - (50 wei * factor)) / (70* factor)),0,5000 ether));
132         priceList.push(PriceTier(uint((1 ether - (40 wei * factor)) / (60* factor)),0,5000 ether));
133         priceList.push(PriceTier(uint(1 ether / (50* factor)),0,5000 ether));
134         priceList.push(PriceTier(uint(1 ether / (40* factor)),0,5000 ether));
135         priceList.push(PriceTier(uint((1 ether - (10 wei * factor))/ (30* factor)),0,5000 ether));
136         priceList.push(PriceTier(uint((1 ether - (10 wei * factor))/ (15* factor)),0,30000 ether));
137         numTiers = 9;
138     }
139     function allocateTokensInternally(uint value) internal constant returns(uint numTokens){
140         if (numTiers == 0) return 0;
141         numTokens = 0;
142         uint8 tierIndex = 0;
143         for (uint8 i = 0; i < numTiers; i++){
144             if (priceList[i].ethersDepositedInTier < priceList[i].maxEthersInTier){
145                 uint ethersToDepositInTier = min256(priceList[i].maxEthersInTier - priceList[i].ethersDepositedInTier, value);
146                 numTokens = safeAdd(numTokens, ethersToDepositInTier / priceList[i].costPerToken);
147                 priceList[i].ethersDepositedInTier = safeAdd(ethersToDepositInTier, priceList[i].ethersDepositedInTier);
148                 totalDepositedEthers = safeAdd(ethersToDepositInTier, totalDepositedEthers);
149                 value = safeSub(value, ethersToDepositInTier);
150                 if (priceList[i].ethersDepositedInTier > 0)
151                     tierIndex = i;
152             }
153         }
154         currentTierIndex = tierIndex;
155         return numTokens;
156     }
157     
158 }
159 
160 contract DAOController{
161     address public dao;
162     modifier onlyDAO{
163         if (msg.sender != dao) throw;
164         _;
165     }
166 }
167 
168 contract CrowdSale is PricingMechanism, DAOController{
169     SphereTokenFactory public tokenFactory;
170     uint public hardCapAmount;
171     bool public isStarted = false;
172     bool public isFinalized = false;
173     uint public duration = 30 days;
174     uint public startTime;
175     address public multiSig;
176     bool public finalizeSet = false;
177     
178     modifier onlyStarted{
179         if (!isStarted) throw;
180         _;
181     }
182     modifier notFinalized{
183         if (isFinalized) throw;
184         _;
185     }
186     modifier afterFinalizeSet{
187         if (!finalizeSet) throw;
188         _;
189     }
190     function CrowdSale(){
191         tokenFactory = SphereTokenFactory(0xf961eb0acf690bd8f92c5f9c486f3b30848d87aa);
192         decimals = 4;
193         setPricing();
194         hardCapAmount = 75000 ether;
195     }
196     function startCrowdsale() onlyOwner {
197         if (isStarted) throw;
198         isStarted = true;
199         startTime = now;
200     }
201     function setDAOAndMultiSig(address _dao, address _multiSig) onlyOwner{
202         dao = _dao;
203         multiSig = _multiSig;
204         finalizeSet = true;
205     }
206     function() payable stopInEmergency onlyStarted notFinalized{
207         if (totalDepositedEthers >= hardCapAmount) throw;
208         uint contribution = msg.value;
209         if (safeAdd(totalDepositedEthers, msg.value) > hardCapAmount){
210             contribution = safeSub(hardCapAmount, totalDepositedEthers);
211         }
212         uint excess = safeSub(msg.value, contribution);
213         uint numTokensToAllocate = allocateTokensInternally(contribution);
214         tokenFactory.mint(msg.sender, numTokensToAllocate);
215         if (excess > 0){
216             msg.sender.send(excess);
217         }
218     }
219     
220     function finalize() payable onlyOwner afterFinalizeSet{
221         if (hardCapAmount == totalDepositedEthers || (now - startTime) > duration){
222             dao.call.gas(150000).value(totalDepositedEthers * 3 / 10)();
223             multiSig.call.gas(150000).value(this.balance)();
224             isFinalized = true;
225         }
226     }
227     function emergencyCease() payable onlyStarted onlyInEmergency onlyOwner afterFinalizeSet{
228         isFinalized = true;
229         isStarted = false;
230         multiSig.call.gas(150000).value(this.balance)();
231     }
232 }