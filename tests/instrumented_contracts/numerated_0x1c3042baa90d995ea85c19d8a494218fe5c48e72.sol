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
100         createShip(1, 'Titanium Ranger Hull', 200, 2, 0.2 ether);
101         createShip(2, 'Platinum Ranger Hull', 400, 4, 0.5 ether);
102         createShip(3, 'Adamantium Ranger Hull', 600, 7, 1 ether);
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
130         addressStorage[_b3(_itemTitle, newItemId)] = _newOwner;
131         return _itemId;
132     }
133 
134     /* ------ READING METHODS FOR USERS ITEMS ------ */
135 
136     function getNumberOfItemsByTypeAndOwner(string _itemType, address _owner) public onlyLogicContract view returns(uint256) {
137         return uintStorage[_b2(_itemType, _owner)];
138     }
139 
140     function getItemsByTypeAndOwner(string _itemTypeTitle, address _owner) public onlyLogicContract view returns(uint256[]) {
141         return uintArrayStorage[_b2(_itemTypeTitle, _owner)];
142     }
143 
144     function getItemsIdsByTypeAndOwner(string _itemIdsTitle, address _owner) public onlyLogicContract view returns(uint256[]) {
145         return uintArrayStorage[_b2(_itemIdsTitle, _owner)];
146     }
147 
148     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public onlyLogicContract view returns(address) {
149         return addressStorage[_b3(_itemType, _itemId)];
150     }
151 
152      /* ------ READING METHODS FOR ALL ITEMS ------ */
153 
154     function getItemPriceById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(uint256) {
155         return uintStorage[_b1(_itemType, _itemId, "price")];
156     }
157 
158     // Get Radar, Scanner, Droid, Fuel, Generator by ID
159     function getTypicalItemById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(
160         uint256,
161         string,
162         uint256,
163         uint256,
164         uint256
165     ) {
166         return (
167             _itemId,
168             stringStorage[_b1(_itemType, _itemId, "name")],
169             uintStorage[_b1(_itemType, _itemId, "value")],
170             uintStorage[_b1(_itemType, _itemId, "price")],
171             uintStorage[_b1(_itemType, _itemId, "durability")]
172         );
173     }
174 
175     function getShipById(uint256 _shipId) public onlyLogicContract view returns(
176         uint256,
177         string,
178         uint256,
179         uint256,
180         uint256
181     ) {
182         return (
183             _shipId,
184             stringStorage[_b1("ships", _shipId, "name")],
185             uintStorage[_b1("ships", _shipId, "hp")],
186             uintStorage[_b1("ships", _shipId, "block")],
187             uintStorage[_b1("ships", _shipId, "price")]
188         );
189     }
190 
191     function getEngineById(uint256 _engineId) public onlyLogicContract view returns(
192         uint256,
193         string,
194         uint256,
195         uint256,
196         uint256,
197         uint256
198     ) {
199         return (
200             _engineId,
201             stringStorage[_b1("engines", _engineId, "name")],
202             uintStorage[_b1("engines", _engineId, "speed")],
203             uintStorage[_b1("engines", _engineId, "giper")],
204             uintStorage[_b1("engines", _engineId, "price")],
205             uintStorage[_b1("engines", _engineId, "durability")]
206         );
207     }
208 
209     function getGunByIdPart1(uint256 _gunId) public onlyLogicContract view returns(
210         uint256,
211         string,
212         uint256,
213         uint256
214     ) {
215         return (
216             _gunId,
217             stringStorage[_b1("guns", _gunId, "name")],
218             uintStorage[_b1("guns", _gunId, "min")],
219             uintStorage[_b1("guns", _gunId, "max")]
220         );
221     }
222 
223     function getGunByIdPart2(uint256 _gunId) public onlyLogicContract view returns(
224         uint256,
225         uint256,
226         uint256,
227         uint256,
228         uint256
229     ) {
230         return (
231             uintStorage[_b1("guns", _gunId, "radius")],
232             uintStorage[_b1("guns", _gunId, "recharge")],
233             uintStorage[_b1("guns", _gunId, "ability")],
234             uintStorage[_b1("guns", _gunId, "price")],
235             uintStorage[_b1("guns", _gunId, "durability")]
236         );
237     }
238 
239     function getMicroModuleByIdPart1(uint256 _microModuleId) public onlyLogicContract view returns(
240         uint256,
241         string,
242         uint256,
243         uint256
244     ) {
245         return (
246             _microModuleId,
247             stringStorage[_b1("microModules", _microModuleId, "name")],
248             uintStorage[_b1("microModules", _microModuleId, "itemType")],
249             uintStorage[_b1("microModules", _microModuleId, "bonusType")]
250         );
251     }
252 
253     function getMicroModuleByIdPart2(uint256 _microModuleId) public onlyLogicContract view returns(
254         uint256,
255         uint256,
256         uint256
257     ) {
258         return (
259             uintStorage[_b1("microModules", _microModuleId, "bonus")],
260             uintStorage[_b1("microModules", _microModuleId, "level")],
261             uintStorage[_b1("microModules", _microModuleId, "price")]
262         );
263     }
264 
265     function getArtefactById(uint256 _artefactId) public onlyLogicContract view returns(
266         uint256,
267         string,
268         uint256,
269         uint256,
270         uint256
271     ) {
272         return (
273             _artefactId,
274             stringStorage[_b1("artefacts", _artefactId, "name")],
275             uintStorage[_b1("artefacts", _artefactId, "itemType")],
276             uintStorage[_b1("artefacts", _artefactId, "bonusType")],
277             uintStorage[_b1("artefacts", _artefactId, "bonus")]
278         );
279     }
280     
281     /* ------ DEV CREATION METHODS ------ */
282 
283     // Ships
284     function createShip(uint256 _shipId, string _name, uint256 _hp, uint256 _block, uint256 _price) public onlyOwnerOfStorage {
285         mI.createShip(_shipId);
286         stringStorage[_b1("ships", _shipId, "name")] = _name;
287         uintStorage[_b1("ships", _shipId, "hp")] = _hp;
288         uintStorage[_b1("ships", _shipId, "block")] = _block;
289         uintStorage[_b1("ships", _shipId, "price")] = _price;
290     }
291 
292     // update data for an item by ID
293     function _update(string _itemType, uint256 _itemId, string _name, uint256 _value, uint256 _price, uint256 _durability) private {
294         stringStorage[_b1(_itemType, _itemId, "name")] = _name;
295         uintStorage[_b1(_itemType, _itemId, "value")] = _value;
296         uintStorage[_b1(_itemType, _itemId, "price")] = _price;
297         uintStorage[_b1(_itemType, _itemId, "durability")] = _durability;
298     }
299 
300     // Radars
301     function createRadar(uint256 _radarId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
302         mI.createRadar(_radarId);
303         _update("radars", _radarId, _name, _value, _price, _durability);
304     }
305 
306     // Scanners
307     function createScanner(uint256 _scannerId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
308         mI.createScanner(_scannerId);
309         _update("scanners", _scannerId, _name, _value, _price, _durability);
310     }
311 
312     // Droids
313     function createDroid(uint256 _droidId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
314         mI.createDroid(_droidId);
315         _update("droids", _droidId, _name, _value, _price, _durability);
316     }
317 
318     // Fuels
319     function createFuel(uint256 _fuelId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
320         mI.createFuel(_fuelId);
321         _update("fuels", _fuelId, _name, _value, _price, _durability);
322     }
323 
324     // Generators
325     function createGenerator(uint256 _generatorId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
326         mI.createGenerator(_generatorId);
327         _update("generators", _generatorId, _name, _value, _price, _durability);
328     }
329 
330     // Engines
331     function createEngine(uint256 _engineId, string _name, uint256 _speed, uint256 _giper, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
332         mI.createEngine(_engineId);
333         stringStorage[_b1("engines", _engineId, "name")] = _name;
334         uintStorage[_b1("engines", _engineId, "speed")] = _speed;
335         uintStorage[_b1("engines", _engineId, "giper")] = _giper;
336         uintStorage[_b1("engines", _engineId, "price")] = _price;
337         uintStorage[_b1("engines", _engineId, "durability")] = _durability;
338     }
339 
340     // Guns
341     function createGun(uint256 _gunId, string _name, uint256 _min, uint256 _max, uint256 _radius, uint256 _recharge, uint256 _ability,  uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
342         mI.createGun(_gunId);
343         stringStorage[_b1("guns", _gunId, "name")] = _name;
344         uintStorage[_b1("guns", _gunId, "min")] = _min;
345         uintStorage[_b1("guns", _gunId, "max")] = _max;
346         uintStorage[_b1("guns", _gunId, "radius")] = _radius;
347         uintStorage[_b1("guns", _gunId, "recharge")] = _recharge;
348         uintStorage[_b1("guns", _gunId, "ability")] = _ability;
349         uintStorage[_b1("guns", _gunId, "price")] = _price;
350         uintStorage[_b1("guns", _gunId, "durability")] = _durability;
351     }
352 
353     // Micro modules
354     function createMicroModule(uint256 _microModuleId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus, uint256 _level, uint256 _price) public onlyOwnerOfStorage {
355         mI.createMicroModule(_microModuleId);
356         stringStorage[_b1("microModules", _microModuleId, "name")] = _name;
357         uintStorage[_b1("microModules", _microModuleId, "itemType")] = _itemType;
358         uintStorage[_b1("microModules", _microModuleId, "bonusType")] = _bonusType;
359         uintStorage[_b1("microModules", _microModuleId, "bonus")] = _bonus;
360         uintStorage[_b1("microModules", _microModuleId, "level")] = _level;
361         uintStorage[_b1("microModules", _microModuleId, "price")] = _price;
362     }
363 
364     // Artefacts
365     function createArtefact(uint256 _artefactId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus) public onlyOwnerOfStorage {
366         mI.createArtefact(_artefactId);
367         stringStorage[_b1("artefacts", _artefactId, "name")] = _name;
368         uintStorage[_b1("artefacts", _artefactId, "itemType")] = _itemType;
369         uintStorage[_b1("artefacts", _artefactId, "bonusType")] = _bonusType;
370         uintStorage[_b1("artefacts", _artefactId, "bonus")] = _bonus;
371     }
372 
373     /* ------ DEV FUNCTIONS ------ */
374 
375     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyLogicContract {
376         uintStorage[_b1(_itemType, _itemTypeId, "price")] = _newPrice;
377     }
378 
379     /* ------ HASH FUNCTIONS ------ */
380 
381     function _b1(string _itemType, uint256 _itemId, string _property) private pure returns(bytes32) {
382         return keccak256(abi.encodePacked(_itemType, _itemId, _property));
383     }
384 
385     function _b2(string _itemType, address _newOwnerAddress) private pure returns(bytes32) {
386         return keccak256(abi.encodePacked(_itemType, _newOwnerAddress));
387     }
388 
389     function _b3(string _itemType, uint256 _itemId) private pure returns(bytes32) {
390         return keccak256(abi.encodePacked(_itemType, _itemId));
391     }
392 
393     /* ------ CHANGE OWNERSHIP OF STORAGE ------ */
394 
395     function transferOwnershipOfStorage(address _newOwnerOfStorage) public onlyOwnerOfStorage {
396         _transferOwnershipOfStorage(_newOwnerOfStorage);
397     }
398 
399     function _transferOwnershipOfStorage(address _newOwnerOfStorage) private {
400         require(_newOwnerOfStorage != address(0));
401         ownerOfStorage = _newOwnerOfStorage;
402     }
403 
404     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
405 
406     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfStorage {
407         _changeLogicContractAddress(_newLogicContractAddress);
408     }
409 
410     function _changeLogicContractAddress(address _newLogicContractAddress) private {
411         require(_newLogicContractAddress != address(0));
412         logicContractAddress = _newLogicContractAddress;
413     }
414 }