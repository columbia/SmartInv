1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract ItemsInterfaceForEternalStorage {
47     function createShip(uint256 _itemId) public;
48     function createRadar(uint256 _itemId) public;
49     function createScanner(uint256 _itemId) public;
50     function createDroid(uint256 _itemId) public;
51     function createFuel(uint256 _itemId) public;
52     function createGenerator(uint256 _itemId) public;
53     function createEngine(uint256 _itemId) public;
54     function createGun(uint256 _itemId) public;
55     function createMicroModule(uint256 _itemId) public;
56     function createArtefact(uint256 _itemId) public;
57     
58     function addItem(string _itemType) public returns(uint256);
59 }
60 
61 contract EternalStorage {
62 
63     ItemsInterfaceForEternalStorage private mI;
64 
65     /* ------ STORAGE ------ */
66 
67     mapping(bytes32 => uint256) private uintStorage;
68     mapping(bytes32 => uint256[]) private uintArrayStorage;
69 
70     mapping(bytes32 => string) private stringStorage;
71     mapping(bytes32 => address) private addressStorage;
72     mapping(bytes32 => bytes) private bytesStorage;
73     mapping(bytes32 => bool) private boolStorage;
74     mapping(bytes32 => int256) private intStorage;
75 
76     address private ownerOfStorage;
77     address private logicContractAddress;
78 
79     mapping(address => uint256) private refunds;
80 
81     constructor() public {
82         ownerOfStorage = msg.sender;
83         mI = ItemsInterfaceForEternalStorage(0x27B95A9231a022923e9b52d71bEB662Fdd5d6cbc);
84     }
85 
86     /* ------ MODIFIERS ------ */
87 
88     modifier onlyOwnerOfStorage() {
89         require(msg.sender == ownerOfStorage);
90         _;
91     }
92 
93     modifier onlyLogicContract() {
94         require(msg.sender == logicContractAddress);
95         _;
96     }
97     
98     /* ------ INITIALISATION ------ */
99 
100     function initWithShips() public onlyOwnerOfStorage {
101         createShip(1, 'Titanium Ranger Hull', 200, 2, 0.18 ether);
102         createShip(2, 'Platinum Ranger Hull', 400, 4, 0.45 ether);
103         createShip(3, 'Adamantium Ranger Hull', 600, 7, 0.9 ether);
104     }
105 
106     /* ------ REFERAL SYSTEM FUNCTIONS ------ */
107 
108     function addReferrer(address _referrerWalletAddress, uint256 referrerPrize) public onlyLogicContract {
109         refunds[_referrerWalletAddress] += referrerPrize;
110     }
111 
112     function widthdrawRefunds(address _owner) public onlyLogicContract returns(uint256) {
113         uint256 refund = refunds[_owner];
114         refunds[_owner] = 0;
115         return refund;
116     }
117 
118     function checkRefundExistanceByOwner(address _owner) public view onlyLogicContract returns(uint256) {
119         return refunds[_owner];
120     }
121 
122      /* ------ BUY OPERATIONS ------ */
123 
124     function buyItem(uint256 _itemId, address _newOwner, string _itemTitle, string _itemTypeTitle) public onlyLogicContract returns(uint256) {
125         uint256 newItemId = mI.addItem(_itemTitle);
126         uintStorage[_b3(_itemTypeTitle, newItemId)] = _itemId;
127         addressStorage[_b4(_itemTitle, newItemId)] = _newOwner;
128 
129         return _itemId;
130     }
131 
132     /* ------ HASH FUNCTIONS ------ */
133 
134     function _b1(string _itemType, uint256 _itemId, string _property) private pure returns(bytes32) {
135         return keccak256(abi.encodePacked(_itemType, _itemId, _property));
136     }
137 
138     function _b3(string _itemType, uint256 _itemId) private pure returns(bytes32) {
139         return keccak256(abi.encodePacked(_itemType, _itemId));
140     }
141 
142     function _b4(string _itemType, uint256 _itemId) private pure returns(bytes32) {
143         return keccak256(abi.encodePacked("owner", _itemType, _itemId));
144     }
145 
146     /* ------ READING METHODS FOR USERS ITEMS ------ */
147 
148     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public onlyLogicContract view returns(address) {
149         return addressStorage[_b4(_itemType, _itemId)];
150     }
151 
152     function getItemTypeIdByTypeAndId(string _itemTypeTitle, uint256 _itemId) public onlyLogicContract view returns(uint256) {
153         return uintStorage[_b3(_itemTypeTitle, _itemId)];
154     }
155 
156      /* ------ READING METHODS FOR ALL ITEMS ------ */
157 
158     function getItemPriceById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(uint256) {
159         return uintStorage[_b1(_itemType, _itemId, "price")];
160     }
161 
162     // Get Radar, Scanner, Droid, Fuel, Generator by ID
163     function getTypicalItemById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(
164         uint256,
165         string,
166         uint256,
167         uint256,
168         uint256
169     ) {
170         return (
171             _itemId,
172             stringStorage[_b1(_itemType, _itemId, "name")],
173             uintStorage[_b1(_itemType, _itemId, "value")],
174             uintStorage[_b1(_itemType, _itemId, "price")],
175             uintStorage[_b1(_itemType, _itemId, "durability")]
176         );
177     }
178 
179     function getShipById(uint256 _shipId) public onlyLogicContract view returns(
180         uint256,
181         string,
182         uint256,
183         uint256,
184         uint256
185     ) {
186         return (
187             _shipId,
188             stringStorage[_b1("ships", _shipId, "name")],
189             uintStorage[_b1("ships", _shipId, "hp")],
190             uintStorage[_b1("ships", _shipId, "block")],
191             uintStorage[_b1("ships", _shipId, "price")]
192         );
193     }
194 
195     function getEngineById(uint256 _engineId) public onlyLogicContract view returns(
196         uint256,
197         string,
198         uint256,
199         uint256,
200         uint256,
201         uint256
202     ) {
203         return (
204             _engineId,
205             stringStorage[_b1("engines", _engineId, "name")],
206             uintStorage[_b1("engines", _engineId, "speed")],
207             uintStorage[_b1("engines", _engineId, "giper")],
208             uintStorage[_b1("engines", _engineId, "price")],
209             uintStorage[_b1("engines", _engineId, "durability")]
210         );
211     }
212 
213     function getGunByIdPart1(uint256 _gunId) public onlyLogicContract view returns(
214         uint256,
215         string,
216         uint256,
217         uint256
218     ) {
219         return (
220             _gunId,
221             stringStorage[_b1("guns", _gunId, "name")],
222             uintStorage[_b1("guns", _gunId, "min")],
223             uintStorage[_b1("guns", _gunId, "max")]
224         );
225     }
226 
227     function getGunByIdPart2(uint256 _gunId) public onlyLogicContract view returns(
228         uint256,
229         uint256,
230         uint256,
231         uint256,
232         uint256
233     ) {
234         return (
235             uintStorage[_b1("guns", _gunId, "radius")],
236             uintStorage[_b1("guns", _gunId, "recharge")],
237             uintStorage[_b1("guns", _gunId, "ability")],
238             uintStorage[_b1("guns", _gunId, "price")],
239             uintStorage[_b1("guns", _gunId, "durability")]
240         );
241     }
242 
243     function getMicroModuleByIdPart1(uint256 _microModuleId) public onlyLogicContract view returns(
244         uint256,
245         string,
246         uint256,
247         uint256
248     ) {
249         return (
250             _microModuleId,
251             stringStorage[_b1("microModules", _microModuleId, "name")],
252             uintStorage[_b1("microModules", _microModuleId, "itemType")],
253             uintStorage[_b1("microModules", _microModuleId, "bonusType")]
254         );
255     }
256 
257     function getMicroModuleByIdPart2(uint256 _microModuleId) public onlyLogicContract view returns(
258         uint256,
259         uint256,
260         uint256
261     ) {
262         return (
263             uintStorage[_b1("microModules", _microModuleId, "bonus")],
264             uintStorage[_b1("microModules", _microModuleId, "level")],
265             uintStorage[_b1("microModules", _microModuleId, "price")]
266         );
267     }
268 
269     function getArtefactById(uint256 _artefactId) public onlyLogicContract view returns(
270         uint256,
271         string,
272         uint256,
273         uint256,
274         uint256
275     ) {
276         return (
277             _artefactId,
278             stringStorage[_b1("artefacts", _artefactId, "name")],
279             uintStorage[_b1("artefacts", _artefactId, "itemType")],
280             uintStorage[_b1("artefacts", _artefactId, "bonusType")],
281             uintStorage[_b1("artefacts", _artefactId, "bonus")]
282         );
283     }
284     
285     /* ------ DEV CREATION METHODS ------ */
286 
287     // Ships
288     function createShip(uint256 _shipId, string _name, uint256 _hp, uint256 _block, uint256 _price) public onlyOwnerOfStorage {
289         mI.createShip(_shipId);
290         stringStorage[_b1("ships", _shipId, "name")] = _name;
291         uintStorage[_b1("ships", _shipId, "hp")] = _hp;
292         uintStorage[_b1("ships", _shipId, "block")] = _block;
293         uintStorage[_b1("ships", _shipId, "price")] = _price;
294     }
295 
296     // update data for an item by ID
297     function _update(string _itemType, uint256 _itemId, string _name, uint256 _value, uint256 _price, uint256 _durability) private {
298         stringStorage[_b1(_itemType, _itemId, "name")] = _name;
299         uintStorage[_b1(_itemType, _itemId, "value")] = _value;
300         uintStorage[_b1(_itemType, _itemId, "price")] = _price;
301         uintStorage[_b1(_itemType, _itemId, "durability")] = _durability;
302     }
303 
304     // Radars
305     function createRadar(uint256 _radarId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
306         mI.createRadar(_radarId);
307         _update("radars", _radarId, _name, _value, _price, _durability);
308     }
309 
310     // Scanners
311     function createScanner(uint256 _scannerId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
312         mI.createScanner(_scannerId);
313         _update("scanners", _scannerId, _name, _value, _price, _durability);
314     }
315 
316     // Droids
317     function createDroid(uint256 _droidId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
318         mI.createDroid(_droidId);
319         _update("droids", _droidId, _name, _value, _price, _durability);
320     }
321 
322     // Fuels
323     function createFuel(uint256 _fuelId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
324         mI.createFuel(_fuelId);
325         _update("fuels", _fuelId, _name, _value, _price, _durability);
326     }
327 
328     // Generators
329     function createGenerator(uint256 _generatorId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
330         mI.createGenerator(_generatorId);
331         _update("generators", _generatorId, _name, _value, _price, _durability);
332     }
333 
334     // Engines
335     function createEngine(uint256 _engineId, string _name, uint256 _speed, uint256 _giper, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
336         mI.createEngine(_engineId);
337         stringStorage[_b1("engines", _engineId, "name")] = _name;
338         uintStorage[_b1("engines", _engineId, "speed")] = _speed;
339         uintStorage[_b1("engines", _engineId, "giper")] = _giper;
340         uintStorage[_b1("engines", _engineId, "price")] = _price;
341         uintStorage[_b1("engines", _engineId, "durability")] = _durability;
342     }
343 
344     // Guns
345     function createGun(uint256 _gunId, string _name, uint256 _min, uint256 _max, uint256 _radius, uint256 _recharge, uint256 _ability,  uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
346         mI.createGun(_gunId);
347         stringStorage[_b1("guns", _gunId, "name")] = _name;
348         uintStorage[_b1("guns", _gunId, "min")] = _min;
349         uintStorage[_b1("guns", _gunId, "max")] = _max;
350         uintStorage[_b1("guns", _gunId, "radius")] = _radius;
351         uintStorage[_b1("guns", _gunId, "recharge")] = _recharge;
352         uintStorage[_b1("guns", _gunId, "ability")] = _ability;
353         uintStorage[_b1("guns", _gunId, "price")] = _price;
354         uintStorage[_b1("guns", _gunId, "durability")] = _durability;
355     }
356 
357     // Micro modules
358     function createMicroModule(uint256 _microModuleId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus, uint256 _level, uint256 _price) public onlyOwnerOfStorage {
359         mI.createMicroModule(_microModuleId);
360         stringStorage[_b1("microModules", _microModuleId, "name")] = _name;
361         uintStorage[_b1("microModules", _microModuleId, "itemType")] = _itemType;
362         uintStorage[_b1("microModules", _microModuleId, "bonusType")] = _bonusType;
363         uintStorage[_b1("microModules", _microModuleId, "bonus")] = _bonus;
364         uintStorage[_b1("microModules", _microModuleId, "level")] = _level;
365         uintStorage[_b1("microModules", _microModuleId, "price")] = _price;
366     }
367 
368     // Artefacts
369     function createArtefact(uint256 _artefactId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus) public onlyOwnerOfStorage {
370         mI.createArtefact(_artefactId);
371         stringStorage[_b1("artefacts", _artefactId, "name")] = _name;
372         uintStorage[_b1("artefacts", _artefactId, "itemType")] = _itemType;
373         uintStorage[_b1("artefacts", _artefactId, "bonusType")] = _bonusType;
374         uintStorage[_b1("artefacts", _artefactId, "bonus")] = _bonus;
375     }
376 
377     /* ------ DEV FUNCTIONS ------ */
378 
379     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyLogicContract {
380         uintStorage[_b1(_itemType, _itemTypeId, "price")] = _newPrice;
381     }
382 
383     /* ------ CHANGE OWNERSHIP OF STORAGE ------ */
384 
385     function transferOwnershipOfStorage(address _newOwnerOfStorage) public onlyOwnerOfStorage {
386         _transferOwnershipOfStorage(_newOwnerOfStorage);
387     }
388 
389     function _transferOwnershipOfStorage(address _newOwnerOfStorage) private {
390         require(_newOwnerOfStorage != address(0));
391         ownerOfStorage = _newOwnerOfStorage;
392     }
393 
394     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
395 
396     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfStorage {
397         _changeLogicContractAddress(_newLogicContractAddress);
398     }
399 
400     function _changeLogicContractAddress(address _newLogicContractAddress) private {
401         require(_newLogicContractAddress != address(0));
402         logicContractAddress = _newLogicContractAddress;
403     }
404 }