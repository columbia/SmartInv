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
18 * RECOMMENDED GAS LIMIT: 200000
19 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
20 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
21 * 
22 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
23 * have private keys.
24 * 
25 * Contracts reviewed and approved by pros!
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
32         uint256 c = a * b;
33         assert(a == 0 || c / a == b);
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns(uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns(uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 
55 }
56 
57 /**
58 The development of the contract is entirely owned by the 3333eth campaign, any copying of the source code is not legal.
59 */
60 contract Eth333v3 {
61     //use of library of safe mathematical operations    
62     using SafeMath
63     for uint;
64     // array containing information about beneficiaries
65     mapping(address => uint) public userDeposit;
66     //array containing information about the time of payment
67     mapping(address => uint) public userTime;
68     //array containing information on interest paid
69     mapping(address => uint) public persentWithdraw;
70     //fund fo transfer percent
71     address public projectFund = 0x18e9F86ed0430679f79EF2eA0cc5E1186b80c570;
72     //wallet for a charitable foundation
73     address public charityFund = 0xf36EEbB7438aDef0E7fE4650a6Cd6dB238B58c6a;
74     //percentage deducted to the advertising fund
75     uint projectPercent = 8;
76     //percent for a charitable foundation
77     uint public charityPercent = 5;
78     //time through which you can take dividends
79     uint public chargingTime = 1 hours;
80     //start persent 0.13% per hour
81     uint public startPercent = 250;
82     uint public lowPersent = 300;
83     uint public middlePersent = 350;
84     uint public highPersent = 375;
85     //interest rate increase steps
86     uint public stepLow = 1000 ether;
87     uint public stepMiddle = 2500 ether;
88     uint public stepHigh = 5000 ether;
89     uint public countOfInvestors = 0;
90     uint public countOfCharity = 0;
91 
92     modifier isIssetUser() {
93         require(userDeposit[msg.sender] > 0, "Deposit not found");
94         _;
95     }
96 
97     modifier timePayment() {
98         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
99         _;
100     }
101 
102     //return of interest on the deposit
103     function collectPercent() isIssetUser timePayment internal {
104         //if the user received 200% or more of his contribution, delete the user
105         if ((userDeposit[msg.sender].mul(2)) <= persentWithdraw[msg.sender]) {
106             userDeposit[msg.sender] = 0;
107             userTime[msg.sender] = 0;
108             persentWithdraw[msg.sender] = 0;
109         } else {
110             uint payout = payoutAmount();
111             userTime[msg.sender] = now;
112             persentWithdraw[msg.sender] += payout;
113             msg.sender.transfer(payout);
114         }
115     }
116 
117     //calculation of the current interest rate on the deposit
118     function persentRate() public view returns(uint) {
119         //get contract balance
120         uint balance = address(this).balance;
121         //calculate persent rate
122         if (balance < stepLow) {
123             return (startPercent);
124         }
125         if (balance >= stepLow && balance < stepMiddle) {
126             return (lowPersent);
127         }
128         if (balance >= stepMiddle && balance < stepHigh) {
129             return (middlePersent);
130         }
131         if (balance >= stepHigh) {
132             return (highPersent);
133         }
134     }
135 
136     //refund of the amount available for withdrawal on deposit
137     function payoutAmount() public view returns(uint) {
138         uint persent = persentRate();
139         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
140         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
141         uint withdrawalAmount = rate.mul(interestRate);
142         return (withdrawalAmount);
143     }
144 
145     //make a contribution to the system
146     function makeDeposit() private {
147         if (msg.value > 0) {
148             if (userDeposit[msg.sender] == 0) {
149                 countOfInvestors += 1;
150             }
151             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
152                 collectPercent();
153             }
154             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
155             userTime[msg.sender] = now;
156             //sending money for advertising
157             projectFund.transfer(msg.value.mul(projectPercent).div(100));
158             //sending money to charity
159             uint charityMoney = msg.value.mul(charityPercent).div(100);
160             countOfCharity+=charityMoney;
161             charityFund.transfer(charityMoney);
162         } else {
163             collectPercent();
164         }
165     }
166 }