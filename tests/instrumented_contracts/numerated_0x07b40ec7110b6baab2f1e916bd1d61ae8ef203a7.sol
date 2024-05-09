1 pragma solidity ^0.4.17;
2 
3 contract CryptoRoses {
4   address constant DESTINATION_ADDRESS = 0x19Ed10db2960B9B21283FdFDe464e7bF3a87D05D;
5   address owner;
6   bytes32 name;
7 
8   enum Rose { Gold, White, Pink, Red }
9 
10   struct RoseOwner {
11       bool hasRose;
12       Rose roseType;
13       string memo;
14   }
15 
16   mapping (bytes32 => RoseOwner) roseOwners;
17   mapping (address => bool) addrWhitelist;
18 
19   function CryptoRoses(bytes32 _name) public {
20       owner = msg.sender;
21       name = _name;
22   }
23 
24   function addAddWhitelist(address s) public {      
25       require(msg.sender == owner);
26 
27       addrWhitelist[s] = true;
28   }
29 
30   // 0.25 ETH (250000000000000000 wei) for a Gold Rose
31   // 50 Garlicoin for a Gold Rose
32 
33   // 0.05 ETH (50000000000000000 wei) for a White Rose
34   // 10 Garlicoin for a White Rose
35 
36   // 0.02 ETH (20000000000000000 wei) for a Pink rose
37   // 4 Garlicoin for a Pink Rose
38 
39   // 0.01 ETH (10000000000000000 wei) for a Red Rose
40   // 2 Garlicoin for a Red Rose
41 
42   uint constant ETH_GOLD_ROSE_PRICE = 250000000000000000;
43   uint constant ETH_WHITE_ROSE_PRICE = 50000000000000000;
44   uint constant ETH_PINK_ROSE_PRICE = 20000000000000000;
45   uint constant ETH_RED_ROSE_PRICE = 10000000000000000;
46 
47   // Buy Rose with ETH
48   function buyRoseETH(string memo) public payable {
49       uint amntSent = msg.value;
50       address sender = msg.sender;
51       bytes32 senderHash = keccak256(sender);
52 
53       Rose roseType;
54 
55       // Assign rose 
56       if (amntSent >= ETH_GOLD_ROSE_PRICE) {
57           roseType = Rose.Gold;
58       } else if (amntSent >= ETH_WHITE_ROSE_PRICE) {
59           roseType = Rose.White;
60       } else if (amntSent >= ETH_PINK_ROSE_PRICE) {
61           roseType = Rose.Pink;
62       } else if (amntSent >= ETH_RED_ROSE_PRICE) {
63           roseType = Rose.Pink;
64       } else {
65           sender.transfer(amntSent);
66           return;
67       }
68 
69       // No double buying roses
70       if (roseOwners[senderHash].hasRose) {
71           sender.transfer(amntSent);
72           return;
73       }
74 
75       roseOwners[senderHash].hasRose = true;
76       roseOwners[senderHash].roseType = roseType;
77       roseOwners[senderHash].memo = memo;
78 
79       DESTINATION_ADDRESS.transfer(amntSent);
80   }
81 
82   uint constant GRLC_GOLD_ROSE_PRICE = 50;
83   uint constant GRLC_WHITE_ROSE_PRICE = 10;
84   uint constant GRLC_PINK_ROSE_PRICE = 4;
85   uint constant GRLC_RED_ROSE_PRICE = 2;
86 
87   function buyRoseGRLC(bytes32 gaddrHash, string memo, uint amntSent) public {
88       // Only a trusted oracle can call this function
89       require(addrWhitelist[msg.sender] || owner == msg.sender);
90 
91       Rose roseType;
92 
93       // Assign rose 
94       if (amntSent >= GRLC_GOLD_ROSE_PRICE) {
95           roseType = Rose.Gold;
96       } else if (amntSent >= GRLC_WHITE_ROSE_PRICE) {
97           roseType = Rose.White;
98       } else if (amntSent >= GRLC_PINK_ROSE_PRICE) {
99           roseType = Rose.Pink;
100       } else if (amntSent >= GRLC_RED_ROSE_PRICE) {
101           roseType = Rose.Pink;
102       } else {          
103           return;
104       }
105 
106       // No double buying roses
107       if (roseOwners[gaddrHash].hasRose) {          
108           return;
109       }
110 
111       roseOwners[gaddrHash].hasRose = true;
112       roseOwners[gaddrHash].roseType = roseType;
113       roseOwners[gaddrHash].memo = memo;
114   }
115 
116   // No refunds fam soz not soz
117   function checkRose(bytes32 h) public constant returns (bool, uint, string) {
118       return (roseOwners[h].hasRose, uint(roseOwners[h].roseType), roseOwners[h].memo);
119   }
120 }