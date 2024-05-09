1 pragma solidity >=0.4.18;
2 
3 contract ERC20Token {
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
51 contract Token is ERC20Token, SafeMath {
52 
53   function Token () {
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
113 contract MSRiseToken is Token {
114     
115     address public owner;
116     
117      
118     uint256 tokenCount = 0;
119     
120     uint256 public bounce_reserve = 0;
121     uint256 public partner_reserve = 0;
122     uint256 public sale_reserve = 0;
123      
124     bool frozen = false;
125      
126     uint256 constant MAX_TOKEN_COUNT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
127      
128 	uint public constant _decimals = (10**18);
129 	
130      
131     modifier onlyOwner() {
132 	    require(owner == msg.sender);
133 	    _;
134 	}
135      
136      function MSRiseToken() {
137          owner = msg.sender;
138          
139          createTokens(5 * (10**25)); // создание 50 млн токенов
140          
141          partner_reserve = 5 * (10**24); // резервация 5 млн токенов для 10% для инвесторов
142          bounce_reserve = 1 * (10**24); // резервация 1 млн токенов для бонусной программы
143          
144          // вычисления общего количества токенов для продажи (44 млн)
145          sale_reserve = safeSub(tokenCount, safeAdd(partner_reserve, bounce_reserve));  
146          
147          
148      }
149      
150     function totalSupply () constant returns (uint256 _totalSupply) {
151         return tokenCount;
152     }
153      
154     function name () constant returns (string result) {
155 		return "MSRiseToken";
156 	}
157 	
158 	function symbol () constant returns (string result) {
159 		return "MSRT";
160 	}
161 	
162 	function decimals () constant returns (uint result) {
163         return 18;
164     }
165     
166     function transfer (address _to, uint256 _value) returns (bool success) {
167         if (frozen) return false;
168         else return Token.transfer (_to, _value);
169     }
170 
171   
172   function transferFrom (address _from, address _to, uint256 _value)
173     returns (bool success) {
174     if (frozen) return false;
175     else return Token.transferFrom (_from, _to, _value);
176   }
177 
178   
179   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
180     returns (bool success) {
181     if (allowance (msg.sender, _spender) == _currentValue)
182       return approve (_spender, _newValue);
183     else return false;
184   }
185 
186   function burnTokens (uint256 _value) returns (bool success) {
187     if (_value > accounts [msg.sender]) return false;
188     else if (_value > 0) {
189       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
190       tokenCount = safeSub (tokenCount, _value);
191       return true;
192     } else return true;
193   }
194 
195 
196   function createTokens (uint256 _value) returns (bool success) {
197     require (msg.sender == owner);
198 
199     if (_value > 0) {
200       if (_value > safeSub (MAX_TOKEN_COUNT, tokenCount)) return false;
201       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
202       tokenCount = safeAdd (tokenCount, _value);
203     }
204 
205     return true;
206   }
207 
208 
209  // Установка нового владельца контракта 
210  // входной параметр адрес ETH кошелька 
211 
212   function setOwner (address _newOwner) {
213     require (msg.sender == owner);
214 
215     owner = _newOwner;
216   }
217 
218   function freezeTransfers () {
219     require (msg.sender == owner);
220 
221     if (!frozen) {
222       frozen = true;
223       Freeze ();
224     }
225   }
226 
227 
228   function unfreezeTransfers () {
229     require (msg.sender == owner);
230 
231     if (frozen) {
232       frozen = false;
233       Unfreeze ();
234     }
235   }
236 
237   event Freeze ();
238 
239   event Unfreeze ();
240 
241 }
242 
243 
244 contract MSRiseTokenSale is MSRiseToken  {
245  
246     address[] balancesKeys;
247     mapping (address => uint256) balances;
248  
249     enum State { PRE_ICO, ICO, STOPPED }
250     
251     
252     // 0 , 1 , 2
253     
254     State public currentState = State.STOPPED;
255 
256     uint public tokenPrice = 50000000000000000;
257     uint public _minAmount = 0.05 ether;
258 	
259 	mapping (address => uint256) wallets;
260 
261     address public beneficiary;
262 
263 	uint256 public totalSold = 0;
264 	uint256 public totalBounces = 0;
265 	
266 	uint public current_percent = 15;
267 	uint public current_discount = 0;
268 
269 	bool private _allowedTransfers = true;
270 	
271 	modifier minAmount() {
272         require(msg.value >= _minAmount);
273         _;
274     }
275     
276     modifier saleIsOn() {
277         require(currentState != State.STOPPED && totalSold < sale_reserve);
278         _;
279     }
280     
281     modifier isAllowedBounce() {
282         require(totalBounces < bounce_reserve);
283         _;
284     }
285     
286 	function TokenSale() {
287 	    owner = msg.sender;
288 	    beneficiary = msg.sender;
289 	}
290 
291 	
292 	// установка текущего бонуса за покупку
293 	
294 	function setBouncePercent(uint _percent) public onlyOwner {
295 	    current_percent = _percent;
296 	}
297 	
298 	function setDiscountPercent(uint _discount) public onlyOwner {
299 	    current_discount = _discount;
300 	}
301 	
302 	
303 	// установка текущей фазы продаж (pre-ico = 0, ico = 1, stopped = 3)
304 	
305 	function setState(State _newState) public onlyOwner {
306 	    currentState = _newState;
307 	}
308 	
309 	// установка минимальной суммы платежа в эфирах
310 	
311 	function setMinAmount(uint _new) public onlyOwner {
312 	    _minAmount = _new;
313 	}
314 	
315 	// возобновление переводов
316 	
317 	function allowTransfers() public onlyOwner {
318 		_allowedTransfers = true;		
319 	}
320 	
321 	// заморозка всех переводов
322 	
323 	function stopTransfers() public onlyOwner {
324 		_allowedTransfers = false;
325 	}
326 	
327 	// функция смены адреса ETH куда будут поступать отправленные эфиры
328 	
329     function setBeneficiaryAddress(address _new) public onlyOwner {
330         beneficiary = _new;
331     }
332     
333     // функция установки стоимости одного токена в wei 
334     
335     function setTokenPrice(uint _price) public onlyOwner {
336         tokenPrice = _price;
337     }
338     
339     // фукнция списания токенов с общего баланса на баланс отправителя
340     
341 	function transferPayable(address _address, uint _amount) private returns (bool) {
342 	    accounts[_address] = safeAdd(accounts[_address], _amount);
343 	    accounts[owner] = safeSub(accounts[owner], _amount);
344 	    totalSold = safeAdd(totalSold, _amount);
345 	    return true;
346 	}
347 	
348 	// вычисления количество токенов, равное количество отправленных эфиров
349 	// исходя из стоимости токена, бонуса и скидки
350 	
351 	function get_tokens_count(uint _amount) private returns (uint) {
352 	    
353 	     uint currentPrice = tokenPrice;
354 	     uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;
355 	     totalSold = safeAdd(totalSold, tokens);
356 	     
357 	     if(currentState == State.PRE_ICO) {
358 	         tokens = safeAdd(tokens, get_bounce_tokens(tokens)); // вызывается при PRE-ICO
359 	     } else if(currentState == State.ICO) {
360 	         tokens = safeAdd(tokens, get_discount_tokens(tokens)); // вызывается при ICO
361 	     }
362 	     
363 	     return tokens;
364 	}
365 	
366 	// вычисление текущей скидки
367 	
368 	function get_discount_tokens(uint _tokens) isAllowedBounce private returns (uint) {
369 	    
370 	    uint tokens = 0;
371 	    uint _current_percent = safeMul(current_discount, 100);
372 	    tokens = _tokens * _current_percent / 10000;
373 	    totalBounces = safeAdd(totalBounces, tokens);
374 	    return tokens;
375 	    
376 	}
377 	
378 	// вычисление бонусных токенов
379 	
380 	function get_bounce_tokens(uint _tokens) isAllowedBounce() private returns (uint) {
381 	    uint tokens = 0;
382 	    uint _current_percent = safeMul(current_percent, 100);
383 	    tokens = _tokens * _current_percent / 10000;
384 	    totalBounces = safeAdd(totalBounces, tokens);
385 	    return tokens;
386 	}
387 	
388 	// функция, которая вызывается при отправке эфира на контракт
389 	
390 	function buy() public saleIsOn() minAmount() payable {
391 	    uint tokens;
392 	    tokens = get_tokens_count(msg.value);
393 		require(transferPayable(msg.sender , tokens));
394 		if(_allowedTransfers) {
395 			beneficiary.transfer(msg.value);
396 			balances[msg.sender] = safeAdd(balances[msg.sender], msg.value);
397 			balancesKeys.push(msg.sender);
398 	    }
399 	}
400 	
401 	// возврат средств, вызывается владельцем контракта,
402 	// для возврата на контракте должны присутствовать эфиры
403 	
404 	function refund() onlyOwner {
405       for(uint i = 0 ; i < balancesKeys.length ; i++) {
406           address addr = balancesKeys[i]; 
407           uint value = balances[addr];
408           balances[addr] = 0; 
409           accounts[addr] = 0;
410           addr.transfer(value); 
411       }
412     }
413 	
414 	
415 	function() external payable {
416       buy();
417     }
418 	
419     
420 }