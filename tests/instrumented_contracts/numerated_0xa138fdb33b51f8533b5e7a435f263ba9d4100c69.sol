1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4 
5     function safeMul(uint256 a, uint256 b) internal constant returns (uint256 ) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint256 a, uint256 b) internal constant returns (uint256 ) {
12         assert(b > 0);
13         uint256 c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint256 a, uint256 b) internal constant returns (uint256 ) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256 ) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ERC20 {
31 
32     /* This is a slight change to the ERC20 base standard.
33     function totalSupply() constant returns (uint256 supply);
34     is replaced with:
35     uint256 public totalSupply;
36     This automatically creates a getter function for the totalSupply.
37     This is moved to the base contract since public getter functions are not
38     currently recognised as an implementation of the matching abstract
39     function by the compiler.
40     */
41     /// total amount of tokens
42     uint256 public totalSupply;
43 
44     /// @param _owner The address from which the balance will be retrieved
45     /// @return The balance
46     function balanceOf(address _owner) constant returns (uint256 balance);
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool success);
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of tokens to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) returns (bool success);
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 contract StandardToken is ERC20, SafeMath {
77 
78     mapping(address => uint256) balances;
79     mapping(address => mapping(address => uint256)) allowed;
80 
81     /// @dev Returns number of tokens owned by given address.
82     /// @param _owner Address of token owner.
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     /// @dev Transfers sender's tokens to a given address. Returns success.
88     /// @param _to Address of token receiver.
89     /// @param _value Number of tokens to transfer.
90     function transfer(address _to, uint256 _value) returns (bool) {
91         if (balances[msg.sender] >= _value && _value > 0) {
92             balances[msg.sender] = safeSub(balances[msg.sender], _value);
93             balances[_to] = safeAdd(balances[_to], _value);
94             Transfer(msg.sender, _to, _value);
95             return true;
96         } else return false;
97     }
98 
99     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
100     /// @param _from Address from where tokens are withdrawn.
101     /// @param _to Address to where tokens are sent.
102     /// @param _value Number of tokens to transfer.
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
104         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105             balances[_to] = safeAdd(balances[_to], _value);
106             balances[_from] = safeSub(balances[_from], _value);
107             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
108             Transfer(_from, _to, _value);
109             return true;
110         } else return false;
111     }
112 
113     /// @dev Sets approved amount of tokens for spender. Returns success.
114     /// @param _spender Address of allowed account.
115     /// @param _value Number of approved tokens.
116     function approve(address _spender, uint256 _value) returns (bool) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /// @dev Returns number of allowed tokens for given address.
123     /// @param _owner Address of token owner.
124     /// @param _spender Address of token spender.
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126         return allowed[_owner][_spender];
127     }
128 }
129 
130 contract Ownable {
131 
132     address public owner;
133     address public pendingOwner;
134 
135     function Ownable() {
136         owner = msg.sender;
137     }
138 
139     modifier onlyOwner() {
140         require(msg.sender == owner);
141         _;
142     }
143 
144     // Safe transfer of ownership in 2 steps. Once called, a newOwner needs to call claimOwnership() to prove ownership.
145     function transferOwnership(address newOwner) onlyOwner {
146         pendingOwner = newOwner;
147     }
148 
149     function claimOwnership() {
150         if (msg.sender == pendingOwner) {
151             owner = pendingOwner;
152             pendingOwner = 0;
153         }
154     }
155 }
156 
157 contract MultiOwnable {
158 
159     mapping (address => bool) ownerMap;
160     address[] public owners;
161 
162     event OwnerAdded(address indexed _newOwner);
163     event OwnerRemoved(address indexed _oldOwner);
164 
165     modifier onlyOwner() {
166         require(isOwner(msg.sender));
167         _;
168     }
169 
170     function MultiOwnable() {
171         // Add default owner
172         address owner = msg.sender;
173         ownerMap[owner] = true;
174         owners.push(owner);
175     }
176 
177     function ownerCount() public constant returns (uint256) {
178         return owners.length;
179     }
180 
181     function isOwner(address owner) public constant returns (bool) {
182         return ownerMap[owner];
183     }
184 
185     function addOwner(address owner) onlyOwner returns (bool) {
186         if (!isOwner(owner) && owner != 0) {
187             ownerMap[owner] = true;
188             owners.push(owner);
189 
190             OwnerAdded(owner);
191             return true;
192         } else return false;
193     }
194 
195     function removeOwner(address owner) onlyOwner returns (bool) {
196         if (isOwner(owner)) {
197             ownerMap[owner] = false;
198             for (uint i = 0; i < owners.length - 1; i++) {
199                 if (owners[i] == owner) {
200                     owners[i] = owners[owners.length - 1];
201                     break;
202                 }
203             }
204             owners.length -= 1;
205 
206             OwnerRemoved(owner);
207             return true;
208         } else return false;
209     }
210 }
211 
212 contract Pausable is Ownable {
213 
214     bool public paused;
215 
216     modifier ifNotPaused {
217         require(!paused);
218         _;
219     }
220 
221     modifier ifPaused {
222         require(paused);
223         _;
224     }
225 
226     // Called by the owner on emergency, triggers paused state
227     function pause() external onlyOwner {
228         paused = true;
229     }
230 
231     // Called by the owner on end of emergency, returns to normal state
232     function resume() external onlyOwner ifPaused {
233         paused = false;
234     }
235 }
236 
237 contract TokenSpender {
238     function receiveApproval(address _from, uint256 _value);
239 }
240 
241 contract BsToken is StandardToken, MultiOwnable {
242 
243     bool public locked;
244 
245     string public name;
246     string public symbol;
247     uint256 public totalSupply;
248     uint8 public decimals = 18;
249     string public version = 'v0.1';
250 
251     address public creator;
252     address public seller;
253     uint256 public tokensSold;
254     uint256 public totalSales;
255 
256     event Sell(address indexed _seller, address indexed _buyer, uint256 _value);
257     event SellerChanged(address indexed _oldSeller, address indexed _newSeller);
258 
259     modifier onlyUnlocked() {
260         if (!isOwner(msg.sender) && locked) throw;
261         _;
262     }
263 
264     function BsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {
265 
266         // Lock the transfer function during the presale/crowdsale to prevent speculations.
267         locked = true;
268 
269         creator = msg.sender;
270         seller = _seller;
271 
272         name = _name;
273         symbol = _symbol;
274         totalSupply = _totalSupplyNoDecimals * 1e18;
275 
276         balances[seller] = totalSupply;
277         Transfer(0x0, seller, totalSupply);
278     }
279 
280     function changeSeller(address newSeller) onlyOwner returns (bool) {
281         require(newSeller != 0x0 && seller != newSeller);
282 
283         address oldSeller = seller;
284 
285         uint256 unsoldTokens = balances[oldSeller];
286         balances[oldSeller] = 0;
287         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
288         Transfer(oldSeller, newSeller, unsoldTokens);
289 
290         seller = newSeller;
291         SellerChanged(oldSeller, newSeller);
292         return true;
293     }
294 
295     function sellNoDecimals(address _to, uint256 _value) returns (bool) {
296         return sell(_to, _value * 1e18);
297     }
298 
299     function sell(address _to, uint256 _value) onlyOwner returns (bool) {
300         if (balances[seller] >= _value && _value > 0) {
301             balances[seller] = safeSub(balances[seller], _value);
302             balances[_to] = safeAdd(balances[_to], _value);
303             Transfer(seller, _to, _value);
304 
305             tokensSold = safeAdd(tokensSold, _value);
306             totalSales = safeAdd(totalSales, 1);
307             Sell(seller, _to, _value);
308             return true;
309         } else return false;
310     }
311 
312     function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
313         return super.transfer(_to, _value);
314     }
315 
316     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
317         return super.transferFrom(_from, _to, _value);
318     }
319 
320     function lock() onlyOwner {
321         locked = true;
322     }
323 
324     function unlock() onlyOwner {
325         locked = false;
326     }
327 
328     function burn(uint256 _value) returns (bool) {
329         if (balances[msg.sender] >= _value && _value > 0) {
330             balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
331             totalSupply = safeSub(totalSupply, _value);
332             Transfer(msg.sender, 0x0, _value);
333             return true;
334         } else return false;
335     }
336 
337     /* Approve and then communicate the approved contract in a single tx */
338     function approveAndCall(address _spender, uint256 _value) {
339         TokenSpender spender = TokenSpender(_spender);
340         if (approve(_spender, _value)) {
341             spender.receiveApproval(msg.sender, _value);
342         }
343     }
344 }
345 
346 /**
347  * In this crowdsale We assume that ETH rate is 320 USD/ETH
348  */
349 contract BsCrowdsale is SafeMath, Ownable, Pausable {
350 
351     enum Currency { BTC, LTC, DASH, ZEC, WAVES, USD, EUR }
352 
353     struct Backer {
354         uint256 weiReceived; // Amount of wei given by backer
355         uint256 tokensSent;  // Amount of tokens received in return to the given amount of ETH.
356     }
357 
358     // TODO rename to buyers?
359     // (buyer_eth_address -> struct)
360     mapping(address => Backer) public backers;
361 
362     // currency_code => (tx_hash => tokens)
363     mapping(uint => mapping(bytes32 => uint256)) public externalTxs;
364 
365     BsToken public token;           // Token contract reference.
366     address public beneficiary;     // Address that will receive ETH raised during this crowdsale.
367     address public notifier;        // Address that can this crowdsale about changed external conditions.
368 
369     uint256 public usdPerEth;
370     uint256 public usdPerEthMin = 200; // Lowest boundary of USD/ETH rate
371     uint256 public usdPerEthMax = 500; // Highest boundary of USD/ETH rate
372 
373     struct UsdPerEthLog {
374         uint256 rate;
375         uint256 time;
376         address changedBy;
377     }
378 
379     UsdPerEthLog[] public usdPerEthLog; // History of used rates of USD/ETH
380 
381     uint256 public minInvestCents = 1;              // Because 1 token = 1 cent.
382     uint256 public maxCapInCents  = 10 * 1e6 * 100; // 10m USD in cents.
383 
384     uint256 public tokensPerCents = 1 * 1e18;       // Ordinary price is 1 token = 1 USD cent.
385     uint256 public tokensPerCentsDayOne = 1.1 * 1e18;
386     uint256 public tokensPerCentsWeekOne = 1.05 * 1e18;
387 
388     // TODO set to last value from SnovWhitelist contract.
389     uint256 public totalInCents = 71481400; // Total amount of USD raised during this crowdsale including (wei -> USD) + (external txs in USD).
390 
391     // Stats for current crowdsale
392     uint256 public totalWeiReceived = 0;   // Total amount of wei received during this crowdsale smart contract.
393     uint256 public totalTokensSold = 0;    // Total amount of tokens sold during this crowdsale.
394     uint256 public totalEthSales = 0;      // Total amount of ETH contributions during this crowdsale.
395     uint256 public totalExternalSales = 0; // Total amount of external contributions (USD, BTC, etc.) during this crowdsale.
396 
397     uint256 public startTime = 1509451200; // 2017-10-31 12:00:00Z
398     uint256 public endTime   = 1512043200; // 2017-11-30 12:00:00Z
399 
400     // Use in bonuses:
401     uint256 oneDayTime       = 1509537600; // 2017-11-01 12:00:00Z
402     uint256 oneWeekTime      = 1510056000; // 2017-11-07 12:00:00Z
403 
404     uint256 public finalizedTime = 0;      // Unix timestamp when finalize() was called.
405 
406     bool public saleEnabled = true;       // if true, then contract will not sell tokens on payment received
407 
408     event BeneficiaryChanged(address indexed _oldAddress, address indexed _newAddress);
409     event NotifierChanged(address indexed _oldAddress, address indexed _newAddress);
410     event UsdPerEthChanged(uint256 _oldRate, uint256 _newRate);
411 
412     event EthReceived(address indexed _buyer, uint256 _amountInWei);
413     event ExternalSale(Currency _currency, string _txHash, address indexed _buyer, uint256 _amountInCents, uint256 _tokensE18);
414 
415     modifier respectTimeFrame() {
416         require(isSaleOn());
417         _;
418     }
419 
420     modifier canNotify() {
421         require(msg.sender == owner || msg.sender == notifier);
422         _;
423     }
424 
425     function BsCrowdsale(address _token, address _beneficiary, uint256 _usdPerEth) {
426         token = BsToken(_token);
427 
428         owner = msg.sender;
429         notifier = 0x73E5B12017A141d41c1a14FdaB43a54A4f9BD490;
430         beneficiary = _beneficiary;
431 
432         setUsdPerEth(_usdPerEth);
433     }
434 
435     // Override this method to mock current time.
436     function getNow() public constant returns (uint256) {
437         return now;
438     }
439 
440     function setSaleEnabled(bool _enabled) public onlyOwner {
441         saleEnabled = _enabled;
442     }
443 
444     function setBeneficiary(address _beneficiary) public onlyOwner {
445         BeneficiaryChanged(beneficiary, _beneficiary);
446         beneficiary = _beneficiary;
447     }
448 
449     function setNotifier(address _notifier) public onlyOwner {
450         NotifierChanged(notifier, _notifier);
451         notifier = _notifier;
452     }
453 
454     function setUsdPerEth(uint256 _usdPerEth) public canNotify {
455         if (_usdPerEth < usdPerEthMin || _usdPerEth > usdPerEthMax) throw;
456 
457         UsdPerEthChanged(usdPerEth, _usdPerEth);
458         usdPerEth = _usdPerEth;
459         usdPerEthLog.push(UsdPerEthLog({ rate: usdPerEth, time: getNow(), changedBy: msg.sender }));
460     }
461 
462     function usdPerEthLogSize() public constant returns (uint256) {
463         return usdPerEthLog.length;
464     }
465 
466     /*
467      * The fallback function corresponds to a donation in ETH
468      */
469     function() public payable {
470         if (saleEnabled) sellTokensForEth(msg.sender, msg.value);
471     }
472 
473     function sellTokensForEth(address _buyer, uint256 _amountInWei) internal ifNotPaused respectTimeFrame {
474 
475         uint256 amountInCents = weiToCents(_amountInWei);
476         require(amountInCents >= minInvestCents);
477 
478         totalInCents = safeAdd(totalInCents, amountInCents);
479         require(totalInCents <= maxCapInCents); // If max cap reached.
480 
481         uint256 tokensSold = centsToTokens(amountInCents);
482         require(token.sell(_buyer, tokensSold)); // Transfer tokens to buyer.
483 
484         totalWeiReceived = safeAdd(totalWeiReceived, _amountInWei);
485         totalTokensSold = safeAdd(totalTokensSold, tokensSold);
486         totalEthSales++;
487 
488         Backer backer = backers[_buyer];
489         backer.tokensSent = safeAdd(backer.tokensSent, tokensSold);
490         backer.weiReceived = safeAdd(backer.weiReceived, _amountInWei);  // Update the total wei collected during the crowdfunding for this backer
491 
492         EthReceived(_buyer, _amountInWei);
493     }
494 
495     function weiToCents(uint256 _amountInWei) public constant returns (uint256) {
496         return safeDiv(safeMul(_amountInWei, usdPerEth * 100), 1 ether);
497     }
498 
499     function centsToTokens(uint256 _amountInCents) public constant returns (uint256) {
500         uint256 rate = tokensPerCents;
501         uint _now = getNow();
502 
503         if (startTime <= _now && _now < oneDayTime) rate = tokensPerCentsDayOne;
504         else if (oneDayTime <= _now && _now < oneWeekTime) rate = tokensPerCentsWeekOne;
505 
506         return safeMul(_amountInCents, rate);
507     }
508 
509     function externalSale(
510         Currency _currency,
511         string _txHash,
512         address _buyer,
513         uint256 _amountInCents,
514         uint256 _tokensE18
515     ) internal ifNotPaused canNotify {
516 
517         require(_buyer > 0 && _amountInCents > 0 && _tokensE18 > 0);
518 
519         var txsByCur = externalTxs[uint(_currency)];
520         bytes32 txKey = keccak256(_txHash);
521 
522         // If this foreign transaction has been already processed in this contract.
523         require(txsByCur[txKey] == 0);
524 
525         totalInCents = safeAdd(totalInCents, _amountInCents);
526         require(totalInCents < maxCapInCents); // Max cap should not be reached yet.
527 
528         require(token.sell(_buyer, _tokensE18)); // Transfer tokens to buyer.
529 
530         totalTokensSold = safeAdd(totalTokensSold, _tokensE18);
531         totalExternalSales++;
532 
533         txsByCur[txKey] = _tokensE18;
534         ExternalSale(_currency, _txHash, _buyer, _amountInCents, _tokensE18);
535     }
536 
537     function sellTokensForBtc(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
538         externalSale(Currency.BTC, _txHash, _buyer, _amountInCents, _tokensE18);
539     }
540 
541     function sellTokensForLtc(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
542         externalSale(Currency.LTC, _txHash, _buyer, _amountInCents, _tokensE18);
543     }
544 
545     function sellTokensForDash(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
546         externalSale(Currency.DASH, _txHash, _buyer, _amountInCents, _tokensE18);
547     }
548 
549     function sellTokensForZec(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
550         externalSale(Currency.ZEC, _txHash, _buyer, _amountInCents, _tokensE18);
551     }
552 
553     function sellTokensForWaves(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
554         externalSale(Currency.WAVES, _txHash, _buyer, _amountInCents, _tokensE18);
555     }
556 
557     function sellTokensForUsd(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
558         externalSale(Currency.USD, _txHash, _buyer, _amountInCents, _tokensE18);
559     }
560 
561     function sellTokensForEur(string _txHash, address _buyer, uint256 _amountInCents, uint256 _tokensE18) public {
562         externalSale(Currency.EUR, _txHash, _buyer, _amountInCents, _tokensE18);
563     }
564 
565     function tokensByExternalTx(Currency _currency, string _txHash) internal constant returns (uint256) {
566         return externalTxs[uint(_currency)][keccak256(_txHash)];
567     }
568 
569     function tokensByBtcTx(string _txHash) public constant returns (uint256) {
570         return tokensByExternalTx(Currency.BTC, _txHash);
571     }
572 
573     function tokensByLtcTx(string _txHash) public constant returns (uint256) {
574         return tokensByExternalTx(Currency.LTC, _txHash);
575     }
576 
577     function tokensByDashTx(string _txHash) public constant returns (uint256) {
578         return tokensByExternalTx(Currency.DASH, _txHash);
579     }
580 
581     function tokensByZecTx(string _txHash) public constant returns (uint256) {
582         return tokensByExternalTx(Currency.ZEC, _txHash);
583     }
584 
585     function tokensByWavesTx(string _txHash) public constant returns (uint256) {
586         return tokensByExternalTx(Currency.WAVES, _txHash);
587     }
588 
589     function tokensByUsdTx(string _txHash) public constant returns (uint256) {
590         return tokensByExternalTx(Currency.USD, _txHash);
591     }
592 
593     function tokensByEurTx(string _txHash) public constant returns (uint256) {
594         return tokensByExternalTx(Currency.EUR, _txHash);
595     }
596 
597     function totalSales() public constant returns (uint256) {
598         return safeAdd(totalEthSales, totalExternalSales);
599     }
600 
601     function isMaxCapReached() public constant returns (bool) {
602         return totalInCents >= maxCapInCents;
603     }
604 
605     function isSaleOn() public constant returns (bool) {
606         uint256 _now = getNow();
607         return startTime <= _now && _now <= endTime;
608     }
609 
610     function isSaleOver() public constant returns (bool) {
611         return getNow() > endTime;
612     }
613 
614     function isFinalized() public constant returns (bool) {
615         return finalizedTime > 0;
616     }
617 
618     /*
619      * Finalize the crowdsale. Raised money can be sent to beneficiary only if crowdsale hit end time or max cap (15m USD).
620      */
621     function finalize() public onlyOwner {
622 
623         // Cannot finalise before end day of crowdsale until max cap is reached.
624         require(isMaxCapReached() || isSaleOver());
625 
626         beneficiary.transfer(this.balance);
627 
628         finalizedTime = getNow();
629     }
630 }
631 
632 contract SnovCrowdsale is BsCrowdsale {
633 
634     function SnovCrowdsale() BsCrowdsale(
635         0xBDC5bAC39Dbe132B1E030e898aE3830017D7d969,
636         0x983F64a550CD9D733f2829275f94B1A3728Fe888,
637         310
638     ) {}
639 }