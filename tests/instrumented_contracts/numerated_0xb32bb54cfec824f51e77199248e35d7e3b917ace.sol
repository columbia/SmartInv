1 pragma solidity ^0.4.25;
2 
3 //LIBRARIES
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9           return 0;
10         }
11         uint256 c = a * b;
12         require(c / a == b, "the SafeMath multiplication check failed");
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     	require(b > 0, "the SafeMath division check failed");
18         uint256 c = a / b;
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "the SafeMath subtraction check failed");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "the SafeMath addition check failed");
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34 	    require(b != 0, "the SafeMath modulo check failed");
35 	    return a % b;
36 	 }
37 }
38 
39 //CONTRACT INTERFACE
40 
41 contract OneHundredthMonkey {
42 	function adminWithdraw() public {}
43 }
44 
45 //MAIN CONTRACT
46 
47 contract FoundationFund {
48 
49 	using SafeMath for uint256;
50 
51 	//CONSTANTS
52 
53 	uint256 public fundsReceived;
54 	address public masterAdmin;
55 	address public mainContract;
56 	bool public mainContractSet = false;
57 
58 	address public teamMemberA = 0x2597afE84661669E590016E51f8FB0059D1Ad63e;   
59 	address public teamMemberB = 0x2E6C1b2B4F7307dc588c289C9150deEB1A66b73d;
60 	address public teamMemberC = 0xB3CaC7157d772A7685824309Dc1eB79497839795;
61 	address public teamMemberD = 0x87395d203B35834F79B46cd16313E6027AE4c9D4;
62 
63 	uint256 public teamMemberArate = 30; //30%
64 	uint256 public teamMemberBrate = 30; //30%
65 	uint256 public teamMemberCrate = 20; //20% 
66 	uint256 public teamMemberDrate = 20; //20% 
67 
68 	mapping (address => uint256) public teamMemberTotal;
69 	mapping (address => uint256) public teamMemberUnclaimed;
70 	mapping (address => uint256) public teamMemberClaimed;
71 	mapping (address => bool) public validTeamMember;
72 	mapping (address => bool) public isProposedAddress;
73 	mapping (address => bool) public isProposing;
74 	mapping (address => uint256) public proposingAddressIndex;
75 
76 	//CONSTRUCTOR
77 
78 	constructor() public {
79 		masterAdmin = msg.sender;
80 		validTeamMember[teamMemberA] = true;
81 		validTeamMember[teamMemberB] = true;
82 		validTeamMember[teamMemberC] = true;
83 		validTeamMember[teamMemberD] = true;
84 	}
85 
86 	//MODIFIERS
87 	
88 	modifier isTeamMember() { 
89 		require (validTeamMember[msg.sender] == true, "you are not a team member"); 
90 		_; 
91 	}
92 
93 	modifier isMainContractSet() { 
94 		require (mainContractSet == true, "the main contract is not yet set"); 
95 		_; 
96 	}
97 
98 	modifier onlyHumans() { 
99         require (msg.sender == tx.origin, "no contracts allowed"); 
100         _; 
101     }
102 
103 	//EVENTS
104 	event fundsIn(
105 		uint256 _amount,
106 		address _sender,
107 		uint256 _totalFundsReceived
108 	);
109 
110 	event fundsOut(
111 		uint256 _amount,
112 		address _receiver
113 	);
114 
115 	event addressChangeProposed(
116 		address _old,
117 		address _new
118 	);
119 
120 	event addressChangeRemoved(
121 		address _old,
122 		address _new
123 	);
124 
125 	event addressChanged(
126 		address _old,
127 		address _new
128 	);
129 
130 	//FUNCTIONS
131 
132 	//add main contract address 
133 	function setContractAddress(address _address) external onlyHumans() {
134 		require (msg.sender == masterAdmin);
135 		require (mainContractSet == false);
136 		mainContract = _address;
137 		mainContractSet = true;
138 	}
139 
140 	//withdrawProxy
141 	function withdrawProxy() external isTeamMember() isMainContractSet() onlyHumans() {
142 		OneHundredthMonkey o = OneHundredthMonkey(mainContract);
143 		o.adminWithdraw();
144 	}
145 
146 	//team member withdraw
147 	function teamWithdraw() external isTeamMember() isMainContractSet() onlyHumans() {
148 	
149 		//set up for msg.sender
150 		address user;
151 		uint256 rate;
152 		if (msg.sender == teamMemberA) {
153 			user = teamMemberA;
154 			rate = teamMemberArate;
155 		} else if (msg.sender == teamMemberB) {
156 			user = teamMemberB;
157 			rate = teamMemberBrate;
158 		} else if (msg.sender == teamMemberC) {
159 			user = teamMemberC;
160 			rate = teamMemberCrate;
161 		} else if (msg.sender == teamMemberD) {
162 			user = teamMemberD;
163 			rate = teamMemberDrate;
164 		}
165 		
166 		//update accounting 
167 		uint256 teamMemberShare = fundsReceived.mul(rate).div(100);
168 		teamMemberTotal[user] = teamMemberShare;
169 		teamMemberUnclaimed[user] = teamMemberTotal[user].sub(teamMemberClaimed[user]);
170 		
171 		//safe transfer 
172 		uint256 toTransfer = teamMemberUnclaimed[user];
173 		teamMemberUnclaimed[user] = 0;
174 		teamMemberClaimed[user] = teamMemberTotal[user];
175 		user.transfer(toTransfer);
176 
177 		emit fundsOut(toTransfer, user);
178 	}
179 
180 	function proposeNewAddress(address _new) external isTeamMember() onlyHumans() {
181 		require (isProposedAddress[_new] == false, "this address cannot be proposed more than once");
182 		require (isProposing[msg.sender] == false, "you can only propose one address at a time");
183 
184 		isProposing[msg.sender] = true;
185 		isProposedAddress[_new] = true;
186 
187 		if (msg.sender == teamMemberA) {
188 			proposingAddressIndex[_new] = 0;
189 		} else if (msg.sender == teamMemberB) {
190 			proposingAddressIndex[_new] = 1;
191 		} else if (msg.sender == teamMemberC) {
192 			proposingAddressIndex[_new] = 2;
193 		} else if (msg.sender == teamMemberD) {
194 			proposingAddressIndex[_new] = 3;
195 		}
196 
197 		emit addressChangeProposed(msg.sender, _new);
198 	}
199 
200 	function removeProposal(address _new) external isTeamMember() onlyHumans() {
201 		require (isProposedAddress[_new] == true, "this address must be proposed but not yet accepted");
202 		require (isProposing[msg.sender] == true, "your address must be actively proposing");
203 
204 		if (proposingAddressIndex[_new] == 0 && msg.sender == teamMemberA) {
205 			isProposedAddress[_new] = false;
206 			isProposing[msg.sender] = false;
207 		} else if (proposingAddressIndex[_new] == 1 && msg.sender == teamMemberB) {
208 			isProposedAddress[_new] = false;
209 			isProposing[msg.sender] = false;
210 		} else if (proposingAddressIndex[_new] == 2 && msg.sender == teamMemberC) {
211 			isProposedAddress[_new] = false;
212 			isProposing[msg.sender] = false;
213 		} else if (proposingAddressIndex[_new] == 3 && msg.sender == teamMemberD) {
214 			isProposedAddress[_new] = false;
215 			isProposing[msg.sender] = false;
216 		} 
217 
218 		emit addressChangeRemoved(msg.sender, _new);
219 	}
220 
221 	function acceptProposal() external onlyHumans() {
222 		require (isProposedAddress[msg.sender] == true, "your address must be proposed");
223 		
224 		if (proposingAddressIndex[msg.sender] == 0) {
225 			address old = teamMemberA;
226 			validTeamMember[old] = false;
227 			isProposing[old] = false;
228 			teamMemberA = msg.sender;
229 			validTeamMember[teamMemberA] = true;
230 		} else if (proposingAddressIndex[msg.sender] == 1) {
231 			old = teamMemberB;
232 			validTeamMember[old] = false;
233 			isProposing[old] = false;
234 			teamMemberB = msg.sender;
235 			validTeamMember[teamMemberB] = true;
236 		} else if (proposingAddressIndex[msg.sender] == 2) {
237 			old = teamMemberC;
238 			validTeamMember[old] = false;
239 			isProposing[old] = false;
240 			teamMemberC = msg.sender;
241 			validTeamMember[teamMemberC] = true;
242 		} else if (proposingAddressIndex[msg.sender] == 3) {
243 			old = teamMemberD;
244 			validTeamMember[old] = false;
245 			isProposing[old] = false;
246 			teamMemberD = msg.sender;
247 			validTeamMember[teamMemberD] = true;
248 		} 
249 
250 		isProposedAddress[msg.sender] = false;
251 
252 		emit addressChanged(old, msg.sender);
253 	}
254 
255 	//VIEW FUNCTIONS
256 
257 	function balanceOf(address _user) public view returns(uint256 _balance) {
258 		address user;
259 		uint256 rate;
260 		if (_user == teamMemberA) {
261 			user = teamMemberA;
262 			rate = teamMemberArate;
263 		} else if (_user == teamMemberB) {
264 			user = teamMemberB;
265 			rate = teamMemberBrate;
266 		} else if (_user == teamMemberC) {
267 			user = teamMemberC;
268 			rate = teamMemberCrate;
269 		} else if (_user == teamMemberD) {
270 			user = teamMemberD;
271 			rate = teamMemberDrate;
272 		} else {
273 			return 0;
274 		}
275 
276 		uint256 teamMemberShare = fundsReceived.mul(rate).div(100);
277 		uint256 unclaimed = teamMemberShare.sub(teamMemberClaimed[_user]); 
278 
279 		return unclaimed;
280 	}
281 
282 	function contractBalance() public view returns(uint256 _contractBalance) {
283 	    return address(this).balance;
284 	}
285 
286 	//FALLBACK
287 
288 	function () public payable {
289 		fundsReceived += msg.value;
290 		emit fundsIn(msg.value, msg.sender, fundsReceived); 
291 	}
292 }