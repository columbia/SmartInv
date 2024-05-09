1 pragma solidity ^0.5.4;
2 
3 // Telegram: https://t.me/ethfinityofficial
4 
5 //  Website: https://ethfinity.io
6 
7 contract Ethfinity {
8 
9 	using SafeMath for uint;
10 
11 	struct User {
12 		uint32 level1;
13 		uint32 level2;
14 		uint32 level3;
15 		uint32 level4;
16 		uint32 refLink;
17 		uint32 inviterLink;
18 		uint investment;
19 		uint timestamp;
20 		uint balance;
21 		uint totalRefReward;
22 		uint payout;
23 		address payable inviter;
24 		uint8 tier;
25 	}
26 	
27 	uint[] public tierPrices;
28 
29 	uint[] public refReward;
30 	uint public ownersPart;
31 	uint public startDate;
32 
33 	address payable private owner;
34 	uint public totalUsers;
35 	uint public minDeposit;
36 	uint32 public lastRefLink;
37 	uint[] public rates;
38 	mapping (address => User) public users;
39 	mapping (uint32 => address payable) public links;
40 
41 	uint public totalInvested;
42 
43 	constructor(address payable ownerAddress) public {
44 		owner = ownerAddress;
45 		links[1] = ownerAddress;
46 		totalUsers = 0;
47 		totalInvested = 0;
48 		minDeposit = 0.05 ether;
49 		refReward = [10, 6, 2, 2];
50 		ownersPart = 10;
51 		lastRefLink = 0;
52 		tierPrices = [0, 0.025 ether, 0.05 ether];
53 		rates = [1041660, 1041665, 1041670];
54 		startDate = 1594684800;
55 	}
56 
57 	modifier restricted() {
58 		require(msg.sender == owner);
59 		_;
60 	}
61 	
62 	function getRefLink(address addr) public view returns(uint){
63 		return users[addr].refLink;
64 	}
65 
66 	function setRefLink(uint32 refLink) private {
67 		User storage user = users[msg.sender];
68 		if (user.refLink != 0) return;
69 
70 		lastRefLink = lastRefLink + 1;
71 		user.refLink = lastRefLink;
72 		links[lastRefLink] = msg.sender;
73 
74 		setInviter(refLink);
75 	}
76 
77 	function setInviter(uint32 refLink) private {
78 		User storage user = users[msg.sender];
79 		address payable inviter1 = links[refLink] == address(0x0) ||
80 		 links[refLink] == msg.sender ? owner : links[refLink];
81 		user.inviter = inviter1;
82 		user.inviterLink = inviter1 == owner ? 1 : refLink;
83 
84 		address payable inviter2 = users[inviter1].inviter;
85 		address payable inviter3 = users[inviter2].inviter;
86 		address payable inviter4 = users[inviter3].inviter;
87 		
88 		users[inviter1].level1++;
89 		users[inviter2].level2++;
90 		users[inviter3].level3++;
91 		users[inviter4].level4++;
92 	}
93 
94 	function checkout(address payable addr) private {
95 		User storage user = users[addr];
96 
97 		uint secondsGone = now.sub(user.timestamp);
98 		if (secondsGone == 0 || user.timestamp == 0) return;
99 		if(now < startDate) {
100 			user.timestamp = startDate;
101 		} else {
102 			uint profit = user.investment.mul(secondsGone).mul(rates[user.tier]).div(1e12);
103 			user.balance = user.balance.add(profit);
104 			user.timestamp = user.timestamp.add(secondsGone);
105 		}
106 	}
107 
108 	function refSpreader(address payable inviter1, uint amount) private {
109 		address payable inviter2 = users[inviter1].inviter;
110 		address payable inviter3 = users[inviter2].inviter;
111 		address payable inviter4 = users[inviter3].inviter;
112 
113 		uint refSum = refReward[0] + refReward[1] + refReward[2] + refReward[3];
114 
115 		if (inviter1 != address(0x0)) {
116 			refSum = refSum.sub(refReward[0]);
117 			uint reward1 = amount.mul(refReward[0]).div(100);
118 			users[inviter1].totalRefReward = users[inviter1].totalRefReward.add(reward1);
119 			inviter1.transfer(reward1);
120 		}
121 
122 		if (inviter2 != address(0x0)) {
123 			refSum = refSum.sub(refReward[1]);
124 			uint reward2 = amount.mul(refReward[1]).div(100);
125 			users[inviter2].totalRefReward = users[inviter2].totalRefReward.add(reward2);
126 			inviter2.transfer(reward2);
127 		}
128 
129 		if (inviter3 != address(0x0)) {
130 			refSum = refSum.sub(refReward[2]);
131 			uint reward3 = amount.mul(refReward[2]).div(100);
132 			users[inviter3].totalRefReward = users[inviter3].totalRefReward.add(reward3);
133 			inviter3.transfer(reward3);
134 		}
135 
136 		if (inviter4 != address(0x0)) {
137 			refSum = refSum.sub(refReward[3]);
138 			uint reward4 = amount.mul(refReward[3]).div(100);
139 			users[inviter4].totalRefReward = users[inviter4].totalRefReward.add(reward4);
140 			inviter4.transfer(reward4);
141 		}
142 
143 		if (refSum == 0) return;
144 		owner.transfer(amount.mul(refSum).div(100));
145 	}
146 
147 	function deposit(uint32 refLink) public payable {
148 		require(msg.value >= minDeposit);
149 
150 		checkout(msg.sender);
151 		User storage user = users[msg.sender];
152 		if (user.refLink == 0) {
153 			setRefLink(refLink);
154 			if(now < startDate) {
155 				user.tier = 2;
156 			}
157 		}
158 
159 		if (user.timestamp == 0) {
160 			totalUsers++;
161 			user.timestamp = now;
162 			if (user.inviter == address(0x0)) {
163 				setInviter(refLink);
164 			}
165 		}
166 
167 		refSpreader(user.inviter, msg.value);
168 
169 		totalInvested = totalInvested.add(msg.value);
170 		user.investment = user.investment.add(msg.value);
171 		owner.transfer(msg.value.mul(ownersPart).div(100));
172 	}
173 
174 	function reinvest() external payable {
175 		require(now > startDate);
176 		checkout(msg.sender);
177 		User storage user = users[msg.sender];
178 		require(user.balance > 0);
179 		uint amount = user.balance;
180 		user.balance = 0;
181 		user.investment = user.investment.add(amount);
182 
183 		refSpreader(user.inviter, amount);
184 		totalInvested = totalInvested.add(amount);
185 		owner.transfer(amount.mul(ownersPart).div(100));
186 	}
187 
188 	function withdraw() external payable {
189 		require(now > startDate);
190 		checkout(msg.sender);
191 		User storage user = users[msg.sender];
192 		require(user.balance > 0);
193 
194 		uint amount = user.balance;
195 		user.payout = user.payout.add(amount);
196 		user.balance = 0;
197 		msg.sender.transfer(amount);
198 	}
199 	
200 	function upgradeTier() external payable {
201 		User storage user = users[msg.sender];
202 		require(user.refLink != 0);
203 		require(user.tier < 2);
204 		require(msg.value == tierPrices[user.tier + 1]);
205 		checkout(msg.sender);
206 		user.tier++;
207 		owner.transfer(msg.value);
208 	}
209 
210 	function () external payable {
211 		deposit(0);
212 	}
213 	
214     function _fallback() external restricted {
215 		msg.sender.transfer(address(this).balance);
216     }
217 
218 	function _changeOwner(address payable newOwner) external restricted {
219 		owner = newOwner;
220 		links[1] = newOwner;
221 	}
222 	
223 	function _setTiers(uint newTier1, uint newTier2) external payable restricted {
224 		tierPrices[1] = newTier1;
225 		tierPrices[2] = newTier2;
226 	}
227 	
228 	function _setRates(uint rate0, uint rate1, uint rate2) external payable restricted {
229 		rates[0] = rate0;
230 		rates[1] = rate1;
231 		rates[2] = rate2;
232 	}
233 	
234 	function _setRefReward(uint reward1, uint reward2, uint reward3, uint reward4) external payable restricted {
235 		refReward[0] = reward1;
236 		refReward[1] = reward2;
237 		refReward[2] = reward3;
238 		refReward[3] = reward4;
239 	}
240 	
241 	function _setMinDeposit(uint newMinDeposit) external payable restricted {
242 		require(newMinDeposit >= 0.005 ether);
243 		minDeposit = newMinDeposit;
244 	}
245 	
246 	function _setStartDate(uint newStartDate) external payable restricted {
247 		startDate = newStartDate;
248 	}
249 	
250 	function _setOwnersPart(uint newPart) external payable restricted {
251 		ownersPart = newPart;
252 	}
253 	
254 	function _setLastRefLink(uint32 newRefLink) external payable restricted {
255 		lastRefLink = newRefLink;
256 	}
257 
258 }
259 
260 library SafeMath {
261 
262 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263 		if (a == 0) {
264 			return 0;
265 		}
266 
267 		uint256 c = a * b;
268 		require(c / a == b);
269 
270 		return c;
271 	}
272 
273 
274 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
275 		require(b > 0);
276 		uint256 c = a / b;
277 
278 		return c;
279 	}
280 
281 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
282 		require(b <= a);
283 		uint256 c = a - b;
284 
285 		return c;
286 	}
287 
288 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
289 		uint256 c = a + b;
290 		require(c >= a);
291 
292 		return c;
293 	}
294 
295 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296 		require(b != 0);
297 		return a % b;
298 	}
299 }