1 pragma solidity ^0.4.13;
2 
3 
4 /* taking ideas from FirstBlood token */
5 contract SafeMath {
6 
7     function safeAdd(uint256 x, uint256 y) internal returns (uint256) {
8         uint256 z = x + y;
9         assert((z >= x) && (z >= y));
10         return z;
11     }
12 
13     function safeSubtract(uint256 x, uint256 y) internal returns (uint256) {
14         assert(x >= y);
15         uint256 z = x - y;
16         return z;
17     }
18 
19     function safeMult(uint256 x, uint256 y) internal returns (uint256) {
20         uint256 z = x * y;
21         assert((x == 0) || (z / x == y));
22         return z;
23     }
24 }
25 
26 
27 /*
28  * Ownable
29  *
30  * Base contract with an owner.
31  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
32  */
33 contract Ownable {
34     address public owner;
35 
36     function Ownable() {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner {
46         if (newOwner != address(0)) {
47             owner = newOwner;
48         }
49     }
50 
51 }
52 
53 
54 /*
55  * Haltable
56  *
57  * Abstract contract that allows children to implement an
58  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
59  *
60  *
61  * Originally envisioned in FirstBlood ICO contract.
62  */
63 contract Haltable is Ownable {
64     bool public halted;
65 
66     modifier stopInEmergency {
67         require(!halted);
68         _;
69     }
70 
71     modifier onlyInEmergency {
72         require(halted);
73         _;
74     }
75 
76     // called by the owner on emergency, triggers stopped state
77     function halt() external onlyOwner {
78         halted = true;
79     }
80 
81     // called by the owner on end of emergency, returns to normal state
82     function unhalt() external onlyOwner onlyInEmergency {
83         halted = false;
84     }
85 
86 }
87 
88 
89 contract FluencePreSale is Haltable, SafeMath {
90 
91     mapping (address => uint256) public balanceOf;
92 
93     /*/
94      *  Constants
95     /*/
96 
97     string public constant name = "Fluence Presale Token";
98 
99     string public constant symbol = "FPT";
100 
101     uint   public constant decimals = 18;
102 
103     // 6% of tokens
104     uint256 public constant SUPPLY_LIMIT = 6000000 ether;
105 
106     // What is given to contributors, <= SUPPLY_LIMIT
107     uint256 public totalSupply;
108 
109     // If soft cap is not reached, refund process is started
110     uint256 public softCap = 1000 ether;
111 
112     // Basic price
113     uint256 public constant basicThreshold = 500 finney;
114 
115     uint public constant basicTokensPerEth = 1500;
116 
117     // Advanced price
118     uint256 public constant advancedThreshold = 5 ether;
119 
120     uint public constant advancedTokensPerEth = 2250;
121 
122     // Expert price
123     uint256 public constant expertThreshold = 100 ether;
124 
125     uint public constant expertTokensPerEth = 3000;
126 
127     // As we have different prices for different amounts,
128     // we keep a mapping of contributions to make refund
129     mapping (address => uint256) public etherContributions;
130 
131     // Max balance of the contract
132     uint256 public etherCollected;
133 
134     // Address to withdraw ether to
135     address public beneficiary;
136 
137     uint public startAtBlock;
138 
139     uint public endAtBlock;
140 
141     // All tokens are sold
142     event GoalReached(uint amountRaised);
143 
144     // Minimal ether cap collected
145     event SoftCapReached(uint softCap);
146 
147     // New contribution received and tokens are issued
148     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
149 
150     // Ether is taken back
151     event Refunded(address indexed holder, uint256 amount);
152 
153     // If soft cap is reached, withdraw should be available
154     modifier softCapReached {
155         if (etherCollected < softCap) {
156             revert();
157         }
158         assert(etherCollected >= softCap);
159         _;
160     }
161 
162     // Allow contribution only during presale
163     modifier duringPresale {
164         if (block.number < startAtBlock || block.number > endAtBlock || totalSupply >= SUPPLY_LIMIT) {
165             revert();
166         }
167         assert(block.number >= startAtBlock && block.number <= endAtBlock && totalSupply < SUPPLY_LIMIT);
168         _;
169     }
170 
171     // Allow withdraw only during refund
172     modifier duringRefund {
173         if(block.number <= endAtBlock || etherCollected >= softCap || this.balance == 0) {
174             revert();
175         }
176         assert(block.number > endAtBlock && etherCollected < softCap && this.balance > 0);
177         _;
178     }
179 
180     function FluencePreSale(uint _startAtBlock, uint _endAtBlock, uint softCapInEther){
181         require(_startAtBlock > 0 && _endAtBlock > 0);
182         beneficiary = msg.sender;
183         startAtBlock = _startAtBlock;
184         endAtBlock = _endAtBlock;
185         softCap = softCapInEther * 1 ether;
186     }
187 
188     // Change beneficiary address
189     function setBeneficiary(address to) onlyOwner external {
190         require(to != address(0));
191         beneficiary = to;
192     }
193 
194     // Withdraw contract's balance to beneficiary account
195     function withdraw() onlyOwner softCapReached external {
196         require(this.balance > 0);
197         beneficiary.transfer(this.balance);
198     }
199 
200     // Process contribution, issue tokens to user
201     function contribute(address _address) private stopInEmergency duringPresale {
202         if(msg.value < basicThreshold && owner != _address) {
203             revert();
204         }
205         assert(msg.value >= basicThreshold || owner == _address);
206         // Minimal contribution
207 
208         uint256 tokensToIssue;
209 
210         if (msg.value >= expertThreshold) {
211             tokensToIssue = safeMult(msg.value, expertTokensPerEth);
212         }
213         else if (msg.value >= advancedThreshold) {
214             tokensToIssue = safeMult(msg.value, advancedTokensPerEth);
215         }
216         else {
217             tokensToIssue = safeMult(msg.value, basicTokensPerEth);
218         }
219 
220         assert(tokensToIssue > 0);
221 
222         totalSupply = safeAdd(totalSupply, tokensToIssue);
223 
224         // Goal is already reached, can't issue any more tokens
225         if(totalSupply > SUPPLY_LIMIT) {
226             revert();
227         }
228         assert(totalSupply <= SUPPLY_LIMIT);
229 
230         // Saving ether contributions for the case of refund
231         etherContributions[_address] = safeAdd(etherContributions[_address], msg.value);
232 
233         // Track ether before adding current contribution to notice the event of reaching soft cap
234         uint collectedBefore = etherCollected;
235         etherCollected = safeAdd(etherCollected, msg.value);
236 
237         // Tokens are issued
238         balanceOf[_address] = safeAdd(balanceOf[_address], tokensToIssue);
239 
240         NewContribution(_address, tokensToIssue, msg.value);
241 
242         if (totalSupply == SUPPLY_LIMIT) {
243             GoalReached(etherCollected);
244         }
245         if (etherCollected >= softCap && collectedBefore < softCap) {
246             SoftCapReached(etherCollected);
247         }
248     }
249 
250     function() external payable {
251         contribute(msg.sender);
252     }
253 
254     function refund() stopInEmergency duringRefund external {
255         uint tokensToBurn = balanceOf[msg.sender];
256 
257 
258         // Sender must have tokens
259         require(tokensToBurn > 0);
260 
261         // Burn
262         balanceOf[msg.sender] = 0;
263 
264         // User contribution amount
265         uint amount = etherContributions[msg.sender];
266 
267         // Amount must be positive -- refund is not processed yet
268         assert(amount > 0);
269 
270         etherContributions[msg.sender] = 0;
271         // Clear state
272 
273         // Reduce counters
274         etherCollected = safeSubtract(etherCollected, amount);
275         totalSupply = safeSubtract(totalSupply, tokensToBurn);
276 
277         // Process refund. In case of error, it will be thrown
278         msg.sender.transfer(amount);
279 
280         Refunded(msg.sender, amount);
281     }
282 
283 
284 }