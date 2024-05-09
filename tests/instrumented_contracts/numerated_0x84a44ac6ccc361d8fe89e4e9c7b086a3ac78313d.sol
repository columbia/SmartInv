1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns(uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 
33 }
34 
35 /**
36 The development of the contract is entirely owned by the 3333eth campaign, any copying of the source code is not legal.
37 */
38 contract ETH333 {
39     //use of library of safe mathematical operations    
40     using SafeMath
41     for uint;
42     // array containing information about beneficiaries
43     mapping(address => uint) public userDeposit;
44     //array containing information about the time of payment
45     mapping(address => uint) public userTime;
46     //array containing information on interest paid
47     mapping(address => uint) public persentWithdraw;
48     //fund fo transfer percent
49     address public projectFund = 0x18e9F86ed0430679f79EF2eA0cc5E1186b80c570;
50     //wallet for a charitable foundation
51     address public charityFund = 0xf36EEbB7438aDef0E7fE4650a6Cd6dB238B58c6a;
52     //percentage deducted to the advertising fund
53     uint projectPercent = 8;
54     //percent for a charitable foundation
55     uint public charityPercent = 5;
56     //time through which you can take dividends
57     uint public chargingTime = 1 hours;
58     //start persent 0.13% per hour
59     uint public startPercent = 250;
60     uint public lowPersent = 300;
61     uint public middlePersent = 350;
62     uint public highPersent = 375;
63     //interest rate increase steps
64     uint public stepLow = 1000 ether;
65     uint public stepMiddle = 2500 ether;
66     uint public stepHigh = 5000 ether;
67     uint public countOfInvestors = 0;
68     uint public countOfCharity = 0;
69 
70     modifier isIssetUser() {
71         require(userDeposit[msg.sender] > 0, "Deposit not found");
72         _;
73     }
74 
75     modifier timePayment() {
76         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
77         _;
78     }
79 
80     //return of interest on the deposit
81     function collectPercent() isIssetUser timePayment internal {
82         //if the user received 200% or more of his contribution, delete the user
83         if ((userDeposit[msg.sender].mul(2)) <= persentWithdraw[msg.sender]) {
84             userDeposit[msg.sender] = 0;
85             userTime[msg.sender] = 0;
86             persentWithdraw[msg.sender] = 0;
87         } else {
88             uint payout = payoutAmount();
89             userTime[msg.sender] = now;
90             persentWithdraw[msg.sender] += payout;
91             msg.sender.transfer(payout);
92         }
93     }
94 
95     //calculation of the current interest rate on the deposit
96     function persentRate() public view returns(uint) {
97         //get contract balance
98         uint balance = address(this).balance;
99         //calculate persent rate
100         if (balance < stepLow) {
101             return (startPercent);
102         }
103         if (balance >= stepLow && balance < stepMiddle) {
104             return (lowPersent);
105         }
106         if (balance >= stepMiddle && balance < stepHigh) {
107             return (middlePersent);
108         }
109         if (balance >= stepHigh) {
110             return (highPersent);
111         }
112     }
113 
114     //refund of the amount available for withdrawal on deposit
115     function payoutAmount() public view returns(uint) {
116         uint persent = persentRate();
117         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
118         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
119         uint withdrawalAmount = rate.mul(interestRate);
120         return (withdrawalAmount);
121     }
122 
123     //make a contribution to the system
124     function makeDeposit() private {
125         if (msg.value > 0) {
126             if (userDeposit[msg.sender] == 0) {
127                 countOfInvestors += 1;
128             }
129             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
130                 collectPercent();
131             }
132             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
133             userTime[msg.sender] = now;
134             //sending money for advertising
135             projectFund.transfer(msg.value.mul(projectPercent).div(100));
136             //sending money to charity
137             uint charityMoney = msg.value.mul(charityPercent).div(100);
138             countOfCharity+=charityMoney;
139             charityFund.transfer(charityMoney);
140         } else {
141             collectPercent();
142         }
143     }
144 
145     //return of deposit balance
146     function returnDeposit() isIssetUser private {
147         //userDeposit-persentWithdraw-(userDeposit*8/100)
148         uint withdrawalAmount = userDeposit[msg.sender].sub(persentWithdraw[msg.sender]).sub(userDeposit[msg.sender].mul(projectPercent).div(100));
149         //check that the user's balance is greater than the interest paid
150         require(userDeposit[msg.sender] > withdrawalAmount, 'You have already repaid your deposit');
151         //delete user record
152         userDeposit[msg.sender] = 0;
153         userTime[msg.sender] = 0;
154         persentWithdraw[msg.sender] = 0;
155         msg.sender.transfer(withdrawalAmount);
156     }
157 }