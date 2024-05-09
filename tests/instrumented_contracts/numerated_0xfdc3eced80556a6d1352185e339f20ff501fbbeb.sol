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
45 contract ItemsInterfaceForEternalStorage {
46     function createShip(uint256 _itemId) public;
47     function createRadar(uint256 _itemId) public;
48     function createScanner(uint256 _itemId) public;
49     function createDroid(uint256 _itemId) public;
50     function createFuel(uint256 _itemId) public;
51     function createGenerator(uint256 _itemId) public;
52     function createEngine(uint256 _itemId) public;
53     function createGun(uint256 _itemId) public;
54     function createMicroModule(uint256 _itemId) public;
55     function createArtefact(uint256 _itemId) public;
56     
57     function addItem(string _itemType) public returns(uint256);
58 }
59 
60 contract EternalStorage {
61 
62     ItemsInterfaceForEternalStorage private mI;
63 
64     /* ------ STORAGE ------ */
65 
66     mapping(bytes32 => uint256) private uintStorage;
67     mapping(bytes32 => uint256[]) private uintArrayStorage;
68 
69     mapping(bytes32 => string) private stringStorage;
70     mapping(bytes32 => address) private addressStorage;
71     mapping(bytes32 => bytes) private bytesStorage;
72     mapping(bytes32 => bool) private boolStorage;
73     mapping(bytes32 => int256) private intStorage;
74 
75     address private ownerOfStorage;
76     address private logicContractAddress;
77 
78     mapping(address => uint256) private refunds;
79 
80     constructor() public {
81         ownerOfStorage = msg.sender;
82         mI = ItemsInterfaceForEternalStorage(0x600c9892B294ef4cB7D22c1f6045C972C0a086e5);
83     }
84 
85     /* ------ MODIFIERS ------ */
86 
87     modifier onlyOwnerOfStorage() {
88         require(msg.sender == ownerOfStorage);
89         _;
90     }
91 
92     modifier onlyLogicContract() {
93         require(msg.sender == logicContractAddress);
94         _;
95     }
96     
97     /* ------ INITIALISATION ------ */
98 
99     function initWithShips() public onlyOwnerOfStorage {
100         createShip(1, 'Titanium Ranger Hull', 200, 2, 0.000018 ether);
101         createShip(2, 'Platinum Ranger Hull', 400, 4, 0.45 ether);
102         createShip(3, 'Adamantium Ranger Hull', 600, 7, 0.9 ether);
103     }
104 
105     /* ------ REFERAL SYSTEM FUNCTIONS ------ */
106 
107     function addReferrer(address _referrerWalletAddress, uint256 referrerPrize) public onlyLogicContract {
108         refunds[_referrerWalletAddress] += referrerPrize;
109     }
110 
111     function widthdrawRefunds(address _owner) public onlyLogicContract returns(uint256) {
112         uint256 refund = refunds[_owner];
113         refunds[_owner] = 0;
114         return refund;
115     }
116 
117     function checkRefundExistanceByOwner(address _owner) public view onlyLogicContract returns(uint256) {
118         return refunds[_owner];
119     }
120 
121      /* ------ BUY OPERATIONS ------ */
122 
123     function buyItem(uint256 _itemId, address _newOwner, string _itemTitle, string _itemTypeTitle, string _itemIdTitle) public onlyLogicContract returns(uint256) {
124         uintStorage[_b2(_itemTitle, _newOwner)]++;
125         uintArrayStorage[_b2(_itemTypeTitle, _newOwner)].push(_itemId);
126 
127         uint256 newItemId = mI.addItem(_itemTitle);
128 
129         uintArrayStorage[_b2(_itemIdTitle, _newOwner)].push(newItemId);
130 
131         addressStorage[_b3(_itemTitle, newItemId)] = _newOwner;
132         return _itemId;
133     }
134 
135     function destroyEternalStorage() public onlyOwnerOfStorage {
136         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
137     }
138 
139     /* ------ HASH FUNCTIONS ------ */
140 
141     function _toString(address x) private pure returns (string) {
142         bytes32 value = bytes32(uint256(x));
143         bytes memory alphabet = "0123456789abcdef";
144 
145         bytes memory str = new bytes(51);
146         str[0] = '0';
147         str[1] = 'x';
148         for (uint i = 0; i < 20; i++) {
149             str[2+i*2] = alphabet[uint(value[i + 12] >> 4)];
150             str[3+i*2] = alphabet[uint(value[i + 12] & 0x0f)];
151         }
152         return string(str);
153 
154     }
155 
156     function _b1(string _itemType, uint256 _itemId, string _property) private pure returns(bytes32) {
157         return keccak256(abi.encodePacked(_itemType, _itemId, _property));
158     }
159 
160     function _b2(string _itemType, address _newOwnerAddress) private pure returns(bytes32) {
161         return keccak256(abi.encodePacked(_toString(_newOwnerAddress), _itemType));
162     }
163 
164     function _b3(string _itemType, uint256 _itemId) private pure returns(bytes32) {
165         return keccak256(abi.encodePacked(_itemType, _itemId));
166     }
167 
168     /* ------ READING METHODS FOR USERS ITEMS ------ */
169 
170     function getNumberOfItemsByTypeAndOwner(string _itemType, address _owner) public onlyLogicContract view returns(uint256) {
171         return uintStorage[_b2(_itemType, _owner)];
172     }
173 
174     function getItemsByTypeAndOwner(string _itemTypeTitle, address _owner) public onlyLogicContract view returns(uint256[]) {
175         return uintArrayStorage[_b2(_itemTypeTitle, _owner)];
176     }
177 
178     function getItemsIdsByTypeAndOwner(string _itemIdsTitle, address _owner) public onlyLogicContract view returns(uint256[]) {
179         return uintArrayStorage[_b2(_itemIdsTitle, _owner)];
180     }
181 
182     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public onlyLogicContract view returns(address) {
183         return addressStorage[_b3(_itemType, _itemId)];
184     }
185 
186      /* ------ READING METHODS FOR ALL ITEMS ------ */
187 
188     function getItemPriceById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(uint256) {
189         return uintStorage[_b1(_itemType, _itemId, "price")];
190     }
191 
192     // Get Radar, Scanner, Droid, Fuel, Generator by ID
193     function getTypicalItemById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(
194         uint256,
195         string,
196         uint256,
197         uint256,
198         uint256
199     ) {
200         return (
201             _itemId,
202             stringStorage[_b1(_itemType, _itemId, "name")],
203             uintStorage[_b1(_itemType, _itemId, "value")],
204             uintStorage[_b1(_itemType, _itemId, "price")],
205             uintStorage[_b1(_itemType, _itemId, "durability")]
206         );
207     }
208 
209     function getShipById(uint256 _shipId) public onlyLogicContract view returns(
210         uint256,
211         string,
212         uint256,
213         uint256,
214         uint256
215     ) {
216         return (
217             _shipId,
218             stringStorage[_b1("ships", _shipId, "name")],
219             uintStorage[_b1("ships", _shipId, "hp")],
220             uintStorage[_b1("ships", _shipId, "block")],
221             uintStorage[_b1("ships", _shipId, "price")]
222         );
223     }
224 
225     function getEngineById(uint256 _engineId) public onlyLogicContract view returns(
226         uint256,
227         string,
228         uint256,
229         uint256,
230         uint256,
231         uint256
232     ) {
233         return (
234             _engineId,
235             stringStorage[_b1("engines", _engineId, "name")],
236             uintStorage[_b1("engines", _engineId, "speed")],
237             uintStorage[_b1("engines", _engineId, "giper")],
238             uintStorage[_b1("engines", _engineId, "price")],
239             uintStorage[_b1("engines", _engineId, "durability")]
240         );
241     }
242 
243     function getGunByIdPart1(uint256 _gunId) public onlyLogicContract view returns(
244         uint256,
245         string,
246         uint256,
247         uint256
248     ) {
249         return (
250             _gunId,
251             stringStorage[_b1("guns", _gunId, "name")],
252             uintStorage[_b1("guns", _gunId, "min")],
253             uintStorage[_b1("guns", _gunId, "max")]
254         );
255     }
256 
257     function getGunByIdPart2(uint256 _gunId) public onlyLogicContract view returns(
258         uint256,
259         uint256,
260         uint256,
261         uint256,
262         uint256
263     ) {
264         return (
265             uintStorage[_b1("guns", _gunId, "radius")],
266             uintStorage[_b1("guns", _gunId, "recharge")],
267             uintStorage[_b1("guns", _gunId, "ability")],
268             uintStorage[_b1("guns", _gunId, "price")],
269             uintStorage[_b1("guns", _gunId, "durability")]
270         );
271     }
272 
273     function getMicroModuleByIdPart1(uint256 _microModuleId) public onlyLogicContract view returns(
274         uint256,
275         string,
276         uint256,
277         uint256
278     ) {
279         return (
280             _microModuleId,
281             stringStorage[_b1("microModules", _microModuleId, "name")],
282             uintStorage[_b1("microModules", _microModuleId, "itemType")],
283             uintStorage[_b1("microModules", _microModuleId, "bonusType")]
284         );
285     }
286 
287     function getMicroModuleByIdPart2(uint256 _microModuleId) public onlyLogicContract view returns(
288         uint256,
289         uint256,
290         uint256
291     ) {
292         return (
293             uintStorage[_b1("microModules", _microModuleId, "bonus")],
294             uintStorage[_b1("microModules", _microModuleId, "level")],
295             uintStorage[_b1("microModules", _microModuleId, "price")]
296         );
297     }
298 
299     function getArtefactById(uint256 _artefactId) public onlyLogicContract view returns(
300         uint256,
301         string,
302         uint256,
303         uint256,
304         uint256
305     ) {
306         return (
307             _artefactId,
308             stringStorage[_b1("artefacts", _artefactId, "name")],
309             uintStorage[_b1("artefacts", _artefactId, "itemType")],
310             uintStorage[_b1("artefacts", _artefactId, "bonusType")],
311             uintStorage[_b1("artefacts", _artefactId, "bonus")]
312         );
313     }
314     
315     /* ------ DEV CREATION METHODS ------ */
316 
317     // Ships
318     function createShip(uint256 _shipId, string _name, uint256 _hp, uint256 _block, uint256 _price) public onlyOwnerOfStorage {
319         mI.createShip(_shipId);
320         stringStorage[_b1("ships", _shipId, "name")] = _name;
321         uintStorage[_b1("ships", _shipId, "hp")] = _hp;
322         uintStorage[_b1("ships", _shipId, "block")] = _block;
323         uintStorage[_b1("ships", _shipId, "price")] = _price;
324     }
325 
326     // update data for an item by ID
327     function _update(string _itemType, uint256 _itemId, string _name, uint256 _value, uint256 _price, uint256 _durability) private {
328         stringStorage[_b1(_itemType, _itemId, "name")] = _name;
329         uintStorage[_b1(_itemType, _itemId, "value")] = _value;
330         uintStorage[_b1(_itemType, _itemId, "price")] = _price;
331         uintStorage[_b1(_itemType, _itemId, "durability")] = _durability;
332     }
333 
334     // Radars
335     function createRadar(uint256 _radarId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
336         mI.createRadar(_radarId);
337         _update("radars", _radarId, _name, _value, _price, _durability);
338     }
339 
340     // Scanners
341     function createScanner(uint256 _scannerId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
342         mI.createScanner(_scannerId);
343         _update("scanners", _scannerId, _name, _value, _price, _durability);
344     }
345 
346     // Droids
347     function createDroid(uint256 _droidId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
348         mI.createDroid(_droidId);
349         _update("droids", _droidId, _name, _value, _price, _durability);
350     }
351 
352     // Fuels
353     function createFuel(uint256 _fuelId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
354         mI.createFuel(_fuelId);
355         _update("fuels", _fuelId, _name, _value, _price, _durability);
356     }
357 
358     // Generators
359     function createGenerator(uint256 _generatorId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
360         mI.createGenerator(_generatorId);
361         _update("generators", _generatorId, _name, _value, _price, _durability);
362     }
363 
364     // Engines
365     function createEngine(uint256 _engineId, string _name, uint256 _speed, uint256 _giper, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
366         mI.createEngine(_engineId);
367         stringStorage[_b1("engines", _engineId, "name")] = _name;
368         uintStorage[_b1("engines", _engineId, "speed")] = _speed;
369         uintStorage[_b1("engines", _engineId, "giper")] = _giper;
370         uintStorage[_b1("engines", _engineId, "price")] = _price;
371         uintStorage[_b1("engines", _engineId, "durability")] = _durability;
372     }
373 
374     // Guns
375     function createGun(uint256 _gunId, string _name, uint256 _min, uint256 _max, uint256 _radius, uint256 _recharge, uint256 _ability,  uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
376         mI.createGun(_gunId);
377         stringStorage[_b1("guns", _gunId, "name")] = _name;
378         uintStorage[_b1("guns", _gunId, "min")] = _min;
379         uintStorage[_b1("guns", _gunId, "max")] = _max;
380         uintStorage[_b1("guns", _gunId, "radius")] = _radius;
381         uintStorage[_b1("guns", _gunId, "recharge")] = _recharge;
382         uintStorage[_b1("guns", _gunId, "ability")] = _ability;
383         uintStorage[_b1("guns", _gunId, "price")] = _price;
384         uintStorage[_b1("guns", _gunId, "durability")] = _durability;
385     }
386 
387     // Micro modules
388     function createMicroModule(uint256 _microModuleId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus, uint256 _level, uint256 _price) public onlyOwnerOfStorage {
389         mI.createMicroModule(_microModuleId);
390         stringStorage[_b1("microModules", _microModuleId, "name")] = _name;
391         uintStorage[_b1("microModules", _microModuleId, "itemType")] = _itemType;
392         uintStorage[_b1("microModules", _microModuleId, "bonusType")] = _bonusType;
393         uintStorage[_b1("microModules", _microModuleId, "bonus")] = _bonus;
394         uintStorage[_b1("microModules", _microModuleId, "level")] = _level;
395         uintStorage[_b1("microModules", _microModuleId, "price")] = _price;
396     }
397 
398     // Artefacts
399     function createArtefact(uint256 _artefactId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus) public onlyOwnerOfStorage {
400         mI.createArtefact(_artefactId);
401         stringStorage[_b1("artefacts", _artefactId, "name")] = _name;
402         uintStorage[_b1("artefacts", _artefactId, "itemType")] = _itemType;
403         uintStorage[_b1("artefacts", _artefactId, "bonusType")] = _bonusType;
404         uintStorage[_b1("artefacts", _artefactId, "bonus")] = _bonus;
405     }
406 
407     /* ------ DEV FUNCTIONS ------ */
408 
409     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyLogicContract {
410         uintStorage[_b1(_itemType, _itemTypeId, "price")] = _newPrice;
411     }
412 
413     /* ------ CHANGE OWNERSHIP OF STORAGE ------ */
414 
415     function transferOwnershipOfStorage(address _newOwnerOfStorage) public onlyOwnerOfStorage {
416         _transferOwnershipOfStorage(_newOwnerOfStorage);
417     }
418 
419     function _transferOwnershipOfStorage(address _newOwnerOfStorage) private {
420         require(_newOwnerOfStorage != address(0));
421         ownerOfStorage = _newOwnerOfStorage;
422     }
423 
424     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
425 
426     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfStorage {
427         _changeLogicContractAddress(_newLogicContractAddress);
428     }
429 
430     function _changeLogicContractAddress(address _newLogicContractAddress) private {
431         require(_newLogicContractAddress != address(0));
432         logicContractAddress = _newLogicContractAddress;
433     }
434 }