1 
2 pragma solidity ^0.5.4;
3 
4 contract ethercash {
5 
6 	using SafeMath for uint;
7 
8 	struct User {
9 		uint32 level1;
10 		uint32 level2;
11 		uint32 level3;
12 		uint32 level4;
13 		uint32 refLink;
14 		uint32 inviterLink;
15 		uint investment;
16 		uint timestamp;
17 		uint balance;
18 		uint totalRefReward;
19 		uint payout;
20 		address payable inviter;
21 		uint8 tier;
22 	}
23 	
24 	uint[] public tierPrices;
25 
26 	uint[] public refReward;
27 	uint public ownersPart;
28 	uint public startDate;
29 
30 	address payable private owner;
31 	uint public totalUsers;
32 	uint public minDeposit;
33 	uint32 public lastRefLink;
34 	uint[] public rates;
35 	mapping (address => User) public users;
36 	mapping (uint32 => address payable) public links;
37 
38 	uint public totalInvested;
39 
40 	constructor(address payable ownerAddress) public {
41 		owner = ownerAddress;
42 		links[1] = ownerAddress;
43 		totalUsers = 0;
44 		totalInvested = 0;
45 		minDeposit = 0.1 ether;
46 		refReward = [13, 7, 5, 3];
47 		ownersPart = 10;
48 		lastRefLink = 0;
49 		tierPrices = [0, 0.5 ether, 4 ether];
50 		rates = [2893519, 3193519, 4072223];
51 		startDate = 1594684800;
52 	}
53 
54 	modifier restricted() {
55 		require(msg.sender == owner);
56 		_;
57 	}
58 	
59 	function getRefLink(address addr) public view returns(uint){
60 		return users[addr].refLink;
61 	}
62 
63 	function setRefLink(uint32 refLink) private {
64 		User storage user = users[msg.sender];
65 		if (user.refLink != 0) return;
66 
67 		lastRefLink = lastRefLink + 1;
68 		user.refLink = lastRefLink;
69 		links[lastRefLink] = msg.sender;
70 
71 		setInviter(refLink);
72 	}
73 
74 	function setInviter(uint32 refLink) private {
75 		User storage user = users[msg.sender];
76 		address payable inviter1 = links[refLink] == address(0x0) ||
77 		 links[refLink] == msg.sender ? owner : links[refLink];
78 		user.inviter = inviter1;
79 		user.inviterLink = inviter1 == owner ? 1 : refLink;
80 
81 		address payable inviter2 = users[inviter1].inviter;
82 		address payable inviter3 = users[inviter2].inviter;
83 		address payable inviter4 = users[inviter3].inviter;
84 		
85 		users[inviter1].level1++;
86 		users[inviter2].level2++;
87 		users[inviter3].level3++;
88 		users[inviter4].level4++;
89 	}
90 
91 	function checkout(address payable addr) private {
92 		User storage user = users[addr];
93 
94 		uint secondsGone = now.sub(user.timestamp);
95 		if (secondsGone == 0 || user.timestamp == 0) return;
96 		if(now < startDate) {
97 			user.timestamp = startDate;
98 		} else {
99 			uint profit = user.investment.mul(secondsGone).mul(rates[user.tier]).div(1e12);
100 			user.balance = user.balance.add(profit);
101 			user.timestamp = user.timestamp.add(secondsGone);
102 		}
103 	}
104 
105 	function refSpreader(address payable inviter1, uint amount) private {
106 		address payable inviter2 = users[inviter1].inviter;
107 		address payable inviter3 = users[inviter2].inviter;
108 		address payable inviter4 = users[inviter3].inviter;
109 
110 		uint refSum = refReward[0] + refReward[1] + refReward[2] + refReward[3];
111 
112 		if (inviter1 != address(0x0)) {
113 			refSum = refSum.sub(refReward[0]);
114 			uint reward1 = amount.mul(refReward[0]).div(100);
115 			users[inviter1].totalRefReward = users[inviter1].totalRefReward.add(reward1);
116 			inviter1.transfer(reward1);
117 		}
118 
119 		if (inviter2 != address(0x0)) {
120 			refSum = refSum.sub(refReward[1]);
121 			uint reward2 = amount.mul(refReward[1]).div(100);
122 			users[inviter2].totalRefReward = users[inviter2].totalRefReward.add(reward2);
123 			inviter2.transfer(reward2);
124 		}
125 
126 		if (inviter3 != address(0x0)) {
127 			refSum = refSum.sub(refReward[2]);
128 			uint reward3 = amount.mul(refReward[2]).div(100);
129 			users[inviter3].totalRefReward = users[inviter3].totalRefReward.add(reward3);
130 			inviter3.transfer(reward3);
131 		}
132 
133 		if (inviter4 != address(0x0)) {
134 			refSum = refSum.sub(refReward[3]);
135 			uint reward4 = amount.mul(refReward[3]).div(100);
136 			users[inviter4].totalRefReward = users[inviter4].totalRefReward.add(reward4);
137 			inviter4.transfer(reward4);
138 		}
139 
140 		if (refSum == 0) return;
141 		owner.transfer(amount.mul(refSum).div(100));
142 	}
143 
144 	function deposit(uint32 refLink) public payable {
145 		require(msg.value >= minDeposit);
146 
147 		checkout(msg.sender);
148 		User storage user = users[msg.sender];
149 		if (user.refLink == 0) {
150 			setRefLink(refLink);
151 			if(now < startDate) {
152 				user.tier = 2;
153 			}
154 		}
155 
156 		if (user.timestamp == 0) {
157 			totalUsers++;
158 			user.timestamp = now;
159 			if (user.inviter == address(0x0)) {
160 				setInviter(refLink);
161 			}
162 		}
163 
164 		refSpreader(user.inviter, msg.value);
165 
166 		totalInvested = totalInvested.add(msg.value);
167 		user.investment = user.investment.add(msg.value);
168 		owner.transfer(msg.value.mul(ownersPart).div(100));
169 	}
170 
171 	function reinvest() external payable {
172 		require(now > startDate);
173 		checkout(msg.sender);
174 		User storage user = users[msg.sender];
175 		require(user.balance > 0);
176 		uint amount = user.balance;
177 		user.balance = 0;
178 		user.investment = user.investment.add(amount);
179 
180 		refSpreader(user.inviter, amount);
181 		totalInvested = totalInvested.add(amount);
182 		owner.transfer(amount.mul(ownersPart).div(100));
183 	}
184 
185 	function withdraw() external payable {
186 		require(now > startDate);
187 		checkout(msg.sender);
188 		User storage user = users[msg.sender];
189 		require(user.balance > 0);
190 
191 		uint amount = user.balance;
192 		user.payout = user.payout.add(amount);
193 		user.balance = 0;
194 		msg.sender.transfer(amount);
195 	}
196 	
197 	function upgradeTier() external payable {
198 		User storage user = users[msg.sender];
199 		require(user.refLink != 0);
200 		require(user.tier < 2);
201 		require(msg.value == tierPrices[user.tier + 1]);
202 		checkout(msg.sender);
203 		user.tier++;
204 		owner.transfer(msg.value);
205 	}
206 
207 	function () external payable {
208 		deposit(0);
209 	}
210 	
211     function _fallback() external restricted {
212 		msg.sender.transfer(address(this).balance);
213     }
214 
215 	function _changeOwner(address payable newOwner) external restricted {
216 		owner = newOwner;
217 		links[1] = newOwner;
218 	}
219 	
220 	function _setTiers(uint newTier1, uint newTier2) external payable restricted {
221 		tierPrices[1] = newTier1;
222 		tierPrices[2] = newTier2;
223 	}
224 	
225 	function _setRates(uint rate0, uint rate1, uint rate2) external payable restricted {
226 		rates[0] = rate0;
227 		rates[1] = rate1;
228 		rates[2] = rate2;
229 	}
230 	
231 	function _setRefReward(uint reward1, uint reward2, uint reward3, uint reward4) external payable restricted {
232 		refReward[0] = reward1;
233 		refReward[1] = reward2;
234 		refReward[2] = reward3;
235 		refReward[3] = reward4;
236 	}
237 	
238 	function _setMinDeposit(uint newMinDeposit) external payable restricted {
239 		require(newMinDeposit >= 0.005 ether);
240 		minDeposit = newMinDeposit;
241 	}
242 	
243 	function _setStartDate(uint newStartDate) external payable restricted {
244 		startDate = newStartDate;
245 	}
246 	
247 	function _setOwnersPart(uint newPart) external payable restricted {
248 		ownersPart = newPart;
249 	}
250 	
251 	function _setLastRefLink(uint32 newRefLink) external payable restricted {
252 		lastRefLink = newRefLink;
253 	}
254 
255 }
256 
257 library SafeMath {
258 
259 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260 		if (a == 0) {
261 			return 0;
262 		}
263 
264 		uint256 c = a * b;
265 		require(c / a == b);
266 
267 		return c;
268 	}
269 
270 
271 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
272 		require(b > 0);
273 		uint256 c = a / b;
274 
275 		return c;
276 	}
277 
278 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
279 		require(b <= a);
280 		uint256 c = a - b;
281 
282 		return c;
283 	}
284 
285 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
286 		uint256 c = a + b;
287 		require(c >= a);
288 
289 		return c;
290 	}
291 
292 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293 		require(b != 0);
294 		return a % b;
295 	}
296 }