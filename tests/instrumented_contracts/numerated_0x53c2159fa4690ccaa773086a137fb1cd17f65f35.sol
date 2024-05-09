1 pragma solidity ^0.4.17;
2 
3 contract AccessControl {
4     address public creatorAddress;
5     uint16 public totalSeraphims = 0;
6     mapping (address => bool) public seraphims;
7 
8     bool public isMaintenanceMode = true;
9  
10     modifier onlyCREATOR() {
11         require(msg.sender == creatorAddress);
12         _;
13     }
14 
15     modifier onlySERAPHIM() {
16         require(seraphims[msg.sender] == true);
17         _;
18     }
19     
20     modifier isContractActive {
21         require(!isMaintenanceMode);
22         _;
23     }
24     
25     // Constructor
26     function AccessControl() public {
27         creatorAddress = msg.sender;
28     }
29     
30 
31     function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
32         if (seraphims[_newSeraphim] == false) {
33             seraphims[_newSeraphim] = true;
34             totalSeraphims += 1;
35         }
36     }
37     
38     function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
39         if (seraphims[_oldSeraphim] == true) {
40             seraphims[_oldSeraphim] = false;
41             totalSeraphims -= 1;
42         }
43     }
44 
45     function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
46         isMaintenanceMode = _isMaintaining;
47     }
48 
49   
50 } 
51 
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
101 contract IAngelCardData is AccessControl, Enums {
102     uint8 public totalAngelCardSeries;
103     uint64 public totalAngels;
104 
105     
106     // write
107     // angels
108     function createAngelCardSeries(uint8 _angelCardSeriesId, uint _basePrice,  uint64 _maxTotal, uint8 _baseAura, uint16 _baseBattlePower, uint64 _liveTime) onlyCREATOR external returns(uint8);
109     function updateAngelCardSeries(uint8 _angelCardSeriesId, uint64 _newPrice, uint64 _newMaxTotal) onlyCREATOR external;
110     function setAngel(uint8 _angelCardSeriesId, address _owner, uint _price, uint16 _battlePower) onlySERAPHIM external returns(uint64);
111     function addToAngelExperienceLevel(uint64 _angelId, uint _value) onlySERAPHIM external;
112     function setAngelLastBattleTime(uint64 _angelId) onlySERAPHIM external;
113     function setAngelLastVsBattleTime(uint64 _angelId) onlySERAPHIM external;
114     function setLastBattleResult(uint64 _angelId, uint16 _value) onlySERAPHIM external;
115     function addAngelIdMapping(address _owner, uint64 _angelId) private;
116     function transferAngel(address _from, address _to, uint64 _angelId) onlySERAPHIM public returns(ResultCode);
117     function ownerAngelTransfer (address _to, uint64 _angelId)  public;
118     function updateAngelLock (uint64 _angelId, bool newValue) public;
119     function removeCreator() onlyCREATOR external;
120 
121     // read
122     function getAngelCardSeries(uint8 _angelCardSeriesId) constant public returns(uint8 angelCardSeriesId, uint64 currentAngelTotal, uint basePrice, uint64 maxAngelTotal, uint8 baseAura, uint baseBattlePower, uint64 lastSellTime, uint64 liveTime);
123     function getAngel(uint64 _angelId) constant public returns(uint64 angelId, uint8 angelCardSeriesId, uint16 battlePower, uint8 aura, uint16 experience, uint price, uint64 createdTime, uint64 lastBattleTime, uint64 lastVsBattleTime, uint16 lastBattleResult, address owner);
124     function getOwnerAngelCount(address _owner) constant public returns(uint);
125     function getAngelByIndex(address _owner, uint _index) constant public returns(uint64);
126     function getTotalAngelCardSeries() constant public returns (uint8);
127     function getTotalAngels() constant public returns (uint64);
128     function getAngelLockStatus(uint64 _angelId) constant public returns (bool);
129 }
130 
131 contract IBattleCooldown is AccessControl, SafeMath {
132     
133     function setBestAngel (uint32 _bestAngel) onlySERAPHIM external ;
134     function getBestAngel() public constant returns (uint32) ;
135     function getBattleCooldown(uint64 angelID) constant public returns (uint64) ;
136     function getNextBattleTime(uint64 angelId) constant public returns (uint) ;
137     
138 }
139 
140 contract BattleCooldown  is IBattleCooldown {
141     // Addresses for other contracts ArenaBattle interacts with.
142 
143 
144 address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
145 uint32 public bestAngel = 120;
146       
147       
148     function setBestAngel (uint32 _bestAngel) onlySERAPHIM external {
149         bestAngel = _bestAngel;
150     }
151     
152     function getBestAngel() public constant returns (uint32) {
153         return bestAngel;
154     }
155     
156         function getBattleCooldown(uint64 angelID) constant public returns (uint64) {
157         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
158         uint64 experience;
159         (,,,,experience,,,,,,) = angelCardData.getAngel(angelID);
160        if (experience == bestAngel) {return 43200;}
161         if (safeSubtract(bestAngel, experience) > 120) {return 0;}
162          if (safeSubtract(bestAngel, experience) > 90) {return 3600;}
163          if (safeSubtract(bestAngel, experience) > 60) {return 21600;}
164          if (safeSubtract(bestAngel, experience) > 30) {return 28800;}
165          return 43200;
166         
167     }
168     
169     function getNextBattleTime(uint64 angelId) constant public returns (uint) {
170         //returns Unix timestamp of the next time an angel can battle. 
171         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
172         uint angellastBattleTime;
173            (,,,,,,,angellastBattleTime,,,) = angelCardData.getAngel(angelId);
174         return (angellastBattleTime + getBattleCooldown(angelId));
175 }
176 
177 }