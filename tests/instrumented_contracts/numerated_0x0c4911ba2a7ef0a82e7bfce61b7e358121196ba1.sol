1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8   function mul(uint256 a, uint256 b) constant internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) constant internal returns (uint256) {
15     assert(b != 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) constant internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) constant internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   
32   function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
33       return div(mul(number, numerator), denominator);
34   }
35 }
36 
37 
38 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
39 /// @title Abstract token contract - Functions to be implemented by token contracts.
40 
41 contract AbstractToken {
42     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
43     function totalSupply() constant returns (uint256) {}
44     function balanceOf(address owner) constant returns (uint256 balance);
45     function transfer(address to, uint256 value) returns (bool success);
46     function transferFrom(address from, address to, uint256 value) returns (bool success);
47     function approve(address spender, uint256 value) returns (bool success);
48     function allowance(address owner, address spender) constant returns (uint256 remaining);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52     event Issuance(address indexed to, uint256 value);
53 }
54 
55 contract StandardToken is AbstractToken {
56     /*
57      *  Data structures
58      */
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     uint256 public totalSupply;
62 
63     /*
64      *  Read and write storage functions
65      */
66     /// @dev Transfers sender's tokens to a given address. Returns success.
67     /// @param _to Address of token receiver.
68     /// @param _value Number of tokens to transfer.
69     function transfer(address _to, uint256 _value) returns (bool success) {
70         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71             balances[msg.sender] -= _value;
72             balances[_to] += _value;
73             Transfer(msg.sender, _to, _value);
74             return true;
75         }
76         else {
77             return false;
78         }
79     }
80 
81     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
82     /// @param _from Address from where tokens are withdrawn.
83     /// @param _to Address to where tokens are sent.
84     /// @param _value Number of tokens to transfer.
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87             balances[_to] += _value;
88             balances[_from] -= _value;
89             allowed[_from][msg.sender] -= _value;
90             Transfer(_from, _to, _value);
91             return true;
92         }
93         else {
94             return false;
95         }
96     }
97 
98     /// @dev Returns number of tokens owned by given address.
99     /// @param _owner Address of token owner.
100     function balanceOf(address _owner) constant returns (uint256 balance) {
101         return balances[_owner];
102     }
103 
104     /// @dev Sets approved amount of tokens for spender. Returns success.
105     /// @param _spender Address of allowed account.
106     /// @param _value Number of approved tokens.
107     function approve(address _spender, uint256 _value) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     /*
114      * Read storage functions
115      */
116     /// @dev Returns number of allowed tokens for given address.
117     /// @param _owner Address of token owner.
118     /// @param _spender Address of token spender.
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120       return allowed[_owner][_spender];
121     }
122 
123 }
124 
125 
126 contract ImmlaToken is StandardToken, SafeMath {
127     /*
128      * Token meta data
129      */
130     string public constant name = "IMMLA";
131     string public constant symbol = "IML";
132     uint public constant decimals = 18;
133     uint public constant supplyLimit = 550688955000000000000000000;
134     
135     address public icoContract = 0x0;
136     /*
137      * Modifiers
138      */
139     
140     modifier onlyIcoContract() {
141         // only ICO contract is allowed to proceed
142         require(msg.sender == icoContract);
143         _;
144     }
145     
146     /*
147      * Contract functions
148      */
149     
150     /// @dev Contract is needed in icoContract address
151     /// @param _icoContract Address of account which will be mint tokens
152     function ImmlaToken(address _icoContract) {
153         assert(_icoContract != 0x0);
154         icoContract = _icoContract;
155     }
156     
157     /// @dev Burns tokens from address. It's can be applied by account with address this.icoContract
158     /// @param _from Address of account, from which will be burned tokens
159     /// @param _value Amount of tokens, that will be burned
160     function burnTokens(address _from, uint _value) onlyIcoContract {
161         assert(_from != 0x0);
162         require(_value > 0);
163         
164         balances[_from] = sub(balances[_from], _value);
165     }
166     
167     /// @dev Adds tokens to address. It's can be applied by account with address this.icoContract
168     /// @param _to Address of account to which the tokens will pass
169     /// @param _value Amount of tokens
170     function emitTokens(address _to, uint _value) onlyIcoContract {
171         assert(_to != 0x0);
172         require(_value > 0);
173         
174         balances[_to] = add(balances[_to], _value);
175     }
176 }
177 
178 
179 contract ImmlaIco is SafeMath {
180     /*
181      * ICO meta data
182      */
183     ImmlaToken public immlaToken;
184     AbstractToken public preIcoToken;
185 
186     // Address of account to which ethers will be tranfered in case of successful ICO
187     address public escrow;
188     // Address of manager
189     address public icoManager;
190     // Address of a account, that will transfer tokens from pre-ICO
191     address public tokenImporter = 0x0;
192     // Addresses of founders, team and bountyOwner
193     address public founder1;
194     address public founder2;
195     address public founder3;
196     address public team;
197     address public bountyOwner;
198     
199     // 38548226,7 IML is reward for team
200     uint public constant teamsReward = 38548226701232220000000000;
201     //  9361712,2 IML is token for bountyOwner
202     uint public constant bountyOwnersTokens = 9361712198870680000000000;
203     
204     // BASE = 10^18
205     uint constant BASE = 1000000000000000000;
206     
207     // 2017.09.14 21:00 UTC or 2017.09.15 0:00 MSK
208     uint public constant defaultIcoStart = 1505422800;
209     // ICO start time
210     uint public icoStart = defaultIcoStart;
211     
212     // 2017.10.15 21:00 UTC or 2017.10.16 0:00 MSK
213     uint public constant defaultIcoDeadline = 1508101200;
214     // ICO end time
215     uint public  icoDeadline = defaultIcoDeadline;
216     
217     // 2018.03.14 21:00 UTC or 2018.03.15 0:00 MSK
218     uint public constant defaultFoundersRewardTime = 1521061200;
219     // founders' reward time
220     uint public foundersRewardTime = defaultFoundersRewardTime;
221     
222     // Min limit of tokens is 18 000 000 IML
223     uint public constant minIcoTokenLimit = 18000000 * BASE;
224     // Max limit of tokens is 434 477 177 IML
225     uint public constant maxIcoTokenLimit = 434477177 * BASE;
226     
227     // Amount of imported tokens from pre-ICO
228     uint public importedTokens = 0;
229     // Amount of sold tokens on ICO
230     uint public soldTokensOnIco = 0;
231     // Amount of issued tokens on pre-ICO = 13232941,7 IML
232     uint public constant soldTokensOnPreIco = 13232941687168431951684000;
233     
234     // There are 170053520 tokens in stage 1
235     // 1 ETH = 3640 IML
236     uint tokenPrice1 = 3640;
237     uint tokenSupply1 = 170053520 * BASE;
238     
239     // There are 103725856 tokens in stage 2
240     // 1 ETH = 3549 IML
241     uint tokenPrice2 = 3549;
242     uint tokenSupply2 = 103725856 * BASE;
243     
244     // There are 100319718 tokens in stage 3
245     // 1 ETH = 3458 IML
246     uint tokenPrice3 = 3458;
247     uint tokenSupply3 = 100319718 * BASE;
248     
249     // There are 60378083 tokens in stage 4
250     // 1 ETH = 3367 IML
251     uint tokenPrice4 = 3367;
252     uint tokenSupply4 = 60378083 * BASE;
253     
254     // Token's prices in stages in array
255     uint[] public tokenPrices;
256     // Token's remaining amounts in stages in array
257     uint[] public tokenSupplies;
258     
259     // Check if manager can be setted
260     bool public initialized = false;
261     // If flag migrated=false, token can be burned
262     bool public migrated = false;
263     // Tokens to founders can be sent only if sentTokensToFounders == false and time > foundersRewardTime
264     bool public sentTokensToFounders = false;
265     // If stopICO is called, then ICO 
266     bool public icoStoppedManually = false;
267     
268     // mapping of ether balances info
269     mapping (address => uint) public balances;
270     
271     /*
272      * Events
273      */
274     
275     event BuyTokens(address buyer, uint value, uint amount);
276     event WithdrawEther();
277     event StopIcoManually();
278     event SendTokensToFounders(uint founder1Reward, uint founder2Reward, uint founder3Reward);
279     event ReturnFundsFor(address account);
280     
281     /*
282      * Modifiers
283      */
284     
285     modifier whenInitialized() {
286         // only when contract is initialized
287         require(initialized);
288         _;
289     } 
290     
291     modifier onlyManager() {
292         // only ICO manager can do this action
293         require(msg.sender == icoManager);
294         _;
295     }
296     
297     modifier onIcoRunning() {
298         // Checks, if ICO is running and has not been stopped
299         require(!icoStoppedManually && now >= icoStart && now <= icoDeadline);
300         _;
301     }
302     
303     modifier onGoalAchievedOrDeadline() {
304         // Checks if amount of sold tokens >= min limit or deadline is reached
305         require(soldTokensOnIco >= minIcoTokenLimit || now > icoDeadline || icoStoppedManually);
306         _;
307     }
308     
309     modifier onIcoStopped() {
310         // Checks if ICO was stopped or deadline is reached
311         require(icoStoppedManually || now > icoDeadline);
312         _;
313     }
314     
315     modifier notMigrated() {
316         // Checks if base can be migrated
317         require(!migrated);
318         _;
319     }
320     
321     /// @dev Constructor of ICO. Requires address of icoManager,
322     /// address of preIcoToken, time of start ICO (or zero),
323     /// time of ICO deadline (or zero), founders' reward time (or zero)
324     /// @param _icoManager Address of ICO manager
325     /// @param _preIcoToken Address of pre-ICO contract
326     /// @param _icoStart Timestamp of ICO start (if equals 0, sets defaultIcoStart)
327     /// @param _icoDeadline Timestamp of ICO deadline (if equals 0, sets defaultIcoDeadline)
328     /// @param _foundersRewardTime Timestamp of founders rewarding time 
329     /// (if equals 0, sets defaultFoundersRewardTime)
330     function ImmlaIco(address _icoManager, address _preIcoToken, 
331         uint _icoStart, uint _icoDeadline, uint _foundersRewardTime) {
332         assert(_preIcoToken != 0x0);
333         assert(_icoManager != 0x0);
334         
335         immlaToken = new ImmlaToken(this);
336         icoManager = _icoManager;
337         preIcoToken = AbstractToken(_preIcoToken);
338         
339         if (_icoStart != 0) {
340             icoStart = _icoStart;
341         }
342         if (_icoDeadline != 0) {
343             icoDeadline = _icoDeadline;
344         }
345         if (_foundersRewardTime != 0) {
346             foundersRewardTime = _foundersRewardTime;
347         }
348         
349         // tokenPrices and tokenSupplies arrays initialisation
350         tokenPrices.push(tokenPrice1);
351         tokenPrices.push(tokenPrice2);
352         tokenPrices.push(tokenPrice3);
353         tokenPrices.push(tokenPrice4);
354         
355         tokenSupplies.push(tokenSupply1);
356         tokenSupplies.push(tokenSupply2);
357         tokenSupplies.push(tokenSupply3);
358         tokenSupplies.push(tokenSupply4);
359     }
360     
361     /// @dev Initialises addresses of team, founders, tokens owner, escrow.
362     /// Initialises balances of team and tokens owner
363     /// @param _founder1 Address of founder 1
364     /// @param _founder2 Address of founder 2
365     /// @param _founder3 Address of founder 3
366     /// @param _team Address of team
367     /// @param _bountyOwner Address of bounty owner
368     /// @param _escrow Address of escrow
369     function init(
370         address _founder1, address _founder2, address _founder3, 
371         address _team, address _bountyOwner, address _escrow) onlyManager {
372         assert(!initialized);
373         assert(_founder1 != 0x0);
374         assert(_founder2 != 0x0);
375         assert(_founder3 != 0x0);
376         assert(_team != 0x0);
377         assert(_bountyOwner != 0x0);
378         assert(_escrow != 0x0);
379         
380         founder1 = _founder1;
381         founder2 = _founder2;
382         founder3 = _founder3;
383         team = _team;
384         bountyOwner = _bountyOwner;
385         escrow = _escrow;
386         
387         immlaToken.emitTokens(team, teamsReward);
388         immlaToken.emitTokens(bountyOwner, bountyOwnersTokens);
389         
390         initialized = true;
391     }
392     
393     /// @dev Sets new manager. Only manager can do it
394     /// @param _newIcoManager Address of new ICO manager
395     function setNewManager(address _newIcoManager) onlyManager {
396         assert(_newIcoManager != 0x0);
397         
398         icoManager = _newIcoManager;
399     }
400     
401     /// @dev Sets new token importer. Only manager can do it
402     /// @param _newTokenImporter Address of token importer
403     function setNewTokenImporter(address _newTokenImporter) onlyManager {
404         tokenImporter = _newTokenImporter;
405     } 
406     
407     // saves info if account's tokens were imported from pre-ICO
408     mapping (address => bool) private importedFromPreIco;
409     /// @dev Imports account's tokens from pre-ICO. It can be done only by user, ICO manager or token importer
410     /// @param _account Address of account which tokens will be imported
411     function importTokens(address _account) {
412         // only tokens holder or manager or tokenImporter can do migration
413         require(msg.sender == tokenImporter || msg.sender == icoManager || msg.sender == _account);
414         require(!importedFromPreIco[_account]);
415         
416         uint preIcoBalance = preIcoToken.balanceOf(_account);
417         if (preIcoBalance > 0) {
418             immlaToken.emitTokens(_account, preIcoBalance);
419             importedTokens = add(importedTokens, preIcoBalance);
420         }
421         
422         importedFromPreIco[_account] = true;
423     }
424     
425     /// @dev Stops ICO manually. Only manager can do it
426     function stopIco() onlyManager /* onGoalAchievedOrDeadline */ {
427         icoStoppedManually = true;
428         StopIcoManually();
429     }
430     
431     /// @dev If ICO is successful, sends funds to escrow (Only manager can do it). If ICO is failed, sends funds to caller (Anyone can do it)
432     function withdrawEther() onGoalAchievedOrDeadline {
433         if (soldTokensOnIco >= minIcoTokenLimit) {
434             assert(initialized);
435             assert(this.balance > 0);
436             assert(msg.sender == icoManager);
437             
438             escrow.transfer(this.balance);
439             WithdrawEther();
440         } 
441         else {
442             returnFundsFor(msg.sender);
443         }
444     }
445     
446     /// @dev Returns funds to funder if ICO is unsuccessful. Dont removes IMMLA balance. Can be called only by manager or contract
447     /// @param _account Address of funder
448     function returnFundsFor(address _account) onGoalAchievedOrDeadline {
449         assert(msg.sender == address(this) || msg.sender == icoManager || msg.sender == _account);
450         assert(soldTokensOnIco < minIcoTokenLimit);
451         assert(balances[_account] > 0);
452         
453         _account.transfer(balances[_account]);
454         balances[_account] = 0;
455         
456         ReturnFundsFor(_account);
457     }
458     
459     /// @dev count tokens that can be sold with amount of money. Can be called only by contract
460     /// @param _weis Amount of weis
461     function countTokens(uint _weis) private returns(uint) { 
462         uint result = 0;
463         uint stage;
464         for (stage = 0; stage < 4; stage++) {
465             if (_weis == 0) {
466                 break;
467             }
468             if (tokenSupplies[stage] == 0) {
469                 continue;
470             }
471             uint maxTokenAmount = tokenPrices[stage] * _weis;
472             if (maxTokenAmount <= tokenSupplies[stage]) {
473                 result = add(result, maxTokenAmount);
474                 break;
475             }
476             result = add(result, tokenSupplies[stage]);
477             _weis = sub(_weis, div(tokenSupplies[stage], tokenPrices[stage]));
478         }
479         
480         if (stage == 4) {
481             result = add(result, tokenPrices[3] * _weis);
482         }
483         
484         return result;
485     }
486     
487     /// @dev Invalidates _amount tokens. Can be called only by contract
488     /// @param _amount Amount of tokens
489     function removeTokens(uint _amount) private {
490         for (uint i = 0; i < 4; i++) {
491             if (_amount == 0) {
492                 break;
493             }
494             if (tokenSupplies[i] > _amount) {
495                 tokenSupplies[i] = sub(tokenSupplies[i], _amount);
496                 break;
497             }
498             _amount = sub(_amount, tokenSupplies[i]);
499             tokenSupplies[i] = 0;
500         }
501     }
502     
503     /// @dev Buys quantity of tokens for the amount of sent ethers.
504     /// @param _buyer Address of account which will receive tokens
505     function buyTokens(address _buyer) private {
506         assert(_buyer != 0x0);
507         require(msg.value > 0);
508         require(soldTokensOnIco < maxIcoTokenLimit);
509         
510         uint boughtTokens = countTokens(msg.value);
511         assert(add(soldTokensOnIco, boughtTokens) <= maxIcoTokenLimit);
512         
513         removeTokens(boughtTokens);
514         soldTokensOnIco = add(soldTokensOnIco, boughtTokens);
515         immlaToken.emitTokens(_buyer, boughtTokens);
516         
517         balances[_buyer] = add(balances[_buyer], msg.value);
518         
519         BuyTokens(_buyer, msg.value, boughtTokens);
520     }
521     
522     /// @dev Fall back function ~50k-100k gas
523     function () payable onIcoRunning {
524         buyTokens(msg.sender);
525     }
526     
527     /// @dev Burn tokens from accounts only in state "not migrated". Only manager can do it
528     /// @param _from Address of account 
529     function burnTokens(address _from, uint _value) onlyManager notMigrated {
530         immlaToken.burnTokens(_from, _value);
531     }
532     
533     /// @dev Set state "migrated". Only manager can do it 
534     function setStateMigrated() onlyManager {
535         migrated = true;
536     }
537     
538     /// @dev Send tokens to founders. Can be sent only after immlaToken.rewardTime() (2018.03.15 0:00 UTC)
539     /// Sends 43% * 10% of all tokens to founder 1
540     /// Sends 43% * 10% of all tokens to founder 2
541     /// Sends 14% * 10% of all tokens to founder 3
542     function sendTokensToFounders() onlyManager whenInitialized {
543         require(!sentTokensToFounders && now >= foundersRewardTime);
544         
545         // soldTokensOnPreIco + soldTokensOnIco is ~81.3% of tokens 
546         uint totalCountOfTokens = mulByFraction(add(soldTokensOnIco, soldTokensOnPreIco), 1000, 813);
547         uint totalRewardToFounders = mulByFraction(totalCountOfTokens, 1, 10);
548         
549         uint founder1Reward = mulByFraction(totalRewardToFounders, 43, 100);
550         uint founder2Reward = mulByFraction(totalRewardToFounders, 43, 100);
551         uint founder3Reward = mulByFraction(totalRewardToFounders, 14, 100);
552         immlaToken.emitTokens(founder1, founder1Reward);
553         immlaToken.emitTokens(founder2, founder2Reward);
554         immlaToken.emitTokens(founder3, founder3Reward);
555         SendTokensToFounders(founder1Reward, founder2Reward, founder3Reward);
556         sentTokensToFounders = true;
557     }
558 }