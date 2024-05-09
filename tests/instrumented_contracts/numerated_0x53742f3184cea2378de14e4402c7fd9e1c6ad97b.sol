1 pragma solidity ^0.4.24;
2 
3 // File: contracts/socialtrading/libs/LibUserInfo.sol
4 
5 contract LibUserInfo {
6   struct Following {
7     address leader;
8     uint percentage; // percentage times (1 ether)
9     uint timeStamp;
10     uint index;
11   }
12 }
13 
14 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
15 
16 /**
17  * @title Ownable
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipRenounced(address indexed previousOwner);
26   event OwnershipTransferred(
27     address indexed previousOwner,
28     address indexed newOwner
29   );
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   constructor() public {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to relinquish control of the contract.
50    * @notice Renouncing to ownership will leave the contract without an owner.
51    * It will not be possible to call the functions with the `onlyOwner`
52    * modifier anymore.
53    */
54   function renounceOwnership() public onlyOwner {
55     emit OwnershipRenounced(owner);
56     owner = address(0);
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param _newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address _newOwner) public onlyOwner {
64     _transferOwnership(_newOwner);
65   }
66 
67   /**
68    * @dev Transfers control of the contract to a newOwner.
69    * @param _newOwner The address to transfer ownership to.
70    */
71   function _transferOwnership(address _newOwner) internal {
72     require(_newOwner != address(0));
73     emit OwnershipTransferred(owner, _newOwner);
74     owner = _newOwner;
75   }
76 }
77 
78 // File: contracts/socialtrading/interfaces/ISocialTrading.sol
79 
80 contract ISocialTrading is Ownable {
81 
82   /**
83    * @dev Follow leader to copy trade.
84    */
85   function follow(address _leader, uint _percentage) external;
86 
87   /**
88    * @dev UnFollow leader to stop copy trade.
89    */
90   function unfollow(address _leader) external;
91 
92   /**
93   * Friends - we refer to "friends" as the users that a specific user follows (e.g., following).
94   */
95   function getFriends(address _user) public view returns (address[]);
96 
97   /**
98   * Followers - refers to the users that follow a specific user.
99   */
100   function getFollowers(address _user) public view returns (address[]);
101 }
102 
103 // File: contracts/socialtrading/SocialTrading.sol
104 
105 contract SocialTrading is ISocialTrading {
106   mapping(address => mapping(address => LibUserInfo.Following)) public followerToLeaders; // Following list
107   mapping(address => address[]) public followerToLeadersIndex; // Following list
108   mapping(address => mapping(address => uint)) public leaderToFollowers;
109   mapping(address => address[]) public leaderToFollowersIndex; // Follower list
110 
111   event Follow(address indexed leader, address indexed follower, uint percentage);
112   event UnFollow(address indexed leader, address indexed follower);
113 
114   function() public {
115     revert();
116   }
117 
118   /**
119    * @dev Follow leader to copy trade.
120    */
121   function follow(address _leader, uint _percentage) external {
122     require(getCurrentPercentage(msg.sender) + _percentage <= 100 ether, "Your percentage more than 100%.");
123     uint index = followerToLeadersIndex[msg.sender].push(_leader) - 1;
124     followerToLeaders[msg.sender][_leader] = LibUserInfo.Following(_leader, _percentage, now, index);
125 
126     uint index2 = leaderToFollowersIndex[_leader].push(msg.sender) - 1;
127     leaderToFollowers[_leader][msg.sender] = index2;
128     emit Follow(_leader, msg.sender, _percentage);
129   }
130 
131   /**
132    * @dev UnFollow leader to stop copy trade.
133    */
134   function unfollow(address _leader) external {
135     _unfollow(msg.sender, _leader);
136   }
137 
138   function _unfollow(address _follower, address _leader) private {
139     uint rowToDelete = followerToLeaders[_follower][_leader].index;
140     address keyToMove = followerToLeadersIndex[_follower][followerToLeadersIndex[_follower].length - 1];
141     followerToLeadersIndex[_follower][rowToDelete] = keyToMove;
142     followerToLeaders[_follower][keyToMove].index = rowToDelete;
143     followerToLeadersIndex[_follower].length -= 1;
144 
145     uint rowToDelete2 = leaderToFollowers[_leader][_follower];
146     address keyToMove2 = leaderToFollowersIndex[_leader][leaderToFollowersIndex[_leader].length - 1];
147     leaderToFollowersIndex[_leader][rowToDelete2] = keyToMove2;
148     leaderToFollowers[_leader][keyToMove2] = rowToDelete2;
149     leaderToFollowersIndex[_leader].length -= 1;
150     emit UnFollow(_leader, _follower);
151   }
152 
153   function getFriends(address _user) public view returns (address[]) {
154     address[] memory result = new address[](followerToLeadersIndex[_user].length);
155     uint counter = 0;
156     for (uint i = 0; i < followerToLeadersIndex[_user].length; i++) {
157       result[counter] = followerToLeadersIndex[_user][i];
158       counter++;
159     }
160     return result;
161   }
162 
163   function getFollowers(address _user) public view returns (address[]) {
164     address[] memory result = new address[](leaderToFollowersIndex[_user].length);
165     uint counter = 0;
166     for (uint i = 0; i < leaderToFollowersIndex[_user].length; i++) {
167       result[counter] = leaderToFollowersIndex[_user][i];
168       counter++;
169     }
170     return result;
171   }
172 
173   function getCurrentPercentage(address _user) internal returns (uint) {
174     uint sum = 0;
175     for (uint i = 0; i < followerToLeadersIndex[_user].length; i++) {
176       address leader = followerToLeadersIndex[_user][i];
177       sum += followerToLeaders[_user][leader].percentage;
178     }
179     return sum;
180   }
181 }