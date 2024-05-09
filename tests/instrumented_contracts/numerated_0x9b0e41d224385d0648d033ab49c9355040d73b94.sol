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
35 
36 contract X2invest {
37     //use of library of safe mathematical operations    
38     using SafeMath
39     for uint;
40     // array containing information about beneficiaries
41     mapping(address => uint) public userDeposit;
42     //array containing information about the time of payment
43     mapping(address => uint) public userTime;
44     //array containing information on interest paid
45     mapping(address => uint) public persentWithdraw;
46     //fund fo transfer percent
47     address public projectFund = 0x3cC93afb2b8e71ab626ad0c733c6a79549d7c43f;
48     //wallet for a charitable foundation
49     address public charityFund = 0x40a7044f42c5deaff3c5a6a495a54c03815327c7;
50     //percentage deducted to the advertising fund
51     uint projectPercent = 8;
52     //percent for a charitable foundation
53     uint public charityPercent = 1;
54     //time through which you can take dividends
55     uint public chargingTime = 1 hours;
56     //start persent 0.25% per hour
57     uint public startPercent = 250;
58     uint public lowPersent = 300;
59     uint public middlePersent = 350;
60     uint public highPersent = 375;
61     //interest rate increase steps
62     uint public stepLow = 1000 ether;
63     uint public stepMiddle = 2500 ether;
64     uint public stepHigh = 5000 ether;
65     uint public countOfInvestors = 0;
66     uint public countOfCharity = 0;
67 
68     modifier isIssetUser() {
69         require(userDeposit[msg.sender] > 0, "Deposit not found");
70         _;
71     }
72 
73     modifier timePayment() {
74         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
75         _;
76     }
77 
78     //return of interest on the deposit
79     function collectPercent() isIssetUser timePayment internal {
80         //if the user received 200% or more of his contribution, delete the user
81         if ((userDeposit[msg.sender].mul(2)) <= persentWithdraw[msg.sender]) {
82             userDeposit[msg.sender] = 0;
83             userTime[msg.sender] = 0;
84             persentWithdraw[msg.sender] = 0;
85         } else {
86             uint payout = payoutAmount();
87             userTime[msg.sender] = now;
88             persentWithdraw[msg.sender] += payout;
89             msg.sender.transfer(payout);
90         }
91     }
92 
93     //calculation of the current interest rate on the deposit
94     function persentRate() public view returns(uint) {
95         //get contract balance
96         uint balance = address(this).balance;
97         //calculate persent rate
98         if (balance < stepLow) {
99             return (startPercent);
100         }
101         if (balance >= stepLow && balance < stepMiddle) {
102             return (lowPersent);
103         }
104         if (balance >= stepMiddle && balance < stepHigh) {
105             return (middlePersent);
106         }
107         if (balance >= stepHigh) {
108             return (highPersent);
109         }
110     }
111 
112     //refund of the amount available for withdrawal on deposit
113     function payoutAmount() public view returns(uint) {
114         uint persent = persentRate();
115         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
116         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
117         uint withdrawalAmount = rate.mul(interestRate);
118         return (withdrawalAmount);
119     }
120 
121     //make a contribution to the system
122     function makeDeposit() private {
123         if (msg.value > 0) {
124             if (userDeposit[msg.sender] == 0) {
125                 countOfInvestors += 1;
126             }
127             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
128                 collectPercent();
129             }
130             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
131             userTime[msg.sender] = now;
132             //sending money for advertising
133             projectFund.transfer(msg.value.mul(projectPercent).div(100));
134             //sending money to charity
135             uint charityMoney = msg.value.mul(charityPercent).div(100);
136             countOfCharity+=charityMoney;
137             charityFund.transfer(charityMoney);
138         } else {
139             collectPercent();
140         }
141     }
142 
143     //return of deposit balance
144     function returnDeposit() isIssetUser private {
145         //userDeposit-persentWithdraw-(userDeposit*8/100)
146         uint withdrawalAmount = userDeposit[msg.sender].sub(persentWithdraw[msg.sender]).sub(userDeposit[msg.sender].mul(projectPercent).div(100));
147         //check that the user's balance is greater than the interest paid
148         require(userDeposit[msg.sender] > withdrawalAmount, 'You have already repaid your deposit');
149         //delete user record
150         userDeposit[msg.sender] = 0;
151         userTime[msg.sender] = 0;
152         persentWithdraw[msg.sender] = 0;
153         msg.sender.transfer(withdrawalAmount);
154     }
155 
156     function() external payable {
157         //refund of remaining funds when transferring to a contract 0.00000112 ether
158         if (msg.value == 0.00000112 ether) {
159             returnDeposit();
160         } else {
161             makeDeposit();
162         }
163     }
164 }