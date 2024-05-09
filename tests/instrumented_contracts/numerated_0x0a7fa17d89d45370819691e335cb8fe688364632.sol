1 pragma solidity ^0.4.17;
2 
3 contract Enums {
4     enum ResultCode {
5         SUCCESS,
6         ERROR_CLASS_NOT_FOUND,
7         ERROR_LOW_BALANCE,
8         ERROR_SEND_FAIL,
9         ERROR_NOT_OWNER,
10         ERROR_NOT_ENOUGH_MONEY,
11         ERROR_INVALID_AMOUNT
12     }
13 
14     enum AngelAura { 
15         Blue, 
16         Yellow, 
17         Purple, 
18         Orange, 
19         Red, 
20         Green 
21     }
22 }
23 contract AccessControl {
24     address public creatorAddress;
25     uint16 public totalSeraphims = 0;
26     mapping (address => bool) public seraphims;
27 
28     bool public isMaintenanceMode = true;
29  
30     modifier onlyCREATOR() {
31         require(msg.sender == creatorAddress);
32         _;
33     }
34 
35     modifier onlySERAPHIM() {
36       
37       require(seraphims[msg.sender] == true);
38         _;
39     }
40     modifier isContractActive {
41         require(!isMaintenanceMode);
42         _;
43     }
44     
45    // Constructor
46     function AccessControl() public {
47         creatorAddress = msg.sender;
48     }
49     
50 
51     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
52         if (seraphims[_newSeraphim] == false) {
53             seraphims[_newSeraphim] = true;
54             totalSeraphims += 1;
55         }
56     }
57     
58     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
59         if (seraphims[_oldSeraphim] == true) {
60             seraphims[_oldSeraphim] = false;
61             totalSeraphims -= 1;
62         }
63     }
64 
65     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
66         isMaintenanceMode = _isMaintaining;
67     }
68 
69   
70 } 
71 contract IABToken is AccessControl {
72  
73  
74     function balanceOf(address owner) public view returns (uint256);
75     function totalSupply() external view returns (uint256) ;
76     function ownerOf(uint256 tokenId) public view returns (address) ;
77     function setMaxAngels() external;
78     function setMaxAccessories() external;
79     function setMaxMedals()  external ;
80     function initAngelPrices() external;
81     function initAccessoryPrices() external ;
82     function setCardSeriesPrice(uint8 _cardSeriesId, uint _newPrice) external;
83     function approve(address to, uint256 tokenId) public;
84     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) ;
85     function tokenURI(uint256 _tokenId) public pure returns (string memory) ;
86     function baseTokenURI() public pure returns (string memory) ;
87     function name() external pure returns (string memory _name) ;
88     function symbol() external pure returns (string memory _symbol) ;
89     function getApproved(uint256 tokenId) public view returns (address) ;
90     function setApprovalForAll(address to, bool approved) public ;
91     function isApprovedForAll(address owner, address operator) public view returns (bool);
92     function transferFrom(address from, address to, uint256 tokenId) public ;
93     function safeTransferFrom(address from, address to, uint256 tokenId) public ;
94     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public ;
95     function _exists(uint256 tokenId) internal view returns (bool) ;
96     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) ;
97     function _mint(address to, uint256 tokenId) internal ;
98     function mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) public;
99     function addABTokenIdMapping(address _owner, uint256 _tokenId) private ;
100     function getPrice(uint8 _cardSeriesId) public view returns (uint);
101     function buyAngel(uint8 _angelSeriesId) public payable ;
102     function buyAccessory(uint8 _accessorySeriesId) public payable ;
103     function getAura(uint8 _angelSeriesId) pure public returns (uint8 auraRed, uint8 auraYellow, uint8 auraBlue) ;
104     function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) ;
105     function getABToken(uint256 tokenId) view public returns(uint8 cardSeriesId, uint16 power, uint16 auraRed, uint16 auraYellow, uint16 auraBlue, string memory name, uint16 experience, uint64 lastBattleTime, uint16 lastBattleResult, address owner, uint16 oldId);
106     function setAuras(uint256 tokenId, uint16 _red, uint16 _blue, uint16 _yellow) external;
107     function setName(uint256 tokenId,string memory namechange) public ;
108     function setExperience(uint256 tokenId, uint16 _experience) external;
109     function setLastBattleResult(uint256 tokenId, uint16 _result) external ;
110     function setLastBattleTime(uint256 tokenId) external;
111     function setLastBreedingTime(uint256 tokenId) external ;
112     function setoldId(uint256 tokenId, uint16 _oldId) external;
113     function getABTokenByIndex(address _owner, uint64 _index) view external returns(uint256) ;
114     function _burn(address owner, uint256 tokenId) internal ;
115     function _burn(uint256 tokenId) internal ;
116     function _transferFrom(address from, address to, uint256 tokenId) internal ;
117     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool);
118     function _clearApproval(uint256 tokenId) private ;
119 }
120 
121 
122 contract IPetCardData is AccessControl, Enums {
123     uint8 public totalPetCardSeries;    
124     uint64 public totalPets;
125     
126     // write
127     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
128     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
129     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
130     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
131     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
132     function addPetIdMapping(address _owner, uint64 _petId) private;
133     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
134     function ownerPetTransfer (address _to, uint64 _petId)  public;
135     function setPetName(string _name, uint64 _petId) public;
136 
137     // read
138     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
139     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
140     function getOwnerPetCount(address _owner) constant public returns(uint);
141     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
142     function getTotalPetCardSeries() constant public returns (uint8);
143     function getTotalPets() constant public returns (uint);
144 }
145 
146 contract IAngelCardData is AccessControl, Enums {
147     uint8 public totalAngelCardSeries;
148     uint64 public totalAngels;
149 
150     
151     // write
152     // angels
153     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
154     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
155     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
156     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
157     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
158     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
159     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
160     function addAngelIdMapping(address _owner, uint64 _angelId) private;
161     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
162     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
163     function updateAngelLock (uint64 _angelId, bool newValue) public;
164     function removeCreator() onlyCREATOR external;
165 
166     // read
167     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
168     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
169     function getOwnerAngelCount(address _owner) constant public returns(uint);
170     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
171     function getTotalAngelCardSeries() constant public returns (uint8);
172     function getTotalAngels() constant public returns (uint64);
173     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
174 }
175 
176 contract IAccessoryData is AccessControl, Enums {
177     uint8 public totalAccessorySeries;    
178     uint32 public totalAccessories;
179     
180  
181     /*** FUNCTIONS ***/
182     //*** Write Access ***//
183     function createAccessorySeries(uint8 _AccessorySeriesId, uint32 _maxTotal, uint _price) onlyCREATOR public returns(uint8) ;
184 	function setAccessory(uint8 _AccessorySeriesId, address _owner) onlySERAPHIM external returns(uint64);
185    function addAccessoryIdMapping(address _owner, uint64 _accessoryId) private;
186 	function transferAccessory(address _from, address _to, uint64 __accessoryId) onlySERAPHIM public returns(ResultCode);
187     function ownerAccessoryTransfer (address _to, uint64 __accessoryId)  public;
188     function updateAccessoryLock (uint64 _accessoryId, bool newValue) public;
189     function removeCreator() onlyCREATOR external;
190     
191     //*** Read Access ***//
192     function getAccessorySeries(uint8 _accessorySeriesId) constant public returns(uint8 accessorySeriesId, uint32 currentTotal, uint32 maxTotal, uint price) ;
193 	function getAccessory(uint _accessoryId) constant public returns(uint accessoryID, uint8 AccessorySeriesID, address owner);
194 	function getOwnerAccessoryCount(address _owner) constant public returns(uint);
195 	function getAccessoryByIndex(address _owner, uint _index) constant public returns(uint) ;
196     function getTotalAccessorySeries() constant public returns (uint8) ;
197     function getTotalAccessories() constant public returns (uint);
198     function getAccessoryLockStatus(uint64 _acessoryId) constant public returns (bool);
199 }
200 
201 
202 contract ABTokenTransfer is AccessControl {
203     // Addresses for other contracts ABTokenTransfer interacts with. 
204   
205     address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
206     address public petCardDataContract = 0xB340686da996b8B3d486b4D27E38E38500A9E926;
207     address public accessoryDataContract = 0x466c44812835f57b736ef9F63582b8a6693A14D0;
208     address public ABTokenDataContract = 0xDC32FF5aaDA11b5cE3CAf2D00459cfDA05293F96;
209  
210 
211     
212     /*** DATA TYPES ***/
213 
214 
215     struct Angel {
216         uint64 angelId;
217         uint8 angelCardSeriesId;
218         address owner;
219         uint16 battlePower;
220         uint8 aura;
221         uint16 experience;
222         uint price;
223         uint64 createdTime;
224         uint64 lastBattleTime;
225         uint64 lastVsBattleTime;
226         uint16 lastBattleResult;
227     }
228 
229     struct Pet {
230         uint petId;
231         uint8 petCardSeriesId;
232         address owner;
233         string name;
234         uint8 luck;
235         uint16 auraRed;
236         uint16 auraYellow;
237         uint16 auraBlue;
238         uint64 lastTrainingTime;
239         uint64 lastBreedingTime;
240         uint price; 
241         uint64 liveTime;
242     }
243     
244      struct Accessory {
245         uint16 accessoryId;
246         uint8 accessorySeriesId;
247         address owner;
248     }
249 
250 
251     // write functions
252     function DataContacts(address _angelCardDataContract, address _petCardDataContract, address _accessoryDataContract, address _ABTokenDataContract) onlyCREATOR external {
253         angelCardDataContract = _angelCardDataContract;
254         petCardDataContract = _petCardDataContract;
255         accessoryDataContract = _accessoryDataContract;
256         ABTokenDataContract = _ABTokenDataContract;
257      
258       
259     }
260    
261   function claimPet(uint64 petID) public {
262        IPetCardData petCardData = IPetCardData(petCardDataContract);
263        IABToken ABTokenData = IABToken(ABTokenDataContract);
264        if ((petID <= 0) || (petID > petCardData.getTotalPets())) {revert();}
265        Pet memory pet;
266        (pet.petId,pet.petCardSeriesId,,pet.luck,pet.auraRed,pet.auraBlue,pet.auraYellow,,,pet.owner) = petCardData.getPet(petID);
267        if ((msg.sender != pet.owner) && (seraphims[msg.sender] == false)) {revert();}
268        //First burn the old pet by transfering to 0x0;
269        petCardData.transferPet(pet.owner,0x0,petID);
270        //finally create the new one. 
271        ABTokenData.mintABToken(pet.owner,pet.petCardSeriesId + 23, pet.luck, pet.auraRed, pet.auraYellow, pet.auraBlue, pet.name,0, uint16(pet.petId));
272   }
273        
274     function claimAccessory(uint64 accessoryID) public {
275        IAccessoryData accessoryData = IAccessoryData(accessoryDataContract);
276        IABToken ABTokenData = IABToken(ABTokenDataContract);
277        if ((accessoryID <= 0) || (accessoryID > accessoryData.getTotalAccessories())) {revert();}
278       Accessory memory accessory;
279        (,accessory.accessorySeriesId,accessory.owner) = accessoryData.getAccessory(accessoryID);
280        
281        //First burn the old accessory by transfering to 0x0;
282        // transfer function will revert if the accessory is still locked. 
283        accessoryData.transferAccessory(accessory.owner,0x0,accessoryID);
284        //finally create the new one. 
285        ABTokenData.mintABToken(accessory.owner,accessory.accessorySeriesId + 42, 0, 0, 0, 0, "0",0, uint16(accessoryID));
286   }
287        
288        function claimAngel(uint64 angelID) public {
289        IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
290        IABToken ABTokenData = IABToken(ABTokenDataContract);
291        if ((angelID <= 0) || (angelID > angelCardData.getTotalAngels())) {revert();}
292        Angel memory angel;
293        (angel.angelId, angel.angelCardSeriesId, angel.battlePower, angel.aura, angel.experience,,,,,, angel.owner) = angelCardData.getAngel(angelID);
294        
295        //First burn the old angel by transfering to 0x0;
296        //transfer will fail if card is locked. 
297        angelCardData.transferAngel(angel.owner,0x0,angel.angelId);
298        //finally create the new one.
299        uint16 auraRed = 0;
300        uint16 auraYellow = 0;
301        uint16 auraBlue = 0;
302        if (angel.aura == 1)  {auraBlue = 1;} //blue aura
303        if (angel.aura == 2)  {auraYellow = 1;} //yellow Aura 
304        if (angel.aura == 3)  {auraBlue = 1; auraRed = 1;} //purple Aura
305        if (angel.aura == 4)  {auraYellow = 1; auraRed = 1;} //orange Aura  
306        if (angel.aura == 5)  {auraRed = 1;} //red Aura
307        if (angel.aura == 6)  {auraBlue = 1; auraYellow =1;} //green Aura
308        ABTokenData.mintABToken(angel.owner,angel.angelCardSeriesId, angel.battlePower, auraRed, auraYellow, auraBlue,"0",0, uint16(angel.angelId));
309   }
310        
311        
312         
313      
314       function kill() onlyCREATOR external {
315         selfdestruct(creatorAddress);
316     }
317 }