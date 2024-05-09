1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     uint constant DAY_IN_SECONDS = 86400;
10     uint constant BASE = 1000000000000000000;
11     uint constant preIcoPrice = 3000;
12     uint constant icoPrice = 1500;
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
38     function divToMul(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
39         return div(mul(number, numerator), denominator);
40     }
41 
42     function mulToDiv(uint256 number, uint256 numerator, uint256 denominator) internal returns (uint256) {
43         return mul(div(number, numerator), denominator);
44     }
45 
46 
47     // ICO volume bonus calculation
48     function volumeBonus(uint256 etherValue) internal returns (uint256) {
49         if(etherValue >= 10000000000000000000000) return 55;  // +55% tokens
50         if(etherValue >=  5000000000000000000000) return 50;  // +50% tokens
51         if(etherValue >=  1000000000000000000000) return 45;  // +45% tokens
52         if(etherValue >=   200000000000000000000) return 40;  // +40% tokens
53         if(etherValue >=   100000000000000000000) return 35;  // +35% tokens
54         if(etherValue >=    50000000000000000000) return 30; // +30% tokens
55         if(etherValue >=    30000000000000000000) return 25;  // +25% tokens
56         if(etherValue >=    20000000000000000000) return 20;  // +20% tokens
57         if(etherValue >=    10000000000000000000) return 15;  // +15% tokens
58         if(etherValue >=     5000000000000000000) return 10;  // +10% tokens
59         if(etherValue >=     1000000000000000000) return 5;   // +5% tokens
60 
61         return 0;
62     }
63 
64     // date bonus calculation
65     function dateBonus(uint startIco, uint currentType, uint datetime) internal returns (uint256) {
66         if(currentType == 2){
67             // day from ICO start
68             uint daysFromStart = (datetime - startIco) / DAY_IN_SECONDS + 1;
69 
70             if(daysFromStart == 1)  return 30; // +30% tokens
71             if(daysFromStart == 2)  return 29; // +29% tokens
72             if(daysFromStart == 3)  return 28; // +28% tokens
73             if(daysFromStart == 4)  return 27; // +27% tokens
74             if(daysFromStart == 5)  return 26; // +26% tokens
75             if(daysFromStart == 6)  return 25; // +25% tokens
76             if(daysFromStart == 7)  return 24; // +24% tokens
77             if(daysFromStart == 8)  return 23; // +23% tokens
78             if(daysFromStart == 9)  return 22; // +22% tokens
79             if(daysFromStart == 10) return 21; // +21% tokens
80             if(daysFromStart == 11) return 20; // +20% tokens
81             if(daysFromStart == 12) return 19; // +19% tokens
82             if(daysFromStart == 13) return 18; // +18% tokens
83             if(daysFromStart == 14) return 17; // +17% tokens
84             if(daysFromStart == 15) return 16; // +16% tokens
85             if(daysFromStart == 16) return 15; // +15% tokens
86             if(daysFromStart == 17) return 14; // +14% tokens
87             if(daysFromStart == 18) return 13; // +13% tokens
88             if(daysFromStart == 19) return 12; // +12% tokens
89             if(daysFromStart == 20) return 11; // +11% tokens
90             if(daysFromStart == 21) return 10; // +10% tokens
91             if(daysFromStart == 22) return 9;  // +9% tokens
92             if(daysFromStart == 23) return 8;  // +8% tokens
93             if(daysFromStart == 24) return 7;  // +7% tokens
94             if(daysFromStart == 25) return 6;  // +6% tokens
95             if(daysFromStart == 26) return 5;  // +5% tokens
96             if(daysFromStart == 27) return 4;  // +4% tokens
97             if(daysFromStart == 28) return 3;  // +3% tokens
98             if(daysFromStart == 29) return 2;  // +2% tokens
99             if(daysFromStart == 30) return 1;  // +1% tokens
100             if(daysFromStart == 31) return 1;  // +1% tokens
101             if(daysFromStart == 32) return 1;  // +1% tokens
102         }
103         if(currentType == 1){
104             /// day from PreSale start
105             uint daysFromPresaleStart = (datetime - startIco) / DAY_IN_SECONDS + 1;
106 
107             if(daysFromPresaleStart == 1)  return 54;  // +54% tokens
108             if(daysFromPresaleStart == 2)  return 51;  // +51% tokens
109             if(daysFromPresaleStart == 3)  return 48;  // +48% tokens
110             if(daysFromPresaleStart == 4)  return 45;  // +45% tokens
111             if(daysFromPresaleStart == 5)  return 42;  // +42% tokens
112             if(daysFromPresaleStart == 6)  return 39;  // +39% tokens
113             if(daysFromPresaleStart == 7)  return 36;  // +36% tokens
114             if(daysFromPresaleStart == 8)  return 33;  // +33% tokens
115             if(daysFromPresaleStart == 9)  return 30;  // +30% tokens
116             if(daysFromPresaleStart == 10) return 27;  // +27% tokens
117             if(daysFromPresaleStart == 11) return 24;  // +24% tokens
118             if(daysFromPresaleStart == 12) return 21;  // +21% tokens
119             if(daysFromPresaleStart == 13) return 18;  // +18% tokens
120             if(daysFromPresaleStart == 14) return 15;  // +15% tokens
121             if(daysFromPresaleStart == 15) return 12;  // +12% tokens
122             if(daysFromPresaleStart == 16) return 9;   // +9% tokens
123             if(daysFromPresaleStart == 17) return 6;   // +6% tokens
124             if(daysFromPresaleStart == 18) return 4;   // +4% tokens
125             if(daysFromPresaleStart == 19) return 0;   // +0% tokens
126         }
127 
128         // no discount
129         return 0;
130     }
131 }
132 
133 
134 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
135 /// @title Abstract token contract - Functions to be implemented by token contracts.
136 
137 contract AbstractToken {
138     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
139     function totalSupply() constant returns (uint256) {}
140     function balanceOf(address owner) constant returns (uint256 balance);
141     function transfer(address to, uint256 value) returns (bool success);
142     function transferFrom(address from, address to, uint256 value) returns (bool success);
143     function approve(address spender, uint256 value) returns (bool success);
144     function allowance(address owner, address spender) constant returns (uint256 remaining);
145 
146     event Transfer(address indexed from, address indexed to, uint256 value);
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148     event Issuance(address indexed to, uint256 value);
149 }
150 
151 contract StandardToken is AbstractToken {
152     /*
153      *  Data structures
154      */
155     mapping (address => uint256) balances;
156     mapping (address => bool) ownerAppended;
157     mapping (address => mapping (address => uint256)) allowed;
158     uint256 public totalSupply;
159     address[] public owners;
160 
161     /*
162      *  Read and write storage functions
163      */
164     /// @dev Transfers sender's tokens to a given address. Returns success.
165     /// @param _to Address of token receiver.
166     /// @param _value Number of tokens to transfer.
167     function transfer(address _to, uint256 _value) returns (bool success) {
168         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
169             balances[msg.sender] -= _value;
170             balances[_to] += _value;
171             if(!ownerAppended[_to]) {
172                 ownerAppended[_to] = true;
173                 owners.push(_to);
174             }
175             Transfer(msg.sender, _to, _value);
176             return true;
177         }
178         else {
179             return false;
180         }
181     }
182 
183     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
184     /// @param _from Address from where tokens are withdrawn.
185     /// @param _to Address to where tokens are sent.
186     /// @param _value Number of tokens to transfer.
187     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
188         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
189             balances[_to] += _value;
190             balances[_from] -= _value;
191             allowed[_from][msg.sender] -= _value;
192             if(!ownerAppended[_to]) {
193                 ownerAppended[_to] = true;
194                 owners.push(_to);
195             }
196             Transfer(_from, _to, _value);
197             return true;
198         }
199         else {
200             return false;
201         }
202     }
203 
204     /// @dev Returns number of tokens owned by given address.
205     /// @param _owner Address of token owner.
206     function balanceOf(address _owner) constant returns (uint256 balance) {
207         return balances[_owner];
208     }
209 
210     /// @dev Sets approved amount of tokens for spender. Returns success.
211     /// @param _spender Address of allowed account.
212     /// @param _value Number of approved tokens.
213     function approve(address _spender, uint256 _value) returns (bool success) {
214         allowed[msg.sender][_spender] = _value;
215         Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     /*
220      * Read storage functions
221      */
222     /// @dev Returns number of allowed tokens for given address.
223     /// @param _owner Address of token owner.
224     /// @param _spender Address of token spender.
225     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
226         return allowed[_owner][_spender];
227     }
228 
229 }
230 
231 
232 contract VINNDTokenContract is StandardToken, SafeMath {
233     /*
234      * Token meta data
235      */
236     string public constant name = "VINND";
237     string public constant symbol = "VIN";
238     uint public constant decimals = 18;
239 
240     // tottal supply
241 
242     address public icoContract = 0x0;
243     /*
244      * Modifiers
245      */
246 
247     modifier onlyIcoContract() {
248         // only ICO contract is allowed to proceed
249         require(msg.sender == icoContract);
250         _;
251     }
252 
253     /*
254      * Contract functions
255      */
256 
257     /// @dev Contract is needed in icoContract address
258     /// @param _icoContract Address of account which will be mint tokens
259     function VINNDTokenContract(address _icoContract) payable{
260         assert(_icoContract != 0x0);
261         icoContract = _icoContract;
262     }
263 
264     /// @dev Burns tokens from address. It's can be applied by account with address this.icoContract
265     /// @param _from Address of account, from which will be burned tokens
266     /// @param _value Amount of tokens, that will be burned
267     function burnTokens(address _from, uint _value) onlyIcoContract {
268         assert(_from != 0x0);
269         require(_value > 0);
270 
271         balances[_from] = sub(balances[_from], _value);
272     }
273 
274     /// @dev Adds tokens to address. It's can be applied by account with address this.icoContract
275     /// @param _to Address of account to which the tokens will pass
276     /// @param _value Amount of tokens
277     function emitTokens(address _to, uint _value) onlyIcoContract {
278         assert(_to != 0x0);
279         require(_value > 0);
280 
281         balances[_to] = add(balances[_to], _value);
282 
283         if(!ownerAppended[_to]) {
284             ownerAppended[_to] = true;
285             owners.push(_to);
286         }
287 
288     }
289 
290     function getOwner(uint index) constant returns (address, uint256) {
291         return (owners[index], balances[owners[index]]);
292     }
293 
294     function getOwnerCount() constant returns (uint) {
295         return owners.length;
296     }
297 
298 }
299 
300 
301 contract VINContract is SafeMath {
302     /*
303      * ICO meta data
304      */
305     VINNDTokenContract public VINToken;
306 
307     enum Stage{
308     Pause,
309     Init,
310     Running,
311     Stopped
312     }
313 
314     enum Type{
315     PRESALE,
316     ICO
317     }
318 
319     // Initializing current steps
320     Stage public currentStage = Stage.Pause;
321     Type public currentType = Type.PRESALE;
322 
323     // Setting constant dates UTC
324 
325     // 11.12.2017 00:00:00
326     uint public startPresaleDate = 1512950400;
327     // 29.12.2017 23:59:59
328     uint public endPresaleDate = 1514591999;
329     // 18.01.2018 00:00:00
330     uint public startICODate = 1516233600;
331     // 18.02.2018 23:59:59
332     uint public endICODate = 1518998399;
333 
334     // Address of manager
335     address public icoOwner;
336 
337     // Addresses of founders and bountyOwner
338     address public founder;
339     address public bountyOwner;
340 
341     // 888.888.888 VIN all tokens
342     uint public constant totalCap   = 888888888000000000000000000;
343     // 534.444.444 ico cap
344     uint public constant ICOCap     = 534444444000000000000000000;
345     //  28.888.888 presale cap
346     uint public constant presaleCap =  28888888000000000000000000;
347 
348     //  14.444.444 VIN is total bounty tokens
349     uint public constant totalBountyTokens = 14444444000000000000000000;
350 
351     // 1 ETH = 3000 VIN
352     uint public constant PRICE = 3000;
353     // 1 ETH = 1500 VIN
354     uint public constant ICOPRICE = 1500;
355 
356     // 2018.02.20 00:00 UTC
357     // founders' reward time
358     uint public foundersRewardTime = 1519084800;
359 
360     // Amount of sold tokens on ICO
361     uint public totalSoldOnICO = 0;
362     // Amount of issued tokens on pre-ICO
363     uint public totalSoldOnPresale = 0;
364 
365 
366     // ? Tokens already sent Founder
367     bool public sentTokensToFounders = false;
368 
369     // Boolean set founder
370     bool public setFounder = false;
371     bool public setBounty = false;
372 
373     uint public totalEther = 0;
374 
375     /*
376      * Modifiers
377      */
378 
379     modifier whenInitialized() {
380         // only when contract is initialized
381         require(currentStage >= Stage.Init);
382         _;
383     }
384 
385     modifier onlyManager() {
386         // only ICO manager can do this action
387         require(msg.sender == icoOwner);
388         _;
389     }
390 
391     modifier onStageRunning() {
392         // Checks, if ICO is running and has not been stopped
393         require(currentStage == Stage.Running);
394         _;
395     }
396 
397     modifier onStageStopped() {
398         // Checks if ICO was stopped or deadline is reached
399         require(currentStage == Stage.Stopped);
400         _;
401     }
402 
403     modifier checkType() {
404         require(currentType == Type.ICO || currentType == Type.PRESALE);
405         _;
406     }
407 
408     modifier checkDateTime(){
409         if(currentType == Type.PRESALE){
410             require(startPresaleDate < now && now < endPresaleDate);
411         }else{
412             require(startICODate < now && now < endICODate);
413         }
414         _;
415     }
416 
417     /// @dev Constructor of ICO
418     function VINContract() payable{
419         VINToken = new VINNDTokenContract(this);
420         icoOwner = msg.sender;
421     }
422 
423     /// @dev Initialises addresses of founders, bountyOwner.
424     /// Initialises balances of tokens owner
425     /// @param _founder Address of founder
426     /// @param _bounty Address of bounty
427     function initialize(address _founder, address _bounty) onlyManager {
428         assert(currentStage != Stage.Init);
429         assert(_founder != 0x0);
430         assert(_bounty != 0x0);
431         require(!setFounder);
432         require(!setBounty);
433 
434         founder = _founder;
435         bountyOwner = _bounty;
436 
437         VINToken.emitTokens(_bounty, totalBountyTokens);
438 
439         setFounder = true;
440         setBounty = true;
441 
442         currentStage = Stage.Init;
443     }
444 
445     /// @dev Sets new type
446     /// @param _type Value of new type
447     function setType(Type _type) public onlyManager onStageStopped{
448         currentType = _type;
449     }
450 
451     /// @dev Sets new stage
452     /// @param _stage Value of new stage
453     function setStage(Stage _stage) public onlyManager{
454         currentStage = _stage;
455     }
456 
457 
458     /// @dev Sets new owner. Only manager can do it
459     /// @param _newicoOwner Address of new ICO manager
460     function setNewOwner(address _newicoOwner) onlyManager {
461         assert(_newicoOwner != 0x0);
462         icoOwner = _newicoOwner;
463     }
464 
465     /// @dev Buy quantity of tokens depending on the amount of sent ethers.
466     /// @param _buyer Address of account which will receive tokens
467     function buyTokens(address _buyer, uint datetime, uint _value) private {
468         assert(_buyer != 0x0);
469         require(_value > 0);
470 
471         uint dateBonusPercent = 0;
472         uint tokensToEmit = 0;
473 
474         //calculate date bonus and set emitTokenPrice
475         if(currentType == Type.PRESALE){
476             tokensToEmit = _value * PRICE;
477             dateBonusPercent = dateBonus(startPresaleDate, 1, datetime);
478         }
479         else{
480             tokensToEmit = _value * ICOPRICE;
481             dateBonusPercent = dateBonus(startICODate, 2, datetime);
482         }
483 
484         //calculate volume bonus
485         uint volumeBonusPercent = volumeBonus(_value);
486 
487         //total bonus tokens
488         uint totalBonusPercent = dateBonusPercent + volumeBonusPercent;
489 
490         if(totalBonusPercent > 0){
491             tokensToEmit =  tokensToEmit + divToMul(tokensToEmit, totalBonusPercent, 100);
492         }
493 
494         if(currentType == Type.PRESALE){
495             require(add(totalSoldOnPresale, tokensToEmit) <= presaleCap);
496             totalSoldOnPresale = add(totalSoldOnPresale, tokensToEmit);
497         }
498         else{
499             require(add(totalSoldOnICO, tokensToEmit) <= ICOCap);
500             totalSoldOnICO = add(totalSoldOnICO, tokensToEmit);
501         }
502 
503         //emit tokens to token holder
504         VINToken.emitTokens(_buyer, tokensToEmit);
505 
506         totalEther = add(totalEther, _value);
507     }
508 
509     /// @dev Fall back function ~50k-100k gas
510     function () payable onStageRunning checkType checkDateTime{
511         buyTokens(msg.sender, now, msg.value);
512     }
513 
514     /// @dev Burn tokens from accounts. Only manager can do it
515     /// @param _from Address of account
516     function burnTokens(address _from, uint _value) onlyManager{
517         VINToken.burnTokens(_from, _value);
518     }
519 
520 
521     /// @dev Send tokens to founders. Can be sent only after VINToken.rewardTime
522     function sendTokensToFounders() onlyManager whenInitialized {
523         require(!sentTokensToFounders && now >= foundersRewardTime);
524 
525         //Calculate total tokens sold on pre-ICO and ICO
526         uint tokensSold = add(totalSoldOnICO, totalSoldOnPresale);
527         uint totalTokenToSold = add(ICOCap, presaleCap);
528 
529         uint x = mul(mul(tokensSold, totalCap), 35);
530         uint y = mul(100, totalTokenToSold);
531         uint result = div(x, y);
532 
533         VINToken.emitTokens(founder, result);
534 
535         sentTokensToFounders = true;
536     }
537 
538     /// @dev Send tokens to other wallets
539     /// @param _buyer Address of account which will receive tokens
540     /// @param _datetime datetime of transaction
541     /// @param _ether ether value
542     function emitTokensToOtherWallet(address _buyer, uint _datetime, uint _ether) onlyManager checkType{
543         assert(_buyer != 0x0);
544         buyTokens(_buyer, _datetime, _ether * 10 ** 18);
545     }
546 }