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
369     uint256 public minTokensToBuy = 1 * 1e18; // Including bonuses.
370     uint256 public maxCapWei      = 50000 ether;
371 
372     uint public tokensPerWei         = 1000; // Ordinary price: 1 ETH = 1000 tokens.
373     uint public tokensPerWeiBonus333 = 1333;
374     uint public tokensPerWeiBonus250 = 1250;
375     uint public tokensPerWeiBonus111 = 1111;
376 
377     uint public startTime       = 1410160700; // 2017-11-08T17:05:00Z
378     uint public bonusEndTime333 = 1510333500; // 2017-11-10T17:05:00Z
379     uint public bonusEndTime250 = 1510679100; // 2017-11-14T17:05:00Z
380     uint public endTime         = 1511024700; // 2017-11-18T17:05:00Z
381 
382     // Stats for current crowdsale
383 
384     // TODO rename to 'totalInWei'
385     uint256 public totalWei           = 0; // Grand total in wei
386 
387     uint256 public totalTokensSold    = 0; // Total amount of tokens sold during this crowdsale.
388     uint256 public totalEthSales      = 0; // Total amount of ETH contributions during this crowdsale.
389     uint256 public totalExternalSales = 0; // Total amount of external contributions (BTC, LTC, USD, etc.) during this crowdsale.
390     uint256 public weiReceived        = 0; // Total amount of wei received during this crowdsale smart contract.
391 
392     uint public finalizedTime = 0; // Unix timestamp when finalize() was called.
393 
394     bool public saleEnabled = true;   // if false, then contract will not sell tokens on payment received
395 
396     event BeneficiaryChanged(address indexed _oldAddress, address indexed _newAddress);
397     event NotifierChanged(address indexed _oldAddress, address indexed _newAddress);
398 
399     event EthReceived(address indexed _buyer, uint256 _amountWei);
400     event ExternalSaleSha3(Currency _currency, bytes32 _txIdSha3, address indexed _buyer, uint256 _amountWei, uint256 _tokensE18);
401 
402     modifier respectTimeFrame() {
403         require(isSaleOn());
404         _;
405     }
406 
407     modifier canNotify() {
408         require(msg.sender == owner || msg.sender == notifier);
409         _;
410     }
411 
412     function CommonBsPresale(address _token, address _beneficiary) {
413         token = CommonBsToken(_token);
414         owner = msg.sender;
415         notifier = owner;
416         beneficiary = _beneficiary;
417     }
418 
419     // Override this method to mock current time.
420     function getNow() public constant returns (uint) {
421         return now;
422     }
423 
424     function setSaleEnabled(bool _enabled) public onlyOwner {
425         saleEnabled = _enabled;
426     }
427 
428     function setBeneficiary(address _beneficiary) public onlyOwner {
429         BeneficiaryChanged(beneficiary, _beneficiary);
430         beneficiary = _beneficiary;
431     }
432 
433     function setNotifier(address _notifier) public onlyOwner {
434         NotifierChanged(notifier, _notifier);
435         notifier = _notifier;
436     }
437 
438     /*
439      * The fallback function corresponds to a donation in ETH
440      */
441     function() public payable {
442         if (saleEnabled) sellTokensForEth(msg.sender, msg.value);
443     }
444 
445     function sellTokensForEth(address _buyer, uint256 _amountWei) internal ifNotPaused respectTimeFrame {
446 
447         totalWei = safeAdd(totalWei, _amountWei);
448         weiReceived = safeAdd(weiReceived, _amountWei);
449         require(totalWei <= maxCapWei); // If max cap reached.
450 
451         uint256 tokensE18 = weiToTokens(_amountWei);
452         require(tokensE18 >= minTokensToBuy);
453 
454         require(token.sell(_buyer, tokensE18)); // Transfer tokens to buyer.
455         totalTokensSold = safeAdd(totalTokensSold, tokensE18);
456         totalEthSales++;
457 
458         Backer backer = backers[_buyer];
459         backer.tokensSent = safeAdd(backer.tokensSent, tokensE18);
460         backer.weiReceived = safeAdd(backer.weiReceived, _amountWei);  // Update the total wei collected during the crowdfunding for this backer
461 
462         EthReceived(_buyer, _amountWei);
463     }
464 
465     // Calc how much tokens you can buy at current time.
466     function weiToTokens(uint256 _amountWei) public constant returns (uint256) {
467         return weiToTokensAtTime(_amountWei, getNow());
468     }
469 
470     function weiToTokensAtTime(uint256 _amountWei, uint _time) public constant returns (uint256) {
471         uint256 rate = tokensPerWei;
472 
473         if (startTime <= _time && _time < bonusEndTime333) rate = tokensPerWeiBonus333;
474         else if (bonusEndTime333 <= _time && _time < bonusEndTime250) rate = tokensPerWeiBonus250;
475         else if (bonusEndTime250 <= _time && _time < endTime) rate = tokensPerWeiBonus111;
476 
477         return safeMul(_amountWei, rate);
478     }
479 
480     //----------------------------------------------------------------------
481     // Begin of external sales.
482 
483     function externalSales(
484         uint8[] _currencies,
485         bytes32[] _txIdSha3,
486         address[] _buyers,
487         uint256[] _amountsWei,
488         uint256[] _tokensE18
489     ) public ifNotPaused canNotify {
490 
491         require(_currencies.length > 0);
492         require(_currencies.length == _txIdSha3.length);
493         require(_currencies.length == _buyers.length);
494         require(_currencies.length == _amountsWei.length);
495         require(_currencies.length == _tokensE18.length);
496 
497         for (uint i = 0; i < _txIdSha3.length; i++) {
498             _externalSaleSha3(
499                 Currency(_currencies[i]),
500                 _txIdSha3[i],
501                 _buyers[i],
502                 _amountsWei[i],
503                 _tokensE18[i]
504             );
505         }
506     }
507 
508     function _externalSaleSha3(
509         Currency _currency,
510         bytes32 _txIdSha3, // To get bytes32 use keccak256(txId) OR sha3(txId)
511         address _buyer,
512         uint256 _amountWei,
513         uint256 _tokensE18
514     ) internal {
515 
516         require(_buyer > 0 && _amountWei > 0 && _tokensE18 > 0);
517 
518         var txsByCur = externalTxs[uint8(_currency)];
519 
520         // If this foreign transaction has been already processed in this contract.
521         require(txsByCur[_txIdSha3] == 0);
522 
523         totalWei = safeAdd(totalWei, _amountWei);
524         require(totalWei <= maxCapWei); // Max cap should not be reached yet.
525 
526         require(token.sell(_buyer, _tokensE18)); // Transfer tokens to buyer.
527         totalTokensSold = safeAdd(totalTokensSold, _tokensE18);
528         totalExternalSales++;
529 
530         txsByCur[_txIdSha3] = _tokensE18;
531         ExternalSaleSha3(_currency, _txIdSha3, _buyer, _amountWei, _tokensE18);
532     }
533 
534     // Get id of currency enum. --------------------------------------------
535 
536     function btcId() public constant returns (uint8) {
537         return uint8(Currency.BTC);
538     }
539 
540     function ltcId() public constant returns (uint8) {
541         return uint8(Currency.LTC);
542     }
543 
544     function zecId() public constant returns (uint8) {
545         return uint8(Currency.ZEC);
546     }
547 
548     function dashId() public constant returns (uint8) {
549         return uint8(Currency.DASH);
550     }
551 
552     function wavesId() public constant returns (uint8) {
553         return uint8(Currency.WAVES);
554     }
555 
556     function usdId() public constant returns (uint8) {
557         return uint8(Currency.USD);
558     }
559 
560     function eurId() public constant returns (uint8) {
561         return uint8(Currency.EUR);
562     }
563 
564     // Get token count by transaction id. ----------------------------------
565 
566     function _tokensByTx(Currency _currency, string _txId) internal constant returns (uint256) {
567         return tokensByTx(uint8(_currency), _txId);
568     }
569 
570     function tokensByTx(uint8 _currency, string _txId) public constant returns (uint256) {
571         return externalTxs[_currency][keccak256(_txId)];
572     }
573 
574     function tokensByBtcTx(string _txId) public constant returns (uint256) {
575         return _tokensByTx(Currency.BTC, _txId);
576     }
577 
578     function tokensByLtcTx(string _txId) public constant returns (uint256) {
579         return _tokensByTx(Currency.LTC, _txId);
580     }
581 
582     function tokensByZecTx(string _txId) public constant returns (uint256) {
583         return _tokensByTx(Currency.ZEC, _txId);
584     }
585 
586     function tokensByDashTx(string _txId) public constant returns (uint256) {
587         return _tokensByTx(Currency.DASH, _txId);
588     }
589 
590     function tokensByWavesTx(string _txId) public constant returns (uint256) {
591         return _tokensByTx(Currency.WAVES, _txId);
592     }
593 
594     function tokensByUsdTx(string _txId) public constant returns (uint256) {
595         return _tokensByTx(Currency.USD, _txId);
596     }
597 
598     function tokensByEurTx(string _txId) public constant returns (uint256) {
599         return _tokensByTx(Currency.EUR, _txId);
600     }
601 
602     // End of external sales.
603     //----------------------------------------------------------------------
604 
605     function totalSales() public constant returns (uint256) {
606         return safeAdd(totalEthSales, totalExternalSales);
607     }
608 
609     function isMaxCapReached() public constant returns (bool) {
610         return totalWei >= maxCapWei;
611     }
612 
613     function isSaleOn() public constant returns (bool) {
614         uint _now = getNow();
615         return startTime <= _now && _now <= endTime;
616     }
617 
618     function isSaleOver() public constant returns (bool) {
619         return getNow() > endTime;
620     }
621 
622     function isFinalized() public constant returns (bool) {
623         return finalizedTime > 0;
624     }
625 
626     /*
627      * Finalize the crowdsale. Raised money can be sent to beneficiary only if crowdsale hit end time or max cap (15m USD).
628      */
629     function finalize() public onlyOwner {
630 
631         // Cannot finalise before end day of crowdsale until max cap is reached.
632         require(isMaxCapReached() || isSaleOver());
633 
634         beneficiary.transfer(this.balance);
635 
636         finalizedTime = getNow();
637     }
638 }
639 
640 contract BsPresale is CommonBsPresale {
641 
642     function BsPresale() CommonBsPresale(
643         0x7aa43ef8aa1829fce420fd1f9e6ebbe2212b3e06, // TODO address _token
644         0x76CA9140540988d36f7be7A8b1172E09E6d8A26c  // TODO address _beneficiary
645     ) {}
646 }