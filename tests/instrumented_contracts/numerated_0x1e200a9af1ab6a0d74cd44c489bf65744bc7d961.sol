1 pragma solidity ^0.4.14;
2 
3 contract BountyBG {
4 
5     address public owner;
6 
7     uint256 public bountyCount = 0;
8     uint256 public minBounty = 10 finney;
9     uint256 public bountyFee = 2 finney;
10     uint256 public bountyFeeCount = 0;
11     uint256 public bountyBeneficiariesCount = 2;
12     uint256 public bountyDuration = 30 hours;
13 
14     mapping(uint256 => Bounty) bountyAt;
15 
16     event BountyStatus(string _msg, uint256 _id, address _from, uint256 _amount);
17     event RewardStatus(string _msg, uint256 _id, address _to, uint256 _amount);
18     event ErrorStatus(string _msg, uint256 _id, address _to, uint256 _amount);
19 
20     struct Bounty {
21         uint256 id;
22         address owner;
23         uint256 bounty;
24         uint256 remainingBounty;
25         uint256 startTime;
26         uint256 endTime;
27         bool ended;
28         bool retracted;
29     }
30 
31     function BountyBG() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     // BLOCKGEEKS ACTIONS
41 
42     function withdrawFee(uint256 _amount) external onlyOwner {
43         require(_amount <= bountyFeeCount);
44         bountyFeeCount -= _amount;
45         owner.transfer(_amount);
46     }
47 
48     function setBountyDuration(uint256 _bountyDuration) external onlyOwner {
49         bountyDuration = _bountyDuration;
50     }
51 
52     function setMinBounty(uint256 _minBounty) external onlyOwner {
53         minBounty = _minBounty;
54     }
55 
56     function setBountyBeneficiariesCount(uint256 _bountyBeneficiariesCount) external onlyOwner {
57         bountyBeneficiariesCount = _bountyBeneficiariesCount;
58     }
59 
60     function rewardUsers(uint256 _bountyId, address[] _users, uint256[] _rewards) external onlyOwner {
61         Bounty storage bounty = bountyAt[_bountyId];
62         require(
63             !bounty.ended &&
64             !bounty.retracted &&
65             bounty.startTime + bountyDuration > block.timestamp &&
66             _users.length > 0 &&
67             _users.length <= bountyBeneficiariesCount &&
68             _users.length == _rewards.length
69         );
70 
71 
72 
73 
74 
75         bounty.ended = true;
76         bounty.endTime = block.timestamp;
77         uint256 currentRewards = 0;
78         for (uint8 i = 0; i < _rewards.length; i++) {
79             currentRewards += _rewards[i];
80         }
81 
82 
83 
84 
85 
86         require(bounty.bounty >= currentRewards);
87 
88         for (i = 0; i < _users.length; i++) {
89             _users[i].transfer(_rewards[i]);
90             RewardStatus("Reward sent", bounty.id, _users[i], _rewards[i]);
91             /* if (_users[i].send(_rewards[i])) {
92                 bounty.remainingBounty -= _rewards[i];
93                 RewardStatus('Reward sent', bounty.id, _users[i], _rewards[i]);
94             } else {
95                 ErrorStatus('Error in reward', bounty.id, _users[i], _rewards[i]);
96             } */
97         }
98     }
99 
100     function rewardUser(uint256 _bountyId, address _user, uint256 _reward) external onlyOwner {
101         Bounty storage bounty = bountyAt[_bountyId];
102         require(bounty.remainingBounty >= _reward);
103         bounty.remainingBounty -= _reward;
104 
105         bounty.ended = true;
106         bounty.endTime = block.timestamp;
107         
108         _user.transfer(_reward);
109         RewardStatus('Reward sent', bounty.id, _user, _reward);
110     }
111 
112     // USER ACTIONS TRIGGERED BY METAMASK
113 
114     function createBounty(uint256 _bountyId) external payable {
115         require(
116             msg.value >= minBounty + bountyFee
117         );
118         Bounty storage bounty = bountyAt[_bountyId];
119         require(bounty.id == 0);
120         bountyCount++;
121         bounty.id = _bountyId;
122         bounty.bounty = msg.value - bountyFee;
123         bounty.remainingBounty = bounty.bounty;
124         bountyFeeCount += bountyFee;
125         bounty.startTime = block.timestamp;
126         bounty.owner = msg.sender;
127         BountyStatus('Bounty submitted', bounty.id, msg.sender, msg.value);
128     }
129 
130     function cancelBounty(uint256 _bountyId) external {
131         Bounty storage bounty = bountyAt[_bountyId];
132         require(
133             msg.sender == bounty.owner &&
134             !bounty.ended &&
135             !bounty.retracted &&
136             bounty.owner == msg.sender &&
137             bounty.startTime + bountyDuration < block.timestamp
138         );
139         bounty.ended = true;
140         bounty.retracted = true;
141         bounty.owner.transfer(bounty.bounty);
142         BountyStatus('Bounty was canceled', bounty.id, msg.sender, bounty.bounty);
143     }
144 
145 
146     // CUSTOM GETTERS
147 
148     function getBalance() external view returns (uint256) {
149         return this.balance;
150     }
151 
152     function getBounty(uint256 _bountyId) external view
153     returns (uint256, address, uint256, uint256, uint256, uint256, bool, bool) {
154         Bounty memory bounty = bountyAt[_bountyId];
155         return (
156             bounty.id,
157             bounty.owner,
158             bounty.bounty,
159             bounty.remainingBounty,
160             bounty.startTime,
161             bounty.endTime,
162             bounty.ended,
163             bounty.retracted
164         );
165     }
166 
167 }