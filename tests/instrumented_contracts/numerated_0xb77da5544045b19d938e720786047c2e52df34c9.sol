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
54 interface EtheremonMonsterNFT {
55     function mintMonster(uint32 _classId, address _trainer, string _name) external returns(uint);
56 }
57 
58 interface EtheremonAdventureItem {
59     function ownerOf(uint256 _tokenId) external view returns (address);
60     function getItemInfo(uint _tokenId) constant external returns(uint classId, uint value);
61     function spawnItem(uint _classId, uint _value, address _owner) external returns(uint);
62 }
63 
64 contract EtheremonReward is BasicAccessControl {
65     bytes constant SIG_PREFIX = "\x19Ethereum Signed Message:\n32";
66     
67     enum RewardType {
68         NONE,
69         REWARD_EMONA,
70         REWARD_EXP_EMOND,
71         REWARD_LEVEL_EMOND
72     }
73     
74     // uint32 rId, uint32 rewardType, uint32 rewardValue, uint32 createTime, uint64 _, uint64 _
75     struct RewardToken {
76         uint rId;
77         uint rewardType;
78         uint rewardValue;
79         uint createTime;
80     }
81     
82     uint public levelItemClass = 200;
83     uint public expItemClass = 201;
84     
85     mapping(uint => uint) public emonaLimit; // maping monster_class_id => max_amount
86     mapping(uint => uint) public expEmondLimit; // mapping exp_value => max_amount
87     mapping(uint => uint) public levelEmondLimit; // mapping level_value => max_amount
88     mapping(uint => uint) public requestStatus; // request_id => status
89 
90     // address
91     address public verifyAddress;
92     address public adventureItemContract;
93     address public monsterNFT;
94     
95     function setConfig(address _verifyAddress, address _adventureItemContract, address _monsterNFT) onlyModerators public {
96         verifyAddress = _verifyAddress;
97         adventureItemContract = _adventureItemContract;
98         monsterNFT = _monsterNFT;
99     }
100     
101     function setEmonaLimit(uint _monsterClass, uint _limit) onlyModerators public {
102         emonaLimit[_monsterClass] = _limit;
103     }
104     
105     function setExpEmondLimit(uint _expValue, uint _limit) onlyModerators public {
106         expEmondLimit[_expValue] = _limit;
107     }
108     
109     function setLevelEmondLimit(uint _levelValue, uint _limit) onlyModerators public {
110         levelEmondLimit[_levelValue] = _limit;
111     }
112     
113     // public
114     function extractRewardToken(bytes32 _rt) public pure returns(uint rId, uint rewardType, uint rewardValue, uint createTime) {
115         createTime = uint32(_rt>>128);
116         rewardValue = uint32(_rt>>160);
117         rewardType = uint32(_rt>>192);
118         rId = uint32(_rt>>224);
119     }
120     
121     function getVerifySignature(address sender, bytes32 _token) public pure returns(bytes32) {
122         return keccak256(abi.encodePacked(sender, _token));
123     }
124     
125     function getVerifyAddress(address sender, bytes32 _token, uint8 _v, bytes32 _r, bytes32 _s) public pure returns(address) {
126         bytes32 hashValue = keccak256(abi.encodePacked(sender, _token));
127         bytes32 prefixedHash = keccak256(abi.encodePacked(SIG_PREFIX, hashValue));
128         return ecrecover(prefixedHash, _v, _r, _s);
129     }
130     
131     function requestReward(bytes32 _token, uint8 _v, bytes32 _r, bytes32 _s) isActive external {
132         if (verifyAddress == address(0)) revert();
133         if (getVerifyAddress(msg.sender, _token, _v, _r, _s) != verifyAddress) revert();
134         RewardToken memory rToken;
135         
136         (rToken.rId, rToken.rewardType, rToken.rewardValue, rToken.createTime) = extractRewardToken(_token);
137         if (rToken.rId == 0 || requestStatus[rToken.rId] > 0) revert();
138         
139         
140         EtheremonMonsterNFT monsterContract = EtheremonMonsterNFT(monsterNFT);
141         EtheremonAdventureItem item = EtheremonAdventureItem(adventureItemContract);
142         if (rToken.rewardType == uint(RewardType.REWARD_EMONA)) {
143             if (emonaLimit[rToken.rewardValue] < 1) revert();
144             monsterContract.mintMonster(uint32(rToken.rewardValue), msg.sender,  "..name me..");
145             emonaLimit[rToken.rewardValue] -= 1;
146             
147         } else if (rToken.rewardType == uint(RewardType.REWARD_EXP_EMOND)) {
148             if (expEmondLimit[rToken.rewardValue] < 1) revert();
149             item.spawnItem(expItemClass, rToken.rewardValue, msg.sender);
150             expEmondLimit[rToken.rewardValue] -= 1;
151             
152         } else if (rToken.rewardType == uint(RewardType.REWARD_LEVEL_EMOND)) {
153             if (levelEmondLimit[rToken.rewardValue] < 1) revert();
154             item.spawnItem(levelItemClass, rToken.rewardValue, msg.sender);
155             levelEmondLimit[rToken.rewardValue] -= 1;
156 
157         } else {
158             revert();
159         }
160         
161         requestStatus[rToken.rId] = 1;
162     }
163     
164     function getRequestStatus(uint _requestId) public view returns(uint) {
165         return requestStatus[_requestId];
166     }
167     
168     
169 }