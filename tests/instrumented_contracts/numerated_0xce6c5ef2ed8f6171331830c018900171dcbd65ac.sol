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
55     uint256 public deadline; 
56     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
57     function addCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
58 }
59 interface CryptoEngineerInterface {
60     function addVirus(address /*_addr*/, uint256 /*_value*/) external pure;
61     function subVirus(address /*_addr*/, uint256 /*_value*/) external pure;
62 
63     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/);
64     function calculateCurrentVirus(address /*_addr*/) external view returns(uint256 /*_currentVirus*/);
65     function calCurrentCrystals(address /*_addr*/) external pure returns(uint256 /*_currentCrystals*/);
66 }
67 interface CryptoProgramFactoryInterface {
68     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
69 
70     function subPrograms(address /*_addr*/, uint256[] /*_programs*/) external;
71     function getData(address _addr) external pure returns(uint256 /*_factoryLevel*/, uint256 /*_factoryTime*/, uint256[] /*memory _programs*/);
72      function getProgramsValue() external pure returns(uint256[]);
73 }
74 interface MiniGameInterface {
75     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
76     function fallback() external payable;
77 }
78 contract CrryptoArena {
79 	using SafeMath for uint256;
80 
81 	address public administrator;
82 
83     uint256 public VIRUS_NORMAL = 0;
84     uint256 public HALF_TIME_ATK= 60 * 15;  
85     uint256 public CRTSTAL_MINING_PERIOD = 86400;
86     uint256 public VIRUS_MINING_PERIOD   = 86400;
87    
88     CryptoMiningWarInterface      public MiningWar;
89     CryptoEngineerInterface       public Engineer;
90     CryptoProgramFactoryInterface public Factory;
91 
92     uint256 miningWarDeadline;
93     // factory info
94     // player info
95     mapping(address => Player) public players;
96 
97     mapping(uint256 => Virus)  public viruses;
98      // minigame info
99     mapping(address => bool)   public miniGames; 
100    
101     struct Player {
102         uint256 virusDef;
103         uint256 nextTimeAtk;
104         uint256 endTimeUnequalledDef;
105     }
106     struct Virus {
107         uint256 atk;
108         uint256 def;
109     }
110     modifier isAdministrator()
111     {
112         require(msg.sender == administrator);
113         _;
114     }
115     modifier onlyContractsMiniGame() 
116     {
117         require(miniGames[msg.sender] == true);
118         _;
119     }
120     event Attack(address atkAddress, address defAddress, bool victory, uint256 reward, uint256 virusAtkDead, uint256 virusDefDead, uint256 atk, uint256 def, uint256 round); // 1 : crystals, 2: hashrate, 3: virus
121     event Programs(uint256 programLv1, uint256 programLv2, uint256 programLv3, uint256 programLv4);
122 
123     constructor() public {
124         administrator = msg.sender;
125         // set interface contract
126         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
127         setEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
128         setFactoryInterface(0x6fa883afde9bc8d9bec0fc7bff25db3c71864402);
129 
130          // setting virusupd
131         viruses[VIRUS_NORMAL] = Virus(1,1);
132     }
133     function () public payable
134     {
135         
136     }
137     /** 
138     * @dev MainContract used this function to verify game's contract
139     */
140     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
141     {
142     	_isContractMiniGame = true;
143     }
144     function upgrade(address addr) public isAdministrator
145     {
146         selfdestruct(addr);
147     }
148     /** 
149     * @dev Main Contract call this function to setup mini game.
150     */
151     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
152     {
153         miningWarDeadline = _miningWarDeadline;   
154     }
155     //--------------------------------------------------------------------------
156     // SETTING CONTRACT MINI GAME 
157     //--------------------------------------------------------------------------
158     function setContractsMiniGame( address _addr ) public isAdministrator 
159     {
160         MiniGameInterface MiniGame = MiniGameInterface( _addr );
161         if( MiniGame.isContractMiniGame() == false ) revert(); 
162 
163         miniGames[_addr] = true;
164     }
165     /**
166     * @dev remove mini game contract from main contract
167     * @param _addr mini game contract address
168     */
169     function removeContractMiniGame(address _addr) public isAdministrator
170     {
171         miniGames[_addr] = false;
172     }
173     // ---------------------------------------------------------------------------------------
174     // SET INTERFACE CONTRACT
175     // ---------------------------------------------------------------------------------------
176     
177     function setMiningWarInterface(address _addr) public isAdministrator
178     {
179         MiningWar = CryptoMiningWarInterface(_addr);
180     }
181     function setEngineerInterface(address _addr) public isAdministrator
182     {
183         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
184         
185         require(engineerInterface.isContractMiniGame() == true);
186 
187         Engineer = engineerInterface;
188     }
189     
190     function setFactoryInterface(address _addr) public isAdministrator
191     {
192         CryptoProgramFactoryInterface factoryInterface = CryptoProgramFactoryInterface(_addr);
193         
194         require(factoryInterface.isContractMiniGame() == true);
195 
196         Factory = factoryInterface;
197     }
198 
199     // --------------------------------------------------------------------------------------------------------------
200     // FUCTION FOR NEXT VERSION
201     // --------------------------------------------------------------------------------------------------------------
202     /**
203     * @dev additional time unequalled defence 
204     * @param _addr player address 
205     */
206     function setAtkNowForPlayer(address _addr) public onlyContractsMiniGame
207     {
208         Player storage p = players[_addr];
209         p.nextTimeAtk = now;
210     }
211     function addVirusDef(address _addr, uint256 _virus) public
212     {
213         require(miniGames[msg.sender] == true || msg.sender == _addr);
214 
215         Engineer.subVirus(_addr, _virus);
216 
217         Player storage p = players[_addr];
218 
219         p.virusDef += SafeMath.mul(_virus, VIRUS_MINING_PERIOD);
220     }
221     function subVirusDef(address _addr, uint256 _virus) public onlyContractsMiniGame
222     {        
223         _virus = SafeMath.mul(_virus, VIRUS_MINING_PERIOD);
224         require(players[_addr].virusDef >= _virus);
225 
226         Player storage p = players[_addr];
227 
228         p.virusDef -= _virus;
229     }
230     function addTimeUnequalledDefence(address _addr, uint256 _value) public onlyContractsMiniGame
231     {
232         Player storage p = players[_addr];
233         uint256 currentTimeUnequalled = p.endTimeUnequalledDef;
234         if (currentTimeUnequalled < now) currentTimeUnequalled = now;
235         
236         p.endTimeUnequalledDef = SafeMath.add(currentTimeUnequalled, _value);
237     }
238     // --------------------------------------------------------------------------------------------------------------
239     // MAIN CONTENT
240     // --------------------------------------------------------------------------------------------------------------
241     function setVirusInfo(uint256 _atk, uint256 _def) public isAdministrator
242     {
243         Virus storage v = viruses[VIRUS_NORMAL];
244         v.atk = _atk;
245         v.def = _def;
246     }
247 
248 
249     /**
250     * @dev start the mini game
251     */
252     function startGame() public 
253     {
254         require(msg.sender == administrator);
255         require(miningWarDeadline == 0);
256         
257         miningWarDeadline = MiningWar.deadline();
258     }
259     /**
260     * @dev ATTACK
261     * _programs[0]: + 10% _virus;
262     * _programs[1]: revival 15 % _virus if this atk lose(not use item before)
263     * _programs[2]: + 20% dame
264     * _programs[3]: -5% virus defence of player you want attack
265     */
266     function attack(address _defAddress, uint256 _virus, uint256[] _programs) public
267     {
268         require(validateAttack(msg.sender, _defAddress) == true);
269         require(_programs.length == 4);
270         require(validatePrograms(_programs) == true);
271 
272         Factory.subPrograms(msg.sender, _programs);
273 
274         Engineer.subVirus(msg.sender, _virus);
275 
276         uint256[] memory programsValue = Factory.getProgramsValue(); 
277 
278         bool victory;
279         uint256 atk;
280         uint256 def;
281         uint256 virusAtkDead;
282         uint256 virusDefDead;   
283         
284         (victory, atk, def, virusAtkDead, virusDefDead) = firstAttack(_defAddress, SafeMath.mul(_virus, VIRUS_MINING_PERIOD), _programs, programsValue);
285 
286         endAttack(_defAddress, victory, SafeMath.div(virusAtkDead, VIRUS_MINING_PERIOD), SafeMath.div(virusDefDead, VIRUS_MINING_PERIOD), atk, def, 1, _programs);
287 
288         if (_programs[1] == 1 && victory == false)  
289             againAttack(_defAddress, SafeMath.div(SafeMath.mul(SafeMath.mul(_virus, VIRUS_MINING_PERIOD), programsValue[1]), 100)); // revival 15 % _virus if this atk lose(not use item before)
290 
291         players[msg.sender].nextTimeAtk = now + HALF_TIME_ATK;
292     }
293     function firstAttack(address _defAddress, uint256 _virus, uint256[] _programs, uint256[] programsValue) 
294     private 
295     returns(
296         bool victory,
297         uint256 atk,
298         uint256 def,
299         uint256 virusAtkDead,
300         uint256 virusDefDead        
301         )
302     {
303         Player storage pDef = players[_defAddress];
304 
305         atk             = _virus; 
306         uint256 rateAtk = 50 + randomNumber(msg.sender, 1, 101);
307         uint256 rateDef = 50 + randomNumber(_defAddress, rateAtk, 101);
308 
309         if (_programs[0] == 1) // + 10% _virus;
310             atk += SafeMath.div(SafeMath.mul(atk, programsValue[0]), 100); 
311         if (_programs[3] == 1) // -5% virus defence of player you want attack
312             pDef.virusDef = SafeMath.sub(pDef.virusDef, SafeMath.div(SafeMath.mul(pDef.virusDef, programsValue[3]), 100)); 
313             
314         atk = SafeMath.div(SafeMath.mul(SafeMath.mul(atk, viruses[VIRUS_NORMAL].atk), rateAtk), 100);
315         def = SafeMath.div(SafeMath.mul(SafeMath.mul(pDef.virusDef, viruses[VIRUS_NORMAL].def), rateDef), 100);
316 
317         if (_programs[2] == 1)  //+ 20% dame
318             atk += SafeMath.div(SafeMath.mul(atk, programsValue[2]), 100);
319 
320         if (atk >= def) {
321             virusAtkDead = SafeMath.min(_virus, SafeMath.div(SafeMath.mul(def, 100), SafeMath.mul(viruses[VIRUS_NORMAL].atk, rateAtk)));
322             virusDefDead = pDef.virusDef;
323             victory      = true;
324         } else {
325             virusAtkDead = _virus;
326             virusDefDead = SafeMath.min(pDef.virusDef, SafeMath.div(SafeMath.mul(atk, 100), SafeMath.mul(viruses[VIRUS_NORMAL].def, rateDef)));
327         }
328 
329         pDef.virusDef = SafeMath.sub(pDef.virusDef, virusDefDead);
330 
331         if (_virus > virusAtkDead) 
332             Engineer.addVirus(msg.sender, SafeMath.div(SafeMath.sub(_virus, virusAtkDead), VIRUS_MINING_PERIOD));
333 
334     }
335     function againAttack(address _defAddress, uint256 _virus) private returns(bool victory)
336     {
337         Player storage pDef = players[_defAddress];
338         // virus normal info
339         Virus memory v = viruses[VIRUS_NORMAL];
340 
341         uint256 rateAtk = 50 + randomNumber(msg.sender, 1, 101);
342         uint256 rateDef = 50 + randomNumber(_defAddress, rateAtk, 101);
343 
344         uint256 atk = SafeMath.div(SafeMath.mul(SafeMath.mul(_virus, v.atk), rateAtk), 100);
345         uint256 def = SafeMath.div(SafeMath.mul(SafeMath.mul(pDef.virusDef, v.def), rateDef), 100);
346         uint256 virusDefDead = 0;
347         uint256[] memory programs;
348         if (atk >= def) {
349             virusDefDead = pDef.virusDef;
350             victory = true;
351         } else {
352             virusDefDead = SafeMath.min(pDef.virusDef, SafeMath.div(SafeMath.mul(atk, 100), SafeMath.mul(v.def, rateDef)));
353         }
354 
355         pDef.virusDef = SafeMath.sub(pDef.virusDef, virusDefDead);
356 
357         endAttack(_defAddress, victory, 0,  SafeMath.div(virusDefDead, VIRUS_MINING_PERIOD), atk, def, 2, programs);
358     }
359     function endAttack(address _defAddress, bool victory, uint256 virusAtkDead, uint256 virusDefDead, uint256 atk, uint256 def, uint256 round, uint256[] programs) private 
360     {
361         uint256 reward = 0;
362         if (victory == true) {
363             uint256 pDefCrystals = Engineer.calCurrentCrystals(_defAddress);
364             // subtract random 10% to 50% current crystals of player defence
365             uint256 rate = 10 + randomNumber(_defAddress, pDefCrystals, 41);
366             reward = SafeMath.div(SafeMath.mul(pDefCrystals, rate),100);
367 
368             if (reward > 0) {
369                 MiningWar.subCrystal(_defAddress, reward);    
370                 MiningWar.addCrystal(msg.sender, reward);
371             }
372         }
373         emit Attack(msg.sender, _defAddress, victory, reward, virusAtkDead, virusDefDead, atk, def, round);
374         if (round == 1) emit Programs( programs[0], programs[1], programs[2], programs[3]);
375     }
376     function validateAttack(address _atkAddress, address _defAddress) private view returns(bool _status) 
377     {
378         if (
379             _atkAddress != _defAddress &&
380             players[_atkAddress].nextTimeAtk <= now &&
381             canAttack(_defAddress) == true
382             ) {
383             _status = true;
384         }
385     } 
386     function validatePrograms(uint256[] _programs) private view returns(bool _status)
387     {
388         _status = true;
389         for(uint256 idx = 0; idx < _programs.length; idx++) {
390             if (_programs[idx] != 0 && _programs[idx] != 1) _status = false;
391         }
392     }
393     function canAttack(address _addr) private view returns(bool _canAtk)
394     {
395         if ( 
396             players[_addr].endTimeUnequalledDef < now &&
397             Engineer.calCurrentCrystals(_addr) >= 5000
398             ) {
399             _canAtk = true;
400         }
401     }
402     // --------------------------------------------------------------------------------------------------------------
403     // CALL FUNCTION
404     // --------------------------------------------------------------------------------------------------------------
405     function getData(address _addr) 
406     public
407     view
408     returns(
409         uint256 _virusDef,
410         uint256 _nextTimeAtk,
411         uint256 _endTimeUnequalledDef,
412         bool    _canAtk,
413         // engineer
414         uint256 _currentVirus, 
415         // mingin war
416         uint256 _currentCrystals
417     ) {
418         Player memory p      = players[_addr];
419         _virusDef            = SafeMath.div(p.virusDef, VIRUS_MINING_PERIOD);
420         _nextTimeAtk         = p.nextTimeAtk;
421         _endTimeUnequalledDef= p.endTimeUnequalledDef;
422         _currentVirus        = SafeMath.div(Engineer.calculateCurrentVirus(_addr), VIRUS_MINING_PERIOD);
423         _currentCrystals     = Engineer.calCurrentCrystals(_addr);
424         _canAtk              = canAttack(_addr);
425     }
426     // --------------------------------------------------------------------------------------------------------------
427     // INTERNAL FUNCTION
428     // --------------------------------------------------------------------------------------------------------------
429     function randomNumber(address _addr, uint256 randNonce, uint256 _maxNumber) private view returns(uint256)
430     {
431         return uint256(keccak256(abi.encodePacked(now, _addr, randNonce))) % _maxNumber;
432     }
433 }