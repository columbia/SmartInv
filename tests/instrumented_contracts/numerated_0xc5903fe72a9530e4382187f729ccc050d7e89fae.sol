1 pragma solidity ^0.4.10;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 contract ERC223ReceivingContract { 
55 /**
56  * @dev Standard ERC223 function that will handle incoming token transfers.
57  *
58  * @param _from  Token sender address.
59  * @param _value Amount of tokens.
60  * @param _data  Transaction metadata.
61  */
62     function tokenFallback(address _from, uint _value, bytes _data);
63 }
64 contract ERC223  {
65    
66     function balanceOf(address who) constant returns (uint);
67     
68     event Transfer(address indexed from, address indexed to, uint value, bytes data);
69 }
70 contract ForeignToken {
71     function balanceOf(address _owner) constant public returns (uint256);
72     function transfer(address _to, uint256 _value) public returns (bool);
73 }
74 
75  
76 contract Tablow is ERC223 {
77      
78     using SafeMath for uint;
79 
80     string public symbol = "TC";
81     string public name = "Tablow Club";
82     uint8 public constant decimals = 18;
83     uint256 _totalSupply = 0;
84     uint256 _MaxDistribPublicSupply = 0;
85     uint256 _OwnerDistribSupply = 0;
86     uint256 _CurrentDistribPublicSupply = 0;
87     uint256 _FreeTokens = 0;
88     uint256 _Multiplier1 = 2;
89     uint256 _Multiplier2 = 3;
90     uint256 _LimitMultiplier1 = 4e15;
91     uint256 _LimitMultiplier2 = 8e15;
92     uint256 _HighDonateLimit = 5e16;
93     uint256 _BonusTokensPerETHdonated = 0;
94     address _DistribFundsReceiverAddress = 0;
95     address _remainingTokensReceiverAddress = 0;
96     address owner = 0;
97     bool setupDone = false;
98     bool IsDistribRunning = false;
99     bool DistribStarted = false;
100 
101     event Transfer(address indexed _from, address indexed _to, uint256 _value);
102     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
103     event Burn(address indexed _owner, uint256 _value);
104 
105     mapping(address => uint256) balances;
106     mapping(address => mapping(address => uint256)) allowed;
107     mapping(address => bool) public Claimed;
108 
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     function Tablow() public {
115         owner = msg.sender;
116     }
117 
118     function() public payable {
119         if (IsDistribRunning) {
120             uint256 _amount;
121             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
122             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
123             if (Claimed[msg.sender] == false) {
124                 _amount = _FreeTokens * 1e18;
125                 _CurrentDistribPublicSupply += _amount;
126                 balances[msg.sender] += _amount;
127                 _totalSupply += _amount;
128                 Transfer(this, msg.sender, _amount);
129                 Claimed[msg.sender] = true;
130             }
131 
132             require(msg.value <= _HighDonateLimit);
133 
134             if (msg.value >= 1e15) {
135                 if (msg.value >= _LimitMultiplier2) {
136                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
137                 } else {
138                     if (msg.value >= _LimitMultiplier1) {
139                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
140                     } else {
141 
142                         _amount = msg.value * _BonusTokensPerETHdonated;
143 
144                     }
145 
146                 }
147 
148                 _CurrentDistribPublicSupply += _amount;
149                 balances[msg.sender] += _amount;
150                 _totalSupply += _amount;
151                 Transfer(this, msg.sender, _amount);
152             }
153 
154 
155 
156         } else {
157             revert();
158         }
159     }
160 
161     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
162         if (msg.sender == owner && !setupDone) {
163             symbol = tokenSymbol;
164             name = tokenName;
165             _FreeTokens = FreeTokens;
166             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
167             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
168             if (OwnerDistribSupply > 0) {
169                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
170                 _totalSupply = _OwnerDistribSupply;
171                 balances[owner] = _totalSupply;
172                 _CurrentDistribPublicSupply += _totalSupply;
173                 Transfer(this, owner, _totalSupply);
174             }
175             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
176             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
177             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
178 
179             setupDone = true;
180         }
181     }
182 
183     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
184         _Multiplier1 = Multiplier1inX;
185         _Multiplier2 = Multiplier2inX;
186         _LimitMultiplier1 = LimitMultiplier1inWei;
187         _LimitMultiplier2 = LimitMultiplier2inWei;
188         _HighDonateLimit = HighDonateLimitInWei;
189     }
190 
191     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
192         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
193     }
194 
195     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
196         _FreeTokens = FreeTokens;
197     }
198 
199     function StartDistrib() public returns(bool success) {
200         if (msg.sender == owner && !DistribStarted && setupDone) {
201             DistribStarted = true;
202             IsDistribRunning = true;
203         } else {
204             revert();
205         }
206         return true;
207     }
208 
209     function StopDistrib() public returns(bool success) {
210         if (msg.sender == owner && IsDistribRunning) {
211             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
212                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
213                 if (_remainingAmount > 0) {
214                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
215                     _totalSupply += _remainingAmount;
216                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
217                 }
218             }
219             DistribStarted = false;
220             IsDistribRunning = false;
221         } else {
222             revert();
223         }
224         return true;
225     }
226 
227     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
228 
229         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
230         require(addresses.length <= 255);
231         require(_amount <= _remainingAmount);
232         _amount = _amount * 1e18;
233 
234         for (uint i = 0; i < addresses.length; i++) {
235             require(_amount <= _remainingAmount);
236             _CurrentDistribPublicSupply += _amount;
237             balances[addresses[i]] += _amount;
238             _totalSupply += _amount;
239             Transfer(this, addresses[i], _amount);
240 
241         }
242 
243         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
244             DistribStarted = false;
245             IsDistribRunning = false;
246         }
247     }
248 
249     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
250 
251         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
252         uint256 _amount;
253 
254         require(addresses.length <= 255);
255         require(addresses.length == amounts.length);
256 
257         for (uint8 i = 0; i < addresses.length; i++) {
258             _amount = amounts[i] * 1e18;
259             require(_amount <= _remainingAmount);
260             _CurrentDistribPublicSupply += _amount;
261             balances[addresses[i]] += _amount;
262             _totalSupply += _amount;
263             Transfer(this, addresses[i], _amount);
264 
265 
266             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
267                 DistribStarted = false;
268                 IsDistribRunning = false;
269             }
270         }
271     }
272 
273     function BurnTokens(uint256 amount) public returns(bool success) {
274         uint256 _amount = amount * 1e18;
275         if (balances[msg.sender] >= _amount) {
276             balances[msg.sender] -= _amount;
277             _totalSupply -= _amount;
278             Burn(msg.sender, _amount);
279             Transfer(msg.sender, 0, _amount);
280         } else {
281             revert();
282         }
283         return true;
284     }
285 
286     function totalSupply() public constant returns(uint256 totalSupplyValue) {
287         return _totalSupply;
288     }
289 
290     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
291         return _MaxDistribPublicSupply;
292     }
293 
294     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
295         return _OwnerDistribSupply;
296     }
297 
298     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
299         return _CurrentDistribPublicSupply;
300     }
301 
302     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
303         return _remainingTokensReceiverAddress;
304     }
305 
306     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
307         return _DistribFundsReceiverAddress;
308     }
309 
310     function Owner() public constant returns(address ownerAddress) {
311         return owner;
312     }
313 
314     function SetupDone() public constant returns(bool setupDoneFlag) {
315         return setupDone;
316     }
317 
318     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
319         return IsDistribRunning;
320     }
321 
322     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
323         return DistribStarted;
324     }
325     
326      
327     /**
328      * @dev Transfer the specified amount of tokens to the specified address.
329      *      This function works the same with the previous one
330      *      but doesn't contain `_data` param.
331      *      Added due to backwards compatibility reasons.
332      *
333      * @param _to    Receiver address.
334      * @param _value Amount of tokens that will be transferred.
335      */
336     
337     function transfer(address _to, uint _value) returns (bool success) {
338         if (balances[msg.sender] >= _value
339             && _value > 0
340             && balances[_to] + _value > balances[_to]) {
341             bytes memory empty;
342             if(isContract(_to)) {
343                 return transferToContract(_to, _value, empty);
344             } else {
345                 return transferToAddress(_to, _value, empty);
346             }
347         } else {
348             return false;
349         }
350     }
351 
352     /* Withdraws to address _to form the address _from up to the amount _value */
353     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
354         if (balances[_from] >= _value
355             && allowed[_from][msg.sender] >= _value
356             && _value > 0
357             && balances[_to] + _value > balances[_to]) {
358             balances[_from] -= _value;
359             allowed[_from][msg.sender] -= _value;
360             balances[_to] += _value;
361             Transfer(_from, _to, _value);
362             return true;
363         } else {
364             return false;
365         }
366     }
367 
368     /* Allows _spender to withdraw the _allowance amount form sender */
369     function approve(address _spender, uint256 _allowance) returns (bool success) {
370         if (_allowance <= _totalSupply) {
371             allowed[msg.sender][_spender] = _allowance;
372             Approval(msg.sender, _spender, _allowance);
373             return true;
374         } else {
375             return false;
376         }
377     }
378 
379     /* Checks how much _spender can withdraw from _owner */
380     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
381         return allowed[_owner][_spender];
382     }
383      
384      
385      function transfer(address _to, uint _value, bytes _data) returns (bool success) {
386         if (balances[msg.sender] >= _value
387             && _value > 0
388             && balances[_to] + _value > balances[_to]) {
389             if(isContract(_to)) {
390                 return transferToContract(_to, _value, _data);
391             } else {
392                 return transferToAddress(_to, _value, _data);
393             }
394         } else {
395             return false;
396         }
397     }
398 
399     /* Transfer function when _to represents a regular address */
400     function transferToAddress(address _to, uint _value, bytes _data) internal returns (bool success) {
401         balances[msg.sender] -= _value;
402         balances[_to] += _value;
403         Transfer(msg.sender, _to, _value);
404         Transfer(msg.sender, _to, _value, _data);
405         return true;
406     }
407 
408     /* Transfer function when _to represents a contract address, with the caveat
409     that the contract needs to implement the tokenFallback function in order to receive tokens */
410     function transferToContract(address _to, uint _value, bytes _data) internal returns (bool success) {
411         balances[msg.sender] -= _value;
412         balances[_to] += _value;
413         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
414         receiver.tokenFallback(msg.sender, _value, _data);
415         Transfer(msg.sender, _to, _value);
416         Transfer(msg.sender, _to, _value, _data);
417         return true;
418     }
419 
420     /* Infers if whether _address is a contract based on the presence of bytecode */
421     function isContract(address _address) internal returns (bool is_contract) {
422         uint length;
423         if (_address == 0) return false;
424         assembly {
425             length := extcodesize(_address)
426         }
427         if(length > 0) {
428             return true;
429         } else {
430             return false;
431         }
432     }
433 
434 
435     
436     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
437         ForeignToken token = ForeignToken(_tokenContract);
438         uint256 amount = token.balanceOf(address(this));
439         return token.transfer(owner, amount);
440     }
441 
442     
443     function balanceOf(address _owner) public constant returns(uint256 balance) {
444         return balances[_owner];
445     }
446     
447     
448 }