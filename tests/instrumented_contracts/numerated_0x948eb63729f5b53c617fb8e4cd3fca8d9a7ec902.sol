1 pragma solidity ^0.4.16;
2 
3 
4 contract ERC20 {
5     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6     function transfer(address to, uint256 tokens) public returns (bool success);
7 }
8 
9 
10 contract owned {
11     function owned() public { owner = msg.sender; }
12     address owner;
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 }
19 
20 
21 contract PublicSaleManager is owned {
22 
23     mapping (address => bool) _earlyList;
24     mapping (address => bool) _whiteList;
25     mapping (address => uint256) _bonus;
26     mapping (address => uint256) _contributedETH;
27 
28     address _tokenAddress = 0xAF815e887b039Fc06a8ddDcC7Ec4f57757616Cd2;
29     address _deadAddress = 0x000000000000000000000000000000000000dead;
30     uint256 _conversionRate = 0;
31     uint256 _startTime = 0;
32 
33     uint256 _totalSold = 0;
34     uint256 _totalBonus = 0;
35 
36     uint256 _regularPersonalCap = 1e20; // 100 ETH
37     uint256 _higherPersonalCap = 2e20; // 200 ETH
38     uint256 _minimumAmount = 2e17; // 0.2 ETH
39 
40     bool _is_stopped = false;
41 
42     function addWhitelist(address[] addressList) public onlyOwner {
43         // Whitelist is managed manually and addresses are added in batch.
44         for (uint i = 0; i < addressList.length; i++) {
45             _whiteList[addressList[i]] = true;
46         }
47     }
48     
49     function addEarlylist(address[] addressList) public onlyOwner {
50         // Whitelist is managed manually and addresses are added in batch.
51         for (uint i = 0; i < addressList.length; i++) {
52             _earlyList[addressList[i]] = true;
53         }
54     }
55 
56     function start(uint32 conversionRate) public onlyOwner {
57         require(_startTime == 0);
58         require(conversionRate > 1);
59 
60         // Starts the public sale.
61         _startTime = now;
62 
63         // Sets the conversion rate.
64         _conversionRate = conversionRate;
65     }
66 
67     function stop() public onlyOwner {
68         _is_stopped = true;
69     }
70 
71     function burnUnsold() public onlyOwner {
72         require(now >= _startTime + (31 days));
73 
74         // Transfers all un-sold tokens to 0x000...dead.
75         ERC20(_tokenAddress).transfer(_deadAddress, ERC20(_tokenAddress).balanceOf(this) - _totalBonus);
76     }
77 
78     function withdrawEther(address toAddress, uint256 amount) public onlyOwner {
79         toAddress.transfer(amount);
80     }
81 
82     function buyTokens() payable public {
83         require(_is_stopped == false);
84 
85         // Validates whitelist.
86         require(_whiteList[msg.sender] == true || _earlyList[msg.sender] == true);
87 
88         if (_earlyList[msg.sender]) {
89             require(msg.value + _contributedETH[msg.sender] <= _higherPersonalCap);
90         } else {
91             require(msg.value + _contributedETH[msg.sender] <= _regularPersonalCap);
92         }
93 
94         require(msg.value >= _minimumAmount);
95 
96         // Validates time.
97         require(now > _startTime);
98         require(now < _startTime + (31 days));
99 
100         // Calculates the purchase amount.
101         uint256 purchaseAmount = msg.value * _conversionRate;
102         require(_conversionRate > 0 && purchaseAmount / _conversionRate == msg.value);
103 
104         // Calculates the bonus amount.
105         uint256 bonus = 0;
106         if (_totalSold + purchaseAmount < 5e26) {
107             // 10% bonus for the first 500 million OGT.
108             bonus = purchaseAmount / 10;
109         } else if (_totalSold + purchaseAmount < 10e26) {
110             // 5% bonus for the first 1 billion OGT.
111             bonus = purchaseAmount / 20;
112         }
113 
114         // Checks that we still have enough balance.
115         require(ERC20(_tokenAddress).balanceOf(this) >= _totalBonus + purchaseAmount + bonus);
116 
117         // Transfers the non-bonus part.
118         ERC20(_tokenAddress).transfer(msg.sender, purchaseAmount);
119         _contributedETH[msg.sender] += msg.value;
120 
121         // Records the bonus.
122         _bonus[msg.sender] += bonus;
123 
124         _totalBonus += bonus;
125         _totalSold += (purchaseAmount + bonus);
126     }
127 
128     function claimBonus() public {
129         // Validates whitelist.
130         require(_whiteList[msg.sender] == true || _earlyList[msg.sender] == true);
131         
132         // Validates bonus.
133         require(_bonus[msg.sender] > 0);
134 
135         // Transfers the bonus if it's after 90 days.
136         if (now > _startTime + (90 days)) {
137             ERC20(_tokenAddress).transfer(msg.sender, _bonus[msg.sender]);
138             _bonus[msg.sender] = 0;
139         }
140     }
141 
142     function checkBonus(address purchaser) public constant returns (uint256 balance) {
143         return _bonus[purchaser];
144     }
145 
146     function checkTotalSold() public constant returns (uint256 balance) {
147         return _totalSold;
148     }
149 
150     function checkContributedETH(address purchaser) public constant returns (uint256 balance) {
151         return _contributedETH[purchaser];
152     }
153 
154     function checkPersonalRemaining(address purchaser) public constant returns (uint256 balance) {
155         if (_earlyList[purchaser]) {
156             return _higherPersonalCap - _contributedETH[purchaser];
157         } else if (_whiteList[purchaser]) {
158             return _regularPersonalCap - _contributedETH[purchaser];
159         } else {
160             return 0;
161         }
162     }
163 }