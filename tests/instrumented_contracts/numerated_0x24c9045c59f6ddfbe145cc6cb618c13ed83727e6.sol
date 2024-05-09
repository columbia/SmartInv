1 pragma solidity ^0.4.16;
2 
3 contract ERC223 {
4   
5   function balanceOf(address who) constant returns (uint);
6   
7   function name() constant returns (string _name);
8   function symbol() constant returns (string _symbol);
9   function decimals() constant returns (uint8 _decimals);
10    
11   function transfer(address to, uint value) returns (bool ok);
12   function transfer(address to, uint value, bytes data) returns (bool ok);
13   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
14   event Transfer(address indexed from, address indexed to, uint value);
15 }
16 contract ForeignToken {
17     function balanceOf(address _owner) constant public returns (uint256);
18     function transfer(address _to, uint256 _value) public returns (bool);
19 }
20 
21 
22 contract ContractReceiver {
23      
24     struct TKN {
25         address sender;
26         uint value;
27         bytes data;
28         bytes4 sig;
29     }
30     
31     
32     function tokenFallback(address _from, uint _value, bytes _data){
33       TKN memory tkn;
34       tkn.sender = _from;
35       tkn.value = _value;
36       tkn.data = _data;
37       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
38       tkn.sig = bytes4(u);
39       
40       /* tkn variable is analogue of msg variable of Ether transaction
41       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
42       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
43       *  tkn.data is data of token transaction   (analogue of msg.data)
44       *  tkn.sig is 4 bytes signature of function
45       *  if data of token transaction is a function execution
46       */
47     }
48 }
49  /**
50  * ERC23 token by Dexaran
51  *
52  * https://github.com/Dexaran/ERC23-tokens
53  */
54  
55  
56  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
57 contract SafeMath {
58     uint256 constant public MAX_UINT256 =
59     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
60 
61     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
62         assert(x <= MAX_UINT256 - y);
63         return x + y;
64     }
65 
66     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
67         assert(x >= y);
68         return x - y;
69     }
70 
71     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
72         if (y == 0) return 0;
73         assert(x <= MAX_UINT256 / y);
74         return x * y;
75     }
76 }
77  
78 /*
79  * Ownable
80  *
81  * Base contract with an owner.
82  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
83  */
84 contract Ownable {
85   address public owner;
86 
87   function Ownable() {
88     owner = msg.sender;
89   }
90 
91   modifier onlyOwner() {
92     assert(msg.sender == owner);
93     _;
94   }
95 
96   function transferOwnership(address newOwner) onlyOwner {
97     if (newOwner != address(0)) {
98       owner = newOwner;
99     }
100   }
101 
102 }
103 
104 contract Haltable is Ownable {
105   bool public halted;
106 
107   modifier stopInEmergency {
108     assert(!halted);
109     _;
110   }
111 
112   modifier onlyInEmergency {
113     assert(halted);
114     _;
115   }
116 
117   // called by the owner on emergency, triggers stopped state
118   function halt() external onlyOwner {
119     halted = true;
120   }
121 
122   // called by the owner on end of emergency, returns to normal state
123   function unhalt() external onlyOwner onlyInEmergency {
124     halted = false;
125   }
126 
127 }
128 
129 contract Tablow is ERC223, SafeMath, Haltable {
130 
131   mapping(address => uint) balances;
132   
133   string public symbol = "TC";
134     string public name = "Tablow Club";
135     uint8 public decimals = 18;
136     uint256  _totalSupply = 0;
137     uint256 _MaxDistribPublicSupply = 0;
138     uint256 _OwnerDistribSupply = 0;
139     uint256 _CurrentDistribPublicSupply = 0;
140     uint256 _FreeTokens = 0;
141     uint256 _Multiplier1 = 2;
142     uint256 _Multiplier2 = 3;
143     uint256 _LimitMultiplier1 = 4e15;
144     uint256 _LimitMultiplier2 = 8e15;
145     uint256 _HighDonateLimit = 5e16;
146     uint256 _BonusTokensPerETHdonated = 0;
147     address _DistribFundsReceiverAddress = 0;
148     address _remainingTokensReceiverAddress = 0;
149     address owner = 0;
150     bool setupDone = false;
151     bool IsDistribRunning = false;
152     bool DistribStarted = false;
153   
154   
155   // Function to access name of token .
156   function name() constant returns (string _name) {
157       return name;
158   }
159   // Function to access symbol of token .
160   function symbol() constant returns (string _symbol) {
161       return symbol;
162   }
163   // Function to access decimals of token .
164   function decimals() constant returns (uint8 _decimals) {
165       return decimals;
166   }
167   // Function to access total supply of tokens .
168    
169   
170    event Transfer(address indexed _from, address indexed _to, uint256 _value);
171     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
172     event Burn(address indexed _owner, uint256 _value);
173 
174    
175     mapping(address => mapping(address => uint256)) allowed;
176     mapping(address => bool) public Claimed;
177 
178     modifier onlyOwner() {
179         require(msg.sender == owner);
180         _;
181     }
182 
183     function Tablow() public {
184         owner = msg.sender;
185     }
186 
187     function() public payable {
188         if (IsDistribRunning) {
189             uint256 _amount;
190             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
191             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
192             if (Claimed[msg.sender] == false) {
193                 _amount = _FreeTokens * 1e18;
194                 _CurrentDistribPublicSupply += _amount;
195                 balances[msg.sender] += _amount;
196                 _totalSupply += _amount;
197                 Transfer(this, msg.sender, _amount);
198                 Claimed[msg.sender] = true;
199             }
200 
201             require(msg.value <= _HighDonateLimit);
202 
203             if (msg.value >= 1e15) {
204                 if (msg.value >= _LimitMultiplier2) {
205                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
206                 } else {
207                     if (msg.value >= _LimitMultiplier1) {
208                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
209                     } else {
210 
211                         _amount = msg.value * _BonusTokensPerETHdonated;
212 
213                     }
214 
215                 }
216 
217                 _CurrentDistribPublicSupply += _amount;
218                 balances[msg.sender] += _amount;
219                 _totalSupply += _amount;
220                 Transfer(this, msg.sender, _amount);
221             }
222 
223 
224 
225         } else {
226             revert();
227         }
228     }
229 
230     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
231         if (msg.sender == owner && !setupDone) {
232             symbol = tokenSymbol;
233             name = tokenName;
234             _FreeTokens = FreeTokens;
235             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
236             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
237             if (OwnerDistribSupply > 0) {
238                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
239                 _totalSupply = _OwnerDistribSupply;
240                 balances[owner] = _totalSupply;
241                 _CurrentDistribPublicSupply += _totalSupply;
242                 Transfer(this, owner, _totalSupply);
243             }
244             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
245             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
246             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
247 
248             setupDone = true;
249         }
250     }
251 
252     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
253         _Multiplier1 = Multiplier1inX;
254         _Multiplier2 = Multiplier2inX;
255         _LimitMultiplier1 = LimitMultiplier1inWei;
256         _LimitMultiplier2 = LimitMultiplier2inWei;
257         _HighDonateLimit = HighDonateLimitInWei;
258     }
259 
260     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
261         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
262     }
263 
264     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
265         _FreeTokens = FreeTokens;
266     }
267 
268     function StartDistrib() public returns(bool success) {
269         if (msg.sender == owner && !DistribStarted && setupDone) {
270             DistribStarted = true;
271             IsDistribRunning = true;
272         } else {
273             revert();
274         }
275         return true;
276     }
277 
278     function StopDistrib() public returns(bool success) {
279         if (msg.sender == owner && IsDistribRunning) {
280             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
281                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
282                 if (_remainingAmount > 0) {
283                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
284                     _totalSupply += _remainingAmount;
285                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
286                 }
287             }
288             DistribStarted = false;
289             IsDistribRunning = false;
290         } else {
291             revert();
292         }
293         return true;
294     }
295 
296     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
297 
298         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
299         require(addresses.length <= 255);
300         require(_amount <= _remainingAmount);
301         _amount = _amount * 1e18;
302 
303         for (uint i = 0; i < addresses.length; i++) {
304             require(_amount <= _remainingAmount);
305             _CurrentDistribPublicSupply += _amount;
306             balances[addresses[i]] += _amount;
307             _totalSupply += _amount;
308             Transfer(this, addresses[i], _amount);
309 
310         }
311 
312         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
313             DistribStarted = false;
314             IsDistribRunning = false;
315         }
316     }
317 
318     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
319 
320         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
321         uint256 _amount;
322 
323         require(addresses.length <= 255);
324         require(addresses.length == amounts.length);
325 
326         for (uint8 i = 0; i < addresses.length; i++) {
327             _amount = amounts[i] * 1e18;
328             require(_amount <= _remainingAmount);
329             _CurrentDistribPublicSupply += _amount;
330             balances[addresses[i]] += _amount;
331             _totalSupply += _amount;
332             Transfer(this, addresses[i], _amount);
333 
334 
335             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
336                 DistribStarted = false;
337                 IsDistribRunning = false;
338             }
339         }
340     }
341 
342  function BurnTokens(uint256 amount) public returns(bool success) {
343         uint256 _amount = amount * 1e18;
344         if (balances[msg.sender] >= _amount) {
345             balances[msg.sender] -= _amount;
346             _totalSupply -= _amount;
347             Burn(msg.sender, _amount);
348             Transfer(msg.sender, 0, _amount);
349         } else {
350             revert();
351         }
352         return true;
353     }
354 
355      
356 
357     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
358         return _MaxDistribPublicSupply;
359     }
360 
361     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
362         return _OwnerDistribSupply;
363     }
364 
365     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
366         return _CurrentDistribPublicSupply;
367     }
368 
369     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
370         return _remainingTokensReceiverAddress;
371     }
372 
373     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
374         return _DistribFundsReceiverAddress;
375     }
376 
377     function Owner() public constant returns(address ownerAddress) {
378         return owner;
379     }
380 
381     function SetupDone() public constant returns(bool setupDoneFlag) {
382         return setupDone;
383     }
384 
385     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
386         return IsDistribRunning;
387     }
388      function totalSupply() public constant returns(uint256 totalSupplyValue) {
389         return _totalSupply;
390     }
391 
392     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
393         return DistribStarted;
394     }
395  function approve(address _spender, uint256 _amount) public returns(bool success) {
396         allowed[msg.sender][_spender] = _amount;
397         Approval(msg.sender, _spender, _amount);
398         return true;
399     }
400 
401 function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
402         ForeignToken token = ForeignToken(_tokenContract);
403         uint256 amount = token.balanceOf(address(this));
404         return token.transfer(owner, amount);
405     }
406     
407     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
408         return allowed[_owner][_spender];
409     }
410     
411   // Function that is called when a user or another contract wants to transfer funds .
412   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
413       
414     if(isContract(_to)) {
415         return transferToContract(_to, _value, _data);
416     }
417     else {
418         return transferToAddress(_to, _value, _data);
419     }
420 }
421   
422   // Standard function transfer similar to ERC20 transfer with no _data .
423   // Added due to backwards compatibility reasons .
424   function transfer(address _to, uint _value) returns (bool success) {
425       
426     //standard function transfer similar to ERC20 transfer with no _data
427     //added due to backwards compatibility reasons
428     bytes memory empty;
429     if(isContract(_to)) {
430         return transferToContract(_to, _value, empty);
431     }
432     else {
433         return transferToAddress(_to, _value, empty);
434     }
435 }
436 
437 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
438   function isContract(address _addr) private returns (bool is_contract) {
439       uint length;
440       assembly {
441             //retrieve the size of the code on target address, this needs assembly
442             length := extcodesize(_addr)
443         }
444         if(length>0) {
445             return true;
446         }
447         else {
448             return false;
449         }
450     }
451 
452   //function that is called when transaction target is an address
453   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
454     assert(balanceOf(msg.sender) >= _value);
455     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
456     balances[_to] = safeAdd(balanceOf(_to), _value);
457     Transfer(msg.sender, _to, _value, _data);
458     Transfer(msg.sender, _to, _value);
459     return true;
460   }
461   
462   //function that is called when transaction target is a contract
463   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
464     assert(balanceOf(msg.sender) >= _value);
465     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
466     balances[_to] = safeAdd(balanceOf(_to), _value);
467     ContractReceiver reciever = ContractReceiver(_to);
468     reciever.tokenFallback(msg.sender, _value, _data);
469     Transfer(msg.sender, _to, _value, _data);
470     Transfer(msg.sender, _to, _value);
471     return true;
472 }
473 
474 
475   function balanceOf(address _owner) constant returns (uint balance) {
476     return balances[_owner];
477   }
478   
479 }