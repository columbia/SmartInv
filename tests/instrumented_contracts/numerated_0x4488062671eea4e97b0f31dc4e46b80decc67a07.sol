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
113 contract LicerioToken is AbstractToken {
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
130      function LicerioToken() {
131          owner = msg.sender;
132          createTokens(100 * (10**24));
133      }
134      
135      function totalSupply () constant returns (uint256 _totalSupply) {
136         return tokenCount;
137      }
138      
139     function name () constant returns (string result) {
140 		return "LicerioToken";
141 	}
142 	
143 	function symbol () constant returns (string result) {
144 		return "LCR";
145 	}
146 	
147 	function decimals () constant returns (uint result) {
148         return 18;
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
226 contract TokenSale is LicerioToken  {
227  
228     enum State { PRIVATE_SALE, PRE_ICO, ICO_FIRST, ICO_SECOND, STOPPED, CLOSED }
229     
230     // 0 , 1 , 2 , 3 , 4 , 5
231     
232     State public currentState = State.STOPPED;
233 
234     uint public tokenPrice = 250000000000000; // wei , 0.00025 eth , 0.12 usd
235     uint public _minAmount = 0.01 ether;
236 	
237     address public beneficiary;
238 	
239 	uint256 private BountyFound = 10 * (10**24);
240 	uint256 private SaleFound = 70 * (10**24);
241 	uint256 private PartnersFound = 5 * (10**24);
242 	uint256 private TeamFound = 15 * (10**24);
243 	
244 	uint256 public totalSold = 0;
245 	
246 	
247 	uint256 private _hardcap = 14000 ether;
248 	uint256 private _softcap = 2500 ether;
249 	
250 	bool private _allowedTransfers = true;
251 	
252 	
253     address[] public Partners;
254     address[] public Holders;
255 	
256 	modifier minAmount() {
257         require(msg.value >= _minAmount);
258         _;
259     }
260     
261     modifier saleIsOn() {
262         require(currentState != State.STOPPED && currentState != State.CLOSED && totalSold < SaleFound);
263         _;
264     }
265     
266 	function TokenSale() {
267 	    owner = msg.sender;
268 	    beneficiary = msg.sender;
269 	}
270 	
271 	function setState(State _newState) public onlyOwner {
272 	    require(currentState != State.CLOSED);
273 	    currentState = _newState;
274 	}
275 	
276 	function setMinAmount(uint _new) public onlyOwner {
277 	    
278 	    _minAmount = _new;
279 	    
280 	}
281 	
282 	function allowTransfers() public onlyOwner {
283 		_allowedTransfers = true;		
284 	}
285 	
286 	function stopTransfers() public onlyOwner {
287 		_allowedTransfers = false;
288 	}
289 	
290 	function stopSale() public onlyOwner {
291 	    currentState = State.CLOSED;
292 	    payoutPartners();
293 	    payoutBonusesToHolders();
294 	}
295 	
296     function setBeneficiaryAddress(address _new) public onlyOwner {
297         
298         beneficiary = _new;
299         
300     }
301     
302     function setTokenPrice(uint _price) public onlyOwner {
303         
304         tokenPrice = _price;
305         
306     }
307     
308     function addPartner(address _newPartner) public onlyOwner {
309         
310         Partners.push(_newPartner);
311         
312     }
313     
314     function payoutPartners() private returns (bool) {
315 
316         if(Partners.length == 0) return false;
317 
318         uint tokensToPartners = safeDiv(PartnersFound, Partners.length);
319         
320         for(uint i = 0 ; i <= Partners.length - 1; i++) {
321             address addr = Partners[i];
322             accounts[addr] = safeAdd(accounts[addr], tokensToPartners);
323 	        accounts[owner] = safeSub(accounts[owner], tokensToPartners);
324         }
325         
326         return true;
327         
328     }
329     
330     
331     function payoutBonusesToHolders() private returns (bool) {
332         
333         if(Holders.length == 0) return false;
334         
335         uint tokensToHolders = safeDiv(BountyFound, Holders.length);
336         
337         for(uint i = 0 ; i <= Holders.length - 1; i++) {
338             address addr = Holders[i];
339             accounts[addr] = safeAdd(accounts[addr], tokensToHolders);
340 	        accounts[owner] = safeSub(accounts[owner], tokensToHolders); 
341         }
342         
343         return true;
344     }
345     
346 	
347 	function transferFromOwner(address _address, uint _amount) public onlyOwner returns (bool) {
348 	    
349 	    uint tokens = get_tokens_count(_amount * 1 ether);
350 	    
351 	    tokens = safeAdd(tokens, get_bounty_count(tokens));
352 	    
353 	    accounts[_address] = safeAdd(accounts[_address], tokens);
354 	    accounts[owner] = safeSub(accounts[owner], tokens);
355 	    
356 	    totalSold = safeAdd(totalSold, _amount);
357 	    
358 	    Holders.push(_address);
359 	    
360 	    return true;
361 
362 	}
363 	
364 
365 	
366 	function transferPayable(address _address, uint _amount) private returns (bool) {
367 	    
368 	    if(SaleFound < _amount) return false;
369 	    
370 	    accounts[_address] = safeAdd(accounts[_address], _amount);
371 	    accounts[owner] = safeSub(accounts[owner], _amount);
372 	    
373 	    totalSold = safeAdd(totalSold, _amount);
374 	    
375 	    Holders.push(_address);
376 	    
377 	    return true;
378 	    
379 	}
380 	
381 	
382 	function buyLCRTokens() public saleIsOn() minAmount() payable {
383 	  
384 	    
385 	    uint tokens = get_tokens_count(msg.value);
386 		require(transferPayable(msg.sender , tokens));
387 		if(_allowedTransfers) {
388 			beneficiary.transfer(msg.value);
389 	    }
390 	    
391 	}
392 	
393 	
394 	function get_tokens_count(uint _amount) private returns (uint) {
395 	    
396 	     uint currentPrice = tokenPrice;
397 	     uint tokens = safeDiv( safeMul(_amount, _decimals), currentPrice ) ;
398     	 return tokens;
399 	    
400 	}
401 	
402 	
403 	function get_bounty_count(uint _tokens) private returns (uint) {
404 	
405 	    uint bonuses = 0;
406 	
407 	    if(currentState == State.PRIVATE_SALE) {
408 	        bonuses = _tokens ;
409 	    }
410 	    
411 	    if(currentState == State.PRE_ICO) {
412 	        bonuses = safeDiv(_tokens , 2);
413 	    }
414 	    
415 	    if(currentState == State.ICO_FIRST) {
416 	         bonuses = safeDiv(_tokens , 4);
417 	    }
418 	    
419 	    if(currentState == State.ICO_SECOND) {
420 	         bonuses = safeDiv(_tokens , 5);
421 	    }
422 	    
423 	    if(BountyFound < bonuses) {
424 	        bonuses = BountyFound;
425 	    }
426 	    
427 	    if(bonuses > 0) {
428 	        safeSub(BountyFound, bonuses);
429 	    }
430 
431 	    return bonuses;
432 	
433 	}
434 	
435 	function() external payable {
436       buyLCRTokens();
437     }
438 	
439     
440 }