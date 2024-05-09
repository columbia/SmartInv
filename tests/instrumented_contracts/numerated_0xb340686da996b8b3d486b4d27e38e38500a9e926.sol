1 pragma solidity ^0.4.17;
2 contract SafeMath {
3     function safeAdd(uint x, uint y) pure internal returns(uint) {
4       uint z = x + y;
5       assert((z >= x) && (z >= y));
6       return z;
7     }
8 
9     function safeSubtract(uint x, uint y) pure internal returns(uint) {
10       assert(x >= y);
11       uint z = x - y;
12       return z;
13     }
14 
15     function safeMult(uint x, uint y) pure internal returns(uint) {
16       uint z = x * y;
17       assert((x == 0)||(z/x == y));
18       return z;
19     }
20 
21     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
22         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
23         return uint8(genNum % (maxRandom - min + 1)+min);
24     }
25 }
26 
27 contract Enums {
28     enum ResultCode {
29         SUCCESS,
30         ERROR_CLASS_NOT_FOUND,
31         ERROR_LOW_BALANCE,
32         ERROR_SEND_FAIL,
33         ERROR_NOT_OWNER,
34         ERROR_NOT_ENOUGH_MONEY,
35         ERROR_INVALID_AMOUNT
36     }
37 
38     enum AngelAura { 
39         Blue, 
40         Yellow, 
41         Purple, 
42         Orange, 
43         Red, 
44         Green 
45     }
46 }
47 
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
96 
97 
98 
99 
100 contract IPetCardData is AccessControl, Enums {
101     uint8 public totalPetCardSeries;    
102     uint64 public totalPets;
103     
104     // write
105     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
106     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
107     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
108     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
109     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
110     function addPetIdMapping(address _owner, uint64 _petId) private;
111     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
112     function ownerPetTransfer (address _to, uint64 _petId)  public;
113     function setPetName(string _name, uint64 _petId) public;
114 
115     // read
116     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
117     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
118     function getOwnerPetCount(address _owner) constant public returns(uint);
119     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
120     function getTotalPetCardSeries() constant public returns (uint8);
121     function getTotalPets() constant public returns (uint);
122 }
123 
124 
125 
126 contract PetCardData is IPetCardData, SafeMath {
127     /*** EVENTS ***/
128     event CreatedPet(uint64 petId);
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /*** DATA TYPES ***/
132     struct PetCardSeries {
133         uint8 petCardSeriesId;
134         uint32 currentPetTotal;
135         uint32 maxPetTotal;
136     }
137 
138     struct Pet {
139         uint64 petId;
140         uint8 petCardSeriesId;
141         address owner;
142         string name;
143         uint8 luck;
144         uint16 auraRed;
145         uint16 auraYellow;
146         uint16 auraBlue;
147         uint64 lastTrainingTime;
148         uint64 lastBreedingTime;
149         uint price; 
150     }
151 
152 
153     /*** STORAGE ***/
154   
155     mapping(uint8 => PetCardSeries) public petCardSeriesCollection;
156     mapping(uint => Pet) public petCollection;
157     mapping(address => uint64[]) public ownerPetCollection;
158     
159     /*** FUNCTIONS ***/
160     //*** Write Access ***//
161     function PetCardData() public {
162         
163     }
164 
165     //*** Pets ***/
166     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8) {
167      if ((now > 1516642200) || (totalPetCardSeries >= 19)) {revert();}
168         //This confirms that no one, even the develoopers, can create any angel series after JAN/22/2018 @ 0530pm (UTC) or more than the original 24 series.
169       
170        PetCardSeries storage petCardSeries = petCardSeriesCollection[_petCardSeriesId];
171         petCardSeries.petCardSeriesId = _petCardSeriesId;
172         petCardSeries.maxPetTotal = _maxTotal;
173         totalPetCardSeries += 1;
174         return totalPetCardSeries;
175     }
176 	
177 	function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64) { 
178         PetCardSeries storage series = petCardSeriesCollection[_petCardSeriesId];
179 
180         if (series.currentPetTotal >= series.maxPetTotal) {
181             revert();
182         }
183         else {
184         totalPets += 1;
185         series.currentPetTotal +=1;
186         Pet storage pet = petCollection[totalPets];
187         pet.petId = totalPets;
188         pet.petCardSeriesId = _petCardSeriesId;
189         pet.owner = _owner;
190         pet.name = _name;
191         pet.luck = _luck;
192         pet.auraRed = _auraRed;
193         pet.auraYellow = _auraYellow;
194         pet.auraBlue = _auraBlue;
195         pet.lastTrainingTime = 0;
196         pet.lastBreedingTime = 0;
197         addPetIdMapping(_owner, pet.petId);
198         }
199     }
200 
201     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external {
202         Pet storage pet = petCollection[_petId];
203         if (pet.petId == _petId) {
204             pet.auraRed = _auraRed;
205             pet.auraBlue = _auraBlue;
206             pet.auraYellow = _auraYellow;
207         }
208     }
209 
210     function setPetName(string _name, uint64 _petId) public {
211         Pet storage pet = petCollection[_petId];
212         if ((pet.petId == _petId) && (msg.sender == pet.owner)) {
213             pet.name = _name;
214         }
215     }
216 
217 
218     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external {
219         Pet storage pet = petCollection[_petId];
220         if (pet.petId == _petId) {
221             pet.lastTrainingTime = uint64(now);
222         }
223     }
224 
225     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external {
226         Pet storage pet = petCollection[_petId];
227         if (pet.petId == _petId) {
228             pet.lastBreedingTime = uint64(now);
229         }
230     }
231     
232     function addPetIdMapping(address _owner, uint64 _petId) private {
233             uint64[] storage owners = ownerPetCollection[_owner];
234             owners.push(_petId);
235             Pet storage pet = petCollection[_petId];
236             pet.owner = _owner;
237             //this is a map of ALL the pets an address has EVER owned. 
238             //We check that they are still the current owner in javascrpit and other places on chain. 
239         
240     }
241 	
242 	function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode) {
243         Pet storage pet = petCollection[_petId];
244         if (pet.owner != _from) {
245             return ResultCode.ERROR_NOT_OWNER;
246         }
247         if (_from == _to) {revert();}
248         addPetIdMapping(_to, _petId);
249         pet.owner = _to;
250         return ResultCode.SUCCESS;
251     }
252     
253     //Anyone can transfer a pet they own by calling this function. 
254     
255   function ownerPetTransfer (address _to, uint64 _petId)  public  {
256      
257         if ((_petId > totalPets) || (_petId == 0)) {revert();}
258        if (msg.sender == _to) {revert();} //can't send to yourself. 
259         if (pet.owner != msg.sender) {
260             revert();
261         }
262         else {
263       Pet storage pet = petCollection[_petId];
264         pet.owner = _to;
265         addPetIdMapping(_to, _petId);
266         }
267     }
268 
269     //*** Read Access ***//
270     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal) {
271         PetCardSeries memory series = petCardSeriesCollection[_petCardSeriesId];
272         petCardSeriesId = series.petCardSeriesId;
273         currentPetTotal = series.currentPetTotal;
274         maxPetTotal = series.maxPetTotal;
275     }
276 	
277 	function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner) {
278         Pet memory pet = petCollection[_petId];
279         petId = pet.petId;
280         petCardSeriesId = pet.petCardSeriesId;
281         name = pet.name;
282         luck = pet.luck;
283         auraRed = pet.auraRed;
284         auraBlue = pet.auraBlue;
285         auraYellow = pet.auraYellow;
286         lastTrainingTime = pet.lastTrainingTime;
287         lastBreedingTime = pet.lastBreedingTime;
288         owner = pet.owner;
289     }
290 	
291 	function getOwnerPetCount(address _owner) constant public returns(uint) {
292         return ownerPetCollection[_owner].length;
293     }
294 	
295 	function getPetByIndex(address _owner, uint _index) constant public returns(uint) {
296         if (_index >= ownerPetCollection[_owner].length)
297             return 0;
298         return ownerPetCollection[_owner][_index];
299     }
300 
301     function getTotalPetCardSeries() constant public returns (uint8) {
302         return totalPetCardSeries;
303     }
304 
305     function getTotalPets() constant public returns (uint) {
306         return totalPets;
307     }
308 }