1 pragma solidity ^0.4.11;
2 contract ConfigInterface {
3         address public owner;
4         mapping(address => bool) admins;
5         mapping(bytes32 => address) addressMap;
6         mapping(bytes32 => bool) boolMap;
7         mapping(bytes32 => bytes32) bytesMap;
8         mapping(bytes32 => uint256) uintMap;
9 
10         /// @notice setConfigAddress sets configuration `_key` to `_val`
11         /// @param _key The key name of the configuration.
12         /// @param _val The value of the configuration.
13         /// @return Whether the configuration setting was successful or not.
14         function setConfigAddress(bytes32 _key, address _val) returns(bool success);
15 
16         /// @notice setConfigBool sets configuration `_key` to `_val`
17         /// @param _key The key name of the configuration.
18         /// @param _val The value of the configuration.
19         /// @return Whether the configuration setting was successful or not.
20         function setConfigBool(bytes32 _key, bool _val) returns(bool success);
21 
22         /// @notice setConfigBytes sets configuration `_key` to `_val`
23         /// @param _key The key name of the configuration.
24         /// @param _val The value of the configuration.
25         /// @return Whether the configuration setting was successful or not.
26         function setConfigBytes(bytes32 _key, bytes32 _val) returns(bool success);
27 
28         /// @notice setConfigUint `_key` to `_val`
29         /// @param _key The key name of the configuration.
30         /// @param _val The value of the configuration.
31         /// @return Whether the configuration setting was successful or not.
32         function setConfigUint(bytes32 _key, uint256 _val) returns(bool success);
33 
34         /// @notice getConfigAddress gets configuration `_key`'s value
35         /// @param _key The key name of the configuration.
36         /// @return The configuration value
37         function getConfigAddress(bytes32 _key) returns(address val);
38 
39         /// @notice getConfigBool gets configuration `_key`'s value
40         /// @param _key The key name of the configuration.
41         /// @return The configuration value
42         function getConfigBool(bytes32 _key) returns(bool val);
43 
44         /// @notice getConfigBytes gets configuration `_key`'s value
45         /// @param _key The key name of the configuration.
46         /// @return The configuration value
47         function getConfigBytes(bytes32 _key) returns(bytes32 val);
48 
49         /// @notice getConfigUint gets configuration `_key`'s value
50         /// @param _key The key name of the configuration.
51         /// @return The configuration value
52         function getConfigUint(bytes32 _key) returns(uint256 val);
53 
54         /// @notice addAdmin sets `_admin` as configuration admin
55         /// @return Whether the configuration setting was successful or not.
56         function addAdmin(address _admin) returns(bool success);
57 
58         /// @notice removeAdmin removes  `_admin`'s rights
59         /// @param _admin The key name of the configuration.
60         /// @return Whether the configuration setting was successful or not.
61         function removeAdmin(address _admin) returns(bool success);
62 
63 }
64 
65 contract TokenInterface {
66 
67         mapping(address => uint256) balances;
68         mapping(address => mapping(address => uint256)) allowed;
69         mapping(address => bool) seller;
70 
71         address config;
72         address owner;
73         address dao;
74         address public badgeLedger;
75         bool locked;
76 
77         /// @return total amount of tokens
78         uint256 public totalSupply;
79 
80         /// @param _owner The address from which the balance will be retrieved
81         /// @return The balance
82         function balanceOf(address _owner) constant returns(uint256 balance);
83 
84         /// @notice send `_value` tokens to `_to` from `msg.sender`
85         /// @param _to The address of the recipient
86         /// @param _value The amount of tokens to be transfered
87         /// @return Whether the transfer was successful or not
88         function transfer(address _to, uint256 _value) returns(bool success);
89 
90         /// @notice send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`
91         /// @param _from The address of the sender
92         /// @param _to The address of the recipient
93         /// @param _value The amount of tokens to be transfered
94         /// @return Whether the transfer was successful or not
95         function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
96 
97         /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on its behalf
98         /// @param _spender The address of the account able to transfer the tokens
99         /// @param _value The amount of tokens to be approved for transfer
100         /// @return Whether the approval was successful or not
101         function approve(address _spender, uint256 _value) returns(bool success);
102 
103         /// @param _owner The address of the account owning tokens
104         /// @param _spender The address of the account able to transfer the tokens
105         /// @return Amount of remaining tokens of _owner that _spender is allowed to spend
106         function allowance(address _owner, address _spender) constant returns(uint256 remaining);
107 
108         /// @notice mint `_amount` of tokens to `_owner`
109         /// @param _owner The address of the account receiving the tokens
110         /// @param _amount The amount of tokens to mint
111         /// @return Whether or not minting was successful
112         function mint(address _owner, uint256 _amount) returns(bool success);
113 
114         /// @notice mintBadge Mint `_amount` badges to `_owner`
115         /// @param _owner The address of the account receiving the tokens
116         /// @param _amount The amount of tokens to mint
117         /// @return Whether or not minting was successful
118         function mintBadge(address _owner, uint256 _amount) returns(bool success);
119 
120         function registerDao(address _dao) returns(bool success);
121 
122         function registerSeller(address _tokensales) returns(bool success);
123 
124         event Transfer(address indexed _from, address indexed _to, uint256 indexed _value);
125         event Mint(address indexed _recipient, uint256 indexed _amount);
126         event Approval(address indexed _owner, address indexed _spender, uint256 indexed _value);
127 }
128 
129 contract TokenSalesInterface {
130 
131         struct SaleProxy {
132                 address payout;
133                 bool isProxy;
134         }
135 
136         struct SaleStatus {
137                 bool founderClaim;
138                 uint256 releasedTokens;
139                 uint256 releasedBadges;
140                 uint256 claimers;
141         }
142 
143         struct Info {
144                 uint256 totalWei;
145                 uint256 totalCents;
146                 uint256 realCents;
147                 uint256 amount;
148         }
149 
150         struct SaleConfig {
151                 uint256 startDate;
152                 uint256 periodTwo;
153                 uint256 periodThree;
154                 uint256 endDate;
155                 uint256 goal;
156                 uint256 cap;
157                 uint256 badgeCost;
158                 uint256 founderAmount;
159                 address founderWallet;
160         }
161 
162         struct Buyer {
163                 uint256 centsTotal;
164                 uint256 weiTotal;
165                 bool claimed;
166         }
167 
168         Info saleInfo;
169         SaleConfig saleConfig;
170         SaleStatus saleStatus;
171 
172         address config;
173         address owner;
174         bool locked;
175 
176         uint256 public ethToCents;
177 
178         mapping(address => Buyer) buyers;
179         mapping(address => SaleProxy) proxies;
180 
181         /// @notice Calculates the parts per billion 1⁄1,000,000,000 of `_a` to `_b`
182         /// @param _a The antecedent
183         /// @param _c The consequent
184         /// @return Part per billion value
185         function ppb(uint256 _a, uint256 _c) public constant returns(uint256 b);
186 
187 
188         /// @notice Calculates the share from `_total` based on `_contrib`
189         /// @param _contrib The contributed amount in USD
190         /// @param _total The total amount raised in USD
191         /// @return Total number of shares
192         function calcShare(uint256 _contrib, uint256 _total) public constant returns(uint256 share);
193 
194         /// @notice Calculates the current USD cents value of `_wei`
195         /// @param _wei the amount of wei
196         /// @return The USD cents value
197         function weiToCents(uint256 _wei) public constant returns(uint256 centsvalue);
198 
199         function proxyPurchase(address _user) returns(bool success);
200 
201         /// @notice Send msg.value purchase for _user.
202         /// @param _user The account to be credited
203         /// @return Success if purchase was accepted
204         function purchase(address _user, uint256 _amount) private returns(bool success);
205 
206         /// @notice Get crowdsale information for `_user`
207         /// @param _user The account to be queried
208         /// @return `centstotal` the total amount of USD cents contributed
209         /// @return `weitotal` the total amount in wei contributed
210         /// @return `share` the current token shares earned
211         /// @return `badges` the number of proposer badges earned
212         /// @return `claimed` is true if the tokens and badges have been claimed
213         function userInfo(address _user) public constant returns(uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed);
214 
215         /// @notice Get the crowdsale information from msg.sender (see userInfo)
216         function myInfo() public constant returns(uint256 centstotal, uint256 weitotal, uint256 share, uint badges, bool claimed);
217 
218         /// @notice get the total amount of wei raised for the crowdsale
219         /// @return The amount of wei raised
220         function totalWei() public constant returns(uint);
221 
222         /// @notice get the total USD value in cents raised for the crowdsale
223         /// @return the amount USD cents
224         function totalCents() public constant returns(uint);
225 
226         /// @notice get the current crowdsale information
227         /// @return `startsale` The unix timestamp for the start of the crowdsale and the first period modifier
228         /// @return `two` The unix timestamp for the start of the second period modifier
229         /// @return `three` The unix timestamp for the start of the third period modifier
230         /// @return `endsale` The unix timestamp of the end of crowdsale
231         /// @return `totalwei` The total amount of wei raised
232         /// @return `totalcents` The total number of USD cents raised
233         /// @return `amount` The amount of DGD tokens available for the crowdsale
234         /// @return `goal` The USD value goal for the crowdsale
235         /// @return `famount` Founders endowment
236         /// @return `faddress` Founder wallet address
237         /*function getSaleInfo() public constant returns (uint256 startsale, uint256 two, uint256 three, uint256 endsale, uint256 totalwei, uint256 totalcents, uint256 amount, uint256 goal, uint256 famount, address faddress);*/
238 
239         function claimFor(address _user) returns(bool success);
240 
241         /// @notice Allows msg.sender to claim the DGD tokens and badges if the goal is reached or refunds the ETH contributed if goal is not reached at the end of the crowdsale
242         function claim() returns(bool success);
243 
244         function claimFounders() returns(bool success);
245 
246         /// @notice See if the crowdsale goal has been reached
247         function goalReached() public constant returns(bool reached);
248 
249         /// @notice Get the current sale period
250         /// @return `saleperiod` 0 = Outside of the crowdsale period, 1 = First reward period, 2 = Second reward period, 3 = Final crowdsale period.
251         function getPeriod() public constant returns(uint saleperiod);
252 
253         /// @notice Get the date for the start of the crowdsale
254         /// @return `date` The unix timestamp for the start
255         function startDate() public constant returns(uint date);
256 
257         /// @notice Get the date for the second reward period of the crowdsale
258         /// @return `date` The unix timestamp for the second period
259         function periodTwo() public constant returns(uint date);
260 
261         /// @notice Get the date for the final period of the crowdsale
262         /// @return `date` The unix timestamp for the final period
263         function periodThree() public constant returns(uint date);
264 
265         /// @notice Get the date for the end of the crowdsale
266         /// @return `date` The unix timestamp for the end of the crowdsale
267         function endDate() public constant returns(uint date);
268 
269         /// @notice Check if crowdsale has ended
270         /// @return `ended` If the crowdsale has ended
271 
272         function isEnded() public constant returns(bool ended);
273 
274         /// @notice Send raised funds from the crowdsale to the DAO
275         /// @return `success` if the send succeeded
276         function sendFunds() public returns(bool success);
277 
278         //function regProxy(address _payment, address _payout) returns (bool success);
279         function regProxy(address _payout) returns(bool success);
280 
281         function getProxy(address _payout) public returns(address proxy);
282 
283         function getPayout(address _proxy) public returns(address payout, bool isproxy);
284 
285         function unlock() public returns(bool success);
286 
287         function getSaleStatus() public constant returns(bool fclaim, uint256 reltokens, uint256 relbadges, uint256 claimers);
288 
289         function getSaleInfo() public constant returns(uint256 weiamount, uint256 cents, uint256 realcents, uint256 amount);
290 
291         function getSaleConfig() public constant returns(uint256 start, uint256 two, uint256 three, uint256 end, uint256 goal, uint256 cap, uint256 badgecost, uint256 famount, address fwallet);
292 
293         event Purchase(uint256 indexed _exchange, uint256 indexed _rate, uint256 indexed _cents);
294         event Claim(address indexed _user, uint256 indexed _amount, uint256 indexed _badges);
295 
296 }
297 
298 contract Badge {
299         mapping(address => uint256) balances;
300         mapping(address => mapping(address => uint256)) allowed;
301 
302         address public owner;
303         bool public locked;
304         string public name;                   //fancy name: eg Simon Bucks
305         uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
306         string public symbol;                 //An identifier: eg SBX
307         string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
308 
309         /// @return total amount of tokens
310         uint256 public totalSupply;
311 
312         modifier ifOwner() {
313                 if (msg.sender != owner) {
314                         throw;
315                 } else {
316                         _;
317                 }
318         }
319 
320 
321         event Transfer(address indexed _from, address indexed _to, uint256 _value);
322         event Mint(address indexed _recipient, uint256 indexed _amount);
323         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
324 
325         function Badge(
326                 uint256 _initialAmount,
327                 string _tokenName,
328                 uint8 _decimalUnits,
329                 string _tokenSymbol
330         ) {
331                 owner = msg.sender;
332                 balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
333                 totalSupply = _initialAmount;                        // Update total supply
334                 name = _tokenName;                                   // Set the name for display purposes
335                 decimals = _decimalUnits;                            // Amount of decimals for display purposes
336                 symbol = _tokenSymbol;                               // Set the symbol for display purposes
337 
338         }
339 
340         function safeToAdd(uint a, uint b) returns(bool) {
341                 return (a + b >= a);
342         }
343 
344         function addSafely(uint a, uint b) returns(uint result) {
345                 if (!safeToAdd(a, b)) {
346                         throw;
347                 } else {
348                         result = a + b;
349                         return result;
350                 }
351         }
352 
353         function safeToSubtract(uint a, uint b) returns(bool) {
354                 return (b <= a);
355         }
356 
357         function subtractSafely(uint a, uint b) returns(uint) {
358                 if (!safeToSubtract(a, b)) throw;
359                 return a - b;
360         }
361 
362         function balanceOf(address _owner) constant returns(uint256 balance) {
363                 return balances[_owner];
364         }
365 
366         function transfer(address _to, uint256 _value) returns(bool success) {
367                 if (balances[msg.sender] >= _value && _value > 0) {
368                         balances[msg.sender] = subtractSafely(balances[msg.sender], _value);
369                         balances[_to] = addSafely(_value, balances[_to]);
370                         Transfer(msg.sender, _to, _value);
371                         success = true;
372                 } else {
373                         success = false;
374                 }
375                 return success;
376         }
377 
378         function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
379                 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
380                         balances[_to] = addSafely(balances[_to], _value);
381                         balances[_from] = subtractSafely(balances[_from], _value);
382                         allowed[_from][msg.sender] = subtractSafely(allowed[_from][msg.sender], _value);
383                         Transfer(_from, _to, _value);
384                         return true;
385                 } else {
386                         return false;
387                 }
388         }
389 
390         function approve(address _spender, uint256 _value) returns(bool success) {
391                 allowed[msg.sender][_spender] = _value;
392                 Approval(msg.sender, _spender, _value);
393                 success = true;
394                 return success;
395         }
396 
397         function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
398                 remaining = allowed[_owner][_spender];
399                 return remaining;
400         }
401 
402         function mint(address _owner, uint256 _amount) ifOwner returns(bool success) {
403                 totalSupply = addSafely(totalSupply, _amount);
404                 balances[_owner] = addSafely(balances[_owner], _amount);
405                 Mint(_owner, _amount);
406                 return true;
407         }
408 
409         function setOwner(address _owner) ifOwner returns(bool success) {
410                 owner = _owner;
411                 return true;
412         }
413 
414 }
415 
416 contract Token {
417 
418         address public owner;
419         address public config;
420         bool public locked;
421         address public dao;
422         address public badgeLedger;
423         uint256 public totalSupply;
424 
425         mapping(address => uint256) balances;
426         mapping(address => mapping(address => uint256)) allowed;
427         mapping(address => bool) seller;
428 
429         /// @return total amount of tokens
430 
431         modifier ifSales() {
432                 if (!seller[msg.sender]) throw;
433                 _;
434         }
435 
436         modifier ifOwner() {
437                 if (msg.sender != owner) throw;
438                 _;
439         }
440 
441         modifier ifDao() {
442                 if (msg.sender != dao) throw;
443                 _;
444         }
445 
446         event Transfer(address indexed _from, address indexed _to, uint256 _value);
447         event Mint(address indexed _recipient, uint256 _amount);
448         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
449 
450         function Token(address _config) {
451                 config = _config;
452                 owner = msg.sender;
453                 address _initseller = ConfigInterface(_config).getConfigAddress("sale1:address");
454                 seller[_initseller] = true;
455                 locked = false;
456         }
457 
458         function safeToAdd(uint a, uint b) returns(bool) {
459                 return (a + b >= a);
460         }
461 
462         function addSafely(uint a, uint b) returns(uint result) {
463                 if (!safeToAdd(a, b)) {
464                         throw;
465                 } else {
466                         result = a + b;
467                         return result;
468                 }
469         }
470 
471         function safeToSubtract(uint a, uint b) returns(bool) {
472                 return (b <= a);
473         }
474 
475         function subtractSafely(uint a, uint b) returns(uint) {
476                 if (!safeToSubtract(a, b)) throw;
477                 return a - b;
478         }
479 
480         function balanceOf(address _owner) constant returns(uint256 balance) {
481                 return balances[_owner];
482         }
483 
484         function transfer(address _to, uint256 _value) returns(bool success) {
485                 if (balances[msg.sender] >= _value && _value > 0) {
486                         balances[msg.sender] = subtractSafely(balances[msg.sender], _value);
487                         balances[_to] = addSafely(balances[_to], _value);
488                         Transfer(msg.sender, _to, _value);
489                         success = true;
490                 } else {
491                         success = false;
492                 }
493                 return success;
494         }
495 
496         function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
497                 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
498                         balances[_to] = addSafely(balances[_to], _value);
499                         balances[_from] = subtractSafely(balances[_from], _value);
500                         allowed[_from][msg.sender] = subtractSafely(allowed[_from][msg.sender], _value);
501                         Transfer(_from, _to, _value);
502                         return true;
503                 } else {
504                         return false;
505                 }
506         }
507 
508         function approve(address _spender, uint256 _value) returns(bool success) {
509                 allowed[msg.sender][_spender] = _value;
510                 Approval(msg.sender, _spender, _value);
511                 success = true;
512                 return success;
513         }
514 
515         function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
516                 remaining = allowed[_owner][_spender];
517                 return remaining;
518         }
519 
520         function mint(address _owner, uint256 _amount) ifSales returns(bool success) {
521                 totalSupply = addSafely(_amount, totalSupply);
522                 balances[_owner] = addSafely(balances[_owner], _amount);
523                 return true;
524         }
525 
526         function mintBadge(address _owner, uint256 _amount) ifSales returns(bool success) {
527                 if (!Badge(badgeLedger).mint(_owner, _amount)) return false;
528                 return true;
529         }
530 
531         function registerDao(address _dao) ifOwner returns(bool success) {
532                 if (locked == true) return false;
533                 dao = _dao;
534                 locked = true;
535                 return true;
536         }
537 
538         function setDao(address _newdao) ifDao returns(bool success) {
539                 dao = _newdao;
540                 return true;
541         }
542 
543         function isSeller(address _query) returns(bool isseller) {
544                 return seller[_query];
545         }
546 
547         function registerSeller(address _tokensales) ifDao returns(bool success) {
548                 seller[_tokensales] = true;
549                 return true;
550         }
551 
552         function unregisterSeller(address _tokensales) ifDao returns(bool success) {
553                 seller[_tokensales] = false;
554                 return true;
555         }
556 
557         function setOwner(address _newowner) ifDao returns(bool success) {
558                 if (Badge(badgeLedger).setOwner(_newowner)) {
559                         owner = _newowner;
560                         success = true;
561                 } else {
562                         success = false;
563                 }
564                 return success;
565         }
566 
567 }