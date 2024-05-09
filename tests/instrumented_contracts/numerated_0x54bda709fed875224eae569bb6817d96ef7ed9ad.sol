1 /// @title DigixDAO Contract Interfaces
2 
3 contract ConfigInterface {
4   address public owner;
5   mapping (address => bool) admins;
6   mapping (bytes32 => address) addressMap;
7   mapping (bytes32 => bool) boolMap;
8   mapping (bytes32 => bytes32) bytesMap;
9   mapping (bytes32 => uint256) uintMap;
10 
11   /// @notice setConfigAddress sets configuration `_key` to `_val` 
12   /// @param _key The key name of the configuration.
13   /// @param _val The value of the configuration.
14   /// @return Whether the configuration setting was successful or not.
15   function setConfigAddress(bytes32 _key, address _val) returns (bool success);
16 
17   /// @notice setConfigBool sets configuration `_key` to `_val` 
18   /// @param _key The key name of the configuration.
19   /// @param _val The value of the configuration.
20   /// @return Whether the configuration setting was successful or not.
21   function setConfigBool(bytes32 _key, bool _val) returns (bool success);
22 
23   /// @notice setConfigBytes sets configuration `_key` to `_val`
24   /// @param _key The key name of the configuration.
25   /// @param _val The value of the configuration.
26   /// @return Whether the configuration setting was successful or not.
27   function setConfigBytes(bytes32 _key, bytes32 _val) returns (bool success);
28 
29   /// @notice setConfigUint `_key` to `_val`
30   /// @param _key The key name of the configuration.
31   /// @param _val The value of the configuration.
32   /// @return Whether the configuration setting was successful or not.
33   function setConfigUint(bytes32 _key, uint256 _val) returns (bool success);
34 
35   /// @notice getConfigAddress gets configuration `_key`'s value
36   /// @param _key The key name of the configuration.
37   /// @return The configuration value 
38   function getConfigAddress(bytes32 _key) returns (address val);
39 
40   /// @notice getConfigBool gets configuration `_key`'s value
41   /// @param _key The key name of the configuration.
42   /// @return The configuration value 
43   function getConfigBool(bytes32 _key) returns (bool val);
44 
45   /// @notice getConfigBytes gets configuration `_key`'s value
46   /// @param _key The key name of the configuration.
47   /// @return The configuration value 
48   function getConfigBytes(bytes32 _key) returns (bytes32 val);
49 
50   /// @notice getConfigUint gets configuration `_key`'s value
51   /// @param _key The key name of the configuration.
52   /// @return The configuration value 
53   function getConfigUint(bytes32 _key) returns (uint256 val);
54 
55   /// @notice addAdmin sets `_admin` as configuration admin
56   /// @return Whether the configuration setting was successful or not.  
57   function addAdmin(address _admin) returns (bool success);
58 
59   /// @notice removeAdmin removes  `_admin`'s rights
60   /// @param _admin The key name of the configuration.
61   /// @return Whether the configuration setting was successful or not.  
62   function removeAdmin(address _admin) returns (bool success);
63 
64 }
65 
66 contract TokenInterface {
67 
68   mapping (address => uint256) balances;
69   mapping (address => mapping (address => uint256)) allowed;
70   mapping (address => bool) seller;
71 
72   address config;
73   address owner;
74   address dao;
75   address public badgeLedger;
76   bool locked;
77 
78   /// @return total amount of tokens
79   uint256 public totalSupply;
80 
81   /// @param _owner The address from which the balance will be retrieved
82   /// @return The balance
83   function balanceOf(address _owner) constant returns (uint256 balance);
84 
85   /// @notice send `_value` tokens to `_to` from `msg.sender`
86   /// @param _to The address of the recipient
87   /// @param _value The amount of tokens to be transfered
88   /// @return Whether the transfer was successful or not
89   function transfer(address _to, uint256 _value) returns (bool success);
90 
91   /// @notice send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`
92   /// @param _from The address of the sender
93   /// @param _to The address of the recipient
94   /// @param _value The amount of tokens to be transfered
95   /// @return Whether the transfer was successful or not
96   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
97 
98   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on its behalf
99   /// @param _spender The address of the account able to transfer the tokens
100   /// @param _value The amount of tokens to be approved for transfer
101   /// @return Whether the approval was successful or not
102   function approve(address _spender, uint256 _value) returns (bool success);
103 
104   /// @param _owner The address of the account owning tokens
105   /// @param _spender The address of the account able to transfer the tokens
106   /// @return Amount of remaining tokens of _owner that _spender is allowed to spend
107   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
108 
109   /// @notice mint `_amount` of tokens to `_owner`
110   /// @param _owner The address of the account receiving the tokens
111   /// @param _amount The amount of tokens to mint
112   /// @return Whether or not minting was successful
113   function mint(address _owner, uint256 _amount) returns (bool success);
114 
115   /// @notice mintBadge Mint `_amount` badges to `_owner`
116   /// @param _owner The address of the account receiving the tokens
117   /// @param _amount The amount of tokens to mint
118   /// @return Whether or not minting was successful
119   function mintBadge(address _owner, uint256 _amount) returns (bool success);
120 
121   function registerDao(address _dao) returns (bool success);
122   function registerSeller(address _tokensales) returns (bool success);
123 
124   event Transfer(address indexed _from, address indexed _to, uint256 indexed _value);
125   event Mint(address indexed _recipient, uint256 indexed _amount);
126   event Approval(address indexed _owner, address indexed _spender, uint256 indexed _value);
127 }
128 
129 contract TokenSalesInterface {
130 
131   struct SaleProxy {
132     address payout;
133     bool isProxy;
134   }
135 
136   struct SaleStatus {
137     bool founderClaim;
138     uint256 releasedTokens;
139     uint256 releasedBadges;
140     uint256 claimers;
141   }
142 
143   struct Info {
144     uint256 totalWei;
145     uint256 totalCents;
146     uint256 realCents;
147     uint256 amount;
148   }
149 
150   struct SaleConfig {
151     uint256 startDate;
152     uint256 periodTwo;
153     uint256 periodThree;
154     uint256 endDate;
155     uint256 goal;
156     uint256 cap;
157     uint256 badgeCost;
158     uint256 founderAmount;
159     address founderWallet;
160   }
161 
162   struct Buyer {
163     uint256 centsTotal;
164     uint256 weiTotal;
165     bool claimed;
166   }
167 
168   Info saleInfo;
169   SaleConfig saleConfig;
170   SaleStatus saleStatus;
171 
172   address config;
173   address owner;
174   bool locked;
175 
176   uint256 public ethToCents;
177 
178   mapping (address => Buyer) buyers;
179   mapping (address => SaleProxy) proxies;
180 
181   /// @notice Calculates the parts per billion 1⁄1,000,000,000 of `_a` to `_b`
182   /// @param _a The antecedent
183   /// @param _c The consequent
184   /// @return Part per billion value
185   function ppb(uint256 _a, uint256 _c) public constant returns (uint256 b);
186 
187 
188   /// @notice Calculates the share from `_total` based on `_contrib` 
189   /// @param _contrib The contributed amount in USD
190   /// @param _total The total amount raised in USD
191   /// @return Total number of shares
192   function calcShare(uint256 _contrib, uint256 _total) public constant returns (uint256 share);
193 
194   /// @notice Calculates the current USD cents value of `_wei` 
195   /// @param _wei the amount of wei
196   /// @return The USD cents value
197   function weiToCents(uint256 _wei) public constant returns (uint256 centsvalue);
198 
199   function proxyPurchase(address _user) returns (bool success);
200 
201   /// @notice Send msg.value purchase for _user.  
202   /// @param _user The account to be credited
203   /// @return Success if purchase was accepted
204   function purchase(address _user, uint256 _amount) private returns (bool success);
205 
206   /// @notice Get crowdsale information for `_user`
207   /// @param _user The account to be queried
208   /// @return `centstotal` the total amount of USD cents contributed
209   /// @return `weitotal` the total amount in wei contributed
210   /// @return `share` the current token shares earned
211   /// @return `badges` the number of proposer badges earned
212   /// @return `claimed` is true if the tokens and badges have been claimed
213   function userInfo(address _user) public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed); 
214 
215   /// @notice Get the crowdsale information from msg.sender (see userInfo)
216   function myInfo() public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed); 
217 
218   /// @notice get the total amount of wei raised for the crowdsale
219   /// @return The amount of wei raised
220   function totalWei() public constant returns (uint);
221 
222   /// @notice get the total USD value in cents raised for the crowdsale
223   /// @return the amount USD cents
224   function totalCents() public constant returns (uint);
225 
226   /// @notice get the current crowdsale information
227   /// @return `startsale` The unix timestamp for the start of the crowdsale and the first period modifier
228   /// @return `two` The unix timestamp for the start of the second period modifier
229   /// @return `three` The unix timestamp for the start of the third period modifier
230   /// @return `endsale` The unix timestamp of the end of crowdsale
231   /// @return `totalwei` The total amount of wei raised
232   /// @return `totalcents` The total number of USD cents raised
233   /// @return `amount` The amount of DGD tokens available for the crowdsale
234   /// @return `goal` The USD value goal for the crowdsale
235   /// @return `famount` Founders endowment
236   /// @return `faddress` Founder wallet address
237   /*function getSaleInfo() public constant returns (uint256 startsale, uint256 two, uint256 three, uint256 endsale, uint256 totalwei, uint256 totalcents, uint256 amount, uint256 goal, uint256 famount, address faddress);*/
238 
239   function claimFor(address _user) returns (bool success); 
240 
241   /// @notice Allows msg.sender to claim the DGD tokens and badges if the goal is reached or refunds the ETH contributed if goal is not reached at the end of the crowdsale
242   function claim() returns (bool success);
243 
244   function claimFounders() returns (bool success);
245 
246   /// @notice See if the crowdsale goal has been reached
247   function goalReached() public constant returns (bool reached);
248 
249   /// @notice Get the current sale period
250   /// @return `saleperiod` 0 = Outside of the crowdsale period, 1 = First reward period, 2 = Second reward period, 3 = Final crowdsale period.
251   function getPeriod() public constant returns (uint saleperiod);
252 
253   /// @notice Get the date for the start of the crowdsale
254   /// @return `date` The unix timestamp for the start
255   function startDate() public constant returns (uint date);
256   
257   /// @notice Get the date for the second reward period of the crowdsale
258   /// @return `date` The unix timestamp for the second period
259   function periodTwo() public constant returns (uint date);
260 
261   /// @notice Get the date for the final period of the crowdsale
262   /// @return `date` The unix timestamp for the final period
263   function periodThree() public constant returns (uint date);
264 
265   /// @notice Get the date for the end of the crowdsale
266   /// @return `date` The unix timestamp for the end of the crowdsale
267   function endDate() public constant returns (uint date);
268 
269   /// @notice Check if crowdsale has ended
270   /// @return `ended` If the crowdsale has ended
271   
272   function isEnded() public constant returns (bool ended);
273 
274   /// @notice Send raised funds from the crowdsale to the DAO
275   /// @return `success` if the send succeeded
276   function sendFunds() public returns (bool success);
277 
278   //function regProxy(address _payment, address _payout) returns (bool success);
279   function regProxy(address _payout) returns (bool success);
280 
281   function getProxy(address _payout) public returns (address proxy);
282   
283   function getPayout(address _proxy) public returns (address payout, bool isproxy);
284 
285   function unlock() public returns (bool success);
286 
287   function getSaleStatus() public constant returns (bool fclaim, uint256 reltokens, uint256 relbadges, uint256 claimers);
288 
289   function getSaleInfo() public constant returns (uint256 weiamount, uint256 cents, uint256 realcents, uint256 amount);
290 
291   function getSaleConfig() public constant returns (uint256 start, uint256 two, uint256 three, uint256 end, uint256 goal, uint256 cap, uint256 badgecost, uint256 famount, address fwallet);
292   
293   event Purchase(uint256 indexed _exchange, uint256 indexed _rate, uint256 indexed _cents);
294   event Claim(address indexed _user, uint256 indexed _amount, uint256 indexed _badges);
295 
296 }
297 
298 
299 contract Badge  {
300   mapping (address => uint256) balances;
301   mapping (address => mapping (address => uint256)) allowed;
302 
303   address public owner;
304   bool public locked;
305 
306   /// @return total amount of tokens
307   uint256 public totalSupply;
308 
309   modifier ifOwner() {
310     if (msg.sender != owner) {
311       throw;
312     } else {
313       _
314     }
315   }
316 
317 
318   event Transfer(address indexed _from, address indexed _to, uint256 _value);
319   event Mint(address indexed _recipient, uint256 indexed _amount);
320   event Approval(address indexed _owner, address indexed _spender, uint256  _value);
321 
322   function Badge() {
323     owner = msg.sender;
324   }
325 
326   function safeToAdd(uint a, uint b) returns (bool) {
327     return (a + b >= a);
328   }
329 
330   function addSafely(uint a, uint b) returns (uint result) {
331     if (!safeToAdd(a, b)) {
332       throw;
333     } else {
334       result = a + b;
335       return result;
336     }
337   }
338 
339   function safeToSubtract(uint a, uint b) returns (bool) {
340     return (b <= a);
341   }
342 
343   function subtractSafely(uint a, uint b) returns (uint) {
344     if (!safeToSubtract(a, b)) throw;
345     return a - b;
346   }
347 
348   function balanceOf(address _owner) constant returns (uint256 balance) {
349     return balances[_owner];
350   }
351 
352   function transfer(address _to, uint256 _value) returns (bool success) {
353     if (balances[msg.sender] >= _value && _value > 0) {
354       balances[msg.sender] = subtractSafely(balances[msg.sender], _value);
355       balances[_to] = addSafely(_value, balances[_to]);
356       Transfer(msg.sender, _to, _value);
357       success = true;
358     } else {
359       success = false;
360     }
361     return success;
362   }
363 
364   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
365     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
366       balances[_to] = addSafely(balances[_to], _value);
367       balances[_from] = subtractSafely(balances[_from], _value);
368       allowed[_from][msg.sender] = subtractSafely(allowed[_from][msg.sender], _value);
369       Transfer(_from, _to, _value);
370       return true;
371     } else {
372       return false;
373     }
374   }
375 
376   function approve(address _spender, uint256 _value) returns (bool success) {
377     allowed[msg.sender][_spender] = _value;
378     Approval(msg.sender, _spender, _value);
379     success = true;
380     return success;
381   }
382 
383   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
384     remaining = allowed[_owner][_spender];
385     return remaining;
386   }
387 
388   function mint(address _owner, uint256 _amount) ifOwner returns (bool success) {
389     totalSupply = addSafely(totalSupply, _amount);
390     balances[_owner] = addSafely(balances[_owner], _amount);
391     Mint(_owner, _amount);
392     return true;
393   }
394 
395   function setOwner(address _owner) ifOwner returns (bool success) {
396     owner = _owner;
397     return true;
398   }
399 
400 }
401 
402 contract Token {
403 
404   address public owner;
405   address public config;
406   bool public locked;
407   address public dao;
408   address public badgeLedger;
409   uint256 public totalSupply;
410 
411   mapping (address => uint256) balances;
412   mapping (address => mapping (address => uint256)) allowed;
413   mapping (address => bool) seller;
414 
415   /// @return total amount of tokens
416 
417   modifier ifSales() {
418     if (!seller[msg.sender]) throw; 
419     _ 
420   }
421 
422   modifier ifOwner() {
423     if (msg.sender != owner) throw;
424     _
425   }
426 
427   modifier ifDao() {
428     if (msg.sender != dao) throw;
429     _
430   }
431 
432   event Transfer(address indexed _from, address indexed _to, uint256 _value);
433   event Mint(address indexed _recipient, uint256  _amount);
434   event Approval(address indexed _owner, address indexed _spender, uint256  _value);
435 
436   function Token(address _config) {
437     config = _config;
438     owner = msg.sender;
439     address _initseller = ConfigInterface(_config).getConfigAddress("sale1:address");
440     seller[_initseller] = true; 
441     badgeLedger = new Badge();
442     locked = false;
443   }
444 
445   function safeToAdd(uint a, uint b) returns (bool) {
446     return (a + b >= a);
447   }
448 
449   function addSafely(uint a, uint b) returns (uint result) {
450     if (!safeToAdd(a, b)) {
451       throw;
452     } else {
453       result = a + b;
454       return result;
455     }
456   }
457 
458   function safeToSubtract(uint a, uint b) returns (bool) {
459     return (b <= a);
460   }
461 
462   function subtractSafely(uint a, uint b) returns (uint) {
463     if (!safeToSubtract(a, b)) throw;
464     return a - b;
465   }
466 
467   function balanceOf(address _owner) constant returns (uint256 balance) {
468     return balances[_owner];
469   }
470 
471   function transfer(address _to, uint256 _value) returns (bool success) {
472     if (balances[msg.sender] >= _value && _value > 0) {
473       balances[msg.sender] = subtractSafely(balances[msg.sender], _value);
474       balances[_to] = addSafely(balances[_to], _value);
475       Transfer(msg.sender, _to, _value);
476       success = true;
477     } else {
478       success = false;
479     }
480     return success;
481   }
482 
483   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
484     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
485       balances[_to] = addSafely(balances[_to], _value);
486       balances[_from] = subtractSafely(balances[_from], _value);
487       allowed[_from][msg.sender] = subtractSafely(allowed[_from][msg.sender], _value);
488       Transfer(_from, _to, _value);
489       return true;
490     } else {
491       return false;
492     }
493   }
494 
495   function approve(address _spender, uint256 _value) returns (bool success) {
496     allowed[msg.sender][_spender] = _value;
497     Approval(msg.sender, _spender, _value);
498     success = true;
499     return success;
500   }
501 
502   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
503     remaining = allowed[_owner][_spender];
504     return remaining;
505   }
506   function mint(address _owner, uint256 _amount) ifSales returns (bool success) {
507     totalSupply = addSafely(_amount, totalSupply);
508     balances[_owner] = addSafely(balances[_owner], _amount);
509     return true;
510   }
511 
512   function mintBadge(address _owner, uint256 _amount) ifSales returns (bool success) {
513     if (!Badge(badgeLedger).mint(_owner, _amount)) return false;
514     return true;
515   }
516 
517   function registerDao(address _dao) ifOwner returns (bool success) {
518     if (locked == true) return false;
519     dao = _dao;
520     locked = true;
521     return true;
522   }
523 
524   function setDao(address _newdao) ifDao returns (bool success) {
525     dao = _newdao;
526     return true;
527   }
528 
529   function isSeller(address _query) returns (bool isseller) {
530     return seller[_query];
531   }
532 
533   function registerSeller(address _tokensales) ifDao returns (bool success) {
534     seller[_tokensales] = true;
535     return true;
536   }
537 
538   function unregisterSeller(address _tokensales) ifDao returns (bool success) {
539     seller[_tokensales] = false;
540     return true;
541   }
542 
543   function setOwner(address _newowner) ifDao returns (bool success) {
544     if(Badge(badgeLedger).setOwner(_newowner)) {
545       owner = _newowner;
546       success = true;
547     } else {
548       success = false;
549     }
550     return success;
551   }
552 
553 }