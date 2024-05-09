1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     uint constant DAY_IN_SECONDS = 86400;
10     uint constant BASE = 1000000000000000000;
11     uint constant preIcoPrice = 4101;
12     uint constant icoPrice = 2255;
13 
14     function mul(uint256 a, uint256 b) constant internal returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) constant internal returns (uint256) {
21         assert(b != 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) constant internal returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) constant internal returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 
38     function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
39         return div(mul(number, numerator), denominator);
40     }
41 
42     // presale volume bonus calculation 
43     function presaleVolumeBonus(uint256 price) internal returns (uint256) {
44 
45         // preCTX > ETH
46         uint256 val = div(price, preIcoPrice);
47 
48         if(val >= 100 * BASE) return add(price, price * 1/20); // 5%
49         if(val >= 50 * BASE) return add(price, price * 3/100); // 3%
50         if(val >= 20 * BASE) return add(price, price * 1/50);  // 2%
51 
52         return price;
53     }
54 
55     // ICO volume bonus calculation
56     function volumeBonus(uint256 etherValue) internal returns (uint256) {
57 
58         if(etherValue >= 1000000000000000000000) return 15;// +15% tokens
59         if(etherValue >=  500000000000000000000) return 10; // +10% tokens
60         if(etherValue >=  300000000000000000000) return 7;  // +7% tokens
61         if(etherValue >=  100000000000000000000) return 5;  // +5% tokens
62         if(etherValue >=   50000000000000000000) return 3;   // +3% tokens
63         if(etherValue >=   20000000000000000000) return 2;   // +2% tokens
64 
65         return 0;
66     }
67 
68     // ICO date bonus calculation
69     function dateBonus(uint startIco) internal returns (uint256) {
70 
71         // day from ICO start
72         uint daysFromStart = (now - startIco) / DAY_IN_SECONDS + 1;
73 
74         if(daysFromStart == 1) return 15; // +15% tokens
75         if(daysFromStart == 2) return 10; // +10% tokens
76         if(daysFromStart == 3) return 10; // +10% tokens
77         if(daysFromStart == 4) return 5;  // +5% tokens
78         if(daysFromStart == 5) return 5;  // +5% tokens
79         if(daysFromStart == 6) return 5;  // +5% tokens
80 
81         // no discount
82         return 0;
83     }
84 
85 }
86 
87 
88 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
89 /// @title Abstract token contract - Functions to be implemented by token contracts.
90 
91 contract AbstractToken {
92     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
93     function totalSupply() constant returns (uint256) {}
94     function balanceOf(address owner) constant returns (uint256 balance);
95     function transfer(address to, uint256 value) returns (bool success);
96     function transferFrom(address from, address to, uint256 value) returns (bool success);
97     function approve(address spender, uint256 value) returns (bool success);
98     function allowance(address owner, address spender) constant returns (uint256 remaining);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102     event Issuance(address indexed to, uint256 value);
103 }
104 
105 contract StandardToken is AbstractToken {
106     /*
107      *  Data structures
108      */
109     mapping (address => uint256) balances;
110     mapping (address => bool) ownerAppended;
111     mapping (address => mapping (address => uint256)) allowed;
112     uint256 public totalSupply;
113     address[] public owners;
114 
115     /*
116      *  Read and write storage functions
117      */
118     /// @dev Transfers sender's tokens to a given address. Returns success.
119     /// @param _to Address of token receiver.
120     /// @param _value Number of tokens to transfer.
121     function transfer(address _to, uint256 _value) returns (bool success) {
122         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
123             balances[msg.sender] -= _value;
124             balances[_to] += _value;
125             if(!ownerAppended[_to]) {
126                 ownerAppended[_to] = true;
127                 owners.push(_to);
128             }
129             Transfer(msg.sender, _to, _value);
130             return true;
131         }
132         else {
133             return false;
134         }
135     }
136 
137     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
138     /// @param _from Address from where tokens are withdrawn.
139     /// @param _to Address to where tokens are sent.
140     /// @param _value Number of tokens to transfer.
141     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
142         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
143             balances[_to] += _value;
144             balances[_from] -= _value;
145             allowed[_from][msg.sender] -= _value;
146             if(!ownerAppended[_to]) {
147                 ownerAppended[_to] = true;
148                 owners.push(_to);
149             }
150             Transfer(_from, _to, _value);
151             return true;
152         }
153         else {
154             return false;
155         }
156     }
157 
158     /// @dev Returns number of tokens owned by given address.
159     /// @param _owner Address of token owner.
160     function balanceOf(address _owner) constant returns (uint256 balance) {
161         return balances[_owner];
162     }
163 
164     /// @dev Sets approved amount of tokens for spender. Returns success.
165     /// @param _spender Address of allowed account.
166     /// @param _value Number of approved tokens.
167     function approve(address _spender, uint256 _value) returns (bool success) {
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /*
174      * Read storage functions
175      */
176     /// @dev Returns number of allowed tokens for given address.
177     /// @param _owner Address of token owner.
178     /// @param _spender Address of token spender.
179     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183 }
184 
185 
186 contract CarTaxiToken is StandardToken, SafeMath {
187     /*
188      * Token meta data
189      */
190     string public constant name = "CarTaxi";
191     string public constant symbol = "CTX";
192     uint public constant decimals = 18;
193 
194     // tottal supply
195 
196     address public icoContract = 0x0;
197     /*
198      * Modifiers
199      */
200 
201     modifier onlyIcoContract() {
202         // only ICO contract is allowed to proceed
203         require(msg.sender == icoContract);
204         _;
205     }
206 
207     /*
208      * Contract functions
209      */
210 
211     /// @dev Contract is needed in icoContract address
212     /// @param _icoContract Address of account which will be mint tokens
213     function CarTaxiToken(address _icoContract) {
214         assert(_icoContract != 0x0);
215         icoContract = _icoContract;
216     }
217 
218     /// @dev Burns tokens from address. It's can be applied by account with address this.icoContract
219     /// @param _from Address of account, from which will be burned tokens
220     /// @param _value Amount of tokens, that will be burned
221     function burnTokens(address _from, uint _value) onlyIcoContract {
222         assert(_from != 0x0);
223         require(_value > 0);
224 
225         balances[_from] = sub(balances[_from], _value);
226     }
227 
228     /// @dev Adds tokens to address. It's can be applied by account with address this.icoContract
229     /// @param _to Address of account to which the tokens will pass
230     /// @param _value Amount of tokens
231     function emitTokens(address _to, uint _value) onlyIcoContract {
232         assert(_to != 0x0);
233         require(_value > 0);
234 
235         balances[_to] = add(balances[_to], _value);
236 
237         if(!ownerAppended[_to]) {
238             ownerAppended[_to] = true;
239             owners.push(_to);
240         }
241 
242     }
243 
244     function getOwner(uint index) constant returns (address, uint256) {
245         return (owners[index], balances[owners[index]]);
246     }
247 
248     function getOwnerCount() constant returns (uint) {
249         return owners.length;
250     }
251 
252 }
253 
254 
255 contract CarTaxiIco is SafeMath {
256     /*
257      * ICO meta data
258      */
259     CarTaxiToken public cartaxiToken;
260     AbstractToken public preIcoToken;
261 
262     enum State{
263         Pause,
264         Init,
265         Running,
266         Stopped,
267         Migrated
268     }
269 
270     State public currentState = State.Pause;
271 
272     uint public startIcoDate = 0;
273 
274     // Address of account to which ethers will be tranfered in case of successful ICO
275     address public escrow;
276     // Address of manager
277     address public icoManager;
278     // Address of a account, that will transfer tokens from pre-ICO
279     address public tokenImporter = 0x0;
280     // Addresses of founders and bountyOwner
281     address public founder1;
282     address public founder2;
283     address public founder3;
284     address public founder4;
285     address public bountyOwner;
286 
287     // 487.500.000 CTX tokens
288     uint public constant supplyLimit = 487500000000000000000000000;
289 
290     //  12500000 CTX is token for bountyOwner
291     uint public constant bountyOwnersTokens = 12500000000000000000000000;
292 
293     // 1 ETH = 2255 CTX
294     uint public constant PRICE = 2255;
295 
296     // BASE = 10^18
297     uint constant BASE = 1000000000000000000;
298 
299     // 2018.02.04 07:00 UTC
300     // founders' reward time
301     uint public foundersRewardTime = 1517727600;
302 
303     // Amount of imported tokens from pre-ICO
304     uint public importedTokens = 0;
305     // Amount of sold tokens on ICO
306     uint public soldTokensOnIco = 0;
307     // Amount of issued tokens on pre-ICO = 3047.999951828165582669 * 4101
308     uint public constant soldTokensOnPreIco = 12499847802447308000000000;
309     // Tokens to founders can be sent only if sentTokensToFounders == false and time > foundersRewardTime
310     bool public sentTokensToFounders = false;
311     // Tokens to bounty owner can be sent only after ICO
312     bool public sentTokensToBountyOwner = false;
313 
314     uint public etherRaised = 0;
315 
316     /*
317      * Modifiers
318      */
319 
320     modifier whenInitialized() {
321         // only when contract is initialized
322         require(currentState >= State.Init);
323         _;
324     }
325 
326     modifier onlyManager() {
327         // only ICO manager can do this action
328         require(msg.sender == icoManager);
329         _;
330     }
331 
332     modifier onIcoRunning() {
333         // Checks, if ICO is running and has not been stopped
334         require(currentState == State.Running);
335         _;
336     }
337 
338     modifier onIcoStopped() {
339         // Checks if ICO was stopped or deadline is reached
340         require(currentState == State.Stopped);
341         _;
342     }
343 
344     modifier notMigrated() {
345         // Checks if base can be migrated
346         require(currentState != State.Migrated);
347         _;
348     }
349 
350     modifier onlyImporter() {
351         // only importer contract is allowed to proceed
352         require(msg.sender == tokenImporter);
353         _;
354     }
355 
356     /// @dev Constructor of ICO. Requires address of icoManager,
357     /// @param _icoManager Address of ICO manager
358     /// @param _preIcoToken Address of pre-ICO contract
359     function CarTaxiIco(address _icoManager, address _preIcoToken) {
360         assert(_preIcoToken != 0x0);
361         assert(_icoManager != 0x0);
362 
363         cartaxiToken = new CarTaxiToken(this);
364         icoManager = _icoManager;
365         preIcoToken = AbstractToken(_preIcoToken);
366     }
367 
368     /// @dev Initialises addresses of founders, tokens owner, escrow.
369     /// Initialises balances of tokens owner
370     /// @param _founder1 Address of founder 1
371     /// @param _founder2 Address of founder 2
372     /// @param _founder3 Address of founder 3
373     /// @param _founder4 Address of founder 4
374     /// @param _escrow Address of escrow
375     function init(address _founder1, address _founder2, address _founder3, address _founder4, address _escrow) onlyManager {
376         assert(currentState != State.Init);
377         assert(_founder1 != 0x0);
378         assert(_founder2 != 0x0);
379         assert(_founder3 != 0x0);
380         assert(_founder4 != 0x0);
381         assert(_escrow != 0x0);
382 
383         founder1 = _founder1;
384         founder2 = _founder2;
385         founder3 = _founder3;
386         founder4 = _founder4;
387         escrow = _escrow;
388 
389         currentState = State.Init;
390     }
391 
392     /// @dev Sets new state
393     /// @param _newState Value of new state
394     function setState(State _newState) public onlyManager
395     {
396         currentState = _newState;
397         if(currentState == State.Running) {
398             startIcoDate = now;
399         }
400     }
401 
402     /// @dev Sets new manager. Only manager can do it
403     /// @param _newIcoManager Address of new ICO manager
404     function setNewManager(address _newIcoManager) onlyManager {
405         assert(_newIcoManager != 0x0);
406         icoManager = _newIcoManager;
407     }
408 
409     /// @dev Sets bounty owner. Only manager can do it
410     /// @param _bountyOwner Address of Bounty owner
411     function setBountyOwner(address _bountyOwner) onlyManager {
412         assert(_bountyOwner != 0x0);
413         bountyOwner = _bountyOwner;
414     }
415 
416     // saves info if account's tokens were imported from pre-ICO
417     mapping (address => bool) private importedFromPreIco;
418 
419     /// @dev Imports account's tokens from pre-ICO. It can be done only by user, ICO manager or token importer
420     /// @param _account Address of account which tokens will be imported
421     function importTokens(address _account) {
422         // only token holder or manager can do migration
423         require(msg.sender == icoManager || msg.sender == _account);
424         require(!importedFromPreIco[_account]);
425 
426         uint preIcoBal = preIcoToken.balanceOf(_account);
427         uint preIcoBalance = presaleVolumeBonus(preIcoBal);
428 
429         if (preIcoBalance > 0) {
430             cartaxiToken.emitTokens(_account, preIcoBalance);
431             importedTokens = add(importedTokens, preIcoBalance);
432         }
433 
434         importedFromPreIco[_account] = true;
435     }
436 
437     /// @dev Buy quantity of tokens depending on the amount of sent ethers.
438     /// @param _buyer Address of account which will receive tokens
439     function buyTokens(address _buyer) private {
440         assert(_buyer != 0x0);
441         require(msg.value > 0);
442 
443         uint tokensToEmit = msg.value * PRICE;
444         //calculate date bonus
445         uint dateBonusPercent = dateBonus(startIcoDate);
446         //calculate volume bonus
447         uint volumeBonusPercent = volumeBonus(msg.value);
448         //total bonus tokens
449         uint totalBonusPercent = dateBonusPercent + volumeBonusPercent;
450 
451         if(totalBonusPercent > 0){
452             tokensToEmit =  tokensToEmit + mulByFraction(tokensToEmit, totalBonusPercent, 100);
453         }
454 
455         require(add(soldTokensOnIco, tokensToEmit) <= supplyLimit);
456 
457         soldTokensOnIco = add(soldTokensOnIco, tokensToEmit);
458 
459         //emit tokens to token holder
460         cartaxiToken.emitTokens(_buyer, tokensToEmit);
461 
462         etherRaised = add(etherRaised, msg.value);
463     }
464 
465     /// @dev Fall back function ~50k-100k gas
466     function () payable onIcoRunning {
467         buyTokens(msg.sender);
468     }
469 
470     /// @dev Burn tokens from accounts only in state "not migrated". Only manager can do it
471     /// @param _from Address of account
472     function burnTokens(address _from, uint _value) onlyManager notMigrated {
473         cartaxiToken.burnTokens(_from, _value);
474     }
475 
476     /// @dev Partial withdraw. Only manager can do it
477     function withdrawEther(uint _value) onlyManager {
478         require(_value > 0);
479         assert(_value <= this.balance);
480         // send 123 to get 1.23
481         escrow.transfer(_value * 10000000000000000); // 10^16
482     }
483 
484     /// @dev Ether withdraw. Only manager can do it
485     function withdrawAllEther() onlyManager {
486         if(this.balance > 0)
487         {
488             escrow.transfer(this.balance);
489         }
490     }
491 
492     ///@dev Send tokens to bountyOwner depending on crowdsale results. Can be send only after ICO.
493     function sendTokensToBountyOwner() onlyManager whenInitialized {
494         require(!sentTokensToBountyOwner);
495 
496         //Calculate total tokens sold on pre-ICO and ICO
497         uint tokensSold = add(soldTokensOnIco, soldTokensOnPreIco);
498 
499         //Calculate bounty tokens depending on total tokens sold
500         uint bountyTokens = mulByFraction(tokensSold, 25, 1000); // 2.5%
501 
502         cartaxiToken.emitTokens(bountyOwner, bountyTokens);
503 
504         sentTokensToBountyOwner = true;
505     }
506 
507     /// @dev Send tokens to founders. Can be sent only after cartaxiToken.rewardTime() (2018.02.04 0:00 UTC)
508     function sendTokensToFounders() onlyManager whenInitialized {
509         require(!sentTokensToFounders && now >= foundersRewardTime);
510 
511         //Calculate total tokens sold on pre-ICO and ICO
512         uint tokensSold = add(soldTokensOnIco, soldTokensOnPreIco);
513 
514         //Calculate founder reward depending on total tokens sold
515         uint totalRewardToFounders = mulByFraction(tokensSold, 3166, 10000); // 31.66%
516 
517         uint founderReward = mulByFraction(totalRewardToFounders, 25, 100); // 25% pie
518 
519         //send every founder 25% of total founder reward
520         cartaxiToken.emitTokens(founder1, founderReward);
521         cartaxiToken.emitTokens(founder2, founderReward);
522         cartaxiToken.emitTokens(founder3, founderReward);
523         cartaxiToken.emitTokens(founder4, founderReward);
524 
525         sentTokensToFounders = true;
526     }
527 }