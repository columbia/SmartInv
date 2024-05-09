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
51 
52 contract SafeMath {
53     function safeAdd(uint x, uint y) pure internal returns(uint) {
54       uint z = x + y;
55       assert((z >= x) && (z >= y));
56       return z;
57     }
58 
59     function safeSubtract(uint x, uint y) pure internal returns(uint) {
60       assert(x >= y);
61       uint z = x - y;
62       return z;
63     }
64 
65     function safeMult(uint x, uint y) pure internal returns(uint) {
66       uint z = x * y;
67       assert((x == 0)||(z/x == y));
68       return z;
69     }
70 
71     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
72         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
73         return uint8(genNum % (maxRandom - min + 1)+min);
74     }
75 }
76 
77 contract Enums {
78     enum ResultCode {
79         SUCCESS,
80         ERROR_CLASS_NOT_FOUND,
81         ERROR_LOW_BALANCE,
82         ERROR_SEND_FAIL,
83         ERROR_NOT_OWNER,
84         ERROR_NOT_ENOUGH_MONEY,
85         ERROR_INVALID_AMOUNT
86     }
87 
88     enum AngelAura { 
89         Blue, 
90         Yellow, 
91         Purple, 
92         Orange, 
93         Red, 
94         Green 
95     }
96 }
97 
98 contract IAngelCardData is AccessControl, Enums {
99     uint8 public totalAngelCardSeries;
100     uint64 public totalAngels;
101 
102     
103     // write
104     // angels
105     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
106     function updateAngelCardSeries(uint8 _angelCardSeriesId) onlyCREATOR external;
107     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
108     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
109     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
110     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
111     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
112     function addAngelIdMapping(address _owner, uint64 _angelId) private;
113     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
114     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
115 
116     // read
117     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
118     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
119     function getOwnerAngelCount(address _owner) constant public returns(uint);
120     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
121     function getTotalAngelCardSeries() constant public returns (uint8);
122     function getTotalAngels() constant public returns (uint64);
123 }
124 
125 
126 contract AngelCardData is IAngelCardData, SafeMath {
127     /*** EVENTS ***/
128     event CreatedAngel(uint64 angelId);
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /*** DATA TYPES ***/
132     struct AngelCardSeries {
133         uint8 angelCardSeriesId;
134         uint basePrice; 
135         uint64 currentAngelTotal;
136         uint64 maxAngelTotal;
137         AngelAura baseAura;
138         uint baseBattlePower;
139         uint64 lastSellTime;
140         uint64 liveTime;
141     }
142 
143     struct Angel {
144         uint64 angelId;
145         uint8 angelCardSeriesId;
146         address owner;
147         uint16 battlePower;
148         AngelAura aura;
149         uint16 experience;
150         uint price;
151         uint64 createdTime;
152         uint64 lastBattleTime;
153         uint64 lastVsBattleTime;
154         uint16 lastBattleResult;
155     }
156 
157     /*** STORAGE ***/
158 
159     mapping(uint8 => AngelCardSeries) public angelCardSeriesCollection;
160     mapping(uint64 => Angel) public angelCollection;
161     mapping(address => uint64[]) public ownerAngelCollection;
162     uint256 public prevSeriesSelloutHours;
163     
164     /*** FUNCTIONS ***/
165     //*** Write Access ***//
166     function AngelCardData() public {
167         
168     }
169   
170 
171     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8) {
172          if ((now > 1516692600) || (totalAngelCardSeries >= 24)) {revert();}
173         //This confirms that no one, even the develoopers, can create any angel series after JAN/23/2018 @ 7:30 am (UTC) or more than the original 24 series.
174 
175         AngelCardSeries storage angelCardSeries = angelCardSeriesCollection[_angelCardSeriesId];
176         angelCardSeries.angelCardSeriesId = _angelCardSeriesId;
177         angelCardSeries.basePrice = _basePrice; 
178         angelCardSeries.maxAngelTotal = _maxTotal;
179         angelCardSeries.baseAura = AngelAura(_baseAura);
180         angelCardSeries.baseBattlePower = _baseBattlePower;
181         angelCardSeries.lastSellTime = 0;
182         angelCardSeries.liveTime = _liveTime;
183 
184         totalAngelCardSeries += 1;
185         return totalAngelCardSeries;
186     }
187 
188     // This is called every 5 days to set the basePrice and maxAngelTotal for the angel series based on buy pressure of the last card
189     function updateAngelCardSeries(uint8 _angelCardSeriesId) onlyCREATOR external {
190         // Require that the series is above the Arel card
191         if (_angelCardSeriesId < 4) 
192             revert();
193         //don't need to use safesubtract here because above we already reverted id less than 4. 
194         AngelCardSeries memory seriesMinusOne = angelCardSeriesCollection[_angelCardSeriesId - 1];
195         AngelCardSeries storage seriesStorage = angelCardSeriesCollection[_angelCardSeriesId];
196         //In case no conditions are true, then no change. 
197         seriesStorage.maxAngelTotal = seriesMinusOne.maxAngelTotal;
198         if (seriesMinusOne.currentAngelTotal >= seriesMinusOne.maxAngelTotal) {
199             prevSeriesSelloutHours = (safeSubtract(seriesMinusOne.lastSellTime,seriesMinusOne.liveTime))/3600;
200         } else {
201             prevSeriesSelloutHours = 120;
202         }
203 
204         // Set the new basePrice for the angelCardSeries
205         //Lower by 0.65 eth if didn't sell out, until min of 0.005 eth
206         if (prevSeriesSelloutHours > 100) { 
207             if (seriesMinusOne.basePrice > 70000000000000000) 
208             {seriesStorage.basePrice = seriesMinusOne.basePrice - 65000000000000000;}
209             else {seriesStorage.basePrice = 5000000000000000;}
210         }
211         //Increase by 0.005 ETH for 100-sell out hours. Price increases faster based on demand. 
212         else {seriesStorage.basePrice = seriesMinusOne.basePrice+((100-prevSeriesSelloutHours)*5000000000000000);}
213         
214         // Adjust the maxTotal for the angelCardSeries
215         //Don't need safeMath here because we are already checking values. 
216         if (prevSeriesSelloutHours < 100 && seriesMinusOne.maxAngelTotal <= 435) {
217             seriesStorage.maxAngelTotal = seriesMinusOne.maxAngelTotal+15;
218         } else if (prevSeriesSelloutHours > 100 && seriesMinusOne.maxAngelTotal >= 60) {
219             seriesStorage.maxAngelTotal = seriesMinusOne.maxAngelTotal-15;
220         }
221         // Need to set this incase no cards  sell, so that other calculations don't break
222         seriesStorage.lastSellTime = uint64(now);
223     }
224 
225     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64) {
226         AngelCardSeries storage series = angelCardSeriesCollection[_angelCardSeriesId];
227     
228         if (series.currentAngelTotal >= series.maxAngelTotal) {
229             revert();
230         }
231        else { 
232         totalAngels += 1;
233         Angel storage angel = angelCollection[totalAngels];
234         series.currentAngelTotal += 1;
235         series.lastSellTime = uint64(now);
236         angel.angelId = totalAngels;
237         angel.angelCardSeriesId = _angelCardSeriesId;
238         angel.owner = _owner;
239         angel.battlePower = _battlePower; 
240         angel.aura = series.baseAura;
241         angel.experience = 0;
242         angel.price = _price;
243         angel.createdTime = uint64(now);
244         angel.lastBattleTime = 0;
245         angel.lastVsBattleTime = 0;
246         angel.lastBattleResult = 0;
247         addAngelIdMapping(_owner, angel.angelId);
248         return angel.angelId;
249        }
250     }
251      
252     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external {
253         Angel storage angel = angelCollection[_angelId];
254         if (angel.angelId == _angelId) {
255             angel.experience = uint16(safeAdd(angel.experience, _value));
256         }
257     }
258 
259     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external {
260         Angel storage angel = angelCollection[_angelId];
261         if (angel.angelId == _angelId) {
262             angel.lastBattleTime = uint64(now);
263         }
264     }
265 
266     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external {
267         Angel storage angel = angelCollection[_angelId];
268         if (angel.angelId == _angelId) {
269             angel.lastVsBattleTime = uint64(now);
270         }
271     }
272 
273     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external {
274         Angel storage angel = angelCollection[_angelId];
275         if (angel.angelId == _angelId) {
276             angel.lastBattleResult = _value;
277         }
278     }
279     
280     function addAngelIdMapping(address _owner, uint64 _angelId) private {
281             uint64[] storage owners = ownerAngelCollection[_owner];
282             owners.push(_angelId);
283             Angel storage angel = angelCollection[_angelId];
284             angel.owner = _owner;
285     }
286 //Anyone can transfer their own angel by sending a transaction with the address to transfer to from the address that owns it. 
287     function ownerAngelTransfer (address _to, uint64 _angelId)  public  {
288         
289        if ((_angelId > totalAngels) || (_angelId == 0)) {revert();}
290        Angel storage angel = angelCollection[_angelId];
291         if (msg.sender == _to) {revert();}
292         if (angel.owner != msg.sender) {
293             revert();
294         }
295         else {
296         angel.owner = _to;
297         addAngelIdMapping(_to, _angelId);
298         }
299     }
300     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode) {
301         Angel storage angel = angelCollection[_angelId];
302         if (_from == _to) {revert();}
303         if (angel.owner != _from) {
304             return ResultCode.ERROR_NOT_OWNER;
305         }
306         angel.owner = _to;
307         addAngelIdMapping(_to, _angelId);
308         return ResultCode.SUCCESS;
309     }
310 
311   
312    
313     //*** Read Access ***//
314     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime) {
315         AngelCardSeries memory series = angelCardSeriesCollection[_angelCardSeriesId];
316         angelCardSeriesId = series.angelCardSeriesId;
317         currentAngelTotal = series.currentAngelTotal;
318         basePrice = series.basePrice;
319         maxAngelTotal = series.maxAngelTotal;
320         baseAura = uint8(series.baseAura);
321         baseBattlePower = series.baseBattlePower;
322         lastSellTime = series.lastSellTime;
323         liveTime = series.liveTime;
324     }
325 
326 
327     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner) {
328         Angel memory angel = angelCollection[_angelId];
329         angelId = angel.angelId;
330         angelCardSeriesId = angel.angelCardSeriesId;
331         battlePower = angel.battlePower;
332         aura = uint8(angel.aura);
333         experience = angel.experience;
334         price = angel.price;
335         createdTime = angel.createdTime;
336         lastBattleTime = angel.lastBattleTime;
337         lastVsBattleTime = angel.lastVsBattleTime;
338         lastBattleResult = angel.lastBattleResult;
339         owner = angel.owner;
340     }
341 
342     function getOwnerAngelCount(address _owner) constant public returns(uint) {
343         return ownerAngelCollection[_owner].length;
344     }
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