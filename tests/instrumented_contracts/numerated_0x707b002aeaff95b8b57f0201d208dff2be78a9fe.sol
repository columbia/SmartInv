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
46     function balanceOf(address _owner) public constant returns (uint256 balance);
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) public returns (bool success);
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of tokens to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) public returns (bool success);
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
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
83     function balanceOf(address _owner) public constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     /// @dev Transfers sender's tokens to a given address. Returns success.
88     /// @param _to Address of token receiver.
89     /// @param _value Number of tokens to transfer.
90     function transfer(address _to, uint256 _value) public returns (bool) {
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
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
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
116     function approve(address _spender, uint256 _value) public returns (bool) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /// @dev Returns number of allowed tokens for given address.
123     /// @param _owner Address of token owner.
124     /// @param _spender Address of token spender.
125     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
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
185     function addOwner(address owner) onlyOwner public returns (bool) {
186         if (!isOwner(owner) && owner != 0) {
187             ownerMap[owner] = true;
188             owners.push(owner);
189 
190             OwnerAdded(owner);
191             return true;
192         } else return false;
193     }
194 
195     function removeOwner(address owner) onlyOwner public returns (bool) {
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
243     string public name;
244     string public symbol;
245     uint256 public totalSupply;
246     uint8 public decimals = 18;
247     string public version = 'v0.1';
248 
249     address public creator;
250     address public seller;     // The main account that holds all tokens at the beginning.
251 
252     uint256 public saleLimit;  // (e18) How many tokens can be sold in total through all tiers or tokensales.
253     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
254     uint256 public totalSales; // Total number of sale (including external sales) made through all tiers or tokensales.
255 
256     bool public locked;
257 
258     event Sell(address indexed _seller, address indexed _buyer, uint256 _value);
259     event SellerChanged(address indexed _oldSeller, address indexed _newSeller);
260 
261     event Lock();
262     event Unlock();
263 
264     event Burn(address indexed _burner, uint256 _value);
265 
266     modifier onlyUnlocked() {
267         if (!isOwner(msg.sender) && locked) throw;
268         _;
269     }
270 
271     function CommonBsToken(
272         address _seller,
273         string _name,
274         string _symbol,
275         uint256 _totalSupplyNoDecimals,
276         uint256 _saleLimitNoDecimals
277     ) MultiOwnable() {
278 
279         // Lock the transfer function during the presale/crowdsale to prevent speculations.
280         locked = true;
281 
282         creator = msg.sender;
283         seller = _seller;
284 
285         name = _name;
286         symbol = _symbol;
287         totalSupply = _totalSupplyNoDecimals * 1e18;
288         saleLimit = _saleLimitNoDecimals * 1e18;
289 
290         balances[seller] = totalSupply;
291         Transfer(0x0, seller, totalSupply);
292     }
293 
294     function changeSeller(address newSeller) onlyOwner public returns (bool) {
295         require(newSeller != 0x0 && seller != newSeller);
296 
297         address oldSeller = seller;
298         uint256 unsoldTokens = balances[oldSeller];
299         balances[oldSeller] = 0;
300         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
301         Transfer(oldSeller, newSeller, unsoldTokens);
302 
303         seller = newSeller;
304         SellerChanged(oldSeller, newSeller);
305         return true;
306     }
307 
308     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
309         return sell(_to, _value * 1e18);
310     }
311 
312     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
313 
314         // Check that we are not out of limit and still can sell tokens:
315         if (saleLimit > 0) require(safeSub(saleLimit, safeAdd(tokensSold, _value)) >= 0);
316 
317         require(_to != address(0));
318         require(_value > 0);
319         require(_value <= balances[seller]);
320 
321         balances[seller] = safeSub(balances[seller], _value);
322         balances[_to] = safeAdd(balances[_to], _value);
323         Transfer(seller, _to, _value);
324 
325         tokensSold = safeAdd(tokensSold, _value);
326         totalSales = safeAdd(totalSales, 1);
327         Sell(seller, _to, _value);
328 
329         return true;
330     }
331 
332     function transfer(address _to, uint256 _value) onlyUnlocked public returns (bool) {
333         return super.transfer(_to, _value);
334     }
335 
336     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked public returns (bool) {
337         return super.transferFrom(_from, _to, _value);
338     }
339 
340     function lock() onlyOwner public {
341         locked = true;
342         Lock();
343     }
344 
345     function unlock() onlyOwner public {
346         locked = false;
347         Unlock();
348     }
349 
350     function burn(uint256 _value) public returns (bool) {
351         require(_value > 0);
352         require(_value <= balances[msg.sender]);
353 
354         balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
355         totalSupply = safeSub(totalSupply, _value);
356         Transfer(msg.sender, 0x0, _value);
357         Burn(msg.sender, _value);
358 
359         return true;
360     }
361 
362     /* Approve and then communicate the approved contract in a single tx */
363     function approveAndCall(address _spender, uint256 _value) public {
364         TokenSpender spender = TokenSpender(_spender);
365         if (approve(_spender, _value)) {
366             spender.receiveApproval(msg.sender, _value);
367         }
368     }
369 }
370 
371 contract CommonBsPresale is SafeMath, Ownable, Pausable {
372 
373     enum Currency { BTC, LTC, ZEC, DASH, WAVES, USD, EUR }
374 
375     // TODO rename to Buyer?
376 
377     struct Backer {
378         uint256 weiReceived; // Amount of wei given by backer
379         uint256 tokensSent;  // Amount of tokens received in return to the given amount of ETH.
380     }
381 
382     // TODO rename to buyers?
383 
384     // (buyer_eth_address -> struct)
385     mapping(address => Backer) public backers;
386 
387     // currency_code => (tx_hash => tokens)
388     mapping(uint8 => mapping(bytes32 => uint256)) public externalTxs;
389 
390     CommonBsToken public token; // Token contract reference.
391     address public beneficiary; // Address that will receive ETH raised during this crowdsale.
392     address public notifier;    // Address that can this crowdsale about changed external conditions.
393 
394     // TODO implement
395     uint256 public minWeiToAccept = 0.0001 ether;
396 
397     uint256 public maxCapWei = 0.01 ether;
398     uint public tokensPerWei = 400 * 1.25; // Ordinary price: 1 ETH = 400 tokens. Plus 25% bonus during presale.
399 
400     uint public startTime; // Will be setup once in a constructor from now().
401     uint public endTime = 1520600400; // 2018-03-09T13:00:00Z
402 
403     // Stats for current crowdsale
404 
405     uint256 public totalInWei         = 0; // Grand total in wei
406     uint256 public totalTokensSold    = 0; // Total amount of tokens sold during this crowdsale.
407     uint256 public totalEthSales      = 0; // Total amount of ETH contributions during this crowdsale.
408     uint256 public totalExternalSales = 0; // Total amount of external contributions (BTC, LTC, USD, etc.) during this crowdsale.
409     uint256 public weiReceived        = 0; // Total amount of wei received during this crowdsale smart contract.
410 
411     uint public finalizedTime = 0; // Unix timestamp when finalize() was called.
412 
413     bool public saleEnabled = true;   // if false, then contract will not sell tokens on payment received
414 
415     event BeneficiaryChanged(address indexed _oldAddress, address indexed _newAddress);
416     event NotifierChanged(address indexed _oldAddress, address indexed _newAddress);
417 
418     event EthReceived(address indexed _buyer, uint256 _amountWei);
419     event ExternalSale(Currency _currency, bytes32 _txIdSha3, address indexed _buyer, uint256 _amountWei, uint256 _tokensE18);
420 
421     modifier respectTimeFrame() {
422         require(isSaleOn());
423         _;
424     }
425 
426     modifier canNotify() {
427         require(msg.sender == owner || msg.sender == notifier);
428         _;
429     }
430 
431     function CommonBsPresale(address _token, address _beneficiary) {
432         token = CommonBsToken(_token);
433         owner = msg.sender;
434         notifier = owner;
435         beneficiary = _beneficiary;
436         startTime = now;
437     }
438 
439     // Override this method to mock current time.
440     function getNow() public constant returns (uint) {
441         return now;
442     }
443 
444     function setSaleEnabled(bool _enabled) public onlyOwner {
445         saleEnabled = _enabled;
446     }
447 
448     function setBeneficiary(address _beneficiary) public onlyOwner {
449         BeneficiaryChanged(beneficiary, _beneficiary);
450         beneficiary = _beneficiary;
451     }
452 
453     function setNotifier(address _notifier) public onlyOwner {
454         NotifierChanged(notifier, _notifier);
455         notifier = _notifier;
456     }
457 
458     /*
459      * The fallback function corresponds to a donation in ETH
460      */
461     function() public payable {
462         if (saleEnabled) sellTokensForEth(msg.sender, msg.value);
463     }
464 
465     function sellTokensForEth(address _buyer, uint256 _amountWei) internal ifNotPaused respectTimeFrame {
466 
467         require(_amountWei >= minWeiToAccept);
468 
469         totalInWei = safeAdd(totalInWei, _amountWei);
470         weiReceived = safeAdd(weiReceived, _amountWei);
471         require(totalInWei <= maxCapWei); // If max cap reached.
472 
473         uint256 tokensE18 = weiToTokens(_amountWei);
474         require(token.sell(_buyer, tokensE18)); // Transfer tokens to buyer.
475         totalTokensSold = safeAdd(totalTokensSold, tokensE18);
476         totalEthSales++;
477 
478         Backer backer = backers[_buyer];
479         backer.tokensSent = safeAdd(backer.tokensSent, tokensE18);
480         backer.weiReceived = safeAdd(backer.weiReceived, _amountWei);  // Update the total wei collected during the crowdfunding for this backer
481 
482         EthReceived(_buyer, _amountWei);
483     }
484 
485     // Calc how much tokens you can buy at current time.
486     function weiToTokens(uint256 _amountWei) public constant returns (uint256) {
487         return safeMul(_amountWei, tokensPerWei);
488     }
489 
490     //----------------------------------------------------------------------
491     // Begin of external sales.
492 
493     function externalSales(
494         uint8[] _currencies,
495         bytes32[] _txIdSha3,
496         address[] _buyers,
497         uint256[] _amountsWei,
498         uint256[] _tokensE18
499     ) public ifNotPaused canNotify {
500 
501         require(_currencies.length > 0);
502         require(_currencies.length == _txIdSha3.length);
503         require(_currencies.length == _buyers.length);
504         require(_currencies.length == _amountsWei.length);
505         require(_currencies.length == _tokensE18.length);
506 
507         for (uint i = 0; i < _txIdSha3.length; i++) {
508             _externalSaleSha3(
509                 Currency(_currencies[i]),
510                 _txIdSha3[i],
511                 _buyers[i],
512                 _amountsWei[i],
513                 _tokensE18[i]
514             );
515         }
516     }
517 
518     function _externalSaleSha3(
519         Currency _currency,
520         bytes32 _txIdSha3, // To get bytes32 use keccak256(txId) OR sha3(txId)
521         address _buyer,
522         uint256 _amountWei,
523         uint256 _tokensE18
524     ) internal {
525 
526         require(_buyer > 0 && _amountWei > 0 && _tokensE18 > 0);
527 
528         var txsByCur = externalTxs[uint8(_currency)];
529 
530         // If this foreign transaction has been already processed in this contract.
531         require(txsByCur[_txIdSha3] == 0);
532 
533         totalInWei = safeAdd(totalInWei, _amountWei);
534         require(totalInWei <= maxCapWei); // Max cap should not be reached yet.
535 
536         require(token.sell(_buyer, _tokensE18)); // Transfer tokens to buyer.
537         totalTokensSold = safeAdd(totalTokensSold, _tokensE18);
538         totalExternalSales++;
539 
540         txsByCur[_txIdSha3] = _tokensE18;
541         ExternalSale(_currency, _txIdSha3, _buyer, _amountWei, _tokensE18);
542     }
543 
544     // Get id of currency enum. --------------------------------------------
545 
546     function btcId() public constant returns (uint8) {
547         return uint8(Currency.BTC);
548     }
549 
550     function ltcId() public constant returns (uint8) {
551         return uint8(Currency.LTC);
552     }
553 
554     function zecId() public constant returns (uint8) {
555         return uint8(Currency.ZEC);
556     }
557 
558     function dashId() public constant returns (uint8) {
559         return uint8(Currency.DASH);
560     }
561 
562     function wavesId() public constant returns (uint8) {
563         return uint8(Currency.WAVES);
564     }
565 
566     function usdId() public constant returns (uint8) {
567         return uint8(Currency.USD);
568     }
569 
570     function eurId() public constant returns (uint8) {
571         return uint8(Currency.EUR);
572     }
573 
574     // Get token count by transaction id. ----------------------------------
575 
576     function _tokensByTx(Currency _currency, string _txId) internal constant returns (uint256) {
577         return tokensByTx(uint8(_currency), _txId);
578     }
579 
580     function tokensByTx(uint8 _currency, string _txId) public constant returns (uint256) {
581         return externalTxs[_currency][keccak256(_txId)];
582     }
583 
584     function tokensByBtcTx(string _txId) public constant returns (uint256) {
585         return _tokensByTx(Currency.BTC, _txId);
586     }
587 
588     function tokensByLtcTx(string _txId) public constant returns (uint256) {
589         return _tokensByTx(Currency.LTC, _txId);
590     }
591 
592     function tokensByZecTx(string _txId) public constant returns (uint256) {
593         return _tokensByTx(Currency.ZEC, _txId);
594     }
595 
596     function tokensByDashTx(string _txId) public constant returns (uint256) {
597         return _tokensByTx(Currency.DASH, _txId);
598     }
599 
600     function tokensByWavesTx(string _txId) public constant returns (uint256) {
601         return _tokensByTx(Currency.WAVES, _txId);
602     }
603 
604     function tokensByUsdTx(string _txId) public constant returns (uint256) {
605         return _tokensByTx(Currency.USD, _txId);
606     }
607 
608     function tokensByEurTx(string _txId) public constant returns (uint256) {
609         return _tokensByTx(Currency.EUR, _txId);
610     }
611 
612     // End of external sales.
613     //----------------------------------------------------------------------
614 
615     function totalSales() public constant returns (uint256) {
616         return safeAdd(totalEthSales, totalExternalSales);
617     }
618 
619     function isMaxCapReached() public constant returns (bool) {
620         return totalInWei >= maxCapWei;
621     }
622 
623     function isSaleOn() public constant returns (bool) {
624         uint _now = getNow();
625         return startTime <= _now && _now <= endTime;
626     }
627 
628     function isSaleOver() public constant returns (bool) {
629         return getNow() > endTime;
630     }
631 
632     function isFinalized() public constant returns (bool) {
633         return finalizedTime > 0;
634     }
635 
636     /*
637      * Finalize the crowdsale. Raised money can be sent to beneficiary only if crowdsale hit end time or max cap.
638      */
639     function finalize() public onlyOwner {
640 
641         // Cannot finalise before end day of crowdsale until max cap is reached.
642         require(isMaxCapReached() || isSaleOver());
643 
644         beneficiary.transfer(this.balance);
645 
646         finalizedTime = getNow();
647     }
648 }
649 
650 contract XPresale is CommonBsPresale {
651 
652     function XPresale() public CommonBsPresale(
653         0x625615dCb1b33C4c5F28f48609e46B0727cfB451, // TODO address _token
654         0xE3E9F66E5Ebe9E961662da34FF9aEA95c6795fd0  // TODO address _beneficiary
655     ) {}
656 }