1 pragma solidity ^0.4.18;
2 
3 // If you wanna escape this contract REALLY FAST
4 // 1. open MEW/METAMASK
5 // 2. Put this as data: 0xb1e35242
6 // 3. send 150000+ gas
7 // That calls the getMeOutOfHere() method
8 // Remember, cashout fee is 10% :^)
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
141     }
142 
143 	function dividends(address _owner) public constant returns (uint256 amount) {
144 		return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
145 	}
146 
147 	function withdrawOld(address to) public {
148 		var balance = dividends(msg.sender);
149 		payouts[msg.sender] += (int256) (balance * PRECISION);
150 		totalPayouts += (int256) (balance * PRECISION);
151 		to.transfer(balance);
152 	}
153 
154 	function balance() internal constant returns (uint256 amount) {
155 		return this.balance - msg.value;
156 	}
157 	function reserve() public constant returns (uint256 amount) {
158 		return balance()
159 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
160 	}
161 
162 	function buy() internal {
163 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
164 			revert();
165 		var sender = msg.sender;
166 		// 10 % of the amount is used to pay holders.
167 		var fee = (uint)(msg.value / 10);
168 		
169 		// compute number of bought tokens
170 		var numEther = msg.value - fee;
171 		var numTokens = getTokensForEther(numEther);
172 
173 		var buyerfee = fee * PRECISION;
174 		if (totalSupply > 0) {
175 			// compute how the fee distributed to previous holders and buyer.
176 			// The buyer already gets a part of the fee as if he would buy each token separately.
177 			var holderreward =
178 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
179 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
180 			var holderfee = fee * holderreward;
181 			buyerfee -= holderfee;
182 		
183 			// Fee is distributed to all existing tokens before buying
184 			var feePerShare = holderfee / totalSupply;
185 			earningsPerShare += feePerShare;
186 		}
187 		// add numTokens to total supply
188 		totalSupply += numTokens;
189 		// add numTokens to balance
190 		balanceOfOld[sender] += numTokens;
191 		// fix payouts so that sender doesn't get old earnings for the new tokens.
192 		// also add its buyerfee
193 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
194 		payouts[sender] += payoutDiff;
195 		totalPayouts += payoutDiff;
196 	}
197 	
198 	function sell(uint256 amount) internal {
199 		var fees = (uint)(getEtherForTokens(amount)/10);
200 		var numEthers = getEtherForTokens(amount) - fees;
201 		// remove tokens
202 		totalSupply -= amount;
203 		balanceOfOld[msg.sender] -= amount;
204 		
205 		// fix payouts and put the ethers in payout
206 		var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
207 		payouts[msg.sender] -= payoutDiff;
208 		totalPayouts -= payoutDiff;
209 
210 	}
211 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
212 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
213 	}
214 
215 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
216 		if (tokens == totalSupply)
217 			return reserve();
218 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
219 	}
220 
221 	int256 constant one       = 0x10000000000000000;
222 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
223 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
224 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
225 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
226 	int256 constant c1        = 0x1ffffffffff9dac9b;
227 	int256 constant c3        = 0x0aaaaaaac16877908;
228 	int256 constant c5        = 0x0666664e5e9fa0c99;
229 	int256 constant c7        = 0x049254026a7630acf;
230 	int256 constant c9        = 0x038bd75ed37753d68;
231 	int256 constant c11       = 0x03284a0c14610924f;
232 
233 	function fixedLog(uint256 a) internal pure returns (int256 log) {
234 		int32 scale = 0;
235 		while (a > sqrt2) {
236 			a /= 2;
237 			scale++;
238 		}
239 		while (a <= sqrtdot5) {
240 			a *= 2;
241 			scale--;
242 		}
243 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
244 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
245 		// approximates the function log(1+x)-log(1-x)
246 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
247 		var z = (s*s) / one;
248 		return scale * ln2 +
249 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
250 				/one))/one))/one))/one))/one);
251 	}
252 
253 	int256 constant c2 =  0x02aaaaaaaaa015db0;
254 	int256 constant c4 = -0x000b60b60808399d1;
255 	int256 constant c6 =  0x0000455956bccdd06;
256 	int256 constant c8 = -0x000001b893ad04b3a;
257 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
258 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
259 		a -= scale*ln2;
260 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
261 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
262 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
263 		int256 z = (a*a) / one;
264 		int256 R = ((int256)(2) * one) +
265 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
266 		exp = (uint256) (((R + a) * one) / (R - a));
267 		if (scale >= 0)
268 			exp <<= scale;
269 		else
270 			exp >>= -scale;
271 		return exp;
272 	}
273 
274 	/*function destroy() external {
275 	    selfdestruct(owner);
276 	}*/
277 
278 	function () payable public {
279 		if (msg.value > 0)
280 			buy();
281 		else
282 			withdrawOld(msg.sender);
283 	}
284 }