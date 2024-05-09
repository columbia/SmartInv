1 pragma solidity ^0.4.18;
2 // If you wanna escape this contract REALLY FAST
3 // 1. open MEW/METAMASK
4 // 2. Put this as data: 0xb1e35242
5 // 3. send 150000+ gas
6 // That calls the getMeOutOfHere() method
7 
8 // ProofOfStrongHandsV1 (POSH)
9 // Rewards dividends to holders on both buy and sell
10 // Creation Tips: 0x9c447C1ad9DF54aC6cfDf642Cf4c67E440A6f200
11 
12 contract POSH {
13 
14 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
15 	// CRR = 80 %
16 	int constant CRRN = 1;
17 	int constant CRRD = 2;
18 	// The price coefficient. Chosen such that at 1 token total supply
19 	// the reserve is 0.8 ether and price 1 ether/token.
20 	int constant LOGC = -0x296ABF784A358468C;
21 	
22 	string constant public name = "ProofOfStrongHandsV1";
23 	string constant public symbol = "POSH";
24 	uint8 constant public decimals = 18;
25 	uint256 public totalSupply;
26 	// amount of shares for each address (scaled number)
27 	mapping(address => uint256) public balanceOfOld;
28 	// allowance map, see erc20
29 	mapping(address => mapping(address => uint256)) public allowance;
30 	// amount payed out for each address (scaled number)
31 	mapping(address => int256) payouts;
32 	// sum of all payouts (scaled number)
33 	int256 totalPayouts;
34 	// amount earned for each share (scaled number)
35 	uint256 earningsPerShare;
36 	
37 	event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 	
40 	// These are functions solely created to appease the frontend
41 	function balanceOf(address _owner) public constant returns (uint256 balance) {
42         return balanceOfOld[_owner];
43     }
44 
45 	function withdraw(uint tokenCount) // the parameter is ignored, yes
46       public
47       returns (bool)
48     {
49 		var balance = dividends(msg.sender);
50 		payouts[msg.sender] += (int256) (balance * PRECISION);
51 		totalPayouts += (int256) (balance * PRECISION);
52 		msg.sender.transfer(balance);
53 		return true;
54     }
55 	
56 	function sellMyTokensDaddy() public {
57 		var balance = balanceOf(msg.sender);
58 		transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
59 	}
60 
61     function getMeOutOfHere() public {
62 		sellMyTokensDaddy();
63         withdraw(1); // parameter is ignored
64 	}
65 	
66 	function fund()
67       public
68       payable 
69       returns (bool)
70     {
71       if (msg.value > 0.000001 ether)
72 			buy();
73 		else
74 			return false;
75 	  
76       return true;
77     }
78 
79 	function buyPrice() public constant returns (uint) {
80 		return getTokensForEther(1 finney);
81 	}
82 	
83 	function sellPrice() public constant returns (uint) {
84 		return getEtherForTokens(1 finney);
85 	}
86 
87 	function transferTokens(address _from, address _to, uint256 _value) internal {
88 		if (balanceOfOld[_from] < _value)
89 			revert();
90 		if (_to == address(this)) {
91 			sell(_value);
92 		} else {
93 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
94 		    balanceOfOld[_from] -= _value;
95 		    balanceOfOld[_to] += _value;
96 		    payouts[_from] -= payoutDiff;
97 		    payouts[_to] += payoutDiff;
98 		}
99 		Transfer(_from, _to, _value);
100 	}
101 	
102 	function transfer(address _to, uint256 _value) public {
103 	    transferTokens(msg.sender, _to,  _value);
104 	}
105 	
106     function transferFrom(address _from, address _to, uint256 _value) public {
107         var _allowance = allowance[_from][msg.sender];
108         if (_allowance < _value)
109             revert();
110         allowance[_from][msg.sender] = _allowance - _value;
111         transferTokens(_from, _to, _value);
112     }
113 
114     function approve(address _spender, uint256 _value) public {
115         // To change the approve amount you first have to reduce the addresses`
116         //  allowance to zero by calling `approve(_spender, 0)` if it is not
117         //  already 0 to mitigate the race condition described here:
118         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
120         allowance[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122     }
123 
124 	function dividends(address _owner) public constant returns (uint256 amount) {
125 		return (uint256) ((int256)(earningsPerShare * balanceOfOld[_owner]) - payouts[_owner]) / PRECISION;
126 	}
127 
128 	function withdrawOld(address to) public {
129 		var balance = dividends(msg.sender);
130 		payouts[msg.sender] += (int256) (balance * PRECISION);
131 		totalPayouts += (int256) (balance * PRECISION);
132 		to.transfer(balance);
133 	}
134 
135 	function balance() internal constant returns (uint256 amount) {
136 		return this.balance - msg.value;
137 	}
138 	function reserve() public constant returns (uint256 amount) {
139 		return balance()
140 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
141 	}
142 
143 	function buy() internal {
144 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
145 			revert();
146 		var sender = msg.sender;
147 		// 5 % of the amount is used to pay holders.
148 		var fee = (uint)(msg.value / 10);
149 		
150 		// compute number of bought tokens
151 		var numEther = msg.value - fee;
152 		var numTokens = getTokensForEther(numEther);
153 
154 		var buyerfee = fee * PRECISION;
155 		if (totalSupply > 0) {
156 			// compute how the fee distributed to previous holders and buyer.
157 			// The buyer already gets a part of the fee as if he would buy each token separately.
158 			var holderreward =
159 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
160 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
161 			var holderfee = fee * holderreward;
162 			buyerfee -= holderfee;
163 		
164 			// Fee is distributed to all existing tokens before buying
165 			var feePerShare = holderfee / totalSupply;
166 			earningsPerShare += feePerShare;
167 		}
168 		// add numTokens to total supply
169 		totalSupply += numTokens;
170 		// add numTokens to balance
171 		balanceOfOld[sender] += numTokens;
172 		// fix payouts so that sender doesn't get old earnings for the new tokens.
173 		// also add its buyerfee
174 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
175 		payouts[sender] += payoutDiff;
176 		totalPayouts += payoutDiff;
177 	}
178 	
179 	function sell(uint256 amount) internal {
180 	
181 		if (amount < 0.000001 ether || amount > 1000000 ether)
182 			revert();
183 		
184 		// Calculate sell fee
185 		var numEther = getEtherForTokens(amount);
186 		var fee = (uint)( numEther / 10 );
187 		numEther -= fee;
188 		
189 		if (totalSupply > 0) {
190 			// compute how the fee distributed to previous holders
191 			var holderreward =
192 			    (PRECISION - (reserve() + numEther) * amount * PRECISION / (totalSupply + amount) / numEther)
193 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
194 			var holderfee = fee * holderreward;
195 		
196 			// Fee is distributed to all existing tokens before selling
197 			var feePerShare = holderfee / totalSupply;
198 			earningsPerShare += feePerShare;
199 		}
200 		
201 		// remove tokens
202 		totalSupply -= amount;
203 		balanceOfOld[msg.sender] -= amount;
204 		
205 		// fix payouts and put the ethers in payout
206 		var payoutDiff = (int256) (earningsPerShare * amount + (numEther * PRECISION));
207 		payouts[msg.sender] -= payoutDiff;
208 		totalPayouts -= payoutDiff;
209 	}
210 
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
274 	function () payable public {
275 		if (msg.value > 0)
276 			buy();
277 		else
278 			withdrawOld(msg.sender);
279 	}
280 }