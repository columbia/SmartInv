1 pragma solidity ^0.4.25;
2 contract FourOutOfFive {
3 
4   struct GroupData {
5     uint groupId;
6     address[] participants;
7     uint timestamp;
8     uint betSize;
9     uint rewardSize;
10     uint8 rewardsAvailable;
11     address[] rewardedParticipants;
12     bool completed;
13   }
14 
15   event GroupCreated(
16     uint groupId,
17     address user,
18     uint timestamp,
19     uint betSize,
20     uint rewardSize
21   );
22 
23   event GroupJoin(
24     uint groupId,
25     address user
26   );
27 
28   event RewardClaimed(
29     uint groupId,
30     address user,
31     uint rewardSize,
32     uint timestamp
33   );
34 
35   GroupData[] Groups; 
36 
37   address owner;
38   uint minBet;
39   uint maxBet;
40   uint maxPossibleWithdraw;
41 
42   constructor() public {
43     owner = msg.sender;
44     setMaxAndMinBet(1000 ether, 10000 szabo); // 10000000000000000 wei
45   }
46   
47   modifier onlyOwner() {
48     require(msg.sender == owner, "Only owner can call.");
49     _;
50   }
51 
52   // Public funcs:
53 
54   function placeBet() public payable returns(bool _newGroupCreated) {
55 
56     require(msg.value >= minBet && msg.value <= maxBet,  "Wrong bet size");
57     
58     uint foundIndex = 0;
59     bool foundGroup = false;
60 
61     for (uint i = Groups.length ; i > 0; i--) {
62       if (Groups[i - 1].completed == false && Groups[i - 1].betSize == msg.value) {
63         foundGroup = true;
64         foundIndex = (i - 1); 
65         break;
66       }
67     }
68 
69     // If create new group
70     if (foundGroup == false) {
71 
72       uint groupId = Groups.length;
73       uint rewardSize = (msg.value / 100) * 120;
74 
75       Groups.push(GroupData({
76         groupId: groupId,
77         participants: new address[](0),
78         timestamp: block.timestamp,
79         betSize: msg.value,
80         rewardSize: rewardSize,
81         rewardsAvailable: 4,
82         rewardedParticipants: new address[](0),
83         completed: false
84       }));
85 
86       Groups[Groups.length - 1].participants.push(msg.sender);
87 
88       emit GroupCreated(
89         groupId,
90         msg.sender,
91         block.timestamp,
92         msg.value,
93         rewardSize
94       );
95 
96       return true;
97     }
98 
99     // Join the group
100     Groups[foundIndex].participants.push(msg.sender);
101 
102     if (Groups[foundIndex].participants.length == 5) {
103       Groups[foundIndex].completed = true;
104       maxPossibleWithdraw += ((msg.value / 100) * 20);
105     }
106 
107     emit GroupJoin(
108       foundIndex,
109       msg.sender
110     );
111 
112     return false;
113   }
114 
115 
116   function claimReward(uint _groupId) public {
117     // _groupId is index in array
118 
119     require(Groups[_groupId].completed == true, "Groups is not completed");
120     require(Groups[_groupId].rewardsAvailable > 0, "No reward found.");
121 
122     uint8 rewardsTotal;
123     uint8 rewardsClaimed;
124 
125     for (uint8 i = 0; i < Groups[_groupId].participants.length; i++) {
126       if (Groups[_groupId].participants[i] == msg.sender)
127         rewardsTotal += 1;
128     }
129 
130     for (uint8 j = 0; j < Groups[_groupId].rewardedParticipants.length; j++) {
131       if (Groups[_groupId].rewardedParticipants[j] == msg.sender)
132         rewardsClaimed += 1;
133     }
134 
135     require(rewardsTotal > rewardsClaimed, "No rewards found for this user");
136 
137     Groups[_groupId].rewardedParticipants.push(msg.sender);
138 
139     emit RewardClaimed(
140       _groupId,
141       msg.sender,
142       Groups[_groupId].rewardSize,
143       block.timestamp
144     );
145 
146     Groups[_groupId].rewardsAvailable -= 1;
147     msg.sender.transfer(Groups[_groupId].rewardSize);
148   }
149 
150   // Only Owner funcs:
151 
152   function withdrawOwnerMaxPossibleSafe() public onlyOwner {
153     owner.transfer(maxPossibleWithdraw);
154     maxPossibleWithdraw = 0;
155   }
156 
157   function setMaxAndMinBet(uint _maxBet, uint _minBet) public onlyOwner {
158     minBet = _minBet;
159     maxBet = _maxBet;
160   }
161 
162   // Public, ethfiddle, etherscan - friendly response
163 
164   function _getContactOwnerBalance() public view returns(uint) {
165     return address(owner).balance;
166   }
167 
168   function _getContactBalance() public view returns(uint) {
169     return address(this).balance;
170   }
171 
172   function _getMaxWithdraw() public view returns(uint _maxPossibleWithdraw) {
173     return maxPossibleWithdraw;
174   }
175 
176   function _getMaxPossibleWithdraw() public view returns(uint) {
177     return maxPossibleWithdraw;
178   }
179 
180   function _getGroupIds() public view returns(uint[]) {
181     uint[] memory groupIds = new uint[](Groups.length);
182     for (uint i = 0; i < Groups.length; i++) {
183       groupIds[i] = Groups[i].groupId;
184     }
185     return groupIds;
186   }
187 
188   function _getGroupParticipants(uint _groupId) public view returns(address[]) {
189     address[] memory participants = new address[](Groups[_groupId].participants.length);
190     for (uint i = 0; i < Groups[_groupId].participants.length; i++) {
191       participants[i] = Groups[_groupId].participants[i];
192     }
193     return participants;
194   }
195 
196   function _getGroupRewardedParticipants(uint _groupId) public view returns(address[]) {
197     address[] memory rewardedParticipants = new address[](Groups[_groupId].rewardedParticipants.length);
198     for (uint i = 0; i < Groups[_groupId].rewardedParticipants.length; i++) {
199       rewardedParticipants[i] = Groups[_groupId].rewardedParticipants[i];
200     }
201     return rewardedParticipants;
202   }
203 
204   function _getGroupRewardSize(uint _groupId) public view returns(uint) {
205     return(
206       Groups[_groupId].rewardSize
207     );
208   }
209 
210   function _getGroupComplete(uint _groupId) public view returns(bool) {
211     return(
212       Groups[_groupId].completed
213     );
214   }
215 
216   function _getGroupRewardsAvailable(uint _groupId) public view returns(uint8) {
217     return(
218       Groups[_groupId].rewardsAvailable
219     );
220   }
221 }