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
113 contract TerraEcoToken is AbstractToken {
114     
115      address public owner;
116      
117      uint256 tokenCount = 0;
118      
119      bool frozen = false;
120      
121      uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
122      
123     uint public constant _decimals = (10**8);
124      
125     modifier onlyOwner() {
126 	    require(owner == msg.sender);
127 	    _;
128 	}
129      
130     function TerraEcoToken() {
131          owner = msg.sender;
132          createTokens(200 * (10**14));
133      }
134      
135     function totalSupply () constant returns (uint256 _totalSupply) {
136         return tokenCount;
137      }
138      
139     function name () constant returns (string result) {
140             return "TerraEcoToken";
141     }
142 	
143     function symbol () constant returns (string result) {
144             return "TET";
145     }
146 	
147     function decimals () constant returns (uint result) {
148         return 8;
149     }
150     
151     function transfer (address _to, uint256 _value) returns (bool success) {
152     if (frozen) return false;
153     else return AbstractToken.transfer (_to, _value);
154   }
155 
156   
157   function transferFrom (address _from, address _to, uint256 _value)
158     returns (bool success) {
159     if (frozen) return false;
160     else return AbstractToken.transferFrom (_from, _to, _value);
161   }
162 
163   
164   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
165     returns (bool success) {
166     if (allowance (msg.sender, _spender) == _currentValue)
167       return approve (_spender, _newValue);
168     else return false;
169   }
170 
171   function burnTokens (uint256 _value) returns (bool success) {
172     if (_value > accounts [msg.sender]) return false;
173     else if (_value > 0) {
174       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
175       tokenCount = safeSub (tokenCount, _value);
176       return true;
177     } else return true;
178   }
179 
180 
181   function createTokens (uint256 _value) returns (bool success) {
182     require (msg.sender == owner);
183 
184     if (_value > 0) {
185       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
186       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
187       tokenCount = safeAdd (tokenCount, _value);
188     }
189 
190     return true;
191   }
192 
193 
194   function setOwner (address _newOwner) {
195     require (msg.sender == owner);
196 
197     owner = _newOwner;
198   }
199 
200   function freezeTransfers () {
201     require (msg.sender == owner);
202 
203     if (!frozen) {
204       frozen = true;
205       Freeze ();
206     }
207   }
208 
209 
210   function unfreezeTransfers () {
211     require (msg.sender == owner);
212 
213     if (frozen) {
214       frozen = false;
215       Unfreeze ();
216     }
217   }
218 
219   event Freeze ();
220 
221   event Unfreeze ();
222 
223 }
224 
225 
226 contract TokenSale is TerraEcoToken  {
227  
228     enum State { ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }
229     
230     // 0 , 1 , 2 , 3 
231     
232     State public currentState = State.ICO_FIRST;
233 
234     uint public tokenPrice = 250000000000000; // wei , 0.00025 eth , 0.12 usd
235     uint public _minAmount = 0.025 ether;
236 	
237     address public beneficiary;
238 	
239     uint256 public totalSold = 0;
240 
241     uint256 private _hardcap = 30000 ether;
242     uint256 private _softcap = 3750 ether;
243 	
244     bool private _allowedTransfers = true;
245 	
246     modifier minAmount() {
247         require(msg.value >= _minAmount);
248         _;
249     }
250     
251     modifier saleIsOn() {
252         require(currentState != State.STOPPED && currentState != State.CLOSED);
253         _;
254     }
255     
256     function TokenSale() {
257         owner = msg.sender;
258         beneficiary = msg.sender;
259     }
260 
261     function setState(State _newState) public onlyOwner {
262         require(currentState != State.CLOSED);
263         currentState = _newState;
264     }
265 
266     function setMinAmount(uint _new) public onlyOwner {
267 
268         _minAmount = _new;
269 
270     }
271 
272     function allowTransfers() public onlyOwner {
273             _allowedTransfers = true;		
274     }
275 
276     function stopTransfers() public onlyOwner {
277         
278             _allowedTransfers = false;
279             
280     }
281 
282     function stopSale() public onlyOwner {
283         
284         currentState = State.CLOSED;
285         
286     }
287 	
288     function setBeneficiaryAddress(address _new) public onlyOwner {
289         
290         beneficiary = _new;
291         
292     }
293 
294 
295     function transferPayable(address _address, uint _amount) private returns (bool) {
296 
297         accounts[_address] = safeAdd(accounts[_address], _amount);
298         accounts[owner] = safeSub(accounts[owner], _amount);
299 
300         totalSold = safeAdd(totalSold, _amount);
301 
302 
303         return true;
304 
305     }
306 	
307 	
308     function getTokens() public saleIsOn() minAmount() payable {
309 
310 
311         uint tokens = get_tokens_count(msg.value);
312         require(transferPayable(msg.sender , tokens));
313         if(_allowedTransfers) { beneficiary.transfer(msg.value); }
314 
315     }
316 
317 	
318     function get_tokens_count(uint _amount) private returns (uint) {
319 
320          uint currentPrice = tokenPrice;
321          uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;
322          tokens = safeAdd(tokens, get_bounty_count(tokens));
323          return tokens;
324 
325     }
326 	
327 	
328     function get_bounty_count(uint _tokens) private returns (uint) {
329 
330         uint bonuses = 0;
331 
332 
333         if(currentState == State.ICO_FIRST) {
334              bonuses = _tokens * 30 / 100;
335         }
336 
337         if(currentState == State.ICO_SECOND) {
338              bonuses = _tokens * 30 / 100;
339         }
340 
341         return bonuses;
342 
343     }
344 	
345     function() external payable {
346       getTokens();
347     }
348 	
349     
350 }