1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Build your own empire on Blockchain
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function min(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a < b ? a : b;
52     }
53 }
54 contract CryptoMiningWarInterface {
55     uint256 public roundNumber;
56     uint256 public deadline; 
57     function addHashrate( address /*_addr*/, uint256 /*_value*/ ) external pure {}
58     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure {}
59     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure {}
60     function isMiningWarContract() external pure returns(bool);
61 }
62 interface CryptoEngineerInterface {
63     function addVirus(address /*_addr*/, uint256 /*_value*/) external pure;
64     function subVirus(address /*_addr*/, uint256 /*_value*/) external pure;
65 
66     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/);
67     function isEngineerContract() external pure returns(bool);
68     function calCurrentVirus(address /*_addr*/) external view returns(uint256 /*_currentVirus*/);
69     function calCurrentCrystals(address /*_addr*/) external pure returns(uint256 /*_currentCrystals*/);
70 }
71 interface CryptoProgramFactoryInterface {
72     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
73     function isProgramFactoryContract() external pure returns(bool);
74 
75     function subPrograms(address /*_addr*/, uint256[] /*_programs*/) external;
76     function getData(address _addr) external pure returns(uint256 /*_factoryLevel*/, uint256 /*_factoryTime*/, uint256[] /*memory _programs*/);
77     function getProgramsValue() external pure returns(uint256[]);
78 }
79 interface MiniGameInterface {
80     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
81     function fallback() external payable;
82 }
83 interface MemoryArenaInterface {
84     function setVirusDef(address /*_addr*/, uint256 /*_value*/) external pure;
85     function setNextTimeAtk(address /*_addr*/, uint256 /*_value*/) external pure;
86     function setEndTimeUnequalledDef(address /*_addr*/, uint256 /*_value*/) external pure;
87     function setNextTimeArenaBonus(address /*_addr*/, uint256 /*_value*/) external pure;
88     function setBonusPoint(address /*_addr*/, uint256 /*_value*/) external pure;
89 
90     function getData(address _addr) external view returns(uint256 /*virusDef*/, uint256 /*nextTimeAtk*/, uint256 /*endTimeUnequalledDef*/, uint256 /*nextTimeArenaBonus*/, uint256 /*bonusPoint*/);
91     function isMemoryArenaContract() external pure returns(bool);
92 }
93 contract CryptoArena {
94 	using SafeMath for uint256;
95 
96 	address public administrator;
97 
98     uint256 private VIRUS_NORMAL = 0;
99     uint256 private HALF_TIME_ATK= 60 * 15;  
100     uint256 private CRTSTAL_MINING_PERIOD = 86400;
101     uint256 private VIRUS_MINING_PERIOD   = 86400;
102     uint256 private ROUND_TIME_MINING_WAR = 86400 * 7;
103     uint256 private TIME_DAY = 24 hours;
104 
105     CryptoMiningWarInterface      public MiningWar;
106     CryptoEngineerInterface       public Engineer;
107     CryptoProgramFactoryInterface public Factory;
108     MemoryArenaInterface          public MemoryArena;
109 
110     // factory info
111     mapping(uint256 => Virus)   public viruses;
112      // minigame info
113     mapping(address => bool)    public miniGames; 
114 
115     mapping(uint256 => uint256) public arenaBonus; 
116    
117     struct Virus {
118         uint256 atk;
119         uint256 def;
120     }
121     modifier isAdministrator()
122     {
123         require(msg.sender == administrator);
124         _;
125     }
126     modifier onlyContractsMiniGame() 
127     {
128         require(miniGames[msg.sender] == true);
129         _;
130     }
131     event Attack(address atkAddress, address defAddress, bool victory, uint256 reward, uint256 virusAtkDead, uint256 virusDefDead, uint256 atk, uint256 def, uint256 round); // 1 : crystals, 2: hashrate, 3: virus
132     event Programs(uint256 programLv1, uint256 programLv2, uint256 programLv3, uint256 programLv4);
133     event ArenaBonus(address player, uint256 bonus);
134 
135     constructor() public {
136         administrator = msg.sender;
137         // set interface contract
138         setMiningWarInterface(0x1b002cd1ba79dfad65e8abfbb3a97826e4960fe5);
139         setEngineerInterface(0xd7afbf5141a7f1d6b0473175f7a6b0a7954ed3d2);
140         setFactoryInterface(0x0498e54b6598e96b7a42ade3d238378dc57b5bb2);
141         setMemoryArenaInterface(0x5fafca56f6860dceeb6e7495a74a806545802895);
142 
143          // setting virusupd
144         viruses[VIRUS_NORMAL] = Virus(1,1);
145         // init arena bonus
146         initArenaBonus();
147     }
148     function initArenaBonus() private 
149     {
150         arenaBonus[0] = 15000;
151         arenaBonus[1] = 50000;
152         arenaBonus[2] = 100000;
153         arenaBonus[3] = 200000;
154         arenaBonus[4] = 350000;
155         arenaBonus[5] = 500000;
156         arenaBonus[6] = 1500000;
157     }
158     function () public payable
159     {
160         
161     }
162     /** 
163     * @dev MainContract used this function to verify game's contract
164     */
165     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
166     {
167     	_isContractMiniGame = true;
168     }
169     function isArenaContract() public pure returns(bool)
170     {
171         return true;
172     }
173     function upgrade(address addr) public isAdministrator
174     {
175         selfdestruct(addr);
176     }
177     /** 
178     * @dev Main Contract call this function to setup mini game.
179     */
180     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public pure
181     {
182 
183     }
184     //--------------------------------------------------------------------------
185     // ADMIN ACTION
186     //--------------------------------------------------------------------------
187     function setArenaBonus(uint256 idx, uint256 _value) public isAdministrator
188     {
189         arenaBonus[idx] = _value;
190     }
191     //--------------------------------------------------------------------------
192     // SETTING CONTRACT MINI GAME 
193     //--------------------------------------------------------------------------
194     function setContractsMiniGame( address _addr ) public isAdministrator 
195     {
196         MiniGameInterface MiniGame = MiniGameInterface( _addr );
197         if( MiniGame.isContractMiniGame() == false ) revert(); 
198 
199         miniGames[_addr] = true;
200     }
201     /**
202     * @dev remove mini game contract from main contract
203     * @param _addr mini game contract address
204     */
205     function removeContractMiniGame(address _addr) public isAdministrator
206     {
207         miniGames[_addr] = false;
208     }
209     // ---------------------------------------------------------------------------------------
210     // SET INTERFACE CONTRACT
211     // ---------------------------------------------------------------------------------------
212     
213     function setMiningWarInterface(address _addr) public isAdministrator
214     {
215         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
216 
217         require(miningWarInterface.isMiningWarContract() == true);
218                 
219         MiningWar = miningWarInterface;
220     }
221     function setEngineerInterface(address _addr) public isAdministrator
222     {
223         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
224         
225         require(engineerInterface.isEngineerContract() == true);
226 
227         Engineer = engineerInterface;
228     }
229     
230     function setFactoryInterface(address _addr) public isAdministrator
231     {
232         CryptoProgramFactoryInterface factoryInterface = CryptoProgramFactoryInterface(_addr);
233         
234         // require(factoryInterface.isProgramFactoryContract() == true);
235 
236         Factory = factoryInterface;
237     }
238     function setMemoryArenaInterface(address _addr) public isAdministrator
239     {
240         MemoryArenaInterface memoryArenaInterface = MemoryArenaInterface(_addr);
241         
242         require(memoryArenaInterface.isMemoryArenaContract() == true);
243 
244         MemoryArena = memoryArenaInterface;
245     }
246 
247     // --------------------------------------------------------------------------------------------------------------
248     // FUCTION FOR NEXT VERSION
249     // --------------------------------------------------------------------------------------------------------------
250     /**
251     * @dev additional time unequalled defence 
252     * @param _addr player address 
253     */
254     function setVirusDef(address _addr, uint256 _value) public isAdministrator
255     {
256         MemoryArena.setVirusDef(_addr, SafeMath.mul(_value, VIRUS_MINING_PERIOD));
257     }
258     function setAtkNowForPlayer(address _addr) public onlyContractsMiniGame
259     {
260         MemoryArena.setNextTimeAtk(_addr, now);
261     }
262     function setPlayerVirusDef(address _addr, uint256 _value) public onlyContractsMiniGame
263     {     
264         MemoryArena.setVirusDef(_addr, SafeMath.mul(_value, VIRUS_MINING_PERIOD));
265     } 
266     function addVirusDef(address _addr, uint256 _virus) public
267     {
268         require(miniGames[msg.sender] == true || msg.sender == _addr);
269 
270         Engineer.subVirus(_addr, _virus);
271         
272         uint256 virusDef;
273         (virusDef, , , ,) = MemoryArena.getData(_addr);
274         virusDef += SafeMath.mul(_virus, VIRUS_MINING_PERIOD);
275 
276         MemoryArena.setVirusDef(_addr, virusDef);
277     }
278     function subVirusDef(address _addr, uint256 _virus) public onlyContractsMiniGame
279     {        
280         _virus = SafeMath.mul(_virus, VIRUS_MINING_PERIOD);
281         uint256 virusDef;
282         (virusDef, , , ,) = MemoryArena.getData(_addr);
283 
284         if (virusDef < _virus) revert();
285 
286         virusDef -= _virus;
287         MemoryArena.setVirusDef(_addr, virusDef);
288     }
289     function addTimeUnequalledDefence(address _addr, uint256 _value) public onlyContractsMiniGame
290     {
291         uint256 endTimeUnequalledDef;
292         (,,endTimeUnequalledDef,,) = MemoryArena.getData(_addr);
293         if (endTimeUnequalledDef < now) endTimeUnequalledDef = now;
294         
295         MemoryArena.setEndTimeUnequalledDef(_addr, SafeMath.add(endTimeUnequalledDef, _value));
296     }
297     // --------------------------------------------------------------------------------------------------------------
298     // MAIN CONTENT
299     // --------------------------------------------------------------------------------------------------------------
300     function setVirusInfo(uint256 _atk, uint256 _def) public isAdministrator
301     {
302         Virus storage v = viruses[VIRUS_NORMAL];
303         v.atk = _atk;
304         v.def = _def;
305     }
306 
307     /**
308     * @dev ATTACK
309     * _programs[0]: + 10% _virus;
310     * _programs[1]: revival 15 % _virus if this atk lose(not use item before)
311     * _programs[2]: + 20% dame
312     * _programs[3]: -5% virus defence of player you want attack
313     */
314     function attack(address _defAddress, uint256 _virus, uint256[] _programs) public
315     {
316         require(validateAttack(msg.sender, _defAddress) == true);
317         require(_programs.length == 4);
318         require(validatePrograms(_programs) == true);
319 
320         Factory.subPrograms(msg.sender, _programs);
321 
322         MemoryArena.setNextTimeAtk(msg.sender, now + HALF_TIME_ATK);
323         uint256 virusDef; // def of player def
324         (virusDef, , , ,) = MemoryArena.getData(_defAddress);
325         if (virusDef == 0) return endAttack(_defAddress, true, 0, 0, SafeMath.mul(_virus, VIRUS_MINING_PERIOD), 0, 1, _programs);
326 
327         Engineer.subVirus(msg.sender, _virus);
328 
329         uint256[] memory programsValue = Factory.getProgramsValue(); 
330 
331         firstAttack(_defAddress, SafeMath.mul(_virus, VIRUS_MINING_PERIOD), _programs, programsValue, virusDef);
332     }
333     function firstAttack(address _defAddress, uint256 _virus, uint256[] _programs, uint256[] programsValue, uint256 virusDef) 
334     private 
335     {
336         uint256 atk;
337         uint256 def;
338         uint256 virusAtkDead;
339         uint256 virusDefDead;
340         bool victory;
341         
342         (atk, def, virusAtkDead, virusDefDead, victory) = getResultAtk(msg.sender, _defAddress, _virus, _programs, programsValue, virusDef, true);
343 
344         if (_virus > virusAtkDead)
345             Engineer.addVirus(msg.sender, SafeMath.div(SafeMath.sub(_virus, virusAtkDead), VIRUS_MINING_PERIOD));
346         
347         endAttack(_defAddress, victory, SafeMath.div(virusAtkDead, VIRUS_MINING_PERIOD), SafeMath.div(virusDefDead, VIRUS_MINING_PERIOD), atk, def, 1, _programs);
348 
349         if (victory == false && _programs[1] == 1)
350             againAttack(_defAddress, SafeMath.div(SafeMath.mul(SafeMath.mul(_virus, VIRUS_MINING_PERIOD), programsValue[1]), 100), programsValue); // revival 15 % _virus if this atk lose(not use item before)
351     }
352     function againAttack(address _defAddress, uint256 _virus, uint256[] programsValue) private returns(bool victory)
353     {
354         uint256 virusDef; // def of player def
355         (virusDef, , , ,) = MemoryArena.getData(_defAddress);
356         uint256[] memory programs;
357         
358         uint256 atk;
359         uint256 def;
360         uint256 virusDefDead;
361         
362         (atk, def, , virusDefDead, victory) = getResultAtk(msg.sender, _defAddress, _virus, programs, programsValue, virusDef, false);
363 
364         endAttack(_defAddress, victory, 0,  SafeMath.div(virusDefDead, VIRUS_MINING_PERIOD), atk, def, 2, programs);
365     }
366     function getResultAtk(address atkAddress, address defAddress, uint256 _virus, uint256[] _programs, uint256[] programsValue, uint256 virusDef, bool isFirstAttack)
367     private  
368     returns(
369         uint256 atk,
370         uint256 def,
371         uint256 virusAtkDead,
372         uint256 virusDefDead,
373         bool victory
374     ){
375         atk             = _virus; 
376         uint256 rateAtk = 50 + randomNumber(atkAddress, 1, 101);
377         uint256 rateDef = 50 + randomNumber(defAddress, rateAtk, 101);
378         
379         if (_programs[0] == 1 && isFirstAttack == true) // + 10% _virus;
380             atk += SafeMath.div(SafeMath.mul(atk, programsValue[0]), 100); 
381         if (_programs[3] == 1 && isFirstAttack == true) {// -5% virus defence of player you want attack
382             virusDef = SafeMath.sub(virusDef, SafeMath.div(SafeMath.mul(virusDef, programsValue[3]), 100)); 
383             MemoryArena.setVirusDef(defAddress, virusDef); 
384         }    
385         atk = SafeMath.div(SafeMath.mul(SafeMath.mul(atk, viruses[VIRUS_NORMAL].atk), rateAtk), 100);
386         def = SafeMath.div(SafeMath.mul(SafeMath.mul(virusDef, viruses[VIRUS_NORMAL].def), rateDef), 100);
387 
388         if (_programs[2] == 1 && isFirstAttack == true)  //+ 20% dame
389             atk += SafeMath.div(SafeMath.mul(atk, programsValue[2]), 100);
390 
391         if (atk >= def) {
392             virusAtkDead = SafeMath.min(_virus, SafeMath.div(SafeMath.mul(def, 100), SafeMath.mul(viruses[VIRUS_NORMAL].atk, rateAtk)));
393             virusDefDead = virusDef;
394             victory      = true;
395         } else {
396             virusAtkDead = _virus;
397             virusDefDead = SafeMath.min(virusDef, SafeMath.div(SafeMath.mul(atk, 100), SafeMath.mul(viruses[VIRUS_NORMAL].def, rateDef)));
398         }
399 
400         MemoryArena.setVirusDef(defAddress, SafeMath.sub(virusDef, virusDefDead));
401     }
402     function endAttack(address _defAddress, bool victory, uint256 virusAtkDead, uint256 virusDefDead, uint256 atk, uint256 def, uint256 round, uint256[] programs) private 
403     {
404         uint256 reward = 0;
405         if (victory == true) {
406             uint256 pDefCrystals = Engineer.calCurrentCrystals(_defAddress);
407             // subtract random 10% to 50% current crystals of player defence
408             uint256 rate = 10 + randomNumber(_defAddress, pDefCrystals, 41);
409             reward = SafeMath.div(SafeMath.mul(pDefCrystals, rate),100);
410 
411             if (reward > 0) {
412                 MiningWar.subCrystal(_defAddress, reward);    
413                 MiningWar.addCrystal(msg.sender, reward);
414             }
415             updateBonusPoint(msg.sender);
416         }
417         emit Attack(msg.sender, _defAddress, victory, reward, virusAtkDead, virusDefDead, atk, def, round);
418         if (round == 1) emit Programs( programs[0], programs[1], programs[2], programs[3]);
419     }
420     function updateBonusPoint(address _addr) private
421     {
422         uint256 nextTimeArenaBonus;
423         uint256 bonusPoint;
424         (,,,nextTimeArenaBonus, bonusPoint) = MemoryArena.getData(_addr);
425 
426         if (now >= nextTimeArenaBonus) {
427             bonusPoint += 1;
428         }
429         if (bonusPoint == 3) {
430             bonusPoint = 0;
431             nextTimeArenaBonus = now + TIME_DAY;
432             uint256 noDayStartMiningWar = getNoDayStartMiningWar();
433             MiningWar.addCrystal(_addr, arenaBonus[noDayStartMiningWar - 1]);
434 
435             emit ArenaBonus(_addr, arenaBonus[noDayStartMiningWar - 1]);
436         }
437         MemoryArena.setNextTimeArenaBonus(_addr, nextTimeArenaBonus);
438         MemoryArena.setBonusPoint(_addr, bonusPoint);
439     }
440     function validateAttack(address _atkAddress, address _defAddress) private view returns(bool _status) 
441     {
442         uint256 nextTimeAtk;
443         (,nextTimeAtk,,,) = MemoryArena.getData(_atkAddress); 
444         if (
445             _atkAddress != _defAddress &&
446             nextTimeAtk <= now &&
447             canAttack(_defAddress) == true
448             ) {
449             _status = true;
450         }
451     } 
452     function validatePrograms(uint256[] _programs) private pure returns(bool _status)
453     {
454         _status = true;
455         for(uint256 idx = 0; idx < _programs.length; idx++) {
456             if (_programs[idx] != 0 && _programs[idx] != 1) _status = false;
457         }
458     }
459     function canAttack(address _addr) private view returns(bool _canAtk)
460     {
461         uint256 endTimeUnequalledDef;
462         (,,endTimeUnequalledDef,,) = MemoryArena.getData(_addr); 
463         if ( 
464             endTimeUnequalledDef < now &&
465             Engineer.calCurrentCrystals(_addr) >= 5000
466             ) {
467             _canAtk = true;
468         }
469     }
470     // --------------------------------------------------------------------------------------------------------------
471     // CALL FUNCTION
472     // --------------------------------------------------------------------------------------------------------------
473     function getData(address _addr) 
474     public
475     view
476     returns(
477         uint256 _virusDef,
478         uint256 _nextTimeAtk,
479         uint256 _endTimeUnequalledDef,
480         bool    _canAtk,
481         // engineer
482         uint256 _currentVirus, 
483         // mingin war
484         uint256 _currentCrystals
485     ) {
486         (_virusDef, _nextTimeAtk, _endTimeUnequalledDef, ,) = MemoryArena.getData(_addr);
487         _virusDef            = SafeMath.div(_virusDef, VIRUS_MINING_PERIOD);
488         _currentVirus        = SafeMath.div(Engineer.calCurrentVirus(_addr), VIRUS_MINING_PERIOD);
489         _currentCrystals     = Engineer.calCurrentCrystals(_addr);
490         _canAtk              = canAttack(_addr);
491     }
492     function getDataForUI(address _addr) 
493     public
494     view
495     returns(
496         uint256 _virusDef,
497         uint256 _nextTimeAtk,
498         uint256 _endTimeUnequalledDef,
499         uint256 _nextTimeArenaBonus,
500         uint256 _bonusPoint,
501         bool    _canAtk,
502         // engineer
503         uint256 _currentVirus, 
504         // mingin war
505         uint256 _currentCrystals
506     ) {
507         (_virusDef, _nextTimeAtk, _endTimeUnequalledDef, _nextTimeArenaBonus, _bonusPoint) = MemoryArena.getData(_addr);
508         _virusDef            = SafeMath.div(_virusDef, VIRUS_MINING_PERIOD);
509         _currentVirus        = SafeMath.div(Engineer.calCurrentVirus(_addr), VIRUS_MINING_PERIOD);
510         _currentCrystals     = Engineer.calCurrentCrystals(_addr);
511         _canAtk              = canAttack(_addr);
512     }
513     // --------------------------------------------------------------------------------------------------------------
514     // INTERNAL FUNCTION
515     // --------------------------------------------------------------------------------------------------------------
516     function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private view returns(uint256)
517     {
518         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
519     }
520     function getNoDayStartMiningWar() public view returns(uint256)
521     {
522         uint256 deadline = MiningWar.deadline();
523         if (deadline < now) return 7;
524         uint256 timeEndMiningWar  = deadline - now;
525         uint256 noDayEndMiningWar = SafeMath.div(timeEndMiningWar, TIME_DAY);
526         return SafeMath.sub(7, noDayEndMiningWar);
527     }
528 }