1 pragma solidity ^0.4.13;
2 
3 contract Ownable 
4 
5 {
6 
7   address public owner;
8 
9  
10 
11   constructor(address _owner) public 
12 
13   {
14 
15     owner = _owner;
16 
17   }
18 
19  
20 
21   modifier onlyOwner() 
22 
23   {
24 
25     require(msg.sender == owner);
26 
27     _;
28 
29   }
30 
31  
32 
33   function transferOwnership(address newOwner) onlyOwner 
34 
35   {
36 
37     require(newOwner != address(0));      
38 
39     owner = newOwner;
40 
41   }
42 
43 }
44 
45 contract IBalance {
46 
47 	function distributeEthProfit(address profitMaker, uint256 amount) public  ;
48 
49 	function distributeTokenProfit (address profitMaker, address token, uint256 amount) public  ;
50 
51 	function modifyBalance(address _account, address _token, uint256 _amount, bool _addOrSub) public;
52 
53 	function getAvailableBalance(address _token, address _account) public constant returns (uint256);
54 
55 }
56 
57 contract IToken {
58 
59 
60 
61   /// @notice send `_value` token to `_to` from `msg.sender`
62 
63   /// @param _to The address of the recipient
64 
65   /// @param _value The amount of token to be transferred
66 
67   /// @return Whether the transfer was successful or not
68 
69   function transfer(address _to, uint256 _value) public returns (bool success);
70 
71 
72 
73   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
74 
75   /// @param _from The address of the sender
76 
77   /// @param _to The address of the recipient
78 
79   /// @param _value The amount of token to be transferred
80 
81   /// @return Whether the transfer was successful or not
82 
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
84 
85 
86 
87   function approve(address _spender, uint256 _value) public returns (bool success);
88 
89 
90 
91 }
92 
93 library SafeMath {
94 
95 
96 
97   /**
98 
99   * @dev Multiplies two numbers, throws on overflow.
100 
101   */
102 
103   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104 
105     if (a == 0) {
106 
107       return 0;
108 
109     }
110 
111     uint256 c = a * b;
112 
113     require(c / a == b);
114 
115     return c;
116 
117   }
118 
119 
120 
121   /**
122 
123   * @dev Integer division of two numbers, truncating the quotient.
124 
125   */
126 
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128 
129     require(b > 0); // Solidity automatically throws when dividing by 0
130 
131     uint256 c = a / b;
132 
133     return c;
134 
135   }
136 
137 
138 
139   /**
140 
141   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
142 
143   */
144 
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146 
147     require(b <= a);
148 
149     return a - b;
150 
151   }
152 
153 
154 
155   /**
156 
157   * @dev Adds two numbers, throws on overflow.
158 
159   */
160 
161   function add(uint256 a, uint256 b) internal pure returns (uint256) {
162 
163     uint256 c = a + b;
164 
165     require(c >= a);
166 
167     return c;
168 
169   }
170 
171 }
172 
173 contract BiLinkExchange is Ownable {
174 
175 	using SafeMath for uint256;
176 
177 
178 
179 	address public contractBalance;
180 
181 	uint256 public commissionRatio;//percentage
182 
183 
184 
185 	mapping (address => mapping ( bytes32 => uint256)) public account2Order2TradeAmount;
186 
187 
188 
189 	bool public isLegacy;//if true, not allow new trade,new deposit
190 
191 
192 
193 	event OnTrade(bytes32 guid, address tokenGive, address tokenGet, address maker, address taker, uint256 amountGive, uint256 amountGet, uint256 amountGetTrade, uint256 timestamp);
194 
195 	
196 
197 
198 
199 	constructor(address _owner, uint256 _commissionRatio) public Ownable(_owner) {
200 
201 		isLegacy= false;
202 
203 		commissionRatio= _commissionRatio;
204 
205 	}
206 
207 
208 
209 	function setThisContractAsLegacy() public onlyOwner {
210 
211 		isLegacy= true;
212 
213 	}
214 
215 
216 
217 	function setBalanceContract(address _contractBalance) public onlyOwner {
218 
219 		contractBalance= _contractBalance;
220 
221 	}
222 
223 
224 
225 	//_arr1:tokenGive,tokenGet,maker
226 
227 	//_arr2:amountGive,amountGet,amountGetTrade,expireTime
228 
229 	//_arr3:rMaker,sMaker
230 
231 	//parameters are from taker's perspective
232 
233 	function trade(address[] _arr1, uint256[] _arr2, bytes32 _guid, uint8 _vMaker, bytes32[] _arr3) public {
234 
235 		require(isLegacy== false&& now <= _arr2[3]);
236 
237 
238 
239 		uint256 _amountTokenGiveTrade= _arr2[0].mul(_arr2[2]).div(_arr2[1]);
240 
241 		require(_arr2[2]<= IBalance(contractBalance).getAvailableBalance(_arr1[1], _arr1[2])&&_amountTokenGiveTrade<= IBalance(contractBalance).getAvailableBalance(_arr1[0], msg.sender));
242 
243 
244 
245 		bytes32 _hash = keccak256(abi.encodePacked(this, _arr1[1], _arr1[0], _arr2[1], _arr2[0], _arr2[3]));
246 
247 		require(ecrecover(_hash, _vMaker, _arr3[0], _arr3[1]) ==  _arr1[2]&& account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[2])<= _arr2[1]);
248 
249 
250 
251 		uint256 _commission= _arr2[2].mul(commissionRatio).div(10000);
252 
253 		
254 
255 		IBalance(contractBalance).modifyBalance(msg.sender, _arr1[1], _arr2[2].sub(_commission), true);
256 
257 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[1], _arr2[2], false); 
258 
259 		
260 
261 		IBalance(contractBalance).modifyBalance(msg.sender, _arr1[0], _amountTokenGiveTrade, false);
262 
263 		IBalance(contractBalance).modifyBalance(_arr1[2], _arr1[0], _amountTokenGiveTrade, true);
264 
265 		account2Order2TradeAmount[_arr1[2]][_hash]= account2Order2TradeAmount[_arr1[2]][_hash].add(_arr2[2]);
266 
267 						
268 
269 		if(_arr1[1]== address(0)) {
270 
271 			IBalance(contractBalance).distributeEthProfit(msg.sender, _commission);
272 
273 		}
274 
275 		else {
276 
277 			IBalance(contractBalance).distributeTokenProfit(msg.sender, _arr1[1], _commission);
278 
279 		}
280 
281 
282 
283 		emit OnTrade(_guid, _arr1[0], _arr1[1], _arr1[2], msg.sender, _arr2[0], _arr2[1], _arr2[2], now);
284 
285 	}
286 
287 }