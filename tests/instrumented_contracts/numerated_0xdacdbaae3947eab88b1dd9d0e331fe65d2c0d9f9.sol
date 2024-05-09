1 pragma solidity ^0.4.24;
2 
3 /* 
4 Welcome to the greates pyramid scheme of the Internet! And it's UNSTOPPABLE
5 You can access it on IPFS here: https://ipfs.io/ipfs/Qmb6q3oWG33xeNoVppRHv1Mk23e5zMd8JK7dmKAhgiFk9H/
6 */
7 
8 contract UnstoppablePyramid {
9     
10     /* Admin */
11     address devAddress = 0x75E129b02D12ECa5A5D7548a5F75007f84387b8F;
12 
13     /* The Unstoppable Ponzi Core */
14     uint256 basePricePonzi = 50000000000000000;    // 0.05 ETH
15 
16     /* Some stats */
17     uint256 totalAmountPlayed;
18     uint256 totalCommissionSent;
19 
20     struct PonziFriend {
21         address playerAddr;
22         uint parent;
23         uint256 amountPlayed;   // We keep track of the amount invested
24         uint256 amountEarned;   // We keep track of the commissions received. It can't be more than 10x the amount invested
25     }
26     PonziFriend[] ponziFriends;
27     mapping (address => uint) public ponziFriendsToId;
28     
29     /* Track Level 1, 2 and 3 commissions */
30     mapping (uint => uint) public ponziFriendToLevel1Ref;
31     mapping (uint => uint) public ponziFriendToLevel2Ref;
32     mapping (uint => uint) public ponziFriendToLevel3Ref;
33 
34     // The main function, we call it when a new friend wants to join
35     function newPonziFriend(uint _parentId) public payable isHuman() {
36         /* Commissions */
37         uint256 com1percent = msg.value / 100;
38         uint256 comLevel1 = com1percent * 50; // 50%
39         uint256 comLevel2 = com1percent * 35; // 35%
40         uint256 comLevel3 = com1percent * 15; // 15%
41     
42         require(msg.value >= basePricePonzi);
43 
44         /* Transfer commission to parents (level 1, 2 & 3) */
45 
46         // Transfer to level 1 if parent[l1] hasn't reached its limit
47         if(ponziFriends[_parentId].amountEarned < (ponziFriends[_parentId].amountPlayed * 5) && _parentId < ponziFriends.length) {
48             // Transfer commission
49             ponziFriends[_parentId].playerAddr.transfer(comLevel1);
50 
51             // Record amount received
52             ponziFriends[_parentId].amountEarned += comLevel1;
53             
54             // Increment level 1 ref
55             ponziFriendToLevel1Ref[_parentId]++;
56         } else {
57             // If the parent has exceeded its x5 limit we transfer the commission to the dev
58             devAddress.transfer(comLevel1);
59         }
60         
61 
62         // Transfer to level 2
63         uint level2parent = ponziFriends[_parentId].parent;
64         if(ponziFriends[level2parent].amountEarned < (ponziFriends[level2parent].amountPlayed *5 )) {
65             // Transfer commission
66             ponziFriends[level2parent].playerAddr.transfer(comLevel2);
67 
68             // Record amount received
69             ponziFriends[level2parent].amountEarned += comLevel2;
70             
71             // Increment level 2 ref
72             ponziFriendToLevel2Ref[level2parent]++;
73         } else {
74             // If the parent has exceeded its x5 limit we transfer the commission to the dev
75             devAddress.transfer(comLevel2);
76         }
77         
78 
79         // Transfer to level 3
80         uint level3parent = ponziFriends[level2parent].parent;
81         if(ponziFriends[level3parent].amountEarned < (ponziFriends[level3parent].amountPlayed * 5)) {
82             // Transfer commission
83             ponziFriends[level3parent].playerAddr.transfer(comLevel3); 
84 
85             // Record amount received
86             ponziFriends[level3parent].amountEarned += comLevel3;
87             
88             // Increment level 3 ref
89             ponziFriendToLevel3Ref[level3parent]++;
90         } else {
91             // If the parent has exceeded its x5 limit we transfer the commission to the dev
92             devAddress.transfer(comLevel3);
93         }
94 
95         /* End Transfer */
96 
97         /* Save Ponzi Friend in struct */
98 
99         if(ponziFriendsToId[msg.sender] > 0) {
100             // Player exists, update data
101             ponziFriends[ponziFriendsToId[msg.sender]].amountPlayed += msg.value;
102         } else {
103             // Player doesn't exist create it
104             uint pzfId = ponziFriends.push(PonziFriend(msg.sender, _parentId, msg.value, 0)) - 1;
105             ponziFriendsToId[msg.sender] = pzfId;
106         }
107 
108         /* End Save Ponzi Friend */
109 
110         /* Save stats */
111         totalAmountPlayed = totalAmountPlayed + msg.value;
112         totalCommissionSent = totalCommissionSent + comLevel1 + comLevel2 + comLevel3;
113 
114     }
115 
116     // This function is called when the contract is deployed
117     constructor() public {
118         // We initiate the first player
119         uint pzfId = ponziFriends.push(PonziFriend(devAddress, 0, 1000000000000000000000000000, 0)) - 1;
120         ponziFriendsToId[msg.sender] = pzfId;
121     }
122 
123     // This will return the stats for a ponzi friend // returns(ponziFriendId, parent, amoutPlayed, amountEarned)
124     function getPonziFriend(address _addr) public view returns(uint, uint, uint256, uint256, uint, uint, uint) {
125         uint pzfId = ponziFriendsToId[_addr];
126         if(pzfId == 0) {
127             return(0, 0, 0, 0, 0, 0, 0);
128         } else {
129             return(pzfId, ponziFriends[pzfId].parent, ponziFriends[pzfId].amountPlayed, ponziFriends[pzfId].amountEarned, ponziFriendToLevel1Ref[pzfId], ponziFriendToLevel2Ref[pzfId], ponziFriendToLevel3Ref[pzfId]);
130         }
131     }
132 
133     // Return some general stats about the game // returns(friendsLength, amountPlayed, commissionsSent)
134     function getStats() public view returns(uint, uint256, uint256) {
135         return(ponziFriends.length, totalAmountPlayed, totalCommissionSent);
136     }
137 
138     // Add isHuman check for the newPonziFriend function (we want to avoid contract to participate in this experience)
139     modifier isHuman() {
140         address _addr = msg.sender;
141         uint256 _codeLength;
142         
143         assembly {_codeLength := extcodesize(_addr)}
144         require(_codeLength == 0, "sorry humans only");
145         _;
146     }
147 
148     
149 }