1 pragma solidity ^0.4.24;
2 
3 // File: /home/robot/CarboneumProject/contracts/contracts/socialtrading/libs/LibUserInfo.sol
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
77 // File: /home/robot/CarboneumProject/contracts/contracts/socialtrading/interfaces/ISocialTrading.sol
78 
79 contract ISocialTrading is Ownable {
80 
81   /**
82    * @dev Follow leader to copy trade.
83    */
84   function follow(address _leader, uint256 _percentage) external;
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
102 // File: /home/robot/CarboneumProject/contracts/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * See https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function balanceOf(address _who) public view returns (uint256);
112   function transfer(address _to, uint256 _value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address _owner, address _spender)
124     public view returns (uint256);
125 
126   function transferFrom(address _from, address _to, uint256 _value)
127     public returns (bool);
128 
129   function approve(address _spender, uint256 _value) public returns (bool);
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 // File: contracts/socialtrading/SocialTrading.sol
138 
139 contract SocialTrading is ISocialTrading {
140   ERC20 public feeToken;
141   address public feeWallet;
142 
143   mapping(address => mapping(address => LibUserInfo.Following)) public followerToLeaders; // Following list
144   mapping(address => address[]) public followerToLeadersIndex; // Following list
145   mapping(address => mapping(address => uint8)) public leaderToFollowers;
146   mapping(address => address[]) public leaderToFollowersIndex; // Follower list
147 
148   mapping(address => bool) public relays;
149 
150   event Follow(address indexed leader, address indexed follower, uint percentage);
151   event UnFollow(address indexed leader, address indexed follower);
152   event AddRelay(address indexed relay);
153   event RemoveRelay(address indexed relay);
154   event PaidReward(
155     address indexed leader,
156     address indexed follower,
157     address indexed relay,
158     uint rewardAndFee,
159     bytes32 leaderOpenOrderHash,
160     bytes32 leaderCloseOrderHash,
161     bytes32 followerOpenOrderHash,
162     bytes32 followercloseOrderHash
163   );
164 
165   constructor (
166     address _feeWallet,
167     ERC20 _feeToken
168   ) public
169   {
170     feeWallet = _feeWallet;
171     feeToken = _feeToken;
172   }
173 
174   function() public {
175     revert();
176   }
177 
178   /**
179    * @dev Follow leader to copy trade.
180    */
181   function follow(address _leader, uint256 _percentage) external {
182     require(getCurrentPercentage(msg.sender) + _percentage <= 100 ether, "Following percentage more than 100%.");
183     uint8 index = uint8(followerToLeadersIndex[msg.sender].push(_leader) - 1);
184     followerToLeaders[msg.sender][_leader] = LibUserInfo.Following(
185       _leader,
186       _percentage,
187       index
188     );
189 
190     uint8 index2 = uint8(leaderToFollowersIndex[_leader].push(msg.sender) - 1);
191     leaderToFollowers[_leader][msg.sender] = index2;
192     emit Follow(_leader, msg.sender, _percentage);
193   }
194 
195   /**
196    * @dev UnFollow leader to stop copy trade.
197    */
198   function unfollow(address _leader) external {
199     _unfollow(msg.sender, _leader);
200   }
201 
202   function _unfollow(address _follower, address _leader) private {
203     uint8 rowToDelete = uint8(followerToLeaders[_follower][_leader].index);
204     address keyToMove = followerToLeadersIndex[_follower][followerToLeadersIndex[_follower].length - 1];
205     followerToLeadersIndex[_follower][rowToDelete] = keyToMove;
206     followerToLeaders[_follower][keyToMove].index = rowToDelete;
207     followerToLeadersIndex[_follower].length -= 1;
208 
209     uint8 rowToDelete2 = uint8(leaderToFollowers[_leader][_follower]);
210     address keyToMove2 = leaderToFollowersIndex[_leader][leaderToFollowersIndex[_leader].length - 1];
211     leaderToFollowersIndex[_leader][rowToDelete2] = keyToMove2;
212     leaderToFollowers[_leader][keyToMove2] = rowToDelete2;
213     leaderToFollowersIndex[_leader].length -= 1;
214     emit UnFollow(_leader, _follower);
215   }
216 
217   function getFriends(address _user) public view returns (address[]) {
218     address[] memory result = new address[](followerToLeadersIndex[_user].length);
219     uint counter = 0;
220     for (uint i = 0; i < followerToLeadersIndex[_user].length; i++) {
221       result[counter] = followerToLeadersIndex[_user][i];
222       counter++;
223     }
224     return result;
225   }
226 
227   function getFollowers(address _user) public view returns (address[]) {
228     address[] memory result = new address[](leaderToFollowersIndex[_user].length);
229     uint counter = 0;
230     for (uint i = 0; i < leaderToFollowersIndex[_user].length; i++) {
231       result[counter] = leaderToFollowersIndex[_user][i];
232       counter++;
233     }
234     return result;
235   }
236 
237   function getCurrentPercentage(address _user) internal view returns (uint) {
238     uint sum = 0;
239     for (uint i = 0; i < followerToLeadersIndex[_user].length; i++) {
240       address leader = followerToLeadersIndex[_user][i];
241       sum += followerToLeaders[_user][leader].percentage;
242     }
243     return sum;
244   }
245 
246   /**
247    * @dev Register relay to contract by the owner.
248    */
249   function registerRelay(address _relay) onlyOwner external {
250     relays[_relay] = true;
251     emit AddRelay(_relay);
252   }
253 
254   /**
255    * @dev Remove relay.
256    */
257   function removeRelay(address _relay) onlyOwner external {
258     relays[_relay] = false;
259     emit RemoveRelay(_relay);
260   }
261 
262   function distributeReward(
263     address _leader,
264     address _follower,
265     uint _reward,
266     uint _relayFee,
267     bytes32[4] _orderHashes
268   ) external
269   {
270     // orderHashes[0] = leaderOpenOrderHash
271     // orderHashes[1] = leaderCloseOrderHash
272     // orderHashes[2] = followerOpenOrderHash
273     // orderHashes[3] = followerCloseOrderHash
274     address relay = msg.sender;
275     require(relays[relay]);
276     // Accept only trusted relay
277     uint256 allowance = feeToken.allowance(_follower, address(this));
278     uint256 balance = feeToken.balanceOf(_follower);
279     uint rewardAndFee = _reward + _relayFee;
280     if ((balance >= rewardAndFee) && (allowance >= rewardAndFee)) {
281       feeToken.transferFrom(_follower, _leader, _reward);
282       feeToken.transferFrom(_follower, relay, _relayFee);
283       emit PaidReward(
284         _leader,
285         _follower,
286         relay,
287         rewardAndFee,
288         _orderHashes[0],
289         _orderHashes[1],
290         _orderHashes[2],
291         _orderHashes[3]
292       );
293     } else {
294       _unfollow(_follower, _leader);
295     }
296   }
297 }