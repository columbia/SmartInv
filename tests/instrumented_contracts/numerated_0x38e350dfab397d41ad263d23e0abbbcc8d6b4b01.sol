1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0);
19         uint256 c = a / b;
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 }
38 
39 contract ETHSmartInvest {
40     using SafeMath for uint256;
41 
42     uint256 constant public ONE_HUNDRED   = 10000;
43     uint256 constant public INTEREST      = 330;
44     uint256 constant public MARKETING_FEE = 800;
45     uint256 constant public ADMIN_FEE     = 200;
46     uint256 constant public ONE_DAY       = 1 days;
47     uint256 constant public MINIMUM       = 0.01 ether;
48 
49     uint256[] public referralPercents     = [200, 100, 50, 25, 10];
50 
51     struct User {
52         uint256 time;
53         uint256 deposit;
54         uint256 reserve;
55         address referrer;
56         uint256 bonus;
57     }
58 
59     address public marketing = 0x137b2E4b00d40a42926e0846aca79F9b0AeBeFb6;
60     address public admin = 0x51ed5021AeD7F39CB0B350EF3Dd6eF1A29D17Ec5;
61 
62     mapping(address => User) public users;
63 
64     event InvestorAdded(address indexed investor, uint256 amount);
65     event ReferrerAdded(address indexed investor, address indexed referrer);
66     event DepositIncreased(address indexed investor, uint256 amount, uint256 totalAmount);
67     event DepositAddAll(uint256 amount);
68     event DividendsPayed(address indexed investor, uint256 amount);
69     event RefBonusPayed(address indexed investor, uint256 amount);
70     event RefBonusAdded(address indexed investor, address indexed referrer, uint256 amount, uint256 indexed level);
71 
72     function() external payable {
73         if (msg.value == 0) {
74             withdraw();
75         } else {
76             invest();
77         }
78     }
79 
80     function invest() public payable {
81         require(msg.value >= MINIMUM);
82         marketing.transfer(msg.value * MARKETING_FEE / ONE_HUNDRED);
83         admin.transfer(msg.value * ADMIN_FEE / ONE_HUNDRED);
84 
85         if (users[msg.sender].deposit > 0) {
86             saveDividends();
87             emit DepositIncreased(msg.sender, msg.value, users[msg.sender].deposit + msg.value);
88         } else {
89             emit InvestorAdded(msg.sender, msg.value);
90         }
91 
92         emit DepositAddAll(msg.value);
93 
94         users[msg.sender].deposit += msg.value;
95         users[msg.sender].time = block.timestamp;
96 
97         if (users[msg.sender].referrer != 0x0) {
98             refSystem();
99         } else if (msg.data.length == 20) {
100             addReferrer();
101         }
102     }
103 
104 
105     function withdraw() public {
106         uint256 payout = getDividends(msg.sender);
107         emit DividendsPayed(msg.sender, payout);
108 
109         if (getRefBonus(msg.sender) != 0) {
110             payout += getRefBonus(msg.sender);
111             emit RefBonusPayed(msg.sender, getRefBonus(msg.sender));
112             users[msg.sender].bonus = 0;
113         }
114 
115         require(payout >= MINIMUM);
116 
117         if (users[msg.sender].reserve != 0) {
118             users[msg.sender].reserve = 0;
119         }
120 
121         users[msg.sender].time += (block.timestamp.sub(users[msg.sender].time)).div(ONE_DAY).mul(ONE_DAY);
122 
123         msg.sender.transfer(payout);
124     }
125 
126     function bytesToAddress(bytes source) internal pure returns(address parsedReferrer) {
127         assembly {
128             parsedReferrer := mload(add(source,0x14))
129         }
130         return parsedReferrer;
131     }
132 
133     function addReferrer() internal {
134         address refAddr = bytesToAddress(bytes(msg.data));
135         if (refAddr != msg.sender) {
136             users[msg.sender].referrer = refAddr;
137 
138             refSystem();
139             emit ReferrerAdded(msg.sender, refAddr);
140         }
141     }
142 
143     function refSystem() internal {
144         address first = users[msg.sender].referrer;
145         users[first].bonus += msg.value * referralPercents[0] / ONE_HUNDRED;
146         emit RefBonusAdded(msg.sender, first, msg.value * referralPercents[0] / ONE_HUNDRED, 1);
147         address second = users[first].referrer;
148         if (second != address(0)) {
149             users[second].bonus += msg.value * referralPercents[1] / ONE_HUNDRED;
150             emit RefBonusAdded(msg.sender, second, msg.value * referralPercents[1] / ONE_HUNDRED, 2);
151             address third = users[second].referrer;
152             if (third != address(0)) {
153                 users[third].bonus += msg.value * referralPercents[2] / ONE_HUNDRED;
154                 emit RefBonusAdded(msg.sender, third, msg.value * referralPercents[2] / ONE_HUNDRED, 3);
155                 address fourth = users[third].referrer;
156                 if (fourth != address(0)) {
157                     users[fourth].bonus += msg.value * referralPercents[3] / ONE_HUNDRED;
158                     emit RefBonusAdded(msg.sender, fourth, msg.value * referralPercents[3] / ONE_HUNDRED, 4);
159                     address fifth = users[fourth].referrer;
160                     if (fifth != address(0)) {
161                         users[fifth].bonus += msg.value * referralPercents[4] / ONE_HUNDRED;
162                         emit RefBonusAdded(msg.sender, fifth, msg.value * referralPercents[4] / ONE_HUNDRED, 5);
163                     }
164                 }
165             }
166         }
167     }
168 
169     function saveDividends() internal {
170         uint256 dividends = (users[msg.sender].deposit.mul(INTEREST).div(ONE_HUNDRED)).mul(block.timestamp.sub(users[msg.sender].time)).div(ONE_DAY);
171         users[msg.sender].reserve += dividends;
172     }
173 
174     function getDividends(address userAddr) public view returns(uint256) {
175         return (users[userAddr].deposit.mul(INTEREST).div(ONE_HUNDRED)).mul((block.timestamp.sub(users[userAddr].time)).div(ONE_DAY)).add(users[userAddr].reserve);
176     }
177 
178     function getRefBonus(address userAddr) public view returns(uint256) {
179         return users[userAddr].bonus;
180     }
181 
182     function getNextTime(address userAddr) public view returns(uint256) {
183         if (users[userAddr].time != 0) {
184             return (block.timestamp.sub(users[userAddr].time)).div(ONE_DAY).mul(ONE_DAY).add(users[userAddr].time).add(ONE_DAY);
185         }
186     }
187 
188 }