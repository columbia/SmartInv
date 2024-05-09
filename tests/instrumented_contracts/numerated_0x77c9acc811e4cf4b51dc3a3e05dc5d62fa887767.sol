1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Blockchain-based strategy game
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
54 interface CryptoMiningWarInterface {
55     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;
56     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) external pure;
57     function isMiningWarContract() external pure returns(bool);
58 }
59 interface CryptoEngineerInterface {
60     function addVirus(address /*_addr*/, uint256 /*_value*/) external pure;
61     function subVirus(address /*_addr*/, uint256 /*_value*/) external pure;
62 
63     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/);
64     function isEngineerContract() external pure returns(bool);
65     function calCurrentVirus(address /*_addr*/) external view returns(uint256 /*_currentVirus*/);
66     function calCurrentCrystals(address /*_addr*/) external pure returns(uint256 /*_currentCrystals*/);
67 }
68 interface CryptoProgramFactoryInterface {
69     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
70     function isProgramFactoryContract() external pure returns(bool);
71 
72     function subPrograms(address /*_addr*/, uint256[] /*_programs*/) external;
73     function getData(address _addr) external pure returns(uint256 /*_factoryLevel*/, uint256 /*_factoryTime*/, uint256[] /*memory _programs*/);
74     function getProgramsValue() external pure returns(uint256[]);
75 }
76 interface MiniGameInterface {
77     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
78     function fallback() external payable;
79 }
80 contract CrryptoArena {
81 	using SafeMath for uint256;
82 
83 	address public administrator;
84 
85     uint256 public VIRUS_NORMAL = 0;
86     uint256 public HALF_TIME_ATK= 60 * 15;  
87     uint256 public CRTSTAL_MINING_PERIOD = 86400;
88     uint256 public VIRUS_MINING_PERIOD   = 86400;
89     address public engineerAddress;
90 
91     CryptoMiningWarInterface      public MiningWar;
92     CryptoEngineerInterface       public Engineer;
93     CryptoProgramFactoryInterface public Factory;
94 
95     // factory info
96     // player info
97     mapping(address => Player) public players;
98 
99     mapping(uint256 => Virus)  public viruses;
100      // minigame info
101     mapping(address => bool)   public miniGames; 
102    
103     struct Player {
104         uint256 virusDef;
105         uint256 nextTimeAtk;
106         uint256 endTimeUnequalledDef;
107     }
108     struct Virus {
109         uint256 atk;
110         uint256 def;
111     }
112     modifier isAdministrator()
113     {
114         require(msg.sender == administrator);
115         _;
116     }
117     modifier onlyContractsMiniGame() 
118     {
119         require(miniGames[msg.sender] == true);
120         _;
121     }
122     event Attack(address atkAddress, address defAddress, bool victory, uint256 reward, uint256 virusAtkDead, uint256 virusDefDead, uint256 atk, uint256 def, uint256 round); // 1 : crystals, 2: hashrate, 3: virus
123     event Programs(uint256 programLv1, uint256 programLv2, uint256 programLv3, uint256 programLv4);
124 
125     constructor() public {
126         administrator = msg.sender;
127         // set interface contract
128         setMiningWarInterface(0x1b002cd1ba79dfad65e8abfbb3a97826e4960fe5);
129         setEngineerInterface(0xd7afbf5141a7f1d6b0473175f7a6b0a7954ed3d2);
130         setFactoryInterface(0x0498e54b6598e96b7a42ade3d238378dc57b5bb2);
131 
132          // setting virusupd
133         viruses[VIRUS_NORMAL] = Virus(1,1);
134     }
135     function () public payable
136     {
137         
138     }
139     /** 
140     * @dev MainContract used this function to verify game's contract
141     */
142     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
143     {
144     	_isContractMiniGame = true;
145     }
146     function isArenaContract() public pure returns(bool)
147     {
148         return true;
149     }
150     function upgrade(address addr) public isAdministrator
151     {
152         selfdestruct(addr);
153     }
154     /** 
155     * @dev Main Contract call this function to setup mini game.
156     */
157     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public
158     {
159 
160     }
161     //--------------------------------------------------------------------------
162     // SETTING CONTRACT MINI GAME 
163     //--------------------------------------------------------------------------
164     function setContractsMiniGame( address _addr ) public isAdministrator 
165     {
166         MiniGameInterface MiniGame = MiniGameInterface( _addr );
167         if( MiniGame.isContractMiniGame() == false ) revert(); 
168 
169         miniGames[_addr] = true;
170     }
171     /**
172     * @dev remove mini game contract from main contract
173     * @param _addr mini game contract address
174     */
175     function removeContractMiniGame(address _addr) public isAdministrator
176     {
177         miniGames[_addr] = false;
178     }
179     // ---------------------------------------------------------------------------------------
180     // SET INTERFACE CONTRACT
181     // ---------------------------------------------------------------------------------------
182     
183     function setMiningWarInterface(address _addr) public isAdministrator
184     {
185         CryptoMiningWarInterface miningWarInterface = CryptoMiningWarInterface(_addr);
186 
187         require(miningWarInterface.isMiningWarContract() == true);
188                 
189         MiningWar = miningWarInterface;
190     }
191     function setEngineerInterface(address _addr) public isAdministrator
192     {
193         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
194         
195         require(engineerInterface.isEngineerContract() == true);
196 
197         engineerAddress = _addr;
198 
199         Engineer = engineerInterface;
200     }
201     
202     function setFactoryInterface(address _addr) public isAdministrator
203     {
204         CryptoProgramFactoryInterface factoryInterface = CryptoProgramFactoryInterface(_addr);
205 
206         Factory = factoryInterface;
207     }
208 
209     // --------------------------------------------------------------------------------------------------------------
210     // FUCTION FOR NEXT VERSION
211     // --------------------------------------------------------------------------------------------------------------
212     /**
213     * @dev additional time unequalled defence 
214     * @param _addr player address 
215     */
216     function setAtkNowForPlayer(address _addr) public onlyContractsMiniGame
217     {
218         Player storage p = players[_addr];
219         p.nextTimeAtk = now;
220     }
221     function setPlayerVirusDef(address _addr, uint256 _value) public onlyContractsMiniGame
222     {     
223         players[_addr].virusDef = SafeMath.mul(_value, VIRUS_MINING_PERIOD);
224     } 
225     function addVirusDef(address _addr, uint256 _virus) public
226     {
227         require(miniGames[msg.sender] == true || msg.sender == _addr);
228 
229         Engineer.subVirus(_addr, _virus);
230 
231         Player storage p = players[_addr];
232 
233         p.virusDef += SafeMath.mul(_virus, VIRUS_MINING_PERIOD);
234     }
235     function subVirusDef(address _addr, uint256 _virus) public onlyContractsMiniGame
236     {        
237         _virus = SafeMath.mul(_virus, VIRUS_MINING_PERIOD);
238         require(players[_addr].virusDef >= _virus);
239 
240         Player storage p = players[_addr];
241 
242         p.virusDef -= _virus;
243     }
244     function addTimeUnequalledDefence(address _addr, uint256 _value) public onlyContractsMiniGame
245     {
246         Player storage p = players[_addr];
247         uint256 currentTimeUnequalled = p.endTimeUnequalledDef;
248         if (currentTimeUnequalled < now) currentTimeUnequalled = now;
249         
250         p.endTimeUnequalledDef = SafeMath.add(currentTimeUnequalled, _value);
251     }
252     // --------------------------------------------------------------------------------------------------------------
253     // MAIN CONTENT
254     // --------------------------------------------------------------------------------------------------------------
255     function setVirusInfo(uint256 _atk, uint256 _def) public isAdministrator
256     {
257         Virus storage v = viruses[VIRUS_NORMAL];
258         v.atk = _atk;
259         v.def = _def;
260     }
261 
262     /**
263     * @dev ATTACK
264     * _programs[0]: + 10% _virus;
265     * _programs[1]: revival 15 % _virus if this atk lose(not use item before)
266     * _programs[2]: + 20% dame
267     * _programs[3]: -5% virus defence of player you want attack
268     */
269     function attack(address _defAddress, uint256 _virus, uint256[] _programs) public
270     {
271         require(validateAttack(msg.sender, _defAddress) == true);
272         require(_programs.length == 4);
273         require(validatePrograms(_programs) == true);
274 
275         Factory.subPrograms(msg.sender, _programs);
276 
277         players[msg.sender].nextTimeAtk = now + HALF_TIME_ATK;
278 
279         if (players[_defAddress].virusDef == 0) return endAttack(_defAddress, true, 0, 0, SafeMath.mul(_virus, VIRUS_MINING_PERIOD), 0, 1, _programs);
280 
281         Engineer.subVirus(msg.sender, _virus);
282 
283         uint256[] memory programsValue = Factory.getProgramsValue(); 
284 
285         bool victory;
286         uint256 atk;
287         uint256 def;
288         uint256 virusAtkDead;
289         uint256 virusDefDead;   
290         
291         (victory, atk, def, virusAtkDead, virusDefDead) = firstAttack(_defAddress, SafeMath.mul(_virus, VIRUS_MINING_PERIOD), _programs, programsValue);
292 
293         endAttack(_defAddress, victory, SafeMath.div(virusAtkDead, VIRUS_MINING_PERIOD), SafeMath.div(virusDefDead, VIRUS_MINING_PERIOD), atk, def, 1, _programs);
294 
295         if (_programs[1] == 1 && victory == false)  
296             againAttack(_defAddress, SafeMath.div(SafeMath.mul(SafeMath.mul(_virus, VIRUS_MINING_PERIOD), programsValue[1]), 100)); // revival 15 % _virus if this atk lose(not use item before)
297     }
298     function firstAttack(address _defAddress, uint256 _virus, uint256[] _programs, uint256[] programsValue) 
299     private 
300     returns(
301         bool victory,
302         uint256 atk,
303         uint256 def,
304         uint256 virusAtkDead,
305         uint256 virusDefDead        
306         )
307     {
308         Player storage pDef = players[_defAddress];
309 
310         atk             = _virus; 
311         uint256 rateAtk = 50 + randomNumber(msg.sender, 1, 101);
312         uint256 rateDef = 50 + randomNumber(_defAddress, rateAtk, 101);
313 
314         if (_programs[0] == 1) // + 10% _virus;
315             atk += SafeMath.div(SafeMath.mul(atk, programsValue[0]), 100); 
316         if (_programs[3] == 1) // -5% virus defence of player you want attack
317             pDef.virusDef = SafeMath.sub(pDef.virusDef, SafeMath.div(SafeMath.mul(pDef.virusDef, programsValue[3]), 100)); 
318             
319         atk = SafeMath.div(SafeMath.mul(SafeMath.mul(atk, viruses[VIRUS_NORMAL].atk), rateAtk), 100);
320         def = SafeMath.div(SafeMath.mul(SafeMath.mul(pDef.virusDef, viruses[VIRUS_NORMAL].def), rateDef), 100);
321 
322         if (_programs[2] == 1)  //+ 20% dame
323             atk += SafeMath.div(SafeMath.mul(atk, programsValue[2]), 100);
324 
325         if (atk >= def) {
326             virusAtkDead = SafeMath.min(_virus, SafeMath.div(SafeMath.mul(def, 100), SafeMath.mul(viruses[VIRUS_NORMAL].atk, rateAtk)));
327             virusDefDead = pDef.virusDef;
328             victory      = true;
329         } else {
330             virusAtkDead = _virus;
331             virusDefDead = SafeMath.min(pDef.virusDef, SafeMath.div(SafeMath.mul(atk, 100), SafeMath.mul(viruses[VIRUS_NORMAL].def, rateDef)));
332         }
333 
334         pDef.virusDef = SafeMath.sub(pDef.virusDef, virusDefDead);
335 
336         if (_virus > virusAtkDead) 
337             Engineer.addVirus(msg.sender, SafeMath.div(SafeMath.sub(_virus, virusAtkDead), VIRUS_MINING_PERIOD));
338 
339     }
340     function againAttack(address _defAddress, uint256 _virus) private returns(bool victory)
341     {
342         Player storage pDef = players[_defAddress];
343         // virus normal info
344         Virus memory v = viruses[VIRUS_NORMAL];
345 
346         uint256 rateAtk = 50 + randomNumber(msg.sender, 1, 101);
347         uint256 rateDef = 50 + randomNumber(_defAddress, rateAtk, 101);
348 
349         uint256 atk = SafeMath.div(SafeMath.mul(SafeMath.mul(_virus, v.atk), rateAtk), 100);
350         uint256 def = SafeMath.div(SafeMath.mul(SafeMath.mul(pDef.virusDef, v.def), rateDef), 100);
351         uint256 virusDefDead = 0;
352         uint256[] memory programs;
353         if (atk >= def) {
354             virusDefDead = pDef.virusDef;
355             victory = true;
356         } else {
357             virusDefDead = SafeMath.min(pDef.virusDef, SafeMath.div(SafeMath.mul(atk, 100), SafeMath.mul(v.def, rateDef)));
358         }
359 
360         pDef.virusDef = SafeMath.sub(pDef.virusDef, virusDefDead);
361 
362         endAttack(_defAddress, victory, 0,  SafeMath.div(virusDefDead, VIRUS_MINING_PERIOD), atk, def, 2, programs);
363     }
364     function endAttack(address _defAddress, bool victory, uint256 virusAtkDead, uint256 virusDefDead, uint256 atk, uint256 def, uint256 round, uint256[] programs) private 
365     {
366         uint256 reward = 0;
367         if (victory == true) {
368             uint256 pDefCrystals = Engineer.calCurrentCrystals(_defAddress);
369             // subtract random 10% to 50% current crystals of player defence
370             uint256 rate = 10 + randomNumber(_defAddress, pDefCrystals, 41);
371             reward = SafeMath.div(SafeMath.mul(pDefCrystals, rate),100);
372 
373             if (reward > 0) {
374                 MiningWar.subCrystal(_defAddress, reward);    
375                 MiningWar.addCrystal(msg.sender, reward);
376             }
377         }
378         emit Attack(msg.sender, _defAddress, victory, reward, virusAtkDead, virusDefDead, atk, def, round);
379         if (round == 1) emit Programs( programs[0], programs[1], programs[2], programs[3]);
380     }
381     function validateAttack(address _atkAddress, address _defAddress) private view returns(bool _status) 
382     {
383         if (
384             _atkAddress != _defAddress &&
385             players[_atkAddress].nextTimeAtk <= now &&
386             canAttack(_defAddress) == true
387             ) {
388             _status = true;
389         }
390     } 
391     function validatePrograms(uint256[] _programs) private view returns(bool _status)
392     {
393         _status = true;
394         for(uint256 idx = 0; idx < _programs.length; idx++) {
395             if (_programs[idx] != 0 && _programs[idx] != 1) _status = false;
396         }
397     }
398     function canAttack(address _addr) private view returns(bool _canAtk)
399     {
400         if ( 
401             players[_addr].endTimeUnequalledDef < now &&
402             Engineer.calCurrentCrystals(_addr) >= 5000
403             ) {
404             _canAtk = true;
405         }
406     }
407     // --------------------------------------------------------------------------------------------------------------
408     // CALL FUNCTION
409     // --------------------------------------------------------------------------------------------------------------
410     function getData(address _addr) 
411     public
412     view
413     returns(
414         uint256 _virusDef,
415         uint256 _nextTimeAtk,
416         uint256 _endTimeUnequalledDef,
417         bool    _canAtk,
418         // engineer
419         uint256 _currentVirus, 
420         // mingin war
421         uint256 _currentCrystals
422     ) {
423         Player memory p      = players[_addr];
424         _virusDef            = SafeMath.div(p.virusDef, VIRUS_MINING_PERIOD);
425         _nextTimeAtk         = p.nextTimeAtk;
426         _endTimeUnequalledDef= p.endTimeUnequalledDef;
427         _currentVirus        = SafeMath.div(Engineer.calCurrentVirus(_addr), VIRUS_MINING_PERIOD);
428         _currentCrystals     = Engineer.calCurrentCrystals(_addr);
429         _canAtk              = canAttack(_addr);
430     }
431     // --------------------------------------------------------------------------------------------------------------
432     // INTERNAL FUNCTION
433     // --------------------------------------------------------------------------------------------------------------
434     function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private view returns(uint256)
435     {
436         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
437     }
438 }