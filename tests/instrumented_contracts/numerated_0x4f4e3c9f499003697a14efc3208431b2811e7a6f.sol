1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4   address owner;
5 
6   function Owned() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwner(address newOwner) public onlyOwner {
16     if (newOwner != address(0)) {
17       owner = newOwner;
18     }
19   }
20 
21   function getOwner() public view returns (address) {
22     return owner;
23   }
24 }
25 
26 contract HolyPiggyStorage {
27   struct Wish {
28     bytes name;
29     bytes content;
30     uint256 time;
31     uint256 tribute;
32   }
33   Wish[] wishes;
34   mapping(address => uint256[]) wishesIdx;
35 
36   address godAddress;
37   address serviceProvider;
38   uint256 serviceFeeNumerator;
39   uint256 serviceFeeDenominator;
40   uint256 minimumWishTribute;
41   uint256 accumulatedServiceFee;
42 }
43 
44 contract HolyPiggy is HolyPiggyStorage, Owned {
45   function() public payable {}
46 
47   function HolyPiggy(address god) public {
48     godAddress = god;
49     serviceFeeNumerator = 1;
50     serviceFeeDenominator = 50;
51     minimumWishTribute = 0;
52   }
53 
54   function getGodAddress() external view returns (address) {
55     return godAddress;
56   }
57 
58   event PostWish(address addr, uint256 id, bytes name, bytes content, uint256 time, uint256 tribute);
59 
60   function setServiceProvider(address addr) public onlyOwner {
61     serviceProvider = addr;
62   }
63 
64   function getServiceProvider() external view returns (address) {
65     return serviceProvider;
66   }
67 
68   function setServiceFee(uint256 n, uint256 d) public onlyServiceProvider {
69     serviceFeeNumerator = n;
70     serviceFeeDenominator = d;
71   }
72 
73   function getAccumulatedServiceFee() external view returns (uint256) {
74     return accumulatedServiceFee;
75   }
76 
77   function getServiceFeeNumerator() external view returns (uint256) {
78     return serviceFeeNumerator;
79   }
80 
81   function getServiceFeeDenominator() external view returns (uint256) {
82     return serviceFeeDenominator;
83   }
84 
85   function getMinimumWishTribute() external view returns (uint256) {
86     return minimumWishTribute;
87   }
88 
89   function setMinimumWishTribute(uint256 tribute) public onlyOwner {
90     minimumWishTribute = tribute;
91   }
92 
93   modifier onlyServiceProvider() {
94     require(msg.sender == serviceProvider);
95     _;
96   }
97 
98   function withdrawServiceFee() public onlyServiceProvider {
99     uint256 fee = accumulatedServiceFee;
100     accumulatedServiceFee = 0;
101     serviceProvider.transfer(fee);
102   }
103 
104   function postWish(bytes name, bytes content) public payable {
105     require(msg.value > 0);
106     require(serviceProvider != address(0));
107     // (1+n/d)t = v  solve for n/d*t, which is the fee
108     // t = d/(n+d)*v
109     // fee = n/(n+d)*v
110     uint256 serviceFee = msg.value * serviceFeeNumerator / (serviceFeeDenominator + serviceFeeNumerator);
111     uint256 tribute = msg.value - serviceFee;
112     require(tribute > minimumWishTribute);
113     assert(accumulatedServiceFee + serviceFee > accumulatedServiceFee);
114     
115     uint256 id = wishes.length;
116     var wish = Wish(name, content, now, tribute);
117     wishes.push(wish);
118     wishesIdx[msg.sender].push(id);
119     accumulatedServiceFee = accumulatedServiceFee + serviceFee;
120     godAddress.transfer(tribute);
121 
122     PostWish(msg.sender, id, name, content, now, tribute);
123   }
124 
125   function countWishes() external view returns (uint256) {
126     return wishes.length;
127   }
128 
129   function getWishName(uint256 idx) external view returns (bytes) {
130     return wishes[idx].name;
131   }
132 
133   function getWishContent(uint256 idx) external view returns (bytes) {
134     return wishes[idx].content;
135   }
136   
137   function getWishTime(uint256 idx) external view returns (uint256) {
138     return wishes[idx].time;
139   }
140 
141   function getWishTribute(uint256 idx) external view returns (uint256) {
142     return wishes[idx].tribute;
143   }
144 
145   function getWishIdxesAt(address addr) external view returns (uint256[]) {
146     return wishesIdx[addr];
147   }
148 
149   function getWishIdxAt(address addr, uint256 pos) external view returns (uint256) {
150     return wishesIdx[addr][pos];
151   }
152 
153   function countWishesAt(address addr) external view returns (uint256) {
154     return wishesIdx[addr].length;
155   }
156 }