1 pragma solidity ^0.4.25;
2 
3 contract WWGPreLaunch {
4     
5     /**
6      * 
7      * WORLD WAR GOO (BETA LAUNCHING SOONISH)
8      * 
9      * PRELAUNCH EVENT CONTRACT FOR LIMITED CLANS & PREMIUM FACTORIES!
10      *
11      * FOR MORE DETAILS VISIT: 
12      * 
13      * https://ethergoo.io
14      * https://discord.gg/ajsz8tn
15      * 
16      */
17     
18     uint256 constant SUPPORTER_PACK_PRICE = 0.1 ether;
19     uint256 constant CRYPTO_CLAN_PRICE = 1 ether;
20     uint256 constant PREMIUM_FACTORY_PRICE = 0.5 ether;
21     uint256 constant GAS_LIMIT = 0.05 szabo; // 50 gwei
22     
23     uint256 public startTime = 1544832000; // Friday evening (00:00 UTC)
24     
25     uint256 clanIdStart; // Can release in waves
26     uint256 clanIdEnd;
27     uint256 factoryIdStart;
28     uint256 factoryIdEnd;
29     
30     address owner;
31     address holdee;
32     
33     mapping(address => bool) public supporters; // Public to grant access to beta & lootcrate etc.
34     mapping(uint256 => address) public factoryOwner; // Public to credit once minigame launched.
35     mapping(address => bool) private boughtFactory; // Limit 1 per player
36 
37     WWGClanCoupon clanCoupons = WWGClanCoupon(0xe9fe4e530ebae235877289bd978f207ae0c8bb25); // Redeemable for clan on launch
38     
39     constructor() public {
40         owner = msg.sender;
41         holdee = address(0xf6fF7aD69aF2F8655Ff1863BEc350093880e03E7);
42     }
43     
44     function buySupporterPack() payable external {
45         require(msg.value >= SUPPORTER_PACK_PRICE);
46         require(now >= startTime);
47         require(!supporters[msg.sender]); // Once only
48         
49         supporters[msg.sender] = true;
50         owner.transfer(SUPPORTER_PACK_PRICE);
51         
52         // Refund extra sent
53         if (msg.value > SUPPORTER_PACK_PRICE) {
54             msg.sender.transfer(msg.value - SUPPORTER_PACK_PRICE);
55         }
56     }
57     
58     function buyCryptoClan(uint256 clanId) payable external {
59         require(msg.value >= CRYPTO_CLAN_PRICE);
60         require(tx.gasprice <= GAS_LIMIT);
61         require(msg.sender == tx.origin);
62         require(now >= startTime);
63         require(validClanId(clanId));
64        
65         clanCoupons.mintClan(clanId, msg.sender);
66         holdee.transfer(CRYPTO_CLAN_PRICE);
67         
68         // Refund extra sent
69         if (msg.value > CRYPTO_CLAN_PRICE) {
70             msg.sender.transfer(msg.value - CRYPTO_CLAN_PRICE);
71         }
72     }
73     
74     function buyPremiumFactory(uint256 factoryId) payable external {
75         require(msg.value >= PREMIUM_FACTORY_PRICE);
76         require(tx.gasprice <= GAS_LIMIT);
77         require(msg.sender == tx.origin);
78         require(now >= startTime);
79         require(factoryOwner[factoryId] == address(0));
80         require(!boughtFactory[msg.sender]);
81         require(validFactoryId(factoryId));
82         
83         factoryOwner[factoryId] = msg.sender;
84         boughtFactory[msg.sender] = true;
85         holdee.transfer(PREMIUM_FACTORY_PRICE);
86         
87          // Refund extra sent
88         if (msg.value > PREMIUM_FACTORY_PRICE) {
89             msg.sender.transfer(msg.value - PREMIUM_FACTORY_PRICE);
90         }
91     }
92     
93     function validClanId(uint256 id) private view returns (bool) {
94         return (id > 0 && clanIdStart <= id && id <= clanIdEnd);
95     }
96     
97     function validFactoryId(uint256 id) private view returns (bool) {
98         return (id > 0 && factoryIdStart <= id && id <= factoryIdEnd);
99     }
100     
101     function getClanOwners() public view returns (address[]) {
102         if (clanIdEnd - clanIdStart == 0) {
103             return;
104         }
105         
106         uint256 size = 1 + clanIdEnd - clanIdStart;
107         address[] memory clanOwners = new address[](size);
108 
109         uint256 clanId = clanIdStart;
110         for (uint256 i = 0; i < size; i++) {
111             clanOwners[i] = clanCoupons.ownerOf(clanId);
112             clanId++;
113         }
114         return clanOwners;
115     }
116     
117     function getFactoryOwners() public view returns (address[]) {
118         if (factoryIdEnd - factoryIdStart == 0) {
119             return;
120         }
121         
122         uint256 size = 1 + factoryIdEnd - factoryIdStart;
123         address[] memory factoryOwners = new address[](size);
124 
125         uint256 factoryId = factoryIdStart;
126         for (uint256 i = 0; i < size; i++) {
127             factoryOwners[i] = address(factoryOwner[factoryId]);
128             factoryId++;
129         }
130         return factoryOwners;
131     }
132     
133     // Unlock the clans/factories, ready for timer
134     function setValidIds(uint256 clanStart, uint256 clanEnd, uint256 factoryStart, uint256 factoryEnd) external {
135         require(msg.sender == owner);
136         clanIdStart = clanStart;
137         clanIdEnd = clanEnd;
138         factoryIdStart = factoryStart;
139         factoryIdEnd = factoryEnd;
140     }
141 
142     // Just incase
143     function delay(uint256 newTime) external {
144         require(msg.sender == owner);
145         require(newTime >= startTime);
146         startTime = newTime;
147     }
148 }
149 
150 interface WWGClanCoupon {
151     function mintClan(uint256 clanId, address clanOwner) external;
152     function ownerOf(uint256 clanId) external view returns (address);
153 }