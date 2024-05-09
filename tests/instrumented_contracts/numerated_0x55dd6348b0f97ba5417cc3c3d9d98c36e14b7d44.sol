1 pragma solidity ^0.4.18;
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
64 contract ERC223Interface {
65    
66     function balanceOf(address who) constant returns (uint);
67     function transfer(address to, uint value);
68     function transfer(address to, uint value, bytes data);
69     event Transfer(address indexed from, address indexed to, uint value, bytes data);
70 }
71 contract ERC223Token is ERC223Interface {
72     using SafeMath for uint;
73 
74     mapping(address => uint) balances; // List of user balances.
75     
76     /**
77      * @dev Transfer the specified amount of tokens to the specified address.
78      *      Invokes the `tokenFallback` function if the recipient is a contract.
79      *      The token transfer fails if the recipient is a contract
80      *      but does not implement the `tokenFallback` function
81      *      or the fallback function to receive funds.
82      *
83      * @param _to    Receiver address.
84      * @param _value Amount of tokens that will be transferred.
85      * @param _data  Transaction metadata.
86      */
87     function transfer(address _to, uint _value, bytes _data) {
88         // Standard function transfer similar to ERC20 transfer with no _data .
89         // Added due to backwards compatibility reasons .
90         uint codeLength;
91 
92         assembly {
93             // Retrieve the size of the code on target address, this needs assembly .
94             codeLength := extcodesize(_to)
95         }
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         if(codeLength>0) {
100             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
101             receiver.tokenFallback(msg.sender, _value, _data);
102         }
103        Transfer(msg.sender, _to, _value, _data);
104     }
105     
106     /**
107      * @dev Transfer the specified amount of tokens to the specified address.
108      *      This function works the same with the previous one
109      *      but doesn't contain `_data` param.
110      *      Added due to backwards compatibility reasons.
111      *
112      * @param _to    Receiver address.
113      * @param _value Amount of tokens that will be transferred.
114      */
115     function transfer(address _to, uint _value) {
116         uint codeLength;
117         bytes memory empty;
118 
119         assembly {
120             // Retrieve the size of the code on target address, this needs assembly .
121             codeLength := extcodesize(_to)
122         }
123 
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         if(codeLength>0) {
127             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
128             receiver.tokenFallback(msg.sender, _value, empty);
129         }
130          Transfer(msg.sender, _to, _value, empty);
131     }
132 
133     
134     /**
135      * @dev Returns balance of the `_owner`.
136      *
137      * @param _owner   The address whose balance will be returned.
138      * @return balance Balance of the `_owner`.
139      */
140     function balanceOf(address _owner) constant returns (uint balance) {
141         return balances[_owner];
142     }
143 }
144 contract Tablow is ERC223Token {
145     string public symbol = "TC";
146     string public name = "Tablow Club";
147     uint8 public constant decimals = 18;
148     uint256 _totalSupply = 0;
149     uint256 _MaxDistribPublicSupply = 0;
150     uint256 _OwnerDistribSupply = 0;
151     uint256 _CurrentDistribPublicSupply = 0;
152     uint256 _FreeTokens = 0;
153     uint256 _Multiplier1 = 2;
154     uint256 _Multiplier2 = 3;
155     uint256 _LimitMultiplier1 = 4e15;
156     uint256 _LimitMultiplier2 = 8e15;
157     uint256 _HighDonateLimit = 5e16;
158     uint256 _BonusTokensPerETHdonated = 0;
159     address _DistribFundsReceiverAddress = 0;
160     address _remainingTokensReceiverAddress = 0;
161     address owner = 0;
162     bool setupDone = false;
163     bool IsDistribRunning = false;
164     bool DistribStarted = false;
165 
166     event Transfer(address indexed _from, address indexed _to, uint256 _value);
167     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
168     event Burn(address indexed _owner, uint256 _value);
169 
170     mapping(address => uint256) balances;
171     mapping(address => mapping(address => uint256)) allowed;
172     mapping(address => bool) public Claimed;
173 
174     modifier onlyOwner() {
175         require(msg.sender == owner);
176         _;
177     }
178 
179     function Tablow() public {
180         owner = msg.sender;
181     }
182 
183     function() public payable {
184         if (IsDistribRunning) {
185             uint256 _amount;
186             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
187             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
188             if (Claimed[msg.sender] == false) {
189                 _amount = _FreeTokens * 1e18;
190                 _CurrentDistribPublicSupply += _amount;
191                 balances[msg.sender] += _amount;
192                 _totalSupply += _amount;
193                 Transfer(this, msg.sender, _amount);
194                 Claimed[msg.sender] = true;
195             }
196 
197             require(msg.value <= _HighDonateLimit);
198 
199             if (msg.value >= 1e15) {
200                 if (msg.value >= _LimitMultiplier2) {
201                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
202                 } else {
203                     if (msg.value >= _LimitMultiplier1) {
204                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
205                     } else {
206 
207                         _amount = msg.value * _BonusTokensPerETHdonated;
208 
209                     }
210 
211                 }
212 
213                 _CurrentDistribPublicSupply += _amount;
214                 balances[msg.sender] += _amount;
215                 _totalSupply += _amount;
216                 Transfer(this, msg.sender, _amount);
217             }
218 
219 
220 
221         } else {
222             revert();
223         }
224     }
225 
226     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
227         if (msg.sender == owner && !setupDone) {
228             symbol = tokenSymbol;
229             name = tokenName;
230             _FreeTokens = FreeTokens;
231             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
232             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
233             if (OwnerDistribSupply > 0) {
234                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
235                 _totalSupply = _OwnerDistribSupply;
236                 balances[owner] = _totalSupply;
237                 _CurrentDistribPublicSupply += _totalSupply;
238                 Transfer(this, owner, _totalSupply);
239             }
240             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
241             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
242             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
243 
244             setupDone = true;
245         }
246     }
247 
248     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
249         _Multiplier1 = Multiplier1inX;
250         _Multiplier2 = Multiplier2inX;
251         _LimitMultiplier1 = LimitMultiplier1inWei;
252         _LimitMultiplier2 = LimitMultiplier2inWei;
253         _HighDonateLimit = HighDonateLimitInWei;
254     }
255 
256     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
257         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
258     }
259 
260     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
261         _FreeTokens = FreeTokens;
262     }
263 
264     function StartDistrib() public returns(bool success) {
265         if (msg.sender == owner && !DistribStarted && setupDone) {
266             DistribStarted = true;
267             IsDistribRunning = true;
268         } else {
269             revert();
270         }
271         return true;
272     }
273 
274     function StopDistrib() public returns(bool success) {
275         if (msg.sender == owner && IsDistribRunning) {
276             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
277                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
278                 if (_remainingAmount > 0) {
279                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
280                     _totalSupply += _remainingAmount;
281                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
282                 }
283             }
284             DistribStarted = false;
285             IsDistribRunning = false;
286         } else {
287             revert();
288         }
289         return true;
290     }
291 
292     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
293 
294         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
295         require(addresses.length <= 255);
296         require(_amount <= _remainingAmount);
297         _amount = _amount * 1e18;
298 
299         for (uint i = 0; i < addresses.length; i++) {
300             require(_amount <= _remainingAmount);
301             _CurrentDistribPublicSupply += _amount;
302             balances[addresses[i]] += _amount;
303             _totalSupply += _amount;
304             Transfer(this, addresses[i], _amount);
305 
306         }
307 
308         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
309             DistribStarted = false;
310             IsDistribRunning = false;
311         }
312     }
313 
314     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
315 
316         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
317         uint256 _amount;
318 
319         require(addresses.length <= 255);
320         require(addresses.length == amounts.length);
321 
322         for (uint8 i = 0; i < addresses.length; i++) {
323             _amount = amounts[i] * 1e18;
324             require(_amount <= _remainingAmount);
325             _CurrentDistribPublicSupply += _amount;
326             balances[addresses[i]] += _amount;
327             _totalSupply += _amount;
328             Transfer(this, addresses[i], _amount);
329 
330 
331             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
332                 DistribStarted = false;
333                 IsDistribRunning = false;
334             }
335         }
336     }
337 
338     function BurnTokens(uint256 amount) public returns(bool success) {
339         uint256 _amount = amount * 1e18;
340         if (balances[msg.sender] >= _amount) {
341             balances[msg.sender] -= _amount;
342             _totalSupply -= _amount;
343             Burn(msg.sender, _amount);
344             Transfer(msg.sender, 0, _amount);
345         } else {
346             revert();
347         }
348         return true;
349     }
350 
351     function totalSupply() public constant returns(uint256 totalSupplyValue) {
352         return _totalSupply;
353     }
354 
355     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
356         return _MaxDistribPublicSupply;
357     }
358 
359     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
360         return _OwnerDistribSupply;
361     }
362 
363     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
364         return _CurrentDistribPublicSupply;
365     }
366 
367     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
368         return _remainingTokensReceiverAddress;
369     }
370 
371     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
372         return _DistribFundsReceiverAddress;
373     }
374 
375     function Owner() public constant returns(address ownerAddress) {
376         return owner;
377     }
378 
379     function SetupDone() public constant returns(bool setupDoneFlag) {
380         return setupDone;
381     }
382 
383     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
384         return IsDistribRunning;
385     }
386 
387     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
388         return DistribStarted;
389     }
390 
391     function balanceOf(address _owner) public constant returns(uint256 balance) {
392         return balances[_owner];
393     }
394 
395     
396 
397     function transferFrom(
398         address _from,
399         address _to,
400         uint256 _amount
401     ) public returns(bool success) {
402         if (balances[_from] >= _amount &&
403             allowed[_from][msg.sender] >= _amount &&
404             _amount > 0 &&
405             balances[_to] + _amount > balances[_to]) {
406             balances[_from] -= _amount;
407             allowed[_from][msg.sender] -= _amount;
408             balances[_to] += _amount;
409             Transfer(_from, _to, _amount);
410             return true;
411         } else {
412             return false;
413         }
414     }
415 
416     function approve(address _spender, uint256 _amount) public returns(bool success) {
417         allowed[msg.sender][_spender] = _amount;
418         Approval(msg.sender, _spender, _amount);
419         return true;
420     }
421 
422     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
423         return allowed[_owner][_spender];
424     }
425 }