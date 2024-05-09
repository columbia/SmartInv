1 pragma solidity ^0.4.23;
2 
3 contract Admin {
4 
5 	address public	admin;
6 	address public	feeAccount; // address feeAccount, which will receive fee.
7 	address public 	nextVersionAddress; // this is next address exchange
8 	bool 	public	orderEnd; // this is var use when Admin want close exchange
9 	string  public 	version; // number version example 1.0, test_1.0
10 	uint 	public	feeTake; //percentage times (1 ether)
11 	bool	public	pause;
12 
13 	modifier assertAdmin() {
14 		if ( msg.sender != admin ) {
15 			revert();
16 		}
17 		_;
18 	}
19 
20 	/*
21 	*	This is function, is needed to change address admin.
22 	*/
23 	function setAdmin( address _admin ) assertAdmin public {
24 		admin = _admin;
25 	}
26 	function setPause (bool state) assertAdmin public {
27 		pause = state;
28 	}
29 	/*
30 	* 	This is function, is needed to change version smart-contract.
31 	*/
32 	function setVersion(string _version) assertAdmin public {
33 		version = _version;	
34 	}
35 
36 	/*
37 	* 	This is function, is needed to set address, next smart-contracts.
38 	*/
39 	function setNextVersionAddress(address _nextVersionAddress) assertAdmin public{
40 		nextVersionAddress = _nextVersionAddress;	
41 	}
42 
43 	/*
44 	* 	This is function, is needed to stop, news orders.
45 	*	Can not turn off it.
46 	*/
47 	function setOrderEnd() assertAdmin public {
48 		orderEnd = true;
49 	}
50 
51 	/*
52 	*	This is function, is needed to change address feeAccount.
53 	*/
54 	function setFeeAccount( address _feeAccount ) assertAdmin public {
55 		feeAccount = _feeAccount;
56 	}
57 
58 	/*
59 	* 	This is function, is needed to set new fee.
60 	*	Can only be changed down.
61 	*/
62 	
63 	function setFeeTake( uint _feeTake ) assertAdmin public {
64 		feeTake = _feeTake;
65 	}
66 }
67 
68 contract SafeMath {
69 
70 	function safeMul( uint a, uint b ) pure internal returns ( uint ) {
71 		
72 		uint 	c;
73 		
74 		c = a * b;
75 		assert( a == 0 || c / a == b );
76 		return c;
77 	}
78 
79 	function safeSub( uint a, uint b ) pure internal returns ( uint ) {
80 		
81 		assert( b <= a );
82 		return a - b;
83 	}
84 
85 	function safeAdd( uint a, uint b ) pure internal returns ( uint ) {
86 		
87 		uint 	c;
88 	
89 		c = a + b;
90 		assert( c >= a && c >= b );
91 		return c;
92 	}
93 }
94 
95 /*
96 * Interface ERC20
97 */
98 
99 contract Token {
100 
101 	function transfer( address _to, uint256 _value ) public returns ( bool success );
102 	
103 	function transferFrom( address _from, address _to, uint256 _value ) public returns ( bool success );
104 	
105 	event Transfer( address indexed _from, address indexed _to, uint256 _value );
106 
107 }
108 
109 contract Exchange is SafeMath, Admin {
110 
111 	mapping( address => mapping( address => uint )) public tokens;
112 	mapping( address => mapping( bytes32 => bool )) public orders;
113 	mapping( bytes32 => mapping( address => uint )) public ordersBalance;
114 
115 	event Deposit( address token, address user, uint amount, uint balance );
116 	event Withdraw( address token, address user, uint amount, uint balance );
117 	event Order( address user, address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce );
118 	event OrderCancel( address user, address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce );
119 	event Trade( address makeAddress, address tokenMake, uint amountGiveMake, address takeAddress, address tokenTake, uint quantityTake, uint feeTakeXfer, uint balanceOrder );
120 	event HashOutput(bytes32 hash);
121 
122 	constructor( address _admin, address _feeAccount, uint _feeTake, string _version) public {
123 		admin = _admin;
124 		feeAccount = _feeAccount;
125 		feeTake = _feeTake;
126 		orderEnd = false;
127 		version = _version;
128 		pause = false;
129 	}
130 
131  	function 	depositEth() payable public {
132  		assertQuantity( msg.value );
133 		tokens[0][msg.sender] = safeAdd( tokens[0][msg.sender], msg.value );
134 		emit Deposit( 0, msg.sender, msg.value, tokens[0][msg.sender] );
135  	}
136 
137 	function 	withdrawEth( uint amount ) public {
138 		assertQuantity( amount );
139 		tokens[0][msg.sender] = safeSub( tokens[0][msg.sender], amount );
140 		msg.sender.transfer( amount );
141 		emit Withdraw( 0, msg.sender, amount, tokens[0][msg.sender] );
142 	}
143 
144 	function 	depositToken( address token, uint amount ) public {
145 		assertToken( token );
146 		assertQuantity( amount );
147 		tokens[token][msg.sender] = safeAdd( tokens[token][msg.sender], amount );
148 		if ( Token( token ).transferFrom( msg.sender, this, amount ) == false ) {
149 			revert();
150 		}
151 	    emit	Deposit( token, msg.sender, amount , tokens[token][msg.sender] );
152 	}
153 
154 	function 	withdrawToken( address token, uint amount ) public {
155 		assertToken( token );
156 		assertQuantity( amount );
157 		if ( Token( token ).transfer( msg.sender, amount ) == false ) {
158 			revert();
159 		}
160 		tokens[token][msg.sender] = safeSub( tokens[token][msg.sender], amount ); // уязвимость двойного входа?
161 	    emit Withdraw( token, msg.sender, amount, tokens[token][msg.sender] );
162 	}
163 	
164 	function 	order( address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce ) public {
165 		bytes32 	hash;
166 
167 		assertQuantity( amountTake );
168 		assertQuantity( amountMake );
169 		assertCompareBalance( amountMake, tokens[tokenMake][msg.sender] );
170 		if ( orderEnd == true )
171 			revert();
172 		
173 		hash = keccak256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
174 		
175 		orders[msg.sender][hash] = true;
176 		tokens[tokenMake][msg.sender] = safeSub( tokens[tokenMake][msg.sender], amountMake );
177 		ordersBalance[hash][msg.sender] = amountMake;
178 
179 		emit HashOutput(hash);
180 		emit Order( msg.sender, tokenTake, amountTake, tokenMake, amountMake, nonce );
181 	}
182 
183 	function 	orderCancel( address tokenTake, uint amountTake, address tokenMake, uint amountMake, uint nonce ) public {
184 		bytes32 	hash;
185 
186 		assertQuantity( amountTake );
187 		assertQuantity( amountMake );
188 
189 		hash = keccak256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
190 		orders[msg.sender][hash] = false;
191 
192 		tokens[tokenMake][msg.sender] = safeAdd( tokens[tokenMake][msg.sender], ordersBalance[hash][msg.sender]);
193 		ordersBalance[hash][msg.sender] = 0;
194 		emit OrderCancel( msg.sender, tokenTake, amountTake, tokenMake, amountMake, nonce );
195 	}
196 
197 	function 	trade( address tokenTake, address tokenMake, uint amountTake, uint amountMake, uint nonce, address makeAddress, uint quantityTake ) public { 
198 
199 		bytes32 	hash;
200 		uint 		amountGiveMake;
201 
202 		assertPause();
203 		assertQuantity( quantityTake );
204 
205 		hash = keccak256( this, tokenTake, tokenMake, amountTake, amountMake, nonce );
206 		assertOrders( makeAddress, hash );
207 		
208 		amountGiveMake = safeMul( amountMake, quantityTake ) / amountTake;
209 		assertCompareBalance ( amountGiveMake, ordersBalance[hash][makeAddress] );
210 	
211 		tradeBalances( tokenTake, tokenMake, amountTake, amountMake, makeAddress, quantityTake, hash);
212 		emit HashOutput(hash);
213 	}
214 
215 	function 	tradeBalances( address tokenGet, address tokenGive, uint amountGet, uint amountGive, address user, uint amount, bytes32 hash) private {
216 		uint 		feeTakeXfer;
217 		uint 		amountGiveMake;
218 
219 		feeTakeXfer = safeMul( amount, feeTake ) / ( 1 ether );
220 		amountGiveMake = safeMul( amountGive, amount ) / amountGet; 
221 
222 		tokens[tokenGet][msg.sender] = safeSub( tokens[tokenGet][msg.sender], safeAdd( amount, feeTakeXfer ) );
223 		tokens[tokenGet][user] = safeAdd( tokens[tokenGet][user], amount );
224 		tokens[tokenGet][feeAccount] = safeAdd( tokens[tokenGet][feeAccount], feeTakeXfer );
225 		ordersBalance[hash][user] = safeSub( ordersBalance[hash][user], safeMul( amountGive, amount ) / amountGet );
226 		tokens[tokenGive][msg.sender] = safeAdd( tokens[tokenGive][msg.sender], safeMul( amountGive, amount ) / amountGet );
227 
228 		emit Trade( user, tokenGive, amountGiveMake, msg.sender, tokenGet, amount, feeTakeXfer, ordersBalance[hash][user] );
229 		emit HashOutput(hash);
230 	}
231 
232 	function 	assertQuantity( uint amount ) pure private {
233 		if ( amount == 0 ) {
234 			revert();
235 		}
236 	}
237 
238 	function	assertPause() view private {
239 		if ( pause == true ) {
240 			revert();
241 		}	
242 	}
243 
244 	function 	assertToken( address token ) pure private { 
245 		if ( token == 0 ) {
246 			revert();
247 		}
248 	}
249 
250 
251 	function 	assertOrders( address makeAddress, bytes32 hash ) view private {
252 		if ( orders[makeAddress][hash] == false ) {
253 			revert();
254 		}
255 	}
256 
257 	function 	assertCompareBalance( uint a, uint b ) pure private {
258 		if ( a > b ) {
259 			revert();
260 		}
261 	}
262 }