1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) { return 0; }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17   
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 
26 contract Manageable {
27 
28   address public owner;
29   address public manager;
30   bool public contractLock;
31   
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33   event ManagerTransferred(address indexed previousManager, address indexed newManager);
34   event ContractLockChanged(address admin, bool state);
35 
36   constructor() public {
37     owner = msg.sender;
38     manager = msg.sender;
39     contractLock = false;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   modifier onlyAdmin() {
48     require((msg.sender == manager) || (msg.sender == owner));
49     _;
50   }
51 
52   modifier isUnlocked() {
53     require(!contractLock);
54     _;
55   }
56 
57   function transferManager(address newManager) public onlyAdmin {
58     require(_addrNotNull(newManager));
59     emit ManagerTransferred(manager, newManager);
60     manager = newManager;
61   }
62 
63   function transferOwner(address _newOwner) public onlyOwner {
64     require(_newOwner != address(0));
65     emit OwnershipTransferred(owner, _newOwner);
66     owner = _newOwner;
67   }
68 
69   function setContractLock(bool setting) public onlyAdmin {
70     contractLock = setting;
71     emit ContractLockChanged(msg.sender, setting);
72   }
73 
74   function _addrNotNull(address _to) internal pure returns (bool) {
75     return(_to != address(0));
76   }
77 }
78 
79 
80 contract CryptoFlipCar2 is Manageable {
81   using SafeMath for uint256;
82 
83   uint256 private constant TYPE_CAR = 3;
84   uint256 private constant TYPE_MAKE = 2;
85   uint256 private constant TYPE_COMPANY = 1;
86   uint256 private constant TYPE_WHALE = 0;
87 
88   uint256 private constant ADDR_M = (2**160)-1;
89   uint256 private constant PRICE_M = (2**96)-1;
90   uint256 private constant MAKE_PRICE_M = (2**91)-1;
91   uint256 private constant COMPANY_ID_M = (2**5)-1;
92   uint256 private constant RACE_ID_M = (2**96)-1;
93   uint256 private constant RACE_BET_M = (2**128) - 1;
94   uint256 private constant WINNER_M = (2**2)-1;
95   uint256 private constant PINKSLIP_M = (2**1)-1;
96   uint256 private constant STATE_M = (2**2)-1;
97 
98   uint256 private constant ADDR_S = 2**160;
99   uint256 private constant MAKE_PRICE_S = 2**165;
100   uint256 private constant RACE_ID_S = 2**162;
101   uint256 private constant RACE_WINNER_S = 2**128;
102   uint256 private constant PINKSLIP_S = 2**130;
103   uint256 private constant STATE_S = 2**131;
104 
105   uint256 private constant RACE_READY = 0;
106   uint256 private constant RACE_OPENED = 1;
107   uint256 private constant RACE_FINISHED = 3;
108 
109   uint256 private constant AD_PRICE = 5000000000000000;
110   uint256 private constant COMPANY_START_PRICE = 0.1 ether;
111   uint256 private constant MAKE_START_PRICE = 0.01 ether;
112   uint256 private constant CAR_START_PRICE = 0.005 ether;
113 
114 /********************************************** EVENTS **********************************************/
115   event RaceCreated(uint256 raceId, address player1, uint256 cardId, uint256 betAmount);
116   event RaceFinished(uint256 raceId, address winner);
117 
118   event CardPurchased(uint256 cardType, uint256 cardId, address buyer, address seller, uint256 price);
119   event CardTransferred(uint256 cardType, uint256 cardId, address buyer, address seller);
120   event AdPurchased(uint256 cardType, uint256 cardId, address buyer, address seller, uint256 price);
121 
122   event CarAdded(uint256 id, uint256 makeId);
123   event MakeAdded(uint256 id, uint256 companyId);
124   event CompanyAdded(uint256 id);
125 /****************************************************************************************************/
126 
127 /********************************************** STRUCTS *********************************************/
128   struct Advert {
129     uint256 data;
130     string link;
131     string text;
132   }
133   
134   struct Car {
135     address[4] owners;
136     uint256 price;
137     uint256 makeId;
138     bool locked;
139   }
140 
141   struct Race {
142     uint256 player1Data;
143     uint256 player2Data;
144     uint256 metaData;
145   }
146 /****************************************************************************************************/
147 
148 /*********************************************** VARS ***********************************************/
149   uint256 private whaleCard;
150 
151   mapping(uint256 => Race) private racesMap;
152   mapping(uint256 => uint256) private companiesMap;
153   mapping(uint256 => uint256) private makesMap;
154   mapping(uint256 => Car) private carsMap;
155 
156   mapping(uint256 => mapping(uint256 => Advert)) private adsMap;
157 
158   uint256 public carCount;
159   uint256 public makeCount;
160   uint256 public companyCount;
161   uint256 public openRaceCount;
162   uint256 public finishedRaceCount;
163 
164   uint256 private adCardOwnerCut = 5;
165   uint256 private ownerCut = 50;
166   uint256 private whaleCut = 5;
167   uint256 private devCut = 5;
168   uint256 private parentCut = 10;
169   uint256 private oldCarCut = 2;
170   
171   bool private initDone = false;
172 /****************************************************************************************************/
173 
174   function init() public onlyAdmin {
175     require(!initDone);
176     initDone = true;
177     whaleCard = 544244940971561611450182022165966101192029151941515963475380724124;
178     
179     companiesMap[0] = 865561039198320994090019029559199471223345461753643689577969591538;
180     companiesMap[1] = 865561039198320993054179444739682765137514550166591154999543755547;
181     companiesMap[2] = 554846819998923714678602910082262521292860787724376787491777411291;
182     companiesMap[3] = 355671038460848535541135615183955125321318851275538745891777411291;
183     companiesMap[4] = 146150163733090292102777780770905740002982644405466239152731821942;
184     companiesMap[5] = 355671038460848535508878910989526070534946658842850550567444902178;
185     companiesMap[6] = 146150163733090292102777780770905740002982644405466239152731821942;
186     companiesMap[7] = 146150163733090292102777780770905740002982644405466239152731821942;
187 
188     companyCount = 8;
189 
190     makesMap[0] = 4605053916465184876084057218227438981618782007393731932205532781978;
191     makesMap[1] = 2914591086370370174599913075554161534533507828594490006968556374688;
192     makesMap[2] = 1844677902766057073279966936236223278229324254247807717511561402428;
193     makesMap[3] = 1844677902766057073279966936236223278229324254247807717511561402428;
194     makesMap[4] = 4605053916465184876911990996766451400782681524689254663484418928006;
195     makesMap[5] = 4605053916465184878081670562508085129910431352928816695390378405668;
196     makesMap[6] = 1167517659978517137984061586248765661373868143008706876811221867930;
197     makesMap[7] = 738935227834504519292893252751116942230691621264798552983426488380;
198     makesMap[8] = 1167517659978517139445563223579668579577552975724989896467154410906;
199     makesMap[9] = 738935227834504520754394890082019860434376453981081572639359031356;
200     makesMap[10] = 738935227834504523289617387884832456129379376897516570443342499703;
201     makesMap[11] = 1167517659978517142247011557709217019077442283260142618443342499703;
202     makesMap[12] = 467680523945888942876598267953905513549396800157884357088327079798;
203 
204     makeCount = 13;
205 
206     carsMap[0] = Car({locked: false, owners:[0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 13122000000000000, makeId: 0 });  // solhint-disable-line max-line-length
207     carsMap[1] = Car({locked: false, owners:[0x7396176Ac6C1ef05d57180e7733b9188B3571d9A, 0x71f35825a3B1528859dFa1A64b24242BC0d12990, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 13122000000000000, makeId: 0 });  // solhint-disable-line max-line-length
208     carsMap[2] = Car({locked: false, owners:[0x71f35825a3B1528859dFa1A64b24242BC0d12990, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 0 });   // solhint-disable-line max-line-length
209     carsMap[3] = Car({locked: false, owners:[0x65A05c896d9A6f428B3936ac5db8df28752Ccd44, 0x71f35825a3B1528859dFa1A64b24242BC0d12990, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 13122000000000000, makeId: 0 });  // solhint-disable-line max-line-length
210     carsMap[4] = Car({locked: false, owners:[0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 10000000000000000, makeId: 5 });  // solhint-disable-line max-line-length
211     carsMap[5] = Car({locked: false, owners:[0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 10000000000000000, makeId: 1 });  // solhint-disable-line max-line-length
212     carsMap[6] = Car({locked: false, owners:[0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 10000000000000000, makeId: 4 });  // solhint-disable-line max-line-length
213     carsMap[7] = Car({locked: false, owners:[0x62D5Be95C330b512b35922E347319afD708dA981, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 16200000000000000, makeId: 4 });  // solhint-disable-line max-line-length
214     carsMap[8] = Car({locked: false, owners:[0x3130259deEdb3052E24FAD9d5E1f490CB8CCcaa0, 0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 16200000000000000, makeId: 6 });  // solhint-disable-line max-line-length
215     carsMap[9] = Car({locked: false, owners:[0x19fC7935fd9D0BC335b4D0df3bE86eD51aD2E62A, 0x558F42Baf1A9352A955D301Fa644AD0F619B97d9, 0x5e4b61220039823aeF8a54EfBe47773194494f77, 0x7396176Ac6C1ef05d57180e7733b9188B3571d9A], price: 22051440000000000, makeId: 10});  // solhint-disable-line max-line-length
216     carsMap[10] = Car({locked: false, owners:[0x504Af27f1Cef15772370b7C04b5D9d593Ee729f5, 0x19fC7935fd9D0BC335b4D0df3bE86eD51aD2E62A, 0x558F42Baf1A9352A955D301Fa644AD0F619B97d9, 0x5e4b61220039823aeF8a54EfBe47773194494f77], price: 37046419200000000, makeId: 11}); // solhint-disable-line max-line-length
217     carsMap[11] = Car({locked: false, owners:[0x7396176Ac6C1ef05d57180e7733b9188B3571d9A, 0x5e4b61220039823aeF8a54EfBe47773194494f77, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 4 });  // solhint-disable-line max-line-length
218     carsMap[12] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x7396176Ac6C1ef05d57180e7733b9188B3571d9A, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 7 });  // solhint-disable-line max-line-length
219     carsMap[13] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x5e4b61220039823aeF8a54EfBe47773194494f77, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 10});  // solhint-disable-line max-line-length
220     carsMap[14] = Car({locked: false, owners:[0x504Af27f1Cef15772370b7C04b5D9d593Ee729f5, 0x5e4b61220039823aeF8a54EfBe47773194494f77, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 11});  // solhint-disable-line max-line-length
221     carsMap[15] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x5e4b61220039823aeF8a54EfBe47773194494f77, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 8 });  // solhint-disable-line max-line-length
222     carsMap[16] = Car({locked: false, owners:[0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x558F42Baf1A9352A955D301Fa644AD0F619B97d9, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 9 });  // solhint-disable-line max-line-length
223     carsMap[17] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x558F42Baf1A9352A955D301Fa644AD0F619B97d9, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 2 });  // solhint-disable-line max-line-length
224     carsMap[18] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x19fC7935fd9D0BC335b4D0df3bE86eD51aD2E62A, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 3 });  // solhint-disable-line max-line-length
225     carsMap[19] = Car({locked: false, owners:[0x308e9C99Ac194101C971FFcAca897AC943843dE8, 0x19fC7935fd9D0BC335b4D0df3bE86eD51aD2E62A, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 6 });  // solhint-disable-line max-line-length
226     carsMap[20] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0xE9cfDadEa5FA5475861B62aA7d5dAA493C377122, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 10});  // solhint-disable-line max-line-length
227     carsMap[21] = Car({locked: false, owners:[0x308e9C99Ac194101C971FFcAca897AC943843dE8, 0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 0 });  // solhint-disable-line max-line-length
228     carsMap[22] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x308e9C99Ac194101C971FFcAca897AC943843dE8, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 12});  // solhint-disable-line max-line-length
229     carsMap[23] = Car({locked: false, owners:[0xac2b4B94eCA37Cb7c9cF7062fEfB2792c5792731, 0x263b604509D6a825719859Ee458b2D91fb7d330D, 0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000], price: 13284000000000000, makeId: 12});  //solhint-disable-line max-line-length
230     carsMap[24] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x308e9C99Ac194101C971FFcAca897AC943843dE8, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 2 });  // solhint-disable-line max-line-length
231     carsMap[25] = Car({locked: false, owners:[0x5632CA98e5788edDB2397757Aa82d1Ed6171e5aD, 0x504Af27f1Cef15772370b7C04b5D9d593Ee729f5, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 12});  // solhint-disable-line max-line-length
232     carsMap[26] = Car({locked: false, owners:[0x9bD750685bF5bfCe24d1B8DE03a1ff3D2631ef5a, 0x3177Abbe93422c9525652b5d4e1101a248A99776, 0x0000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000], price: 8100000000000000, makeId: 11});  // solhint-disable-line max-line-length
233      
234     carCount = 27;
235   }
236 
237 /********************************************** RACES ***********************************************/
238   function createRace(uint256 _cardId, uint256 _betAmount, uint256 pinkSlip) public payable isUnlocked {
239     uint256 excess = msg.value.sub(_betAmount);
240     require(_owns(msg.sender, TYPE_CAR, _cardId));
241     require(!carsMap[_cardId].locked);
242     carsMap[_cardId].locked = true;
243     
244     racesMap[openRaceCount+finishedRaceCount].player1Data = _packPlayerData(msg.sender, _cardId);
245     racesMap[openRaceCount+finishedRaceCount].metaData = _packRaceData(_betAmount, 0, pinkSlip, RACE_OPENED);
246     openRaceCount++;
247 
248     emit RaceCreated(openRaceCount+finishedRaceCount, msg.sender, _cardId, _betAmount);
249     _pay(msg.sender, excess);
250   }
251   
252   function joinRaceAndFinish (uint256 _raceId, uint256 _cardId) public payable isUnlocked {
253     require(msg.sender == tx.origin);
254 
255     require(_owns(msg.sender, TYPE_CAR, _cardId));
256     
257     require(!carsMap[_cardId].locked);
258     (uint256 bet, bool pinkslip) = _unpackRaceFinishData(racesMap[_raceId].metaData);
259     
260     require(_raceOpened(racesMap[_raceId].metaData));
261     
262     openRaceCount--;
263     finishedRaceCount++; 
264     
265     racesMap[_raceId].player2Data = _packPlayerData(msg.sender, _cardId);
266     address player1 = address(racesMap[_raceId].player1Data & ADDR_M);
267 
268     uint256 winner = _getRNGValue(_raceId);
269     address winnerAddr = (winner == 1) ? player1 : msg.sender;
270 
271     _transferCar(winnerAddr, racesMap[_raceId].player1Data, pinkslip);
272     _transferCar(winnerAddr, racesMap[_raceId].player2Data, pinkslip);
273 
274     uint256 devFee = bet.mul(2).mul(devCut) / 100;
275     uint256 winnings = bet.mul(2).sub(devFee);
276     
277     _updateRaceWinner(_raceId, winner);
278     emit RaceFinished(_raceId, winnerAddr);
279     
280     _pay(msg.sender, msg.value.sub(bet));
281     _pay(owner, devFee);
282     _pay(winnerAddr, winnings);
283   }
284 /****************************************************************************************************/
285 
286 /******************************************** PURCHASE **********************************************/
287   function purchaseAd(uint256 _cardType, uint256 _cardId, string adText, string adLink) public payable isUnlocked {
288     
289     (address seller, uint256 price) = _unpackItemData(adsMap[_cardType][_cardId].data);
290     price = (price == 0) ? AD_PRICE : price;
291     seller = (seller == address(0)) ? owner : seller;
292     
293     uint256 excess = msg.value.sub(price);
294     require(_released(_cardType, _cardId));
295     require(_cardType != 0);
296   
297     uint256 totalPerc = 100 + adCardOwnerCut + ownerCut + devCut;
298     uint256 newPrice = price.mul(totalPerc) / 100;
299 
300     uint256 cardsellerCommission = price.mul(adCardOwnerCut) / totalPerc;
301     uint256 devFee = price.mul(devCut) / totalPerc;
302     uint256 sellerCommission = price - (cardsellerCommission + devFee);
303     uint256 adData = _packItemData(msg.sender, newPrice);
304 
305     adsMap[_cardType][_cardId] = Advert({text: adText, link: adLink, data: adData});
306     
307     emit AdPurchased(_cardType, _cardId, msg.sender, seller, price);
308 
309     _pay(ownerOf(_cardType, _cardId), cardsellerCommission);
310     _pay(owner, devFee);
311     _pay(seller, sellerCommission);
312     _pay(msg.sender, excess);
313   }
314 
315   function purchaseCard(uint256 _cardType, uint256 _cardId) public payable isUnlocked {
316     if ( _cardType == TYPE_WHALE) {
317       _purchaseWhaleCard();
318     } else if (_cardType == TYPE_COMPANY) {
319       _purchaseCompany(_cardId);
320     } else if (_cardType == TYPE_MAKE) {
321       _purchaseMake(_cardId);
322     } else if (_cardType == TYPE_CAR) {
323       _purchaseCar(_cardId);
324     }
325   }
326 /****************************************************************************************************/
327 
328 /********************************************* GETTERS **********************************************/
329   function getWhaleCard() public view returns (address _owner, uint256 _price) {
330     (_owner, _price) = _unpackItemData(whaleCard);
331   }
332 
333   function getCompany(uint256 _companyId) public view returns(address _owner, uint256 _price) {
334     (_owner, _price) = _unpackItemData(companiesMap[_companyId]);
335   }
336 
337   function getMake(uint256 _makeId) public view returns(address _owner, uint256 _price, uint256 _companyId) {
338     (_owner, _companyId, _price) = _unpackMakeData(makesMap[_makeId]);
339   }
340   
341   function getCar(uint256 _carId) public view returns (address[4] owners, uint256 price, uint256 makeId) {
342     Car memory _car = carsMap[_carId];
343     owners = _car.owners;
344     price = _car.price;
345     makeId = _car.makeId;
346   }
347   
348   function getRace(uint256 _raceId) public view returns(uint256 _p1Data, uint256 _p2Data, uint256 _raceMetaData) {
349     Race memory _race = racesMap[_raceId];
350     _p1Data = _race.player1Data;
351     _p2Data = _race.player2Data;
352     _raceMetaData = _race.metaData;
353   }
354   
355   function getFullRace(uint256 _raceId) public view returns(
356     address p1, uint256 p1Id,
357     address p2, uint256 p2Id,
358     uint256 bet, uint256 winner, bool pinkslip, uint256 state) {
359     Race memory _race = racesMap[_raceId];
360     (p1, p1Id) = _unpackPlayerData(_race.player1Data);
361     (p2, p2Id) = _unpackPlayerData(_race.player2Data);
362     (bet, winner, pinkslip, state) = _unpackRaceData(_race.metaData);
363   }
364 
365   function getAd(uint256 _cardType, uint256 _cardId) public view returns(string text, string link, address seller, uint256 price) {
366     Advert memory ad = adsMap[_cardType][_cardId];
367     (seller, price) = _unpackItemData(ad.data);
368     price = (price == 0) ? AD_PRICE : price;
369     seller = (seller == address(0)) ? owner : seller;
370     text = ad.text;
371     link = ad.link;
372   }
373   
374   function getCuts() public view returns(uint256[6] cuts) {
375     cuts = [adCardOwnerCut, ownerCut, whaleCut, devCut, parentCut, oldCarCut];
376   }
377 
378   function ownerOf(uint256 cardType, uint256 cardId) public view returns(address cardOwner) {
379     if (cardType == TYPE_WHALE) {
380       cardOwner = address(whaleCard & ADDR_M);
381     } else if (cardType == TYPE_COMPANY) {
382       cardOwner = address(companiesMap[cardId] & ADDR_M);
383     } else if (cardType == TYPE_MAKE) {
384       cardOwner = address(makesMap[cardId] & ADDR_M);
385     } else if (cardType == TYPE_CAR) {
386       cardOwner = carsMap[cardId].owners[0];
387     }
388   }
389 /****************************************************************************************************/
390 
391 /********************************************* RELEASE **********************************************/   
392   function transferCard(address _newOwner, uint256 _cardType, uint256 _cardId) public onlyAdmin {
393     _transferCard(_newOwner, _cardType, _cardId);
394   }
395 /****************************************************************************************************/
396 
397 /******************************************** ADD CARDS *********************************************/
398   function addCompany() public onlyAdmin {
399     companiesMap[companyCount] = _packItemData(owner, COMPANY_START_PRICE);
400     emit CompanyAdded(companyCount++);
401   }
402 
403   function addMake(uint256 _companyId) public onlyAdmin {
404     makesMap[makeCount] = _packMakeData(owner, MAKE_START_PRICE, _companyId);
405     emit MakeAdded(makeCount++, _companyId);
406   }
407   
408   function addCar(uint256 _makeId) public onlyAdmin {
409     carsMap[carCount] = Car({price: CAR_START_PRICE, owners: [owner, address(0), address(0), address(0)], makeId: _makeId, locked : false});
410     emit CarAdded(carCount++, _makeId);
411   }
412   
413   function addAd(address _ownerAddr, uint256 _price, uint256 _cardType, uint256 _cardId, string _text, string _link) public onlyAdmin {
414     require(_addrNotNull(_ownerAddr) && (_price != 0));
415     uint256 _data = _packItemData(_ownerAddr, _price);
416     adsMap[_cardType][_cardId] = Advert({text: _text, link: _link, data: _data});
417   }
418   
419   function editCuts(uint256[6] cuts) public onlyAdmin {
420     adCardOwnerCut = (cuts[0] == 0) ? adCardOwnerCut : cuts[0];
421     ownerCut = (cuts[1] == 0) ? ownerCut : cuts[1];
422     whaleCut = (cuts[2] == 0) ? whaleCut : cuts[2];
423     devCut = (cuts[3] == 0) ? devCut : cuts[3];
424     parentCut = (cuts[4] == 0) ? parentCut : cuts[4];
425     oldCarCut = (cuts[5] == 0) ? oldCarCut : cuts[5];
426   }
427 /****************************************************************************************************/
428 
429 /********************************************* PRIVATE **********************************************/
430 
431   function _editPriceOf(uint256 cardType, uint256 cardId, uint256 _newPrice) private {
432     if (cardType == TYPE_WHALE) {
433       whaleCard = (~(PRICE_M*ADDR_S) & whaleCard) | ((_newPrice & PRICE_M) * ADDR_S);
434     } else if (cardType == TYPE_COMPANY) {
435       companiesMap[cardId] = (~(PRICE_M*ADDR_S) & companiesMap[cardId]) | ((_newPrice & PRICE_M) * ADDR_S);
436     } else if (cardType == TYPE_MAKE) {
437       makesMap[cardId] = (~(MAKE_PRICE_M*MAKE_PRICE_S) & makesMap[cardId]) | ((_newPrice & MAKE_PRICE_M) * MAKE_PRICE_S);
438     } else if (cardType == TYPE_CAR) {
439       carsMap[cardId].price = _newPrice;
440     }
441   }
442 
443   function _priceOf(uint256 cardType, uint256 cardId) private view returns(uint256 _price) {
444     if (cardType == TYPE_WHALE) {
445       _price = (PRICE_M & (whaleCard / ADDR_S));
446     } else if (cardType == TYPE_COMPANY) {
447       _price = (PRICE_M & (companiesMap[cardId] / ADDR_S));
448     } else if (cardType == TYPE_MAKE) {
449       _price = (MAKE_PRICE_M & (makesMap[cardId] / MAKE_PRICE_S));
450     } else if (cardType == TYPE_CAR) {
451       _price = carsMap[cardId].price;
452     }
453   }
454 
455   function _owns(address _owner, uint256 cardType, uint256 cardId) private view returns(bool) {
456     address _toCheck = ownerOf(cardType, cardId);
457     return(_owner == _toCheck);
458   }
459 
460   function _released(uint256 cardType, uint256 cardId) private view returns(bool) {
461     return(_addrNotNull(ownerOf(cardType, cardId)));
462   }
463   
464   function _transferCard(address newOwner, uint256 cardType, uint256 cardId) private returns (bool) {   
465     require(_released(cardType, cardId));
466     address seller = ownerOf(cardType, cardId);
467     if ( newOwner == seller) {
468     } else if (cardType == TYPE_WHALE) {
469       whaleCard = (~(ADDR_M) & whaleCard) | (uint256(newOwner) & ADDR_M);
470     } else if (cardType == TYPE_COMPANY) {
471       companiesMap[cardId] = (~(ADDR_M) & companiesMap[cardId]) | (uint256(newOwner) & ADDR_M);
472     } else if (cardType == TYPE_MAKE) {
473       makesMap[cardId] = (~(ADDR_M) & makesMap[cardId]) | (uint256(newOwner) & ADDR_M);
474     } else if (cardType == TYPE_CAR) {
475       carsMap[cardId].owners[3] = carsMap[cardId].owners[2];
476       carsMap[cardId].owners[2] = carsMap[cardId].owners[1];    
477       carsMap[cardId].owners[1] = carsMap[cardId].owners[0];
478       carsMap[cardId].owners[0] = newOwner;
479     }
480     emit CardTransferred(cardType, cardId, newOwner, seller);
481   }
482 
483   function _pay(address _to, uint256 _value) private {
484     if ( _addrNotNull(_to) && _value != 0) {
485       _to.transfer(_value);
486     }
487   }
488 
489   function _transferCar(address newOwner, uint256 _data, bool pinkslip) private returns (bool) {
490     uint256 id = _getRacerCar(_data);
491     carsMap[id].locked = false;
492     if ( pinkslip) {
493       _transferCard(newOwner, TYPE_CAR, id);
494     }
495   }    
496 
497   function _oldOwnersOf(uint256 _carId) private view returns(uint256) {
498     Car memory _car = carsMap[_carId];
499     uint256 count = _addrNotNull(_car.owners[1]) ? 1 : 0;
500     count += (_addrNotNull(_car.owners[2]) ? 1 : 0);
501     count += (_addrNotNull(_car.owners[3]) ? 1 : 0);
502     return(count);
503   }
504 
505   function _packItemData(address itemOwner, uint256 price) public pure returns(uint256) {
506     uint256 _data = (~(ADDR_M) & _data) | (uint256(itemOwner) & ADDR_M);
507     _data = (~(PRICE_M*ADDR_S) & _data) | ((price & PRICE_M) * ADDR_S);
508     return(_data);
509   }
510   
511   function _unpackItemData(uint256 _data) private pure returns(address itemOwner, uint256 price) {
512     itemOwner = address(_data & ADDR_M);
513     price = PRICE_M & (_data / ADDR_S);
514   }
515 
516   function _packMakeData(address makeOwner, uint256 price, uint256 companyId) private pure returns(uint256 _data) {
517     _data = (~(ADDR_M) & _data) | (uint256(makeOwner) & ADDR_M);
518     _data = (~(COMPANY_ID_M*ADDR_S) & _data) | ((companyId & COMPANY_ID_M) * ADDR_S);
519     _data = (~(MAKE_PRICE_M*MAKE_PRICE_S) & _data) | ((price & MAKE_PRICE_M) * MAKE_PRICE_S);
520   }
521 
522   function _unpackMakeData(uint256 _data) private pure returns(address makeOwner, uint256 companyId, uint256 price) {
523     makeOwner = address(_data & ADDR_M);
524     companyId = COMPANY_ID_M & (_data / ADDR_S);
525     price = (MAKE_PRICE_M & (_data / MAKE_PRICE_S));
526   }
527 
528   function _purchaseCar(uint256 _cardId) private {
529     Car memory car = carsMap[_cardId];
530     require(!car.locked);
531 
532     uint256 excess = msg.value.sub(car.price);
533 
534     require(msg.sender != car.owners[0]);
535 
536     uint256 totalPerc = 100 + ownerCut + devCut + whaleCut + (2 * parentCut) + (oldCarCut * _oldOwnersOf(_cardId));
537     
538     uint256 parentFee = car.price.mul(parentCut) / totalPerc;    
539     uint256 oldCarFee = car.price.mul(oldCarCut) / totalPerc;  
540     uint256 whaleFee = car.price.mul(whaleCut) / totalPerc;  
541     uint256 devFee = car.price.mul(devCut) / totalPerc;
542     
543     uint256 sellerCommission = car.price - ((oldCarFee * _oldOwnersOf(_cardId)) + (2 * parentFee) + devFee + whaleFee);
544 
545     uint256 companyId = COMPANY_ID_M & (makesMap[car.makeId] / ADDR_S);
546 
547     emit CardPurchased(TYPE_CAR, _cardId, msg.sender, car.owners[0], car.price);
548 
549     _transferCard(msg.sender, TYPE_CAR, _cardId);
550     _editPriceOf(TYPE_CAR, _cardId, car.price.mul(totalPerc) / 100);
551      
552     _pay(ownerOf(TYPE_COMPANY, companyId), parentFee);
553     _pay(ownerOf(TYPE_MAKE, car.makeId), parentFee);
554 
555     _pay(car.owners[0], sellerCommission);
556     _pay(car.owners[1], oldCarFee);
557     _pay(car.owners[2], oldCarFee);
558     _pay(car.owners[3], oldCarFee);
559     
560     _pay(ownerOf(0, 0), whaleFee);
561     _pay(owner, devFee);
562     _pay(msg.sender, excess);
563   }
564 
565   function _purchaseMake(uint256 _cardId) private isUnlocked {
566     (address seller, uint256 price, uint256 companyId) = getMake(_cardId);
567     uint256 excess = msg.value.sub(price);
568 
569     require(msg.sender != seller);
570     
571     uint256 totalPerc = 100 + ownerCut + devCut + parentCut + whaleCut;
572     
573     uint256 parentFee = price.mul(parentCut) / totalPerc;
574     uint256 whaleFee = price.mul(whaleCut) / totalPerc;
575     uint256 devFee = price.mul(devCut) / totalPerc;
576 
577     uint256 newPrice = price.mul(totalPerc) / 100;
578   
579     uint256 sellerCommission = price - (parentFee+whaleFee+devFee);
580     
581     _transferCard(msg.sender, 2, _cardId);
582     _editPriceOf(2, _cardId, newPrice);
583     
584     emit CardPurchased(2, _cardId, msg.sender, seller, price);
585 
586     _pay(ownerOf(TYPE_WHALE, 0), whaleFee);
587     _pay(ownerOf(TYPE_COMPANY, companyId), parentFee);     
588     _pay(owner, devFee);
589     _pay(seller, sellerCommission);
590     _pay(msg.sender, excess);
591   }
592 
593   function _purchaseCompany(uint256 _cardId) private isUnlocked {
594     (address seller, uint256 price) = getCompany(_cardId);
595     uint256 excess = msg.value.sub(price);
596 
597     require(msg.sender != seller);
598 
599     uint256 totalPerc = 100+ownerCut+devCut+whaleCut;
600     uint256 newPrice = price.mul(totalPerc) / 100;
601     
602     _transferCard(msg.sender, 1, _cardId);
603     _editPriceOf(1, _cardId, newPrice);
604     
605     uint256 whaleFee = price.mul(whaleCut) / totalPerc;
606     uint256 devFee = price.mul(devCut) / totalPerc;
607     uint256 sellerCommission = price - (whaleFee + devFee);
608     
609     emit CardPurchased(1, _cardId, msg.sender, seller, price);
610     
611     _pay(ownerOf(0,0), whaleFee);
612     _pay(owner, devFee);
613     _pay(seller,sellerCommission);
614     _pay(msg.sender, excess);
615   }
616 
617   function _purchaseWhaleCard() private isUnlocked {
618     (address seller, uint256 price) = getWhaleCard();
619     uint256 excess = msg.value.sub(price);
620     
621     require(msg.sender != seller);
622 
623     uint256 totalPerc = 100 + ownerCut + devCut;
624     uint256 devFee = price.mul(devCut) / totalPerc;
625 
626     uint256 sellerCommission = price - devFee;
627     uint256 newPrice = price.mul(totalPerc) / 100;
628 
629     _transferCard(msg.sender, TYPE_WHALE, TYPE_WHALE);
630     _editPriceOf(TYPE_WHALE, TYPE_WHALE, newPrice);
631     
632     emit CardPurchased(TYPE_WHALE, TYPE_WHALE, msg.sender, seller, price);
633       
634     _pay(owner, devFee);
635     _pay(seller, sellerCommission);
636     _pay(msg.sender, excess);
637   }
638 /****************************************************************************************************/
639 
640 /****************************************** PRIVATE RACE ********************************************/
641   function _packPlayerData(address player, uint256 id) private pure returns(uint256 playerData) {
642     playerData = (~(ADDR_M) & playerData) | (uint256(player) & ADDR_M);
643     playerData = (~(RACE_ID_M*ADDR_S) & playerData) | ((id & RACE_ID_M) * ADDR_S);
644   }
645 
646   function _unpackPlayerData(uint256 playerData) private pure returns(address player, uint256 id) {
647     player = address(playerData & ADDR_M);
648     id = (RACE_ID_M & (playerData / ADDR_S));
649   }
650 
651   function _packRaceData(uint256 _bet, uint256 _winner, uint256 _pinkslip, uint256 _state) private pure returns(uint256 _raceData) {
652     _raceData = (~(RACE_BET_M) & _raceData) | (_bet & RACE_BET_M);
653     _raceData = (~(WINNER_M*RACE_WINNER_S) & _raceData) | ((_winner & WINNER_M) * RACE_WINNER_S);
654     _raceData = (~(PINKSLIP_M*PINKSLIP_S) & _raceData) | ((_pinkslip & PINKSLIP_M) * PINKSLIP_S);
655     _raceData = (~(STATE_M*STATE_S) & _raceData) | ((_state & STATE_M) * STATE_S);
656   }
657 
658   function _unpackRaceData(uint256 _raceData) private pure returns(uint256 bet, uint256 winner, bool pinkslip, uint256 state) {
659     bet = _raceData & RACE_BET_M;
660     winner = (WINNER_M & (_raceData / RACE_WINNER_S));
661     pinkslip = (PINKSLIP_M & (_raceData / PINKSLIP_S)) != 0;
662     state = (STATE_M & (_raceData / STATE_S));
663   }
664   
665   function _unpackRaceFinishData(uint256 _raceData) private pure returns(uint256 bet, bool pinkslip) {
666     bet = _raceData & RACE_BET_M;
667     pinkslip = (PINKSLIP_M & (_raceData / PINKSLIP_S)) != 0;
668   }
669   
670   function _updateRaceWinner(uint256 raceId, uint256 winner) private {
671     racesMap[raceId].metaData = (~(STATE_M*STATE_S) & racesMap[raceId].metaData) | ((RACE_FINISHED & STATE_M) * STATE_S);
672     racesMap[raceId].metaData = (~(WINNER_M*RACE_WINNER_S) & racesMap[raceId].metaData) | ((winner & WINNER_M) * RACE_WINNER_S);
673   }
674 
675   function _raceOpened(uint256 raceData) private pure returns (bool opened) {
676     uint256 state = (STATE_M & (raceData / STATE_S));
677     opened = ((state == RACE_OPENED));
678   }
679 
680   function _getRacerCar(uint256 playerData) private pure returns (uint256 id) {
681     id = (RACE_ID_M & (playerData / ADDR_S));
682   }
683 
684   function _getRNGValue(uint256 id) private view returns(uint256 winner) {
685     Race memory race = racesMap[id];
686     uint256 p1Price = _priceOf(TYPE_CAR, _getRacerCar(race.player1Data));
687     uint256 p2Price = _priceOf(TYPE_CAR, _getRacerCar(race.player2Data));
688     uint256 _totalValue = p1Price.add(p2Price); 
689     
690     uint256 blockToCheck = block.number - 1;
691     uint256 weight = (p1Price.mul(2) < _totalValue) ? _totalValue/2 : p1Price;
692     //uint256 ratio = ((2**256)-1)/_totalValue;
693     uint256 ratio = 115792089237316195423570985008687907853269984665640564039457584007913129639935/_totalValue;
694     bytes32 blockHash = blockhash(blockToCheck);
695     winner = (uint256(keccak256(abi.encodePacked(blockHash))) > weight*ratio) ? 2 : 1;
696   }
697 /****************************************************************************************************/
698 }