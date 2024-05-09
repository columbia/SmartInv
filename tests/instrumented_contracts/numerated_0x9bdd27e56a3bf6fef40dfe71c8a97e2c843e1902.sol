1 pragma solidity ^0.4.4;
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
20 
21      function assert(bool assertion) internal {
22           if (!assertion) throw;
23      }
24 }
25 
26 // Standard token interface (ERC 20)
27 // https://github.com/ethereum/EIPs/issues/20
28 contract Token is SafeMath {
29      // Functions:
30      /// @return total amount of tokens
31      function totalSupply() constant returns (uint256 supply) {}
32 
33      /// @param _owner The address from which the balance will be retrieved
34      /// @return The balance
35      function balanceOf(address _owner) constant returns (uint256 balance) {}
36 
37      /// @notice send `_value` token to `_to` from `msg.sender`
38      /// @param _to The address of the recipient
39      /// @param _value The amount of token to be transferred
40      function transfer(address _to, uint256 _value) {}
41 
42      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
43      /// @param _from The address of the sender
44      /// @param _to The address of the recipient
45      /// @param _value The amount of token to be transferred
46      /// @return Whether the transfer was successful or not
47      function transferFrom(address _from, address _to, uint256 _value){}
48 
49      /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
50      /// @param _spender The address of the account able to transfer the tokens
51      /// @param _value The amount of wei to be approved for transfer
52      /// @return Whether the approval was successful or not
53      function approve(address _spender, uint256 _value) returns (bool success) {}
54 
55      /// @param _owner The address of the account owning tokens
56      /// @param _spender The address of the account able to transfer the tokens
57      /// @return Amount of remaining tokens allowed to spent
58      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
59 
60      // Events:
61      event Transfer(address indexed _from, address indexed _to, uint256 _value);
62      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 contract StdToken is Token {
66      // Fields:
67      mapping(address => uint256) balances;
68      mapping (address => mapping (address => uint256)) allowed;
69      uint public totalSupply = 0;
70 
71      // Functions:
72      function transfer(address _to, uint256 _value) {
73           if((balances[msg.sender] < _value) || (balances[_to] + _value <= balances[_to])) {
74                throw;
75           }
76 
77           balances[msg.sender] -= _value;
78           balances[_to] += _value;
79           Transfer(msg.sender, _to, _value);
80      }
81 
82      function transferFrom(address _from, address _to, uint256 _value) {
83           if((balances[_from] < _value) || 
84                (allowed[_from][msg.sender] < _value) || 
85                (balances[_to] + _value <= balances[_to])) 
86           {
87                throw;
88           }
89 
90           balances[_to] += _value;
91           balances[_from] -= _value;
92           allowed[_from][msg.sender] -= _value;
93 
94           Transfer(_from, _to, _value);
95      }
96 
97      function balanceOf(address _owner) constant returns (uint256 balance) {
98           return balances[_owner];
99      }
100 
101      function approve(address _spender, uint256 _value) returns (bool success) {
102           allowed[msg.sender][_spender] = _value;
103           Approval(msg.sender, _spender, _value);
104 
105           return true;
106      }
107 
108      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
109           return allowed[_owner][_spender];
110      }
111 
112      modifier onlyPayloadSize(uint _size) {
113           if(msg.data.length < _size + 4) {
114                throw;
115           }
116           _;
117      }
118 }
119 
120 contract MNTP is StdToken {
121 /// Fields:
122      string public constant name = "Goldmint MNT Prelaunch Token";
123      string public constant symbol = "MNTP";
124      uint public constant decimals = 18;
125 
126      address public creator = 0x0;
127      address public icoContractAddress = 0x0;
128      bool public lockTransfers = false;
129 
130      // 10 mln
131      uint public constant TOTAL_TOKEN_SUPPLY = 10000000 * (1 ether / 1 wei);
132 
133 /// Modifiers:
134      modifier onlyCreator() { if(msg.sender != creator) throw; _; }
135      modifier byCreatorOrIcoContract() { if((msg.sender != creator) && (msg.sender != icoContractAddress)) throw; _; }
136 
137      function setCreator(address _creator) onlyCreator {
138           creator = _creator;
139      }
140 
141 /// Setters/Getters
142      function setIcoContractAddress(address _icoContractAddress) onlyCreator {
143           icoContractAddress = _icoContractAddress;
144      }
145 
146 /// Functions:
147      /// @dev Constructor
148      function MNTP() {
149           creator = msg.sender;
150 
151           // 10 mln tokens total
152           assert(TOTAL_TOKEN_SUPPLY == (10000000 * (1 ether / 1 wei)));
153      }
154 
155      /// @dev Override
156      function transfer(address _to, uint256 _value) public {
157           if(lockTransfers){
158                throw;
159           }
160           super.transfer(_to,_value);
161      }
162 
163      /// @dev Override
164      function transferFrom(address _from, address _to, uint256 _value)public{
165           if(lockTransfers){
166                throw;
167           }
168           super.transferFrom(_from,_to,_value);
169      }
170 
171      function issueTokens(address _who, uint _tokens) byCreatorOrIcoContract {
172           if((totalSupply + _tokens) > TOTAL_TOKEN_SUPPLY){
173                throw;
174           }
175 
176           balances[_who] += _tokens;
177           totalSupply += _tokens;
178      }
179 
180      function burnTokens(address _who, uint _tokens) byCreatorOrIcoContract {
181           balances[_who] = safeSub(balances[_who], _tokens);
182           totalSupply = safeSub(totalSupply, _tokens);
183      }
184 
185      function lockTransfer(bool _lock) byCreatorOrIcoContract {
186           lockTransfers = _lock;
187      }
188 
189      // Do not allow to send money directly to this contract
190      function() {
191           throw;
192      }
193 }
194 
195 // This contract will hold all tokens that were unsold during ICO
196 // (Goldmint should be able to withdraw them and sold only 1 year post-ICO)
197 contract GoldmintUnsold is SafeMath {
198      address public creator;
199      address public teamAccountAddress;
200      address public icoContractAddress;
201      uint64 public icoIsFinishedDate;
202 
203      MNTP public mntToken;
204 
205      function GoldmintUnsold(address _teamAccountAddress,address _mntTokenAddress){
206           creator = msg.sender;
207           teamAccountAddress = _teamAccountAddress;
208 
209           mntToken = MNTP(_mntTokenAddress);          
210      }
211 
212 /// Setters/Getters
213      function setIcoContractAddress(address _icoContractAddress) {
214           if(msg.sender!=creator){
215                throw;
216           }
217 
218           icoContractAddress = _icoContractAddress;
219      }
220 
221      function icoIsFinished() public {
222           // only by Goldmint contract 
223           if(msg.sender!=icoContractAddress){
224                throw;
225           }
226 
227           icoIsFinishedDate = uint64(now);
228      }
229 
230      // can be called by anyone...
231      function withdrawTokens() public {
232           // wait for 1 year!
233           uint64 oneYearPassed = icoIsFinishedDate + 365 days;  
234           if(uint(now) < oneYearPassed) throw;
235 
236           // transfer all tokens from this contract to the teamAccountAddress
237           uint total = mntToken.balanceOf(this);
238           mntToken.transfer(teamAccountAddress,total);
239      }
240 
241      // Default fallback function
242      function() payable {
243           throw;
244      }
245 }
246 
247 contract FoundersVesting is SafeMath {
248      address public creator;
249      address public teamAccountAddress;
250      uint64 public lastWithdrawTime;
251 
252      uint public withdrawsCount = 0;
253      uint public amountToSend = 0;
254 
255      MNTP public mntToken;
256 
257      function FoundersVesting(address _teamAccountAddress,address _mntTokenAddress){
258           creator = msg.sender;
259           teamAccountAddress = _teamAccountAddress;
260           lastWithdrawTime = uint64(now);
261 
262           mntToken = MNTP(_mntTokenAddress);          
263      }
264 
265      // can be called by anyone...
266      function withdrawTokens() public {
267           // 1 - wait for next month!
268           uint64 oneMonth = lastWithdrawTime + 30 days;  
269           if(uint(now) < oneMonth) throw;
270 
271           // 2 - calculate amount (only first time)
272           if(withdrawsCount==0){
273                amountToSend = mntToken.balanceOf(this) / 10;
274           }
275 
276           // 3 - send 1/10th
277           assert(amountToSend!=0);
278           mntToken.transfer(teamAccountAddress,amountToSend);
279 
280           withdrawsCount++;
281           lastWithdrawTime = uint64(now);
282      }
283 
284      // Default fallback function
285      function() payable {
286           throw;
287      }
288 }
289 
290 contract Goldmint is SafeMath {
291      address public creator = 0x0;
292      address public tokenManager = 0x0;
293      address public multisigAddress = 0x0;
294      address public otherCurrenciesChecker = 0x0;
295 
296      uint64 public icoStartedTime = 0;
297 
298      MNTP public mntToken; 
299      GoldmintUnsold public unsoldContract;
300 
301      // These can be changed before ICO start ($7USD/MNTP)
302      uint constant STD_PRICE_USD_PER_1000_TOKENS = 7000;
303      // coinmarketcap.com 14.08.2017
304      uint constant ETH_PRICE_IN_USD = 300;
305      // price changes from block to block
306      //uint public constant SINGLE_BLOCK_LEN = 700000;
307 
308      uint public constant SINGLE_BLOCK_LEN = 100;
309 
310 ///////     
311      // 1 000 000 tokens
312      uint public constant BONUS_REWARD = 1000000 * (1 ether/ 1 wei);
313      // 2 000 000 tokens
314      uint public constant FOUNDERS_REWARD = 2000000 * (1 ether / 1 wei);
315      // 7 000 000 we sell only this amount of tokens during the ICO
316      //uint public constant ICO_TOKEN_SUPPLY_LIMIT = 7000000 * (1 ether / 1 wei); 
317      
318      uint public constant ICO_TOKEN_SUPPLY_LIMIT = 250 * (1 ether / 1 wei); 
319 
320      // this is total number of tokens sold during ICO
321      uint public icoTokensSold = 0;
322      // this is total number of tokens sent to GoldmintUnsold contract after ICO is finished
323      uint public icoTokensUnsold = 0;
324 
325      // this is total number of tokens that were issued by a scripts
326      uint public issuedExternallyTokens = 0;
327 
328      bool public foundersRewardsMinted = false;
329      bool public restTokensMoved = false;
330 
331      // this is where FOUNDERS_REWARD will be allocated
332      address public foundersRewardsAccount = 0x0;
333 
334      enum State{
335           Init,
336 
337           ICORunning,
338           ICOPaused,
339          
340           ICOFinished
341      }
342      State public currentState = State.Init;
343 
344 /// Modifiers:
345      modifier onlyCreator() { if(msg.sender != creator) throw; _; }
346      modifier onlyTokenManager() { if(msg.sender != tokenManager) throw; _; }
347      modifier onlyOtherCurrenciesChecker() { if(msg.sender != otherCurrenciesChecker) throw; _; }
348 
349      modifier onlyInState(State state){ if(state != currentState) throw; _; }
350 
351 /// Events:
352      event LogStateSwitch(State newState);
353      event LogBuy(address indexed owner, uint value);
354      event LogBurn(address indexed owner, uint value);
355      
356 /// Functions:
357      /// @dev Constructor
358      function Goldmint(
359           address _multisigAddress,
360           address _tokenManager,
361           address _otherCurrenciesChecker,
362 
363           address _mntTokenAddress,
364           address _unsoldContractAddress,
365           address _foundersVestingAddress)
366      {
367           creator = msg.sender;
368 
369           multisigAddress = _multisigAddress;
370           tokenManager = _tokenManager;
371           otherCurrenciesChecker = _otherCurrenciesChecker; 
372 
373           mntToken = MNTP(_mntTokenAddress);
374           unsoldContract = GoldmintUnsold(_unsoldContractAddress);
375 
376           // slight rename
377           foundersRewardsAccount = _foundersVestingAddress;
378      }
379 
380      /// @dev This function is automatically called when ICO is started
381      /// WARNING: can be called multiple times!
382      function startICO() internal onlyCreator {
383           mintFoundersRewards(foundersRewardsAccount);
384 
385           mntToken.lockTransfer(true);
386 
387           if(icoStartedTime==0){
388                icoStartedTime = uint64(now);
389           }
390      }
391 
392      function pauseICO() internal onlyCreator {
393           mntToken.lockTransfer(false);
394      }
395 
396      /// @dev This function is automatically called when ICO is finished 
397      /// WARNING: can be called multiple times!
398      function finishICO() internal {
399           mntToken.lockTransfer(false);
400 
401           if(!restTokensMoved){
402                restTokensMoved = true;
403 
404                // move all unsold tokens to unsoldTokens contract
405                icoTokensUnsold = safeSub(ICO_TOKEN_SUPPLY_LIMIT,icoTokensSold);
406                if(icoTokensUnsold>0){
407                     mntToken.issueTokens(unsoldContract,icoTokensUnsold);
408                     unsoldContract.icoIsFinished();
409                }
410           }
411 
412           // send all ETH to multisig
413           if(this.balance>0){
414                if(!multisigAddress.send(this.balance)) throw;
415           }
416      }
417 
418      function mintFoundersRewards(address _whereToMint) internal onlyCreator {
419           if(!foundersRewardsMinted){
420                foundersRewardsMinted = true;
421                mntToken.issueTokens(_whereToMint,FOUNDERS_REWARD);
422           }
423      }
424 
425 /// Access methods:
426      function setTokenManager(address _new) public onlyTokenManager {
427           tokenManager = _new;
428      }
429 
430      function setOtherCurrenciesChecker(address _new) public onlyOtherCurrenciesChecker {
431           otherCurrenciesChecker = _new;
432      }
433 
434      function getTokensIcoSold() constant public returns (uint){
435           return icoTokensSold;
436      }
437 
438      function getTotalIcoTokens() constant public returns (uint){
439           return ICO_TOKEN_SUPPLY_LIMIT;
440      }
441 
442      function getMntTokenBalance(address _of) constant public returns (uint){
443           return mntToken.balanceOf(_of);
444      }
445 
446      function getCurrentPrice()constant public returns (uint){
447           return getMntTokensPerEth(icoTokensSold);
448      }
449 
450      function getBlockLength()constant public returns (uint){
451           return SINGLE_BLOCK_LEN;
452      }
453 
454 ////
455      function isIcoFinished() public returns(bool){
456           if(icoStartedTime==0){return false;}          
457 
458           // 1 - if time elapsed
459           uint64 oneMonth = icoStartedTime + 30 days;  
460           if(uint(now) > oneMonth){return true;}
461 
462           // 2 - if all tokens are sold
463           if(icoTokensSold>=ICO_TOKEN_SUPPLY_LIMIT){
464                return true;
465           }
466 
467           return false;
468      }
469 
470      function setState(State _nextState) public {
471           // only creator can change state
472           // but in case ICOFinished -> anyone can do that after all time is elapsed
473           bool icoShouldBeFinished = isIcoFinished();
474           if((msg.sender!=creator) && !(icoShouldBeFinished && State.ICOFinished==_nextState)){
475                throw;
476           }
477 
478           bool canSwitchState
479                =  (currentState == State.Init && _nextState == State.ICORunning)
480                || (currentState == State.ICORunning && _nextState == State.ICOPaused)
481                || (currentState == State.ICOPaused && _nextState == State.ICORunning)
482                || (currentState == State.ICORunning && _nextState == State.ICOFinished)
483                || (currentState == State.ICOFinished && _nextState == State.ICORunning);
484 
485           if(!canSwitchState) throw;
486 
487           currentState = _nextState;
488           LogStateSwitch(_nextState);
489 
490           if(currentState==State.ICORunning){
491                startICO();
492           }else if(currentState==State.ICOFinished){
493                finishICO();
494           }else if(currentState==State.ICOPaused){
495                pauseICO();
496           }
497      }
498 
499      function getMntTokensPerEth(uint tokensSold) public constant returns (uint){
500           // 10 buckets
501           uint priceIndex = (tokensSold / (1 ether/ 1 wei)) / SINGLE_BLOCK_LEN;
502           assert(priceIndex>=0 && (priceIndex<=9));
503           
504           uint8[10] memory discountPercents = [20,15,10,8,6,4,2,0,0,0];
505 
506           // We have to multiply by '1 ether' to avoid float truncations
507           // Example: ($7000 * 100) / 120 = $5833.33333
508           uint pricePer1000tokensUsd = 
509                ((STD_PRICE_USD_PER_1000_TOKENS * 100) * (1 ether / 1 wei)) / (100 + discountPercents[priceIndex]);
510 
511           // Correct: 300000 / 5833.33333333 = 51.42857142
512           // We have to multiply by '1 ether' to avoid float truncations
513           uint mntPerEth = (ETH_PRICE_IN_USD * 1000 * (1 ether / 1 wei) * (1 ether / 1 wei)) / pricePer1000tokensUsd;
514           return mntPerEth;
515      }
516 
517      function buyTokens(address _buyer) public payable onlyInState(State.ICORunning) {
518           if(msg.value == 0) throw;
519 
520           // The price is selected based on current sold tokens.
521           // Price can 'overlap'. For example:
522           //   1. if currently we sold 699950 tokens (the price is 10% discount)
523           //   2. buyer buys 1000 tokens
524           //   3. the price of all 1000 tokens would be with 10% discount!!!
525           uint newTokens = (msg.value * getMntTokensPerEth(icoTokensSold)) / (1 ether / 1 wei);
526 
527           issueTokensInternal(_buyer,newTokens);
528      }
529 
530      /// @dev This is called by other currency processors to issue new tokens 
531      function issueTokensFromOtherCurrency(address _to, uint _wei_count) onlyInState(State.ICORunning) public onlyOtherCurrenciesChecker {
532           if(_wei_count== 0) throw;
533           uint newTokens = (_wei_count * getMntTokensPerEth(icoTokensSold)) / (1 ether / 1 wei);
534           issueTokensInternal(_to,newTokens);
535      }
536 
537      /// @dev This can be called to manually issue new tokens 
538      /// from the bonus reward
539      function issueTokensExternal(address _to, uint _tokens) public onlyInState(State.ICOFinished) onlyTokenManager {
540           // can not issue more than BONUS_REWARD
541           if((issuedExternallyTokens + _tokens)>BONUS_REWARD){
542                throw;
543           }
544 
545           mntToken.issueTokens(_to,_tokens);
546 
547           issuedExternallyTokens = issuedExternallyTokens + _tokens;
548      }
549 
550      function issueTokensInternal(address _to, uint _tokens) internal {
551           if((icoTokensSold + _tokens)>ICO_TOKEN_SUPPLY_LIMIT){
552                throw;
553           }
554 
555           mntToken.issueTokens(_to,_tokens);
556 
557           icoTokensSold+=_tokens;
558 
559           LogBuy(_to,_tokens);
560      }
561 
562      function burnTokens(address _from, uint _tokens) public onlyInState(State.ICOFinished) onlyTokenManager {
563           mntToken.burnTokens(_from,_tokens);
564 
565           LogBurn(_from,_tokens);
566      }
567 
568      // Default fallback function
569      function() payable {
570           // buyTokens -> issueTokensInternal
571           buyTokens(msg.sender);
572      }
573 }