1 pragma solidity 0.4.24;
2 
3 contract ItemsStorage {
4 
5     /* ------ ITEMS STORAGE ------ */
6 
7     uint256[] private ships;
8     uint256[] private radars;
9     uint256[] private scanners;
10     uint256[] private droids;
11     uint256[] private engines;
12     uint256[] private fuels;
13     uint256[] private generators;
14     uint256[] private guns;
15     uint256[] private microModules;
16     uint256[] private artefacts;
17 
18     uint256[] private usersShips;
19     uint256[] private usersRadars;
20     uint256[] private usersScanners;
21     uint256[] private usersDroids;
22     uint256[] private usersEngines;
23     uint256[] private usersFuels;
24     uint256[] private usersGenerators;
25     uint256[] private usersGuns;
26     uint256[] private usersMicroModules;
27     uint256[] private usersArtefacts;
28 
29     address private ownerOfItemsStorage;
30     address private logicContractAddress;
31     address private eternalStorageContractAddress;
32 
33     constructor() public {
34         ownerOfItemsStorage = msg.sender;
35     }
36 
37     /* ------ MODIFIERS ------ */
38 
39     modifier onlyOwnerOfItemsStorage() {
40         require(msg.sender == ownerOfItemsStorage);
41         _;
42     }
43 
44     modifier onlyLogicContract() {
45         require(msg.sender == logicContractAddress);
46         _;
47     }
48 
49     modifier onlyEternalStorageContract() {
50         require(msg.sender == eternalStorageContractAddress);
51         _;
52     }
53 
54     /* ------ BUY OPERATION ------ */
55 
56     function _compareStrings (string _string1, string _string2) private pure returns (bool) {
57        return keccak256(abi.encodePacked(_string1)) == keccak256(abi.encodePacked(_string2));
58     }
59 
60     function addItem(string _itemType) public onlyEternalStorageContract returns(uint256) {
61 
62         uint256 newItemId;
63         if (_compareStrings(_itemType, "ship")) {
64             newItemId = usersShips.length + 1;
65             usersShips.push(newItemId);
66         } else if (_compareStrings(_itemType, "radar")) {
67             newItemId = usersRadars.length + 1;
68             usersRadars.push(newItemId);
69         } else if (_compareStrings(_itemType, "scanner")) {
70             newItemId = usersScanners.length + 1;
71             usersScanners.push(newItemId);
72         } else if (_compareStrings(_itemType, "droid")) {
73             newItemId = usersDroids.length + 1;
74             usersDroids.push(newItemId);
75         } else if (_compareStrings(_itemType, "engine")) {
76             newItemId = usersEngines.length + 1;
77             usersEngines.push(newItemId);
78         } else if (_compareStrings(_itemType, "fuel")) {
79             newItemId = usersFuels.length + 1;
80             usersFuels.push(newItemId);
81         } else if (_compareStrings(_itemType, "generator")) {
82             newItemId = usersGenerators.length + 1;
83             usersGenerators.push(newItemId);
84         } else if (_compareStrings(_itemType, "gun")) {
85             newItemId = usersGuns.length + 1;
86             usersGuns.push(newItemId);
87         } else if (_compareStrings(_itemType, "microModule")) {
88             newItemId = usersMicroModules.length + 1;
89             usersMicroModules.push(newItemId);
90         }
91 
92         return newItemId;
93     }
94 
95     /* ------ GET ALL POSSIBLE USERS ITEMS ------ */
96 
97     function getUsersShipsIds() public onlyLogicContract view returns(uint256[]) {
98         return usersShips;
99     }
100 
101     function getUsersRadarsIds() public onlyLogicContract view returns(uint256[]) {
102         return usersRadars;
103     }
104 
105     function getUsersScannersIds() public onlyLogicContract view returns(uint256[]) {
106         return usersScanners;
107     }
108 
109     function getUsersDroidsIds() public onlyLogicContract view returns(uint256[]) {
110         return usersDroids;
111     }
112 
113     function getUsersEnginesIds() public onlyLogicContract view returns(uint256[]) {
114         return usersEngines;
115     }
116 
117     function getUsersFuelsIds() public onlyLogicContract view returns(uint256[]) {
118         return usersFuels;
119     }
120 
121     function getUsersGeneratorsIds() public onlyLogicContract view returns(uint256[]) {
122         return usersGenerators;
123     }
124 
125     function getUsersGunsIds() public onlyLogicContract view returns(uint256[]) {
126         return usersGuns;
127     }
128 
129     function getUsersMicroModulesIds() public onlyLogicContract view returns(uint256[]) {
130         return usersMicroModules;
131     }
132 
133     function getUsersArtefactsIds() public onlyLogicContract view returns(uint256[]) {
134         return usersArtefacts;
135     }
136 
137      /* ------ READING METHODS FOR ALL ITEMS ------ */
138 
139 
140     function getShipsIds() public onlyLogicContract view returns(uint256[]) {
141         return ships;
142     }
143 
144     function getRadarsIds() public onlyLogicContract view returns(uint256[]) {
145         return radars;
146     }
147 
148     function getScannersIds() public onlyLogicContract view returns(uint256[]) {
149         return scanners;
150     }
151 
152     function getDroidsIds() public onlyLogicContract view returns(uint256[]) {
153         return droids;
154     }
155 
156     function getEnginesIds() public onlyLogicContract view returns(uint256[]) {
157         return engines;
158     }
159 
160     function getFuelsIds() public onlyLogicContract view returns(uint256[]) {
161         return fuels;
162     }
163 
164     function getGeneratorsIds() public onlyLogicContract view returns(uint256[]) {
165         return generators;
166     }
167 
168     function getGunsIds() public onlyLogicContract view returns(uint256[]) {
169         return guns;
170     }
171 
172     function getMicroModulesIds() public onlyLogicContract view returns(uint256[]) {
173         return microModules;
174     }
175 
176     function getArtefactsIds() public onlyLogicContract view returns(uint256[]) {
177         return artefacts;
178     }
179     
180     /* ------ DEV CREATION METHODS ------ */
181 
182     // Ships
183     function createShip(uint256 _shipId) public onlyEternalStorageContract {
184         ships.push(_shipId);
185     }
186 
187     // Radars
188     function createRadar(uint256 _radarId) public onlyEternalStorageContract {
189         radars.push(_radarId);
190     }
191 
192     // Scanners
193     function createScanner(uint256 _scannerId) public onlyEternalStorageContract {
194         scanners.push(_scannerId);
195     }
196 
197     // Droids
198     function createDroid(uint256 _droidId) public onlyEternalStorageContract {
199         droids.push(_droidId);
200     }
201 
202     // Fuels
203     function createFuel(uint256 _fuelId) public onlyEternalStorageContract {
204         fuels.push(_fuelId);
205     }
206 
207     // Generators
208     function createGenerator(uint256 _generatorId) public onlyEternalStorageContract {
209         generators.push(_generatorId);
210     }
211 
212     // Engines
213     function createEngine(uint256 _engineId) public onlyEternalStorageContract {
214         engines.push(_engineId);
215     }
216 
217     // Guns
218     function createGun(uint256 _gunId) public onlyEternalStorageContract {
219         guns.push(_gunId);
220     }
221 
222     // Micro modules
223     function createMicroModule(uint256 _microModuleId) public onlyEternalStorageContract {
224         microModules.push(_microModuleId);
225     }
226 
227     // Artefacts
228     function createArtefact(uint256 _artefactId) public onlyEternalStorageContract {
229         artefacts.push(_artefactId);
230     }
231 
232 
233     /* ------ CHANGE OWNERSHIP OF ITEMS STORAGE ------ */
234 
235     function transferOwnershipOfItemsStorage(address _newOwnerOfItemsStorage) public onlyOwnerOfItemsStorage {
236         _transferOwnershipOfItemsStorage(_newOwnerOfItemsStorage);
237     }
238 
239     function _transferOwnershipOfItemsStorage(address _newOwnerOfItemsStorage) private {
240         require(_newOwnerOfItemsStorage != address(0));
241         ownerOfItemsStorage = _newOwnerOfItemsStorage;
242     }
243 
244     /* ------ CHANGE LOGIC CONTRACT ADDRESS ------ */
245 
246     function changeLogicContractAddress(address _newLogicContractAddress) public onlyOwnerOfItemsStorage {
247         _changeLogicContractAddress(_newLogicContractAddress);
248     }
249 
250     function _changeLogicContractAddress(address _newLogicContractAddress) private {
251         require(_newLogicContractAddress != address(0));
252         logicContractAddress = _newLogicContractAddress;
253     }
254 
255     /* ------ CHANGE ETERNAL STORAGE CONTRACT ADDRESS ------ */
256 
257     function changeEternalStorageContractAddress(address _newEternalStorageContractAddress) public onlyOwnerOfItemsStorage {
258         _changeEternalStorageContractAddress(_newEternalStorageContractAddress);
259     }
260 
261     function _changeEternalStorageContractAddress(address _newEternalStorageContractAddress) private {
262         require(_newEternalStorageContractAddress != address(0));
263         eternalStorageContractAddress = _newEternalStorageContractAddress;
264     }
265 }