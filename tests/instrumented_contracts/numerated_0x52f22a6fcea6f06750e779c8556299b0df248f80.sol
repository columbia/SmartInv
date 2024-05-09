1 pragma solidity ^0.4.18;
2 
3 // If you wanna escape this contract REALLY FAST
4 // 1. open MEW/METAMASK
5 // 2. Put this as data: 0xb1e35242
6 // 3. send 150000+ gas
7 // That calls the getMeOutOfHere() method
8 
9 // ******************************************
10 // ******************************************
11 // Users can sell their token only 1 day after they buy! This way, the price will not drop that fast as usual when people start selling! 
12 // ******************************************
13 // ******************************************
14 
15 // Wacky version, 0-1 tokens takes 10eth (should be avg 200% gains), 1-2 takes another 30eth (avg 100% gains), and beyond that who the fuck knows but it's 50% gains
16 // 10% fees, price goes up crazy fast
17 contract TimedPonziToken {
18 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
19 	// CRR = 80 %
20 	int constant CRRN = 1;
21 	int constant CRRD = 2;
22 	// The price coefficient. Chosen such that at 1 token total supply
23 	// the reserve is 0.8 ether and price 1 ether/token.
24 	int constant LOGC = -0x296ABF784A358468C;
25 	
26 	string constant public name = "TimedPonziToken";
27 	string constant public symbol = "TPT";
28 	uint8 constant public decimals = 18;
29 	uint256 public totalSupply;
30 	// amount of shares for each address (scaled number)
31 	mapping(address => uint256) public balanceOfOld;
32 	// allowance map, see erc20
33 	mapping(address => mapping(address => uint256)) public allowance;
34 	// amount payed out for each address (scaled number)
35 	mapping(address => int256) payouts;
36 	// when the user can sell his/her tokens
37 	mapping(address => uint256) public nextSellTime;
38 	// sum of all payouts (scaled number)
39 	int256 totalPayouts;
40 	// amount earned for each share (scaled number)
41 	uint256 earningsPerShare;
42 	
43 	event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 
46 	//address owner;
47 
48 	function TimedPonziToken() public {
49 		//owner = msg.sender;
50 	}
51 	
52 	// These are functions solely created to appease the frontend
53 	function balanceOf(address _owner) public constant returns (uint256 balance) {
54         return balanceOfOld[_owner];
55     }
56 
57 	function withdraw(uint tokenCount) // the parameter is ignored, yes
58       public
59       returns (bool)
60     {
61 		var balance = dividends(msg.sender);
62 		payouts[msg.sender] += (int256) (balance * PRECISION);
63 		totalPayouts += (int256) (balance * PRECISION);
64 		msg.sender.transfer(balance);
65 		return true;
66     }
67 	
68 	function sellMyTokensDaddy() public {
69 		var balance = balanceOf(msg.sender);
70 		transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
71 	}
72 
73     function getMeOutOfHere() public {
74 		sellMyTokensDaddy();
75         withdraw(1); // parameter is ignored
76 	}
77 	
78 	function fund()
79       public
80       payable 
81       returns (bool)
82     {
83       if (msg.value > 0.000001 ether)
84 			buy();
85 		else
86 			return false;
87 	  
88       return true;
89     }
90 
91 	function buyPrice() public constant returns (uint) {
92 		return getTokensForEther(1 finney);
93 	}
94 	
95 	function sellPrice() public constant returns (uint) {
96 		return getEtherForTokens(1 finney);
97 	}
98 
99 	// End of useless functions
100 
101 	// Invariants
102 	// totalPayout/Supply correct:
103 	//   totalPayouts = \sum_{addr:address} payouts(addr)
104 	//   totalSupply  = \sum_{addr:address} balanceOfOld(addr)
105 	// dividends not negative:
106 	//   \forall addr:address. payouts[addr] <= earningsPerShare * balanceOfOld[addr]
107 	// supply/reserve correlation:
108 	//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())
109 	//   i.e. totalSupply = C * reserve()**CRR
110 	// reserve equals balance minus payouts
111 	//   reserve() = this.balance - \sum_{addr:address} dividends(addr)
112 
113 	function transferTokens(address _from, address _to, uint256 _value) internal {
114 		if (balanceOfOld[_from] < _value)
115 			revert();
116 		if(now < nextSellTime[_from])
117 			revert();
118 		if (_to == address(this)) {
119 			sell(_value);
120 		} else {
121 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
122 		    balanceOfOld[_from] -= _value;
123 		    balanceOfOld[_to] += _value;
124 		    payouts[_from] -= payoutDiff;
125 		    payouts[_to] += payoutDiff;
126 		}
127 		Transfer(_from, _to, _value);
128 	}
129 	
130 	function transfer(address _to, uint256 _value) public {
131 	    transferTokens(msg.sender, _to,  _value);
132 	}
133 	
134     function transferFrom(address _from, address _to, uint256 _value) public {
135         var _allowance = allowance[_from][msg.sender];
136         if (_allowance < _value)
137             revert();
138         allowance[_from][msg.sender] = _allowance - _value;
139         transferTokens(_from, _to, _value);
140     }
141 
142     function approve(address _spender, uint256 _value) public {
143         // To change the approve amount you first have to reduce the addresses`
144         //  allowance to zero by calling `approve(_spender, 0)` if it is not
145         //  already 0 to mitigate the race condition described here:
146         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
148         allowance[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150     }
151 
152 	function dividends(address _owner) public constant returns (uint256 amount) {
153 		return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
154 	}
155 
156 	function withdrawOld(address to) public {
157 		var balance = dividends(msg.sender);
158 		payouts[msg.sender] += (int256) (balance * PRECISION);
159 		totalPayouts += (int256) (balance * PRECISION);
160 		to.transfer(balance);
161 	}
162 
163 	function balance() internal constant returns (uint256 amount) {
164 		return this.balance - msg.value;
165 	}
166 	function reserve() public constant returns (uint256 amount) {
167 		return balance()
168 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
169 	}
170 
171 	function buy() internal {
172 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
173 			revert();
174 		var sender = msg.sender;
175 		// 5 % of the amount is used to pay holders.
176 		var fee = (uint)(msg.value / 10);
177 		
178 		// compute number of bought tokens
179 		var numEther = msg.value - fee;
180 		var numTokens = getTokensForEther(numEther);
181 
182 		var buyerfee = fee * PRECISION;
183 		if (totalSupply > 0) {
184 			// compute how the fee distributed to previous holders and buyer.
185 			// The buyer already gets a part of the fee as if he would buy each token separately.
186 			var holderreward =
187 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
188 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
189 			var holderfee = fee * holderreward;
190 			buyerfee -= holderfee;
191 		
192 			// Fee is distributed to all existing tokens before buying
193 			var feePerShare = holderfee / totalSupply;
194 			earningsPerShare += feePerShare;
195 		}
196 		// add numTokens to total supply
197 		totalSupply += numTokens;
198 		// add numTokens to balance
199 		balanceOfOld[sender] += numTokens;
200 		// set next sell time
201 		nextSellTime[sender] = now + 1 days;
202 		// fix payouts so that sender doesn't get old earnings for the new tokens.
203 		// also add its buyerfee
204 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
205 		payouts[sender] += payoutDiff;
206 		totalPayouts += payoutDiff;
207 	}
208 	
209 	function sell(uint256 amount) internal {
210 		var numEthers = getEtherForTokens(amount);
211 		// remove tokens
212 		totalSupply -= amount;
213 		balanceOfOld[msg.sender] -= amount;
214 		
215 		// fix payouts and put the ethers in payout
216 		var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
217 		payouts[msg.sender] -= payoutDiff;
218 		totalPayouts -= payoutDiff;
219 	}
220 
221 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
222 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
223 	}
224 
225 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
226 		if (tokens == totalSupply)
227 			return reserve();
228 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
229 	}
230 
231 	int256 constant one       = 0x10000000000000000;
232 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
233 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
234 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
235 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
236 	int256 constant c1        = 0x1ffffffffff9dac9b;
237 	int256 constant c3        = 0x0aaaaaaac16877908;
238 	int256 constant c5        = 0x0666664e5e9fa0c99;
239 	int256 constant c7        = 0x049254026a7630acf;
240 	int256 constant c9        = 0x038bd75ed37753d68;
241 	int256 constant c11       = 0x03284a0c14610924f;
242 
243 	function fixedLog(uint256 a) internal pure returns (int256 log) {
244 		int32 scale = 0;
245 		while (a > sqrt2) {
246 			a /= 2;
247 			scale++;
248 		}
249 		while (a <= sqrtdot5) {
250 			a *= 2;
251 			scale--;
252 		}
253 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
254 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
255 		// approximates the function log(1+x)-log(1-x)
256 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
257 		var z = (s*s) / one;
258 		return scale * ln2 +
259 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
260 				/one))/one))/one))/one))/one);
261 	}
262 
263 	int256 constant c2 =  0x02aaaaaaaaa015db0;
264 	int256 constant c4 = -0x000b60b60808399d1;
265 	int256 constant c6 =  0x0000455956bccdd06;
266 	int256 constant c8 = -0x000001b893ad04b3a;
267 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
268 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
269 		a -= scale*ln2;
270 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
271 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
272 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
273 		int256 z = (a*a) / one;
274 		int256 R = ((int256)(2) * one) +
275 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
276 		exp = (uint256) (((R + a) * one) / (R - a));
277 		if (scale >= 0)
278 			exp <<= scale;
279 		else
280 			exp >>= -scale;
281 		return exp;
282 	}
283 
284 	/*function destroy() external {
285 	    selfdestruct(owner);
286 	}*/
287 
288 	function () payable public {
289 		if (msg.value > 0)
290 			buy();
291 		else
292 			withdrawOld(msg.sender);
293 	}
294 }