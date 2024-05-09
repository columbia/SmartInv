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
94   function allowance (address _owner, address _spender) constant returns (uint256 remaining) {
95     return allowances [_owner][_spender];
96   }
97 
98   /**
99    * Mapping from addresses of token holders to the numbers of tokens belonging
100    * to these token holders.
101    */
102   mapping (address => uint256) accounts;
103 
104   /**
105    * Mapping from addresses of token holders to the mapping of addresses of
106    * spenders to the allowances set by these token holders to these spenders.
107    */
108   mapping (address => mapping (address => uint256)) private allowances;
109 }
110 
111 
112 contract DESALToken is AbstractToken {
113     
114      address public owner;
115      
116      uint256 tokenCount = 0;
117      
118      bool frozen = false;
119      
120      uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
121      
122     uint public constant _decimals = (10**8);
123      
124     modifier onlyOwner() {
125 	    require(owner == msg.sender);
126 	    _;
127 	}
128      
129     function DESALToken() {
130          owner = msg.sender;
131          createTokens(60 * (10**14));
132      }
133      
134     function totalSupply () constant returns (uint256 _totalSupply) {
135         return tokenCount;
136      }
137      
138     function name () constant returns (string result) {
139         return "DESAL TOKEN";
140     }
141 	
142     function symbol () constant returns (string result) {
143             return "DESAL";
144     }
145 	
146     function decimals () constant returns (uint result) {
147         return 8;
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
181     require (msg.sender == owner);
182 
183     if (_value > 0) {
184       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
185       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
186       tokenCount = safeAdd (tokenCount, _value);
187     }
188 
189     return true;
190   }
191 
192 
193   function setOwner (address _newOwner) {
194     require (msg.sender == owner);
195 
196     owner = _newOwner;
197   }
198 
199   function freezeTransfers () {
200     require (msg.sender == owner);
201 
202     if (!frozen) {
203       frozen = true;
204       Freeze ();
205     }
206   }
207 
208 
209   function unfreezeTransfers () {
210     require (msg.sender == owner);
211 
212     if (frozen) {
213       frozen = false;
214       Unfreeze ();
215     }
216   }
217 
218   event Freeze ();
219 
220   event Unfreeze ();
221 
222 }
223 
224 
225 contract DESALSale is DESALToken  {
226  
227     enum State { ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }
228     
229     // 0 , 1 , 2 , 3 
230     
231     State public currentState = State.ICO_FIRST;
232 
233     uint public tokenPrice = 250000000000000; // wei , 0.00025 eth , 0.12 usd
234     uint public _minAmount = 0.025 ether;
235 	
236     address public beneficiary;
237 	
238     uint256 public totalSold = 0;
239 
240     uint256 private _hardcap = 30000 ether;
241     uint256 private _softcap = 3750 ether;
242 	
243     bool private _allowedTransfers = true;
244 	
245     modifier minAmount() {
246         require(msg.value >= _minAmount);
247         _;
248     }
249     
250     modifier saleIsOn() {
251         require(currentState != State.STOPPED && currentState != State.CLOSED);
252         _;
253     }
254     
255     function DESALSale() {
256         owner = msg.sender;
257         beneficiary = msg.sender;
258     }
259 
260     function setState(State _newState) public onlyOwner {
261         require(currentState != State.CLOSED);
262         currentState = _newState;
263     }
264 
265     function setMinAmount(uint _new) public onlyOwner {
266 
267         _minAmount = _new;
268 
269     }
270 
271     function allowTransfers() public onlyOwner {
272             _allowedTransfers = true;		
273     }
274 
275     function stopTransfers() public onlyOwner {
276         
277             _allowedTransfers = false;
278             
279     }
280 
281     function stopSale() public onlyOwner {
282         
283         currentState = State.CLOSED;
284         
285     }
286 	
287     function setBeneficiaryAddress(address _new) public onlyOwner {
288         
289         beneficiary = _new;
290         
291     }
292 
293 
294     function transferPayable(address _address, uint _amount) private returns (bool) {
295 
296         accounts[_address] = safeAdd(accounts[_address], _amount);
297         accounts[owner] = safeSub(accounts[owner], _amount);
298 
299         totalSold = safeAdd(totalSold, _amount);
300 
301 
302         return true;
303 
304     }
305 	
306 	
307     function getTokens() public saleIsOn() minAmount() payable {
308 
309 
310         uint tokens = get_tokens_count(msg.value);
311         require(transferPayable(msg.sender , tokens));
312         if(_allowedTransfers) { beneficiary.transfer(msg.value); }
313 
314     }
315 
316 	
317     function get_tokens_count(uint _amount) private returns (uint) {
318 
319          uint currentPrice = tokenPrice;
320          uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;
321          return tokens;
322 
323     }
324 	
325     function() external payable {
326       getTokens();
327     }
328 	
329     
330 }