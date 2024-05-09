1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5   function totalSupply () constant returns (uint256 _totalSupply);
6 
7   function balanceOf (address _owner) constant returns (uint256 balance);
8 
9   function transfer (address _to, uint256 _value) returns (bool success);
10 
11   function transferFrom (address _from, address _to, uint256 _value) returns (bool success);
12 
13   function approve (address _spender, uint256 _value) returns (bool success);
14 
15   function allowance (address _owner, address _spender) constant returns (uint256 remaining);
16 
17   event Transfer (address indexed _from, address indexed _to, uint256 _value);
18 
19   event Approval (address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract SafeMath {
23   uint256 constant private MAX_UINT256 =
24   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
25 
26   function safeAdd (uint256 x, uint256 y) constant internal returns (uint256 z) {
27     assert (x <= MAX_UINT256 - y);
28     return x + y;
29   }
30 
31   function safeSub (uint256 x, uint256 y) constant internal returns (uint256 z) {
32     assert (x >= y);
33     return x - y;
34   }
35 
36   function safeMul (uint256 x, uint256 y)  constant internal  returns (uint256 z) {
37     if (y == 0) return 0; // Prevent division by zero at the next line
38     assert (x <= MAX_UINT256 / y);
39     return x * y;
40   }
41   
42   
43    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a / b;
45     return c;
46   }
47   
48 }
49 
50 
51 contract AbstractToken is Token, SafeMath {
52 
53   function AbstractToken () {
54     // Do nothing
55   }
56  
57   function balanceOf (address _owner) constant returns (uint256 balance) {
58     return accounts [_owner];
59   }
60 
61   function transfer (address _to, uint256 _value) returns (bool success) {
62     if (accounts [msg.sender] < _value) return false;
63     if (_value > 0 && msg.sender != _to) {
64       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
65       accounts [_to] = safeAdd (accounts [_to], _value);
66     }
67     Transfer (msg.sender, _to, _value);
68     return true;
69   }
70 
71   function transferFrom (address _from, address _to, uint256 _value)  returns (bool success) {
72     if (allowances [_from][msg.sender] < _value) return false;
73     if (accounts [_from] < _value) return false;
74 
75     allowances [_from][msg.sender] =
76       safeSub (allowances [_from][msg.sender], _value);
77 
78     if (_value > 0 && _from != _to) {
79       accounts [_from] = safeSub (accounts [_from], _value);
80       accounts [_to] = safeAdd (accounts [_to], _value);
81     }
82     Transfer (_from, _to, _value);
83     return true;
84   }
85 
86  
87   function approve (address _spender, uint256 _value) returns (bool success) {
88     allowances [msg.sender][_spender] = _value;
89     Approval (msg.sender, _spender, _value);
90     return true;
91   }
92 
93   
94   function allowance (address _owner, address _spender) constant
95   returns (uint256 remaining) {
96     return allowances [_owner][_spender];
97   }
98 
99   /**
100    * Mapping from addresses of token holders to the numbers of tokens belonging
101    * to these token holders.
102    */
103   mapping (address => uint256) accounts;
104 
105   /**
106    * Mapping from addresses of token holders to the mapping of addresses of
107    * spenders to the allowances set by these token holders to these spenders.
108    */
109   mapping (address => mapping (address => uint256)) private allowances;
110 }
111 
112 
113 contract RebateCoin is AbstractToken {
114     
115      address public owner;
116      
117      uint256 tokenCount = 0;
118      
119      bool frozen = false;
120      
121      uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
122      
123 	uint public constant _decimals = (10**18);
124      
125     modifier onlyOwner() {
126 	    require(owner == msg.sender);
127 	    _;
128 	}
129      
130      function RebateCoin() {
131          owner = msg.sender;
132      }
133      
134      function totalSupply () constant returns (uint256 _totalSupply) {
135         return tokenCount;
136      }
137      
138     function name () constant returns (string result) {
139 		return "Rebate Coin";
140 	}
141 	
142 	function symbol () constant returns (string result) {
143 		return "RBC";
144 	}
145 	
146 	function decimals () constant returns (uint result) {
147         return 18;
148     }
149     
150     function transfer (address _to, uint256 _value) returns (bool success) {
151     if (frozen) return false;
152     else return AbstractToken.transfer (_to, _value);
153   }
154 
155   
156   function transferFrom (address _from, address _to, uint256 _value)
157     returns (bool success) {
158     if (frozen) return false;
159     else return AbstractToken.transferFrom (_from, _to, _value);
160   }
161 
162   
163   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
164     returns (bool success) {
165     if (allowance (msg.sender, _spender) == _currentValue)
166       return approve (_spender, _newValue);
167     else return false;
168   }
169 
170   function burnTokens (uint256 _value) returns (bool success) {
171     if (_value > accounts [msg.sender]) return false;
172     else if (_value > 0) {
173       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
174       tokenCount = safeSub (tokenCount, _value);
175       return true;
176     } else return true;
177   }
178 
179 
180   function createTokens (uint256 _value) returns (bool success) {
181 
182     if (_value > 0) {
183       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
184       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
185       tokenCount = safeAdd (tokenCount, _value);
186     }
187 
188     return true;
189   }
190 
191 
192   function setOwner (address _newOwner) {
193     require (msg.sender == owner);
194 
195     owner = _newOwner;
196   }
197 
198   function freezeTransfers () {
199     require (msg.sender == owner);
200 
201     if (!frozen) {
202       frozen = true;
203       Freeze ();
204     }
205   }
206 
207 
208   function unfreezeTransfers () {
209     require (msg.sender == owner);
210 
211     if (frozen) {
212       frozen = false;
213       Unfreeze ();
214     }
215   }
216 
217   event Freeze ();
218 
219   event Unfreeze ();
220 
221 }
222 
223 
224 contract TokenSale is RebateCoin  {
225  
226     enum State { PRE_ICO, ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }
227     
228     // 0 , 1 , 2 , 3 , 4 
229     
230     State public currentState = State.STOPPED;
231 
232     uint public tokenPrice = 1000000000000000; // wei , 0.0001 eth , 0.6 usd
233  
234     address public beneficiary;
235 	
236 	uint256 private BountyFound = 10 * (10**24);
237 	uint256 private SaleFound = 70 * (10**24);
238 	uint256 private PartnersFound = 5 * (10**24);
239 	uint256 private TeamFound = 15 * (10**24);
240 	
241 	uint256 public totalSold = 0;
242 	
243 	uint256 private _hardcap = 22800 ether;
244 	uint256 private _softcap = 62250 ether;
245 	
246 	bool private _allowedTransfers = true;
247 
248     modifier saleIsOn() {
249         require(currentState != State.STOPPED && currentState != State.CLOSED && totalSold < SaleFound);
250         _;
251     }
252     
253 	function TokenSale() {
254 	    owner = msg.sender;
255 	    beneficiary = msg.sender;
256 	}
257 	
258 	function setState(State _newState) public onlyOwner {
259 	    require(currentState != State.CLOSED);
260 	    currentState = _newState;
261 	}
262 	
263 	
264 	function allowTransfers() public onlyOwner {
265 		_allowedTransfers = true;		
266 	}
267 	
268 	function stopTransfers() public onlyOwner {
269 		_allowedTransfers = false;
270 	}
271 	
272 	function stopSale() public onlyOwner {
273 	    currentState = State.CLOSED;
274 	}
275 	
276     function setBeneficiaryAddress(address _new) public onlyOwner {
277         
278         beneficiary = _new;
279         
280     }
281     
282     function setTokenPrice(uint _price) public onlyOwner {
283         
284         tokenPrice = _price;
285         
286     }
287     
288 	
289 	function transferPayable(uint _amount) private returns (bool) {
290 	    
291 	    if(SaleFound < _amount) return false;
292 
293 	    return true;
294 	    
295 	}
296 	
297 	
298 	function buyRBCTokens() public saleIsOn() payable {
299 
300 	    uint tokens = get_tokens_count(msg.value);
301 		require(transferPayable(tokens));
302 		createTokens(tokens);
303 		if(_allowedTransfers) {
304 			beneficiary.transfer(msg.value);
305 			emit Transfer(owner, msg.sender, tokens);
306 	    }
307 	    
308 	}
309 	
310 	
311 	function get_tokens_count(uint _amount) private returns (uint) {
312 	    
313 	     uint currentPrice = tokenPrice;
314 	     uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;
315     	 return tokens;
316 	    
317 	}
318 	
319 	
320 	function() external payable {
321       buyRBCTokens();
322     }
323 	
324     
325 }