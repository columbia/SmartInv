1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4      function safeMul(uint a, uint b) internal returns (uint) {
5           uint c = a * b;
6           assert(a == 0 || c / a == b);
7           return c;
8      }
9 
10      function safeSub(uint a, uint b) internal returns (uint) {
11           assert(b <= a);
12           return a - b;
13      }
14 
15      function safeAdd(uint a, uint b) internal returns (uint) {
16           uint c = a + b;
17           assert(c>=a && c>=b);
18           return c;
19      }
20 }
21 
22 // ERC20 standard
23 // We don't use ERC23 standard
24 contract StdToken is SafeMath {
25 // Fields:
26      mapping(address => uint256) balances;
27      mapping (address => mapping (address => uint256)) allowed;
28      uint public totalSupply = 0;
29 
30 // Events:
31      event Transfer(address indexed _from, address indexed _to, uint256 _value);
32      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 
34 // Functions:
35      function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns(bool){
36           require(balances[msg.sender] >= _value);
37           require(balances[_to] + _value > balances[_to]);
38 
39           balances[msg.sender] = safeSub(balances[msg.sender],_value);
40           balances[_to] = safeAdd(balances[_to],_value);
41 
42           Transfer(msg.sender, _to, _value);
43           return true;
44      }
45 
46      function transferFrom(address _from, address _to, uint256 _value) returns(bool){
47           require(balances[_from] >= _value);
48           require(allowed[_from][msg.sender] >= _value);
49           require(balances[_to] + _value > balances[_to]);
50 
51           balances[_to] = safeAdd(balances[_to],_value);
52           balances[_from] = safeSub(balances[_from],_value);
53           allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
54 
55           Transfer(_from, _to, _value);
56           return true;
57      }
58 
59      function balanceOf(address _owner) constant returns (uint256) {
60           return balances[_owner];
61      }
62 
63      function approve(address _spender, uint256 _value) returns (bool) {
64           // To change the approve amount you first have to reduce the addresses`
65           //  allowance to zero by calling `approve(_spender, 0)` if it is not
66           //  already 0 to mitigate the race condition described here:
67           //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68           require((_value == 0) || (allowed[msg.sender][_spender] == 0));
69 
70           allowed[msg.sender][_spender] = _value;
71           Approval(msg.sender, _spender, _value);
72           return true;
73      }
74 
75      function allowance(address _owner, address _spender) constant returns (uint256) {
76           return allowed[_owner][_spender];
77      }
78 
79      modifier onlyPayloadSize(uint _size) {
80           require(msg.data.length >= _size + 4);
81           _;
82      }
83 }
84 
85 contract MNTP is StdToken {
86 // Fields:
87      string public constant name = "Goldmint MNT Prelaunch Token";
88      string public constant symbol = "MNTP";
89      uint public constant decimals = 18;
90 
91      address public creator = 0x0;
92      address public icoContractAddress = 0x0;
93      bool public lockTransfers = false;
94 
95      // 10 mln
96      uint public constant TOTAL_TOKEN_SUPPLY = 10000000 * 1 ether;
97 
98 /// Modifiers:
99      modifier onlyCreator() { 
100           require(msg.sender == creator); 
101           _; 
102      }
103 
104      modifier byIcoContract() { 
105           require(msg.sender == icoContractAddress); 
106           _; 
107      }
108 
109      function setCreator(address _creator) onlyCreator {
110           creator = _creator;
111      }
112 
113 // Setters/Getters
114      function setIcoContractAddress(address _icoContractAddress) onlyCreator {
115           icoContractAddress = _icoContractAddress;
116      }
117 
118 // Functions:
119      function MNTP() {
120           creator = msg.sender;
121 
122           assert(TOTAL_TOKEN_SUPPLY == 10000000 * 1 ether);
123      }
124 
125      /// @dev Override
126      function transfer(address _to, uint256 _value) public returns(bool){
127           require(!lockTransfers);
128           return super.transfer(_to,_value);
129      }
130 
131      /// @dev Override
132      function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
133           require(!lockTransfers);
134           return super.transferFrom(_from,_to,_value);
135      }
136 
137      function issueTokens(address _who, uint _tokens) byIcoContract {
138           require((totalSupply + _tokens) <= TOTAL_TOKEN_SUPPLY);
139 
140           balances[_who] = safeAdd(balances[_who],_tokens);
141           totalSupply = safeAdd(totalSupply,_tokens);
142 
143           Transfer(0x0, _who, _tokens);
144      }
145 
146      // For refunds only
147      function burnTokens(address _who, uint _tokens) byIcoContract {
148           balances[_who] = safeSub(balances[_who], _tokens);
149           totalSupply = safeSub(totalSupply, _tokens);
150      }
151 
152      function lockTransfer(bool _lock) byIcoContract {
153           lockTransfers = _lock;
154      }
155 
156      // Do not allow to send money directly to this contract
157      function() {
158           revert();
159      }
160 }
161 
162 // This contract will hold all tokens that were unsold during ICO.
163 //
164 // Goldmint Team should be able to withdraw them and sell only after 1 year is passed after 
165 // ICO is finished.
166 contract GoldmintUnsold is SafeMath {
167      address public creator;
168      address public teamAccountAddress;
169      address public icoContractAddress;
170      uint64 public icoIsFinishedDate;
171 
172      MNTP public mntToken;
173 
174      function GoldmintUnsold(address _teamAccountAddress,address _mntTokenAddress){
175           creator = msg.sender;
176           teamAccountAddress = _teamAccountAddress;
177 
178           mntToken = MNTP(_mntTokenAddress);          
179      }
180 
181      modifier onlyCreator() { 
182           require(msg.sender==creator); 
183           _; 
184      }
185 
186      modifier onlyIcoContract() { 
187           require(msg.sender==icoContractAddress); 
188           _; 
189      }
190 
191 // Setters/Getters
192      function setIcoContractAddress(address _icoContractAddress) onlyCreator {
193           icoContractAddress = _icoContractAddress;
194      }
195 
196      function finishIco() public onlyIcoContract {
197           icoIsFinishedDate = uint64(now);
198      }
199 
200      // can be called by anyone...
201      function withdrawTokens() public {
202           // Check if 1 year is passed
203           uint64 oneYearPassed = icoIsFinishedDate + 365 days;  
204           require(uint(now) >= oneYearPassed);
205 
206           // Transfer all tokens from this contract to the teamAccountAddress
207           uint total = mntToken.balanceOf(this);
208           mntToken.transfer(teamAccountAddress,total);
209      }
210 
211      // Do not allow to send money directly to this contract
212      function() payable {
213           revert();
214      }
215 }
216 
217 contract FoundersVesting is SafeMath {
218      address public creator;
219      address public teamAccountAddress;
220      uint64 public lastWithdrawTime;
221 
222      uint public withdrawsCount = 0;
223      uint public amountToSend = 0;
224 
225      MNTP public mntToken;
226 
227      function FoundersVesting(address _teamAccountAddress,address _mntTokenAddress){
228           teamAccountAddress = _teamAccountAddress;
229           lastWithdrawTime = uint64(now);
230 
231           mntToken = MNTP(_mntTokenAddress);          
232 
233           creator = msg.sender;
234      }
235 
236      modifier onlyCreator() { 
237           require(msg.sender==creator); 
238           _; 
239      }
240 
241      function withdrawTokens() onlyCreator public {
242           // 1 - wait for the next month
243           uint64 oneMonth = lastWithdrawTime + 30 days;  
244           require(uint(now) >= oneMonth);
245 
246           // 2 - calculate amount (only first time)
247           if(withdrawsCount==0){
248                amountToSend = mntToken.balanceOf(this) / 10;
249           }
250 
251           require(amountToSend!=0);
252 
253           // 3 - send 1/10th
254           uint currentBalance = mntToken.balanceOf(this);
255           if(currentBalance<amountToSend){
256              amountToSend = currentBalance;  
257           }
258           mntToken.transfer(teamAccountAddress,amountToSend);
259 
260           // 4 - update counter
261           withdrawsCount++;
262           lastWithdrawTime = uint64(now);
263      }
264 
265      // Do not allow to send money directly to this contract
266      function() payable {
267           revert();
268      }
269 }
270 
271 // This is the main Goldmint ICO smart contract
272 contract Goldmint is SafeMath {
273 // Constants:
274      // These values are HARD CODED!!!
275      // For extra security we split single multisig wallet into 10 separate multisig wallets
276      //
277      // THIS IS A REAL ICO WALLETS!!!
278      // PLEASE DOUBLE CHECK THAT...
279      address[] public multisigs = [
280           0xcec42e247097c276ad3d7cfd270adbd562da5c61,
281           0x373c46c544662b8c5d55c24cf4f9a5020163ec2f,
282           0x672cf829272339a6c8c11b14acc5f9d07bafac7c,
283           0xce0e1981a19a57ae808a7575a6738e4527fb9118,
284           0x93aa76cdb17eea80e4de983108ef575d8fc8f12b,
285           0x20ae3329cd1e35feff7115b46218c9d056d430fd,
286           0xe9fc1a57a5dc1caa3de22a940e9f09e640615f7e,
287           0xd360433950de9f6fa0e93c29425845eed6bfa0d0,
288           0xf0de97eaff5d6c998c80e07746c81a336e1bbd43,
289           0x80b365da1C18f4aa1ecFa0dFA07Ed4417B05Cc69
290      ];
291 
292      // We count ETH invested by person, for refunds (see below)
293      mapping(address => uint) ethInvestedBy;
294      uint collectedWei = 0;
295 
296      // These can be changed before ICO starts ($7USD/MNTP)
297      uint constant STD_PRICE_USD_PER_1000_TOKENS = 7000;
298 
299      // The USD/ETH exchange rate may be changed every hour and can vary from $100 to $700 depending on the market. The exchange rate is retrieved from coinmarketcap.com site and is rounded to $1 dollar. For example if current marketcap price is $306.123 per ETH, the price is set as $306 to the contract.
300      uint public usdPerEthCoinmarketcapRate = 300;
301      uint64 public lastUsdPerEthChangeDate = 0;
302 
303      // Price changes from block to block
304      //uint constant SINGLE_BLOCK_LEN = 700000;
305      // TODO: for test
306      uint constant SINGLE_BLOCK_LEN = 100;
307 
308      // 1 000 000 tokens
309      uint public constant BONUS_REWARD = 1000000 * 1 ether;
310      // 2 000 000 tokens
311      uint public constant FOUNDERS_REWARD = 2000000 * 1 ether;
312      // 7 000 000 is sold during the ICO
313      //uint public constant ICO_TOKEN_SUPPLY_LIMIT = 7000000 * 1 ether;
314 
315      // TODO: for tests only!
316      uint public constant ICO_TOKEN_SUPPLY_LIMIT = 250 * 1 ether;
317 
318      // 150 000 tokens soft cap (otherwise - refund)
319      uint public constant ICO_TOKEN_SOFT_CAP = 150000 * 1 ether;
320 
321      // 3 000 000 can be issued from other currencies
322      uint public constant MAX_ISSUED_FROM_OTHER_CURRENCIES = 3000000 * 1 ether;
323      // 30 000 MNTP tokens per one call only
324      uint public constant MAX_SINGLE_ISSUED_FROM_OTHER_CURRENCIES = 30000 * 1 ether;
325      uint public issuedFromOtherCurrencies = 0;
326 
327 // Fields:
328      address public creator = 0x0;                // can not be changed after deploy
329      address public ethRateChanger = 0x0;         // can not be changed after deploy
330      address public tokenManager = 0x0;           // can be changed by token manager only
331      address public otherCurrenciesChecker = 0x0; // can not be changed after deploy
332 
333      uint64 public icoStartedTime = 0;
334 
335      MNTP public mntToken; 
336 
337      GoldmintUnsold public unsoldContract;
338 
339      // Total amount of tokens sold during ICO
340      uint public icoTokensSold = 0;
341      // Total amount of tokens sent to GoldmintUnsold contract after ICO is finished
342      uint public icoTokensUnsold = 0;
343      // Total number of tokens that were issued by a scripts
344      uint public issuedExternallyTokens = 0;
345      // This is where FOUNDERS_REWARD will be allocated
346      address public foundersRewardsAccount = 0x0;
347 
348      enum State{
349           Init,
350 
351           ICORunning,
352           ICOPaused,
353 
354           // Collected ETH is transferred to multisigs.
355           // Unsold tokens transferred to GoldmintUnsold contract.
356           ICOFinished,
357 
358           // We start to refund if Soft Cap is not reached.
359           // Then each token holder should request a refund personally from his
360           // personal wallet.
361           //
362           // We will return ETHs only to the original address. If your address is changed
363           // or you have lost your keys -> you will not be able to get a refund.
364           // 
365           // There is no any possibility to transfer tokens
366           // There is no any possibility to move back
367           Refunding,
368 
369           // In this state we lock all MNT tokens forever.
370           // We are going to migrate MNTP -> MNT tokens during this stage. 
371           // 
372           // There is no any possibility to transfer tokens
373           // There is no any possibility to move back
374           Migrating
375      }
376      State public currentState = State.Init;
377 
378 // Modifiers:
379      modifier onlyCreator() { 
380           require(msg.sender==creator); 
381           _; 
382      }
383      modifier onlyTokenManager() { 
384           require(msg.sender==tokenManager); 
385           _; 
386      }
387      modifier onlyOtherCurrenciesChecker() { 
388           require(msg.sender==otherCurrenciesChecker); 
389           _; 
390      }
391      modifier onlyEthSetter() { 
392           require(msg.sender==ethRateChanger); 
393           _; 
394      }
395 
396      modifier onlyInState(State state){ 
397           require(state==currentState); 
398           _; 
399      }
400 
401 // Events:
402      event LogStateSwitch(State newState);
403      event LogBuy(address indexed owner, uint value);
404      event LogBurn(address indexed owner, uint value);
405      
406 // Functions:
407      /// @dev Constructor
408      function Goldmint(
409           address _tokenManager,
410           address _ethRateChanger,
411           address _otherCurrenciesChecker,
412 
413           address _mntTokenAddress,
414           address _unsoldContractAddress,
415           address _foundersVestingAddress)
416      {
417           creator = msg.sender;
418 
419           tokenManager = _tokenManager;
420           ethRateChanger = _ethRateChanger;
421           lastUsdPerEthChangeDate = uint64(now);
422 
423           otherCurrenciesChecker = _otherCurrenciesChecker; 
424 
425           mntToken = MNTP(_mntTokenAddress);
426           unsoldContract = GoldmintUnsold(_unsoldContractAddress);
427 
428           // slight rename
429           foundersRewardsAccount = _foundersVestingAddress;
430 
431           assert(multisigs.length==10);
432      }
433 
434      function startICO() public onlyCreator onlyInState(State.Init) {
435           setState(State.ICORunning);
436           icoStartedTime = uint64(now);
437           mntToken.lockTransfer(true);
438           mntToken.issueTokens(foundersRewardsAccount, FOUNDERS_REWARD);
439      }
440 
441      function pauseICO() public onlyCreator onlyInState(State.ICORunning) {
442           setState(State.ICOPaused);
443      }
444 
445      function resumeICO() public onlyCreator onlyInState(State.ICOPaused) {
446           setState(State.ICORunning);
447      }
448 
449      function startRefunding() public onlyCreator onlyInState(State.ICORunning) {
450           // only switch to this state if less than ICO_TOKEN_SOFT_CAP sold
451           require(icoTokensSold < ICO_TOKEN_SOFT_CAP);
452           setState(State.Refunding);
453 
454           // in this state tokens still shouldn't be transferred
455           assert(mntToken.lockTransfers());
456      }
457 
458      function startMigration() public onlyCreator onlyInState(State.ICOFinished) {
459           // there is no way back...
460           setState(State.Migrating);
461 
462           // disable token transfers
463           mntToken.lockTransfer(true);
464      }
465 
466      /// @dev This function can be called by creator at any time,
467      /// or by anyone if ICO has really finished.
468      function finishICO() public onlyInState(State.ICORunning) {
469           require(msg.sender == creator || isIcoFinished());
470           setState(State.ICOFinished);
471 
472           // 1 - lock all transfers
473           mntToken.lockTransfer(false);
474 
475           // 2 - move all unsold tokens to unsoldTokens contract
476           icoTokensUnsold = safeSub(ICO_TOKEN_SUPPLY_LIMIT,icoTokensSold);
477           if(icoTokensUnsold>0){
478                mntToken.issueTokens(unsoldContract,icoTokensUnsold);
479                unsoldContract.finishIco();
480           }
481 
482           // 3 - send all ETH to multisigs
483           // we have N separate multisigs for extra security
484           uint sendThisAmount = (this.balance / 10);
485 
486           // 3.1 - send to 9 multisigs
487           for(uint i=0; i<9; ++i){
488                address ms = multisigs[i];
489 
490                if(this.balance>=sendThisAmount){
491                     ms.transfer(sendThisAmount);
492                }
493           }
494 
495           // 3.2 - send everything left to 10th multisig
496           if(0!=this.balance){
497                address lastMs = multisigs[9];
498                lastMs.transfer(this.balance);
499           }
500      }
501 
502      function setState(State _s) internal {
503           currentState = _s;
504           LogStateSwitch(_s);
505      }
506 
507 // Access methods:
508      function setTokenManager(address _new) public onlyTokenManager {
509           tokenManager = _new;
510      }
511 
512      // TODO: stealing creator's key means stealing otherCurrenciesChecker key too!
513      /*
514      function setOtherCurrenciesChecker(address _new) public onlyCreator {
515           otherCurrenciesChecker = _new;
516      }
517      */
518 
519      // These are used by frontend so we can not remove them
520      function getTokensIcoSold() constant public returns (uint){          
521           return icoTokensSold;       
522      }      
523      
524      function getTotalIcoTokens() constant public returns (uint){          
525           return ICO_TOKEN_SUPPLY_LIMIT;         
526      }       
527      
528      function getMntTokenBalance(address _of) constant public returns (uint){         
529           return mntToken.balanceOf(_of);         
530      }        
531 
532      function getBlockLength()constant public returns (uint){          
533           return SINGLE_BLOCK_LEN;      
534      }
535 
536      function getCurrentPrice()constant public returns (uint){
537           return getMntTokensPerEth(icoTokensSold);
538      }
539 
540      function getTotalCollectedWei()constant public returns (uint){
541           return collectedWei;
542      }
543 
544 /////////////////////////////
545      function isIcoFinished() constant public returns(bool) {
546           return (icoStartedTime > 0)
547             && (now > (icoStartedTime + 30 days) || (icoTokensSold >= ICO_TOKEN_SUPPLY_LIMIT));
548      }
549 
550      function getMntTokensPerEth(uint _tokensSold) public constant returns (uint){
551           // 10 buckets
552           uint priceIndex = (_tokensSold / 1 ether) / SINGLE_BLOCK_LEN;
553           assert(priceIndex>=0 && (priceIndex<=9));
554           
555           uint8[10] memory discountPercents = [20,15,10,8,6,4,2,0,0,0];
556 
557           // We have to multiply by '1 ether' to avoid float truncations
558           // Example: ($7000 * 100) / 120 = $5833.33333
559           uint pricePer1000tokensUsd = 
560                ((STD_PRICE_USD_PER_1000_TOKENS * 100) * 1 ether) / (100 + discountPercents[priceIndex]);
561 
562           // Correct: 300000 / 5833.33333333 = 51.42857142
563           // We have to multiply by '1 ether' to avoid float truncations
564           uint mntPerEth = (usdPerEthCoinmarketcapRate * 1000 * 1 ether * 1 ether) / pricePer1000tokensUsd;
565           return mntPerEth;
566      }
567 
568      function buyTokens(address _buyer) public payable onlyInState(State.ICORunning) {
569           require(msg.value!=0);
570 
571           // The price is selected based on current sold tokens.
572           // Price can 'overlap'. For example:
573           //   1. if currently we sold 699950 tokens (the price is 10% discount)
574           //   2. buyer buys 1000 tokens
575           //   3. the price of all 1000 tokens would be with 10% discount!!!
576           uint newTokens = (msg.value * getMntTokensPerEth(icoTokensSold)) / 1 ether;
577 
578           issueTokensInternal(_buyer,newTokens);
579 
580           // Update this only when buying from ETH
581           ethInvestedBy[msg.sender] = safeAdd(ethInvestedBy[msg.sender], msg.value);
582 
583           // This is total collected ETH
584           collectedWei = safeAdd(collectedWei, msg.value);
585      }
586 
587      /// @dev This is called by other currency processors to issue new tokens 
588      function issueTokensFromOtherCurrency(address _to, uint _weiCount) onlyInState(State.ICORunning) public onlyOtherCurrenciesChecker {
589           require(_weiCount!=0);
590 
591           uint newTokens = (_weiCount * getMntTokensPerEth(icoTokensSold)) / 1 ether;
592           
593           require(newTokens<=MAX_SINGLE_ISSUED_FROM_OTHER_CURRENCIES);
594           require((issuedFromOtherCurrencies + newTokens)<=MAX_ISSUED_FROM_OTHER_CURRENCIES);
595 
596           issueTokensInternal(_to,newTokens);
597 
598           issuedFromOtherCurrencies = issuedFromOtherCurrencies + newTokens;
599      }
600 
601      /// @dev This can be called to manually issue new tokens 
602      /// from the bonus reward
603      function issueTokensExternal(address _to, uint _tokens) public onlyInState(State.ICOFinished) onlyTokenManager {
604           // can not issue more than BONUS_REWARD
605           require((issuedExternallyTokens + _tokens)<=BONUS_REWARD);
606 
607           mntToken.issueTokens(_to,_tokens);
608 
609           issuedExternallyTokens = issuedExternallyTokens + _tokens;
610      }
611 
612      function issueTokensInternal(address _to, uint _tokens) internal {
613           require((icoTokensSold + _tokens)<=ICO_TOKEN_SUPPLY_LIMIT);
614 
615           mntToken.issueTokens(_to,_tokens); 
616           icoTokensSold+=_tokens;
617 
618           LogBuy(_to,_tokens);
619      }
620 
621      // anyone can call this and get his money back
622      function getMyRefund() public onlyInState(State.Refunding) {
623           address sender = msg.sender;
624           uint ethValue = ethInvestedBy[sender];
625 
626           require(ethValue > 0);
627 
628           // 1 - send money back
629           sender.transfer(ethValue);
630           ethInvestedBy[sender] = 0;
631 
632           // 2 - burn tokens
633           mntToken.burnTokens(sender, mntToken.balanceOf(sender));
634      }
635 
636      function setUsdPerEthRate(uint _usdPerEthRate) public onlyEthSetter {
637           // 1 - check
638           require((_usdPerEthRate>=100) && (_usdPerEthRate<=700));
639           uint64 hoursPassed = lastUsdPerEthChangeDate + 1 hours;  
640           require(uint(now) >= hoursPassed);
641 
642           // 2 - update
643           usdPerEthCoinmarketcapRate = _usdPerEthRate;
644           lastUsdPerEthChangeDate = uint64(now);
645      }
646 
647      // Default fallback function
648      function() payable {
649           // buyTokens -> issueTokensInternal
650           buyTokens(msg.sender);
651      }
652 }