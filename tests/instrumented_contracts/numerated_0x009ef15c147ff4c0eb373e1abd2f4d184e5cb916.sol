1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         assert(b != 0);
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract ERC20Base {
29 	uint public totalSupply;
30 
31 	event Transfer(address indexed from, address indexed to, uint value);
32 	event Approval(address indexed owner, address indexed spender, uint value);
33 
34 	function balanceOf(address who) public view returns (uint);
35   	function transfer(address to, uint value) public returns (bool);
36   	function allowance(address owner, address spender) public view returns (uint);
37   	function transferFrom(address from, address to, uint value) public returns (bool);
38   	function approve(address spender, uint value) public returns (bool);
39 }
40 
41 contract CampaignContract {
42 	using SafeMath for uint256;
43 	
44 	address internal owner;
45 	
46 	//Limits are recorded as USD in ether units (1 ether = 1 USD) [this is units not actual price]
47 	uint256 public minUSD;
48 	uint256 public maxUSD;
49 	uint256 public maxContribution;
50 	uint256 public minContribution;
51 
52 	struct KYCObject {
53 		bytes32 phone;
54 		bytes32 name;
55 		bytes32 occupation;
56 		bytes32 addressOne;
57 		bytes32 addressTwo;
58 	}
59 	
60 	mapping (address => KYCObject) internal contributionKYC;
61 
62 	mapping (address => uint256) internal amountAttempted;
63 	mapping (address => uint256) internal amountContributed;
64 
65 	uint256 public amountRaised; //Value strictly increases and tracks total raised.
66 	uint256 public amountRemaining; //Value represents amount that can be withdrawn.
67 
68 	event OwnerChanged(address indexed from, address indexed to);
69 	event LimitsChanged(uint256 indexed newMin, uint256 indexed newMax, uint256 indexed price);
70 
71 	event KYCSubmitted(address indexed who, bytes32 phone, bytes32 name, bytes32 occupation, bytes32 addrOne, bytes32 addrTwo);
72 
73 	event ContributionReceived(address indexed from, uint256 amount);
74 	event ContributionWithdrawn(address indexed from, uint256 amount);
75 
76 	event KYCReset(address indexed by, address indexed who);
77 	event ContributionIncrease(uint256 indexed time, uint256 amount);
78 	event ContributionAccepted(address indexed from, uint256 amount, uint256 total);
79 	event ContributionReturned(address indexed from, uint256 amount);
80 	
81 	event EtherWithdrawn(address indexed by, uint256 amount, uint256 remaining);
82 
83 	function CampaignContract() public {
84 		owner = msg.sender;
85 		
86 		minUSD = 1 ether;
87 		maxUSD = 950 ether;
88 		minContribution = .1 ether;
89 		maxContribution = 1 ether;
90 
91 		amountRaised = 0 ether;
92 		amountRemaining = 0 ether;
93 
94 	}
95 
96 	modifier onlyOwner() {
97 		require(msg.sender == owner);
98 		_;
99 	}
100 	
101 	function changeOwner(address addr) external onlyOwner {
102 		require(addr != address(0));
103 		owner = addr;
104 	
105 		emit OwnerChanged(msg.sender, addr);
106 	}
107 	
108 	function changeLimits(uint256 price) external onlyOwner {
109 		uint256 adjPrice = price.div(10**9);
110 		uint256 adjMin = minUSD.mul(10**9);
111 		uint256 adjMax = maxUSD.mul(10**9);
112 	
113 		maxContribution = adjMax.div(adjPrice);
114 		minContribution = adjMin.div(adjPrice);
115 	
116 		emit LimitsChanged(minContribution, maxContribution, price);
117 	}
118 
119 	modifier hasKYCInfo(address addr) {
120 		require(contributionKYC[addr].phone != "");
121 		require(contributionKYC[addr].name != "");
122 		_;
123 	}
124 	
125 	function verifyKYC(bytes32 phone, bytes32 name, bytes32 occupation, bytes32 addrOne, bytes32 addrTwo) external {
126 		require(contributionKYC[msg.sender].phone == "");
127 		require(contributionKYC[msg.sender].name == "");
128 		require(phone != "");
129 		require(name != "");
130 		require(occupation != "");
131 		require(addrOne != "");
132 		require(addrTwo != "");
133 	
134 		contributionKYC[msg.sender].phone = phone;
135 		contributionKYC[msg.sender].name = name;
136 		contributionKYC[msg.sender].occupation = occupation;
137 		contributionKYC[msg.sender].addressOne = addrOne;
138 		contributionKYC[msg.sender].addressTwo = addrTwo;
139 	
140 		emit KYCSubmitted(msg.sender, phone, name, occupation, addrOne, addrTwo);
141 	}
142 	
143 	function getPhone(address addr) external view returns (bytes32 result) {
144 		return contributionKYC[addr].phone;
145 	}
146 	
147 	function getName(address addr) external view returns (bytes32 result) {
148 		return contributionKYC[addr].name;
149 	}
150 	
151 	function getOccupation(address addr) external view returns (bytes32 result) {
152 		return contributionKYC[addr].occupation;
153 	}
154 	
155 	function getAddressOne(address addr) external view returns (bytes32 result) {
156 		return contributionKYC[addr].addressOne;
157 	}
158 	
159 	function getAddressTwo(address addr) external view returns (bytes32 result) {
160 		return contributionKYC[addr].addressTwo;
161 	}
162 
163 	function contribute() external hasKYCInfo(msg.sender) payable {
164 		//Make sure they're not attempting to submit more than max.
165 		uint256 finalAttempted = amountAttempted[msg.sender].add(msg.value);
166 		require(finalAttempted <= maxContribution);
167 	
168 		//Make sure the attempt added with the already submitted amount isn't more than max.
169 		uint256 finalAmount = amountContributed[msg.sender].add(finalAttempted);
170 		require(finalAmount >= minContribution);
171 		require(finalAmount <= maxContribution);
172 	
173 		amountAttempted[msg.sender] = finalAttempted;
174 		emit ContributionReceived(msg.sender, msg.value);
175 	}
176 	
177 	function withdrawContribution() external hasKYCInfo(msg.sender) {
178 		require(amountAttempted[msg.sender] > 0);
179 		uint256 amount = amountAttempted[msg.sender];
180 		amountAttempted[msg.sender] = 0;
181 	
182 		msg.sender.transfer(amount);
183 		emit ContributionWithdrawn(msg.sender, amount);
184 	}
185 	
186 	function getAmountAttempted(address addr) external view returns (uint256 amount) {
187 		return amountAttempted[addr];
188 	}
189 	
190 	function getAmountContributed(address addr) external view returns (uint256 amount) {
191 		return amountContributed[addr];
192 	}
193 	
194 	function getPotentialAmount(address addr) external view returns (uint256 amount) {
195 		return amountAttempted[addr].add(amountContributed[addr]);
196 	}
197 
198 	function resetKYC(address addr) external onlyOwner hasKYCInfo(addr) {
199 		//Cant reset KYC for someone who you've accepted from already.
200 		require(amountContributed[addr] == 0);
201 	
202 		//Someone having their KYC reset must have withdrawn their attempts.
203 		require(amountAttempted[addr] == 0);
204 	
205 		contributionKYC[addr].phone = "";
206 		contributionKYC[addr].name = "";
207 		contributionKYC[addr].occupation = "";
208 		contributionKYC[addr].addressOne = "";
209 		contributionKYC[addr].addressTwo = "";
210 	
211 		emit KYCReset(msg.sender, addr);
212 	}
213 	
214 	function acceptContribution(address addr) external onlyOwner hasKYCInfo(addr) {
215 		require(amountAttempted[addr] >= minContribution);
216 		require(amountContributed[addr].add(amountAttempted[addr]) <= maxContribution);
217 	
218 		uint256 amount = amountAttempted[addr];
219 		amountAttempted[addr] = 0;
220 		amountContributed[addr] = amountContributed[addr].add(amount);
221 		amountRaised = amountRaised.add(amount);
222 		amountRemaining = amountRemaining.add(amount);
223 	
224 		emit ContributionIncrease(now, amountRaised);
225 		emit ContributionAccepted(addr, amount, amountContributed[addr]);
226 	}
227 	
228 	function rejectContribution(address addr) external onlyOwner {
229 		require(amountAttempted[addr] > 0);
230 	
231 		uint256 amount = amountAttempted[addr];
232 		amountAttempted[addr] = 0;
233 	
234 		addr.transfer(amount);
235 		emit ContributionReturned(addr, amount);
236 	}
237 	
238 	function withdrawToWallet(uint256 amount) external onlyOwner {
239 		require(amount <= amountRemaining);
240 	
241 		amountRemaining = amountRemaining.sub(amount);
242 		msg.sender.transfer(amount);
243 		emit EtherWithdrawn(msg.sender, amount, amountRemaining);
244 	}
245 	
246 	function retrieveAssets(address which) external onlyOwner {
247 		ERC20Base token = ERC20Base(which);
248 		uint256 amount = token.balanceOf(address(this));
249 		require(token.transfer(msg.sender, amount));
250 	}
251 	
252 	function killContract() external onlyOwner {
253 		selfdestruct(msg.sender);
254 	}
255 
256 }