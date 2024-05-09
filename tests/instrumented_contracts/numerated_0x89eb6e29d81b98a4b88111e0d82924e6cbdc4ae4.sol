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
82         mI = ItemsInterfaceForEternalStorage(0xf1fd447DAc5AbEAba356cD0010Bac95daA37C265);
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
142         bytes memory b = new bytes(20);
143         for (uint i = 0; i < 20; i++)
144             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
145         return string(b);
146     }
147 
148     function _b1(string _itemType, uint256 _itemId, string _property) private pure returns(bytes32) {
149         return keccak256(abi.encodePacked(_itemType, _itemId, _property));
150     }
151 
152     function _b2(string _itemType, address _newOwnerAddress) private pure returns(bytes32) {
153         return keccak256(abi.encodePacked(_toString(_newOwnerAddress), _itemType));
154     }
155 
156     function _b3(string _itemType, uint256 _itemId) private pure returns(bytes32) {
157         return keccak256(abi.encodePacked(_itemType, _itemId));
158     }
159 
160     /* ------ READING METHODS FOR USERS ITEMS ------ */
161 
162     function getNumberOfItemsByTypeAndOwner(string _itemType, address _owner) public onlyLogicContract view returns(uint256) {
163         return uintStorage[_b2(_itemType, _owner)];
164     }
165 
166     function getItemsByTypeAndOwner(string _itemTypeTitle, address _owner) public onlyLogicContract view returns(uint256[]) {
167         return uintArrayStorage[_b2(_itemTypeTitle, _owner)];
168     }
169 
170     function getItemsIdsByTypeAndOwner(string _itemIdsTitle, address _owner) public onlyLogicContract view returns(uint256[]) {
171         return uintArrayStorage[_b2(_itemIdsTitle, _owner)];
172     }
173 
174     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public onlyLogicContract view returns(address) {
175         return addressStorage[_b3(_itemType, _itemId)];
176     }
177 
178      /* ------ READING METHODS FOR ALL ITEMS ------ */
179 
180     function getItemPriceById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(uint256) {
181         return uintStorage[_b1(_itemType, _itemId, "price")];
182     }
183 
184     // Get Radar, Scanner, Droid, Fuel, Generator by ID
185     function getTypicalItemById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(
186         uint256,
187         string,
188         uint256,
189         uint256,
190         uint256
191     ) {
192         return (
193             _itemId,
194             stringStorage[_b1(_itemType, _itemId, "name")],
195             uintStorage[_b1(_itemType, _itemId, "value")],
196             uintStorage[_b1(_itemType, _itemId, "price")],
197             uintStorage[_b1(_itemType, _itemId, "durability")]
198         );
199     }
200 
201     function getShipById(uint256 _shipId) public onlyLogicContract view returns(
202         uint256,
203         string,
204         uint256,
205         uint256,
206         uint256
207     ) {
208         return (
209             _shipId,
210             stringStorage[_b1("ships", _shipId, "name")],
211             uintStorage[_b1("ships", _shipId, "hp")],
212             uintStorage[_b1("ships", _shipId, "block")],
213             uintStorage[_b1("ships", _shipId, "price")]
214         );
215     }
216 
217     function getEngineById(uint256 _engineId) public onlyLogicContract view returns(
218         uint256,
219         string,
220         uint256,
221         uint256,
222         uint256,
223         uint256
224     ) {
225         return (
226             _engineId,
227             stringStorage[_b1("engines", _engineId, "name")],
228             uintStorage[_b1("engines", _engineId, "speed")],
229             uintStorage[_b1("engines", _engineId, "giper")],
230             uintStorage[_b1("engines", _engineId, "price")],
231             uintStorage[_b1("engines", _engineId, "durability")]
232         );
233     }
234 
235     function getGunByIdPart1(uint256 _gunId) public onlyLogicContract view returns(
236         uint256,
237         string,
238         uint256,
239         uint256
240     ) {
241         return (
242             _gunId,
243             stringStorage[_b1("guns", _gunId, "name")],
244             uintStorage[_b1("guns", _gunId, "min")],
245             uintStorage[_b1("guns", _gunId, "max")]
246         );
247     }
248 
249     function getGunByIdPart2(uint256 _gunId) public onlyLogicContract view returns(
250         uint256,
251         uint256,
252         uint256,
253         uint256,
254         uint256
255     ) {
256         return (
257             uintStorage[_b1("guns", _gunId, "radius")],
258             uintStorage[_b1("guns", _gunId, "recharge")],
259             uintStorage[_b1("guns", _gunId, "ability")],
260             uintStorage[_b1("guns", _gunId, "price")],
261             uintStorage[_b1("guns", _gunId, "durability")]
262         );
263     }
264 
265     function getMicroModuleByIdPart1(uint256 _microModuleId) public onlyLogicContract view returns(
266         uint256,
267         string,
268         uint256,
269         uint256
270     ) {
271         return (
272             _microModuleId,
273             stringStorage[_b1("microModules", _microModuleId, "name")],
274             uintStorage[_b1("microModules", _microModuleId, "itemType")],
275             uintStorage[_b1("microModules", _microModuleId, "bonusType")]
276         );
277     }
278 
279     function getMicroModuleByIdPart2(uint256 _microModuleId) public onlyLogicContract view returns(
280         uint256,
281         uint256,
282         uint256
283     ) {
284         return (
285             uintStorage[_b1("microModules", _microModuleId, "bonus")],
286             uintStorage[_b1("microModules", _microModuleId, "level")],
287             uintStorage[_b1("microModules", _microModuleId, "price")]
288         );
289     }
290 
291     function getArtefactById(uint256 _artefactId) public onlyLogicContract view returns(
292         uint256,
293         string,
294         uint256,
295         uint256,
296         uint256
297     ) {
298         return (
299             _artefactId,
300             stringStorage[_b1("artefacts", _artefactId, "name")],
301             uintStorage[_b1("artefacts", _artefactId, "itemType")],
302             uintStorage[_b1("artefacts", _artefactId, "bonusType")],
303             uintStorage[_b1("artefacts", _artefactId, "bonus")]
304         );
305     }
306     
307     /* ------ DEV CREATION METHODS ------ */
308 
309     // Ships
310     function createShip(uint256 _shipId, string _name, uint256 _hp, uint256 _block, uint256 _price) public onlyOwnerOfStorage {
311         mI.createShip(_shipId);
312         stringStorage[_b1("ships", _shipId, "name")] = _name;
313         uintStorage[_b1("ships", _shipId, "hp")] = _hp;
314         uintStorage[_b1("ships", _shipId, "block")] = _block;
315         uintStorage[_b1("ships", _shipId, "price")] = _price;
316     }
317 
318     // update data for an item by ID
319     function _update(string _itemType, uint256 _itemId, string _name, uint256 _value, uint256 _price, uint256 _durability) private {
320         stringStorage[_b1(_itemType, _itemId, "name")] = _name;
321         uintStorage[_b1(_itemType, _itemId, "value")] = _value;
322         uintStorage[_b1(_itemType, _itemId, "price")] = _price;
323         uintStorage[_b1(_itemType, _itemId, "durability")] = _durability;
324     }
325 
326     // Radars
327     function createRadar(uint256 _radarId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
328         mI.createRadar(_radarId);
329         _update("radars", _radarId, _name, _value, _price, _durability);
330     }
331 
332     // Scanners
333     function createScanner(uint256 _scannerId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
334         mI.createScanner(_scannerId);
335         _update("scanners", _scannerId, _name, _value, _price, _durability);
336     }
337 
338     // Droids
339     function createDroid(uint256 _droidId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
340         mI.createDroid(_droidId);
341         _update("droids", _droidId, _name, _value, _price, _durability);
342     }
343 
344     // Fuels
345     function createFuel(uint256 _fuelId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
346         mI.createFuel(_fuelId);
347         _update("fuels", _fuelId, _name, _value, _price, _durability);
348     }
349 
350     // Generators
351     function createGenerator(uint256 _generatorId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
352         mI.createGenerator(_generatorId);
353         _update("generators", _generatorId, _name, _value, _price, _durability);
354     }
355 
356     // Engines
357     function createEngine(uint256 _engineId, string _name, uint256 _speed, uint256 _giper, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
358         mI.createEngine(_engineId);
359         stringStorage[_b1("engines", _engineId, "name")] = _name;
360         uintStorage[_b1("engines", _engineId, "speed")] = _speed;
361         uintStorage[_b1("engines", _engineId, "giper")] = _giper;
362         uintStorage[_b1("engines", _engineId, "price")] = _price;
363         uintStorage[_b1("engines", _engineId, "durability")] = _durability;
364     }
365 
366     // Guns
367     function createGun(uint256 _gunId, string _name, uint256 _min, uint256 _max, uint256 _radius, uint256 _recharge, uint256 _ability,  uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
368         mI.createGun(_gunId);
369         stringStorage[_b1("guns", _gunId, "name")] = _name;
370         uintStorage[_b1("guns", _gunId, "min")] = _min;
371         uintStorage[_b1("guns", _gunId, "max")] = _max;
372         uintStorage[_b1("guns", _gunId, "radius")] = _radius;
373         uintStorage[_b1("guns", _gunId, "recharge")] = _recharge;
374         uintStorage[_b1("guns", _gunId, "ability")] = _ability;
375         uintStorage[_b1("guns", _gunId, "price")] = _price;
376         uintStorage[_b1("guns", _gunId, "durability")] = _durability;
377     }
378 
379     // Micro modules
380     function createMicroModule(uint256 _microModuleId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus, uint256 _level, uint256 _price) public onlyOwnerOfStorage {
381         mI.createMicroModule(_microModuleId);
382         stringStorage[_b1("microModules", _microModuleId, "name")] = _name;
383         uintStorage[_b1("microModules", _microModuleId, "itemType")] = _itemType;
384         uintStorage[_b1("microModules", _microModuleId, "bonusType")] = _bonusType;
385         uintStorage[_b1("microModules", _microModuleId, "bonus")] = _bonus;
386         uintStorage[_b1("microModules", _microModuleId, "level")] = _level;
387         uintStorage[_b1("microModules", _microModuleId, "price")] = _price;
388     }
389 
390     // Artefacts
391     function createArtefact(uint256 _artefactId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus) public onlyOwnerOfStorage {
392         mI.createArtefact(_artefactId);
393         stringStorage[_b1("artefacts", _artefactId, "name")] = _name;
394         uintStorage[_b1("artefacts", _artefactId, "itemType")] = _itemType;
395         uintStorage[_b1("artefacts", _artefactId, "bonusType")] = _bonusType;
396         uintStorage[_b1("artefacts", _artefactId, "bonus")] = _bonus;
397     }
398 
399     /* ------ DEV FUNCTIONS ------ */
400 
401     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyLogicContract {
402         uintStorage[_b1(_itemType, _itemTypeId, "price")] = _newPrice;
403     }
404 
405     /* ------ CHANGE OWNERSHIP OF STORAGE ------ */
406 
407     function transferOwnershipOfStorage(address _newOwnerOfStorage) public onlyOwnerOfStorage {
408         _transferOwnershipOfStorage(_newOwnerOfStorage);
409     }
410 
411     function _transferOwnershipOfStorage(address _newOwnerOfStorage) private {
412         require(_newOwnerOfStorage != address(0));
413         ownerOfStorage = _newOwnerOfStorage;
414     }
415 
416     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
417 
418     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfStorage {
419         _changeLogicContractAddress(_newLogicContractAddress);
420     }
421 
422     function _changeLogicContractAddress(address _newLogicContractAddress) private {
423         require(_newLogicContractAddress != address(0));
424         logicContractAddress = _newLogicContractAddress;
425     }
426 }