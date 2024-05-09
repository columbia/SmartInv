1 pragma solidity ^0.4.18;
2 
3 /**
4  * How addresses of non ERC20 coins were defined:
5  * address(web3.sha3(coin_symbol_in_upper_case))
6  * 
7  * Example for BTC:
8  * web3.sha3('BTC') = 0xe98e2830be1a7e4156d656a7505e65d08c67660dc618072422e9c78053c261e9
9  * address(0xe98e2830be1a7e4156d656a7505e65d08c67660dc618072422e9c78053c261e9) = 0x505e65d08c67660dc618072422e9c78053c261e9
10  */
11 contract CoinLib {
12     
13     // Bitcoin and forks:
14     address public constant btc = address(0xe98e2830be1a7e4156d656a7505e65d08c67660dc618072422e9c78053c261e9);
15     address public constant bch = address(0xc157673705e9a7d6253fb36c51e0b2c9193b9b560fd6d145bd19ecdf6b3a873b);
16     address public constant btg = address(0x4e5f418e667aa2b937135735d3deb218f913284dd429fa56a60a2a8c2d913f6c);
17     
18     // Ethereum and forks:
19     address public constant eth = address(0xaaaebeba3810b1e6b70781f14b2d72c1cb89c0b2b320c43bb67ff79f562f5ff4);
20     address public constant etc = address(0x49b019f3320b92b2244c14d064de7e7b09dbc4c649e8650e7aa17e5ce7253294);
21     
22     // Bitcoin relatives:
23     address public constant ltc = address(0xfdd18b7aa4e2107a72f3310e2403b9bd7ace4a9f01431002607b3b01430ce75d);
24     address public constant doge = address(0x9a3f52b1b31ae58da40209f38379e78c3a0756495a0f585d0b3c84a9e9718f9d);
25     
26     // Anons/privacy coins: 
27     address public constant dash = address(0x279c8d120dfdb1ac051dfcfe9d373ee1d16624187fd2ed07d8817b7f9da2f07b);
28     address public constant xmr = address(0x8f7631e03f6499d6370dbfd69bc9be2ac2a84e20aa74818087413a5c8e085688);
29     address public constant zec = address(0x85118a02446a6ea7372cee71b5fc8420a3f90277281c88f5c237f3edb46419a6);
30     address public constant bcn = address(0x333433c3d35b6491924a29fbd93a9852a3c64d3d5b9229c073a047045d57cbe4);
31     address public constant pivx = address(0xa8b003381bf1e14049ab83186dd79e07408b0884618bc260f4e76ccd730638c7);
32     
33     // Smart contracts:
34     address public constant ada = address(0x4e1e6d8aa1ff8f43f933718e113229b0ec6b091b699f7a8671bcbd606da36eea);
35     address public constant xem = address(0x5f83a7d8f46444571fbbd0ea2d2613ab294391cb1873401ac6090df731d949e5);
36     address public constant neo = address(0x6dc5790d7c4bfaaa2e4f8e2cd517bacd4a3831f85c0964e56f2743cbb847bc46);
37     address public constant eos = 0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0; // Address of ERC20 token.
38     
39     address[] internal oldSchool = [btc, ltc, eth, dash];
40     address[] internal btcForks = [btc, bch, btg];
41     address[] internal smart = [eth, ada, eos, xem];
42     address[] internal anons = [dash, xmr, zec, bcn];
43     
44     function getBtcForkCoins() public view returns (address[]) {
45         return btcForks;
46     }
47     
48     function getOldSchoolCoins() public view returns (address[]) {
49         return oldSchool;
50     }
51     
52     function getPrivacyCoins() public view returns (address[]) {
53         return anons;
54     }
55     
56     function getSmartCoins() public view returns (address[]) {
57         return smart;
58     }
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a * b;
69         assert(a == 0 || c / a == b);
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // assert(b > 0); // Solidity automatically throws when dividing by 0
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         assert(c >= a);
88         return c;
89     }
90 }
91 
92 contract SuperOwners {
93 
94     address public owner1;
95     address public pendingOwner1;
96     
97     address public owner2;
98     address public pendingOwner2;
99 
100     function SuperOwners(address _owner1, address _owner2) internal {
101         require(_owner1 != address(0));
102         owner1 = _owner1;
103         
104         require(_owner2 != address(0));
105         owner2 = _owner2;
106     }
107 
108     modifier onlySuperOwner1() {
109         require(msg.sender == owner1);
110         _;
111     }
112     
113     modifier onlySuperOwner2() {
114         require(msg.sender == owner2);
115         _;
116     }
117     
118     /** Any of the owners can execute this. */
119     modifier onlySuperOwner() {
120         require(isSuperOwner(msg.sender));
121         _;
122     }
123     
124     /** Is msg.sender any of the owners. */
125     function isSuperOwner(address _addr) public view returns (bool) {
126         return _addr == owner1 || _addr == owner2;
127     }
128 
129     /** 
130      * Safe transfer of ownership in 2 steps. Once called, a newOwner needs 
131      * to call claimOwnership() to prove ownership.
132      */
133     function transferOwnership1(address _newOwner1) onlySuperOwner1 public {
134         pendingOwner1 = _newOwner1;
135     }
136     
137     function transferOwnership2(address _newOwner2) onlySuperOwner2 public {
138         pendingOwner2 = _newOwner2;
139     }
140 
141     function claimOwnership1() public {
142         require(msg.sender == pendingOwner1);
143         owner1 = pendingOwner1;
144         pendingOwner1 = address(0);
145     }
146     
147     function claimOwnership2() public {
148         require(msg.sender == pendingOwner2);
149         owner2 = pendingOwner2;
150         pendingOwner2 = address(0);
151     }
152 }
153 
154 contract MultiOwnable is SuperOwners {
155 
156     mapping (address => bool) public ownerMap;
157     address[] public ownerHistory;
158 
159     event OwnerAddedEvent(address indexed _newOwner);
160     event OwnerRemovedEvent(address indexed _oldOwner);
161 
162     function MultiOwnable(address _owner1, address _owner2) 
163         SuperOwners(_owner1, _owner2) internal {}
164 
165     modifier onlyOwner() {
166         require(isOwner(msg.sender));
167         _;
168     }
169 
170     function isOwner(address owner) public view returns (bool) {
171         return isSuperOwner(owner) || ownerMap[owner];
172     }
173     
174     function ownerHistoryCount() public view returns (uint) {
175         return ownerHistory.length;
176     }
177 
178     // Add extra owner
179     function addOwner(address owner) onlySuperOwner public {
180         require(owner != address(0));
181         require(!ownerMap[owner]);
182         ownerMap[owner] = true;
183         ownerHistory.push(owner);
184         OwnerAddedEvent(owner);
185     }
186 
187     // Remove extra owner
188     function removeOwner(address owner) onlySuperOwner public {
189         require(ownerMap[owner]);
190         ownerMap[owner] = false;
191         OwnerRemovedEvent(owner);
192     }
193 }
194 
195 contract Pausable is MultiOwnable {
196 
197     bool public paused;
198 
199     modifier ifNotPaused {
200         require(!paused);
201         _;
202     }
203 
204     modifier ifPaused {
205         require(paused);
206         _;
207     }
208 
209     // Called by the owner on emergency, triggers paused state
210     function pause() external onlySuperOwner {
211         paused = true;
212     }
213 
214     // Called by the owner on end of emergency, returns to normal state
215     function resume() external onlySuperOwner ifPaused {
216         paused = false;
217     }
218 }
219 
220 contract ERC20 {
221 
222     uint256 public totalSupply;
223 
224     function balanceOf(address _owner) public view returns (uint256 balance);
225 
226     function transfer(address _to, uint256 _value) public returns (bool success);
227 
228     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
229 
230     function approve(address _spender, uint256 _value) public returns (bool success);
231 
232     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
233 
234     event Transfer(address indexed _from, address indexed _to, uint256 _value);
235     
236     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
237 }
238 
239 contract StandardToken is ERC20 {
240     
241     using SafeMath for uint;
242 
243     mapping(address => uint256) balances;
244     
245     mapping(address => mapping(address => uint256)) allowed;
246 
247     function balanceOf(address _owner) public view returns (uint256 balance) {
248         return balances[_owner];
249     }
250 
251     function transfer(address _to, uint256 _value) public returns (bool) {
252         require(_to != address(0));
253         require(_value > 0);
254         require(_value <= balances[msg.sender]);
255         
256         balances[msg.sender] = balances[msg.sender].sub(_value);
257         balances[_to] = balances[_to].add(_value);
258         Transfer(msg.sender, _to, _value);
259         return true;
260     }
261 
262     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
263     /// @param _from Address from where tokens are withdrawn.
264     /// @param _to Address to where tokens are sent.
265     /// @param _value Number of tokens to transfer.
266     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
267         require(_to != address(0));
268         require(_value > 0);
269         require(_value <= balances[_from]);
270         require(_value <= allowed[_from][msg.sender]);
271         
272         balances[_to] = balances[_to].add(_value);
273         balances[_from] = balances[_from].sub(_value);
274         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
275         Transfer(_from, _to, _value);
276         return true;
277     }
278 
279     /// @dev Sets approved amount of tokens for spender. Returns success.
280     /// @param _spender Address of allowed account.
281     /// @param _value Number of approved tokens.
282     function approve(address _spender, uint256 _value) public returns (bool) {
283         allowed[msg.sender][_spender] = _value;
284         Approval(msg.sender, _spender, _value);
285         return true;
286     }
287 
288     /// @dev Returns number of allowed tokens for given address.
289     /// @param _owner Address of token owner.
290     /// @param _spender Address of token spender.
291     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
292         return allowed[_owner][_spender];
293     }
294 }
295 
296 contract CommonToken is StandardToken, MultiOwnable {
297 
298     string public name;
299     string public symbol;
300     uint256 public totalSupply;
301     uint8 public decimals = 18;
302     string public version = 'v0.1';
303 
304     address public seller;     // The main account that holds all tokens at the beginning and during tokensale.
305 
306     uint256 public saleLimit;  // (e18) How many tokens can be sold in total through all tiers or tokensales.
307     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
308     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
309 
310     // Lock the transfer functions during tokensales to prevent price speculations.
311     bool public locked = true;
312     
313     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
314     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
315     event Burn(address indexed _burner, uint256 _value);
316     event Unlock();
317 
318     function CommonToken(
319         address _owner1,
320         address _owner2,
321         address _seller,
322         string _name,
323         string _symbol,
324         uint256 _totalSupplyNoDecimals,
325         uint256 _saleLimitNoDecimals
326     ) MultiOwnable(_owner1, _owner2) public {
327 
328         require(_seller != address(0));
329         require(_totalSupplyNoDecimals > 0);
330         require(_saleLimitNoDecimals > 0);
331 
332         seller = _seller;
333         name = _name;
334         symbol = _symbol;
335         totalSupply = _totalSupplyNoDecimals * 1e18;
336         saleLimit = _saleLimitNoDecimals * 1e18;
337         balances[seller] = totalSupply;
338 
339         Transfer(0x0, seller, totalSupply);
340     }
341     
342     modifier ifUnlocked(address _from, address _to) {
343         require(!locked || isOwner(_from) || isOwner(_to));
344         _;
345     }
346     
347     /** Can be called once by super owner. */
348     function unlock() onlySuperOwner public {
349         require(locked);
350         locked = false;
351         Unlock();
352     }
353 
354     function changeSeller(address newSeller) onlySuperOwner public returns (bool) {
355         require(newSeller != address(0));
356         require(seller != newSeller);
357 
358         address oldSeller = seller;
359         uint256 unsoldTokens = balances[oldSeller];
360         balances[oldSeller] = 0;
361         balances[newSeller] = balances[newSeller].add(unsoldTokens);
362         Transfer(oldSeller, newSeller, unsoldTokens);
363 
364         seller = newSeller;
365         ChangeSellerEvent(oldSeller, newSeller);
366         
367         return true;
368     }
369 
370     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
371         return sell(_to, _value * 1e18);
372     }
373 
374     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
375 
376         // Check that we are not out of limit and still can sell tokens:
377         require(tokensSold.add(_value) <= saleLimit);
378 
379         require(_to != address(0));
380         require(_value > 0);
381         require(_value <= balances[seller]);
382 
383         balances[seller] = balances[seller].sub(_value);
384         balances[_to] = balances[_to].add(_value);
385         Transfer(seller, _to, _value);
386 
387         totalSales++;
388         tokensSold = tokensSold.add(_value);
389         SellEvent(seller, _to, _value);
390 
391         return true;
392     }
393     
394     /**
395      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
396      */
397     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender, _to) public returns (bool) {
398         return super.transfer(_to, _value);
399     }
400 
401     /**
402      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
403      */
404     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from, _to) public returns (bool) {
405         return super.transferFrom(_from, _to, _value);
406     }
407 
408     function burn(uint256 _value) public returns (bool) {
409         require(_value > 0);
410         require(_value <= balances[msg.sender]);
411 
412         balances[msg.sender] = balances[msg.sender].sub(_value) ;
413         totalSupply = totalSupply.sub(_value);
414         Transfer(msg.sender, 0x0, _value);
415         Burn(msg.sender, _value);
416 
417         return true;
418     }
419 }
420 
421 contract RaceToken is CommonToken {
422     
423     function RaceToken() CommonToken(
424         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
425         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
426         0x2821e1486D604566842FF27F626aF133FddD5f89, // __SELLER__
427         'Coin Race',
428         'RACE',
429         100 * 1e6, // 100m tokens in total.
430         70 * 1e6   // 70m tokens for sale.
431     ) public {}
432 }
433 
434 library RaceCalc {
435     
436     using SafeMath for uint;
437     
438     // Calc a stake of a driver based on his current time.
439     // We use linear regression, so the more time passed since 
440     // the start of the race, the less stake of a final reward he will receive.
441     function calcStake(
442         uint _currentTime, // Example: 1513533600 - 2017-12-17 18:00:00 UTC
443         uint _finishTime   // Example: 1513537200 - 2017-12-17 19:00:00 UTC
444     ) public pure returns (uint) {
445         
446         require(_currentTime > 0);
447         require(_currentTime < _finishTime);
448         
449         return _finishTime.sub(_currentTime);
450     }
451     
452     // Calc gain of car at the finish of a race.
453     // Result can be negative.
454     // 100% is represented as 10^8 to be more precious.
455     function calcGainE8(
456         uint _startRateToUsdE8, // Example: 345
457         uint _finishRateToUsdE8 // Example: 456
458     ) public pure returns (int) {
459         
460         require(_startRateToUsdE8 > 0);
461         require(_finishRateToUsdE8 > 0);
462         
463         int diff = int(_finishRateToUsdE8) - int(_startRateToUsdE8);
464         return (diff * 1e8) / int(_startRateToUsdE8);
465     }
466     
467     function calcPrizeTokensE18(
468         uint totalTokens, 
469         uint winningStake, 
470         uint driverStake
471     ) public pure returns (uint) {
472         
473         if (totalTokens == 0) return 0;
474         if (winningStake == 0) return 0;
475         if (driverStake == 0) return 0;
476         if (winningStake == driverStake) return totalTokens;
477         
478         require(winningStake > driverStake);
479         uint share = driverStake.mul(1e8).div(winningStake);
480         return totalTokens.mul(share).div(1e8);
481     }
482 }
483 
484 /** 
485  * Here we implement all token methods that require msg.sender to be albe 
486  * to perform operations on behalf of GameWallet from other CoinRace contracts 
487  * like a particular contract of RaceGame.
488  */
489 contract CommonWallet is MultiOwnable {
490     
491     RaceToken public token;
492     
493     event ChangeTokenEvent(address indexed _oldAddress, address indexed _newAddress);
494     
495     function CommonWallet(address _owner1, address _owner2) 
496         MultiOwnable(_owner1, _owner2) public {}
497     
498     function setToken(address _token) public onlySuperOwner {
499         require(_token != 0);
500         require(_token != address(token));
501         
502         ChangeTokenEvent(token, _token);
503         token = RaceToken(_token);
504     }
505     
506     function transfer(address _to, uint256 _value) onlyOwner public returns (bool) {
507         return token.transfer(_to, _value);
508     }
509     
510     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
511         return token.transferFrom(_from, _to, _value);
512     }
513     
514     function approve(address _spender, uint256 _value) onlyOwner public returns (bool) {
515         return token.approve(_spender, _value);
516     }
517     
518     function burn(uint256 _value) onlySuperOwner public returns (bool) {
519         return token.burn(_value);
520     }
521     
522     /** Amount of tokens that players of CoinRace bet during the games and haven't claimed yet. */
523     function balance() public view returns (uint256) {
524         return token.balanceOf(this);
525     }
526     
527     function balanceOf(address _owner) public view returns (uint256) {
528         return token.balanceOf(_owner);
529     }
530     
531     function allowance(address _owner, address _spender) public view returns (uint256) {
532         return token.allowance(_owner, _spender);
533     }
534 }
535 
536 contract GameWallet is CommonWallet {
537     
538     function GameWallet() CommonWallet(
539         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
540         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7  // __OWNER2__
541     ) public {}
542 }
543 
544 library RaceLib {
545     
546     using SafeMath for uint;
547     
548     function makeBet(
549         Race storage _race, 
550         address _driver, 
551         address _car, 
552         uint _tokensE18
553     ) public {
554         require(!isFinished(_race));
555         
556         var bet = Bet({
557             driver: _driver,
558             car: _car,
559             tokens: _tokensE18,
560             time: now
561         });
562 
563         _race.betsByDriver[_driver].push(bet);
564         _race.betsByCar[_car].push(bet);
565             
566         if (_race.tokensByCarAndDriver[_car][_driver] == 0) {
567             _race.driverCountByCar[_car] = _race.driverCountByCar[_car] + 1;
568         }
569         
570         _race.tokensByCar[_car] = _race.tokensByCar[_car].add(_tokensE18);
571         _race.tokensByCarAndDriver[_car][_driver] = 
572             _race.tokensByCarAndDriver[_car][_driver].add(_tokensE18);
573         
574         uint stakeTime = bet.time;
575         if (bet.time < _race.leftGraceTime && _race.leftGraceTime > 0) stakeTime = _race.leftGraceTime;
576         if (bet.time > _race.rightGraceTime && _race.rightGraceTime > 0) stakeTime = _race.rightGraceTime;
577         uint stake = RaceCalc.calcStake(stakeTime, _race.finishTime);
578         _race.stakeByCar[_car] = _race.stakeByCar[_car].add(stake);
579         _race.stakeByCarAndDriver[_car][_driver] = 
580             _race.stakeByCarAndDriver[_car][_driver].add(stake);
581         
582         _race.totalTokens = _race.totalTokens.add(_tokensE18);
583     }
584     
585     function hasDriverJoined(
586         Race storage _race, 
587         address _driver
588     ) public view returns (bool) {
589         return betCountByDriver(_race, _driver) > 0;
590     }
591     
592     function betCountByDriver(
593         Race storage _race, 
594         address _driver
595     ) public view returns (uint) {
596         return _race.betsByDriver[_driver].length;
597     }
598     
599     function betCountByCar(
600         Race storage _race, 
601         address _car
602     ) public view returns (uint) {
603         return _race.betsByCar[_car].length;
604     }
605     
606     function startCar(
607         Race storage _race, 
608         address _car,
609         uint _rateToUsdE8
610     ) public {
611         require(_rateToUsdE8 > 0);
612         require(_race.carRates[_car].startRateToUsdE8 == 0);
613         _race.carRates[_car].startRateToUsdE8 = _rateToUsdE8;
614     }
615     
616     function finish(
617         Race storage _race
618     ) public {
619         require(!_race.finished);
620         require(now >= _race.finishTime);
621         _race.finished = true;
622     }
623     
624     function isFinished(
625         Race storage _race
626     ) public view returns (bool) {
627         return _race.finished;
628     }
629     
630     struct Race {
631         
632         uint id;
633         
634         uint leftGraceTime;
635         
636         uint rightGraceTime;
637         
638         uint startTime;
639         
640         uint finishTime;
641         
642         bool finished;
643         
644         uint finishedCarCount;
645         
646         // 0 - if race is not finished yet.
647         address firstCar;
648         
649         // Total amount of tokens tha thave been bet on all cars during the race: 
650         uint totalTokens;
651         
652         uint driverCount;
653         
654         // num of driver => driver's address.
655         mapping (uint => address) drivers;
656         
657         // car_address => total_drivers_that_made_bet_on_this_car
658         mapping (address => uint) driverCountByCar;
659         
660         // driver_address => bets by driver
661         mapping (address => Bet[]) betsByDriver;
662         
663         // car_address => bets on this car.
664         mapping (address => Bet[]) betsByCar;
665         
666         // car_address => total_tokens_bet_on_this_car
667         mapping (address => uint) tokensByCar;
668         
669         // car_address => driver_address => total_tokens_bet_on_this_car_by_this_driver
670         mapping (address => mapping (address => uint)) tokensByCarAndDriver;
671 
672         // car_address => stake_by_all_drivers
673         mapping (address => uint) stakeByCar;
674 
675         // car_address => driver_address => stake
676         mapping (address => mapping (address => uint)) stakeByCarAndDriver;
677 
678         // car_address => its rates to USD.
679         mapping (address => CarRates) carRates;
680 
681         // int because it can be negative value if finish rate is lower.
682         mapping (address => int) gainByCar;
683         
684         mapping (address => bool) isFinishedCar;
685         
686         // driver_address => amount of tokens (e18) that have been claimed by driver.
687         mapping (address => uint) tokensClaimedByDriver;
688     }
689     
690     struct Bet {
691         address driver;
692         address car;
693         uint tokens;
694         uint time;
695     }
696     
697     struct CarRates {
698         uint startRateToUsdE8;
699         uint finishRateToUsdE8;
700     }
701 }
702 
703 contract CommonRace is MultiOwnable {
704     
705     using SafeMath for uint;
706     using RaceLib for RaceLib.Race;
707     
708     GameWallet public wallet;
709     
710     // The name of the game.
711     string public name;
712     
713     address[] public cars;
714     
715     mapping (address => bool) public isKnownCar;
716     
717     RaceLib.Race[] public races;
718     
719     address[] public drivers;
720 
721     mapping (address => bool) public isKnownDriver;
722     
723     modifier ifWalletDefined() {
724         require(address(wallet) != address(0));
725         _;
726     }
727     
728     function CommonRace(
729         address _owner1,
730         address _owner2,
731         address[] _cars,
732         string _name
733     ) MultiOwnable(_owner1, _owner2) public {
734         require(_cars.length > 0);
735 
736         name = _name;
737         cars = _cars;
738         
739         for (uint16 i = 0; i < _cars.length; i++) {
740             isKnownCar[_cars[i]] = true;
741         }
742     }
743     
744     function getNow() public view returns (uint) {
745         return now;
746     }
747     
748     function raceCount() public view returns (uint) {
749         return races.length;
750     }
751     
752     function carCount() public view returns (uint) {
753         return cars.length;
754     }
755     
756     function driverCount() public view returns (uint) {
757         return drivers.length;
758     }
759     
760     function setWallet(address _newWallet) onlySuperOwner public {
761         require(wallet != _newWallet);
762         require(_newWallet != 0);
763         
764         GameWallet newWallet = GameWallet(_newWallet);
765         wallet = newWallet;
766     }
767 
768     function lastLapId() public view returns (uint) {
769         require(races.length > 0);
770         return races.length - 1;
771     }
772 
773     function nextLapId() public view returns (uint) {
774         return races.length;
775     }
776     
777     function getRace(uint _lapId) internal view returns (RaceLib.Race storage race) {
778         race = races[_lapId];
779         require(race.startTime > 0); // if startTime is > 0 then race is real.
780     }
781     
782     /**
783      * _durationSecs - A duration of race in seconds.
784      * 
785      * Structure of _carsAndRates:
786      *   N-th elem is a car addr.
787      *   (N+1)-th elem is car rate.
788      */
789     function startNewRace(
790         uint _newLapId, 
791         uint[] _carsAndRates,
792         uint _durationSecs,
793         uint _leftGraceSecs, // How many seconds from the start we should not apply penalty for stake of bet?
794         uint _rightGraceSecs // How many seconds before the finish we should not apply penalty for stake of bet?
795     ) onlyOwner public {
796         require(_newLapId == nextLapId());
797         require(_carsAndRates.length == (cars.length * 2));
798         require(_durationSecs > 0);
799         
800         if (_leftGraceSecs > 0) require(_leftGraceSecs <= _durationSecs);
801         if (_rightGraceSecs > 0) require(_rightGraceSecs <= _durationSecs);
802         
803         uint finishTime = now.add(_durationSecs);
804         
805         races.push(RaceLib.Race({
806             id: _newLapId,
807             leftGraceTime: now + _leftGraceSecs,
808             rightGraceTime: finishTime - _rightGraceSecs,
809             startTime: now,
810             finishTime: finishTime,
811             finished: false,
812             finishedCarCount: 0,
813             firstCar: 0,
814             totalTokens: 0,
815             driverCount: 0
816         }));
817         RaceLib.Race storage race = races[_newLapId];
818 
819         uint8 j = 0;
820         for (uint8 i = 0; i < _carsAndRates.length; i += 2) {
821             address car = address(_carsAndRates[j++]);
822             uint startRateToUsdE8 = _carsAndRates[j++];
823             require(isKnownCar[car]);
824             race.startCar(car, startRateToUsdE8);
825         }
826     }
827 
828     /**
829      * Structure of _carsAndRates:
830      *   N-th elem is a car addr.
831      *   (N+1)-th elem is car rate.
832      */
833     function finishRace(
834         uint _lapId, 
835         uint[] _carsAndRates
836     ) onlyOwner public {
837         require(_carsAndRates.length == (cars.length * 2));
838         
839         RaceLib.Race storage race = getRace(_lapId);
840         race.finish();
841         
842         int maxGain = 0;
843         address firstCar; // The first finished car.
844         
845         uint8 j = 0;
846         for (uint8 i = 0; i < _carsAndRates.length; i += 2) {
847             address car = address(_carsAndRates[j++]);
848             uint finishRateToUsdE8 = _carsAndRates[j++];
849             require(!isCarFinished(_lapId, car));
850             
851             // Mark car as finished:
852             RaceLib.CarRates storage rates = race.carRates[car];
853             rates.finishRateToUsdE8 = finishRateToUsdE8;
854             race.isFinishedCar[car] = true;
855             race.finishedCarCount++;
856             
857             // Calc gain of car:
858             int gain = RaceCalc.calcGainE8(rates.startRateToUsdE8, finishRateToUsdE8);
859             race.gainByCar[car] = gain;
860             if (i == 0 || gain > maxGain) {
861                 maxGain = gain;
862                 firstCar = car;
863             }
864         }
865         
866         // The first finished car should be found.
867         require(firstCar != 0);
868         race.firstCar = firstCar;
869     }
870     
871     function finishRaceThenStartNext(
872         uint _lapId, 
873         uint[] _carsAndRates,
874         uint _durationSecs,
875         uint _leftGraceSecs, // How many seconds from the start we should not apply penalty for stake of bet?
876         uint _rightGraceSecs // How many seconds before the finish we should not apply penalty for stake of bet?
877     ) onlyOwner public {
878         finishRace(_lapId, _carsAndRates);
879         startNewRace(_lapId + 1, _carsAndRates, _durationSecs, _leftGraceSecs, _rightGraceSecs);
880     }
881     
882     function isLastRaceFinsihed() public view returns (bool) {
883         return isLapFinished(lastLapId());
884     }
885     
886     function isLapFinished(
887         uint _lapId
888     ) public view returns (bool) {
889         return getRace(_lapId).isFinished();
890     }
891     
892     // Unused func.
893     // function shouldFinishLap(
894     //     uint _lapId
895     // ) public view returns (bool) {
896     //     RaceLib.Race storage lap = getRace(_lapId);
897     //     // 'now' will not work for Ganache
898     //     return !lap.isFinished() && now >= lap.finishTime;
899     // }
900     
901     function lapStartTime(
902         uint _lapId
903     ) public view returns (uint) {
904         return getRace(_lapId).startTime;
905     }
906     
907     function lapFinishTime(
908         uint _lapId
909     ) public view returns (uint) {
910         return getRace(_lapId).finishTime;
911     }
912     
913     function isCarFinished(
914         uint _lapId,
915         address _car
916     ) public view returns (bool) {
917         require(isKnownCar[_car]);
918         return getRace(_lapId).isFinishedCar[_car];
919     }
920     
921     function allCarsFinished(
922         uint _lapId
923     ) public view returns (bool) {
924         return finishedCarCount(_lapId) == cars.length;
925     }
926     
927     function finishedCarCount(
928         uint _lapId
929     ) public view returns (uint) {
930         return getRace(_lapId).finishedCarCount;
931     }
932     
933     function firstCar(
934         uint _lapId
935     ) public view returns (address) {
936         return getRace(_lapId).firstCar;
937     }
938     
939     function isWinningDriver(
940         uint _lapId, 
941         address _driver
942     ) public view returns (bool) {
943         RaceLib.Race storage race = getRace(_lapId);
944         return race.tokensByCarAndDriver[race.firstCar][_driver] > 0;
945     }
946     
947     /**
948      * This is helper function usefull when debugging contract or checking state on Etherscan.
949      */
950     function myUnclaimedTokens(
951         uint _lapId
952     ) public view returns (uint) {
953         return unclaimedTokens(_lapId, msg.sender);
954     }
955     
956     /** 
957      * Calculate how much tokens a winning driver can claim once race is over.
958      * Claimed tokens will be added back to driver's token balance.
959      * Formula = share of all tokens based on bets made on winning car.
960      * Tokens in format e18.
961      */
962     function unclaimedTokens(
963         uint _lapId,
964         address _driver
965     ) public view returns (uint) {
966         RaceLib.Race storage race = getRace(_lapId);
967         
968         // if driver has claimed his tokens already.
969         if (race.tokensClaimedByDriver[_driver] > 0) return 0;
970         
971         if (!race.isFinished()) return 0;
972         if (race.firstCar == 0) return 0;
973         if (race.totalTokens == 0) return 0;
974         if (race.stakeByCar[race.firstCar] == 0) return 0;
975         
976         // Size of driver's stake on the first finished car.
977         uint driverStake = race.stakeByCarAndDriver[race.firstCar][_driver];
978         if (driverStake == 0) return 0;
979 
980         return RaceCalc.calcPrizeTokensE18(
981             race.totalTokens, 
982             race.stakeByCar[race.firstCar],
983             driverStake
984         );
985     }
986 
987     function claimTokens(
988         uint _lapId
989     ) public ifWalletDefined {
990         address driver = msg.sender;
991         uint tokens = unclaimedTokens(_lapId, driver);
992         require(tokens > 0);
993         // Transfer prize tokens from game wallet to driver's address:
994         require(wallet.transfer(driver, tokens));
995         getRace(_lapId).tokensClaimedByDriver[driver] = tokens;
996     }
997     
998     function makeBet(
999         uint _lapId,
1000         address _car, 
1001         uint _tokensE18
1002     ) public ifWalletDefined {
1003         address driver = msg.sender;
1004         require(isKnownCar[_car]);
1005         
1006         // NOTE: Remember that driver needs to call Token(address).approve(wallet, tokens) 
1007         // or this contract will not be able to do the transfer on your behalf.
1008         
1009         // Transfer tokens from driver to game wallet:
1010         require(wallet.transferFrom(msg.sender, wallet, _tokensE18));
1011         getRace(_lapId).makeBet(driver, _car, _tokensE18);
1012         
1013         if (!isKnownDriver[driver]) {
1014             isKnownDriver[driver] = true;
1015             drivers.push(driver);
1016         }
1017     }
1018     
1019     /**
1020      * Result array format:
1021      * [
1022      * N+0: COIN_ADDRESS (ex: 0x0000000000000000000000000000000000012301)
1023      * N+1: MY_BET_TOKENS_E18
1024      * ... repeat ...
1025      * ]
1026      */
1027     function myBetsInLap(
1028         uint _lapId
1029     ) public view returns (uint[] memory totals) {
1030         RaceLib.Race storage race = getRace(_lapId);
1031         totals = new uint[](cars.length * 2);
1032         uint8 j = 0;
1033         address car;
1034         for (uint8 i = 0; i < cars.length; i++) {
1035             car = cars[i];
1036             totals[j++] = uint(car);
1037             totals[j++] = race.tokensByCarAndDriver[car][msg.sender];
1038         }
1039     }
1040     
1041     /**
1042      * Result array format:
1043      * [
1044      * 0: START_DATE_UNIX_TS
1045      * 1: DURATION_SEC
1046      * 2: FIRST_CAR_ID
1047      * 3: !!! NEW !!! MY_UNCLAIMED_TOKENS
1048      * 
1049      * N+0: COIN_ADDRESS (ex: 0x0000000000000000000000000000000000012301)
1050      * N+1: START_RATE_E8
1051      * N+2: END_RATE_E8
1052      * N+3: DRIVER_COUNT
1053      * N+4: TOTAL_BET_TOKENS_E18
1054      * N+5: MY_BET_TOKENS_E18
1055      * N+6: !!! NEW !!! GAIN_E8
1056      * ... repeat for each car...
1057      * ]
1058      */
1059     function lapTotals(
1060         uint _lapId
1061     ) public view returns (int[] memory totals) {
1062         RaceLib.Race storage race = getRace(_lapId);
1063         totals = new int[](5 + cars.length * 7);
1064         
1065         uint _myUnclaimedTokens = 0;
1066         if (isLapFinished(_lapId)) {
1067             _myUnclaimedTokens = unclaimedTokens(_lapId, msg.sender);
1068         }
1069         
1070         address car;
1071         uint8 j = 0;
1072         totals[j++] = int(now);
1073         totals[j++] = int(race.startTime);
1074         totals[j++] = int(race.finishTime - race.startTime);
1075         totals[j++] = int(race.firstCar);
1076         totals[j++] = int(_myUnclaimedTokens);
1077         
1078         for (uint8 i = 0; i < cars.length; i++) {
1079             car = cars[i];
1080             totals[j++] = int(car);
1081             totals[j++] = int(race.carRates[car].startRateToUsdE8);
1082             totals[j++] = int(race.carRates[car].finishRateToUsdE8);
1083             totals[j++] = int(race.driverCountByCar[car]);
1084             totals[j++] = int(race.tokensByCar[car]);
1085             totals[j++] = int(race.tokensByCarAndDriver[car][msg.sender]);
1086             totals[j++] = race.gainByCar[car];
1087         }
1088     }
1089 }
1090 
1091 contract RaceOldSchool4h is CommonRace, CoinLib {
1092     
1093     function RaceOldSchool4h() CommonRace(
1094         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
1095         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
1096         oldSchool,
1097         'Old School'
1098     ) public {}
1099 }
1100 
1101 contract RaceBtcForks4h is CommonRace, CoinLib {
1102     
1103     function RaceBtcForks4h() CommonRace(
1104         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
1105         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
1106         btcForks,
1107         'Bitcoin Forks'
1108     ) public {}
1109 }
1110 
1111 contract RaceSmart4h is CommonRace, CoinLib {
1112     
1113     function RaceSmart4h() CommonRace(
1114         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
1115         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
1116         smart,
1117         'Smart Coins'
1118     ) public {}
1119 }
1120 
1121 contract RaceAnons4h is CommonRace, CoinLib {
1122     
1123     function RaceAnons4h() CommonRace(
1124         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
1125         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
1126         anons,
1127         'Anonymouses'
1128     ) public {}
1129 }