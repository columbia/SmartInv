1 pragma solidity ^0.4.24;
2 contract BasicAccessControl {
3     address public owner;
4     // address[] public moderators;
5     uint16 public totalModerators = 0;
6     mapping (address => bool) public moderators;
7     bool public isMaintaining = false;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     modifier onlyModerators() {
19         require(msg.sender == owner || moderators[msg.sender] == true);
20         _;
21     }
22 
23     modifier isActive {
24         require(!isMaintaining);
25         _;
26     }
27 
28     function ChangeOwner(address _newOwner) onlyOwner public {
29         if (_newOwner != address(0)) {
30             owner = _newOwner;
31         }
32     }
33 
34 
35     function AddModerator(address _newModerator) onlyOwner public {
36         if (moderators[_newModerator] == false) {
37             moderators[_newModerator] = true;
38             totalModerators += 1;
39         }
40     }
41     
42     function RemoveModerator(address _oldModerator) onlyOwner public {
43         if (moderators[_oldModerator] == true) {
44             moderators[_oldModerator] = false;
45             totalModerators -= 1;
46         }
47     }
48 
49     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
50         isMaintaining = _isMaintaining;
51     }
52 }
53 
54 interface EtheremonDataBase {
55     function getMonsterObj(uint64 _objId) constant external returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
56 }
57 
58 interface EtheremonMonsterNFTInterface {
59     function burnMonster(uint64 _tokenId) external;
60 }
61 
62 interface EtheremonTradeInterface {
63     function isOnTrading(uint64 _objId) constant external returns(bool);
64 }
65 
66 contract EtheremonBurnReward is BasicAccessControl {
67     
68     struct MonsterObjAcc {
69         uint64 monsterId;
70         uint32 classId;
71         address trainer;
72         string name;
73         uint32 exp;
74         uint32 createIndex;
75         uint32 lastClaimIndex;
76         uint createTime;
77     }
78     
79     // address
80     mapping(uint => uint) public requests; // mapping burn_id => monster_id
81     address public tradeContract;
82     address public dataContract;
83     address public monsterNFTContract;
84     
85     function setContract(address _monsterNFTContract, address _dataContract, address _tradeContract) onlyModerators public {
86         monsterNFTContract = _monsterNFTContract;
87         dataContract = _dataContract;
88         tradeContract = _tradeContract;
89     }
90     
91     // public api
92     function burnForReward(uint64 _monsterId, uint _burnId) isActive external {
93         if (_burnId == 0 || _monsterId == 0 || requests[_burnId] > 0) revert();
94         
95         EtheremonDataBase data = EtheremonDataBase(dataContract);
96         MonsterObjAcc memory obj;
97         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_monsterId);
98         if (obj.trainer == address(0) || obj.trainer != msg.sender) revert();
99         
100         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
101         if (trade.isOnTrading(_monsterId)) revert();
102         
103         EtheremonMonsterNFTInterface monsterNFT = EtheremonMonsterNFTInterface(monsterNFTContract);
104         monsterNFT.burnMonster(_monsterId);
105         
106         requests[_burnId] = _monsterId;
107     }
108     
109     function getBurnInfo(uint _burnId) constant external returns(uint) {
110         return requests[_burnId];
111     }
112 }