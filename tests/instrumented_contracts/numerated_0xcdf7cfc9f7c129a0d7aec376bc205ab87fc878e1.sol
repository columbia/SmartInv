1 pragma solidity ^0.4.16;
2 
3 library AddressUtils {
4     function isContract(address addr) internal view returns (bool) {
5         uint256 size;
6         assembly { size := extcodesize(addr) }
7         return size > 0;
8     }
9 }
10 
11 contract BasicAccessControl {
12     address public owner;
13     // address[] public moderators;
14     uint16 public totalModerators = 0;
15     mapping (address => bool) public moderators;
16     bool public isMaintaining = false;
17 
18     function BasicAccessControl() public {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     modifier onlyModerators() {
28         require(msg.sender == owner || moderators[msg.sender] == true);
29         _;
30     }
31 
32     modifier isActive {
33         require(!isMaintaining);
34         _;
35     }
36 
37     function ChangeOwner(address _newOwner) onlyOwner public {
38         if (_newOwner != address(0)) {
39             owner = _newOwner;
40         }
41     }
42 
43 
44     function AddModerator(address _newModerator) onlyOwner public {
45         if (moderators[_newModerator] == false) {
46             moderators[_newModerator] = true;
47             totalModerators += 1;
48         }
49     }
50     
51     function RemoveModerator(address _oldModerator) onlyOwner public {
52         if (moderators[_oldModerator] == true) {
53             moderators[_oldModerator] = false;
54             totalModerators -= 1;
55         }
56     }
57 
58     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
59         isMaintaining = _isMaintaining;
60     }
61 }
62 
63 contract EtheremonEnum {
64 
65     enum ResultCode {
66         SUCCESS,
67         ERROR_CLASS_NOT_FOUND,
68         ERROR_LOW_BALANCE,
69         ERROR_SEND_FAIL,
70         ERROR_NOT_TRAINER,
71         ERROR_NOT_ENOUGH_MONEY,
72         ERROR_INVALID_AMOUNT
73     }
74     
75     enum ArrayType {
76         CLASS_TYPE,
77         STAT_STEP,
78         STAT_START,
79         STAT_BASE,
80         OBJ_SKILL
81     }
82     
83     enum PropertyType {
84         ANCESTOR,
85         XFACTOR
86     }
87 }
88 
89 interface EtheremonDataBase {
90     // read
91     function getMonsterClass(uint32 _classId) constant external returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
92     function getMonsterObj(uint64 _objId) constant external returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
93     function getElementInArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint _index) constant external returns(uint8);
94     
95     function addMonsterObj(uint32 _classId, address _trainer, string _name) external returns(uint64);
96     function addElementToArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint8 _value) external returns(uint);
97 }
98 
99 contract ERC20Interface {
100     function totalSupply() public constant returns (uint);
101     function balanceOf(address tokenOwner) public constant returns (uint balance);
102     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
103     function transfer(address to, uint tokens) public returns (bool success);
104     function approve(address spender, uint tokens) public returns (bool success);
105     function transferFrom(address from, address to, uint tokens) public returns (bool success);
106 }
107 
108 interface ERC721Interface {
109     function ownerOf(uint256 _tokenId) external view returns (address owner);
110 }
111 
112 interface EtheremonAdventureItem {
113     function ownerOf(uint256 _tokenId) external view returns (address);
114     function getItemInfo(uint _tokenId) constant external returns(uint classId, uint value);
115     function spawnItem(uint _classId, uint _value, address _owner) external returns(uint);
116 }
117 
118 interface EtheremonAdventureSetting {
119     function getSiteItem(uint _siteId, uint _seed) constant external returns(uint _monsterClassId, uint _tokenClassId, uint _value);
120     function getSiteId(uint _classId, uint _seed) constant external returns(uint);
121 }
122 
123 interface EtheremonMonsterNFT {
124     function mintMonster(uint32 _classId, address _trainer, string _name) external returns(uint);
125 }
126 
127 contract EtheremonAdventureData {
128     
129     function addLandRevenue(uint _siteId, uint _emontAmount, uint _etherAmount) external;
130     function addTokenClaim(uint _tokenId, uint _emontAmount, uint _etherAmount) external;
131     function addExploreData(address _sender, uint _typeId, uint _monsterId, uint _siteId, uint _startAt, uint _emontAmount, uint _etherAmount) external returns(uint);
132     function removePendingExplore(uint _exploreId, uint _itemSeed) external;
133     
134     // public function
135     function getLandRevenue(uint _classId) constant public returns(uint _emontAmount, uint _etherAmount);
136     
137     function getTokenClaim(uint _tokenId) constant public returns(uint _emontAmount, uint _etherAmount);
138     
139     function getExploreData(uint _exploreId) constant public returns(address _sender, uint _typeId, uint _monsterId, uint _siteId, uint _itemSeed, uint _startAt);
140     
141     function getPendingExplore(address _player) constant public returns(uint);
142     
143     function getPendingExploreData(address _player) constant public returns(uint _exploreId, uint _typeId, uint _monsterId, uint _siteId, uint _itemSeed, uint _startAt);
144 }
145 
146 contract EtheremonAdventure is EtheremonEnum, BasicAccessControl {
147     
148     using AddressUtils for address;
149     
150     uint8 constant public STAT_COUNT = 6;
151     uint8 constant public STAT_MAX = 32;
152 
153     struct MonsterObjAcc {
154         uint64 monsterId;
155         uint32 classId;
156         address trainer;
157         string name;
158         uint32 exp;
159         uint32 createIndex;
160         uint32 lastClaimIndex;
161         uint createTime;
162     }
163     
164     struct ExploreData {
165         address sender;
166         uint monsterType;
167         uint monsterId;
168         uint siteId;
169         uint itemSeed;
170         uint startAt; // blocknumber
171     }
172     
173     struct ExploreReward {
174         uint monsterClassId;
175         uint itemClassId;
176         uint value;
177         uint temp;
178     }
179     
180     address public dataContract;
181     address public monsterNFT;
182     address public adventureDataContract;
183     address public adventureSettingContract;
184     address public adventureItemContract;
185     address public tokenContract;
186     address public kittiesContract;
187     
188     uint public exploreETHFee = 0.01 ether;
189     uint public exploreEMONTFee = 1500000000;
190     uint public exploreFastenETHFee = 0.005 ether;
191     uint public exploreFastenEMONTFee = 750000000;
192     uint public minBlockGap = 240;
193     uint public totalSite = 54;
194     
195     uint seed = 0;
196     
197     event SendExplore(address indexed from, uint monsterType, uint monsterId, uint exploreId);
198     event ClaimExplore(address indexed from, uint exploreId, uint itemType, uint itemClass, uint itemId);
199     
200     modifier requireDataContract {
201         require(dataContract != address(0));
202         _;
203     }
204     
205     modifier requireAdventureDataContract {
206         require(adventureDataContract != address(0));
207         _;
208     }
209     
210     modifier requireAdventureSettingContract {
211         require(adventureSettingContract != address(0));
212         _;
213     }
214     
215     modifier requireTokenContract {
216         require(tokenContract != address(0));
217         _;
218     }
219     
220     modifier requireKittiesContract {
221         require(kittiesContract != address(0));
222         _;
223     }
224     
225     function setContract(address _dataContract, address _monsterNFT, address _adventureDataContract, address _adventureSettingContract, address _adventureItemContract, address _tokenContract, address _kittiesContract) onlyOwner public {
226         dataContract = _dataContract;
227         monsterNFT = _monsterNFT;
228         adventureDataContract = _adventureDataContract;
229         adventureSettingContract = _adventureSettingContract;
230         adventureItemContract = _adventureItemContract;
231         tokenContract = _tokenContract;
232         kittiesContract = _kittiesContract;
233     }
234 
235     function setFeeConfig(uint _exploreETHFee, uint _exploreEMONTFee, uint _exploreFastenETHFee, uint _exploreFastenEMONTFee) onlyOwner public {
236         exploreETHFee = _exploreETHFee;
237         exploreEMONTFee = _exploreEMONTFee;
238         exploreFastenEMONTFee = _exploreFastenEMONTFee;
239         exploreFastenETHFee = _exploreFastenETHFee;
240     }
241 
242     function setConfig( uint _minBlockGap, uint _totalSite) onlyOwner public {
243         minBlockGap = _minBlockGap;
244         totalSite = _totalSite;
245     }
246     
247     function withdrawEther(address _sendTo, uint _amount) onlyOwner public {
248         // it is used in case we need to upgrade the smartcontract
249         if (_amount > address(this).balance) {
250             revert();
251         }
252         _sendTo.transfer(_amount);
253     }
254     
255     function withdrawToken(address _sendTo, uint _amount) onlyOwner requireTokenContract external {
256         ERC20Interface token = ERC20Interface(tokenContract);
257         if (_amount > token.balanceOf(address(this))) {
258             revert();
259         }
260         token.transfer(_sendTo, _amount);
261     }
262     
263     function adventureByToken(address _player, uint _token, uint _param1, uint _param2, uint64 _param3, uint64 _param4) isActive onlyModerators external {
264         // param1 = 1 -> explore, param1 = 2 -> claim 
265         if (_param1 == 1) {
266             _exploreUsingEmont(_player, _param2, _param3, _token);
267         } else {
268             _claimExploreItemUsingEMont(_param2, _token);
269         }
270     }
271     
272     function _exploreUsingEmont(address _sender, uint _monsterType, uint _monsterId, uint _token) internal {
273         if (_token < exploreEMONTFee) revert();
274         seed = getRandom(_sender, block.number - 1, seed, _monsterId);
275         uint siteId = getTargetSite(_sender, _monsterType, _monsterId, seed);
276         if (siteId == 0) revert();
277         
278         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
279         uint exploreId = adventureData.addExploreData(_sender, _monsterType, _monsterId, siteId, block.number, _token, 0);
280         SendExplore(_sender, _monsterType, _monsterId, exploreId);
281     }
282     
283     function _claimExploreItemUsingEMont(uint _exploreId, uint _token) internal {
284         if (_token < exploreFastenEMONTFee) revert();
285         
286         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
287         ExploreData memory exploreData;
288         (exploreData.sender, exploreData.monsterType, exploreData.monsterId, exploreData.siteId, exploreData.itemSeed, exploreData.startAt) = adventureData.getExploreData(_exploreId);
289         
290         if (exploreData.itemSeed != 0)
291             revert();
292         
293         // min 2 blocks
294         if (block.number < exploreData.startAt + 2)
295             revert();
296         
297         exploreData.itemSeed = getRandom(exploreData.sender, exploreData.startAt + 1, exploreData.monsterId, _exploreId) % 100000;
298         ExploreReward memory reward;
299         (reward.monsterClassId, reward.itemClassId, reward.value) = EtheremonAdventureSetting(adventureSettingContract).getSiteItem(exploreData.siteId, exploreData.itemSeed);
300         
301         adventureData.removePendingExplore(_exploreId, exploreData.itemSeed);
302         
303         if (reward.monsterClassId > 0) {
304             EtheremonMonsterNFT monsterContract = EtheremonMonsterNFT(monsterNFT);
305             reward.temp = monsterContract.mintMonster(uint32(reward.monsterClassId), exploreData.sender,  "..name me..");
306             ClaimExplore(exploreData.sender, _exploreId, 0, reward.monsterClassId, reward.temp);
307         } else if (reward.itemClassId > 0) {
308             // give new adventure item 
309             EtheremonAdventureItem item = EtheremonAdventureItem(adventureItemContract);
310             reward.temp = item.spawnItem(reward.itemClassId, reward.value, exploreData.sender);
311             ClaimExplore(exploreData.sender, _exploreId, 1, reward.itemClassId, reward.temp);
312         } else if (reward.value > 0) {
313             // send token contract
314             ERC20Interface token = ERC20Interface(tokenContract);
315             token.transfer(exploreData.sender, reward.value);
316             ClaimExplore(exploreData.sender, _exploreId, 2, 0, reward.value);
317         } else {
318             revert();
319         }
320     }
321     
322     // public
323     
324     function getRandom(address _player, uint _block, uint _seed, uint _count) constant public returns(uint) {
325         return uint(keccak256(block.blockhash(_block), _player, _seed, _count));
326     }
327     
328     function getTargetSite(address _sender, uint _monsterType, uint _monsterId, uint _seed) constant public returns(uint) {
329         if (_monsterType == 0) {
330             // Etheremon 
331             MonsterObjAcc memory obj;
332             (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = EtheremonDataBase(dataContract).getMonsterObj(uint64(_monsterId));
333             if (obj.trainer != _sender) revert();
334             return EtheremonAdventureSetting(adventureSettingContract).getSiteId(obj.classId, _seed);
335         } else if (_monsterType == 1) {
336             // Cryptokitties
337             if (_sender != ERC721Interface(kittiesContract).ownerOf(_monsterId)) revert();
338             return EtheremonAdventureSetting(adventureSettingContract).getSiteId(_seed % totalSite, _seed);
339         }
340         return 0;
341     }
342     
343     function exploreUsingETH(uint _monsterType, uint _monsterId) isActive public payable {
344         // not allow contract to make txn
345         if (msg.sender.isContract()) revert();
346         
347         if (msg.value < exploreETHFee) revert();
348         seed = getRandom(msg.sender, block.number - 1, seed, _monsterId);
349         uint siteId = getTargetSite(msg.sender, _monsterType, _monsterId, seed);
350         if (siteId == 0) revert();
351         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
352         uint exploreId = adventureData.addExploreData(msg.sender, _monsterType, _monsterId, siteId, block.number, 0, msg.value);
353         SendExplore(msg.sender, _monsterType, _monsterId, exploreId);
354     }
355     
356     function claimExploreItem(uint _exploreId) isActive public payable {
357         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
358         ExploreData memory exploreData;
359         (exploreData.sender, exploreData.monsterType, exploreData.monsterId, exploreData.siteId, exploreData.itemSeed, exploreData.startAt) = adventureData.getExploreData(_exploreId);
360         
361         if (exploreData.itemSeed != 0)
362             revert();
363         
364         // min 2 blocks
365         if (block.number < exploreData.startAt + 2)
366             revert();
367         
368         exploreData.itemSeed = getRandom(exploreData.sender, exploreData.startAt + 1, exploreData.monsterId, _exploreId) % 100000;
369         if (msg.value < exploreFastenETHFee) {
370             if (block.number < exploreData.startAt + minBlockGap + exploreData.startAt % minBlockGap)
371                 revert();
372         }
373         
374         ExploreReward memory reward;
375         (reward.monsterClassId, reward.itemClassId, reward.value) = EtheremonAdventureSetting(adventureSettingContract).getSiteItem(exploreData.siteId, exploreData.itemSeed);
376         
377         adventureData.removePendingExplore(_exploreId, exploreData.itemSeed);
378         
379         if (reward.monsterClassId > 0) {
380             EtheremonMonsterNFT monsterContract = EtheremonMonsterNFT(monsterNFT);
381             reward.temp = monsterContract.mintMonster(uint32(reward.monsterClassId), exploreData.sender,  "..name me..");
382             ClaimExplore(exploreData.sender, _exploreId, 0, reward.monsterClassId, reward.temp);
383         } else if (reward.itemClassId > 0) {
384             // give new adventure item 
385             EtheremonAdventureItem item = EtheremonAdventureItem(adventureItemContract);
386             reward.temp = item.spawnItem(reward.itemClassId, reward.value, exploreData.sender);
387             ClaimExplore(exploreData.sender, _exploreId, 1, reward.itemClassId, reward.temp);
388         } else if (reward.value > 0) {
389             // send token contract
390             ERC20Interface token = ERC20Interface(tokenContract);
391             token.transfer(exploreData.sender, reward.value);
392             ClaimExplore(exploreData.sender, _exploreId, 2, 0, reward.value);
393         } else {
394             revert();
395         }
396     }
397     
398     // public
399     
400     function predictExploreReward(uint _exploreId) constant external returns(uint itemSeed, uint rewardMonsterClass, uint rewardItemCLass, uint rewardValue) {
401         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
402         ExploreData memory exploreData;
403         (exploreData.sender, exploreData.monsterType, exploreData.monsterId, exploreData.siteId, exploreData.itemSeed, exploreData.startAt) = adventureData.getExploreData(_exploreId);
404         
405         if (exploreData.itemSeed != 0) {
406             itemSeed = exploreData.itemSeed;
407         } else {
408             if (block.number < exploreData.startAt + 2)
409                 return (0, 0, 0, 0);
410             itemSeed = getRandom(exploreData.sender, exploreData.startAt + 1, exploreData.monsterId, _exploreId) % 100000;
411         }
412         (rewardMonsterClass, rewardItemCLass, rewardValue) = EtheremonAdventureSetting(adventureSettingContract).getSiteItem(exploreData.siteId, itemSeed);
413     }
414     
415     function getExploreItem(uint _exploreId) constant external returns(address trainer, uint monsterType, uint monsterId, uint siteId, uint startBlock, uint rewardMonsterClass, uint rewardItemClass, uint rewardValue) {
416         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
417         (trainer, monsterType, monsterId, siteId, rewardMonsterClass, startBlock) = adventureData.getExploreData(_exploreId);
418         
419         if (rewardMonsterClass > 0) {
420             (rewardMonsterClass, rewardItemClass, rewardValue) = EtheremonAdventureSetting(adventureSettingContract).getSiteItem(siteId, rewardMonsterClass);
421         }
422         
423     }
424     
425     function getPendingExploreItem(address _trainer) constant external returns(uint exploreId, uint monsterType, uint monsterId, uint siteId, uint startBlock, uint endBlock) {
426         EtheremonAdventureData adventureData = EtheremonAdventureData(adventureDataContract);
427         (exploreId, monsterType, monsterId, siteId, endBlock, startBlock) = adventureData.getPendingExploreData(_trainer);
428         if (exploreId > 0) {
429             endBlock = startBlock + minBlockGap + startBlock % minBlockGap;
430         }
431     }
432 
433 }