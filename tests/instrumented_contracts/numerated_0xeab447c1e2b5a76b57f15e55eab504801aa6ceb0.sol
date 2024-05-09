1 pragma solidity ^0.4.24;
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
67     function transfer(address to, uint value);
68     function transfer(address to, uint value, bytes data);
69     event Transfer(address indexed from, address indexed to, uint value, bytes data);
70 }
71 contract ForeignToken {
72     function balanceOf(address _owner) constant public returns (uint256);
73     function transfer(address _to, uint256 _value) public returns (bool);
74 }
75 
76  
77 contract Tablow is ERC223 {
78      
79     using SafeMath for uint;
80 
81     string public symbol = "TC";
82     string public name = "Tablow Club";
83     uint8 public constant decimals = 18;
84     uint256 _totalSupply = 0;
85     uint256 _MaxDistribPublicSupply = 0;
86     uint256 _OwnerDistribSupply = 0;
87     uint256 _CurrentDistribPublicSupply = 0;
88     uint256 _FreeTokens = 0;
89     uint256 _Multiplier1 = 2;
90     uint256 _Multiplier2 = 3;
91     uint256 _LimitMultiplier1 = 4e15;
92     uint256 _LimitMultiplier2 = 8e15;
93     uint256 _HighDonateLimit = 5e16;
94     uint256 _BonusTokensPerETHdonated = 0;
95     address _DistribFundsReceiverAddress = 0;
96     address _remainingTokensReceiverAddress = 0;
97     address owner = 0;
98     bool setupDone = false;
99     bool IsDistribRunning = false;
100     bool DistribStarted = false;
101 
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104     event Burn(address indexed _owner, uint256 _value);
105 
106     mapping(address => uint256) balances;
107     mapping(address => mapping(address => uint256)) allowed;
108     mapping(address => bool) public Claimed;
109 
110     modifier onlyOwner() {
111         require(msg.sender == owner);
112         _;
113     }
114 
115     function Tablow() public {
116         owner = msg.sender;
117     }
118 
119     function() public payable {
120         if (IsDistribRunning) {
121             uint256 _amount;
122             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
123             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
124             if (Claimed[msg.sender] == false) {
125                 _amount = _FreeTokens * 1e18;
126                 _CurrentDistribPublicSupply += _amount;
127                 balances[msg.sender] += _amount;
128                 _totalSupply += _amount;
129                 Transfer(this, msg.sender, _amount);
130                 Claimed[msg.sender] = true;
131             }
132 
133             require(msg.value <= _HighDonateLimit);
134 
135             if (msg.value >= 1e15) {
136                 if (msg.value >= _LimitMultiplier2) {
137                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
138                 } else {
139                     if (msg.value >= _LimitMultiplier1) {
140                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
141                     } else {
142 
143                         _amount = msg.value * _BonusTokensPerETHdonated;
144 
145                     }
146 
147                 }
148 
149                 _CurrentDistribPublicSupply += _amount;
150                 balances[msg.sender] += _amount;
151                 _totalSupply += _amount;
152                 Transfer(this, msg.sender, _amount);
153             }
154 
155 
156 
157         } else {
158             revert();
159         }
160     }
161 
162     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
163         if (msg.sender == owner && !setupDone) {
164             symbol = tokenSymbol;
165             name = tokenName;
166             _FreeTokens = FreeTokens;
167             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
168             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
169             if (OwnerDistribSupply > 0) {
170                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
171                 _totalSupply = _OwnerDistribSupply;
172                 balances[owner] = _totalSupply;
173                 _CurrentDistribPublicSupply += _totalSupply;
174                 Transfer(this, owner, _totalSupply);
175             }
176             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
177             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
178             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
179 
180             setupDone = true;
181         }
182     }
183 
184     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
185         _Multiplier1 = Multiplier1inX;
186         _Multiplier2 = Multiplier2inX;
187         _LimitMultiplier1 = LimitMultiplier1inWei;
188         _LimitMultiplier2 = LimitMultiplier2inWei;
189         _HighDonateLimit = HighDonateLimitInWei;
190     }
191 
192     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
193         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
194     }
195 
196     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
197         _FreeTokens = FreeTokens;
198     }
199 
200     function StartDistrib() public returns(bool success) {
201         if (msg.sender == owner && !DistribStarted && setupDone) {
202             DistribStarted = true;
203             IsDistribRunning = true;
204         } else {
205             revert();
206         }
207         return true;
208     }
209 
210     function StopDistrib() public returns(bool success) {
211         if (msg.sender == owner && IsDistribRunning) {
212             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
213                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
214                 if (_remainingAmount > 0) {
215                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
216                     _totalSupply += _remainingAmount;
217                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
218                 }
219             }
220             DistribStarted = false;
221             IsDistribRunning = false;
222         } else {
223             revert();
224         }
225         return true;
226     }
227 
228     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
229 
230         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
231         require(addresses.length <= 255);
232         require(_amount <= _remainingAmount);
233         _amount = _amount * 1e18;
234 
235         for (uint i = 0; i < addresses.length; i++) {
236             require(_amount <= _remainingAmount);
237             _CurrentDistribPublicSupply += _amount;
238             balances[addresses[i]] += _amount;
239             _totalSupply += _amount;
240             Transfer(this, addresses[i], _amount);
241 
242         }
243 
244         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
245             DistribStarted = false;
246             IsDistribRunning = false;
247         }
248     }
249 
250     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
251 
252         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
253         uint256 _amount;
254 
255         require(addresses.length <= 255);
256         require(addresses.length == amounts.length);
257 
258         for (uint8 i = 0; i < addresses.length; i++) {
259             _amount = amounts[i] * 1e18;
260             require(_amount <= _remainingAmount);
261             _CurrentDistribPublicSupply += _amount;
262             balances[addresses[i]] += _amount;
263             _totalSupply += _amount;
264             Transfer(this, addresses[i], _amount);
265 
266 
267             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
268                 DistribStarted = false;
269                 IsDistribRunning = false;
270             }
271         }
272     }
273 
274     function BurnTokens(uint256 amount) public returns(bool success) {
275         uint256 _amount = amount * 1e18;
276         if (balances[msg.sender] >= _amount) {
277             balances[msg.sender] -= _amount;
278             _totalSupply -= _amount;
279             Burn(msg.sender, _amount);
280             Transfer(msg.sender, 0, _amount);
281         } else {
282             revert();
283         }
284         return true;
285     }
286 
287     function totalSupply() public constant returns(uint256 totalSupplyValue) {
288         return _totalSupply;
289     }
290 
291     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
292         return _MaxDistribPublicSupply;
293     }
294 
295     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
296         return _OwnerDistribSupply;
297     }
298 
299     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
300         return _CurrentDistribPublicSupply;
301     }
302 
303     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
304         return _remainingTokensReceiverAddress;
305     }
306 
307     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
308         return _DistribFundsReceiverAddress;
309     }
310 
311     function Owner() public constant returns(address ownerAddress) {
312         return owner;
313     }
314 
315     function SetupDone() public constant returns(bool setupDoneFlag) {
316         return setupDone;
317     }
318 
319     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
320         return IsDistribRunning;
321     }
322 
323     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
324         return DistribStarted;
325     }
326     
327      
328     /**
329      * @dev Transfer the specified amount of tokens to the specified address.
330      *      This function works the same with the previous one
331      *      but doesn't contain `_data` param.
332      *      Added due to backwards compatibility reasons.
333      *
334      * @param _to    Receiver address.
335      * @param _value Amount of tokens that will be transferred.
336      */
337     
338 
339     
340       function transfer(address _to, uint _value, bytes _data) {
341         // Standard function transfer similar to ERC20 transfer with no _data .
342         // Added due to backwards compatibility reasons .
343         uint codeLength;
344 
345         assembly {
346             // Retrieve the size of the code on target address, this needs assembly .
347             codeLength := extcodesize(_to)
348         }
349 
350         balances[msg.sender] = balances[msg.sender].sub(_value);
351         balances[_to] = balances[_to].add(_value);
352         if(codeLength>0) {
353             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
354             receiver.tokenFallback(msg.sender, _value, _data);
355         }
356        Transfer(msg.sender, _to, _value, _data);
357     }
358 
359 
360       function transfer(address _to, uint _value) {
361         uint codeLength;
362         bytes memory empty;
363 
364         assembly {
365             // Retrieve the size of the code on target address, this needs assembly .
366             codeLength := extcodesize(_to)
367         }
368 
369         balances[msg.sender] = balances[msg.sender].sub(_value);
370         balances[_to] = balances[_to].add(_value);
371         if(codeLength>0) {
372             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
373             receiver.tokenFallback(msg.sender, _value, empty);
374         }
375          Transfer(msg.sender, _to, _value, empty);
376     }
377 
378     
379 
380     function transferFrom(
381         address _from,
382         address _to,
383         uint256 _amount
384     ) public returns(bool success) {
385         if (balances[_from] >= _amount &&
386             allowed[_from][msg.sender] >= _amount &&
387             _amount > 0 &&
388             balances[_to] + _amount > balances[_to]) {
389             balances[_from] -= _amount;
390             allowed[_from][msg.sender] -= _amount;
391             balances[_to] += _amount;
392             Transfer(_from, _to, _amount);
393             return true;
394         } else {
395             return false;
396         }
397     }
398 
399     function approve(address _spender, uint256 _amount) public returns(bool success) {
400         allowed[msg.sender][_spender] = _amount;
401         Approval(msg.sender, _spender, _amount);
402         return true;
403     }
404     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
405         ForeignToken token = ForeignToken(_tokenContract);
406         uint256 amount = token.balanceOf(address(this));
407         return token.transfer(owner, amount);
408     }
409 
410     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
411         return allowed[_owner][_spender];
412     }
413     function balanceOf(address _owner) public constant returns(uint256 balance) {
414         return balances[_owner];
415     }
416     
417     
418 }