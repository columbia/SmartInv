1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC721 interface
5  * @dev see https://github.com/ethereum/eips/issues/721
6  */
7 
8 
9 contract AccessControl {
10     address public creatorAddress;
11     uint16 public totalSeraphims = 0;
12     mapping (address => bool) public seraphims;
13 
14     bool public isMaintenanceMode = true;
15  
16     modifier onlyCREATOR() {
17         require(msg.sender == creatorAddress);
18         _;
19     }
20 
21     modifier onlySERAPHIM() {
22         require(seraphims[msg.sender] == true);
23         _;
24     }
25     
26     modifier isContractActive {
27         require(!isMaintenanceMode);
28         _;
29     }
30     
31     // Constructor
32     function AccessControl() public {
33         creatorAddress = msg.sender;
34     }
35     
36 
37     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
38         if (seraphims[_newSeraphim] == false) {
39             seraphims[_newSeraphim] = true;
40             totalSeraphims += 1;
41         }
42     }
43     
44     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
45         if (seraphims[_oldSeraphim] == true) {
46             seraphims[_oldSeraphim] = false;
47             totalSeraphims -= 1;
48         }
49     }
50 
51     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
52         isMaintenanceMode = _isMaintaining;
53     }
54 
55   
56 } 
57 
58 contract SafeMath {
59     function safeAdd(uint x, uint y) pure internal returns(uint) {
60       uint z = x + y;
61       assert((z >= x) && (z >= y));
62       return z;
63     }
64 
65     function safeSubtract(uint x, uint y) pure internal returns(uint) {
66       assert(x >= y);
67       uint z = x - y;
68       return z;
69     }
70 
71     function safeMult(uint x, uint y) pure internal returns(uint) {
72       uint z = x * y;
73       assert((x == 0)||(z/x == y));
74       return z;
75     }
76 
77     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) constant public returns(uint8) {
78         uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(privateAddress);
79         return uint8(genNum % (maxRandom - min + 1)+min);
80     }
81 }
82 
83 contract Enums {
84     enum ResultCode {
85         SUCCESS,
86         ERROR_CLASS_NOT_FOUND,
87         ERROR_LOW_BALANCE,
88         ERROR_SEND_FAIL,
89         ERROR_NOT_OWNER,
90         ERROR_NOT_ENOUGH_MONEY,
91         ERROR_INVALID_AMOUNT
92     }
93 
94     enum AngelAura { 
95         Blue, 
96         Yellow, 
97         Purple, 
98         Orange, 
99         Red, 
100         Green 
101     }
102 }
103 
104 contract IPetCardData is AccessControl, Enums {
105     uint8 public totalPetCardSeries;    
106     uint64 public totalPets;
107     
108     // write
109     function createPetCardSeries(uint8 _petCardSeriesId, uint32 _maxTotal) onlyCREATOR public returns(uint8);
110     function setPet(uint8 _petCardSeriesId, address _owner, string _name, uint8 _luck, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue) onlySERAPHIM external returns(uint64);
111     function setPetAuras(uint64 _petId, uint8 _auraRed, uint8 _auraBlue, uint8 _auraYellow) onlySERAPHIM external;
112     function setPetLastTrainingTime(uint64 _petId) onlySERAPHIM external;
113     function setPetLastBreedingTime(uint64 _petId) onlySERAPHIM external;
114     function addPetIdMapping(address _owner, uint64 _petId) private;
115     function transferPet(address _from, address _to, uint64 _petId) onlySERAPHIM public returns(ResultCode);
116     function ownerPetTransfer (address _to, uint64 _petId)  public;
117     function setPetName(string _name, uint64 _petId) public;
118 
119     // read
120     function getPetCardSeries(uint8 _petCardSeriesId) constant public returns(uint8 petCardSeriesId, uint32 currentPetTotal, uint32 maxPetTotal);
121     function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, string name, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, uint64 lastTrainingTime, uint64 lastBreedingTime, address owner);
122     function getOwnerPetCount(address _owner) constant public returns(uint);
123     function getPetByIndex(address _owner, uint _index) constant public returns(uint);
124     function getTotalPetCardSeries() constant public returns (uint8);
125     function getTotalPets() constant public returns (uint);
126 }
127  
128 contract PetWrapper721 is AccessControl, Enums {
129   //Events
130   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
131   event MarketplaceTransfer(address indexed _from, address indexed _to, uint256 _tokenId, address _marketplace);
132   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
133 
134 
135 //Storage
136  
137    
138     address public petCardDataContract =0xB340686da996b8B3d486b4D27E38E38500A9E926;
139     
140     struct Pet {
141         uint64 petId;
142         uint8 petCardSeriesId;
143         address owner;
144         string name;
145         uint8 luck;
146         uint16 auraRed;
147         uint16 auraYellow;
148         uint16 auraBlue;
149         uint64 lastTrainingTime;
150         uint64 lastBreedingTime;
151         uint price; 
152     }
153 
154 
155 
156 
157     
158     function SetPetCardDataContact(address _petCardDataContract) onlyCREATOR external {
159        petCardDataContract = _petCardDataContract;
160     }
161 
162   function balanceOf(address _owner) public view returns (uint256 _balance) {
163          IPetCardData petCardData = IPetCardData(petCardDataContract);
164            return petCardData.getOwnerPetCount(_owner);
165   }
166   
167   function ownerOf(uint256 _tokenId) public view returns (address _owner) {
168             IPetCardData petCardData = IPetCardData(petCardDataContract);
169             address owner;
170              (,,,,,,,,, owner) = petCardData.getPet(uint64(_tokenId));
171             return owner;
172   }
173   
174   function getTokenByIndex (address _owner, uint index) constant public returns (uint64) {
175       //returns the angel number of the index-th item in that addresses angel list. 
176          IPetCardData petCardData = IPetCardData(petCardDataContract);
177         return uint64(petCardData.getPetByIndex(_owner, index));
178         
179   }
180 	
181 
182      function getPet(uint _petId) constant public returns(uint petId, uint8 petCardSeriesId, uint8 luck, uint16 auraRed, uint16 auraBlue, uint16 auraYellow, address owner) {
183          IPetCardData petCardData = IPetCardData(petCardDataContract);
184          (petId,petCardSeriesId,,luck, auraRed, auraBlue, auraYellow,, , owner) = petCardData.getPet(_petId);
185 
186     }
187 	
188         
189         
190        
191     
192     function getTokenLockStatus(uint64 _tokenId) constant public returns (bool) {
193        return false;
194        //lock is not implemented for pet tokens. 
195        
196     }
197     
198  
199   function transfer(address _to, uint256 _tokenId) public {
200       
201         IPetCardData petCardData = IPetCardData(petCardDataContract);
202        address owner;
203          (,,,,,,,,,owner) = petCardData.getPet(_tokenId);
204       
205        if ((seraphims[msg.sender] == true)  || (owner == msg.sender))
206        {
207          petCardData.transferPet(owner,_to, uint64 (_tokenId)) ;
208          Transfer(owner, _to, _tokenId);
209          MarketplaceTransfer(owner,  _to, _tokenId, msg.sender);
210            
211        }
212       else {revert();}
213   }
214   function approve(address _to, uint256 _tokenId) public
215   {
216       //this function should never be called - instead, use updateAccessoryLock from the accessoryData contract;
217       revert();
218       
219   }
220   function takeOwnership(uint256 _tokenId) public
221   { 
222      //this function should never be called - instead use transfer
223      revert();
224   }
225     function kill() onlyCREATOR external {
226         selfdestruct(creatorAddress);
227     }
228     }