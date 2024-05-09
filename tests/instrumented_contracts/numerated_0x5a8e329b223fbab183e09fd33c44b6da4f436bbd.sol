1 pragma solidity ^0.4.18;
2 
3 // If you wanna escape this contract REALLY FAST
4 // 1. open MEW/METAMASK
5 // 2. Put this as data: 0xb1e35242
6 // 3. send 150000+ gas
7 // That calls the getMeOutOfHere() method
8 
9 // Wacky version, 0-1 tokens takes 10eth (should be avg 200% gains), 1-2 takes another 30eth (avg 100% gains), and beyond that who the fuck knows but it's 50% gains
10 // 10% fees, price goes up crazy fast
11 contract EthPyramid {
12 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
13 	// CRR = 50 %
14 	int constant CRRN = 1;
15 	int constant CRRD = 2;
16 	// The price coefficient. Chosen such that at 1 token total supply
17 	// the reserve is 0.5 ether and price 1 ether/token.
18 	int constant LOGC = -0x296ABF784A358468C;
19 	
20 	string constant public name = "EthPyramid";
21 	string constant public symbol = "ETP";
22 	uint8 constant public decimals = 18;
23 	uint256 public totalSupply;
24 	// amount of shares for each address (scaled number)
25 	mapping(address => uint256) public balanceOfOld;
26 	// allowance map, see erc20
27 	mapping(address => mapping(address => uint256)) public allowance;
28 	// amount payed out for each address (scaled number)
29 	mapping(address => int256) public payouts;
30 	// sum of all payouts (scaled number)
31 	int256 public totalPayouts;
32 	// amount earned for each share (scaled number)
33 	uint256 public earningsPerShare;
34 
35 	event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38 	function EthPyramid() public {
39 		//owner = msg.sender;
40 	}
41 	
42 	// These are functions solely created to appease the frontend
43 	function balanceOf(address _owner) public constant returns (uint256 balance) {
44         return balanceOfOld[_owner];
45     }
46 
47 	function withdraw(uint tokenCount) // the parameter is ignored, yes
48       public
49       returns (bool)
50     {
51 		var balance = dividends(msg.sender);
52 		payouts[msg.sender] += (int256) (balance * PRECISION);
53 		totalPayouts += (int256) (balance * PRECISION);
54         
55 		msg.sender.transfer(balance);
56 
57 		return true;
58     }
59 
60     function reinvestDivies() public returns (bool) 
61     {
62         var balance = dividends(msg.sender);
63         payouts[msg.sender] += (int256) (balance * PRECISION);
64 		totalPayouts += (int256) (balance * PRECISION);
65 		
66 		uint value_ = (uint) (balance);
67 		
68 		 if (value_ < 0.000001 ether || value_ > 1000000 ether)
69 			revert();
70 		var sender = msg.sender;
71 		var res = reserve() - balance;
72 		// 5 % of the amount is used to pay holders.
73 		var fee = (uint)(value_ / 10);
74 		
75 		// compute number of bought tokens
76 		var numEther = value_ - fee;
77 		var numTokens = getTokensForEther2(numEther, balance);
78 
79 		var buyerfee = fee * PRECISION;
80 		if (totalSupply > 0) {
81 			// compute how the fee distributed to previous holders and buyer.
82 			// The buyer already gets a part of the fee as if he would buy each token separately.
83 			var holderreward =
84 			    (PRECISION - (res + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
85 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
86 			var holderfee = fee * holderreward;
87 			buyerfee -= holderfee;
88 		
89 			// Fee is distributed to all existing tokens before buying
90 			var feePerShare = holderfee / totalSupply;
91 			earningsPerShare += feePerShare;
92 		}
93 		// add numTokens to total supply
94 		totalSupply += numTokens;
95 		// add numTokens to balance
96 		balanceOfOld[sender] += numTokens;
97 		// fix payouts so that sender doesn't get old earnings for the new tokens.
98 		// also add its buyerfee
99 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
100 		payouts[sender] += payoutDiff;
101 		totalPayouts += payoutDiff;
102 		
103         return true;
104     }
105 	
106 	function sellMyTokensDaddy() public {
107 		var balance = balanceOf(msg.sender);
108 		transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
109 	}
110 
111     function getMeOutOfHere() public {
112 		sellMyTokensDaddy();
113         withdraw(1); // parameter is ignored
114 	}
115 	
116 	function fund()
117       public
118       payable 
119       returns (bool)
120     {
121       if (msg.value > 0.000001 ether)
122 			buy();
123 		else
124 			return false;
125 	  
126       return true;
127     }
128 
129 	function buyPrice() public constant returns (uint) {
130 		return getTokensForEther(1 finney);
131 	}
132 	
133 	function sellPrice() public constant returns (uint) {
134         var eth = getEtherForTokens(1 finney);
135         var fee = (uint256)(eth / 10);
136         return eth - fee;
137     }
138 
139 	// End of useless functions
140 
141 	// Invariants
142 	// totalPayout/Supply correct:
143 	//   totalPayouts = \sum_{addr:address} payouts(addr)
144 	//   totalSupply  = \sum_{addr:address} balanceOfOld(addr)
145 	// dividends not negative:
146 	//   \forall addr:address. payouts[addr] <= earningsPerShare * balanceOfOld[addr]
147 	// supply/reserve correlation:
148 	//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())
149 	//   i.e. totalSupply = C * reserve()**CRR
150 	// reserve equals balance minus payouts
151 	//   reserve() = this.balance - \sum_{addr:address} dividends(addr)
152 
153 	function transferTokens(address _from, address _to, uint256 _value) internal {
154 		if (balanceOfOld[_from] < _value)
155 			revert();
156 		if (_to == address(this)) {
157 			sell(_value);
158 		} else {
159 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
160 		    balanceOfOld[_from] -= _value;
161 		    balanceOfOld[_to] += _value;
162 		    payouts[_from] -= payoutDiff;
163 		    payouts[_to] += payoutDiff;
164 		}
165 		Transfer(_from, _to, _value);
166 	}
167 	
168 	function transfer(address _to, uint256 _value) public {
169 	    transferTokens(msg.sender, _to,  _value);
170 	}
171 	
172     function transferFrom(address _from, address _to, uint256 _value) public {
173         var _allowance = allowance[_from][msg.sender];
174         if (_allowance < _value)
175             revert();
176         allowance[_from][msg.sender] = _allowance - _value;
177         transferTokens(_from, _to, _value);
178     }
179 
180     function approve(address _spender, uint256 _value) public {
181         // To change the approve amount you first have to reduce the addresses`
182         //  allowance to zero by calling `approve(_spender, 0)` if it is not
183         //  already 0 to mitigate the race condition described here:
184         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
186         allowance[msg.sender][_spender] = _value;
187         Approval(msg.sender, _spender, _value);
188     }
189 
190 	function dividends(address _owner) public constant returns (uint256 amount) {
191 		return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
192 	}
193 
194 	function withdrawOld(address to) public {
195 		var balance = dividends(msg.sender);
196 		payouts[msg.sender] += (int256) (balance * PRECISION);
197 		totalPayouts += (int256) (balance * PRECISION);
198 		to.transfer(balance);
199 	}
200 
201 	function balance() internal constant returns (uint256 amount) {
202 		return this.balance - msg.value;
203 	}
204 	function reserve() public constant returns (uint256 amount) {
205 		return balance()
206 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
207 	}
208 
209 	function buy() internal {
210 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
211 			revert();
212 		var sender = msg.sender;
213 		// 10 % of the amount is used to pay holders.
214 		var fee = (uint)(msg.value / 10);
215 		
216 		// compute number of bought tokens
217 		var numEther = msg.value - fee;
218 		var numTokens = getTokensForEther(numEther);
219 
220 		var buyerfee = fee * PRECISION;
221 		if (totalSupply > 0) {
222 			// compute how the fee distributed to previous holders and buyer.
223 			// The buyer already gets a part of the fee as if he would buy each token separately.
224 			var holderreward =
225 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
226 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
227 			var holderfee = fee * holderreward;
228 			buyerfee -= holderfee;
229 		
230 			// Fee is distributed to all existing tokens before buying
231 			var feePerShare = holderfee / totalSupply;
232 			earningsPerShare += feePerShare;
233 		}
234 		// add numTokens to total supply
235 		totalSupply += numTokens;
236 		// add numTokens to balance
237 		balanceOfOld[sender] += numTokens;
238 		// fix payouts so that sender doesn't get old earnings for the new tokens.
239 		// also add its buyerfee
240 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
241 		payouts[sender] += payoutDiff;
242 		totalPayouts += payoutDiff;
243 	}
244 	
245 	function sell(uint256 amount) internal {
246 	    
247 	   var numEthersBeforeFee = getEtherForTokens(amount);
248         var fee = (uint256)(numEthersBeforeFee / 10);
249         var numEthers = numEthersBeforeFee - fee; // Net ether for seller, after fee
250             totalSupply -= amount;
251         balanceOfOld[msg.sender] -= amount;
252          if(totalSupply > 0 ) {
253             // fix payouts and put the ethers in payout
254             var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
255             payouts[msg.sender] -= payoutDiff;
256             totalPayouts -= payoutDiff;
257      
258             var sellerfee = fee * PRECISION;
259             var feePerShare = sellerfee / totalSupply;
260             earningsPerShare += feePerShare;
261          }
262         
263 
264  
265  
266 
267 	}
268 
269 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
270 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
271 	}
272 
273 	function getTokensForEther2(uint256 ethervalue, uint256 sub) public constant returns (uint256 tokens) {
274 		return fixedExp(fixedLog(reserve() - sub + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
275 	}
276 
277 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
278 		if (tokens == totalSupply)
279 			return reserve();
280 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
281 	}
282 
283 	int256 constant one       = 0x10000000000000000;
284 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
285 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
286 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
287 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
288 	int256 constant c1        = 0x1ffffffffff9dac9b;
289 	int256 constant c3        = 0x0aaaaaaac16877908;
290 	int256 constant c5        = 0x0666664e5e9fa0c99;
291 	int256 constant c7        = 0x049254026a7630acf;
292 	int256 constant c9        = 0x038bd75ed37753d68;
293 	int256 constant c11       = 0x03284a0c14610924f;
294 
295 	function fixedLog(uint256 a) internal pure returns (int256 log) {
296 		int32 scale = 0;
297 		while (a > sqrt2) {
298 			a /= 2;
299 			scale++;
300 		}
301 		while (a <= sqrtdot5) {
302 			a *= 2;
303 			scale--;
304 		}
305 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
306 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
307 		// approximates the function log(1+x)-log(1-x)
308 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
309 		var z = (s*s) / one;
310 		return scale * ln2 +
311 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
312 				/one))/one))/one))/one))/one);
313 	}
314 
315 	int256 constant c2 =  0x02aaaaaaaaa015db0;
316 	int256 constant c4 = -0x000b60b60808399d1;
317 	int256 constant c6 =  0x0000455956bccdd06;
318 	int256 constant c8 = -0x000001b893ad04b3a;
319 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
320 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
321 		a -= scale*ln2;
322 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
323 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
324 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
325 		int256 z = (a*a) / one;
326 		int256 R = ((int256)(2) * one) +
327 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
328 		exp = (uint256) (((R + a) * one) / (R - a));
329 		if (scale >= 0)
330 			exp <<= scale;
331 		else
332 			exp >>= -scale;
333 		return exp;
334 	}
335 
336 	 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
337     if (a == 0) {
338       return 0;
339     }
340     uint256 c = a * b;
341     assert(c / a == b);
342     return c;
343   }
344 
345   function div(uint256 a, uint256 b) internal pure returns (uint256) {
346     // assert(b > 0); // Solidity automatically throws when dividing by 0
347     uint256 c = a / b;
348     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
349     return c;
350   }
351 
352   
353   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
354     assert(b <= a);
355     return a - b;
356   }
357 
358 
359   function add(uint256 a, uint256 b) internal pure returns (uint256) {
360     uint256 c = a + b;
361     assert(c >= a);
362     return c;
363   }
364 	
365 
366 	function () payable public {
367 		if (msg.value > 0)
368 			buy();
369 		else
370 			withdrawOld(msg.sender);
371 	}
372 }