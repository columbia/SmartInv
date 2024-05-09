1 pragma solidity ^0.4.16;
2 
3 interface Token {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 contract CMDCrowdsale {
8     
9     Token public tokenReward;
10     address public creator;
11     address public owner = 0x16F4b9b85Ed28F11D0b7b52B7ad48eFe217E0D48;
12 
13     uint256 private tokenSold;
14     uint256 public price;
15 
16     modifier isCreator() {
17         require(msg.sender == creator);
18         _;
19     }
20 
21     event FundTransfer(address backer, uint amount, bool isContribution);
22 
23     function CMDCrowdsale() public {
24         creator = msg.sender;
25         tokenReward = Token(0xf04eAba18e56ECA6be0f29f09082f62D3865782a);
26         price = 2000;
27     }
28 
29     function setOwner(address _owner) isCreator public {
30         owner = _owner;      
31     }
32 
33     function setCreator(address _creator) isCreator public {
34         creator = _creator;      
35     }
36 
37     function setPrice(uint256 _price) isCreator public {
38         price = _price;      
39     }
40 
41     function setToken(address _token) isCreator public {
42         tokenReward = Token(_token);      
43     }
44 
45     function sendToken(address _to, uint256 _value) isCreator public {
46         tokenReward.transfer(_to, _value);      
47     }
48 
49     function kill() isCreator public {
50         selfdestruct(owner);
51     }
52 
53     function () payable public {
54         require(msg.value > 0);
55         uint256 amount;
56         uint256 bonus;
57         
58         // Private Sale
59         if (now > 1522018800 && now < 1523228400 && tokenSold < 42000001) {
60             amount = msg.value * price;
61             amount += amount / 3;
62         }
63 
64         // Pre-Sale
65         if (now > 1523228399 && now < 1525388400 && tokenSold > 42000000 && tokenSold < 84000001) {
66             amount = msg.value * price;
67             amount += amount / 5;
68         }
69 
70         // Public ICO
71         if (now > 1525388399 && now < 1530399600 && tokenSold > 84000001 && tokenSold < 140000001) {
72             amount = msg.value * price;
73             bonus = amount / 100;
74 
75             if (now < 1525388399 + 1 days) {
76                 amount += bonus * 15;
77             }
78 
79             if (now > 1525388399 + 1 days && now < 1525388399 + 2 days) {
80                 amount += bonus * 14;
81             }
82 
83             if (now > 1525388399 + 2 days && now < 1525388399 + 3 days) {
84                 amount += bonus * 13;
85             }
86 
87             if (now > 1525388399 + 3 days && now < 1525388399 + 4 days) {
88                 amount += bonus * 12;
89             }
90 
91             if (now > 1525388399 + 4 days && now < 1525388399 + 5 days) {
92                 amount += bonus * 11;
93             }
94 
95             if (now > 1525388399 + 5 days && now < 1525388399 + 6 days) {
96                 amount += bonus * 10;
97             }
98 
99             if (now > 1525388399 + 6 days && now < 1525388399 + 7 days) {
100                 amount += bonus * 9;
101             }
102 
103             if (now > 1525388399 + 7 days && now < 1525388399 + 8 days) {
104                 amount += bonus * 8;
105             }
106 
107             if (now > 1525388399 + 8 days && now < 1525388399 + 9 days) {
108                 amount += bonus * 7;
109             }
110 
111             if (now > 1525388399 + 9 days && now < 1525388399 + 10 days) {
112                 amount += bonus * 6;
113             }
114 
115             if (now > 1525388399 + 10 days && now < 1525388399 + 11 days) {
116                 amount += bonus * 5;
117             }
118 
119             if (now > 1525388399 + 11 days && now < 1525388399 + 12 days) {
120                 amount += bonus * 4;
121             }
122 
123             if (now > 1525388399 + 12 days && now < 1525388399 + 13 days) {
124                 amount += bonus * 3;
125             }
126 
127             if (now > 1525388399 + 14 days && now < 1525388399 + 15 days) {
128                 amount += bonus * 2;
129             }
130 
131             if (now > 1525388399 + 15 days && now < 1525388399 + 16 days) {
132                 amount += bonus;
133             }
134         }
135 
136         tokenSold += amount / 1 ether;
137         tokenReward.transfer(msg.sender, amount);
138         FundTransfer(msg.sender, amount, true);
139         owner.transfer(msg.value);
140     }
141 }