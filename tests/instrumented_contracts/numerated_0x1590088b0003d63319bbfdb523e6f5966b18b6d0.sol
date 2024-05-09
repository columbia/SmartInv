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
22 // Standard token interface (ERC 20)
23 // https://github.com/ethereum/EIPs/issues/20
24 contract Token is SafeMath {
25      // Functions:
26      /// @return total amount of tokens
27      function totalSupply() constant returns (uint256 supply) {}
28 
29      /// @param _owner The address from which the balance will be retrieved
30      /// @return The balance
31      function balanceOf(address _owner) constant returns (uint256 balance) {}
32 
33      /// @notice send `_value` token to `_to` from `msg.sender`
34      /// @param _to The address of the recipient
35      /// @param _value The amount of token to be transferred
36      function transfer(address _to, uint256 _value) returns(bool) {}
37 
38      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39      /// @param _from The address of the sender
40      /// @param _to The address of the recipient
41      /// @param _value The amount of token to be transferred
42      /// @return Whether the transfer was successful or not
43      function transferFrom(address _from, address _to, uint256 _value)returns(bool){}
44 
45      /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46      /// @param _spender The address of the account able to transfer the tokens
47      /// @param _value The amount of wei to be approved for transfer
48      /// @return Whether the approval was successful or not
49      function approve(address _spender, uint256 _value) returns (bool success) {}
50 
51      /// @param _owner The address of the account owning tokens
52      /// @param _spender The address of the account able to transfer the tokens
53      /// @return Amount of remaining tokens allowed to spent
54      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
55 
56      // Events:
57      event Transfer(address indexed _from, address indexed _to, uint256 _value);
58      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 }
60 
61 contract StdToken is Token {
62      // Fields:
63      mapping(address => uint256) balances;
64      mapping (address => mapping (address => uint256)) allowed;
65      uint public totalSupply = 0;
66 
67      // Functions:
68      function transfer(address _to, uint256 _value) returns(bool){
69           require(balances[msg.sender] >= _value);
70           require(balances[_to] + _value > balances[_to]);
71 
72           balances[msg.sender] = safeSub(balances[msg.sender],_value);
73           balances[_to] = safeAdd(balances[_to],_value);
74 
75           Transfer(msg.sender, _to, _value);
76           return true;
77      }
78 
79      function transferFrom(address _from, address _to, uint256 _value) returns(bool){
80           require(balances[_from] >= _value);
81           require(allowed[_from][msg.sender] >= _value);
82           require(balances[_to] + _value > balances[_to]);
83 
84           balances[_to] = safeAdd(balances[_to],_value);
85           balances[_from] = safeSub(balances[_from],_value);
86           allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
87 
88           Transfer(_from, _to, _value);
89           return true;
90      }
91 
92      function balanceOf(address _owner) constant returns (uint256 balance) {
93           return balances[_owner];
94      }
95 
96      function approve(address _spender, uint256 _value) returns (bool success) {
97           allowed[msg.sender][_spender] = _value;
98           Approval(msg.sender, _spender, _value);
99           return true;
100      }
101 
102      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103           return allowed[_owner][_spender];
104      }
105 
106      modifier onlyPayloadSize(uint _size) {
107           require(msg.data.length >= _size + 4);
108           _;
109      }
110 }
111 
112 contract MNTP is StdToken {
113 /// Fields:
114      string public constant name = "Goldmint MNT Prelaunch Token";
115      string public constant symbol = "MNTP";
116      uint public constant decimals = 18;
117 
118      address public creator = 0x0;
119      address public icoContractAddress = 0x0;
120      bool public lockTransfers = false;
121 
122      // 10 mln
123      uint public constant TOTAL_TOKEN_SUPPLY = 10000000 * (1 ether / 1 wei);
124 
125 /// Modifiers:
126      modifier onlyCreator() { 
127           require(msg.sender == creator); 
128           _; 
129      }
130 
131      modifier byCreatorOrIcoContract() { 
132           require((msg.sender == creator) || (msg.sender == icoContractAddress)); 
133           _; 
134      }
135 
136      function setCreator(address _creator) onlyCreator {
137           creator = _creator;
138      }
139 
140 /// Setters/Getters
141      function setIcoContractAddress(address _icoContractAddress) onlyCreator {
142           icoContractAddress = _icoContractAddress;
143      }
144 
145 /// Functions:
146      /// @dev Constructor
147      function MNTP() {
148           creator = msg.sender;
149 
150           // 10 mln tokens total
151           assert(TOTAL_TOKEN_SUPPLY == (10000000 * (1 ether / 1 wei)));
152      }
153 
154      /// @dev Override
155      function transfer(address _to, uint256 _value) public returns(bool){
156           require(!lockTransfers);
157           return super.transfer(_to,_value);
158      }
159 
160      /// @dev Override
161      function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
162           require(!lockTransfers);
163           return super.transferFrom(_from,_to,_value);
164      }
165 
166      function issueTokens(address _who, uint _tokens) byCreatorOrIcoContract {
167           require((totalSupply + _tokens) <= TOTAL_TOKEN_SUPPLY);
168 
169           balances[_who] = safeAdd(balances[_who],_tokens);
170           totalSupply = safeAdd(totalSupply,_tokens);
171      }
172 
173      function burnTokens(address _who, uint _tokens) byCreatorOrIcoContract {
174           balances[_who] = safeSub(balances[_who], _tokens);
175           totalSupply = safeSub(totalSupply, _tokens);
176      }
177 
178      function lockTransfer(bool _lock) byCreatorOrIcoContract {
179           lockTransfers = _lock;
180      }
181 
182      // Do not allow to send money directly to this contract
183      function() {
184           revert();
185      }
186 }
187 
188 // This contract will hold all tokens that were unsold during ICO
189 // (Goldmint should be able to withdraw them and sold only 1 year post-ICO)
190 contract GoldmintUnsold is SafeMath {
191      address public creator;
192      address public teamAccountAddress;
193      address public icoContractAddress;
194      uint64 public icoIsFinishedDate;
195 
196      MNTP public mntToken;
197 
198      function GoldmintUnsold(address _teamAccountAddress,address _mntTokenAddress){
199           creator = msg.sender;
200           teamAccountAddress = _teamAccountAddress;
201 
202           mntToken = MNTP(_mntTokenAddress);          
203      }
204 
205      modifier onlyCreator() { 
206           require(msg.sender==creator); 
207           _; 
208      }
209 
210      modifier onlyIcoContract() { 
211           require(msg.sender==icoContractAddress); 
212           _; 
213      }
214 
215 /// Setters/Getters
216      function setIcoContractAddress(address _icoContractAddress) onlyCreator {
217           icoContractAddress = _icoContractAddress;
218      }
219 
220      // only by Goldmint contract 
221      function finishIco() public onlyIcoContract {
222           icoIsFinishedDate = uint64(now);
223      }
224 
225      // can be called by anyone...
226      function withdrawTokens() public {
227           // wait for 1 year!
228           uint64 oneYearPassed = icoIsFinishedDate + 365 days;  
229           require(uint(now) >= oneYearPassed);
230 
231           // transfer all tokens from this contract to the teamAccountAddress
232           uint total = mntToken.balanceOf(this);
233           mntToken.transfer(teamAccountAddress,total);
234      }
235 
236      // Default fallback function
237      function() payable {
238           revert();
239      }
240 }
241 
242 contract FoundersVesting is SafeMath {
243      address public teamAccountAddress;
244      uint64 public lastWithdrawTime;
245 
246      uint public withdrawsCount = 0;
247      uint public amountToSend = 0;
248 
249      MNTP public mntToken;
250 
251      function FoundersVesting(address _teamAccountAddress,address _mntTokenAddress){
252           teamAccountAddress = _teamAccountAddress;
253           lastWithdrawTime = uint64(now);
254 
255           mntToken = MNTP(_mntTokenAddress);          
256      }
257 
258      // can be called by anyone...
259      function withdrawTokens() public {
260           // 1 - wait for next month!
261           uint64 oneMonth = lastWithdrawTime + 30 days;  
262           require(uint(now) >= oneMonth);
263 
264           // 2 - calculate amount (only first time)
265           if(withdrawsCount==0){
266                amountToSend = mntToken.balanceOf(this) / 10;
267           }
268 
269           require(amountToSend!=0);
270 
271           // 3 - send 1/10th
272           uint currentBalance = mntToken.balanceOf(this);
273           if(currentBalance<amountToSend){
274              amountToSend = currentBalance;  
275           }
276           mntToken.transfer(teamAccountAddress,amountToSend);
277 
278           // 4 - update counter
279           withdrawsCount++;
280           lastWithdrawTime = uint64(now);
281      }
282 
283      // Default fallback function
284      function() payable {
285           require(false);
286      }
287 }
288 
289 contract Goldmint is SafeMath {
290      address public creator = 0x0;
291      address public tokenManager = 0x0;
292      address public multisigAddress = 0x0;
293      address public otherCurrenciesChecker = 0x0;
294 
295      uint64 public icoStartedTime = 0;
296 
297      MNTP public mntToken; 
298      GoldmintUnsold public unsoldContract;
299 
300      struct TokenBuyer {
301           uint weiSent;
302           uint tokensGot;
303      }
304      mapping(address => TokenBuyer) buyers;
305 
306      // These can be changed before ICO start ($7USD/MNTP)
307      uint constant STD_PRICE_USD_PER_1000_TOKENS = 7000;
308      // coinmarketcap.com 14.08.2017
309      uint constant ETH_PRICE_IN_USD = 300;
310      // price changes from block to block
311      //uint public constant SINGLE_BLOCK_LEN = 700000;
312 
313      // TODO: only for tests. DO NOT merge this to master!!!
314      uint public constant SINGLE_BLOCK_LEN = 100;
315 
316 ///////     
317      // 1 000 000 tokens
318      uint public constant BONUS_REWARD = 1000000 * (1 ether/ 1 wei);
319      // 2 000 000 tokens
320      uint public constant FOUNDERS_REWARD = 2000000 * (1 ether / 1 wei);
321      // 7 000 000 we sell only this amount of tokens during the ICO
322      //uint public constant ICO_TOKEN_SUPPLY_LIMIT = 7000000 * (1 ether / 1 wei); 
323 
324      // TODO: only for tests. DO NOT merge this to master!!!
325      // 150 - we sell only this amount of tokens during the ICO
326      uint public constant ICO_TOKEN_SUPPLY_LIMIT = 150 * (1 ether / 1 wei); 
327 
328      // 150 000 tokens soft cap
329      uint public constant ICO_TOKEN_SOFT_CAP = 150000 * (1 ether / 1 wei);
330      
331      // this is total number of tokens sold during ICO
332      uint public icoTokensSold = 0;
333      // this is total number of tokens sent to GoldmintUnsold contract after ICO is finished
334      uint public icoTokensUnsold = 0;
335 
336      // this is total number of tokens that were issued by a scripts
337      uint public issuedExternallyTokens = 0;
338 
339      bool public foundersRewardsMinted = false;
340      bool public restTokensMoved = false;
341 
342      // this is where FOUNDERS_REWARD will be allocated
343      address public foundersRewardsAccount = 0x0;
344 
345      enum State{
346           Init,
347 
348           ICORunning,
349           ICOPaused,
350          
351           ICOFinished,
352 
353           Refunding
354      }
355      State public currentState = State.Init;
356 
357 /// Modifiers:
358      modifier onlyCreator() { 
359           require(msg.sender==creator); 
360           _; 
361      }
362      modifier onlyTokenManager() { 
363           require(msg.sender==tokenManager); 
364           _; 
365      }
366      modifier onlyOtherCurrenciesChecker() { 
367           require(msg.sender==otherCurrenciesChecker); 
368           _; 
369      }
370      modifier onlyInState(State state){ 
371           require(state==currentState); 
372           _; 
373      }
374 
375 /// Events:
376      event LogStateSwitch(State newState);
377      event LogBuy(address indexed owner, uint value);
378      event LogBurn(address indexed owner, uint value);
379      
380 /// Functions:
381      /// @dev Constructor
382      function Goldmint(
383           address _multisigAddress,
384           address _tokenManager,
385           address _otherCurrenciesChecker,
386 
387           address _mntTokenAddress,
388           address _unsoldContractAddress,
389           address _foundersVestingAddress)
390      {
391           creator = msg.sender;
392 
393           multisigAddress = _multisigAddress;
394           tokenManager = _tokenManager;
395           otherCurrenciesChecker = _otherCurrenciesChecker; 
396 
397           mntToken = MNTP(_mntTokenAddress);
398           unsoldContract = GoldmintUnsold(_unsoldContractAddress);
399 
400           // slight rename
401           foundersRewardsAccount = _foundersVestingAddress;
402      }
403 
404      /// @dev This function is automatically called when ICO is started
405      /// WARNING: can be called multiple times!
406      function startICO() internal onlyCreator {
407           mintFoundersRewards(foundersRewardsAccount);
408 
409           mntToken.lockTransfer(true);
410 
411           if(icoStartedTime==0){
412                icoStartedTime = uint64(now);
413           }
414      }
415 
416      function pauseICO() internal onlyCreator {
417      }
418 
419      function startRefunding() internal onlyCreator {
420           // only switch to this state if less than ICO_TOKEN_SOFT_CAP sold
421           require(icoTokensSold<ICO_TOKEN_SOFT_CAP);
422 
423           // in this state tokens still shouldn't be transferred
424           assert(mntToken.lockTransfers());
425      }
426 
427      /// @dev This function is automatically called when ICO is finished 
428      /// WARNING: can be called multiple times!
429      function finishICO() internal {
430           mntToken.lockTransfer(false);
431 
432           if(!restTokensMoved){
433                restTokensMoved = true;
434 
435                // move all unsold tokens to unsoldTokens contract
436                icoTokensUnsold = safeSub(ICO_TOKEN_SUPPLY_LIMIT,icoTokensSold);
437                if(icoTokensUnsold>0){
438                     mntToken.issueTokens(unsoldContract,icoTokensUnsold);
439                     unsoldContract.finishIco();
440                }
441           }
442 
443           // send all ETH to multisig
444           if(this.balance>0){
445                multisigAddress.transfer(this.balance);
446           }
447      }
448 
449      function mintFoundersRewards(address _whereToMint) internal onlyCreator {
450           if(!foundersRewardsMinted){
451                foundersRewardsMinted = true;
452                mntToken.issueTokens(_whereToMint,FOUNDERS_REWARD);
453           }
454      }
455 
456 /// Access methods:
457      function setTokenManager(address _new) public onlyTokenManager {
458           tokenManager = _new;
459      }
460 
461      function setOtherCurrenciesChecker(address _new) public onlyCreator {
462           otherCurrenciesChecker = _new;
463      }
464 
465      function getTokensIcoSold() constant public returns (uint){
466           return icoTokensSold;
467      }
468 
469      function getTotalIcoTokens() constant public returns (uint){
470           return ICO_TOKEN_SUPPLY_LIMIT;
471      }
472 
473      function getMntTokenBalance(address _of) constant public returns (uint){
474           return mntToken.balanceOf(_of);
475      }
476 
477      function getCurrentPrice()constant public returns (uint){
478           return getMntTokensPerEth(icoTokensSold);
479      }
480 
481      function getBlockLength()constant public returns (uint){
482           return SINGLE_BLOCK_LEN;
483      }
484 
485 ////
486      function isIcoFinished() public returns(bool){
487           if(icoStartedTime==0){return false;}          
488 
489           // 1 - if time elapsed
490           uint64 oneMonth = icoStartedTime + 30 days;  
491           if(uint(now) > oneMonth){return true;}
492 
493           // 2 - if all tokens are sold
494           if(icoTokensSold>=ICO_TOKEN_SUPPLY_LIMIT){
495                return true;
496           }
497 
498           return false;
499      }
500 
501      function setState(State _nextState) public {
502           // only creator can change state
503           // but in case ICOFinished -> anyone can do that after all time is elapsed
504           bool icoShouldBeFinished = isIcoFinished();
505           bool allow = (msg.sender==creator) || (icoShouldBeFinished && (State.ICOFinished==_nextState));
506           require(allow);
507 
508           bool canSwitchState
509                =  (currentState == State.Init && _nextState == State.ICORunning)
510                || (currentState == State.ICORunning && _nextState == State.ICOPaused)
511                || (currentState == State.ICOPaused && _nextState == State.ICORunning)
512                || (currentState == State.ICORunning && _nextState == State.ICOFinished)
513                || (currentState == State.ICORunning && _nextState == State.Refunding);
514 
515           require(canSwitchState);
516 
517           currentState = _nextState;
518           LogStateSwitch(_nextState);
519 
520           if(currentState==State.ICORunning){
521                startICO();
522           }else if(currentState==State.ICOFinished){
523                finishICO();
524           }else if(currentState==State.ICOPaused){
525                pauseICO();
526           }else if(currentState==State.Refunding){
527                startRefunding();
528           }
529      }
530 
531      function getMntTokensPerEth(uint tokensSold) public constant returns (uint){
532           // 10 buckets
533           uint priceIndex = (tokensSold / (1 ether/ 1 wei)) / SINGLE_BLOCK_LEN;
534           assert(priceIndex>=0 && (priceIndex<=9));
535           
536           uint8[10] memory discountPercents = [20,15,10,8,6,4,2,0,0,0];
537 
538           // We have to multiply by '1 ether' to avoid float truncations
539           // Example: ($7000 * 100) / 120 = $5833.33333
540           uint pricePer1000tokensUsd = 
541                ((STD_PRICE_USD_PER_1000_TOKENS * 100) * (1 ether / 1 wei)) / (100 + discountPercents[priceIndex]);
542 
543           // Correct: 300000 / 5833.33333333 = 51.42857142
544           // We have to multiply by '1 ether' to avoid float truncations
545           uint mntPerEth = (ETH_PRICE_IN_USD * 1000 * (1 ether / 1 wei) * (1 ether / 1 wei)) / pricePer1000tokensUsd;
546           return mntPerEth;
547      }
548 
549      function buyTokens(address _buyer) public payable onlyInState(State.ICORunning) {
550           require(msg.value!=0);
551 
552           // The price is selected based on current sold tokens.
553           // Price can 'overlap'. For example:
554           //   1. if currently we sold 699950 tokens (the price is 10% discount)
555           //   2. buyer buys 1000 tokens
556           //   3. the price of all 1000 tokens would be with 10% discount!!!
557           uint newTokens = (msg.value * getMntTokensPerEth(icoTokensSold)) / (1 ether / 1 wei);
558 
559           issueTokensInternal(_buyer,newTokens);
560 
561           // update 'buyers' map
562           // (only when buying from ETH)
563           TokenBuyer memory b = buyers[msg.sender];
564           b.weiSent = safeAdd(b.weiSent, msg.value);
565           b.tokensGot = safeAdd(b.tokensGot, newTokens);
566           buyers[msg.sender] = b;
567      }
568 
569      /// @dev This is called by other currency processors to issue new tokens 
570      function issueTokensFromOtherCurrency(address _to, uint _wei_count) onlyInState(State.ICORunning) public onlyOtherCurrenciesChecker {
571           require(_wei_count!=0);
572 
573           uint newTokens = (_wei_count * getMntTokensPerEth(icoTokensSold)) / (1 ether / 1 wei);
574           issueTokensInternal(_to,newTokens);
575      }
576 
577      /// @dev This can be called to manually issue new tokens 
578      /// from the bonus reward
579      function issueTokensExternal(address _to, uint _tokens) public onlyInState(State.ICOFinished) onlyTokenManager {
580           // can not issue more than BONUS_REWARD
581           require((issuedExternallyTokens + _tokens)<=BONUS_REWARD);
582 
583           mntToken.issueTokens(_to,_tokens);
584 
585           issuedExternallyTokens = issuedExternallyTokens + _tokens;
586      }
587 
588      function issueTokensInternal(address _to, uint _tokens) internal {
589           require((icoTokensSold + _tokens)<=ICO_TOKEN_SUPPLY_LIMIT);
590 
591           mntToken.issueTokens(_to,_tokens);
592 
593           icoTokensSold+=_tokens;
594 
595           LogBuy(_to,_tokens);
596      }
597 
598      function burnTokens(address _from, uint _tokens) public onlyInState(State.ICOFinished) onlyTokenManager {
599           mntToken.burnTokens(_from,_tokens);
600 
601           LogBurn(_from,_tokens);
602      }
603 
604      // anyone can call this and get his money back
605      function getMyRefund() public onlyInState(State.Refunding) {
606           address sender = msg.sender;
607 
608           require(0!=buyers[sender].weiSent);
609           require(0!=buyers[sender].tokensGot);
610 
611           // 1 - send money back
612           sender.transfer(buyers[sender].weiSent);
613 
614           // 2 - burn tokens
615           mntToken.burnTokens(sender,buyers[sender].tokensGot);
616      }
617 
618      // Default fallback function
619      function() payable {
620           // buyTokens -> issueTokensInternal
621           buyTokens(msg.sender);
622      }
623 }