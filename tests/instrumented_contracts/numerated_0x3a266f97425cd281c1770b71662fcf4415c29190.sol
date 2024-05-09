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
66     function fallback() external payable {}
67 }
68 contract MemoryFactoryInterface {
69     uint256 public factoryTotal;
70 
71     function setFactoryToal(uint256 /*_value*/) public {}
72     function updateFactory(address /*_addr*/, uint256 /*_levelUp*/, uint256 /*_time*/) public {}
73     function updateLevel(address /*_addr*/) public {}
74     function addProgram(address /*_addr*/, uint256 /*_idx*/, uint256 /*_program*/) public {}
75     function subProgram(address /*_addr*/, uint256 /*_idx*/, uint256 /*_program*/) public {}
76 
77     function getPrograms(address /*_addr*/) public view returns(uint256[]) {}
78     function getLevel(address /*_addr*/) public view returns(uint256 /*_level*/) {}
79     function getData(address /*_addr*/) public view returns(uint256 /*_level*/, uint256 /*_updateTime*/, uint256[] /*_programs*/) {} 
80 }
81 interface MiniGameInterface {
82     function isContractMiniGame() external pure returns( bool _isContractMiniGame );
83     function fallback() external payable;
84 }
85 contract CryptoProgramFactory {
86     bool status = false;
87 	using SafeMath for uint256;
88 
89 	address public administrator;
90 
91     uint256 private BASE_PRICE   = 0.1 ether; 
92     uint256 private BASE_TIME    = 4 hours; 
93 
94     MemoryFactoryInterface   public Memory;
95     CryptoMiningWarInterface public MiningWar;
96     CryptoEngineerInterface  public Engineer;
97 
98     // factory info
99     mapping(uint256 => Factory) public factories; 
100     // minigame info
101     mapping(address => bool)    public miniGames; 
102    
103     struct Factory {
104         uint256 level;
105         uint256 crystals;
106         uint256 programPriceByCrystals;
107         uint256 programPriceByDarkCrystals;
108         uint256 programValue; // example with level one can more 15% virus an arena(programValue = 15);
109         uint256 eth;
110         uint256 time;
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
122     event UpdateFactory(address _addr, uint256 _crystals, uint256 _eth, uint256 _levelUp, uint256 _updateTime);
123     event BuyProgarams(address _addr, uint256 _crystals, uint256 _darkCrystals, uint256[] _programs);
124     constructor() public {
125         administrator = msg.sender;
126         // set interface contract
127         setMiningWarInterface(0x65c347702b66ff8f1a28cf9a9768487fbe97765f);
128         setEngineerInterface(0xb2d6000d4a7fe8b1358d54a9bc21f2badf91d849);
129         setMemoryInterface(0x5de9c80c15f39a711e2a6607642820be648e5695);
130     }
131     function initFactory() private 
132     {       
133         //                  level crystals programPriceByCrystals programPriceByDarkCrystals programValue ether            time                
134         factories[0] = Factory(1, 100000,         10000,           0,                         10           ,BASE_PRICE * 0, BASE_TIME * 1);
135         factories[1] = Factory(2, 500000,         20000,           0,                         15           ,BASE_PRICE * 1, BASE_TIME * 2);
136         factories[2] = Factory(3, 1500000,        40000,           0,                         20           ,BASE_PRICE * 4, BASE_TIME * 3);
137         factories[3] = Factory(4, 3000000,        80000,           0,                         5            ,BASE_PRICE * 5, BASE_TIME * 6);
138 
139         Memory.setFactoryToal(4);
140     }
141     function () public payable
142     {
143         
144     }
145     /** 
146     * @dev MainContract used this function to verify game's contract
147     */
148     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
149     {
150     	_isContractMiniGame = true;
151     }
152     function upgrade(address addr) public isAdministrator
153     {
154         selfdestruct(addr);
155     }
156     /** 
157     * @dev Main Contract call this function to setup mini game.
158     */
159     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/ ) public
160     {
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
237         require(status == false);
238         
239         status = true;
240 
241         initFactory();
242     }
243     function updateFactory() public payable 
244     {
245 
246         Memory.updateLevel(msg.sender);
247         
248         Factory memory f = factories[uint256(Memory.getLevel(msg.sender))];// factory update
249 
250         if (msg.value < f.eth) revert();
251 
252         MiningWar.subCrystal(msg.sender, f.crystals);
253 
254         uint256 updateTime = now + f.time;
255         uint256 levelUp     = f.level;
256 
257         Memory.updateFactory(msg.sender, levelUp, updateTime);
258 
259         if (msg.value > 0) {
260             uint256 fee = devFee(msg.value);
261             address gameSponsor = Engineer.gameSponsor();
262             gameSponsor.transfer(fee);
263             administrator.transfer(fee);
264 
265             MiningWar.fallback.value(fee)();
266             Engineer.fallback.value(SafeMath.sub(msg.value, 3 * fee))();
267         }
268 
269         emit UpdateFactory(msg.sender, f.crystals, msg.value, levelUp, updateTime);
270     }
271 
272     function buyProgarams(uint256[] _programs) public
273     {
274         require(_programs.length <= Memory.factoryTotal());
275 
276         Memory.updateLevel(msg.sender);
277 
278         uint256 factoryLevel = Memory.getLevel(msg.sender);
279         uint256 crystals = 0;
280         uint256 darkCrystals =0; 
281 
282         for (uint256 idx = 0; idx < _programs.length; idx ++) {
283             Factory memory f = factories[idx];
284             uint256 level = idx + 1;
285             if (_programs[idx] > 0 && factoryLevel < level) revert();
286             if (_programs[idx] > 0) {
287                 crystals     += SafeMath.mul(_programs[idx], f.programPriceByCrystals);
288                 darkCrystals += SafeMath.mul(_programs[idx], f.programPriceByDarkCrystals);
289                 Memory.addProgram(msg.sender, idx, _programs[idx]);
290             }    
291         }
292 
293         if (crystals > 0) MiningWar.subCrystal(msg.sender, crystals);
294         // if (darkCrystals > 0) BossWannaCry.subDarkCrystal(msg.sender, darkCrystals);
295         emit BuyProgarams(msg.sender, crystals, darkCrystals, _programs);
296     }
297     function subPrograms(address _addr, uint256[] _programs) public onlyContractsMiniGame
298     {
299         uint256 factoryTotal = Memory.factoryTotal();
300         require(_programs.length <= factoryTotal);
301 
302         for (uint256 idx = 0; idx < _programs.length; idx++) {
303             if (_programs[idx] > 0) Memory.subProgram(_addr, idx, _programs[idx]);
304         }
305     }
306     function getData(address _addr) 
307     public
308     view
309     returns(
310         uint256   _factoryTotal,
311         uint256   _factoryLevel,
312         uint256   _factoryTime,
313         uint256[] _programs
314     ) {
315         _factoryTotal = Memory.factoryTotal();
316         (_factoryLevel, _factoryTime, _programs) = Memory.getData(_addr);
317     }
318     function getProgramsValue() public view returns(uint256[]) {
319         uint256 factoryTotal = Memory.factoryTotal();
320         uint256[] memory _programsValue = new uint256[](factoryTotal);
321         
322         for(uint256 idx = 0; idx < factoryTotal; idx++) {
323             Factory memory f    = factories[idx];
324             _programsValue[idx] = f.programValue;
325         }
326         return _programsValue;
327     }
328     // INTERFACE
329     // --------------------------------------------------------------------------------------------------------------
330     function devFee(uint256 _amount) private pure returns(uint256)
331     {
332         return SafeMath.div(SafeMath.mul(_amount, 5), 100);
333     }
334   
335 }