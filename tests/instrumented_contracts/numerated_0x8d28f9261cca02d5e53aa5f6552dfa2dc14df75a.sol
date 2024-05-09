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
52 
53 
54 contract SafeMath {
55     function safeAdd(uint x, uint y) pure internal returns(uint) {
56       uint z = x + y;
57       assert((z >= x) && (z >= y));
58       return z;
59     }
60 
61     function safeSubtract(uint x, uint y) pure internal returns(uint) {
62       assert(x >= y);
63       uint z = x - y;
64       return z;
65     }
66 
67     function safeMult(uint x, uint y) pure internal returns(uint) {
68       uint z = x * y;
69       assert((x == 0)||(z/x == y));
70       return z;
71     }
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
130 contract LeaderboardSlogans is AccessControl {
131     
132     
133     mapping(uint64 => string) public slogans;
134     uint64[] Slogans;
135     address public angelCardDataContract = 0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
136     
137      function SetAngelCardDataContact(address _angelCardDataContract) onlyCREATOR external {
138         angelCardDataContract = _angelCardDataContract;
139     }
140     function setSlogan(uint64 _angelID, string _slogan) public {
141         IAngelCardData angelCardData = IAngelCardData(angelCardDataContract);
142           address angelowner;
143           (,,,,,,,,,,angelowner) = angelCardData.getAngel(_angelID);
144             if (angelowner != msg.sender) {revert();}
145              //can only set slogans for angels you own. 
146             slogans[_angelID] = _slogan;
147     }
148     function getSlogan(uint64 _angelID) public constant returns (string) {
149         return slogans[_angelID];
150     }
151     
152        function kill() onlyCREATOR external {
153         selfdestruct(creatorAddress);
154     }
155 }