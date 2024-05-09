1 pragma solidity ^0.4.18;
2 
3 contract ETHMap {
4 
5     /// Initial price zone (= LUX)
6     /// set at 0.001 Eth
7     uint initialZonePrice = 1000000000000000 wei;
8 
9     /// contractOwner address
10     address contractOwner;
11 
12     /// Users pending withdrawals
13     mapping(address => uint) pendingWithdrawals;
14 
15     /// Zone structures mapping
16     mapping(uint => Zone) zoneStructs;
17     uint[] zoneList;
18 
19     struct Zone {
20         uint id;
21         address owner;
22         uint sellPrice;
23     }
24 
25     /// Constructor
26     function ETHMap() public {
27       contractOwner = msg.sender;
28     }
29 
30     modifier onlyContractOwner()
31     {
32        // Throws if called by any account other than the contract owner
33         require(msg.sender == contractOwner);
34         _;
35     }
36 
37     modifier onlyValidZone(uint zoneId)
38     {
39        // Throws if zone id is not valid
40         require(zoneId >= 1 && zoneId <= 178);
41         _;
42     }
43 
44     modifier onlyZoneOwner(uint zoneId)
45     {
46        // Throws if called by any account other than the zone owner
47         require(msg.sender == zoneStructs[zoneId].owner);
48         _;
49     }
50 
51     function buyZone(uint zoneId) public
52       onlyValidZone(zoneId)
53       payable
54     returns (bool success)
55     {
56         // Throw if zone is not on sale
57         if (zoneStructs[zoneId].owner != address(0)) {
58           require(zoneStructs[zoneId].sellPrice != 0);
59         }
60         // Throw if amount sent is not sufficient
61         uint minPrice = (zoneStructs[zoneId].owner == address(0)) ? computeInitialPrice(zoneId) : zoneStructs[zoneId].sellPrice;
62         require(msg.value >= minPrice);
63         // If initial sale
64         if (zoneStructs[zoneId].owner == address(0)) {
65             // No current owners, credit contract owner balance
66             pendingWithdrawals[contractOwner] += msg.value;
67             // Init zone
68             zoneStructs[zoneId].id = zoneId;
69         } else {
70           // Contract owner take 2% cut on transaction
71           uint256 contractOwnerCut = (msg.value * 200) / 10000;
72           uint256 ownersShare = msg.value - contractOwnerCut;
73           // Credit contract owner
74           pendingWithdrawals[contractOwner] += contractOwnerCut;
75           // Credit zone owner
76           address ownerAddress = zoneStructs[zoneId].owner;
77           pendingWithdrawals[ownerAddress] += ownersShare;
78         }
79 
80         zoneStructs[zoneId].owner = msg.sender;
81         zoneStructs[zoneId].sellPrice = 0;
82         return true;
83     }
84 
85     /// Allow owner to sell his zone
86     function sellZone(uint zoneId, uint amount) public
87         onlyValidZone(zoneId)
88         onlyZoneOwner(zoneId)
89         returns (bool success) 
90     {
91         zoneStructs[zoneId].sellPrice = amount;
92         return true;
93     }
94 
95     /// Allow owner to transfer his zone
96     function transferZone(uint zoneId, address recipient) public
97         onlyValidZone(zoneId)
98         onlyZoneOwner(zoneId)
99         returns (bool success) 
100     {
101         zoneStructs[zoneId].owner = recipient;
102         return true;
103     }
104 
105     /// Compute initial zone price
106     function computeInitialPrice(uint zoneId) public view
107         onlyValidZone(zoneId)
108         returns (uint price)
109     {
110         return initialZonePrice + ((zoneId - 1) * (initialZonePrice / 2));
111     }
112 
113     /// Return zone details
114     function getZone(uint zoneId) public constant
115         onlyValidZone(zoneId)
116         returns(uint id, address owner, uint sellPrice)
117     {
118         return (
119           zoneStructs[zoneId].id,
120           zoneStructs[zoneId].owner,
121           zoneStructs[zoneId].sellPrice
122         );
123     }
124 
125     /// Return balance from sender
126     function getBalance() public view
127       returns (uint amount)
128     {
129         return pendingWithdrawals[msg.sender];
130     }
131 
132     /// Allow address to withdraw their balance
133     function withdraw() public
134         returns (bool success) 
135     {
136         uint amount = pendingWithdrawals[msg.sender];
137         pendingWithdrawals[msg.sender] = 0;
138         msg.sender.transfer(amount);
139         return true;
140     }
141 
142     /// Allow contract owner to change address
143     function transferContractOwnership(address newOwner) public
144         onlyContractOwner()
145         returns (bool success) 
146     {
147         contractOwner = newOwner;
148         return true;
149     }
150 
151 }