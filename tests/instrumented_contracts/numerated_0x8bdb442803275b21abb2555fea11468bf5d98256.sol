1 pragma solidity >=0.5.0;
2 
3 library UintSafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract BMToken
31 {
32     function allowance(address src, address where) public pure returns (uint256);
33     function transferFrom(address src, address where, uint amount) public returns (bool);
34     function transfer(address where, uint amount) external returns (bool);
35 }
36 
37 contract BMT_Exchange {
38     using UintSafeMath for uint256;
39 
40     BMToken contractTokens;
41     address payable public owner;
42 
43     uint256 public tokenPrice;
44     uint256 public totalSupplay;
45     uint256 public ethPart;
46 
47     mapping(address => uint256) public Holders;
48     mapping(address => uint256) public lastAccess;
49     uint256 lastUpdate;
50 
51     uint256 constant distributionInterval = 5 days;
52 
53     constructor() public {
54         contractTokens = BMToken(0xf028ADEe51533b1B47BEaa890fEb54a457f51E89);
55 
56         owner = msg.sender;
57 
58         tokenPrice = 0.0000765 ether;
59         totalSupplay = 0;
60         ethPart = 0 ether;
61     }
62 
63     modifier isOwner()
64     {
65         assert(msg.sender == owner);
66         _;
67     }
68 
69     function changeOwner(address payable new_owner) isOwner public {
70         assert(new_owner != owner);
71         assert(new_owner != address(0x0));
72 
73         owner = new_owner;
74     }
75 
76     // DO NOT SEND TOKENS TO CONTRACT - USE "APPROVE" FUNCTION
77     function transferTokens(uint256 _value) isOwner public{
78         contractTokens.transfer(owner, _value);
79     }
80 
81     function setTokenPrice(uint256 new_price) isOwner public {
82         assert(new_price > 0);
83 
84         tokenPrice = new_price;
85     }
86 
87     function updateHolder(address[] calldata _holders, uint256[] calldata _amounts) isOwner external {
88         assert(_holders.length == _amounts.length);
89 
90         for(uint256 i = 0; i < _holders.length; i++){
91             Holders[_holders[i]] = Holders[_holders[i]].add(_amounts[i]);
92             totalSupplay = totalSupplay.add(_amounts[i]);
93         }
94 
95         updateTokenDistribution();
96     }
97 
98     function deposit() isOwner payable public {
99         assert(msg.value > 0);
100         updateTokenDistribution();
101     }
102 
103     function withdraw(uint256 amount) isOwner public {
104         assert(address(this).balance >= amount);
105 
106         address(owner).transfer(amount);
107         updateTokenDistribution();
108 
109     }
110     function updateTokenDistribution() internal {
111         if (totalSupplay > 0) {
112             ethPart = address(this).balance.mul(10**18).div(totalSupplay);
113             lastUpdate = now;
114         }
115     }
116 
117     function secondsLeft(address addr) view public returns (uint256) {
118         if (now < lastAccess[addr]) return 0;
119         return now - lastAccess[addr];
120     }
121 
122     function calculateAmounts(address addr) view public returns (uint256 tokenAmount, uint256 ethReturn) {
123         assert(Holders[addr] > 0);
124         assert(now - lastAccess[addr] > distributionInterval);
125 
126         tokenAmount = ethPart.mul(Holders[addr]).div(tokenPrice).div(10**18).mul(10**18); // +round
127         assert(tokenAmount > 0);
128         assert(contractTokens.allowance(addr, address(this)) >= tokenAmount);
129         ethReturn = tokenAmount.mul(tokenPrice).div(10**18);
130     }
131 
132     function () external {
133         if (now - lastUpdate > distributionInterval) updateTokenDistribution();
134         assert(tx.origin == msg.sender);
135 
136         assert(Holders[msg.sender] > 0);
137         assert(now - lastAccess[msg.sender] > distributionInterval);
138 
139         uint256 tokenAmount;
140         uint256 ethReturn;
141         (tokenAmount, ethReturn) = calculateAmounts(msg.sender);
142 
143         contractTokens.transferFrom(msg.sender, owner, tokenAmount);
144         msg.sender.transfer(ethReturn);
145 
146         Holders[msg.sender] = Holders[msg.sender].sub(tokenAmount);
147         totalSupplay = totalSupplay.sub(tokenAmount);
148         lastAccess[msg.sender] = now;
149     }
150 }