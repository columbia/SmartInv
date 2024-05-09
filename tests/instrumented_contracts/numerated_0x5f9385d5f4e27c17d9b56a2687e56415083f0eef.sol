1 pragma solidity ^0.4.18;
2 // THIS IS A REAL WORLD SIMULATION AS SOCIAL EXPERIMENT
3 // By sending ETH to the smart contract, you're trusting 
4 // an uncaring mathematical gambling robot to entrust you with Tokens.
5 // Every Time a Token is purchased, the contract increases the price 
6 // of the next token by a small percentage (about 0.25%). 
7 // Every time a Token is sold, the next Token is valued slightly less (about -0.25%).
8 // At any time, you can sell your Tokens back to the Smart Contract
9 // for 90% of the current price, or withdraw just the dividends 
10 // you've accumulated!
11 // This is a Simulation and kinda a Social Experiment 
12 
13 // ------- DO NOT USE FUNDS YOU CAN'T EFFORT TO LOSE -------
14 // ------- THIS IS A PURE SIMULATION OF THE CAPABILITIES OF ETHEREUM CONTRACTS -------
15 
16 // If you want to WITHDRAW accumulated DIVIDENDS 
17 // 1. open MEW/METAMASK
18 // 2. Put this as data: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000
19 // 3. send 50.000+ gas
20 
21 // If you want to escape this contract REALLY FAST
22 // 1. open MEW/METAMASK
23 // 2. Put this as data: 0xb1e35242
24 // 3. send 150.000+ gas
25 // That calls the getMeOutOfHere() method
26 
27 contract ethpyramid {
28 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
29 	// CRR = 80 %
30 	int constant CRRN = 1;
31 	int constant CRRD = 2;
32 	// The price coefficient. Chosen such that at 1 token total supply
33 	// the reserve is 0.8 ether and price 1 ether/token.
34 	int constant LOGC = -0x296ABF784A358468C;
35 	
36 	string constant public name = "EthPyramid";
37 	string constant public symbol = "EPT";
38 	uint8 constant public decimals = 18;
39 	uint256 public totalSupply;
40 	// amount of shares for each address (scaled number)
41 	mapping(address => uint256) public balanceOfOld;
42 	// allowance map, see erc20
43 	mapping(address => mapping(address => uint256)) public allowance;
44 	// amount payed out for each address (scaled number)
45 	mapping(address => int256) payouts;
46 	// sum of all payouts (scaled number)
47 	int256 totalPayouts;
48 	// amount earned for each share (scaled number)
49 	uint256 earningsPerShare;
50 	
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 
54 	//address owner;
55 
56 	function ethpyramid() public {
57 		//owner = msg.sender;
58 	}
59 	
60 	// These are functions solely created to appease the frontend
61 	function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balanceOfOld[_owner];
63     }
64 
65 	function withdraw(uint tokenCount) // the parameter is ignored, yes
66       public
67       returns (bool)
68     {
69 		var balance = dividends(msg.sender);
70 		payouts[msg.sender] += (int256) (balance * PRECISION);
71 		totalPayouts += (int256) (balance * PRECISION);
72 		msg.sender.transfer(balance);
73 		return true;
74     }
75 	
76 	function sellMyTokensDaddy() public {
77 		var balance = balanceOf(msg.sender);
78 		transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
79 	}
80 
81     function getMeOutOfHere() public {
82 		sellMyTokensDaddy();
83         withdraw(1); // parameter is ignored
84 	}
85 	
86 	function fund()
87       public
88       payable 
89       returns (bool)
90     {
91       if (msg.value > 0.000001 ether)
92 			buy();
93 		else
94 			return false;
95 	  
96       return true;
97     }
98 
99 	function buyPrice() public constant returns (uint) {
100 		return getTokensForEther(1 finney);
101 	}
102 	
103 	function sellPrice() public constant returns (uint) {
104 		return getEtherForTokens(1 finney);
105 	}
106 
107 	// End of useless functions
108 
109 	// Invariants
110 	// totalPayout/Supply correct:
111 	//   totalPayouts = \sum_{addr:address} payouts(addr)
112 	//   totalSupply  = \sum_{addr:address} balanceOfOld(addr)
113 	// dividends not negative:
114 	//   \forall addr:address. payouts[addr] <= earningsPerShare * balanceOfOld[addr]
115 	// supply/reserve correlation:
116 	//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())
117 	//   i.e. totalSupply = C * reserve()**CRR
118 	// reserve equals balance minus payouts
119 	//   reserve() = this.balance - \sum_{addr:address} dividends(addr)
120 
121 	function transferTokens(address _from, address _to, uint256 _value) internal {
122 		if (balanceOfOld[_from] < _value)
123 			revert();
124 		if (_to == address(this)) {
125 			sell(_value);
126 		} else {
127 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
128 		    balanceOfOld[_from] -= _value;
129 		    balanceOfOld[_to] += _value;
130 		    payouts[_from] -= payoutDiff;
131 		    payouts[_to] += payoutDiff;
132 		}
133 		Transfer(_from, _to, _value);
134 	}
135 	
136 	function transfer(address _to, uint256 _value) public {
137 	    transferTokens(msg.sender, _to,  _value);
138 	}
139 	
140     function transferFrom(address _from, address _to, uint256 _value) public {
141         var _allowance = allowance[_from][msg.sender];
142         if (_allowance < _value)
143             revert();
144         allowance[_from][msg.sender] = _allowance - _value;
145         transferTokens(_from, _to, _value);
146     }
147 
148     function approve(address _spender, uint256 _value) public {
149         // To change the approve amount you first have to reduce the addresses`
150         //  allowance to zero by calling `approve(_spender, 0)` if it is not
151         //  already 0 to mitigate the race condition described here:
152         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
154         allowance[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156     }
157 
158 	function dividends(address _owner) public constant returns (uint256 amount) {
159 		return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
160 	}
161 
162 	function withdrawOld(address to) public {
163 		var balance = dividends(msg.sender);
164 		payouts[msg.sender] += (int256) (balance * PRECISION);
165 		totalPayouts += (int256) (balance * PRECISION);
166 		to.transfer(balance);
167 	}
168 
169 	function balance() internal constant returns (uint256 amount) {
170 		return this.balance - msg.value;
171 	}
172 	function reserve() public constant returns (uint256 amount) {
173 		return balance()
174 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
175 	}
176 
177 	function buy() internal {
178 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
179 			revert();
180 		var sender = msg.sender;
181 		// 5 % of the amount is used to pay holders.
182 		var fee = (uint)(msg.value / 10);
183 		
184 		// compute number of bought tokens
185 		var numEther = msg.value - fee;
186 		var numTokens = getTokensForEther(numEther);
187 
188 		var buyerfee = fee * PRECISION;
189 		if (totalSupply > 0) {
190 			// compute how the fee distributed to previous holders and buyer.
191 			// The buyer already gets a part of the fee as if he would buy each token separately.
192 			var holderreward =
193 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
194 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
195 			var holderfee = fee * holderreward;
196 			buyerfee -= holderfee;
197 		
198 			// Fee is distributed to all existing tokens before buying
199 			var feePerShare = holderfee / totalSupply;
200 			earningsPerShare += feePerShare;
201 		}
202 		// add numTokens to total supply
203 		totalSupply += numTokens;
204 		// add numTokens to balance
205 		balanceOfOld[sender] += numTokens;
206 		// fix payouts so that sender doesn't get old earnings for the new tokens.
207 		// also add its buyerfee
208 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
209 		payouts[sender] += payoutDiff;
210 		totalPayouts += payoutDiff;
211 	}
212 	
213 	function sell(uint256 amount) internal {
214 		var numEthers = getEtherForTokens(amount);
215 		// remove tokens
216 		totalSupply -= amount;
217 		balanceOfOld[msg.sender] -= amount;
218 		
219 		// fix payouts and put the ethers in payout
220 		var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
221 		payouts[msg.sender] -= payoutDiff;
222 		totalPayouts -= payoutDiff;
223 	}
224 
225 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
226 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
227 	}
228 
229 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
230 		if (tokens == totalSupply)
231 			return reserve();
232 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
233 	}
234 
235 	int256 constant one       = 0x10000000000000000;
236 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
237 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
238 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
239 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
240 	int256 constant c1        = 0x1ffffffffff9dac9b;
241 	int256 constant c3        = 0x0aaaaaaac16877908;
242 	int256 constant c5        = 0x0666664e5e9fa0c99;
243 	int256 constant c7        = 0x049254026a7630acf;
244 	int256 constant c9        = 0x038bd75ed37753d68;
245 	int256 constant c11       = 0x03284a0c14610924f;
246 
247 	function fixedLog(uint256 a) internal pure returns (int256 log) {
248 		int32 scale = 0;
249 		while (a > sqrt2) {
250 			a /= 2;
251 			scale++;
252 		}
253 		while (a <= sqrtdot5) {
254 			a *= 2;
255 			scale--;
256 		}
257 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
258 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
259 		// approximates the function log(1+x)-log(1-x)
260 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
261 		var z = (s*s) / one;
262 		return scale * ln2 +
263 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
264 				/one))/one))/one))/one))/one);
265 	}
266 
267 	int256 constant c2 =  0x02aaaaaaaaa015db0;
268 	int256 constant c4 = -0x000b60b60808399d1;
269 	int256 constant c6 =  0x0000455956bccdd06;
270 	int256 constant c8 = -0x000001b893ad04b3a;
271 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
272 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
273 		a -= scale*ln2;
274 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
275 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
276 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
277 		int256 z = (a*a) / one;
278 		int256 R = ((int256)(2) * one) +
279 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
280 		exp = (uint256) (((R + a) * one) / (R - a));
281 		if (scale >= 0)
282 			exp <<= scale;
283 		else
284 			exp >>= -scale;
285 		return exp;
286 	}
287 
288 	/*function destroy() external {
289 	    selfdestruct(owner);
290 	}*/
291 
292 	function () payable public {
293 		if (msg.value > 0)
294 			buy();
295 		else
296 			withdrawOld(msg.sender);
297 	}
298 }