1 pragma solidity 0.4 .25;
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
36 *We are Etherum Global development fund
37 * 
38 *
39 *
40 *
41 */
42 contract EGDF {
43     //use of library of safe mathematical operations    
44     using SafeMath
45     for uint;
46     // array containing information about beneficiaries
47     mapping(address => uint) public userDeposit;
48     //array containing information about the time of payment
49     mapping(address => uint) public userTime;
50     //array containing information on interest paid
51     mapping(address => uint) public persentWithdraw;
52     //fund fo transfer percent
53     address public projectFund = 0x88EFF12801B69f33368f1219DCcbA53b68fd3a4c;
54     //wallet for a charitable foundation
55     address public charityFund = 0x31C38865D14B0A44E15e71e25f733395F437D797;
56     //percentage deducted to the advertising fund
57     uint projectPercent = 10;
58     //percent for a charitable foundation
59     uint public charityPercent = 2;
60     //time through which you can take dividends
61     uint public chargingTime = 1 hours;
62     //start persent 0.25% per hour
63     uint public startPercent = 250;
64     uint public lowPersent = 300;
65     uint public middlePersent = 350;
66     uint public highPersent = 375;
67     //interest rate increase steps
68     uint public stepLow = 500 ether;
69     uint public stepMiddle = 2000 ether;
70     uint public stepHigh = 4000 ether;
71     uint public countOfInvestors = 0;
72     uint public countOfCharity = 0;
73 
74     modifier isIssetUser() {
75         require(userDeposit[msg.sender] > 0, "Deposit not found");
76         _;
77     }
78 
79     modifier timePayment() {
80         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
81         _;
82     }
83 
84     //return of interest on the deposit
85     function collectPercent() isIssetUser timePayment internal {
86         //if the user received 200% or more of his contribution, delete the user
87         if ((userDeposit[msg.sender].mul(2)) <= persentWithdraw[msg.sender]) {
88             userDeposit[msg.sender] = 0;
89             userTime[msg.sender] = 0;
90             persentWithdraw[msg.sender] = 0;
91         } else {
92             uint payout = payoutAmount();
93             userTime[msg.sender] = now;
94             persentWithdraw[msg.sender] += payout;
95             msg.sender.transfer(payout);
96         }
97     }
98 
99     //calculation of the current interest rate on the deposit
100     function persentRate() public view returns(uint) {
101         //get contract balance
102         uint balance = address(this).balance;
103         //calculate persent rate
104         if (balance < stepLow) {
105             return (startPercent);
106         }
107         if (balance >= stepLow && balance < stepMiddle) {
108             return (lowPersent);
109         }
110         if (balance >= stepMiddle && balance < stepHigh) {
111             return (middlePersent);
112         }
113         if (balance >= stepHigh) {
114             return (highPersent);
115         }
116     }
117 
118     //refund of the amount available for withdrawal on deposit
119     function payoutAmount() public view returns(uint) {
120         uint persent = persentRate();
121         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
122         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
123         uint withdrawalAmount = rate.mul(interestRate);
124         return (withdrawalAmount);
125     }
126 
127     //make a contribution to the system
128     function makeDeposit() private {
129         if (msg.value > 0) {
130             if (userDeposit[msg.sender] == 0) {
131                 countOfInvestors += 1;
132             }
133             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
134                 collectPercent();
135             }
136             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
137             userTime[msg.sender] = now;
138             //sending money for advertising
139             projectFund.transfer(msg.value.mul(projectPercent).div(100));
140             //sending money to charity
141             uint charityMoney = msg.value.mul(charityPercent).div(100);
142             countOfCharity+=charityMoney;
143             charityFund.transfer(charityMoney);
144         } else {
145             collectPercent();
146         }
147     }
148 
149     //return of deposit balance
150     function returnDeposit() isIssetUser private {
151         //userDeposit-persentWithdraw-(userDeposit*10/100)
152         uint withdrawalAmount = userDeposit[msg.sender].sub(persentWithdraw[msg.sender]).sub(userDeposit[msg.sender].mul(projectPercent).div(100));
153         //check that the user's balance is greater than the interest paid
154         require(userDeposit[msg.sender] > withdrawalAmount, 'You have already repaid your deposit');
155         //delete user record
156         userDeposit[msg.sender] = 0;
157         userTime[msg.sender] = 0;
158         persentWithdraw[msg.sender] = 0;
159         msg.sender.transfer(withdrawalAmount);
160     }
161 
162     function() external payable {
163         //refund of remaining funds when transferring to a contract 0.00002291 ether
164         if (msg.value == 0.00002291 ether) {
165             returnDeposit();
166         } else {
167             makeDeposit();
168         }
169     }
170 }