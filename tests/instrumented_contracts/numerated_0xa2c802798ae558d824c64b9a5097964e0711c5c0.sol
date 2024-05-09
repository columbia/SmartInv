1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) { return 0; }
6     uint256 c = a * b;
7     assert(c / a == b);
8     return c;
9   }
10 
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }
21 }
22 
23 
24 contract Manageable {
25 
26   address public owner;
27   address public manager;
28   bool public contractLock;
29   
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31   event ContractLockChanged(address admin, bool state);
32 
33   constructor() public {
34     owner = msg.sender;
35     contractLock = false;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   modifier isUnlocked() {
44     require(!contractLock);
45     _;
46   }
47 
48   function transferOwner(address _newOwner) public onlyOwner {
49     require(_newOwner != address(0));
50     emit OwnershipTransferred(owner, _newOwner);
51     owner = _newOwner;
52   }
53 
54   function setContractLock(bool setting) public onlyOwner {
55     contractLock = setting;
56     emit ContractLockChanged(msg.sender, setting);
57   }
58 
59   function _addrNotNull(address _to) internal pure returns (bool) {
60     return(_to != address(0));
61   }
62 }
63 
64 
65 contract InvitherB is Manageable {
66 /*********level A**********************************************/
67   using SafeMath for uint256;
68 
69 /********************************************** EVENTS **********************************************/
70   event AddUser(address user_address,  uint256 user_id, uint256 parent_id);
71   event Reward(address user_address, uint256 user_id, uint256 reward_amount);
72   event Init();
73 /****************************************************************************************************/
74 
75 /********************************************** STRUCTS *********************************************/
76   struct User {
77     address user_address;
78     uint256 parent_id;
79     uint256[5] childs;
80     bool isFull;
81   }
82 
83 /*********************************************** VARS ***********************************************/
84 
85   mapping(uint256 => User) private usersMap;
86   bool public initDone = false;
87   uint256 public userCount = 0;
88   uint256 public price = 100000000000000000;
89   address commissioner = 0xfe9313E171C441db91E3604F75cA58f13AA0Cb23;
90 /****************************************************************************************************/
91 
92 
93   function init() public onlyOwner {
94     require(!initDone);
95     initDone = true;
96     uint256 child = 0;
97     usersMap[0] = User({user_address: owner, parent_id: 0, childs:[child, child, child, child, child], isFull: false});  // solhint-disable-line max-line-length
98     userCount=1;
99     emit Init();
100   }
101     
102   function _addUser(address user_address) private returns (uint256) {
103     for (uint256 i=0; i<userCount; i++){
104       if (!usersMap[i].isFull){
105         for (uint256 j=0; j<5; j++){
106           if (usersMap[i].childs[j] == 0){
107             usersMap[i].childs[j] = userCount;
108             uint256 child = 0;
109             usersMap[userCount] = User({user_address: user_address, parent_id:i, childs:[child, child, child, child, child], isFull: false});
110             userCount++;
111             if (j == 4) usersMap[i].isFull = true;
112             return userCount-1;
113           }
114         }
115       }
116     }
117     return 0;
118   }
119 
120   function getRewarder(uint256 parent_id) private view returns (uint256) {
121     uint256 i = 0;
122     for (i = 0; i < 3; i++){
123       parent_id = usersMap[parent_id].parent_id;
124       if (parent_id == 0){
125         return 0;
126       }
127     }
128     return parent_id;
129   }
130 
131   function getUserCount() public view returns (uint256 _usercount){
132     _usercount = userCount;
133   }
134 
135   function getUser(uint256 _user_id) public view returns (address user_address, uint256 parent_id, uint256[5] childs, bool isFull){
136     User memory _user = usersMap[_user_id];
137     user_address = _user.user_address;
138     parent_id = _user.parent_id;
139     childs = _user.childs;
140     isFull = _user.isFull;
141   }
142 
143   function addUser(uint256 parent_id) public payable isUnlocked{
144     require(parent_id < userCount);  
145     require(msg.value >= price);
146     uint256 fee = msg.value.mul(4) / 100;
147     uint256 reward_amount = msg.value - fee;
148     if (!usersMap[parent_id].isFull) {
149       for (uint256 i=0; i<5; i++){
150         if (usersMap[parent_id].childs[i] == 0){
151           usersMap[parent_id].childs[i] = userCount;
152           uint256 child = 0;
153           usersMap[userCount] = User({user_address: msg.sender, parent_id:parent_id, childs:[child, child, child, child, child], isFull: false});
154           uint256 current_user_id = userCount;
155           userCount++;
156           if (i == 4) usersMap[parent_id].isFull = true;
157           emit AddUser(msg.sender, current_user_id, parent_id);
158           uint256 rewarder_id = getRewarder(parent_id);
159           commissioner.transfer(fee);
160           usersMap[rewarder_id].user_address.transfer(reward_amount);
161           emit Reward(usersMap[rewarder_id].user_address, rewarder_id, reward_amount);
162           break;
163         }
164       }
165     } 
166   }
167   
168   function addUserAuto() public payable isUnlocked{
169     require(msg.value >= price);
170     uint256 fee = msg.value.mul(4) / 100;
171     uint256 reward_amount = msg.value - fee;
172     uint256 user_id = _addUser(msg.sender);
173     emit AddUser(msg.sender, user_id, usersMap[user_id].parent_id);
174     uint256 rewarder = getRewarder(usersMap[user_id].parent_id);
175     commissioner.transfer(fee);
176     usersMap[rewarder].user_address.transfer(reward_amount);
177     emit Reward(usersMap[rewarder].user_address, rewarder, reward_amount);
178   }
179 }