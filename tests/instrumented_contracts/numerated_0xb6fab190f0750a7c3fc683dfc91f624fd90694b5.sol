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
35      function transfer(address _to, uint256 _value) returns(bool){
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
218      address public teamAccountAddress;
219      uint64 public lastWithdrawTime;
220 
221      uint public withdrawsCount = 0;
222      uint public amountToSend = 0;
223 
224      MNTP public mntToken;
225 
226      function FoundersVesting(address _teamAccountAddress,address _mntTokenAddress){
227           teamAccountAddress = _teamAccountAddress;
228           lastWithdrawTime = uint64(now);
229 
230           mntToken = MNTP(_mntTokenAddress);          
231      }
232 
233      // Can be called by anyone
234      function withdrawTokens() public {
235           // 1 - wait for the next month
236           uint64 oneMonth = lastWithdrawTime + 30 days;  
237           require(uint(now) >= oneMonth);
238 
239           // 2 - calculate amount (only first time)
240           if(withdrawsCount==0){
241                amountToSend = mntToken.balanceOf(this) / 10;
242           }
243 
244           require(amountToSend!=0);
245 
246           // 3 - send 1/10th
247           uint currentBalance = mntToken.balanceOf(this);
248           if(currentBalance<amountToSend){
249              amountToSend = currentBalance;  
250           }
251           mntToken.transfer(teamAccountAddress,amountToSend);
252 
253           // 4 - update counter
254           withdrawsCount++;
255           lastWithdrawTime = uint64(now);
256      }
257 
258      // Do not allow to send money directly to this contract
259      function() payable {
260           revert();
261      }
262 }
263 
264 // This is the main Goldmint ICO smart contract
265 contract Goldmint is SafeMath {
266 // Constants:
267      // These values are HARD CODED!!!
268      // For extra security we split single multisig wallet into 10 separate multisig wallets
269      //
270      // TODO: set real params here
271      address[] public multisigs = [
272           0x27ce565b1047c6258164062983bb8bc2917f11d2,
273           0xfb3afc815894e91fe1ab6e6ef36f8565fbb904f6,
274           0x7e2a7a10509177db2a7ea41e728743c4eb42f528,
275           0x27ce565b1047c6258164062983bb8bc2917f11d2,
276           0xfb3afc815894e91fe1ab6e6ef36f8565fbb904f6,
277           0x7e2a7a10509177db2a7ea41e728743c4eb42f528,
278           0x27ce565b1047c6258164062983bb8bc2917f11d2,
279           0xfb3afc815894e91fe1ab6e6ef36f8565fbb904f6,
280           0x7e2a7a10509177db2a7ea41e728743c4eb42f528,
281           0xF4Ce80097bf1E584822dBcA84f91D5d7d9df0846
282      ];
283 
284      // We count ETH invested by person, for refunds (see below)
285      mapping(address => uint) ethInvestedBy;
286      // These can be changed before ICO starts ($7USD/MNTP)
287      uint constant STD_PRICE_USD_PER_1000_TOKENS = 7000;
288      // USD/ETH is fixed for the whole ICO
289      // WARNING: if USD/ETH rate changes DURING ICO -> we won't change it
290      // coinmarketcap.com 04.09.2017
291      uint constant ETH_PRICE_IN_USD = 300;
292      // Price changes from block to block
293      //uint constant SINGLE_BLOCK_LEN = 700000;
294 
295      uint constant SINGLE_BLOCK_LEN = 100;
296 
297      // 1 000 000 tokens
298      uint public constant BONUS_REWARD = 1000000 * 1 ether;
299      // 2 000 000 tokens
300      uint public constant FOUNDERS_REWARD = 2000000 * 1 ether;
301      // 7 000 000 is sold during the ICO
302      //uint public constant ICO_TOKEN_SUPPLY_LIMIT = 7000000 * 1 ether;
303 
304      uint public constant ICO_TOKEN_SUPPLY_LIMIT = 150 * 1 ether;
305 
306      // 150 000 tokens soft cap (otherwise - refund)
307      uint public constant ICO_TOKEN_SOFT_CAP = 150000 * 1 ether;
308 
309 // Fields:
310      address public creator = 0x0;
311      address public tokenManager = 0x0;
312      address public otherCurrenciesChecker = 0x0;
313 
314      uint64 public icoStartedTime = 0;
315 
316      MNTP public mntToken; 
317 
318      GoldmintUnsold public unsoldContract;
319 
320      // Total amount of tokens sold during ICO
321      uint public icoTokensSold = 0;
322      // Total amount of tokens sent to GoldmintUnsold contract after ICO is finished
323      uint public icoTokensUnsold = 0;
324      // Total number of tokens that were issued by a scripts
325      uint public issuedExternallyTokens = 0;
326      // This is where FOUNDERS_REWARD will be allocated
327      address public foundersRewardsAccount = 0x0;
328 
329      enum State{
330           Init,
331 
332           ICORunning,
333           ICOPaused,
334 
335           // Collected ETH is transferred to multisigs.
336           // Unsold tokens transferred to GoldmintUnsold contract.
337           ICOFinished,
338 
339           // We start to refund if Soft Cap is not reached.
340           // Then each token holder should request a refund personally from his
341           // personal wallet.
342           //
343           // We will return ETHs only to the original address. If your address is changed
344           // or you have lost your keys -> you will not be able to get a refund.
345           // 
346           // There is no any possibility to transfer tokens
347           // There is no any possibility to move back
348           Refunding,
349 
350           // In this state we lock all MNT tokens forever.
351           // We are going to migrate MNTP -> MNT tokens during this stage. 
352           // 
353           // There is no any possibility to transfer tokens
354           // There is no any possibility to move back
355           Migrating
356      }
357      State public currentState = State.Init;
358 
359 // Modifiers:
360      modifier onlyCreator() { 
361           require(msg.sender==creator); 
362           _; 
363      }
364      modifier onlyTokenManager() { 
365           require(msg.sender==tokenManager); 
366           _; 
367      }
368      modifier onlyOtherCurrenciesChecker() { 
369           require(msg.sender==otherCurrenciesChecker); 
370           _; 
371      }
372      modifier onlyInState(State state){ 
373           require(state==currentState); 
374           _; 
375      }
376 
377 // Events:
378      event LogStateSwitch(State newState);
379      event LogBuy(address indexed owner, uint value);
380      event LogBurn(address indexed owner, uint value);
381      
382 // Functions:
383      /// @dev Constructor
384      function Goldmint(
385           address _tokenManager,
386           address _otherCurrenciesChecker,
387 
388           address _mntTokenAddress,
389           address _unsoldContractAddress,
390           address _foundersVestingAddress)
391      {
392           creator = msg.sender;
393 
394           tokenManager = _tokenManager;
395           otherCurrenciesChecker = _otherCurrenciesChecker; 
396 
397           mntToken = MNTP(_mntTokenAddress);
398           unsoldContract = GoldmintUnsold(_unsoldContractAddress);
399 
400           // slight rename
401           foundersRewardsAccount = _foundersVestingAddress;
402 
403           assert(multisigs.length==10);
404      }
405 
406      function startICO() public onlyCreator onlyInState(State.Init) {
407           setState(State.ICORunning);
408           icoStartedTime = uint64(now);
409           mntToken.lockTransfer(true);
410           mntToken.issueTokens(foundersRewardsAccount, FOUNDERS_REWARD);
411      }
412 
413      function pauseICO() public onlyCreator onlyInState(State.ICORunning) {
414           setState(State.ICOPaused);
415      }
416 
417      function resumeICO() public onlyCreator onlyInState(State.ICOPaused) {
418           setState(State.ICORunning);
419      }
420 
421      function startRefunding() public onlyCreator onlyInState(State.ICORunning) {
422           // only switch to this state if less than ICO_TOKEN_SOFT_CAP sold
423           require(icoTokensSold < ICO_TOKEN_SOFT_CAP);
424           setState(State.Refunding);
425 
426           // in this state tokens still shouldn't be transferred
427           assert(mntToken.lockTransfers());
428      }
429 
430      function startMigration() public onlyCreator onlyInState(State.ICOFinished) {
431           // there is no way back...
432           setState(State.Migrating);
433 
434           // disable token transfers
435           mntToken.lockTransfer(true);
436      }
437 
438      /// @dev This function can be called by creator at any time,
439      /// or by anyone if ICO has really finished.
440      function finishICO() public onlyInState(State.ICORunning) {
441           require(msg.sender == creator || isIcoFinished());
442           setState(State.ICOFinished);
443 
444           // 1 - lock all transfers
445           mntToken.lockTransfer(false);
446 
447           // 2 - move all unsold tokens to unsoldTokens contract
448           icoTokensUnsold = safeSub(ICO_TOKEN_SUPPLY_LIMIT,icoTokensSold);
449           if(icoTokensUnsold>0){
450                mntToken.issueTokens(unsoldContract,icoTokensUnsold);
451                unsoldContract.finishIco();
452           }
453 
454           // 3 - send all ETH to multisigs
455           // we have N separate multisigs for extra security
456           uint sendThisAmount = (this.balance / 10);
457 
458           // 3.1 - send to 9 multisigs
459           for(uint i=0; i<9; ++i){
460                address ms = multisigs[i];
461 
462                if(this.balance>=sendThisAmount){
463                     ms.transfer(sendThisAmount);
464                }
465           }
466 
467           // 3.2 - send everything left to 10th multisig
468           if(0!=this.balance){
469                address lastMs = multisigs[9];
470                lastMs.transfer(this.balance);
471           }
472      }
473 
474      function setState(State _s) internal {
475           currentState = _s;
476           LogStateSwitch(_s);
477      }
478 
479 // Access methods:
480      function setTokenManager(address _new) public onlyTokenManager {
481           tokenManager = _new;
482      }
483 
484      // TODO: stealing creator's key means stealing otherCurrenciesChecker key too!
485      /*
486      function setOtherCurrenciesChecker(address _new) public onlyCreator {
487           otherCurrenciesChecker = _new;
488      }
489      */
490 
491      // These are used by frontend so we can not remove them
492      function getTokensIcoSold() constant public returns (uint){          
493           return icoTokensSold;       
494      }      
495      
496      function getTotalIcoTokens() constant public returns (uint){          
497           return ICO_TOKEN_SUPPLY_LIMIT;         
498      }       
499      
500      function getMntTokenBalance(address _of) constant public returns (uint){         
501           return mntToken.balanceOf(_of);         
502      }        
503 
504      function getBlockLength()constant public returns (uint){          
505           return SINGLE_BLOCK_LEN;      
506      }
507 
508      function getCurrentPrice()constant public returns (uint){
509           return getMntTokensPerEth(icoTokensSold);
510      }
511 
512 /////////////////////////////
513      function isIcoFinished() constant public returns(bool) {
514           return (icoStartedTime > 0)
515             && (now > (icoStartedTime + 30 days) || (icoTokensSold >= ICO_TOKEN_SUPPLY_LIMIT));
516      }
517 
518      function getMntTokensPerEth(uint _tokensSold) public constant returns (uint){
519           // 10 buckets
520           uint priceIndex = (_tokensSold / 1 ether) / SINGLE_BLOCK_LEN;
521           assert(priceIndex>=0 && (priceIndex<=9));
522           
523           uint8[10] memory discountPercents = [20,15,10,8,6,4,2,0,0,0];
524 
525           // We have to multiply by '1 ether' to avoid float truncations
526           // Example: ($7000 * 100) / 120 = $5833.33333
527           uint pricePer1000tokensUsd = 
528                ((STD_PRICE_USD_PER_1000_TOKENS * 100) * 1 ether) / (100 + discountPercents[priceIndex]);
529 
530           // Correct: 300000 / 5833.33333333 = 51.42857142
531           // We have to multiply by '1 ether' to avoid float truncations
532           uint mntPerEth = (ETH_PRICE_IN_USD * 1000 * 1 ether * 1 ether) / pricePer1000tokensUsd;
533           return mntPerEth;
534      }
535 
536      function buyTokens(address _buyer) public payable onlyInState(State.ICORunning) {
537           require(msg.value!=0);
538 
539           // The price is selected based on current sold tokens.
540           // Price can 'overlap'. For example:
541           //   1. if currently we sold 699950 tokens (the price is 10% discount)
542           //   2. buyer buys 1000 tokens
543           //   3. the price of all 1000 tokens would be with 10% discount!!!
544           uint newTokens = (msg.value * getMntTokensPerEth(icoTokensSold)) / 1 ether;
545 
546           issueTokensInternal(_buyer,newTokens);
547 
548           // Update this only when buying from ETH
549           ethInvestedBy[msg.sender] = safeAdd(ethInvestedBy[msg.sender], msg.value);
550      }
551 
552      /// @dev This is called by other currency processors to issue new tokens 
553      function issueTokensFromOtherCurrency(address _to, uint _weiCount) onlyInState(State.ICORunning) public onlyOtherCurrenciesChecker {
554           require(_weiCount!=0);
555 
556           uint newTokens = (_weiCount * getMntTokensPerEth(icoTokensSold)) / 1 ether;
557           issueTokensInternal(_to,newTokens);
558      }
559 
560      /// @dev This can be called to manually issue new tokens 
561      /// from the bonus reward
562      function issueTokensExternal(address _to, uint _tokens) public onlyInState(State.ICOFinished) onlyTokenManager {
563           // can not issue more than BONUS_REWARD
564           require((issuedExternallyTokens + _tokens)<=BONUS_REWARD);
565 
566           mntToken.issueTokens(_to,_tokens);
567 
568           issuedExternallyTokens = issuedExternallyTokens + _tokens;
569      }
570 
571      function issueTokensInternal(address _to, uint _tokens) internal {
572           require((icoTokensSold + _tokens)<=ICO_TOKEN_SUPPLY_LIMIT);
573 
574           mntToken.issueTokens(_to,_tokens);
575 
576           icoTokensSold+=_tokens;
577 
578           LogBuy(_to,_tokens);
579      }
580 
581      // anyone can call this and get his money back
582      function getMyRefund() public onlyInState(State.Refunding) {
583           address sender = msg.sender;
584           uint ethValue = ethInvestedBy[sender];
585 
586           require(ethValue > 0);
587 
588           // 1 - send money back
589           sender.transfer(ethValue);
590           ethInvestedBy[sender] = 0;
591 
592           // 2 - burn tokens
593           mntToken.burnTokens(sender, mntToken.balanceOf(sender));
594      }
595 
596      // Default fallback function
597      function() payable {
598           // buyTokens -> issueTokensInternal
599           buyTokens(msg.sender);
600      }
601 }