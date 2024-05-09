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
241 contract CommonBsToken is StandardToken, MultiOwnable {
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
264     function CommonBsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {
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
346 contract CommonBsPresale is SafeMath, Ownable, Pausable {
347 
348     enum Currency { BTC, LTC, ZEC, DASH, WAVES, USD, EUR }
349 
350     // TODO rename to Buyer?
351 
352     struct Backer {
353         uint256 weiReceived; // Amount of wei given by backer
354         uint256 tokensSent;  // Amount of tokens received in return to the given amount of ETH.
355     }
356 
357     // TODO rename to buyers?
358 
359     // (buyer_eth_address -> struct)
360     mapping(address => Backer) public backers;
361 
362     // currency_code => (tx_hash => tokens)
363     mapping(uint8 => mapping(bytes32 => uint256)) public externalTxs;
364 
365     CommonBsToken public token; // Token contract reference.
366     address public beneficiary; // Address that will receive ETH raised during this crowdsale.
367     address public notifier;    // Address that can this crowdsale about changed external conditions.
368 
369     uint256 public minTokensToBuy = 50 * 1e18; // Including bonuses.
370     uint256 public maxCapWei      = 50000 ether;
371 
372     uint public tokensPerWei         = 1000; // Ordinary price: 1 ETH = 1000 tokens.
373     uint public tokensPerWeiBonus333 = 1333;
374     uint public tokensPerWeiBonus250 = 1250;
375     uint public tokensPerWeiBonus111 = 1111;
376 
377     uint public startTime       = 1510160700; // 2017-11-08T17:05:00Z
378     uint public bonusEndTime333 = 1510333500; // 2017-11-10T17:05:00Z
379     uint public bonusEndTime250 = 1510679100; // 2017-11-14T17:05:00Z
380     uint public endTime         = 1511024700; // 2017-11-18T17:05:00Z
381 
382     // Stats for current crowdsale
383 
384     uint256 public totalInWei         = 0; // Grand total in wei
385     uint256 public totalTokensSold    = 0; // Total amount of tokens sold during this crowdsale.
386     uint256 public totalEthSales      = 0; // Total amount of ETH contributions during this crowdsale.
387     uint256 public totalExternalSales = 0; // Total amount of external contributions (BTC, LTC, USD, etc.) during this crowdsale.
388     uint256 public weiReceived        = 0; // Total amount of wei received during this crowdsale smart contract.
389 
390     uint public finalizedTime = 0; // Unix timestamp when finalize() was called.
391 
392     bool public saleEnabled = true;   // if false, then contract will not sell tokens on payment received
393 
394     event BeneficiaryChanged(address indexed _oldAddress, address indexed _newAddress);
395     event NotifierChanged(address indexed _oldAddress, address indexed _newAddress);
396 
397     event EthReceived(address indexed _buyer, uint256 _amountWei);
398     event ExternalSale(Currency _currency, bytes32 _txIdSha3, address indexed _buyer, uint256 _amountWei, uint256 _tokensE18);
399 
400     modifier respectTimeFrame() {
401         require(isSaleOn());
402         _;
403     }
404 
405     modifier canNotify() {
406         require(msg.sender == owner || msg.sender == notifier);
407         _;
408     }
409 
410     function CommonBsPresale(address _token, address _beneficiary) {
411         token = CommonBsToken(_token);
412         owner = msg.sender;
413         notifier = owner;
414         beneficiary = _beneficiary;
415     }
416 
417     // Override this method to mock current time.
418     function getNow() public constant returns (uint) {
419         return now;
420     }
421 
422     function setSaleEnabled(bool _enabled) public onlyOwner {
423         saleEnabled = _enabled;
424     }
425 
426     function setBeneficiary(address _beneficiary) public onlyOwner {
427         BeneficiaryChanged(beneficiary, _beneficiary);
428         beneficiary = _beneficiary;
429     }
430 
431     function setNotifier(address _notifier) public onlyOwner {
432         NotifierChanged(notifier, _notifier);
433         notifier = _notifier;
434     }
435 
436     /*
437      * The fallback function corresponds to a donation in ETH
438      */
439     function() public payable {
440         if (saleEnabled) sellTokensForEth(msg.sender, msg.value);
441     }
442 
443     function sellTokensForEth(address _buyer, uint256 _amountWei) internal ifNotPaused respectTimeFrame {
444 
445         totalInWei = safeAdd(totalInWei, _amountWei);
446         weiReceived = safeAdd(weiReceived, _amountWei);
447         require(totalInWei <= maxCapWei); // If max cap reached.
448 
449         uint256 tokensE18 = weiToTokens(_amountWei);
450         require(tokensE18 >= minTokensToBuy);
451 
452         require(token.sell(_buyer, tokensE18)); // Transfer tokens to buyer.
453         totalTokensSold = safeAdd(totalTokensSold, tokensE18);
454         totalEthSales++;
455 
456         Backer backer = backers[_buyer];
457         backer.tokensSent = safeAdd(backer.tokensSent, tokensE18);
458         backer.weiReceived = safeAdd(backer.weiReceived, _amountWei);  // Update the total wei collected during the crowdfunding for this backer
459 
460         EthReceived(_buyer, _amountWei);
461     }
462 
463     // Calc how much tokens you can buy at current time.
464     function weiToTokens(uint256 _amountWei) public constant returns (uint256) {
465         return weiToTokensAtTime(_amountWei, getNow());
466     }
467 
468     function weiToTokensAtTime(uint256 _amountWei, uint _time) public constant returns (uint256) {
469         uint256 rate = tokensPerWei;
470 
471         if (startTime <= _time && _time < bonusEndTime333) rate = tokensPerWeiBonus333;
472         else if (bonusEndTime333 <= _time && _time < bonusEndTime250) rate = tokensPerWeiBonus250;
473         else if (bonusEndTime250 <= _time && _time < endTime) rate = tokensPerWeiBonus111;
474 
475         return safeMul(_amountWei, rate);
476     }
477 
478     //----------------------------------------------------------------------
479     // Begin of external sales.
480 
481     function externalSales(
482         uint8[] _currencies,
483         bytes32[] _txIdSha3,
484         address[] _buyers,
485         uint256[] _amountsWei,
486         uint256[] _tokensE18
487     ) public ifNotPaused canNotify {
488 
489         require(_currencies.length > 0);
490         require(_currencies.length == _txIdSha3.length);
491         require(_currencies.length == _buyers.length);
492         require(_currencies.length == _amountsWei.length);
493         require(_currencies.length == _tokensE18.length);
494 
495         for (uint i = 0; i < _txIdSha3.length; i++) {
496             _externalSaleSha3(
497                 Currency(_currencies[i]),
498                 _txIdSha3[i],
499                 _buyers[i],
500                 _amountsWei[i],
501                 _tokensE18[i]
502             );
503         }
504     }
505 
506     function _externalSaleSha3(
507         Currency _currency,
508         bytes32 _txIdSha3, // To get bytes32 use keccak256(txId) OR sha3(txId)
509         address _buyer,
510         uint256 _amountWei,
511         uint256 _tokensE18
512     ) internal {
513 
514         require(_buyer > 0 && _amountWei > 0 && _tokensE18 > 0);
515 
516         var txsByCur = externalTxs[uint8(_currency)];
517 
518         // If this foreign transaction has been already processed in this contract.
519         require(txsByCur[_txIdSha3] == 0);
520 
521         totalInWei = safeAdd(totalInWei, _amountWei);
522         require(totalInWei <= maxCapWei); // Max cap should not be reached yet.
523 
524         require(token.sell(_buyer, _tokensE18)); // Transfer tokens to buyer.
525         totalTokensSold = safeAdd(totalTokensSold, _tokensE18);
526         totalExternalSales++;
527 
528         txsByCur[_txIdSha3] = _tokensE18;
529         ExternalSale(_currency, _txIdSha3, _buyer, _amountWei, _tokensE18);
530     }
531 
532     // Get id of currency enum. --------------------------------------------
533 
534     function btcId() public constant returns (uint8) {
535         return uint8(Currency.BTC);
536     }
537 
538     function ltcId() public constant returns (uint8) {
539         return uint8(Currency.LTC);
540     }
541 
542     function zecId() public constant returns (uint8) {
543         return uint8(Currency.ZEC);
544     }
545 
546     function dashId() public constant returns (uint8) {
547         return uint8(Currency.DASH);
548     }
549 
550     function wavesId() public constant returns (uint8) {
551         return uint8(Currency.WAVES);
552     }
553 
554     function usdId() public constant returns (uint8) {
555         return uint8(Currency.USD);
556     }
557 
558     function eurId() public constant returns (uint8) {
559         return uint8(Currency.EUR);
560     }
561 
562     // Get token count by transaction id. ----------------------------------
563 
564     function _tokensByTx(Currency _currency, string _txId) internal constant returns (uint256) {
565         return tokensByTx(uint8(_currency), _txId);
566     }
567 
568     function tokensByTx(uint8 _currency, string _txId) public constant returns (uint256) {
569         return externalTxs[_currency][keccak256(_txId)];
570     }
571 
572     function tokensByBtcTx(string _txId) public constant returns (uint256) {
573         return _tokensByTx(Currency.BTC, _txId);
574     }
575 
576     function tokensByLtcTx(string _txId) public constant returns (uint256) {
577         return _tokensByTx(Currency.LTC, _txId);
578     }
579 
580     function tokensByZecTx(string _txId) public constant returns (uint256) {
581         return _tokensByTx(Currency.ZEC, _txId);
582     }
583 
584     function tokensByDashTx(string _txId) public constant returns (uint256) {
585         return _tokensByTx(Currency.DASH, _txId);
586     }
587 
588     function tokensByWavesTx(string _txId) public constant returns (uint256) {
589         return _tokensByTx(Currency.WAVES, _txId);
590     }
591 
592     function tokensByUsdTx(string _txId) public constant returns (uint256) {
593         return _tokensByTx(Currency.USD, _txId);
594     }
595 
596     function tokensByEurTx(string _txId) public constant returns (uint256) {
597         return _tokensByTx(Currency.EUR, _txId);
598     }
599 
600     // End of external sales.
601     //----------------------------------------------------------------------
602 
603     function totalSales() public constant returns (uint256) {
604         return safeAdd(totalEthSales, totalExternalSales);
605     }
606 
607     function isMaxCapReached() public constant returns (bool) {
608         return totalInWei >= maxCapWei;
609     }
610 
611     function isSaleOn() public constant returns (bool) {
612         uint _now = getNow();
613         return startTime <= _now && _now <= endTime;
614     }
615 
616     function isSaleOver() public constant returns (bool) {
617         return getNow() > endTime;
618     }
619 
620     function isFinalized() public constant returns (bool) {
621         return finalizedTime > 0;
622     }
623 
624     /*
625      * Finalize the crowdsale. Raised money can be sent to beneficiary only if crowdsale hit end time or max cap (15m USD).
626      */
627     function finalize() public onlyOwner {
628 
629         // Cannot finalise before end day of crowdsale until max cap is reached.
630         require(isMaxCapReached() || isSaleOver());
631 
632         beneficiary.transfer(this.balance);
633 
634         finalizedTime = getNow();
635     }
636 }
637 
638 contract JobeumPresale is CommonBsPresale {
639 
640     function JobeumPresale() CommonBsPresale(
641         0x08d069ae12b1fe5f651ab56adae0f6c99cb7a15f, // address _token
642         0x76CA9140540988d36f7be7A8b1172E09E6d8A26c  // address _beneficiary
643     ) {}
644 }