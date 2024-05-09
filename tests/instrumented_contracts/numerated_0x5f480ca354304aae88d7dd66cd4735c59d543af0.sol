1 pragma solidity ^0.4.23;
2 
3 contract BasicAccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(msg.sender == owner || moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42     
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 interface EtheremonMonsterNFTInterface {
56    function triggerTransferEvent(address _from, address _to, uint _tokenId) external;
57    function getMonsterCP(uint64 _monsterId) constant external returns(uint cp);
58 }
59 
60 contract EtheremonEnum {
61 
62     enum ResultCode {
63         SUCCESS,
64         ERROR_CLASS_NOT_FOUND,
65         ERROR_LOW_BALANCE,
66         ERROR_SEND_FAIL,
67         ERROR_NOT_TRAINER,
68         ERROR_NOT_ENOUGH_MONEY,
69         ERROR_INVALID_AMOUNT
70     }
71     
72     enum ArrayType {
73         CLASS_TYPE,
74         STAT_STEP,
75         STAT_START,
76         STAT_BASE,
77         OBJ_SKILL
78     }
79     
80     enum PropertyType {
81         ANCESTOR,
82         XFACTOR
83     }
84 }
85 
86 contract EtheremonDataBase {
87     
88     uint64 public totalMonster;
89     uint32 public totalClass;
90     
91     // write
92     function addElementToArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint8 _value) external returns(uint);
93     function addMonsterObj(uint32 _classId, address _trainer, string _name) external returns(uint64);
94     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) external;
95     
96     // read
97     function getElementInArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint _index) constant external returns(uint8);
98     function getMonsterClass(uint32 _classId) constant external returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
99     function getMonsterObj(uint64 _objId) constant external returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
100 }
101 
102 contract EtheremonWorldNFT is BasicAccessControl {
103     uint8 constant public STAT_COUNT = 6;
104     uint8 constant public STAT_MAX = 32;
105     
106     struct MonsterClassAcc {
107         uint32 classId;
108         uint256 price;
109         uint256 returnPrice;
110         uint32 total;
111         bool catchable;
112     }
113 
114     struct MonsterObjAcc {
115         uint64 monsterId;
116         uint32 classId;
117         address trainer;
118         string name;
119         uint32 exp;
120         uint32 createIndex;
121         uint32 lastClaimIndex;
122         uint createTime;
123     }
124     
125     address public dataContract;
126     address public monsterNFT;
127     
128     mapping(uint32 => bool) classWhitelist;
129     mapping(address => bool) addressWhitelist;
130     
131     uint public gapFactor = 5;
132     uint public priceIncreasingRatio = 1000;
133     
134     function setContract(address _dataContract, address _monsterNFT) onlyModerators external {
135         dataContract = _dataContract;
136         monsterNFT = _monsterNFT;
137     }
138     
139     function setConfig(uint _gapFactor, uint _priceIncreasingRatio) onlyModerators external {
140         gapFactor = _gapFactor;
141         priceIncreasingRatio = _priceIncreasingRatio;
142     }
143     
144     function setClassWhitelist(uint32 _classId, bool _status) onlyModerators external {
145         classWhitelist[_classId] = _status;
146     }
147 
148     function setAddressWhitelist(address _smartcontract, bool _status) onlyModerators external {
149         addressWhitelist[_smartcontract] = _status;
150     }
151     
152     function withdrawEther(address _sendTo, uint _amount) onlyOwner public {
153         if (_amount > address(this).balance) {
154             revert();
155         }
156         _sendTo.transfer(_amount);
157     }
158     
159     function mintMonster(uint32 _classId, address _trainer, string _name) onlyModerators external returns(uint){
160         EtheremonDataBase data = EtheremonDataBase(dataContract);
161         // add monster
162         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
163         uint8 value;
164         uint seed = getRandom(_trainer, block.number-1, objId);
165         // generate base stat for the previous one
166         for (uint i=0; i < STAT_COUNT; i+= 1) {
167             seed /= 100;
168             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
169             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
170         }
171         
172         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _trainer, objId);
173         return objId;
174     }
175     
176     function burnMonster(uint64 _tokenId) onlyModerators external {
177         // need to check condition before calling this function
178         EtheremonDataBase data = EtheremonDataBase(dataContract);
179         MonsterObjAcc memory obj;
180         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_tokenId);
181         require(obj.trainer != address(0));
182         data.removeMonsterIdMapping(obj.trainer, _tokenId);
183         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(obj.trainer, address(0), _tokenId);
184     }
185     
186     // public api 
187     function getRandom(address _player, uint _block, uint _count) view public returns(uint) {
188         return uint(keccak256(abi.encodePacked(blockhash(_block), _player, _count)));
189     }
190     
191     function getMonsterClassBasic(uint32 _classId) constant external returns(uint256, uint256, uint256, bool) {
192         EtheremonDataBase data = EtheremonDataBase(dataContract);
193         MonsterClassAcc memory class;
194         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
195         return (class.price, class.returnPrice, class.total, class.catchable);
196     }
197     
198     function getPrice(uint32 _classId) constant external returns(bool catchable, uint price) {
199         EtheremonDataBase data = EtheremonDataBase(dataContract);
200         MonsterClassAcc memory class;
201         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
202         
203         price = class.price;
204         if (class.total > 0)
205             price += class.price*(class.total-1)/priceIncreasingRatio;
206         
207         if (class.catchable == false) {
208             return (classWhitelist[_classId], price);
209         } else {
210             return (true, price);
211         }
212     }
213     
214     function catchMonsterNFT(uint32 _classId, string _name) isActive external payable{
215         EtheremonDataBase data = EtheremonDataBase(dataContract);
216         MonsterClassAcc memory class;
217         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
218         if (class.classId == 0 || class.catchable == false) {
219             revert();
220         }
221         
222         uint price = class.price;
223         if (class.total > 0)
224             price += class.price*(class.total-1)/priceIncreasingRatio;
225         if (msg.value < price) {
226             revert();
227         }
228         
229         // add new monster 
230         uint64 objId = data.addMonsterObj(_classId, msg.sender, _name);
231         uint8 value;
232         uint seed = getRandom(msg.sender, block.number-1, objId);
233         // generate base stat for the previous one
234         for (uint i=0; i < STAT_COUNT; i+= 1) {
235             seed /= 100;
236             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
237             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
238         }
239         
240         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), msg.sender, objId);
241         // refund extra
242         if (msg.value > price) {
243             msg.sender.transfer((msg.value - price));
244         }
245     }
246     
247     // for whitelist contracts, no refund extra
248     function catchMonster(address _player, uint32 _classId, string _name) isActive external payable returns(uint tokenId) {
249         if (addressWhitelist[msg.sender] == false) {
250             revert();
251         }
252         
253         EtheremonDataBase data = EtheremonDataBase(dataContract);
254         MonsterClassAcc memory class;
255         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
256         if (class.classId == 0) {
257             revert();
258         }
259         
260         if (class.catchable == false && classWhitelist[_classId] == false) {
261             revert();
262         }
263         
264         uint price = class.price;
265         if (class.total > gapFactor) {
266             price += class.price*(class.total - gapFactor)/priceIncreasingRatio;
267         }
268         if (msg.value < price) {
269             revert();
270         }
271         
272         // add new monster 
273         uint64 objId = data.addMonsterObj(_classId, _player, _name);
274         uint8 value;
275         uint seed = getRandom(_player, block.number-1, objId);
276         // generate base stat for the previous one
277         for (uint i=0; i < STAT_COUNT; i+= 1) {
278             seed /= 100;
279             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
280             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
281         }
282         
283         EtheremonMonsterNFTInterface(monsterNFT).triggerTransferEvent(address(0), _player, objId);
284         return objId; 
285     }
286     
287 }