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
29 	event Approval(address indexed owner, address indexed spender, uint256 value);
30 	event Transfer(address indexed from, address indexed to, uint256 value);
31 
32 	string public name;
33 	string public symbol;
34 	uint8 public decimals;
35 
36 	function totalSupply() public view returns (uint256);
37 	function transfer(address to, uint256 value) public returns (bool);
38 	function transferFrom(address from, address to, uint256 value) public returns (bool);
39 	function approve(address spender, uint256 value) public returns (bool);
40 	function balanceOf(address who) public view returns (uint256);
41 	function allowance(address owner, address spender) public view returns (uint256);
42 }
43 
44 contract SimpleICO {
45 	using SafeMath for uint256;
46 	
47 	address internal owner;
48 	uint256 public startTime;
49 	uint256 public endTime;
50 	
51 	//0 - Initial State
52 	//1 - Contribution State
53 	//2 - Final State
54 	uint256 public state;
55 
56 	mapping (address => bool) internal contributionKYC;
57 
58 	mapping (address => uint256) internal originalContributed;
59 	mapping (address => uint256) internal adjustedContributed;
60 	uint256 public amountRaised; //Value strictly increases and tracks total raised.
61 	uint256 public adjustedRaised;
62 	uint256 public currentRate;
63 
64 	uint256 public amountRemaining; //Amount that can be withdrawn.
65 	uint256 public nextCheckpoint; //Next blocktime that funds can be released.
66 	uint256 public tenthTotal;
67 
68 	event KYCApproved(address indexed who, address indexed admin);
69 	event KYCRemoved(address indexed who, address indexed admin);
70 
71 	event RateDecreased(uint256 indexed when, uint256 newRate);
72 	event ContributionReceived(address indexed from, uint256 amount, uint256 soFar);
73 
74 	event EtherReleased(uint256 time, uint256 amount);
75 	event EtherWithdrawn(address indexed by, uint256 amount, uint256 remaining);
76 
77 	function SimpleICO() public {
78 		owner = msg.sender;
79 		startTime = 0;
80 		endTime = 0;
81 		state = 0;
82 
83 		amountRaised = 0 ether;
84 		adjustedRaised = 0 ether;
85 		currentRate = 4;
86 
87 		amountRemaining = 0 ether;
88 		nextCheckpoint = 0;
89 		tenthTotal = 0 ether;
90 
91 	}
92 
93 	modifier onlyOwner() {
94 		require(msg.sender == owner);
95 		_;
96 	}
97 	
98 	modifier stillRunning() {
99 		require(state == 1);
100 		require(now <= endTime);
101 		_;
102 	}
103 	
104 	modifier canEnd() {
105 		require(state == 1);
106 		require(now > endTime || amountRaised >= 500 ether);
107 		_;
108 	}
109 
110 	modifier allowKYC(address addr) {
111 		if (!contributionKYC[addr]) {
112 			uint256 total = originalContributed[msg.sender].add(msg.value);
113 			require(total < .1 ether);
114 		}
115 	
116 		_;
117 	}
118 	
119 	function isApproved(address addr) external view returns (bool) {
120 		return contributionKYC[addr];
121 	}
122 	
123 	function approveKYC(address addr) external onlyOwner {
124 		require(!contributionKYC[addr]);
125 		contributionKYC[addr] = true;
126 	
127 		emit KYCApproved(addr, msg.sender);
128 	}
129 	
130 	function removeKYC(address addr) external onlyOwner {
131 		require(contributionKYC[addr]);
132 		require(originalContributed[addr] < .1 ether);
133 		contributionKYC[addr] = false;
134 	
135 		emit KYCRemoved(addr, msg.sender);
136 	}
137 
138 	function contribute() external allowKYC(msg.sender) stillRunning payable {
139 		uint256 total = originalContributed[msg.sender].add(msg.value);
140 		uint256 adjusted = msg.value.mul(currentRate);
141 		uint256 adjustedTotal = adjustedContributed[msg.sender].add(adjusted);
142 	
143 		originalContributed[msg.sender] = total;
144 		adjustedContributed[msg.sender] = adjustedTotal;
145 	
146 		amountRaised = amountRaised.add(msg.value);
147 		adjustedRaised = adjustedRaised.add(adjusted);
148 		emit ContributionReceived(msg.sender, msg.value, total);
149 	
150 		if (currentRate == 4 && now > (startTime.add(2 weeks))) {
151 			currentRate = 2;
152 			emit RateDecreased(now, currentRate);
153 		}
154 	}
155 	
156 	function getAmountContributed(address addr) external view returns (uint256 amount) {
157 		return originalContributed[addr];
158 	}
159 	
160 	function getAdjustedContribution(address addr) external view returns (uint256 amount) {
161 		return adjustedContributed[addr];
162 	}
163 
164 	function startContribution() external onlyOwner {
165 		require(state == 0);
166 		state = 1;
167 		startTime = now;
168 		endTime = now + 4 weeks;
169 	}
170 	
171 	function endContribution() external canEnd onlyOwner { //Require state 1 is in canEnd
172 		tenthTotal = amountRaised.div(10);
173 		amountRemaining = tenthTotal.mul(5);
174 		nextCheckpoint = now + 1 weeks;
175 	
176 		state = 2;
177 		emit EtherReleased(now, tenthTotal.mul(5));
178 	}
179 	
180 	function withdrawToWallet(uint256 amount) external onlyOwner {
181 		require(state == 2);
182 		require(amount <= amountRemaining);
183 	
184 		if (now > nextCheckpoint) {
185 			amountRemaining = amountRemaining.add(tenthTotal);
186 			nextCheckpoint = now + 1 weeks;
187 	
188 			emit EtherReleased(now, tenthTotal);
189 		}
190 	
191 		amountRemaining = amountRemaining.sub(amount);
192 		msg.sender.transfer(amount);
193 		emit EtherWithdrawn(msg.sender, amount, amountRemaining);
194 	}
195 	
196 	function retrieveAssets(address which) external onlyOwner {
197 		require(which != address(this));
198 	
199 		ERC20Base token = ERC20Base(which);
200 		uint256 amount = token.balanceOf(address(this));
201 		require(token.transfer(msg.sender, amount));
202 	}
203 
204 }