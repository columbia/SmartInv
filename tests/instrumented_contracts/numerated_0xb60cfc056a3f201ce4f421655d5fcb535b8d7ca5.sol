1 pragma solidity ^0.4.24;
2 
3 contract SimpleBanners {
4 
5     struct BannerOwnerStruct {
6         address owner;
7         uint balance;
8         uint bidAmountPerDay;
9         bytes32 dataCID;
10         uint timestampTaken;
11     }
12 
13     address owner;
14     BannerOwnerStruct[2] banners;
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     event BannerUpdate();
21 
22     function takeBanner(uint bannerId, uint bidAmountPerDay, bytes32 dataCID) public payable {
23 
24         if (msg.value == 0)
25             revert("Requires some ETH");
26 
27         if (bidAmountPerDay < 10000000000000 wei) // 0.00001 ETH / 0.003 usd / 0.3 of a cent
28             revert("bid amount is below minimum");
29 
30         // calculate total charge amount
31         uint totalCost = calculateTotalCost(bannerId);
32         uint totalValueRemaining = banners[bannerId].balance - totalCost;
33 
34         // compare the total value of new bid vs calculated remaining value of current bid
35         if (msg.value <= totalValueRemaining) {
36             // if the bid is double the active price and has enough funds for 1 week then allow it to replace
37             if (bidAmountPerDay < banners[bannerId].bidAmountPerDay * 2)
38                 revert("amount needs to be double existing bid");
39             
40             if (msg.value < bidAmountPerDay * 7)
41                 revert("requires at least 7 days to replace existing bid");
42         }            
43 
44         // new banner bid is good to go, charge previous account and send them any refunds
45         owner.transfer(totalCost);
46         banners[bannerId].owner.transfer(totalValueRemaining);
47 
48         banners[bannerId].owner = msg.sender;
49         banners[bannerId].balance = msg.value;
50         banners[bannerId].bidAmountPerDay = bidAmountPerDay;
51         banners[bannerId].dataCID = dataCID;
52         banners[bannerId].timestampTaken = block.timestamp;
53 
54         emit BannerUpdate();
55     }
56 
57     function updateBannerContent(uint bannerId, bytes32 dataCID) public {
58         if (banners[bannerId].owner != msg.sender)
59             revert("Not owner");
60 
61         banners[bannerId].dataCID = dataCID;
62         emit BannerUpdate();
63     }
64 
65     function addFunds(uint bannerId) public payable{
66         if (banners[bannerId].owner != msg.sender)
67             revert("Not owner");
68 
69         uint totalCost = calculateTotalCost(bannerId);
70         if (totalCost >= banners[bannerId].balance) {
71             // the funds have all been used up, take the balance
72             owner.transfer(banners[bannerId].balance);
73             banners[bannerId].timestampTaken = block.timestamp;
74             banners[bannerId].balance = msg.value;
75             emit BannerUpdate();
76         } else {
77             banners[bannerId].balance += msg.value;
78         }        
79     }
80 
81     /************************************************************************************
82     *** VIEW FUNCTIONS
83     ************************************************************************************/
84     function getBannerDetails(uint bannerId) public view returns (address, uint, uint, bytes32, uint) {
85         return (
86             banners[bannerId].owner,
87             banners[bannerId].balance,
88             banners[bannerId].bidAmountPerDay,
89             banners[bannerId].dataCID,
90             banners[bannerId].timestampTaken
91         );
92     }
93 
94     function getRemainingBalance(uint bannerId) public view returns (uint remainingBalance) {
95         uint totalCost = calculateTotalCost(bannerId);
96         return banners[bannerId].balance - totalCost;
97     }
98 
99     function calculateTotalCost(uint bannerId) internal view returns (uint) {
100         // calculate total seconds passed, and times that by our daily rate on a seconds basis
101         uint totalSecondsPassed = block.timestamp - banners[bannerId].timestampTaken;
102         uint totalCost = totalSecondsPassed * (banners[bannerId].bidAmountPerDay / 1 days);
103 
104         // total cost cant be more than balance
105         if (totalCost > banners[bannerId].balance)
106             totalCost = banners[bannerId].balance;
107 
108         return totalCost;
109     }
110 
111     function getActiveBanners() public view returns (bytes32, bytes32) {
112         bytes32 b1;
113         bytes32 b2;
114 
115         uint tCost = calculateTotalCost(0);
116         if (tCost >= banners[0].balance)
117             b1 = 0x00;
118         else
119             b1 = banners[0].dataCID;
120 
121         tCost = calculateTotalCost(1);
122         if (tCost >= banners[1].balance)
123             b2 = 0x00;
124         else
125             b2 = banners[1].dataCID;
126 
127         return (b1, b2);
128     }
129 
130     /************************************************************************************
131     *** ADMIN FUNCTIONS
132     ************************************************************************************/
133     function updateOwner(address newOwner) public {
134         if (msg.sender != owner)
135             revert("Not the owner");
136 
137         owner = newOwner;
138     }
139 
140     function emergencyWithdraw() public {
141         if (msg.sender != owner)
142             revert("Not the owner");
143 
144         owner.transfer(address(this).balance);
145     }
146 
147     function rejectBanner(uint bannerId) public {
148         if (msg.sender != owner)
149             revert("Not the owner");
150 
151         // settle costs
152         uint totalCost = calculateTotalCost(bannerId);
153         owner.transfer(totalCost);
154         banners[bannerId].owner.transfer(banners[bannerId].balance - totalCost);
155 
156         delete banners[bannerId];
157 
158         emit BannerUpdate();
159     }
160 }