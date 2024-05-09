1 pragma solidity ^0.4.17;
2 
3 contract SafeMath {
4     function safeAdd(uint x, uint y) pure internal returns(uint) {
5       uint z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtract(uint x, uint y) pure internal returns(uint) {
11       assert(x >= y);
12       uint z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint x, uint y) pure internal returns(uint) {
17       uint z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 
22     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
23         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
24         return uint8(genNum % (maxRandom - min + 1)+min);
25     }
26 }
27 
28 contract Enums {
29     enum ResultCode {
30         SUCCESS,
31         ERROR_CLASS_NOT_FOUND,
32         ERROR_LOW_BALANCE,
33         ERROR_SEND_FAIL,
34         ERROR_NOT_OWNER,
35         ERROR_NOT_ENOUGH_MONEY,
36         ERROR_INVALID_AMOUNT
37     }
38 
39     enum AngelAura { 
40         Blue, 
41         Yellow, 
42         Purple, 
43         Orange, 
44         Red, 
45         Green 
46     }
47 }
48 
49 
50 
51 contract AccessControl {
52     address public creatorAddress;
53     uint16 public totalSeraphims = 0;
54     mapping (address => bool) public seraphims;
55 
56     bool public isMaintenanceMode = true;
57  
58     modifier onlyCREATOR() {
59         require(msg.sender == creatorAddress);
60         _;
61     }
62 
63     modifier onlySERAPHIM() {
64         require(seraphims[msg.sender] == true);
65         _;
66     }
67     
68     modifier isContractActive {
69         require(!isMaintenanceMode);
70         _;
71     }
72     
73     // Constructor
74     function AccessControl() public {
75         creatorAddress = msg.sender;
76     }
77     
78 
79     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
80         if (seraphims[_newSeraphim] == false) {
81             seraphims[_newSeraphim] = true;
82             totalSeraphims += 1;
83         }
84     }
85     
86     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
87         if (seraphims[_oldSeraphim] == true) {
88             seraphims[_oldSeraphim] = false;
89             totalSeraphims -= 1;
90         }
91     }
92 
93     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
94         isMaintenanceMode = _isMaintaining;
95     }
96 
97   
98 } 
99 
100 
101 
102 contract IAccessoryData is AccessControl, Enums {
103     uint8 public totalAccessorySeries;    
104     uint32 public totalAccessories;
105     
106  
107     /*** FUNCTIONS ***/
108     //*** Write Access ***//
109     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;
110 	function setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);
111    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;
112 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);
113     function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;
114     
115     //*** Read Access ***//
116     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;
117 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);
118 	function getOwnerAccessoryCount(address _owner) constant public returns(uint);
119 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;
120     function getTotalAccessorySeries() constant public returns (uint8) ;
121     function getTotalAccessories() constant public returns (uint);
122 }
123 
124 
125 contract IAngelCardData is AccessControl, Enums {
126     uint8 public totalAngelCardSeries;
127     uint64 public totalAngels;
128 
129     
130     // write
131     // angels
132     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
133     function updateAngelCardSeries(uint8 _angelCardSeriesId) onlyCREATOR external;
134     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
135     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
136     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
137     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
138     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
139     function addAngelIdMapping(address _owner, uint64 _angelId) private;
140     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
141     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
142 
143     // read
144     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
145     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
146     function getOwnerAngelCount(address _owner) constant public returns(uint);
147     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
148     function getTotalAngelCardSeries() constant public returns (uint8);
149     function getTotalAngels() constant public returns (uint64);
150 }
151 
152 
153 contract IPetCardData is AccessControl, Enums {
154     uint8 public totalPetCardSeries;    
155     uint64 public totalPets;
156     
157     // write
158     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
159     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
160     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
161     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
162     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
163     function addPetIdMapping(address _owner, uint64 _petId) private;
164     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
165     function ownerPetTransfer (address _to, uint64 _petId)  public;
166     function setPetName(string _name, uint64 _petId) public;
167 
168     // read
169     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
170     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
171     function getOwnerPetCount(address _owner) constant public returns(uint);
172     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
173     function getTotalPetCardSeries() constant public returns (uint8);
174     function getTotalPets() constant public returns (uint);
175 }
176 
177   
178 
179    
180 	
181 
182 contract Realm is AccessControl, Enums, SafeMath {
183     // Addresses for other contracts realm interacts with. 
184     address public angelCardDataContract;
185     address public petCardDataContract;
186     address public accessoryDataContract;
187     
188     // events
189     event EventCreateAngel(address indexed owner, uint64 angelId);
190     event EventCreatePet(address indexed owner, uint petId);
191      event EventCreateAccessory(address indexed owner, uint accessoryId);
192     
193 
194     /*** DATA TYPES ***/
195     struct AngelCardSeries {
196         uint8 angelCardSeriesId;
197         uint basePrice; 
198         uint64 currentAngelTotal;
199         uint64 maxAngelTotal;
200         AngelAura baseAura;
201         uint baseBattlePower;
202         uint64 lastSellTime;
203         uint64 liveTime;
204     }
205 
206     struct PetCardSeries {
207         uint8 petCardSeriesId;
208         uint32 currentPetTotal;
209         uint32 maxPetTotal;
210     }
211 
212     struct Angel {
213         uint64 angelId;
214         uint8 angelCardSeriesId;
215         address owner;
216         uint16 battlePower;
217         AngelAura aura;
218         uint16 experience;
219         uint price;
220         uint64 createdTime;
221         uint64 lastBattleTime;
222         uint64 lastVsBattleTime;
223         uint16 lastBattleResult;
224     }
225 
226     struct Pet {
227         uint64 petId;
228         uint8 petCardSeriesId;
229         address owner;
230         string name;
231         uint8 luck;
232         uint16 auraRed;
233         uint16 auraYellow;
234         uint16 auraBlue;
235         uint64 lastTrainingTime;
236         uint64 lastBreedingTime;
237         uint price; 
238         uint64 liveTime;
239     }
240     
241       struct AccessorySeries {
242         uint8 AccessorySeriesId;
243         uint32 currentTotal;
244         uint32 maxTotal;
245         uint price;
246     }
247 
248     struct Accessory {
249         uint32 accessoryId;
250         uint8 accessorySeriesId;
251         address owner;
252     }
253 
254     // write functions
255     function SetAngelCardDataContact(address _angelCardDataContract) onlyCREATOR external {
256         angelCardDataContract = _angelCardDataContract;
257     }
258     function SetPetCardDataContact(address _petCardDataContract) onlyCREATOR external {
259         petCardDataContract = _petCardDataContract;
260     }
261     function SetAccessoryDataContact(address _accessoryDataContract) onlyCREATOR external {
262         accessoryDataContract = _accessoryDataContract;
263     }
264 
265 
266     function withdrawEther() external onlyCREATOR {
267     creatorAddress.transfer(this.balance);
268 }
269 
270     //Create each mint of a petCard
271      function createPet(uint8 _petCardSeriesId, string _newname) isContractActive external {
272         IPetCardData petCardData = IPetCardData(petCardDataContract);
273         PetCardSeries memory petSeries;
274       
275       
276         (,petSeries.currentPetTotal, petSeries.maxPetTotal) = petCardData.getPetCardSeries(_petCardSeriesId);
277 
278         
279         if (petSeries.currentPetTotal >= petSeries.maxPetTotal) { revert ();}
280         
281         //timechecks - in case people try to interact with the contract directly and get pets before they are available
282         if (_petCardSeriesId > 4) {revert();} //Pets higher than 4 come from battle, breeding, or marketplace. 
283         if ((_petCardSeriesId == 2) && (now < 1518348600)) {revert();}
284         if ((_petCardSeriesId == 3) && (now < 1520076600)) {revert();}
285         if ((_petCardSeriesId == 4) && (now < 1521804600)) {revert();}
286          
287         //first find pet luck
288         uint8 _newLuck = getRandomNumber(19, 10, msg.sender);
289         
290         
291         uint16 _auraRed = 0;
292         uint16 _auraYellow = 0;
293         uint16 _auraBlue = 0;
294         
295         uint32 _auraColor = getRandomNumber(2,0,msg.sender);
296         if (_auraColor == 0) { _auraRed = 2;}
297         if (_auraColor == 1) { _auraYellow = 2;}
298         if (_auraColor == 2) { _auraBlue = 2;}
299         
300         uint64 petId = petCardData.setPet(_petCardSeriesId, msg.sender, _newname, _newLuck, _auraRed, _auraYellow, _auraBlue);
301         
302         EventCreatePet(msg.sender, petId);
303     }
304 
305  //Create each mint of a Accessory card 
306      function createAccessory(uint8 _accessorySeriesId) isContractActive external payable {
307         if (_accessorySeriesId > 18) {revert();} 
308     IAccessoryData AccessoryData = IAccessoryData(accessoryDataContract);
309       AccessorySeries memory accessorySeries;
310       (,accessorySeries.currentTotal, accessorySeries.maxTotal, accessorySeries.price) = AccessoryData.getAccessorySeries(_accessorySeriesId);
311     if (accessorySeries.currentTotal >= accessorySeries.maxTotal) { revert ();}
312       if (msg.value < accessorySeries.price) { revert();}
313      uint64 accessoryId = AccessoryData.setAccessory(_accessorySeriesId, msg.sender);
314      
315      EventCreateAccessory(msg.sender, accessoryId);
316     }
317     
318     
319     // created every mint of an angel card
320     function createAngel(uint8 _angelCardSeriesId) isContractActive external payable {
321         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
322         AngelCardSeries memory series;
323         (, series.currentAngelTotal, series.basePrice, series.maxAngelTotal,,series.baseBattlePower, series.lastSellTime, series.liveTime) = angelCardData.getAngelCardSeries(_angelCardSeriesId);
324       
325       if ( _angelCardSeriesId > 24) {revert();}
326         //Checked here and in angelCardData
327         if (series.currentAngelTotal >= series.maxAngelTotal) { revert();}
328         if (_angelCardSeriesId > 3) {
329             // check is it within the  release schedule
330             if (now < series.liveTime) {
331             revert();
332             }
333         }
334         // Verify the price paid for card is correct
335         if (series.basePrice > msg.value) {revert(); }
336         
337         // add angel
338         uint64 angelId = angelCardData.setAngel(_angelCardSeriesId, msg.sender, msg.value, uint16(series.baseBattlePower+getRandomNumber(10,0,msg.sender)));
339         
340         EventCreateAngel(msg.sender, angelId);
341     }
342       function kill() onlyCREATOR external {
343         selfdestruct(creatorAddress);
344     }
345 }