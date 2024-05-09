1 pragma solidity ^0.4.24;
2 
3 // File: contracts/socialtrading/libs/LibUserInfo.sol
4 
5 contract LibUserInfo {
6   struct Following {
7     address leader;
8     uint percentage; // percentage (100 = 100%)
9     uint index;
10   }
11 }
12 
13 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 // File: contracts/socialtrading/interfaces/ISocialTrading.sol
78 
79 contract ISocialTrading is Ownable {
80 
81   /**
82    * @dev Follow leader to copy trade.
83    */
84   function follow(address _leader, uint8 _percentage) external;
85 
86   /**
87    * @dev UnFollow leader to stop copy trade.
88    */
89   function unfollow(address _leader) external;
90 
91   /**
92   * Friends - we refer to "friends" as the users that a specific user follows (e.g., following).
93   */
94   function getFriends(address _user) public view returns (address[]);
95 
96   /**
97   * Followers - refers to the users that follow a specific user.
98   */
99   function getFollowers(address _user) public view returns (address[]);
100 }
101 
102 // File: contracts/socialtrading/SocialTrading.sol
103 
104 contract SocialTrading is ISocialTrading {
105   mapping(address => mapping(address => LibUserInfo.Following)) public followerToLeaders; // Following list
106   mapping(address => address[]) public followerToLeadersIndex; // Following list
107   mapping(address => mapping(address => uint8)) public leaderToFollowers;
108   mapping(address => address[]) public leaderToFollowersIndex; // Follower list
109 
110   event Follow(address indexed leader, address indexed follower, uint percentage);
111   event UnFollow(address indexed leader, address indexed follower);
112 
113   function() public {
114     revert();
115   }
116 
117   /**
118    * @dev Follow leader to copy trade.
119    */
120   function follow(address _leader, uint8 _percentage) external {
121     require(getCurrentPercentage(msg.sender) + _percentage <= 100, "Following percentage more than 100%.");
122     uint8 index = uint8(followerToLeadersIndex[msg.sender].push(_leader) - 1);
123     followerToLeaders[msg.sender][_leader] = LibUserInfo.Following(
124       _leader,
125       _percentage,
126       index
127     );
128 
129     uint8 index2 = uint8(leaderToFollowersIndex[_leader].push(msg.sender) - 1);
130     leaderToFollowers[_leader][msg.sender] = index2;
131     emit Follow(_leader, msg.sender, _percentage);
132   }
133 
134   /**
135    * @dev UnFollow leader to stop copy trade.
136    */
137   function unfollow(address _leader) external {
138     _unfollow(msg.sender, _leader);
139   }
140 
141   function _unfollow(address _follower, address _leader) private {
142     uint8 rowToDelete = uint8(followerToLeaders[_follower][_leader].index);
143     address keyToMove = followerToLeadersIndex[_follower][followerToLeadersIndex[_follower].length - 1];
144     followerToLeadersIndex[_follower][rowToDelete] = keyToMove;
145     followerToLeaders[_follower][keyToMove].index = rowToDelete;
146     followerToLeadersIndex[_follower].length -= 1;
147 
148     uint8 rowToDelete2 = uint8(leaderToFollowers[_leader][_follower]);
149     address keyToMove2 = leaderToFollowersIndex[_leader][leaderToFollowersIndex[_leader].length - 1];
150     leaderToFollowersIndex[_leader][rowToDelete2] = keyToMove2;
151     leaderToFollowers[_leader][keyToMove2] = rowToDelete2;
152     leaderToFollowersIndex[_leader].length -= 1;
153     emit UnFollow(_leader, _follower);
154   }
155 
156   function getFriends(address _user) public view returns (address[]) {
157     address[] memory result = new address[](followerToLeadersIndex[_user].length);
158     uint counter = 0;
159     for (uint i = 0; i < followerToLeadersIndex[_user].length; i++) {
160       result[counter] = followerToLeadersIndex[_user][i];
161       counter++;
162     }
163     return result;
164   }
165 
166   function getFollowers(address _user) public view returns (address[]) {
167     address[] memory result = new address[](leaderToFollowersIndex[_user].length);
168     uint counter = 0;
169     for (uint i = 0; i < leaderToFollowersIndex[_user].length; i++) {
170       result[counter] = leaderToFollowersIndex[_user][i];
171       counter++;
172     }
173     return result;
174   }
175 
176   function getCurrentPercentage(address _user) internal returns (uint) {
177     uint sum = 0;
178     for (uint i = 0; i < followerToLeadersIndex[_user].length; i++) {
179       address leader = followerToLeadersIndex[_user][i];
180       sum += followerToLeaders[_user][leader].percentage;
181     }
182     return sum;
183   }
184 }