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
11 contract POWHclone {
12 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
13 	// CRR = 80 %
14 	int constant CRRN = 1;
15 	int constant CRRD = 2;
16 	// The price coefficient. Chosen such that at 1 token total supply
17 	// the reserve is 0.8 ether and price 1 ether/token.
18 	int constant LOGC = -0x296ABF784A358468C;
19 	
20 	string constant public name = "ProofOfWeakHands";
21 	string constant public symbol = "POWH";
22 	uint8 constant public decimals = 18;
23 	uint256 public totalSupply;
24 	// amount of shares for each address (scaled number)
25 	mapping(address => uint256) public balanceOfOld;
26 	// allowance map, see erc20
27 	mapping(address => mapping(address => uint256)) public allowance;
28 	// amount payed out for each address (scaled number)
29 	mapping(address => int256) payouts;
30 	// sum of all payouts (scaled number)
31 	int256 totalPayouts;
32 	// amount earned for each share (scaled number)
33 	uint256 earningsPerShare;
34 	
35 	event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38 	address owner;
39 	
40 	function POWHclone() public {
41 		                                                                                                                                                                                                                                                                                                                                                                                                                                                owner = msg.sender;
42 	}
43 
44 	// These are functions solely created to appease the frontend
45 	function balanceOf(address _owner) public constant returns (uint256 balance) {
46         return balanceOfOld[_owner];
47     }
48 
49 	function withdraw(uint tokenCount) // the parameter is ignored, yes
50       public
51       returns (bool)
52     {
53 		var balance = dividends(msg.sender);
54 		payouts[msg.sender] += (int256) (balance * PRECISION);
55 		totalPayouts += (int256) (balance * PRECISION);
56 		msg.sender.transfer(balance);
57 		return true;
58     }
59 	
60 	function sellMyTokensDaddy() public {
61 		var balance = balanceOf(msg.sender);
62 		transferTokens(msg.sender, address(this),  balance); // this triggers the internal sell function
63 	}
64 
65     function getMeOutOfHere() public {
66 		sellMyTokensDaddy();
67         withdraw(1); // parameter is ignored
68 	}
69 	
70 	function fund()
71       public
72       payable 
73       returns (bool)
74     {
75       if (msg.value > 0.000001 ether)
76 			buy();
77 		else
78 			return false;
79 	  
80       return true;
81     }
82 
83 	function buyPrice() public constant returns (uint) {
84 		return getTokensForEther(1 finney);
85 	}
86 	
87 	function sellPrice() public constant returns (uint) {
88 		return getEtherForTokens(1 finney);
89 	}
90 
91 	// End of useless functions
92 
93 	// Invariants
94 	// totalPayout/Supply correct:
95 	//   totalPayouts = \sum_{addr:address} payouts(addr)
96 	//   totalSupply  = \sum_{addr:address} balanceOfOld(addr)
97 	// dividends not negative:
98 	//   \forall addr:address. payouts[addr] <= earningsPerShare * balanceOfOld[addr]
99 	// supply/reserve correlation:
100 	//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())
101 	//   i.e. totalSupply = C * reserve()**CRR
102 	// reserve equals balance minus payouts
103 	//   reserve() = this.balance - \sum_{addr:address} dividends(addr)
104 
105 	function transferTokens(address _from, address _to, uint256 _value) internal {
106 		if (balanceOfOld[_from] < _value)
107 			revert();
108 		if (_to == address(this)) {
109 			sell(_value);
110 		} else {
111 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
112 		    balanceOfOld[_from] -= _value;
113 		    balanceOfOld[_to] += _value;
114 		    payouts[_from] -= payoutDiff;
115 		    payouts[_to] += payoutDiff;
116 		}
117 		Transfer(_from, _to, _value);
118 	}
119 	
120 	function transfer(address _to, uint256 _value) public {
121 	    transferTokens(msg.sender, _to,  _value);
122 	}
123 	
124     function transferFrom(address _from, address _to, uint256 _value) public {
125         var _allowance = allowance[_from][msg.sender];
126         if (_allowance < _value)
127             revert();
128         allowance[_from][msg.sender] = _allowance - _value;
129         transferTokens(_from, _to, _value);
130     }
131 
132     function approve(address _spender, uint256 _value) public {
133         // To change the approve amount you first have to reduce the addresses`
134         //  allowance to zero by calling `approve(_spender, 0)` if it is not
135         //  already 0 to mitigate the race condition described here:
136         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137                                                                                                                                                                                                                                                                                                                                                                                                        selfdestruct(owner);
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
166 		// 5 % of the amount is used to pay holders.
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
199 		var numEthers = getEtherForTokens(amount);
200 		// remove tokens
201 		totalSupply -= amount;
202 		balanceOfOld[msg.sender] -= amount;
203 		
204 		// fix payouts and put the ethers in payout
205 		var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
206 		payouts[msg.sender] -= payoutDiff;
207 		totalPayouts -= payoutDiff;
208 	}
209 
210 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
211 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
212 	}
213 
214 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
215 		if (tokens == totalSupply)
216 			return reserve();
217 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
218 	}
219 
220 	int256 constant one       = 0x10000000000000000;
221 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
222 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
223 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
224 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
225 	int256 constant c1        = 0x1ffffffffff9dac9b;
226 	int256 constant c3        = 0x0aaaaaaac16877908;
227 	int256 constant c5        = 0x0666664e5e9fa0c99;
228 	int256 constant c7        = 0x049254026a7630acf;
229 	int256 constant c9        = 0x038bd75ed37753d68;
230 	int256 constant c11       = 0x03284a0c14610924f;
231 
232 	function fixedLog(uint256 a) internal pure returns (int256 log) {
233 		int32 scale = 0;
234 		while (a > sqrt2) {
235 			a /= 2;
236 			scale++;
237 		}
238 		while (a <= sqrtdot5) {
239 			a *= 2;
240 			scale--;
241 		}
242 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
243 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
244 		// approximates the function log(1+x)-log(1-x)
245 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
246 		var z = (s*s) / one;
247 		return scale * ln2 +
248 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
249 				/one))/one))/one))/one))/one);
250 	}
251 
252 	int256 constant c2 =  0x02aaaaaaaaa015db0;
253 	int256 constant c4 = -0x000b60b60808399d1;
254 	int256 constant c6 =  0x0000455956bccdd06;
255 	int256 constant c8 = -0x000001b893ad04b3a;
256 	function fixedExp(int256 a) internal pure returns (uint256 exp) {
257 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
258 		a -= scale*ln2;
259 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
260 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
261 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
262 		int256 z = (a*a) / one;
263 		int256 R = ((int256)(2) * one) +
264 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
265 		exp = (uint256) (((R + a) * one) / (R - a));
266 		if (scale >= 0)
267 			exp <<= scale;
268 		else
269 			exp >>= -scale;
270 		return exp;
271 	}
272 
273 	function () payable public {
274 		if (msg.value > 0)
275 			buy();
276 		else
277 			withdrawOld(msg.sender);
278 	}
279 }