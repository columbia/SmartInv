1 pragma solidity ^0.4.18;
2 
3 contract useContractWeb {
4 
5   ContractWeb internal web = ContractWeb(0x0);
6 
7 }
8 
9 contract Owned {
10 
11   address public owner = msg.sender;
12 
13   function transferOwner(address _newOwner) onlyOwner public returns (bool) {
14     owner = _newOwner;
15     return true;
16   }
17 
18   modifier onlyOwner {
19     require(msg.sender == owner);
20     _;
21   }
22 
23 }
24 
25 contract CheckPayloadSize {
26 
27   modifier onlyPayloadSize(uint256 _size) {
28     require(msg.data.length >= _size + 4);
29     _;
30   }
31 
32 }
33 
34 contract CanTransferTokens is CheckPayloadSize, Owned {
35 
36   function transferCustomToken(address _token, address _to, uint256 _value) onlyPayloadSize(3 * 32) onlyOwner public returns (bool) {
37     Token tkn = Token(_token);
38     return tkn.transfer(_to, _value);
39   }
40 
41 }
42 
43 contract SafeMath {
44 
45   function add(uint256 x, uint256 y) pure internal returns (uint256) {
46     require(x <= x + y);
47     return x + y;
48   }
49 
50   function sub(uint256 x, uint256 y) pure internal returns (uint256) {
51     require(x >= y);
52     return x - y;
53   }
54 
55 }
56 
57 contract CheckIfContract {
58 
59   function isContract(address _addr) view internal returns (bool) {
60     uint256 length;
61     if (_addr == address(0x0)) return false;
62     assembly {
63       length := extcodesize(_addr)
64     }
65     if(length > 0) {
66       return true;
67     } else {
68       return false;
69     }
70   }
71 }
72 
73 contract ContractReceiver {
74 
75   TKN internal fallback;
76 
77   struct TKN {
78     address sender;
79     uint256 value;
80     bytes data;
81     bytes4 sig;
82   }
83 
84   function getFallback() view public returns (TKN) {
85     return fallback;
86   }
87 
88 
89   function tokenFallback(address _from, uint256 _value, bytes _data) public returns (bool) {
90     TKN memory tkn;
91     tkn.sender = _from;
92     tkn.value = _value;
93     tkn.data = _data;
94     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
95     tkn.sig = bytes4(u);
96     fallback = tkn;
97     return true;
98   }
99 
100 }
101 
102 contract Token1st {
103 
104   address public currentTradingSystem;
105   address public currentExchangeSystem;
106 
107   mapping(address => uint) public balanceOf;
108   mapping(address => mapping (address => uint)) public allowance;
109   mapping(address => mapping (address => uint)) public tradingBalanceOf;
110   mapping(address => mapping (address => uint)) public exchangeBalanceOf;
111 
112   /* @notice get balance of a specific address */
113   function getBalanceOf(address _address) view public returns (uint amount){
114     return balanceOf[_address];
115   }
116 
117   event Transfer (address _to, address _from, uint _decimalAmount);
118 
119   /* A contract or user attempts to get the coins */
120   function transferDecimalAmountFrom(address _from, address _to, uint _value) public returns (bool success) {
121     require(balanceOf[_from]
122       - tradingBalanceOf[_from][currentTradingSystem]
123       - exchangeBalanceOf[_from][currentExchangeSystem] >= _value);                 // Check if the sender has enough
124     require(balanceOf[_to] + (_value) >= balanceOf[_to]);  // Check for overflows
125     require(_value <= allowance[_from][msg.sender]);   // Check allowance
126     balanceOf[_from] -= _value;                          // Subtract from the sender
127     balanceOf[_to] += _value;                            // Add the same to the recipient
128     allowance[_from][msg.sender] -= _value;
129     Transfer(_to, _from, _value);
130     return true;
131   }
132 
133     /* Allow another contract or user to spend some tokens in your behalf */
134   function approveSpenderDecimalAmount(address _spender, uint _value) public returns (bool success) {
135     allowance[msg.sender][_spender] = _value;
136     return true;
137   }
138 
139 }
140 
141 contract ContractWeb is CanTransferTokens, CheckIfContract {
142 
143       //contract name | contract info
144   mapping(string => contractInfo) internal contracts;
145 
146   event ContractAdded(string _name, address _referredTo);
147   event ContractEdited(string _name, address _referredTo);
148   event ContractMadePermanent(string _name);
149 
150   struct contractInfo {
151     address contractAddress;
152     bool isPermanent;
153   }
154 
155   function getContractAddress(string _name) view public returns (address) {
156     return contracts[_name].contractAddress;
157   }
158 
159   function isContractPermanent(string _name) view public returns (bool) {
160     return contracts[_name].isPermanent;
161   }
162 
163   function setContract(string _name, address _address) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
164     require(isContract(_address));
165     require(this != _address);
166     require(contracts[_name].contractAddress != _address);
167     require(contracts[_name].isPermanent == false);
168     address oldAddress = contracts[_name].contractAddress;
169     contracts[_name].contractAddress = _address;
170     if(oldAddress == address(0x0)) {
171       ContractAdded(_name, _address);
172     } else {
173       ContractEdited(_name, _address);
174     }
175     return true;
176   }
177 
178   function makeContractPermanent(string _name) onlyOwner public returns (bool) {
179     require(contracts[_name].contractAddress != address(0x0));
180     require(contracts[_name].isPermanent == false);
181     contracts[_name].isPermanent = true;
182     ContractMadePermanent(_name);
183     return true;
184   }
185 
186   function tokenSetup(address _Tokens1st, address _Balancecs, address _Token, address _Conversion, address _Distribution) onlyPayloadSize(5 * 32) onlyOwner public returns (bool) {
187     setContract("Token1st", _Tokens1st);
188     setContract("Balances", _Balancecs);
189     setContract("Token", _Token);
190     setContract("Conversion", _Conversion);
191     setContract("Distribution", _Distribution);
192     return true;
193   }
194 
195 }
196 
197 contract Balances is CanTransferTokens, SafeMath, useContractWeb {
198 
199   mapping(address => uint256) internal _balances;
200 
201   function get(address _account) view public returns (uint256) {
202     return _balances[_account];
203   }
204 
205   function tokenContract() view internal returns (address) {
206     return web.getContractAddress("Token");
207   }
208 
209   function Balances() public {
210     _balances[msg.sender] = 190 * 1000000 * 1000000000000000000;
211   }
212 
213   modifier onlyToken {
214     require(msg.sender == tokenContract());
215     _;
216   }
217 
218   function transfer(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) onlyToken public returns (bool success) {
219   _balances[_from] = sub(_balances[_from], _value);
220   _balances[_to] = add(_balances[_to], _value);
221   return true;
222   }
223 
224 }
225 
226 contract Token is CanTransferTokens, SafeMath, CheckIfContract, useContractWeb {
227 
228   string public symbol = "SHC";
229   string public name = "ShineCoin";
230   uint8 public decimals = 18;
231   uint256 public totalSupply = 190 * 1000000 * 1000000000000000000;
232 
233   mapping (address => mapping (address => uint256)) internal _allowance;
234 
235     // ERC20 Events
236   event Approval(address indexed from, address indexed to, uint256 value);
237   event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     // ERC223 Event
240   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
241 
242   function balanceOf(address _account) view public returns (uint256) {
243     return Balances(balancesContract()).get(_account);
244   }
245 
246   function allowance(address _from, address _to) view public returns (uint256 remaining) {
247     return _allowance[_from][_to];
248   }
249 
250   function balancesContract() view internal returns (address) {
251     return web.getContractAddress("Balances");
252   }
253 
254   function Token() public {
255     bytes memory empty;
256     Transfer(this, msg.sender, 190 * 1000000 * 1000000000000000000);
257     Transfer(this, msg.sender, 190 * 1000000 * 1000000000000000000, empty);
258   }
259 
260   function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) onlyPayloadSize(4 * 32) public returns (bool success) {
261     if(isContract(_to)) {
262       require(Balances(balancesContract()).get(msg.sender) >= _value);
263       Balances(balancesContract()).transfer(msg.sender, _to, _value);
264       ContractReceiver receiver = ContractReceiver(_to);
265       require(receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
266       Transfer(msg.sender, _to, _value);
267       Transfer(msg.sender, _to, _value, _data);
268       return true;
269     } else {
270       return transferToAddress(_to, _value, _data);
271     }
272   }
273 
274   function transfer(address _to, uint256 _value, bytes _data) onlyPayloadSize(3 * 32) public returns (bool success) {
275     if(isContract(_to)) {
276       return transferToContract(_to, _value, _data);
277     }
278     else {
279       return transferToAddress(_to, _value, _data);
280     }
281   }
282 
283   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
284     bytes memory empty;
285     if(isContract(_to)) {
286       return transferToContract(_to, _value, empty);
287     }
288     else {
289       return transferToAddress(_to, _value, empty);
290     }
291   }
292 
293   function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool success) {
294     require(Balances(balancesContract()).get(msg.sender) >= _value);
295     Balances(balancesContract()).transfer(msg.sender, _to, _value);
296     Transfer(msg.sender, _to, _value);
297     Transfer(msg.sender, _to, _value, _data);
298     return true;
299   }
300 
301   function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool success) {
302     require(Balances(balancesContract()).get(msg.sender) >= _value);
303     Balances(balancesContract()).transfer(msg.sender, _to, _value);
304     ContractReceiver receiver = ContractReceiver(_to);
305     receiver.tokenFallback(msg.sender, _value, _data);
306     Transfer(msg.sender, _to, _value);
307     Transfer(msg.sender, _to, _value, _data);
308     return true;
309   }
310 
311   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
312     bytes memory empty;
313     require(_value > 0 && _allowance[_from][msg.sender] >= _value && Balances(balancesContract()).get(_from) >= _value);
314     _allowance[_from][msg.sender] = sub(_allowance[_from][msg.sender], _value);
315     if(msg.sender != _to && isContract(_to)) {
316       Balances(balancesContract()).transfer(_from, _to, _value);
317       ContractReceiver receiver = ContractReceiver(_to);
318       receiver.tokenFallback(_from, _value, empty);
319     } else {
320       Balances(balancesContract()).transfer(_from, _to, _value);
321     }
322     Transfer(_from, _to, _value);
323     Transfer(_from, _to, _value, empty);
324     return true;
325   }
326 
327   function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
328     _allowance[msg.sender][_spender] = add(_allowance[msg.sender][_spender], _value);
329     Approval(msg.sender, _spender, _value);
330     return true;
331   }
332 
333 }
334 
335 contract Conversion is CanTransferTokens, useContractWeb {
336 
337   function token1stContract() view internal returns (address) {
338     return web.getContractAddress("Token1st");
339   }
340 
341   function tokenContract() view internal returns (address) {
342     return web.getContractAddress("Token");
343   }
344 
345   function deposit() onlyOwner public returns (bool) {
346     require(Token(tokenContract()).allowance(owner, this) > 0);
347     return Token(tokenContract()).transferFrom(owner, this, Token(tokenContract()).allowance(owner, this));
348   }
349 
350   function convert() public returns (bool) {
351     uint256 senderBalance = Token1st(token1stContract()).getBalanceOf(msg.sender);
352     require(Token1st(token1stContract()).allowance(msg.sender, this) >= senderBalance);
353     Token1st(token1stContract()).transferDecimalAmountFrom(msg.sender, owner, senderBalance);
354     return Token(tokenContract()).transfer(msg.sender, senderBalance * 10000000000);
355   }
356 
357 }
358 
359 contract Distribution is CanTransferTokens, SafeMath, useContractWeb {
360 
361   uint256 public liveSince;
362   uint256 public withdrawn;
363 
364   function withdrawnReadable() view public returns (uint256) {
365     return withdrawn / 1000000000000000000;
366   }
367 
368   function secondsLive() view public returns (uint256) {
369     if(liveSince != 0) {
370       return now - liveSince;
371     }
372   }
373 
374   function allowedSince() view public returns (uint256) {
375     return secondsLive() * 380265185769276972;
376   }
377 
378   function allowedSinceReadable() view public returns (uint256) {
379     return secondsLive() * 380265185769276972 / 1000000000000000000;
380   }
381 
382   function stillAllowed() view public returns (uint256) {
383     return allowedSince() - withdrawn;
384   }
385 
386   function stillAllowedReadable() view public returns (uint256) {
387     uint256 _1 = allowedSince() - withdrawn;
388     return _1 / 1000000000000000000;
389   }
390 
391   function tokenContract() view internal returns (address) {
392     return web.getContractAddress("Token");
393   }
394 
395   function makeLive() onlyOwner public returns (bool) {
396     require(liveSince == 0);
397     liveSince = now;
398     return true;
399   }
400 
401   function deposit() onlyOwner public returns (bool) {
402     require(Token(tokenContract()).allowance(owner, this) > 0);
403     return Token(tokenContract()).transferFrom(owner, this, Token(tokenContract()).allowance(owner, this));
404   }
405 
406   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
407     require(stillAllowed() >= _value && _value > 0 && liveSince != 0);
408     withdrawn = add(withdrawn, _value);
409     return Token(tokenContract()).transfer(_to, _value);
410   }
411 
412   function transferReadable(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
413     require(stillAllowed() >= _value * 1000000000000000000 && stillAllowed() != 0 && liveSince != 0);
414     withdrawn = add(withdrawn, _value * 1000000000000000000);
415     return Token(tokenContract()).transfer(_to, _value * 1000000000000000000);
416   }
417 
418 }