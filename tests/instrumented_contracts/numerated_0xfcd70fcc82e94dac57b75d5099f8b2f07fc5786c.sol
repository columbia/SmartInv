1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  *
6  * LEPRECHAUN - ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
7  * Telegram bot - t.me/LeprechaunContractBot
8  *
9  *  - GAIN 2% PER 24 HOURS
10  *  - Life-long payments
11  *  - Contribution allocation schemes:
12  *    -- 85% payments
13  *    -- 15% marketing
14  *
15  * HOW TO USE:
16  *  1. Send of ether to make an investment
17  *  2a. Claim your profit by sending 0 ether transaction (every hour, every day, every week)
18  *  OR
19  *  2b. Send more ether to reinvest AND get your profit at the same time
20  *
21  * PARTNER PROGRAM:
22  * At the moment of making the first deposit, the referral indicates in the DATA field the ETH address of the referrer's wallet,
23  * and the referrer then receives 5% of the every attachments of the referral,
24  * and the referral also immediately gets back 10% of his deposit
25  *
26  * NOTES:
27  * All ETHs that you've sent will be added to your deposit.
28  * In order to get an extra profit from your deposit, it is enough to send just 1 wei.
29  * It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
30  * have private keys.
31  *
32  * RECOMMENDED GAS LIMIT: 300000
33  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
34  *
35  */
36 library SafeMath {
37 
38     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
39 
40         if (_a == 0) { return 0; }
41 
42         c = _a * _b;
43         assert(c / _a == _b);
44         return c;
45     }
46 
47     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         return _a / _b;
49     }
50 
51 
52     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         assert(_b <= _a);
54         return _a - _b;
55     }
56 
57 
58     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59         c = _a + _b;
60         assert(c >= _a);
61         return c;
62     }
63 }
64 
65 contract Storage  {
66 
67     using SafeMath for uint;
68 
69     uint public constant perDay = 2;
70     uint public constant fee = 15;
71     uint public constant bonusReferral = 10;
72     uint public constant bonusReferrer = 5;
73 
74     uint public constant minimalDepositForBonusReferrer = 0.001 ether;
75 
76     uint public countInvestors = 0;
77     uint public totalInvest = 0;
78     uint public totalPaid = 0;
79 
80     struct User
81     {
82         uint balance;
83         uint paid;
84         uint timestamp;
85         uint countReferrals;
86         uint earnOnReferrals;
87         address referrer;
88     }
89 
90     mapping (address => User) internal user;
91 
92     function getAvailableBalance(address addr) internal view returns(uint) {
93         uint diffTime = user[addr].timestamp > 0 ? now.sub(user[addr].timestamp) : 0;
94         return user[addr].balance.mul(perDay).mul(diffTime).div(100).div(24 hours);
95     }
96 
97     function getUser(address addr) public view returns(uint, uint, uint, uint, uint, address) {
98 
99         return (
100             user[addr].balance,
101             user[addr].paid,
102             getAvailableBalance(addr),
103             user[addr].countReferrals,
104             user[addr].earnOnReferrals,
105             user[addr].referrer
106         );
107 
108     }
109 
110 
111 }
112 
113 contract Leprechaun is Storage {
114 
115     address public owner = msg.sender;
116 
117     modifier withDeposit() { if (msg.value > 0) { _; } }
118 
119     function() public payable {
120 
121         if (msg.sender == owner) { return; }
122 
123         register();
124         sendFee();
125         sendReferrer();
126         sendPayment();
127         updateInvestBalance();
128     }
129 
130 
131     function register() internal withDeposit {
132 
133         if (user[msg.sender].balance == 0) {
134 
135             user[msg.sender].timestamp = now;
136             countInvestors++;
137 
138             address referrer = bytesToAddress(msg.data);
139 
140             if (user[referrer].balance > 0 && referrer != msg.sender) {
141                 user[msg.sender].referrer = referrer;
142                 user[referrer].countReferrals++;
143                 transfer(msg.sender, msg.value.mul(bonusReferral).div(100));
144             }
145         }
146 
147     }
148 
149     function sendFee() internal withDeposit {
150         transfer(owner, msg.value.mul(fee).div(100));
151     }
152 
153     function sendReferrer() internal withDeposit {
154 
155         if (msg.value >= minimalDepositForBonusReferrer) {
156             address referrer = user[msg.sender].referrer;
157             if (user[referrer].balance > 0) {
158                 uint amountReferrer = msg.value.mul(bonusReferrer).div(100);
159                 user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
160                 transfer(referrer, amountReferrer);
161             }
162         }
163 
164     }
165 
166     function sendPayment() internal {
167 
168         if (user[msg.sender].balance > 0) {
169             transfer(msg.sender, getAvailableBalance(msg.sender));
170             user[msg.sender].timestamp = now;
171         }
172 
173     }
174 
175     function updateInvestBalance() internal withDeposit {
176         user[msg.sender].balance = user[msg.sender].balance.add(msg.value);
177         totalInvest = totalInvest.add(msg.value);
178     }
179 
180     function transfer(address receiver, uint amount) internal {
181 
182         if (amount > 0) {
183 
184             if (receiver != owner) { totalPaid = totalPaid.add(amount); }
185 
186             user[receiver].paid = user[receiver].paid.add(amount);
187 
188             if (amount > address(this).balance) {
189                 selfdestruct(receiver);
190             } else {
191                 receiver.transfer(amount);
192             }
193 
194         }
195 
196     }
197 
198     function bytesToAddress(bytes source) internal pure returns(address addr) {
199         assembly { addr := mload(add(source,0x14)) }
200         return addr;
201     }
202 
203 }