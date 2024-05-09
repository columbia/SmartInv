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
104 contract IAngelCardData is AccessControl, Enums {
105     uint8 public totalAngelCardSeries;
106     uint64 public totalAngels;
107 
108     
109     // write
110     // angels
111     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
112     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
113     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
114     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
115     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
116     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
117     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
118     function addAngelIdMapping(address _owner, uint64 _angelId) private;
119     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
120     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
121     function updateAngelLock (uint64 _angelId, bool newValue) public;
122     function removeCreator() onlyCREATOR external;
123 
124     // read
125     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
126     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
127     function getOwnerAngelCount(address _owner) constant public returns(uint);
128     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
129     function getTotalAngelCardSeries() constant public returns (uint8);
130     function getTotalAngels() constant public returns (uint64);
131     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
132 }
133  
134 contract AngelWrapper721 is AccessControl, Enums {
135   //Events
136   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
137   event MarketplaceTransfer(address indexed _from, address indexed _to, uint256 _tokenId, address _marketplace);
138   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
139 
140 
141 //Storage
142  
143    
144     address public angelCardDataContract = 0x6d2e76213615925c5fc436565b5ee788ee0e86dc;
145     
146     struct Angel {
147         uint64 angelId;
148         uint8 angelCardSeriesId;
149         address owner;
150         uint16 battlePower;
151         AngelAura aura;
152         uint16 experience;
153         uint price;
154         uint64 createdTime;
155         uint64 lastBattleTime;
156         uint64 lastVsBattleTime;
157         uint16 lastBattleResult;
158         bool ownerLock;
159     }
160 
161 
162 
163 
164     
165     function SetAngelCardDataContact(address _angelCardDataContract) onlyCREATOR external {
166        angelCardDataContract = _angelCardDataContract;
167     }
168 
169   function balanceOf(address _owner) public view returns (uint256 _balance) {
170            IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
171            return angelCardData.getOwnerAngelCount(_owner);
172   }
173   
174   function ownerOf(uint256 _tokenId) public view returns (address _owner) {
175             IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
176             address owner;
177         (,,,,,,,,,,owner) = angelCardData.getAngel(uint64(_tokenId));
178             return owner;
179   }
180   
181   function getTokenByIndex (address _owner, uint index) constant public returns (uint64) {
182       //returns the angel number of the index-th item in that addresses angel list. 
183              IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
184         return uint64(angelCardData.getAngelByIndex(_owner, index));
185         
186   }
187 	
188 
189         
190          function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, address owner) {
191         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
192         (angelId,angelCardSeriesId, battlePower, aura,experience,price,,,,, owner) = angelCardData.getAngel(_angelId);
193       
194     }
195         
196         
197        
198     
199     function getTokenLockStatus(uint64 _tokenId) constant public returns (bool) {
200        IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
201        return angelCardData.getAngelLockStatus(_tokenId);
202        
203     }
204     
205    
206  
207   function transfer(address _to, uint256 _tokenId) public {
208       
209         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
210        address owner;
211        (,,,,,,,,, owner) = angelCardData.getAngel(uint64(_tokenId));
212       
213        if ((seraphims[msg.sender] == true)  || (owner == msg.sender))
214        {
215          angelCardData.transferAngel(owner,_to, uint64 (_tokenId)) ;
216          Transfer(owner, _to, _tokenId);
217          MarketplaceTransfer(owner,  _to, _tokenId, msg.sender);
218            
219        }
220       else {revert();}
221   }
222   function approve(address _to, uint256 _tokenId) public
223   {
224       //this function should never be called - instead, use updateAccessoryLock from the accessoryData contract;
225       revert();
226       
227   }
228   function takeOwnership(uint256 _tokenId) public
229   { 
230      //this function should never be called - instead use transfer
231      revert();
232   }
233     function kill() onlyCREATOR external {
234         selfdestruct(creatorAddress);
235     }
236     }