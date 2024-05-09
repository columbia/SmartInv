1 pragma solidity 0.4.25;
2 
3 /**
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 3.0
5 * Web              - https://3333eth.ru
6 * 
7 * 
8 *  - GAIN 3,33% - 1% PER 24 HOURS (interest is charges in equal parts every 10 min)
9 *  - Life-long payments
10 *  - The revolutionary reliability
11 *  - Minimal contribution 0.01 eth
12 *  - Currency and payment - ETH
13 *  - Contribution allocation schemes:
14 *    -- 87% payments
15 *    --  8% marketing
16 *    --  5% technical support
17 *
18 *   ---About the Project
19 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
20 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
21 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
22 *  freely accessed online. In order to insure our investors' complete security, full control over the 
23 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
24 *  system's permanent autonomous functioning.
25 * 
26 * RECOMMENDED GAS LIMIT: 200000
27 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
28 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
29 * 
30 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
31 * have private keys.
32 * 
33 * Contracts reviewed and approved by pros!
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
40         uint256 c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44 
45     function div(uint256 a, uint256 b) internal pure returns(uint256) {
46         // assert(b > 0); // Solidity automatically throws when dividing by 0
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     function add(uint256 a, uint256 b) internal pure returns(uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 
63 }
64 
65 /**
66 The development of the contract is entirely owned by the 3333eth campaign, any copying of the source code is not legal.
67 */
68 contract ETH_v3 {
69     //use of library of safe mathematical operations    
70     using SafeMath
71     for uint;
72     // array containing information about beneficiaries
73     mapping(address => uint) public userDeposit;
74     //array containing information about the time of payment
75     mapping(address => uint) public userTime;
76     //array containing information on interest paid
77     mapping(address => uint) public persentWithdraw;
78     //fund fo transfer percent
79     address public projectFund = 0x18e9F86ed0430679f79EF2eA0cc5E1186b80c570;
80     //wallet for a charitable foundation
81     address public charityFund = 0xf36EEbB7438aDef0E7fE4650a6Cd6dB238B58c6a;
82     //percentage deducted to the advertising fund
83     uint projectPercent = 8;
84     //percent for a charitable foundation
85     uint public charityPercent = 5;
86     //time through which you can take dividends
87     uint public chargingTime = 1 hours;
88     //start persent 0.13% per hour
89     uint public startPercent = 250;
90     uint public lowPersent = 300;
91     uint public middlePersent = 350;
92     uint public highPersent = 375;
93     //interest rate increase steps
94     uint public stepLow = 1000 ether;
95     uint public stepMiddle = 2500 ether;
96     uint public stepHigh = 5000 ether;
97     uint public countOfInvestors = 0;
98     uint public countOfCharity = 0;
99 
100     modifier isIssetUser() {
101         require(userDeposit[msg.sender] > 0, "Deposit not found");
102         _;
103     }
104 
105     modifier timePayment() {
106         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
107         _;
108     }
109 
110     //return of interest on the deposit
111     function collectPercent() isIssetUser timePayment internal {
112         //if the user received 200% or more of his contribution, delete the user
113         if ((userDeposit[msg.sender].mul(2)) <= persentWithdraw[msg.sender]) {
114             userDeposit[msg.sender] = 0;
115             userTime[msg.sender] = 0;
116             persentWithdraw[msg.sender] = 0;
117         } else {
118             uint payout = payoutAmount();
119             userTime[msg.sender] = now;
120             persentWithdraw[msg.sender] += payout;
121             msg.sender.transfer(payout);
122         }
123     }
124 
125     //calculation of the current interest rate on the deposit
126     function persentRate() public view returns(uint) {
127         //get contract balance
128         uint balance = address(this).balance;
129         //calculate persent rate
130         if (balance < stepLow) {
131             return (startPercent);
132         }
133         if (balance >= stepLow && balance < stepMiddle) {
134             return (lowPersent);
135         }
136         if (balance >= stepMiddle && balance < stepHigh) {
137             return (middlePersent);
138         }
139         if (balance >= stepHigh) {
140             return (highPersent);
141         }
142     }
143 
144     //refund of the amount available for withdrawal on deposit
145     function payoutAmount() public view returns(uint) {
146         uint persent = persentRate();
147         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
148         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
149         uint withdrawalAmount = rate.mul(interestRate);
150         return (withdrawalAmount);
151     }
152 
153     //make a contribution to the system
154     function makeDeposit() private {
155         if (msg.value > 0) {
156             if (userDeposit[msg.sender] == 0) {
157                 countOfInvestors += 1;
158             }
159             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
160                 collectPercent();
161             }
162             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
163             userTime[msg.sender] = now;
164             //sending money for advertising
165             projectFund.transfer(msg.value.mul(projectPercent).div(100));
166             //sending money to charity
167             uint charityMoney = msg.value.mul(charityPercent).div(100);
168             countOfCharity+=charityMoney;
169             charityFund.transfer(charityMoney);
170         } else {
171             collectPercent();
172         }
173     }
174 }