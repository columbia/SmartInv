1 pragma solidity ^0.4.17;
2 
3 
4 contract AccessControl {
5     address public creatorAddress;
6     uint16 public totalSeraphims = 0;
7     mapping (address => bool) public seraphims;
8 
9     bool public isMaintenanceMode = true;
10  
11     modifier onlyCREATOR() {
12         require(msg.sender == creatorAddress);
13         _;
14     }
15 
16     modifier onlySERAPHIM() {
17         require(seraphims[msg.sender] == true);
18         _;
19     }
20     
21     modifier isContractActive {
22         require(!isMaintenanceMode);
23         _;
24     }
25     
26     // Constructor
27     function AccessControl() public {
28         creatorAddress = msg.sender;
29     }
30     
31 
32     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
33         if (seraphims[_newSeraphim] == false) {
34             seraphims[_newSeraphim] = true;
35             totalSeraphims += 1;
36         }
37     }
38     
39     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
40         if (seraphims[_oldSeraphim] == true) {
41             seraphims[_oldSeraphim] = false;
42             totalSeraphims -= 1;
43         }
44     }
45 
46     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
47         isMaintenanceMode = _isMaintaining;
48     }
49 
50   
51 } 
52 contract SafeMath {
53     function safeAdd(uint x, uint y) pure internal returns(uint) {
54       uint z = x + y;
55       assert((z >= x) && (z >= y));
56       return z;
57     }
58 
59     function safeSubtract(uint x, uint y) pure internal returns(uint) {
60       assert(x >= y);
61       uint z = x - y;
62       return z;
63     }
64 
65     function safeMult(uint x, uint y) pure internal returns(uint) {
66       uint z = x * y;
67       assert((x == 0)||(z/x == y));
68       return z;
69     }
70     
71      
72 
73     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
74         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
75         return uint8(genNum % (maxRandom - min + 1)+min);
76     }
77 }
78 
79 contract Enums {
80     enum ResultCode {
81         SUCCESS,
82         ERROR_CLASS_NOT_FOUND,
83         ERROR_LOW_BALANCE,
84         ERROR_SEND_FAIL,
85         ERROR_NOT_OWNER,
86         ERROR_NOT_ENOUGH_MONEY,
87         ERROR_INVALID_AMOUNT
88     }
89 
90     enum AngelAura { 
91         Blue, 
92         Yellow, 
93         Purple, 
94         Orange, 
95         Red, 
96         Green 
97     }
98 }
99 
100 
101 contract IPetCardData is AccessControl, Enums {
102     uint8 public totalPetCardSeries;    
103     uint64 public totalPets;
104     
105     // write
106     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
107     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
108     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
109     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
110     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
111     function addPetIdMapping(address _owner, uint64 _petId) private;
112     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
113     function ownerPetTransfer (address _to, uint64 _petId)  public;
114     function setPetName(string _name, uint64 _petId) public;
115 
116     // read
117     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
118     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
119     function getOwnerPetCount(address _owner) constant public returns(uint);
120     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
121     function getTotalPetCardSeries() constant public returns (uint8);
122     function getTotalPets() constant public returns (uint);
123 }
124 
125 contract RetirePets is AccessControl, SafeMath {
126 
127   
128    
129     address public petCardDataContract = 0xB340686da996b8B3d486b4D27E38E38500A9E926;
130 
131 
132    
133     // events
134    
135     event EventNewPet(uint64 petID);
136 
137   
138 
139 
140 
141     // write functions
142     function DataContacts( address _petCardDataContract) onlyCREATOR external {
143         petCardDataContract = _petCardDataContract;
144       
145     }
146     
147 
148        
149     function checkPet (uint64  petID) private constant returns (uint8) {
150               IPetCardData petCardData = IPetCardData(petCardDataContract);
151               
152         //check if a pet both exists and is owned by the message sender.
153         // This function also returns the petcardSeriesID. 
154      
155         if ((petID <= 0) || (petID > petCardData.getTotalPets())) {return 0;}
156         
157         address petowner;
158         uint8 petcardSeriesID;
159      
160       (,petcardSeriesID,,,,,,,,petowner) = petCardData.getPet(petID);
161     
162          if  (petowner != msg.sender)  {return 0;}
163         
164         return petcardSeriesID;
165         
166         
167 }
168      function retireWildEasy(uint64 pet1, uint64 pet2, uint64 pet3, uint64 pet4, uint64 pet5, uint64 pet6) public {
169             IPetCardData petCardData = IPetCardData(petCardDataContract);
170          // Send this function the petIds of 6 of your Wild Easy (2 star pets) to receive 1 3 star pet. 
171          
172          //won't throw an error if you send a level3 pet, but will still recycle. This is to reduce gas costs for everyone. 
173          if (checkPet(pet1) <5) {revert();}
174          if (checkPet(pet2) <5) {revert();}
175          if (checkPet(pet3) <5) {revert();}
176          if (checkPet(pet4) <5) {revert();}
177          if (checkPet(pet5) <5) {revert();}
178          if (checkPet(pet6) <5) {revert();}
179          
180        petCardData.transferPet(msg.sender, address(0), pet1);
181        petCardData.transferPet(msg.sender, address(0), pet2);
182        petCardData.transferPet(msg.sender, address(0), pet3);
183        petCardData.transferPet(msg.sender, address(0), pet4);
184        petCardData.transferPet(msg.sender, address(0), pet5);
185        petCardData.transferPet(msg.sender, address(0), pet6);
186         getNewPetCard(getRandomNumber(12,9,msg.sender));
187          
188      }
189 
190     function retireWildHard(uint64 pet1, uint64 pet2, uint64 pet3, uint64 pet4, uint64 pet5, uint64 pet6) public {
191             IPetCardData petCardData = IPetCardData(petCardDataContract);
192          // Send this function the petIds of 6 of your Wild Hard (3 star pets) to receive 1 four star pet. 
193          
194         
195          if (checkPet(pet1) <9) {revert();}
196          if (checkPet(pet2) <9) {revert();}
197          if (checkPet(pet3) <9) {revert();}
198          if (checkPet(pet4) <9) {revert();}
199          if (checkPet(pet5) <9) {revert();}
200          if (checkPet(pet6) <9) {revert();}
201          
202        petCardData.transferPet(msg.sender, address(0), pet1);
203        petCardData.transferPet(msg.sender, address(0), pet2);
204        petCardData.transferPet(msg.sender, address(0), pet3);
205        petCardData.transferPet(msg.sender, address(0), pet4);
206        petCardData.transferPet(msg.sender, address(0), pet5);
207        petCardData.transferPet(msg.sender, address(0), pet6);
208         getNewPetCard(getRandomNumber(16,13,msg.sender));
209          
210      }
211 
212 
213     
214    function getNewPetCard(uint8 opponentId) private {
215         uint16 _auraRed = 0;
216         uint16 _auraYellow = 0;
217         uint16 _auraBlue = 0;
218         
219         uint32 _auraColor = getRandomNumber(2,0,msg.sender);
220         if (_auraColor == 0) { _auraRed = 14;}
221         if (_auraColor == 1) { _auraYellow = 14;}
222         if (_auraColor == 2) { _auraBlue = 14;}
223         
224         uint8 _newLuck = getRandomNumber(39,30,msg.sender);
225         IPetCardData petCardData = IPetCardData(petCardDataContract);
226         uint64 petId = petCardData.setPet(opponentId+4, msg.sender, 'Rover', _newLuck, _auraRed, _auraYellow, _auraBlue);
227         EventNewPet(petId);
228         }
229 
230 
231  
232       function kill() onlyCREATOR external {
233         selfdestruct(creatorAddress);
234     }
235 }