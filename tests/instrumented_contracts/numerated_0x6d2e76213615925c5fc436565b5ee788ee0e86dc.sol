1 pragma solidity ^0.4.17;
2 
3 contract AccessControl {
4     address public creatorAddress;
5     uint16 public totalSeraphims = 0;
6     mapping (address => bool) public seraphims;
7 
8     bool public isMaintenanceMode = true;
9  
10     modifier onlyCREATOR() {
11         require(msg.sender == creatorAddress);
12         _;
13     }
14 
15     modifier onlySERAPHIM() {
16         require(seraphims[msg.sender] == true);
17         _;
18     }
19     
20     modifier isContractActive {
21         require(!isMaintenanceMode);
22         _;
23     }
24     
25     // Constructor
26     function AccessControl() public {
27         creatorAddress = msg.sender;
28     }
29     
30 
31     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
32         if (seraphims[_newSeraphim] == false) {
33             seraphims[_newSeraphim] = true;
34             totalSeraphims += 1;
35         }
36     }
37     
38     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
39         if (seraphims[_oldSeraphim] == true) {
40             seraphims[_oldSeraphim] = false;
41             totalSeraphims -= 1;
42         }
43     }
44 
45     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
46         isMaintenanceMode = _isMaintaining;
47     }
48 
49   
50 } 
51 contract SafeMath {
52     function safeAdd(uint x, uint y) pure internal returns(uint) {
53       uint z = x + y;
54       assert((z >= x) && (z >= y));
55       return z;
56     }
57 
58     function safeSubtract(uint x, uint y) pure internal returns(uint) {
59       assert(x >= y);
60       uint z = x - y;
61       return z;
62     }
63 
64     function safeMult(uint x, uint y) pure internal returns(uint) {
65       uint z = x * y;
66       assert((x == 0)||(z/x == y));
67       return z;
68     }
69 
70     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
71         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
72         return uint8(genNum % (maxRandom - min + 1)+min);
73     }
74 }
75 
76 contract Enums {
77     enum ResultCode {
78         SUCCESS,
79         ERROR_CLASS_NOT_FOUND,
80         ERROR_LOW_BALANCE,
81         ERROR_SEND_FAIL,
82         ERROR_NOT_OWNER,
83         ERROR_NOT_ENOUGH_MONEY,
84         ERROR_INVALID_AMOUNT
85     }
86 
87     enum AngelAura { 
88         Blue, 
89         Yellow, 
90         Purple, 
91         Orange, 
92         Red, 
93         Green 
94     }
95 }
96 
97 contract IAngelCardData is AccessControl, Enums {
98     uint8 public totalAngelCardSeries;
99     uint64 public totalAngels;
100 
101     
102     // write
103     // angels
104     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
105     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
106     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
107     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
108     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
109     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
110     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
111     function addAngelIdMapping(address _owner, uint64 _angelId) private;
112     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
113     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
114     function updateAngelLock (uint64 _angelId, bool newValue) public;
115     function removeCreator() onlyCREATOR external;
116 
117     // read
118     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
119     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
120     function getOwnerAngelCount(address _owner) constant public returns(uint);
121     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
122     function getTotalAngelCardSeries() constant public returns (uint8);
123     function getTotalAngels() constant public returns (uint64);
124     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
125 }
126 
127 contract AngelCardData is IAngelCardData, SafeMath {
128     /*** EVENTS ***/
129     event CreatedAngel(uint64 angelId);
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /*** DATA TYPES ***/
133     struct AngelCardSeries {
134         uint8 angelCardSeriesId;
135         uint basePrice; 
136         uint64 currentAngelTotal;
137         uint64 maxAngelTotal;
138         AngelAura baseAura;
139         uint baseBattlePower;
140         uint64 lastSellTime;
141         uint64 liveTime;
142     }
143 
144     struct Angel {
145         uint64 angelId;
146         uint8 angelCardSeriesId;
147         address owner;
148         uint16 battlePower;
149         AngelAura aura;
150         uint16 experience;
151         uint price;
152         uint64 createdTime;
153         uint64 lastBattleTime;
154         uint64 lastVsBattleTime;
155         uint16 lastBattleResult;
156         bool ownerLock;
157     }
158 
159     /*** STORAGE ***/
160 
161     mapping(uint8 => AngelCardSeries) public angelCardSeriesCollection;
162     mapping(uint64 => Angel) public angelCollection;
163     mapping(address => uint64[]) public ownerAngelCollection;
164     uint256 public prevSeriesSelloutHours;
165     
166     /*** FUNCTIONS ***/
167     //*** Write Access ***//
168     function AngelCardData() public {
169         
170     }
171   
172 
173     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8) {
174          if ((now > 1517189201) || (totalAngelCardSeries >= 24)) {revert();}
175         //This confirms that no one, even the develoopers, can create any angel series after JAN/29/2018 @ 1:26 am (UTC) or more than the original 24 series.
176 
177         AngelCardSeries storage angelCardSeries = angelCardSeriesCollection[_angelCardSeriesId];
178         angelCardSeries.angelCardSeriesId = _angelCardSeriesId;
179         angelCardSeries.basePrice = _basePrice; 
180         angelCardSeries.maxAngelTotal = _maxTotal;
181         angelCardSeries.baseAura = AngelAura(_baseAura);
182         angelCardSeries.baseBattlePower = _baseBattlePower;
183         angelCardSeries.lastSellTime = 0;
184         angelCardSeries.liveTime = _liveTime;
185 
186         totalAngelCardSeries += 1;
187         return totalAngelCardSeries;
188     }
189 
190   // This is called every 5 days to set the basePrice and maxAngelTotal for the angel series based on buy pressure of the last card
191     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external {
192         // Require that the series is above the Arel card
193         if (_angelCardSeriesId < 4) {revert();}
194         //(The orginal, powerful series can't be altered. 
195         if ((_newMaxTotal <45) || (_newMaxTotal >450)) {revert();}
196        //series can only be adjusted within a certain narrow range. 
197         AngelCardSeries storage seriesStorage = angelCardSeriesCollection[_angelCardSeriesId];
198         seriesStorage.maxAngelTotal = _newMaxTotal;
199        seriesStorage.basePrice = _newPrice;
200         seriesStorage.lastSellTime = uint64(now);
201     }
202 
203 
204 
205     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64) {
206         AngelCardSeries storage series = angelCardSeriesCollection[_angelCardSeriesId];
207     
208         if (series.currentAngelTotal >= series.maxAngelTotal) {
209             revert();
210         }
211        else { 
212         totalAngels += 1;
213         Angel storage angel = angelCollection[totalAngels];
214         series.currentAngelTotal += 1;
215         series.lastSellTime = uint64(now);
216         angel.angelId = totalAngels;
217         angel.angelCardSeriesId = _angelCardSeriesId;
218         angel.owner = _owner;
219         angel.battlePower = _battlePower; 
220         angel.aura = series.baseAura;
221         angel.experience = 0;
222         angel.price = _price;
223         angel.createdTime = uint64(now);
224         angel.lastBattleTime = 0;
225         angel.lastVsBattleTime = 0;
226         angel.lastBattleResult = 0;
227         addAngelIdMapping(_owner, angel.angelId);
228         angel.ownerLock = true;
229         return angel.angelId;
230        }
231     }
232      
233     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external {
234         Angel storage angel = angelCollection[_angelId];
235         if (angel.angelId == _angelId) {
236             angel.experience = uint16(safeAdd(angel.experience, _value));
237         }
238     }
239 
240     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external {
241         Angel storage angel = angelCollection[_angelId];
242         if (angel.angelId == _angelId) {
243             angel.lastBattleTime = uint64(now);
244         }
245     }
246 
247     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external {
248         Angel storage angel = angelCollection[_angelId];
249         if (angel.angelId == _angelId) {
250             angel.lastVsBattleTime = uint64(now);
251         }
252     }
253 
254     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external {
255         Angel storage angel = angelCollection[_angelId];
256         if (angel.angelId == _angelId) {
257             angel.lastBattleResult = _value;
258         }
259     }
260     
261     function addAngelIdMapping(address _owner, uint64 _angelId) private {
262             uint64[] storage owners = ownerAngelCollection[_owner];
263             owners.push(_angelId);
264             Angel storage angel = angelCollection[_angelId];
265             angel.owner = _owner;
266     }
267 //Anyone can transfer their own angel by sending a transaction with the address to transfer to from the address that owns it. 
268     function ownerAngelTransfer (address _to, uint64 _angelId)  public  {
269         
270        if ((_angelId > totalAngels) || (_angelId == 0)) {revert();}
271        Angel storage angel = angelCollection[_angelId];
272         if (msg.sender == _to) {revert();}
273         if (angel.owner != msg.sender) {
274             revert();
275         }
276         else {
277         angel.owner = _to;
278         addAngelIdMapping(_to, _angelId);
279         }
280     }
281     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode) {
282         Angel storage angel = angelCollection[_angelId];
283         if (_from == _to) {revert();}
284         if (angel.ownerLock == true) {revert();} //must be unlocked before transfering. 
285         if (angel.owner != _from) {
286             return ResultCode.ERROR_NOT_OWNER;
287         }
288         angel.owner = _to;
289         addAngelIdMapping(_to, _angelId);
290         angel.ownerLock = true;
291         return ResultCode.SUCCESS;
292     }
293 
294       function updateAngelLock (uint64 _angelId, bool newValue) public {
295         if ((_angelId > totalAngels) || (_angelId == 0)) {revert();}
296         Angel storage angel = angelCollection[_angelId];
297         if (angel.owner != msg.sender) { revert();}
298         angel.ownerLock = newValue;
299     }
300     
301     function removeCreator() onlyCREATOR external {
302         //this function is meant to be called once all modules for the game are in place. It will remove our ability to add any new modules and make the game fully decentralized. 
303         creatorAddress = address(0);
304     }
305    
306     //*** Read Access ***//
307     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime) {
308         AngelCardSeries memory series = angelCardSeriesCollection[_angelCardSeriesId];
309         angelCardSeriesId = series.angelCardSeriesId;
310         currentAngelTotal = series.currentAngelTotal;
311         basePrice = series.basePrice;
312         maxAngelTotal = series.maxAngelTotal;
313         baseAura = uint8(series.baseAura);
314         baseBattlePower = series.baseBattlePower;
315         lastSellTime = series.lastSellTime;
316         liveTime = series.liveTime;
317     }
318 
319 
320     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner) {
321         Angel memory angel = angelCollection[_angelId];
322         angelId = angel.angelId;
323         angelCardSeriesId = angel.angelCardSeriesId;
324         battlePower = angel.battlePower;
325         aura = uint8(angel.aura);
326         experience = angel.experience;
327         price = angel.price;
328         createdTime = angel.createdTime;
329         lastBattleTime = angel.lastBattleTime;
330         lastVsBattleTime = angel.lastVsBattleTime;
331         lastBattleResult = angel.lastBattleResult;
332         owner = angel.owner;
333     }
334 
335     function getOwnerAngelCount(address _owner) constant public returns(uint) {
336         return ownerAngelCollection[_owner].length;
337     }
338     
339     function getAngelLockStatus(uint64 _angelId) constant public returns (bool) {
340         if ((_angelId > totalAngels) || (_angelId == 0)) {revert();}
341        Angel storage angel = angelCollection[_angelId];
342        return angel.ownerLock;
343     }
344     
345 
346     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64) {
347         if (_index >= ownerAngelCollection[_owner].length) {
348             return 0; }
349         return ownerAngelCollection[_owner][_index];
350     }
351 
352     function getTotalAngelCardSeries() constant public returns (uint8) {
353         return totalAngelCardSeries;
354     }
355 
356     function getTotalAngels() constant public returns (uint64) {
357         return totalAngels;
358     }
359 }