1 pragma solidity ^0.4.18;
2 
3 contract SoulcoinGems {
4 
5 	uint256 constant scaleFactor = 0x10000000000000000;
6 	int constant crr_n = 1; // CRR numerator
7 	int constant crr_d = 2; // CRR denominator
8 	int constant price_coeff = -0x296ABF784A358468C;
9 	string constant public name = "Soulcoin Gem";
10 	string constant public symbol = "SOULGEM";
11 	uint8 constant public decimals = 18;
12 	mapping(address => uint256) public tokenBalance;
13 	mapping(address => int256) public payouts;
14 	uint256 public totalSupply;
15 	int256 totalPayouts;
16 
17 	uint256 earningsPerToken;
18 	uint256 public contractBalance;
19 	uint private __totalSupply = 0;
20     mapping (address => uint) private __balanceOf;
21     mapping (address => mapping (address => uint)) private __allowances;
22     
23 	function SoulcoinGems() public {}
24     function totalSupply() constant returns (uint _totalSupply) {
25         _totalSupply = __totalSupply;
26     }
27 	function generateSoul(uint _value) internal {
28 		__balanceOf[msg.sender] += _value*10;
29 		__totalSupply += _value*10;
30 	}
31     function balanceOf(address _addr) constant returns (uint balance) {
32         return __balanceOf[_addr];
33     }
34     
35     function transfer(address _to, uint _value) returns (bool success) {
36         if (_value > 0 && _value <= balanceOf(msg.sender)) {
37             __balanceOf[msg.sender] -= _value;
38             __balanceOf[_to] += _value;
39             return true;
40         }
41         return false;
42     }
43     
44     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
45         if (__allowances[_from][msg.sender] > 0 &&
46             _value > 0 &&
47             __allowances[_from][msg.sender] >= _value && 
48             __balanceOf[_from] >= _value) {
49             __balanceOf[_from] -= _value;
50             __balanceOf[_to] += _value;
51             // Missed from the video
52             __allowances[_from][msg.sender] -= _value;
53             return true;
54         }
55         return false;
56     }
57     
58     function approve(address _spender, uint _value) returns (bool success) {
59         __allowances[msg.sender][_spender] = _value;
60         return true;
61     }
62     
63     function allowance(address _owner, address _spender) constant returns (uint remaining) {
64         return __allowances[_owner][_spender];
65     }
66 
67 	function pyrBalanceOf(address _owner) public constant returns (uint256 balance) {
68 		return tokenBalance[_owner];
69 	}
70 	function withdraw() public {
71 		var balance = dividends(msg.sender);
72 		payouts[msg.sender] += (int256) (balance * scaleFactor);
73 		totalPayouts += (int256) (balance * scaleFactor);
74 		contractBalance = sub(contractBalance, balance);
75 		msg.sender.transfer(balance);
76 	}
77 	function reinvestDividends() public {
78 		var balance = dividends(msg.sender);
79 		payouts[msg.sender] += (int256) (balance * scaleFactor);
80 		totalPayouts += (int256) (balance * scaleFactor);
81 		uint value_ = (uint) (balance);
82 		if (value_ < 0.000001 ether || value_ > 1000000 ether)
83 			revert();
84 		var sender = msg.sender;
85 		var res = reserve() - balance;
86 		var fee = div(value_, 10);
87 		var numEther = value_ - fee;
88 		
89 		var numTokens = calculateDividendTokens(numEther, balance);
90 		generateSoul(numTokens);
91 
92 		var buyerFee = fee * scaleFactor;
93 		if (totalSupply > 0) {
94 			var bonusCoEff =
95 			    (scaleFactor - (res + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
96 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
97 			var holderReward = fee * bonusCoEff;
98 			
99 			buyerFee -= holderReward;
100 
101 			var rewardPerShare = holderReward / totalSupply;
102 			earningsPerToken += rewardPerShare;
103 		}
104 
105 		totalSupply = add(totalSupply, numTokens);
106 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
107 		var payoutDiff  = (int256) ((earningsPerToken * numTokens) - buyerFee);
108 		
109 		payouts[sender] += payoutDiff;
110 		totalPayouts    += payoutDiff;
111 		
112 	}
113 	function sellMyTokens() public {
114 		var balance = pyrBalanceOf(msg.sender);
115 		sell(balance);
116 	}
117     function getMeOutOfHere() public {
118 		sellMyTokens();
119         withdraw();
120 	}
121     function mineSoul() public {
122 		sellMyTokens();
123         reinvestDividends();
124 	}
125 	function fund() payable public {
126 	
127 		if (msg.value > 0.000001 ether) {
128 		    contractBalance = add(contractBalance, msg.value);
129 			buy();
130 		} else {
131 			revert();
132 		}
133     }
134 	function buyPrice() public constant returns (uint) {
135 		return getTokensForEther(1 finney);
136 	}
137 	function sellPrice() public constant returns (uint) {
138         var eth = getEtherForTokens(1 finney);
139         var fee = div(eth, 10);
140         return eth - fee;
141     }
142 
143 	function dividends(address _owner) public constant returns (uint256 amount) {
144 		return (uint256) ((int256)(earningsPerToken * tokenBalance[_owner]) - payouts[_owner]) / scaleFactor;
145 	}
146 
147 	function withdrawOld(address to) public {
148 
149 		var balance = dividends(msg.sender);
150 
151 		payouts[msg.sender] += (int256) (balance * scaleFactor);
152 
153 		totalPayouts += (int256) (balance * scaleFactor);
154 
155 		contractBalance = sub(contractBalance, balance);
156 		to.transfer(balance);		
157 	}
158 
159 	function balance() internal constant returns (uint256 amount) {
160 		return contractBalance - msg.value;
161 	}
162 
163 	function buy() internal {
164 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
165 			revert();
166 		var sender = msg.sender;
167 		var fee = div(msg.value, 10);
168 		var numEther = msg.value - fee;
169 		var numTokens = getTokensForEther(numEther);
170 		
171 		generateSoul(numTokens);
172 
173 		var buyerFee = fee * scaleFactor;
174 		if (totalSupply > 0) {
175 			var bonusCoEff =
176 			    (scaleFactor - (reserve() + numEther) * numTokens * scaleFactor / (totalSupply + numTokens) / numEther)
177 			    * (uint)(crr_d) / (uint)(crr_d-crr_n);
178 			var holderReward = fee * bonusCoEff;
179 			
180 			buyerFee -= holderReward;
181 
182 			var rewardPerShare = holderReward / totalSupply;
183 			earningsPerToken += rewardPerShare;
184 			
185 		}
186 		totalSupply = add(totalSupply, numTokens);
187 
188 		tokenBalance[sender] = add(tokenBalance[sender], numTokens);
189 		var payoutDiff = (int256) ((earningsPerToken * numTokens) - buyerFee);
190 		
191 		payouts[sender] += payoutDiff;
192 		totalPayouts    += payoutDiff;
193 		
194 	}
195 
196 	function sell(uint256 amount) internal {
197 	    var numEthersBeforeFee = getEtherForTokens(amount);
198 		var fee = div(numEthersBeforeFee, 10);
199 		
200 		var numEthers = numEthersBeforeFee ;//- fee;
201 		
202 		totalSupply = sub(totalSupply, amount);
203 		
204         tokenBalance[msg.sender] = sub(tokenBalance[msg.sender], amount);
205 
206         var payoutDiff = (int256) (earningsPerToken * amount + (numEthers * scaleFactor));
207 		
208         payouts[msg.sender] -= payoutDiff;		
209 		
210 		totalPayouts -= payoutDiff;
211 		
212 		if (totalSupply > 0) {
213 			var etherFee = fee * scaleFactor;
214 			
215 			var rewardPerShare = etherFee / totalSupply;
216 			
217 			earningsPerToken = add(earningsPerToken, rewardPerShare);
218 		}
219 	}
220 	function reserve() internal constant returns (uint256 amount) {
221 		return sub(balance(),
222 			 ((uint256) ((int256) (earningsPerToken * totalSupply) - totalPayouts) / scaleFactor));
223 	}
224 
225 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
226 		return sub(fixedExp(fixedLog(reserve() + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
227 	}
228 
229 	function calculateDividendTokens(uint256 ethervalue, uint256 subvalue) public constant returns (uint256 tokens) {
230 		return sub(fixedExp(fixedLog(reserve() - subvalue + ethervalue)*crr_n/crr_d + price_coeff), totalSupply);
231 	}
232 
233 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
234 		var reserveAmount = reserve();
235 
236 		if (tokens == totalSupply)
237 			return reserveAmount;
238 		return sub(reserveAmount, fixedExp((fixedLog(totalSupply - tokens) - price_coeff) * crr_d/crr_n));
239 	}
240 
241 	int256  constant one        = 0x10000000000000000;
242 	uint256 constant sqrt2      = 0x16a09e667f3bcc908;
243 	uint256 constant sqrtdot5   = 0x0b504f333f9de6484;
244 	int256  constant ln2        = 0x0b17217f7d1cf79ac;
245 	int256  constant ln2_64dot5 = 0x2cb53f09f05cc627c8;
246 	int256  constant c1         = 0x1ffffffffff9dac9b;
247 	int256  constant c3         = 0x0aaaaaaac16877908;
248 	int256  constant c5         = 0x0666664e5e9fa0c99;
249 	int256  constant c7         = 0x049254026a7630acf;
250 	int256  constant c9         = 0x038bd75ed37753d68;
251 	int256  constant c11        = 0x03284a0c14610924f;
252 
253 	function fixedLog(uint256 a) internal pure returns (int256 log) {
254 		int32 scale = 0;
255 		while (a > sqrt2) {
256 			a /= 2;
257 			scale++;
258 		}
259 		while (a <= sqrtdot5) {
260 			a *= 2;
261 			scale--;
262 		}
263 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
264 		var z = (s*s) / one;
265 		return scale * ln2 +
266 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
267 				/one))/one))/one))/one))/one);
268 	}
269 
270 	int256 constant c2 =  0x02aaaaaaaaa015db0;
271 	int256 constant c4 = -0x000b60b60808399d1;
272 	int256 constant c6 =  0x0000455956bccdd06;
273 	int256 constant c8 = -0x000001b893ad04b3a;
274 	
275 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
276 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
277 		a -= scale*ln2;
278 		int256 z = (a*a) / one;
279 		int256 R = ((int256)(2) * one) +
280 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
281 		exp = (uint256) (((R + a) * one) / (R - a));
282 		if (scale >= 0)
283 			exp <<= scale;
284 		else
285 			exp >>= -scale;
286 		return exp;
287 	}
288 	
289 
290 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291 		if (a == 0) {
292 			return 0;
293 		}
294 		uint256 c = a * b;
295 		assert(c / a == b);
296 		return c;
297 	}
298 
299 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
300 		uint256 c = a / b;
301 		return c;
302 	}
303 
304 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305 		assert(b <= a);
306 		return a - b;
307 	}
308 
309 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
310 		uint256 c = a + b;
311 		assert(c >= a);
312 		return c;
313 	}
314 
315 	function () payable public {
316 		if (msg.value > 0) {
317 			fund();
318 		} else {
319 			withdrawOld(msg.sender);
320 		}
321 	}
322 }