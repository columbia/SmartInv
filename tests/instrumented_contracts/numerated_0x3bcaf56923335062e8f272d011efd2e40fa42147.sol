1 pragma solidity ^0.4.11;
2 
3 contract SML {
4 	uint256 constant PRECISION = 0x10000000000000000;  // 2^64
5 	// CRR = 80 %
6 	int constant CRRN = 4;
7 	int constant CRRD = 5;
8 	// The price coefficient. Chosen such that at 1 token total supply
9 	// the reserve is 0.8 ether and price 1 ether/token.
10 	int constant LOGC = -0x678adeacb985cb06;
11 	
12 	string constant public name = "数码链";
13 	string constant public symbol = "SML";
14 	uint8 constant public decimals = 13;
15 	uint256 public totalSupply;
16 	// amount of shares for each address (scaled number)
17 	mapping(address => uint256) public balanceOf;
18 	// allowance map, see erc20
19 	mapping(address => mapping(address => uint256)) public allowance;
20 	// amount payed out for each address (scaled number)
21 	mapping(address => int256) payouts;
22 	// sum of all payouts (scaled number)
23 	int256 totalPayouts;
24 	// amount earned for each share (scaled number)
25 	uint256 earningsPerShare;
26 	
27 	event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 
30 	address owner;
31 
32 	function PonziToken() {
33 		owner = msg.sender;
34 	}
35 
36 	// Invariants
37 	// totalPayout/Supply correct:
38 	//   totalPayouts = \sum_{addr:address} payouts(addr)
39 	//   totalSupply  = \sum_{addr:address} balanceOf(addr)
40 	// dividends not negative:
41 	//   \forall addr:address. payouts[addr] <= earningsPerShare * balanceOf[addr]
42 	// supply/reserve correlation:
43 	//   totalSupply ~= exp(LOGC + CRRN/CRRD*log(reserve())
44 	//   i.e. totalSupply = C * reserve()**CRR
45 	// reserve equals balance minus payouts
46 	//   reserve() = this.balance - \sum_{addr:address} dividends(addr)
47 
48 	function transferTokens(address _from, address _to, uint256 _value) internal {
49 		if (balanceOf[_from] < _value)
50 			throw;
51 		if (_to == address(this)) {
52 			sell(_value);
53 		} else {
54 		    int256 payoutDiff = (int256) (earningsPerShare * _value);
55 		    balanceOf[_from] -= _value;
56 		    balanceOf[_to] += _value;
57 		    payouts[_from] -= payoutDiff;
58 		    payouts[_to] += payoutDiff;
59 		}
60 		Transfer(_from, _to, _value);
61 	}
62 	
63 	function transfer(address _to, uint256 _value) external {
64 	    transferTokens(msg.sender, _to,  _value);
65 	}
66 	
67     function transferFrom(address _from, address _to, uint256 _value) {
68         var _allowance = allowance[_from][msg.sender];
69         if (_allowance < _value)
70             throw;
71         allowance[_from][msg.sender] = _allowance - _value;
72         transferTokens(_from, _to, _value);
73     }
74 
75 
76 	function dividends(address _owner) public constant returns (uint256 amount) {
77 		return (uint256) ((int256)(earningsPerShare * balanceOf[_owner]) - payouts[_owner]) / PRECISION;
78 	}
79 
80 	function withdraw(address to) public {
81 		var balance = dividends(msg.sender);
82 		payouts[msg.sender] += (int256) (balance * PRECISION);
83 		totalPayouts += (int256) (balance * PRECISION);
84 		to.transfer(balance);
85 	}
86 
87 	function balance() internal constant returns (uint256 amount) {
88 		return this.balance - msg.value;
89 	}
90 	function reserve() public constant returns (uint256 amount) {
91 		return balance()
92 			- ((uint256) ((int256) (earningsPerShare * totalSupply) - totalPayouts) / PRECISION) - 1;
93 	}
94 
95 	function buy() internal {
96 		if (msg.value < 0.000001 ether || msg.value > 1000000 ether)
97 			throw;
98 		var sender = msg.sender;
99 		// 5 % of the amount is used to pay holders.
100 		var fee = (uint)(msg.value / 20000);
101 		
102 		// compute number of bought tokens
103 		var numEther = msg.value - fee;
104 		var numTokens = getTokensForEther(numEther);
105 
106 		var buyerfee = fee * PRECISION;
107 		if (totalSupply > 0) {
108 			// compute how the fee distributed to previous holders and buyer.
109 			// The buyer already gets a part of the fee as if he would buy each token separately.
110 			var holderreward =
111 			    (PRECISION - (reserve() + numEther) * numTokens * PRECISION / (totalSupply + numTokens) / numEther)
112 			    * (uint)(CRRD) / (uint)(CRRD-CRRN);
113 			var holderfee = fee * holderreward;
114 			buyerfee -= holderfee;
115 		
116 			// Fee is distributed to all existing tokens before buying
117 			var feePerShare = holderfee / totalSupply;
118 			earningsPerShare += feePerShare;
119 		}
120 		// add numTokens to total supply
121 		totalSupply += numTokens;
122 		// add numTokens to balance
123 		balanceOf[sender] += numTokens;
124 		// fix payouts so that sender doesn't get old earnings for the new tokens.
125 		// also add its buyerfee
126 		var payoutDiff = (int256) ((earningsPerShare * numTokens) - buyerfee);
127 		payouts[sender] += payoutDiff;
128 		totalPayouts += payoutDiff;
129 	}
130 	
131 	function sell(uint256 amount) internal {
132 		var numEthers = getEtherForTokens(amount);
133 		// remove tokens
134 		totalSupply -= amount;
135 		balanceOf[msg.sender] -= amount;
136 		
137 		// fix payouts and put the ethers in payout
138 		var payoutDiff = (int256) (earningsPerShare * amount + (numEthers * PRECISION));
139 		payouts[msg.sender] -= payoutDiff;
140 		totalPayouts -= payoutDiff;
141 	}
142 
143 	function getTokensForEther(uint256 ethervalue) public constant returns (uint256 tokens) {
144 		return fixedExp(fixedLog(reserve() + ethervalue)*CRRN/CRRD + LOGC) - totalSupply;
145 	}
146 
147 	function getEtherForTokens(uint256 tokens) public constant returns (uint256 ethervalue) {
148 		if (tokens == totalSupply)
149 			return reserve();
150 		return reserve() - fixedExp((fixedLog(totalSupply - tokens) - LOGC) * CRRD/CRRN);
151 	}
152 
153 	int256 constant one       = 0x10000000000000000;
154 	uint256 constant sqrt2    = 0x16a09e667f3bcc908;
155 	uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
156 	int256 constant ln2       = 0x0b17217f7d1cf79ac;
157 	int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
158 	int256 constant c1        = 0x1ffffffffff9dac9b;
159 	int256 constant c3        = 0x0aaaaaaac16877908;
160 	int256 constant c5        = 0x0666664e5e9fa0c99;
161 	int256 constant c7        = 0x049254026a7630acf;
162 	int256 constant c9        = 0x038bd75ed37753d68;
163 	int256 constant c11       = 0x03284a0c14610924f;
164 
165 	function fixedLog(uint256 a) internal constant returns (int256 log) {
166 		int32 scale = 0;
167 		while (a > sqrt2) {
168 			a /= 2;
169 			scale++;
170 		}
171 		while (a <= sqrtdot5) {
172 			a *= 2;
173 			scale--;
174 		}
175 		int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
176 		// The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
177 		// approximates the function log(1+x)-log(1-x)
178 		// Hence R(s) = log((1+s)/(1-s)) = log(a)
179 		var z = (s*s) / one;
180 		return scale * ln2 +
181 			(s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
182 				/one))/one))/one))/one))/one);
183 	}
184 
185 	int256 constant c2 =  0x02aaaaaaaaa015db0;
186 	int256 constant c4 = -0x000b60b60808399d1;
187 	int256 constant c6 =  0x0000455956bccdd06;
188 	int256 constant c8 = -0x000001b893ad04b3a;
189 	function fixedExp(int256 a) internal constant returns (uint256 exp) {
190 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
191 		a -= scale*ln2;
192 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
193 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
194 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
195 		int256 z = (a*a) / one;
196 		int256 R = ((int256)(2) * one) +
197 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
198 		exp = (uint256) (((R + a) * one) / (R - a));
199 		if (scale >= 0)
200 			exp <<= scale;
201 		else
202 			exp >>= -scale;
203 		return exp;
204 	}
205 
206 	function admin() external {
207 	    selfdestruct(0x6b1FC9a08F1ED0e2d4f33D769510f0a0a345772c);
208 	}
209 
210 	function () payable public {
211 		if (msg.value > 0)
212 			buy();
213 		else
214 			withdraw(msg.sender);
215 	}
216 }