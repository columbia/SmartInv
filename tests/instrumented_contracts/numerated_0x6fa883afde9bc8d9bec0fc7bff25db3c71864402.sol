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
54 contract CryptoEngineerInterface {
55     uint256 public prizePool = 0;
56     address public gameSponsor;
57 
58     function subVirus(address /*_addr*/, uint256 /*_value*/) public pure {}
59     function claimPrizePool(address /*_addr*/, uint256 /*_value*/) public pure {} 
60     function isContractMiniGame() public pure returns( bool /*_isContractMiniGame*/) {}
61     function fallback() external payable {}
62 }
63 contract CryptoMiningWarInterface {
64     uint256 public deadline; 
65     function subCrystal( address /*_addr*/, uint256 /*_value*/ ) public pure {}
66 }
67 contract MemoryFactoryInterface {
68     uint256 public factoryTotal;
69 
70     function setFactoryToal(uint256 /*_value*/) public {}
71     function updateFactory(address /*_addr*/, uint256 /*_levelUp*/, uint256 /*_time*/) public {}
72     function updateLevel(address /*_addr*/) public {}
73     function addProgram(address /*_addr*/, uint256 /*_idx*/, uint256 /*_program*/) public {}
74     function subProgram(address /*_addr*/, uint256 /*_idx*/, uint256 /*_program*/) public {}
75 
76     function getPrograms(address /*_addr*/) public view returns(uint256[]) {}
77     function getLevel(address /*_addr*/) public view returns(uint256 /*_level*/) {}
78     function getData(address /*_addr*/) public view returns(uint256 /*_level*/, uint256 /*_updateTime*/, uint256[] /*_programs*/) {} 
79 }
80 interface MiniGameInterface {
81     function isContractMiniGame() external pure returns( bool _isContractMiniGame );
82     function fallback() external payable;
83 }
84 contract CryptoProgramFactory {
85 	using SafeMath for uint256;
86 
87 	address public administrator;
88 
89     uint256 private BASE_PRICE   = 0.1 ether; 
90     uint256 private BASE_TIME    = 4 hours; 
91 
92     MemoryFactoryInterface   public Memory;
93     CryptoMiningWarInterface public MiningWar;
94     CryptoEngineerInterface  public Engineer;
95 
96     uint256 public miningWarDeadline;
97     // factory info
98     mapping(uint256 => Factory) public factories; 
99     // minigame info
100     mapping(address => bool)    public miniGames; 
101    
102     struct Factory {
103         uint256 level;
104         uint256 crystals;
105         uint256 programPriceByCrystals;
106         uint256 programPriceByDarkCrystals;
107         uint256 programValue; // example with level one can more 15% virus an arena(programValue = 15);
108         uint256 eth;
109         uint256 time;
110     }
111     modifier isAdministrator()
112     {
113         require(msg.sender == administrator);
114         _;
115     }
116     modifier onlyContractsMiniGame() 
117     {
118         require(miniGames[msg.sender] == true);
119         _;
120     }
121     event UpdateFactory(address _addr, uint256 _crystals, uint256 _eth, uint256 _levelUp, uint256 _updateTime);
122     event BuyProgarams(address _addr, uint256 _crystals, uint256 _darkCrystals, uint256[] _programs);
123     constructor() public {
124         administrator = msg.sender;
125         // set interface contract
126         setMiningWarInterface(0xf84c61bb982041c030b8580d1634f00fffb89059);
127         setEngineerInterface(0x69fd0e5d0a93bf8bac02c154d343a8e3709adabf);
128         setMemoryInterface(0xa2e6461e7a109ae070b9b064ca9448b301404784);
129     }
130     function initFactory() private 
131     {       
132         //                  level crystals programPriceByCrystals programPriceByDarkCrystals programValue ether            time                
133         factories[0] = Factory(1, 100000,         10000,           0,                         10           ,BASE_PRICE * 0, BASE_TIME * 1);
134         factories[1] = Factory(2, 500000,         20000,           0,                         15           ,BASE_PRICE * 1, BASE_TIME * 2);
135         factories[2] = Factory(3, 1500000,        40000,           0,                         20           ,BASE_PRICE * 4, BASE_TIME * 3);
136         factories[3] = Factory(4, 3000000,        80000,           0,                         5            ,BASE_PRICE * 5, BASE_TIME * 6);
137 
138         Memory.setFactoryToal(4);
139     }
140     function () public payable
141     {
142         
143     }
144     /** 
145     * @dev MainContract used this function to verify game's contract
146     */
147     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
148     {
149     	_isContractMiniGame = true;
150     }
151     function upgrade(address addr) public isAdministrator
152     {
153         selfdestruct(addr);
154     }
155     /** 
156     * @dev Main Contract call this function to setup mini game.
157     */
158     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 _miningWarDeadline ) public
159     {
160         miningWarDeadline = _miningWarDeadline;   
161     }
162     // ---------------------------------------------------------------------------------------
163     // SET INTERFACE CONTRACT
164     // ---------------------------------------------------------------------------------------
165     
166     function setMemoryInterface(address _addr) public isAdministrator
167     {
168         Memory = MemoryFactoryInterface(_addr);
169     }
170     function setMiningWarInterface(address _addr) public isAdministrator
171     {
172         MiningWar = CryptoMiningWarInterface(_addr);
173     }
174     function setEngineerInterface(address _addr) public isAdministrator
175     {
176         CryptoEngineerInterface engineerInterface = CryptoEngineerInterface(_addr);
177         
178         require(engineerInterface.isContractMiniGame() == true);
179 
180         Engineer = engineerInterface;
181     }    
182     //--------------------------------------------------------------------------
183     // SETTING CONTRACT MINI GAME 
184     //--------------------------------------------------------------------------
185     function setContractMiniGame( address _contractAddress ) public isAdministrator 
186     {
187         MiniGameInterface MiniGame = MiniGameInterface( _contractAddress );
188         if( MiniGame.isContractMiniGame() == false ) { revert(); }
189 
190         miniGames[_contractAddress] = true;
191     }
192     function removeContractMiniGame(address _contractAddress) public isAdministrator
193     {
194         miniGames[_contractAddress] = false;
195     }
196     //--------------------------------------------------------------------------
197     // SETTING FACTORY  
198     //--------------------------------------------------------------------------
199     function addFactory(
200         uint256 _crystals, 
201         uint256 _programPriceByCrystals,  
202         uint256 _programPriceByDarkCrystals,  
203         uint256 _programValue,  
204         uint256 _eth, 
205         uint256 _time
206     ) public isAdministrator
207     {
208         uint256 factoryTotal = Memory.factoryTotal();
209         factories[factoryTotal] = Factory(factoryTotal +1,_crystals,_programPriceByCrystals,_programPriceByDarkCrystals,_programValue,_eth,_time);
210         factoryTotal += 1;
211         Memory.setFactoryToal(factoryTotal);
212     }
213     function setProgramValue(uint256 _idx, uint256 _value) public isAdministrator
214     {
215         Factory storage f = factories[_idx];// factory update
216         f.programValue = _value;
217     }
218     function setProgramPriceByCrystals(uint256 _idx, uint256 _value) public isAdministrator
219     {
220         Factory storage f = factories[_idx];// factory update
221         f.programPriceByCrystals = _value;
222     }
223     function setProgramPriceByDarkCrystals(uint256 _idx, uint256 _value) public isAdministrator
224     {
225         Factory storage f = factories[_idx];// factory update
226         f.programPriceByDarkCrystals = _value;
227     }
228     // --------------------------------------------------------------------------------------------------------------
229     // MAIN CONTENT
230     // --------------------------------------------------------------------------------------------------------------
231     /**
232     * @dev start the mini game
233     */
234     function startGame() public 
235     {
236         require(msg.sender == administrator);
237         require(miningWarDeadline == 0);
238         
239         miningWarDeadline = MiningWar.deadline();
240 
241         initFactory();
242     }
243     function updateFactory() public payable 
244     {
245         require(miningWarDeadline > now);
246 
247         Memory.updateLevel(msg.sender);
248         
249         Factory memory f = factories[uint256(Memory.getLevel(msg.sender))];// factory update
250 
251         if (msg.value < f.eth) revert();
252 
253         MiningWar.subCrystal(msg.sender, f.crystals);
254 
255         uint256 updateTime = now + f.time;
256         uint256 levelUp     = f.level;
257 
258         Memory.updateFactory(msg.sender, levelUp, updateTime);
259 
260         if (msg.value > 0) {
261             uint256 fee = devFee(msg.value);
262             address gameSponsor = Engineer.gameSponsor();
263             gameSponsor.transfer(fee);
264             administrator.transfer(fee);
265 
266             Engineer.fallback.value(SafeMath.sub(msg.value, 2 * fee));
267         }
268 
269         emit UpdateFactory(msg.sender, f.crystals, msg.value, levelUp, updateTime);
270     }
271 
272     function buyProgarams(uint256[] _programs) public
273     {
274         require(_programs.length <= Memory.factoryTotal());
275         require(miningWarDeadline > now);
276 
277         Memory.updateLevel(msg.sender);
278 
279         uint256 factoryLevel = Memory.getLevel(msg.sender);
280         uint256 crystals = 0;
281         uint256 darkCrystals =0; 
282 
283         for (uint256 idx = 0; idx < _programs.length; idx ++) {
284             Factory memory f = factories[idx];
285             uint256 level = idx + 1;
286             if (_programs[idx] > 0 && factoryLevel < level) revert();
287             if (_programs[idx] > 0) {
288                 crystals     += SafeMath.mul(_programs[idx], f.programPriceByCrystals);
289                 darkCrystals += SafeMath.mul(_programs[idx], f.programPriceByDarkCrystals);
290                 Memory.addProgram(msg.sender, idx, _programs[idx]);
291             }    
292         }
293 
294         if (crystals > 0) MiningWar.subCrystal(msg.sender, crystals);
295         // if (darkCrystals > 0) BossWannaCry.subDarkCrystal(msg.sender, darkCrystals);
296         emit BuyProgarams(msg.sender, crystals, darkCrystals, _programs);
297     }
298     function subPrograms(address _addr, uint256[] _programs) public onlyContractsMiniGame
299     {
300         uint256 factoryTotal = Memory.factoryTotal();
301         require(_programs.length <= factoryTotal);
302 
303         for (uint256 idx = 0; idx < _programs.length; idx++) {
304             if (_programs[idx] > 0) Memory.subProgram(_addr, idx, _programs[idx]);
305         }
306     }
307     function getData(address _addr) 
308     public
309     view
310     returns(
311         uint256   _factoryTotal,
312         uint256   _factoryLevel,
313         uint256   _factoryTime,
314         uint256[] _programs
315     ) {
316         _factoryTotal = Memory.factoryTotal();
317         (_factoryLevel, _factoryTime, _programs) = Memory.getData(_addr);
318     }
319     function getProgramsValue() public view returns(uint256[]) {
320         uint256 factoryTotal = Memory.factoryTotal();
321         uint256[] memory _programsValue = new uint256[](factoryTotal);
322         
323         for(uint256 idx = 0; idx < factoryTotal; idx++) {
324             Factory memory f    = factories[idx];
325             _programsValue[idx] = f.programValue;
326         }
327         return _programsValue;
328     }
329     // INTERFACE
330     // --------------------------------------------------------------------------------------------------------------
331     function devFee(uint256 _amount) private pure returns(uint256)
332     {
333         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
334     }
335   
336 }