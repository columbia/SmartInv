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
48 contract AccessControl {
49     address public creatorAddress;
50     uint16 public totalSeraphims = 0;
51     mapping (address => bool) public seraphims;
52 
53     bool public isMaintenanceMode = true;
54  
55     modifier onlyCREATOR() {
56         require(msg.sender == creatorAddress);
57         _;
58     }
59 
60     modifier onlySERAPHIM() {
61         require(seraphims[msg.sender] == true);
62         _;
63     }
64     
65     modifier isContractActive {
66         require(!isMaintenanceMode);
67         _;
68     }
69     
70     // Constructor
71     function AccessControl() public {
72         creatorAddress = msg.sender;
73     }
74     
75 
76     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
77         if (seraphims[_newSeraphim] == false) {
78             seraphims[_newSeraphim] = true;
79             totalSeraphims += 1;
80         }
81     }
82     
83     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
84         if (seraphims[_oldSeraphim] == true) {
85             seraphims[_oldSeraphim] = false;
86             totalSeraphims -= 1;
87         }
88     }
89 
90     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
91         isMaintenanceMode = _isMaintaining;
92     }
93 
94   
95 } 
96 contract IAngelCardData is AccessControl, Enums {
97     uint8 public totalAngelCardSeries;
98     uint64 public totalAngels;
99 
100     
101     // write
102     // angels
103     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
104     function updateAngelCardSeries(uint8 _angelCardSeriesId) onlyCREATOR external;
105     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
106     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
107     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
108     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
109     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
110     function addAngelIdMapping(address _owner, uint64 _angelId) private;
111     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
112     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
113 
114     // read
115     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
116     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
117     function getOwnerAngelCount(address _owner) constant public returns(uint);
118     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
119     function getTotalAngelCardSeries() constant public returns (uint8);
120     function getTotalAngels() constant public returns (uint64);
121 }
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
146 contract TrainingField is AccessControl{
147     // Addresses for other contracts realm interacts with. 
148     address public angelCardDataContract;
149     address public petCardDataContract;
150     address public accessoryDataContract;
151     
152     // events
153      event EventSuccessfulTraining(uint64 angelId,uint64 pet1ID,uint64 pet2ID);
154     
155 
156     /*** DATA TYPES ***/
157 
158 
159     struct Angel {
160         uint64 angelId;
161         uint8 angelCardSeriesId;
162         address owner;
163         uint16 battlePower;
164         uint8 aura;
165         uint16 experience;
166         uint price;
167         uint64 createdTime;
168         uint64 lastBattleTime;
169         uint64 lastVsBattleTime;
170         uint16 lastBattleResult;
171     }
172 
173     struct Pet {
174         uint64 petId;
175         uint8 petCardSeriesId;
176         address owner;
177         string name;
178         uint8 luck;
179         uint16 auraRed;
180         uint16 auraYellow;
181         uint16 auraBlue;
182         uint64 lastTrainingTime;
183         uint64 lastBreedingTime;
184         uint price; 
185         uint64 liveTime;
186     }
187     
188 
189     // write functions
190     function SetAngelCardDataContact(address _angelCardDataContract) onlyCREATOR external {
191         angelCardDataContract = _angelCardDataContract;
192     }
193     function SetPetCardDataContact(address _petCardDataContract) onlyCREATOR external {
194         petCardDataContract = _petCardDataContract;
195     }
196        
197         function checkTraining (uint64 angelID, uint64  pet1ID, uint64 pet2ID) private returns (uint8) {
198               IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
199               IPetCardData petCardData = IPetCardData(petCardDataContract);
200         
201         //check if training function has improper parameters 
202         if (pet1ID == pet2ID) {return 0;}
203         if ((pet1ID <= 0) || (pet1ID > petCardData.getTotalPets())) {return 0;}
204         if ((pet2ID <= 0) || (pet2ID > petCardData.getTotalPets())) {return 0;}
205         if ((angelID <= 0) || (angelID > angelCardData.getTotalAngels())) {return 0;}
206         return 1;
207 }
208 
209         function Train (uint64 angelID, uint64  pet1ID, uint64 pet2ID) external  {
210         uint8 canTrain = checkTraining(angelID, pet1ID, pet2ID);
211         if (canTrain == 0 ) {revert();}
212         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
213         IPetCardData petCardData = IPetCardData(petCardDataContract);
214         
215         Pet memory pet1;
216         Pet memory pet2;
217         Angel memory angel;
218         (,,,angel.aura,,,,,,,angel.owner) = angelCardData.getAngel(angelID);
219         (,,,,pet1.auraRed,pet1.auraBlue,pet1.auraYellow,pet1.lastTrainingTime,,pet1.owner) = petCardData.getPet(pet1ID);
220         (,,,,pet2.auraRed,pet2.auraBlue,pet2.auraYellow,pet2.lastTrainingTime,,pet2.owner) = petCardData.getPet(pet2ID);
221      
222      //can't train with someone else's pets. 
223      if ((angel.owner != msg.sender) || (pet1.owner != msg.sender) || (pet2.owner!= msg.sender)) {revert();}
224      //check that you haven't trained for 24 hours 24 *60 * 60 
225      if ((now < (pet1.lastTrainingTime+86400)) || (now < (pet1.lastTrainingTime+86400))) {revert();}
226     
227     //AngelRed is a 0 when the angel�s aura isnt� compatible with Red and 1 when it is. 
228  
229     uint32 AngelRed = 0;
230     uint32 AngelBlue = 0;
231     uint32 AngelYellow = 0;
232  
233     if ((angel.aura == 4) || (angel.aura == 3) || (angel.aura == 2)) {AngelRed = 1;} 
234     if ((angel.aura == 0) || (angel.aura == 2) || (angel.aura == 5)) {AngelBlue = 1;}
235     if ((angel.aura == 3) || (angel.aura == 1) || (angel.aura == 5)) {AngelYellow = 1;}
236 
237     //You can�t Gain new aura colors, only strengthen the ones you have, so first make sure it HAS a red Aura before increasing it. 
238     
239    
240     
241     //Set Results
242     petCardData.setPetAuras(pet1ID,uint8(findAuras(pet1.auraRed, pet1.auraRed,pet2.auraRed, AngelRed)),uint8(findAuras(pet1.auraBlue, pet1.auraBlue,pet2.auraBlue, AngelBlue)), uint8(findAuras(pet1.auraYellow, pet1.auraYellow,pet2.auraYellow, AngelYellow)) );
243      petCardData.setPetAuras(pet2ID,uint8(findAuras(pet2.auraRed, pet1.auraRed,pet2.auraRed, AngelRed)),uint8(findAuras(pet2.auraBlue, pet1.auraBlue,pet2.auraBlue, AngelBlue)), uint8(findAuras(pet2.auraYellow, pet1.auraYellow,pet2.auraYellow, AngelYellow)) );
244     petCardData.setPetLastTrainingTime(pet1ID);
245     petCardData.setPetLastTrainingTime(pet2ID);
246    EventSuccessfulTraining(angelID, pet1ID, pet2ID);
247 
248 
249         } 
250         
251          function findAuras (uint16 petBaseAura, uint32 pet1Aura, uint32 pet2Aura, uint32 angelAura) private returns (uint32) {
252         //Increase by 1 if there is one compatible pet and 2 if there are two. 
253          if ((petBaseAura >=250) || (petBaseAura == 0)) {return petBaseAura;}
254          //max value allowed. 
255          if ((pet1Aura != 0) && (angelAura == 1)) {
256          if (pet2Aura != 0) {return petBaseAura + 2;}
257         else {return petBaseAura + 1;}
258         }
259         return petBaseAura;    
260         
261     }
262         
263       function kill() onlyCREATOR external {
264         selfdestruct(creatorAddress);
265     }
266 }