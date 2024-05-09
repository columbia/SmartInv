1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  *
6  * BABLORUB - ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
7  *
8  *  - GAIN 8% PER 24 HOURS
9  *  - Life-long payments
10  *  - Contribution allocation schemes:
11  *    -- 85% payments
12  *    -- 15% marketing
13  *
14  * HOW TO USE:
15  *  1. Send of ether to make an investment
16  *  2a. Claim your profit by sending 0 ether transaction (every hour, every day, every week)
17  *  OR
18  *  2b. Send more ether to reinvest AND get your profit at the same time
19  *
20  * PARTNER PROGRAM:
21  * At the moment of making the first deposit, the referral indicates in the DATA field the ETH address of the referrer's wallet,
22  * and the referrer then receives 5% of the every attachments of the referral,
23  * and the referral also immediately gets back 10% of his deposit
24  *
25  * NOTES:
26  * All ETHs that you've sent will be added to your deposit.
27  * In order to get an extra profit from your deposit, it is enough to send just 1 wei.
28  * It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
29  * have private keys.
30  *
31  * RECOMMENDED GAS LIMIT: 300000
32  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
33  *
34  */
35 library SafeMath {
36 
37     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
38 
39         if (_a == 0) { return 0; }
40 
41         c = _a * _b;
42         assert(c / _a == _b);
43         return c;
44     }
45 
46     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
47         return _a / _b;
48     }
49 
50 
51     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
52         assert(_b <= _a);
53         return _a - _b;
54     }
55 
56 
57     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58         c = _a + _b;
59         assert(c >= _a);
60         return c;
61     }
62 }
63 
64 contract Storage  {
65 
66     using SafeMath for uint;
67 
68     uint public constant perDay = 8;
69     uint public constant fee = 15;
70     uint public constant bonusReferral = 10;
71     uint public constant bonusReferrer = 5;
72 
73     uint public constant minimalDepositForBonusReferrer = 0.001 ether;
74 
75     uint public countInvestors = 0;
76     uint public totalInvest = 0;
77     uint public totalPaid = 0;
78 
79     struct User
80     {
81         uint balance;
82         uint paid;
83         uint timestamp;
84         uint countReferrals;
85         uint earnOnReferrals;
86         address referrer;
87     }
88 
89     mapping (address => User) internal user;
90 
91     function getAvailableBalance(address addr) internal view returns(uint) {
92         uint diffTime = user[addr].timestamp > 0 ? now.sub(user[addr].timestamp) : 0;
93         return user[addr].balance.mul(perDay).mul(diffTime).div(100).div(24 hours);
94     }
95 
96     function getUser(address addr) public view returns(uint, uint, uint, uint, uint, address) {
97 
98         return (
99             user[addr].balance,
100             user[addr].paid,
101             getAvailableBalance(addr),
102             user[addr].countReferrals,
103             user[addr].earnOnReferrals,
104             user[addr].referrer
105         );
106 
107     }
108 
109 
110 }
111 
112 contract Bablorub is Storage {
113 
114     address public owner = msg.sender;
115 
116     modifier withDeposit() { if (msg.value > 0) { _; } }
117 
118     function() public payable {
119 
120         if (msg.sender == owner) { return; }
121 
122         register();
123         sendFee();
124         sendReferrer();
125         sendPayment();
126         updateInvestBalance();
127     }
128 
129 
130     function register() internal withDeposit {
131 
132         if (user[msg.sender].balance == 0) {
133 
134             user[msg.sender].timestamp = now;
135             countInvestors++;
136 
137             address referrer = bytesToAddress(msg.data);
138 
139             if (user[referrer].balance > 0 && referrer != msg.sender) {
140                 user[msg.sender].referrer = referrer;
141                 user[referrer].countReferrals++;
142                 transfer(msg.sender, msg.value.mul(bonusReferral).div(100));
143             }
144         }
145 
146     }
147 
148     function sendFee() internal withDeposit {
149         transfer(owner, msg.value.mul(fee).div(100));
150     }
151 
152     function sendReferrer() internal withDeposit {
153 
154         if (msg.value >= minimalDepositForBonusReferrer) {
155             address referrer = user[msg.sender].referrer;
156             if (user[referrer].balance > 0) {
157                 uint amountReferrer = msg.value.mul(bonusReferrer).div(100);
158                 user[referrer].earnOnReferrals = user[referrer].earnOnReferrals.add(amountReferrer);
159                 transfer(referrer, amountReferrer);
160             }
161         }
162 
163     }
164 
165     function sendPayment() internal {
166 
167         if (user[msg.sender].balance > 0) {
168             transfer(msg.sender, getAvailableBalance(msg.sender));
169             user[msg.sender].timestamp = now;
170         }
171 
172     }
173 
174     function updateInvestBalance() internal withDeposit {
175         user[msg.sender].balance = user[msg.sender].balance.add(msg.value);
176         totalInvest = totalInvest.add(msg.value);
177     }
178 
179     function transfer(address receiver, uint amount) internal {
180 
181         if (amount > 0) {
182 
183             if (receiver != owner) { totalPaid = totalPaid.add(amount); }
184 
185             user[receiver].paid = user[receiver].paid.add(amount);
186 
187             if (amount > address(this).balance) {
188                 selfdestruct(receiver);
189             } else {
190                 receiver.transfer(amount);
191             }
192 
193         }
194 
195     }
196 
197     function bytesToAddress(bytes source) internal pure returns(address addr) {
198         assembly { addr := mload(add(source,0x14)) }
199         return addr;
200     }
201 
202 }