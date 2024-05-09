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
68   struct User {
69     bool locked;
70     uint256 balance;
71     uint256 badges;
72     mapping (address => uint256) allowed;
73   }
74 
75   mapping (address => User) users;
76   mapping (address => uint256) balances;
77   mapping (address => mapping (address => uint256)) allowed;
78   mapping (address => bool) seller;
79 
80   address config;
81   address owner;
82   address dao;
83   bool locked;
84 
85   /// @return total amount of tokens
86   uint256 public totalSupply;
87   uint256 public totalBadges;
88 
89   /// @param _owner The address from which the balance will be retrieved
90   /// @return The balance
91   function balanceOf(address _owner) constant returns (uint256 balance);
92 
93   /// @param _owner The address from which the badge count will be retrieved
94   /// @return The badges count
95   function badgesOf(address _owner) constant returns (uint256 badge);
96 
97   /// @notice send `_value` tokens to `_to` from `msg.sender`
98   /// @param _to The address of the recipient
99   /// @param _value The amount of tokens to be transfered
100   /// @return Whether the transfer was successful or not
101   function transfer(address _to, uint256 _value) returns (bool success);
102 
103   /// @notice send `_value` badges to `_to` from `msg.sender`
104   /// @param _to The address of the recipient
105   /// @param _value The amount of tokens to be transfered
106   /// @return Whether the transfer was successful or not
107   function sendBadge(address _to, uint256 _value) returns (bool success);
108 
109   /// @notice send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`
110   /// @param _from The address of the sender
111   /// @param _to The address of the recipient
112   /// @param _value The amount of tokens to be transfered
113   /// @return Whether the transfer was successful or not
114   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
115 
116   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on its behalf
117   /// @param _spender The address of the account able to transfer the tokens
118   /// @param _value The amount of tokens to be approved for transfer
119   /// @return Whether the approval was successful or not
120   function approve(address _spender, uint256 _value) returns (bool success);
121 
122   /// @param _owner The address of the account owning tokens
123   /// @param _spender The address of the account able to transfer the tokens
124   /// @return Amount of remaining tokens of _owner that _spender is allowed to spend
125   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
126 
127   /// @notice mint `_amount` of tokens to `_owner`
128   /// @param _owner The address of the account receiving the tokens
129   /// @param _amount The amount of tokens to mint
130   /// @return Whether or not minting was successful
131   function mint(address _owner, uint256 _amount) returns (bool success);
132 
133   /// @notice mintBadge Mint `_amount` badges to `_owner`
134   /// @param _owner The address of the account receiving the tokens
135   /// @param _amount The amount of tokens to mint
136   /// @return Whether or not minting was successful
137   function mintBadge(address _owner, uint256 _amount) returns (bool success);
138 
139   function registerDao(address _dao) returns (bool success);
140 
141   function registerSeller(address _tokensales) returns (bool success);
142 
143   event Transfer(address indexed _from, address indexed _to, uint256 _value);
144   event SendBadge(address indexed _from, address indexed _to, uint256 _amount);
145   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 }
147 
148 contract TokenSalesInterface {
149 
150   struct SaleProxy {
151     address payout;
152     bool isProxy;
153   }
154 
155   struct SaleStatus {
156     bool founderClaim;
157     uint256 releasedTokens;
158     uint256 releasedBadges;
159     uint256 claimers;
160   }
161 
162   struct Info {
163     uint256 totalWei;
164     uint256 totalCents;
165     uint256 realCents;
166     uint256 amount;
167   }
168 
169   struct SaleConfig {
170     uint256 startDate;
171     uint256 periodTwo;
172     uint256 periodThree;
173     uint256 endDate;
174     uint256 goal;
175     uint256 cap;
176     uint256 badgeCost;
177     uint256 founderAmount;
178     address founderWallet;
179   }
180 
181   struct Buyer {
182     uint256 centsTotal;
183     uint256 weiTotal;
184     bool claimed;
185   }
186 
187   Info saleInfo;
188   SaleConfig saleConfig;
189   SaleStatus saleStatus;
190 
191   address config;
192   address owner;
193   bool locked;
194 
195   uint256 public ethToCents;
196 
197   mapping (address => Buyer) buyers;
198   mapping (address => SaleProxy) proxies;
199 
200   /// @notice Calculates the parts per billion 1â„1,000,000,000 of `_a` to `_b`
201   /// @param _a The antecedent
202   /// @param _c The consequent
203   /// @return Part per billion value
204   function ppb(uint256 _a, uint256 _c) public constant returns (uint256 b);
205 
206 
207   /// @notice Calculates the share from `_total` based on `_contrib` 
208   /// @param _contrib The contributed amount in USD
209   /// @param _total The total amount raised in USD
210   /// @return Total number of shares
211   function calcShare(uint256 _contrib, uint256 _total) public constant returns (uint256 share);
212 
213   /// @notice Calculates the current USD cents value of `_wei` 
214   /// @param _wei the amount of wei
215   /// @return The USD cents value
216   function weiToCents(uint256 _wei) public constant returns (uint256 centsvalue);
217 
218   function proxyPurchase(address _user) returns (bool success);
219 
220   /// @notice Send msg.value purchase for _user.  
221   /// @param _user The account to be credited
222   /// @return Success if purchase was accepted
223   function purchase(address _user, uint256 _amount) private returns (bool success);
224 
225   /// @notice Get crowdsale information for `_user`
226   /// @param _user The account to be queried
227   /// @return `centstotal` the total amount of USD cents contributed
228   /// @return `weitotal` the total amount in wei contributed
229   /// @return `share` the current token shares earned
230   /// @return `badges` the number of proposer badges earned
231   /// @return `claimed` is true if the tokens and badges have been claimed
232   function userInfo(address _user) public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed); 
233 
234   /// @notice Get the crowdsale information from msg.sender (see userInfo)
235   function myInfo() public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed); 
236 
237   /// @notice get the total amount of wei raised for the crowdsale
238   /// @return The amount of wei raised
239   function totalWei() public constant returns (uint);
240 
241   /// @notice get the total USD value in cents raised for the crowdsale
242   /// @return the amount USD cents
243   function totalCents() public constant returns (uint);
244 
245   /// @notice get the current crowdsale information
246   /// @return `startsale` The unix timestamp for the start of the crowdsale and the first period modifier
247   /// @return `two` The unix timestamp for the start of the second period modifier
248   /// @return `three` The unix timestamp for the start of the third period modifier
249   /// @return `endsale` The unix timestamp of the end of crowdsale
250   /// @return `totalwei` The total amount of wei raised
251   /// @return `totalcents` The total number of USD cents raised
252   /// @return `amount` The amount of DGD tokens available for the crowdsale
253   /// @return `goal` The USD value goal for the crowdsale
254   /// @return `famount` Founders endowment
255   /// @return `faddress` Founder wallet address
256   /*function getSaleInfo() public constant returns (uint256 startsale, uint256 two, uint256 three, uint256 endsale, uint256 totalwei, uint256 totalcents, uint256 amount, uint256 goal, uint256 famount, address faddress);*/
257 
258   function claimFor(address _user) returns (bool success); 
259 
260   /// @notice Allows msg.sender to claim the DGD tokens and badges if the goal is reached or refunds the ETH contributed if goal is not reached at the end of the crowdsale
261   function claim() returns (bool success);
262 
263   function claimFounders() returns (bool success);
264 
265   /// @notice See if the crowdsale goal has been reached
266   function goalReached() public constant returns (bool reached);
267 
268   /// @notice Get the current sale period
269   /// @return `saleperiod` 0 = Outside of the crowdsale period, 1 = First reward period, 2 = Second reward period, 3 = Final crowdsale period.
270   function getPeriod() public constant returns (uint saleperiod);
271 
272   /// @notice Get the date for the start of the crowdsale
273   /// @return `date` The unix timestamp for the start
274   function startDate() public constant returns (uint date);
275   
276   /// @notice Get the date for the second reward period of the crowdsale
277   /// @return `date` The unix timestamp for the second period
278   function periodTwo() public constant returns (uint date);
279 
280   /// @notice Get the date for the final period of the crowdsale
281   /// @return `date` The unix timestamp for the final period
282   function periodThree() public constant returns (uint date);
283 
284   /// @notice Get the date for the end of the crowdsale
285   /// @return `date` The unix timestamp for the end of the crowdsale
286   function endDate() public constant returns (uint date);
287 
288   /// @notice Check if crowdsale has ended
289   /// @return `ended` If the crowdsale has ended
290   
291   function isEnded() public constant returns (bool ended);
292 
293   /// @notice Send raised funds from the crowdsale to the DAO
294   /// @return `success` if the send succeeded
295   function sendFunds() public returns (bool success);
296 
297   //function regProxy(address _payment, address _payout) returns (bool success);
298   function regProxy(address _payout) returns (bool success);
299 
300   function getProxy(address _payout) public returns (address proxy);
301   
302   function getPayout(address _proxy) public returns (address payout, bool isproxy);
303 
304   function unlock() public returns (bool success);
305 
306   function getSaleStatus() public constant returns (bool fclaim, uint256 reltokens, uint256 relbadges, uint256 claimers);
307 
308   function getSaleInfo() public constant returns (uint256 weiamount, uint256 cents, uint256 realcents, uint256 amount);
309 
310   function getSaleConfig() public constant returns (uint256 start, uint256 two, uint256 three, uint256 end, uint256 goal, uint256 cap, uint256 badgecost, uint256 famount, address fwallet);
311   
312   event Purchase(uint256 indexed _exchange, uint256 indexed _rate, uint256 indexed _cents);
313   event Claim(address indexed _user, uint256 indexed _amount, uint256 indexed _badges);
314 
315 }
316 
317 contract ProxyPayment {
318 
319   address payout;
320   address tokenSales; 
321   address owner;
322 
323   function ProxyPayment(address _payout, address _tokenSales) {
324     payout = _payout;
325     tokenSales = _tokenSales;
326     owner = _payout;
327   }
328 
329   function () {
330     if (!TokenSalesInterface(tokenSales).proxyPurchase.value(msg.value).gas(106000)(payout)) throw;
331   }
332 
333 }
334 
335 contract TokenSales is TokenSalesInterface {
336 
337   modifier ifOwner() {
338     if (msg.sender != owner) throw;
339     _
340   }
341 
342   modifier ifOOrigin() {
343     if (tx.origin != owner) throw;
344     _
345   }
346 
347   mapping (address => address) proxyPayouts;
348   uint256 public WEI_PER_ETH = 1000000000000000000;
349   uint256 public BILLION = 1000000000;
350   uint256 public CENTS = 100;
351 
352 
353   function TokenSales(address _config) {
354     owner = msg.sender;
355     config = _config;
356     saleStatus.founderClaim = false;
357     saleStatus.releasedTokens = 0;
358     saleStatus.releasedBadges = 0;
359     saleStatus.claimers = 0;
360     saleConfig.startDate = ConfigInterface(_config).getConfigUint("sale1:period1");
361     saleConfig.periodTwo = ConfigInterface(_config).getConfigUint("sale1:period2");
362     saleConfig.periodThree = ConfigInterface(_config).getConfigUint("sale1:period3");
363     saleConfig.endDate = ConfigInterface(_config).getConfigUint("sale1:end");
364     saleConfig.founderAmount = ConfigInterface(_config).getConfigUint("sale1:famount") * BILLION;
365     saleConfig.founderWallet = ConfigInterface(_config).getConfigAddress("sale1:fwallet");
366     saleConfig.goal = ConfigInterface(_config).getConfigUint("sale1:goal") * CENTS;
367     saleConfig.cap = ConfigInterface(_config).getConfigUint("sale1:cap") * CENTS;
368     saleConfig.badgeCost = ConfigInterface(_config).getConfigUint("sale1:badgecost") * CENTS;
369     saleInfo.amount = ConfigInterface(_config).getConfigUint("sale1:amount") * BILLION;
370     saleInfo.totalWei = 0;
371     saleInfo.totalCents = 0;
372     saleInfo.realCents;
373     saleStatus.founderClaim = false;
374     locked = true;
375   }
376 
377   function () {
378     if (getPeriod() == 0) throw;
379     uint256 _amount = msg.value;
380     address _sender;
381     if (proxies[msg.sender].isProxy == true) {
382       _sender = proxies[msg.sender].payout;
383     } else {
384       _sender = msg.sender;
385     }
386     if (!purchase(_sender, _amount)) throw;
387   }
388 
389   function proxyPurchase(address _user) returns (bool success) {
390     return purchase(_user, msg.value);
391   }
392 
393   function purchase(address _user, uint256 _amount) private returns (bool success) {
394     uint256 _cents = weiToCents(_amount);
395     if ((saleInfo.realCents + _cents) > saleConfig.cap) return false;
396     uint256 _wei = _amount;
397     uint256 _modifier;
398     uint _period = getPeriod();
399     if ((_period == 0) || (_cents == 0)) {
400       return false;
401     } else {
402       if (_period == 3) _modifier = 100;
403       if (_period == 2) _modifier = 115;
404       if (_period == 1) _modifier = 130;
405       uint256 _creditwei = _amount;
406       uint256 _creditcents = (weiToCents(_creditwei) * _modifier * 10000) / 1000000 ;
407       buyers[_user].centsTotal += _creditcents;
408       buyers[_user].weiTotal += _creditwei; 
409       saleInfo.totalCents += _creditcents;
410       saleInfo.realCents += _cents;
411       saleInfo.totalWei += _creditwei;
412       Purchase(ethToCents, _modifier, _creditcents); 
413       return true;
414     }
415   }
416 
417   function ppb(uint256 _a, uint256 _c) public constant returns (uint256 b) {
418     b = (BILLION * _a + _c / 2) / _c;
419     return b;
420   }
421 
422   function calcShare(uint256 _contrib, uint256 _total) public constant returns (uint256 share) {
423     uint256 _ppb = ppb(_contrib, _total);
424     share = ((_ppb * saleInfo.amount) / BILLION);
425     return share;
426   }
427 
428   function weiToCents(uint256 _wei) public constant returns (uint256 centsvalue) {
429     centsvalue = ((_wei * 100000 / WEI_PER_ETH) * ethToCents) / 100000;
430     return centsvalue;
431   }
432 
433   function setEthToCents(uint256 _eth) ifOwner returns (bool success) {
434     ethToCents = _eth;
435     success = true;
436     return success;
437   }
438 
439 
440   function getSaleStatus() public constant returns (bool fclaim, uint256 reltokens, uint256 relbadges, uint256 claimers) {
441     return (saleStatus.founderClaim, saleStatus.releasedTokens, saleStatus.releasedBadges, saleStatus.claimers);
442   }
443 
444   function getSaleInfo() public constant returns (uint256 weiamount, uint256 cents, uint256 realcents, uint256 amount) {
445     return (saleInfo.totalWei, saleInfo.totalCents, saleInfo.realCents, saleInfo.amount);
446   }
447 
448 
449   function getSaleConfig() public constant returns (uint256 start, uint256 two, uint256 three, uint256 end, uint256 goal, uint256 cap, uint256 badgecost, uint256 famount, address fwallet) {
450     return (saleConfig.startDate, saleConfig.periodTwo, saleConfig.periodThree, saleConfig.endDate, saleConfig.goal, saleConfig.cap, saleConfig.badgeCost, saleConfig.founderAmount, saleConfig.founderWallet);
451   }
452 
453   function goalReached() public constant returns (bool reached) {
454     reached = (saleInfo.totalCents >= saleConfig.goal);
455     return reached;
456   }
457 
458   function claim() returns (bool success) {
459     return claimFor(msg.sender);
460   }
461 
462   function claimFor(address _user) returns (bool success) {
463     if ( (now < saleConfig.endDate) || (buyers[_user].claimed == true) ) {
464       return true;
465     }
466   
467     if (!goalReached()) {
468       if (!address(_user).send(buyers[_user].weiTotal)) throw;
469       buyers[_user].claimed = true;
470       return true;
471     }
472 
473     if (goalReached()) {
474       address _tokenc = ConfigInterface(config).getConfigAddress("ledger");
475       uint256 _tokens = calcShare(buyers[_user].centsTotal, saleInfo.totalCents); 
476       uint256 _badges = buyers[_user].centsTotal / saleConfig.badgeCost;
477       if ((TokenInterface(_tokenc).mint(msg.sender, _tokens)) && (TokenInterface(_tokenc).mintBadge(_user, _badges))) {
478         saleStatus.releasedTokens += _tokens;
479         saleStatus.releasedBadges += _badges;
480         saleStatus.claimers += 1;
481         buyers[_user].claimed = true;
482         Claim(_user, _tokens, _badges);
483         return true;
484       } else {
485         return false;
486       }
487     }
488 
489   }
490 
491   function claimFounders() returns (bool success) {
492     if (saleStatus.founderClaim == true) return false;
493     if (now < saleConfig.endDate) return false;
494     if (!goalReached()) return false;
495     address _tokenc = ConfigInterface(config).getConfigAddress("ledger");
496     uint256 _tokens = saleConfig.founderAmount;
497     uint256 _badges = 4;
498     address _faddr = saleConfig.founderWallet;
499     if ((TokenInterface(_tokenc).mint(_faddr, _tokens)) && (TokenInterface(_tokenc).mintBadge(_faddr, _badges))) {
500       saleStatus.founderClaim = true;
501       saleStatus.releasedTokens += _tokens;
502       saleStatus.releasedBadges += _badges;
503       saleStatus.claimers += 1;
504       Claim(_faddr, _tokens, _badges);
505       return true;
506     } else {
507       return false;
508     }
509   }
510 
511   function getPeriod() public constant returns (uint saleperiod) {
512     if ((now > saleConfig.endDate) || (now < saleConfig.startDate)) {
513       saleperiod = 0;
514       return saleperiod;
515     }
516     if (now >= saleConfig.periodThree) {
517       saleperiod = 3;
518       return saleperiod;
519     }
520     if (now >= saleConfig.periodTwo) {
521       saleperiod = 2;
522       return saleperiod;
523     }
524     if (now < saleConfig.periodTwo) {
525       saleperiod = 1;
526       return saleperiod;
527     }
528   }
529 
530   function userInfo(address _user) public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed) {
531     share = calcShare(buyers[_user].centsTotal, saleInfo.totalCents);
532     badges = buyers[_user].centsTotal / saleConfig.badgeCost;
533     return (buyers[_user].centsTotal, buyers[_user].weiTotal, share, badges, buyers[_user].claimed);
534   }
535 
536   function myInfo() public constant returns (uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed) {
537     return userInfo(msg.sender);
538   }
539 
540   function totalWei() public constant returns (uint) {
541     return saleInfo.totalWei;
542   }
543 
544   function totalCents() public constant returns (uint) {
545     return saleInfo.totalCents;
546   }
547 
548   function startDate() public constant returns (uint date) {
549     return saleConfig.startDate;
550   }
551   
552   function periodTwo() public constant returns (uint date) {
553     return saleConfig.periodTwo;
554   }
555 
556   function periodThree() public constant returns (uint date) {
557     return saleConfig.periodThree;
558   }
559 
560   function endDate() public constant returns (uint date) {
561     return saleConfig.endDate;
562   }
563 
564   function isEnded() public constant returns (bool ended) {
565     return (now >= endDate());
566   }
567   
568   function sendFunds() public returns (bool success) {
569     if (locked) return false;
570     if (!goalReached()) return false;
571     if (!isEnded()) return false;
572     address _dao = ConfigInterface(config).getConfigAddress("sale1:dao");
573     if (_dao == 0x0000000000000000000000000000000000000000) return false;
574     return _dao.send(totalWei());
575   }
576 
577   function regProxy(address _payout) ifOOrigin returns (bool success) {
578     address _proxy = new ProxyPayment(_payout, address(this));
579     proxies[_proxy].payout = _payout;
580     proxies[_proxy].isProxy = true;
581     proxyPayouts[_payout] = _proxy;
582     return true;
583   }
584   
585   function getProxy(address _payout) public returns (address proxy) {
586     return proxyPayouts[_payout];
587   }
588 
589   function getPayout(address _proxy) public returns (address payout, bool isproxy) {
590     return (proxies[_proxy].payout, proxies[_proxy].isProxy);
591   }
592 
593   function unlock() ifOwner public returns (bool success) {
594     locked = false;
595     return true;
596   }
597 }