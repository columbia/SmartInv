1 pragma solidity ^0.4.13;
2 
3 contract IToken {
4 
5 
6 
7   /// @notice send `_value` token to `_to` from `msg.sender`
8 
9   /// @param _to The address of the recipient
10 
11   /// @param _value The amount of token to be transferred
12 
13   /// @return Whether the transfer was successful or not
14 
15   function transfer(address _to, uint256 _value) public returns (bool success);
16 
17 
18 
19   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20 
21   /// @param _from The address of the sender
22 
23   /// @param _to The address of the recipient
24 
25   /// @param _value The amount of token to be transferred
26 
27   /// @return Whether the transfer was successful or not
28 
29   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31 
32 
33   function approve(address _spender, uint256 _value) public returns (bool success);
34 
35 
36 
37 }
38 
39 contract Ownable 
40 
41 {
42 
43   address public owner;
44 
45  
46 
47   constructor(address _owner) public 
48 
49   {
50 
51     owner = _owner;
52 
53   }
54 
55  
56 
57   modifier onlyOwner() 
58 
59   {
60 
61     require(msg.sender == owner);
62 
63     _;
64 
65   }
66 
67  
68 
69   function transferOwnership(address newOwner) onlyOwner 
70 
71   {
72 
73     require(newOwner != address(0));      
74 
75     owner = newOwner;
76 
77   }
78 
79 }
80 
81 contract BiLinkExchange is Ownable {
82 
83 	using SafeMath for uint256;
84 
85 
86 
87 	address public contractBalance;
88 
89 	uint256 public commissionRatio;//percentage
90 
91 
92 
93 	mapping (address => mapping ( bytes32 => uint256)) public account2Order2TradeAmount;
94 
95 
96 
97 	bool public isLegacy;//if true, not allow new trade,new deposit
98 
99 
100 
101 	event OnTrade(address tokenGive, address tokenGet, address maker, address taker, uint256 amountGive, uint256 amountGet, uint256 amountGetTrade, uint256 timestamp);
102 
103 	
104 
105 
106 
107 	constructor(address _owner, uint256 _commissionRatio) public Ownable(_owner) {
108 
109 		isLegacy= false;
110 
111 		commissionRatio= _commissionRatio;
112 
113 	}
114 
115 
116 
117 	function setThisContractAsLegacy() public onlyOwner {
118 
119 		isLegacy= true;
120 
121 	}
122 
123 
124 
125 	function setBalanceContract(address _contractBalance) public onlyOwner {
126 
127 		contractBalance= _contractBalance;
128 
129 	}
130 
131 
132 
133 	//_arr1:tokenGive,tokenGet,maker,taker
134 
135 	//_arr2:amountGive,amountGet,amountGetTrade,expireTime
136 
137 	//_arr3:rMaker,sMaker,rTaker,sTaker
138 
139 	//parameters are from taker's perspective
140 
141 	function trade(address[] _arr1, uint256[] _arr2, uint8 _vMaker,uint8 _vTaker, bytes32[] _arr3) public {
142 
143 		require(isLegacy== false&& now <= _arr2[3]);
144 
145 
146 
147 		uint256 _amountTokenGiveTrade= _arr2[0].mul(_arr2[2]).div(_arr2[1]);
148 
149 		require(_arr2[2]<= IBalance(contractBalance).getAvailableBalance(_arr1[1], _arr1[2])&&_amountTokenGiveTrade<= IBalance(contractBalance).getAvailableBalance(_arr1[0], _arr1[3]));
150 
151 
152 
153 		bytes32 _hash = keccak256(abi.encodePacked(this, _arr1[1], _arr1[0], _arr2[1], _arr2[0], _arr2[3]));
154 
155 		require(ecrecover(_hash, _vMaker, _arr3[0], _arr3[1]) ==  _arr1[2]
156 
157 			&& ecrecover(keccak256(abi.encodePacked(this, _arr1[0], _arr1[1], _arr2[0], _arr2[1], _arr2[2], _arr1[2], _arr2[3])), _vTaker, _arr3[2], _arr3[3]) ==  _arr1[3]
158 
159 			&& account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[2])<= _arr2[1]);
160 
161 
162 
163 		uint256 _commission= _arr2[2].mul(commissionRatio).div(10000);
164 
165 		
166 
167 		IBalance(contractBalance).modifyBalance(_arr1[3], _arr1[1], _arr2[2].sub(_commission), true);
168 
169 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[1], _arr2[2], false); 
170 
171 		
172 
173 		IBalance(contractBalance).modifyBalance(_arr1[3], _arr1[0], _amountTokenGiveTrade, false);
174 
175 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[0], _amountTokenGiveTrade, true);
176 
177 		account2Order2TradeAmount[_arr1[2]][_hash]= account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[2]);
178 
179 						
180 
181 		if(_arr1[1]== address(0)) {
182 
183 			IBalance(contractBalance).distributeEthProfit(_arr1[3], _commission);
184 
185 		}
186 
187 		else {
188 
189 			IBalance(contractBalance).distributeTokenProfit(_arr1[3], _arr1[1], _commission);
190 
191 		}
192 
193 
194 
195 		emit OnTrade(_arr1[0], _arr1[1], _arr1[2], _arr1[3], _arr2[0], _arr2[1], _arr2[2], now);
196 
197 	}
198 
199 }
200 
201 contract IBalance {
202 
203 	function distributeEthProfit(address profitMaker, uint256 amount) public  ;
204 
205 	function distributeTokenProfit (address profitMaker, address token, uint256 amount) public  ;
206 
207 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public;
208 
209 	function getAvailableBalance(address _token, address _account) public constant returns (uint256);
210 
211 }
212 
213 library SafeMath {
214 
215 
216 
217   /**
218 
219   * @dev Multiplies two numbers, throws on overflow.
220 
221   */
222 
223   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224 
225     if (a == 0) {
226 
227       return 0;
228 
229     }
230 
231     uint256 c = a * b;
232 
233     require(c / a == b);
234 
235     return c;
236 
237   }
238 
239 
240 
241   /**
242 
243   * @dev Integer division of two numbers, truncating the quotient.
244 
245   */
246 
247   function div(uint256 a, uint256 b) internal pure returns (uint256) {
248 
249     require(b > 0); // Solidity automatically throws when dividing by 0
250 
251     uint256 c = a / b;
252 
253     return c;
254 
255   }
256 
257 
258 
259   /**
260 
261   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
262 
263   */
264 
265   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266 
267     require(b <= a);
268 
269     return a - b;
270 
271   }
272 
273 
274 
275   /**
276 
277   * @dev Adds two numbers, throws on overflow.
278 
279   */
280 
281   function add(uint256 a, uint256 b) internal pure returns (uint256) {
282 
283     uint256 c = a + b;
284 
285     require(c >= a);
286 
287     return c;
288 
289   }
290 
291 }