1 pragma solidity ^0.4.24;
2 
3 contract EthCalendar {
4     // Initial price of a day is 0.003 ETH
5     uint256 constant initialDayPrice = 3000000000000000 wei;
6 
7     // Address of the contract owner
8     address contractOwner;
9 
10     // Mapping of addresses to the pending withdrawal amount
11     mapping(address => uint256) pendingWithdrawals;
12 
13     // Mapping of day ids to their structs
14     mapping(uint16 => Day) dayStructs;
15 
16     // Fired when a day was bought
17     event DayBought(uint16 dayId);
18 
19     // Holds all information about a day
20     struct Day {
21         address owner;
22         string message;
23         uint256 sellprice;
24         uint256 buyprice;
25     }
26 
27     // Set contract owner on deploy
28     constructor() public {
29         contractOwner = msg.sender;
30     }
31 
32     // Ensures sender is the contract owner
33     modifier onlyContractOwner() {
34         require(msg.sender == contractOwner, "sender must be contract owner");
35         _;
36     }
37 
38     // Ensures dayid is in valid range
39     modifier onlyValidDay (uint16 dayId) {
40         require(dayId >= 0 && dayId <= 365, "day id must be between 0 and 365");
41         _;
42     }
43 
44     // Ensures sender is the owner of a specific day
45     modifier onlyDayOwner(uint16 dayId) {
46         require(msg.sender == dayStructs[dayId].owner, "sender must be owner of day");
47         _;
48     }
49 
50     // Ensures sender is not the owner of a specific day
51     modifier notDayOwner(uint16 dayId) {
52         require(msg.sender != dayStructs[dayId].owner, "sender can't be owner of day");
53         _;
54     }
55 
56     // Ensures message is of a valid length
57     modifier onlyValidMessage(string message) {
58         require(bytes(message).length > 0, "message has to be set");
59         _;
60     }
61 
62     // Ensures the updated sellprice is below the here defined moving maximum.
63     // The maximum is oriented to the price the day is bought.
64     // Into baseprice the buyprice needs to be passed. This could be either msg.value or a stored value from previous tx.
65     modifier onlyValidSellprice(uint256 sellprice, uint256 baseprice) {
66         // Set the moving maximum to twice the paid amount
67         require(sellprice > 0 && sellprice <= baseprice * 2, "new sell price must be lower than or equal to twice the paid price");
68         _;
69     }
70 
71     // Ensures the transfered value of the tx is large enough to pay for a specific day
72     modifier onlySufficientPayment(uint16 dayId) {
73         // The current price needs to be covered by the sent amount.
74         // It is possible to pay more than needed.
75         require(msg.value >= getCurrentPrice(dayId), "tx value must be greater than or equal to price of day");
76         _;
77     }
78 
79     // Any address can buy a day for the specified minimum price.
80     // A sell price and a message need to be specified in this call.
81     // The new sell price has a maximum of twice the paid amount.
82     // A day can be bought for more than the specified sell price. So the maximum new sell price can be arbitrary high.
83     function buyDay(uint16 dayId, uint256 sellprice, string message) public payable
84         onlyValidDay(dayId)
85         notDayOwner(dayId)
86         onlyValidMessage(message)
87         onlySufficientPayment(dayId)
88         onlyValidSellprice(sellprice, msg.value) {
89 
90         if (hasOwner(dayId)) {
91             // Day already has an owner
92             // Contract owner takes 2% cut on transaction
93             uint256 contractOwnerCut = (msg.value * 200) / 10000;
94             uint256 dayOwnerShare = msg.value - contractOwnerCut;
95 
96             // Credit contract owner and day owner their shares
97             pendingWithdrawals[contractOwner] += contractOwnerCut;
98             pendingWithdrawals[dayStructs[dayId].owner] += dayOwnerShare;
99         } else {
100             // Day has no owner yet.
101             // Contract owner gets credited the initial transaction
102             pendingWithdrawals[contractOwner] += msg.value;
103         }
104 
105         // Update the data of the day bought
106         dayStructs[dayId].owner = msg.sender;
107         dayStructs[dayId].message = message;
108         dayStructs[dayId].sellprice = sellprice;
109         dayStructs[dayId].buyprice = msg.value;
110 
111         emit DayBought(dayId);
112     }
113 
114     // Owner can change price of his days
115     function changePrice(uint16 dayId, uint256 sellprice) public
116         onlyValidDay(dayId)
117         onlyDayOwner(dayId)
118         onlyValidSellprice(sellprice, dayStructs[dayId].buyprice) {
119         dayStructs[dayId].sellprice = sellprice;
120     }
121 
122     // Owner can change personal message of his days
123     function changeMessage(uint16 dayId, string message) public
124         onlyValidDay(dayId)
125         onlyDayOwner(dayId)
126         onlyValidMessage(message) {
127         dayStructs[dayId].message = message;
128     }
129 
130     // Owner can tranfer his day to another address
131     function transferDay(uint16 dayId, address recipient) public
132         onlyValidDay(dayId)
133         onlyDayOwner(dayId) {
134         dayStructs[dayId].owner = recipient;
135     }
136 
137     // Returns day details
138     function getDay (uint16 dayId) public view
139         onlyValidDay(dayId)
140     returns (uint16 id, address owner, string message, uint256 sellprice, uint256 buyprice) {
141         return(  
142             dayId,
143             dayStructs[dayId].owner,
144             dayStructs[dayId].message,
145             getCurrentPrice(dayId),
146             dayStructs[dayId].buyprice
147         );    
148     }
149 
150     // Returns the senders balance
151     function getBalance() public view
152     returns (uint256 amount) {
153         return pendingWithdrawals[msg.sender];
154     }
155 
156     // User can withdraw his balance
157     function withdraw() public {
158         uint256 amount = pendingWithdrawals[msg.sender];
159         pendingWithdrawals[msg.sender] = 0;
160         msg.sender.transfer(amount);
161     }
162 
163     // Returns whether or not the day is already bought
164     function hasOwner(uint16 dayId) private view
165     returns (bool dayHasOwner) {
166         return dayStructs[dayId].owner != address(0);
167     }
168 
169     // Returns the price the day currently can be bought for
170     function getCurrentPrice(uint16 dayId) private view
171     returns (uint256 currentPrice) {
172         return hasOwner(dayId) ?
173             dayStructs[dayId].sellprice :
174             initialDayPrice;
175     }
176 }