1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
6 		if (_a == 0) {
7 			return 0;
8 		}
9 
10 		uint256 c = _a * _b;
11 		require(c / _a == _b);
12 
13 		return c;
14 	}
15 
16 	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
17 		require(_b > 0);
18 		uint256 c = _a / _b;
19 
20 		return c;
21 	}
22 
23 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
24 		require(_b <= _a);
25 		uint256 c = _a - _b;
26 
27 		return c;
28 	}
29 
30 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
31 		uint256 c = _a + _b;
32 		require(c >= _a);
33 
34 		return c;
35 	}
36 
37 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38 		require(b != 0);
39 		return a % b;
40 	}
41 }
42 
43 contract InvestorsStorage {
44 	address private owner;
45 
46 	mapping (address => Investor) private investors;
47 
48 	struct Investor {
49 		uint deposit;
50 		uint checkpoint;
51 		address referrer;
52 	}
53 
54 	constructor() public {
55 		owner = msg.sender;
56 	}
57 
58 	modifier onlyOwner() {
59 		require(msg.sender == owner);
60 		_;
61 	}
62 
63 	function updateInfo(address _address, uint _value) external onlyOwner {
64 		investors[_address].deposit += _value;
65 		investors[_address].checkpoint = block.timestamp;
66 	}
67 
68 	function updateCheckpoint(address _address) external onlyOwner {
69 		investors[_address].checkpoint = block.timestamp;
70 	}
71 
72 	function addReferrer(address _referral, address _referrer) external onlyOwner {
73 		investors[_referral].referrer = _referrer;
74 	}
75 
76 	function getInterest(address _address) external view returns(uint) {
77 		if (investors[_address].deposit > 0) {
78 			return(500 + ((block.timestamp - investors[_address].checkpoint) / 1 days));
79 		}
80 	}
81 
82 	function d(address _address) external view returns(uint) {
83 		return investors[_address].deposit;
84 	}
85 
86 	function c(address _address) external view returns(uint) {
87 		return investors[_address].checkpoint;
88 	}
89 
90 	function r(address _address) external view returns(address) {
91 		return investors[_address].referrer;
92 	}
93 }
94 
95 contract NewSmartPyramid {
96 	using SafeMath for uint;
97 
98 	address adv_adr;
99 	address adm_adr;
100 	uint waveStartUp;
101 	uint nextPayDay;
102 
103 	mapping (uint => Leader) top;
104 
105 	event LogInvestment(address indexed _addr, uint _value);
106 	event LogIncome(address indexed _addr, uint _value, string indexed _type);
107 	event LogReferralInvestment(address indexed _referrer, address indexed _referral, uint _value);
108 	event LogGift(address _firstAddr, uint _firstDep, address _secondAddr, uint _secondDep, address _thirdAddr, uint _thirdDep);
109 	event LogNewWave(uint _waveStartUp);
110 
111 	InvestorsStorage private x;
112 
113 	modifier notOnPause() {
114 		require(waveStartUp <= block.timestamp);
115 		_;
116 	}
117 
118 	struct Leader {
119 		address addr;
120 		uint deposit;
121 	}
122 
123 	function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
124 		assembly {
125 			parsedReferrer := mload(add(_source,0x14))
126 		}
127 		return parsedReferrer;
128 	}
129 
130 	function addReferrer(uint _value) internal {
131 		address _referrer = bytesToAddress(bytes(msg.data));
132 		if (_referrer != msg.sender) {
133 			x.addReferrer(msg.sender, _referrer);
134 			x.r(msg.sender).transfer(_value / 20);
135 			emit LogReferralInvestment(_referrer, msg.sender, _value);
136 			emit LogIncome(_referrer, _value / 20, "referral");
137 		}
138 	}
139 
140 	constructor(address adv,address adm) public {
141 		adv_adr = adv;
142 		adm_adr = adm;
143 		x = new InvestorsStorage();
144 		nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);
145 	}
146 
147 	function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
148 		deposit = x.d(_address);
149 		if (block.timestamp >= x.c(_address) + 10 minutes) {
150 			amountToWithdraw = (x.d(_address).mul(x.getInterest(_address)).div(10000)).mul(block.timestamp.sub(x.c(_address))).div(1 days);
151 		} else {
152 			amountToWithdraw = 0;
153 		}
154 	}
155 
156 	function getTop() external view returns(address, uint, address, uint, address, uint) {
157 		return(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
158 	}
159 
160 	function() external payable {
161 		if (msg.value == 0) {
162 			withdraw();
163 		} else {
164 			invest();
165 		}
166 	}
167 
168 	function invest() notOnPause public payable {
169 
170 		adm_adr.transfer(msg.value.mul(13).div(100));
171 		adv_adr.transfer(msg.value.mul(2).div(100));
172 
173 		if (x.d(msg.sender) > 0) {
174 			withdraw();
175 		}
176 
177 		x.updateInfo(msg.sender, msg.value);
178 
179 		if (msg.value > top[3].deposit) {
180 			toTheTop();
181 		}
182 
183 		if (x.r(msg.sender) != 0x0) {
184 			x.r(msg.sender).transfer(msg.value / 20);
185 			emit LogReferralInvestment(x.r(msg.sender), msg.sender, msg.value);
186 			emit LogIncome(x.r(msg.sender), msg.value / 20, "referral");
187 		} else if (msg.data.length == 20) {
188 			addReferrer(msg.value);
189 		}
190 
191 		emit LogInvestment(msg.sender, msg.value);
192 	}
193 
194 	function withdraw() notOnPause public {
195 
196 		if (block.timestamp >= x.c(msg.sender) + 10 minutes) {
197 			uint _payout = (x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000)).mul(block.timestamp.sub(x.c(msg.sender))).div(1 days);
198 			x.updateCheckpoint(msg.sender);
199 		}
200 
201 		if (_payout > 0) {
202 
203 			if (_payout > address(this).balance) {
204 				nextWave();
205 				return;
206 			}
207 
208 			msg.sender.transfer(_payout);
209 			emit LogIncome(msg.sender, _payout, "withdrawn");
210 		}
211 	}
212 
213 	function toTheTop() internal {
214 		if (msg.value <= top[2].deposit) {
215 			top[3] = Leader(msg.sender, msg.value);
216 		} else {
217 			if (msg.value <= top[1].deposit) {
218 				top[3] = top[2];
219 				top[2] = Leader(msg.sender, msg.value);
220 			} else {
221 				top[3] = top[2];
222 				top[2] = top[1];
223 				top[1] = Leader(msg.sender, msg.value);
224 			}
225 		}
226 	}
227 
228 	function payDay() external {
229 		if(msg.sender != adm_adr)
230 			require(block.timestamp >= nextPayDay);
231 		nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);
232 
233 		emit LogGift(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
234 
235 		for (uint i = 0; i <= 2; i++) {
236 			if (top[i+1].addr != 0x0) {
237 				uint money_to = 0.5 ether;
238 				if(i==0)
239 					money_to = 3 ether;
240 				else if(i==1)
241 					money_to = 1.5 ether;
242 
243 				top[i+1].addr.transfer(money_to);
244 				top[i+1] = Leader(0x0, 0);
245 			}
246 		}
247 	}
248 
249 	function nextWave() private {
250 		for (uint i = 0; i <= 2; i++) {
251 			top[i+1] = Leader(0x0, 0);
252 		}
253 		x = new InvestorsStorage();
254 		waveStartUp = block.timestamp + 7 days;
255 		emit LogNewWave(waveStartUp);
256 	}
257 }