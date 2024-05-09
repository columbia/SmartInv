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
82         mI = ItemsInterfaceForEternalStorage(0x504c53cBd44B68001Ec8A2728679c07BB78283f0);
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
123     function buyItem(uint256 _itemId, address _newOwner, string _itemTitle, string _itemTypeTitle) public onlyLogicContract returns(uint256) {
124         uint256 newItemId = mI.addItem(_itemTitle);
125         uintStorage[_b3(_itemTypeTitle, newItemId)] = _itemId;
126         addressStorage[_b4(_itemTitle, newItemId)] = _newOwner;
127 
128         return _itemId;
129     }
130 
131     function destroyEternalStorage() public onlyOwnerOfStorage {
132         selfdestruct(0xd135377eB20666725D518c967F23e168045Ee11F);
133     }
134 
135     /* ------ HASH FUNCTIONS ------ */
136 
137     function _b1(string _itemType, uint256 _itemId, string _property) private pure returns(bytes32) {
138         return keccak256(abi.encodePacked(_itemType, _itemId, _property));
139     }
140 
141     function _b3(string _itemType, uint256 _itemId) private pure returns(bytes32) {
142         return keccak256(abi.encodePacked(_itemType, _itemId));
143     }
144 
145     function _b4(string _itemType, uint256 _itemId) private pure returns(bytes32) {
146         return keccak256(abi.encodePacked("owner", _itemType, _itemId));
147     }
148 
149     /* ------ READING METHODS FOR USERS ITEMS ------ */
150 
151     function getOwnerByItemTypeAndId(string _itemType, uint256 _itemId) public onlyLogicContract view returns(address) {
152         return addressStorage[_b4(_itemType, _itemId)];
153     }
154 
155     function getItemTypeIdByTypeAndId(string _itemTypeTitle, uint256 _itemId) public onlyLogicContract view returns(uint256) {
156         return uintStorage[_b3(_itemTypeTitle, _itemId)];
157     }
158 
159      /* ------ READING METHODS FOR ALL ITEMS ------ */
160 
161     function getItemPriceById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(uint256) {
162         return uintStorage[_b1(_itemType, _itemId, "price")];
163     }
164 
165     // Get Radar, Scanner, Droid, Fuel, Generator by ID
166     function getTypicalItemById(string _itemType, uint256 _itemId) public onlyLogicContract view returns(
167         uint256,
168         string,
169         uint256,
170         uint256,
171         uint256
172     ) {
173         return (
174             _itemId,
175             stringStorage[_b1(_itemType, _itemId, "name")],
176             uintStorage[_b1(_itemType, _itemId, "value")],
177             uintStorage[_b1(_itemType, _itemId, "price")],
178             uintStorage[_b1(_itemType, _itemId, "durability")]
179         );
180     }
181 
182     function getShipById(uint256 _shipId) public onlyLogicContract view returns(
183         uint256,
184         string,
185         uint256,
186         uint256,
187         uint256
188     ) {
189         return (
190             _shipId,
191             stringStorage[_b1("ships", _shipId, "name")],
192             uintStorage[_b1("ships", _shipId, "hp")],
193             uintStorage[_b1("ships", _shipId, "block")],
194             uintStorage[_b1("ships", _shipId, "price")]
195         );
196     }
197 
198     function getEngineById(uint256 _engineId) public onlyLogicContract view returns(
199         uint256,
200         string,
201         uint256,
202         uint256,
203         uint256,
204         uint256
205     ) {
206         return (
207             _engineId,
208             stringStorage[_b1("engines", _engineId, "name")],
209             uintStorage[_b1("engines", _engineId, "speed")],
210             uintStorage[_b1("engines", _engineId, "giper")],
211             uintStorage[_b1("engines", _engineId, "price")],
212             uintStorage[_b1("engines", _engineId, "durability")]
213         );
214     }
215 
216     function getGunByIdPart1(uint256 _gunId) public onlyLogicContract view returns(
217         uint256,
218         string,
219         uint256,
220         uint256
221     ) {
222         return (
223             _gunId,
224             stringStorage[_b1("guns", _gunId, "name")],
225             uintStorage[_b1("guns", _gunId, "min")],
226             uintStorage[_b1("guns", _gunId, "max")]
227         );
228     }
229 
230     function getGunByIdPart2(uint256 _gunId) public onlyLogicContract view returns(
231         uint256,
232         uint256,
233         uint256,
234         uint256,
235         uint256
236     ) {
237         return (
238             uintStorage[_b1("guns", _gunId, "radius")],
239             uintStorage[_b1("guns", _gunId, "recharge")],
240             uintStorage[_b1("guns", _gunId, "ability")],
241             uintStorage[_b1("guns", _gunId, "price")],
242             uintStorage[_b1("guns", _gunId, "durability")]
243         );
244     }
245 
246     function getMicroModuleByIdPart1(uint256 _microModuleId) public onlyLogicContract view returns(
247         uint256,
248         string,
249         uint256,
250         uint256
251     ) {
252         return (
253             _microModuleId,
254             stringStorage[_b1("microModules", _microModuleId, "name")],
255             uintStorage[_b1("microModules", _microModuleId, "itemType")],
256             uintStorage[_b1("microModules", _microModuleId, "bonusType")]
257         );
258     }
259 
260     function getMicroModuleByIdPart2(uint256 _microModuleId) public onlyLogicContract view returns(
261         uint256,
262         uint256,
263         uint256
264     ) {
265         return (
266             uintStorage[_b1("microModules", _microModuleId, "bonus")],
267             uintStorage[_b1("microModules", _microModuleId, "level")],
268             uintStorage[_b1("microModules", _microModuleId, "price")]
269         );
270     }
271 
272     function getArtefactById(uint256 _artefactId) public onlyLogicContract view returns(
273         uint256,
274         string,
275         uint256,
276         uint256,
277         uint256
278     ) {
279         return (
280             _artefactId,
281             stringStorage[_b1("artefacts", _artefactId, "name")],
282             uintStorage[_b1("artefacts", _artefactId, "itemType")],
283             uintStorage[_b1("artefacts", _artefactId, "bonusType")],
284             uintStorage[_b1("artefacts", _artefactId, "bonus")]
285         );
286     }
287     
288     /* ------ DEV CREATION METHODS ------ */
289 
290     // Ships
291     function createShip(uint256 _shipId, string _name, uint256 _hp, uint256 _block, uint256 _price) public onlyOwnerOfStorage {
292         mI.createShip(_shipId);
293         stringStorage[_b1("ships", _shipId, "name")] = _name;
294         uintStorage[_b1("ships", _shipId, "hp")] = _hp;
295         uintStorage[_b1("ships", _shipId, "block")] = _block;
296         uintStorage[_b1("ships", _shipId, "price")] = _price;
297     }
298 
299     // update data for an item by ID
300     function _update(string _itemType, uint256 _itemId, string _name, uint256 _value, uint256 _price, uint256 _durability) private {
301         stringStorage[_b1(_itemType, _itemId, "name")] = _name;
302         uintStorage[_b1(_itemType, _itemId, "value")] = _value;
303         uintStorage[_b1(_itemType, _itemId, "price")] = _price;
304         uintStorage[_b1(_itemType, _itemId, "durability")] = _durability;
305     }
306 
307     // Radars
308     function createRadar(uint256 _radarId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
309         mI.createRadar(_radarId);
310         _update("radars", _radarId, _name, _value, _price, _durability);
311     }
312 
313     // Scanners
314     function createScanner(uint256 _scannerId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
315         mI.createScanner(_scannerId);
316         _update("scanners", _scannerId, _name, _value, _price, _durability);
317     }
318 
319     // Droids
320     function createDroid(uint256 _droidId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
321         mI.createDroid(_droidId);
322         _update("droids", _droidId, _name, _value, _price, _durability);
323     }
324 
325     // Fuels
326     function createFuel(uint256 _fuelId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
327         mI.createFuel(_fuelId);
328         _update("fuels", _fuelId, _name, _value, _price, _durability);
329     }
330 
331     // Generators
332     function createGenerator(uint256 _generatorId, string _name, uint256 _value, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
333         mI.createGenerator(_generatorId);
334         _update("generators", _generatorId, _name, _value, _price, _durability);
335     }
336 
337     // Engines
338     function createEngine(uint256 _engineId, string _name, uint256 _speed, uint256 _giper, uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
339         mI.createEngine(_engineId);
340         stringStorage[_b1("engines", _engineId, "name")] = _name;
341         uintStorage[_b1("engines", _engineId, "speed")] = _speed;
342         uintStorage[_b1("engines", _engineId, "giper")] = _giper;
343         uintStorage[_b1("engines", _engineId, "price")] = _price;
344         uintStorage[_b1("engines", _engineId, "durability")] = _durability;
345     }
346 
347     // Guns
348     function createGun(uint256 _gunId, string _name, uint256 _min, uint256 _max, uint256 _radius, uint256 _recharge, uint256 _ability,  uint256 _price, uint256 _durability) public onlyOwnerOfStorage {
349         mI.createGun(_gunId);
350         stringStorage[_b1("guns", _gunId, "name")] = _name;
351         uintStorage[_b1("guns", _gunId, "min")] = _min;
352         uintStorage[_b1("guns", _gunId, "max")] = _max;
353         uintStorage[_b1("guns", _gunId, "radius")] = _radius;
354         uintStorage[_b1("guns", _gunId, "recharge")] = _recharge;
355         uintStorage[_b1("guns", _gunId, "ability")] = _ability;
356         uintStorage[_b1("guns", _gunId, "price")] = _price;
357         uintStorage[_b1("guns", _gunId, "durability")] = _durability;
358     }
359 
360     // Micro modules
361     function createMicroModule(uint256 _microModuleId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus, uint256 _level, uint256 _price) public onlyOwnerOfStorage {
362         mI.createMicroModule(_microModuleId);
363         stringStorage[_b1("microModules", _microModuleId, "name")] = _name;
364         uintStorage[_b1("microModules", _microModuleId, "itemType")] = _itemType;
365         uintStorage[_b1("microModules", _microModuleId, "bonusType")] = _bonusType;
366         uintStorage[_b1("microModules", _microModuleId, "bonus")] = _bonus;
367         uintStorage[_b1("microModules", _microModuleId, "level")] = _level;
368         uintStorage[_b1("microModules", _microModuleId, "price")] = _price;
369     }
370 
371     // Artefacts
372     function createArtefact(uint256 _artefactId, string _name, uint256 _itemType, uint256 _bonusType, uint256 _bonus) public onlyOwnerOfStorage {
373         mI.createArtefact(_artefactId);
374         stringStorage[_b1("artefacts", _artefactId, "name")] = _name;
375         uintStorage[_b1("artefacts", _artefactId, "itemType")] = _itemType;
376         uintStorage[_b1("artefacts", _artefactId, "bonusType")] = _bonusType;
377         uintStorage[_b1("artefacts", _artefactId, "bonus")] = _bonus;
378     }
379 
380     /* ------ DEV FUNCTIONS ------ */
381 
382     function setNewPriceToItem(string _itemType, uint256 _itemTypeId, uint256 _newPrice) public onlyLogicContract {
383         uintStorage[_b1(_itemType, _itemTypeId, "price")] = _newPrice;
384     }
385 
386     /* ------ CHANGE OWNERSHIP OF STORAGE ------ */
387 
388     function transferOwnershipOfStorage(address _newOwnerOfStorage) public onlyOwnerOfStorage {
389         _transferOwnershipOfStorage(_newOwnerOfStorage);
390     }
391 
392     function _transferOwnershipOfStorage(address _newOwnerOfStorage) private {
393         require(_newOwnerOfStorage != address(0));
394         ownerOfStorage = _newOwnerOfStorage;
395     }
396 
397     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
398 
399     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfStorage {
400         _changeLogicContractAddress(_newLogicContractAddress);
401     }
402 
403     function _changeLogicContractAddress(address _newLogicContractAddress) private {
404         require(_newLogicContractAddress != address(0));
405         logicContractAddress = _newLogicContractAddress;
406     }
407 }