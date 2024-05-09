1 pragma solidity 0.4 .25;
2 
3 /**
4  * 
5  *   ---About the Project  SAFEInvestRETURNdeps
6  *  Absolutely honest contract without an owner, your money is safe and no one can take it away, nobody
7  *  Unique project with the possibility of withdrawal of the deposit at any time
8  *  The percentage of dynamic depending on the amount of ETH deposit
9  *  To withdraw interest send 0 to the address of the contract
10  *  To withdraw the deposit send 0.00000911 ETH to the address of the contract
11  *  Recommended gas limit 200,000
12  *  Interest payments are made every 30 minutes
13  *  The maximum you can get 200 percent, after which the contract will remove your address from memory
14  *  If you want to withdraw the deposit ahead of time it will be taken fee 15 percent of withdrawal amount
15  * 
16  * 
17  * 
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns(uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns(uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47 }
48 
49 /**
50  The SAFEInvest rebuilding fork№1
51 */
52 contract SAFEInvestRETURNdeps {
53     //use of library of safe mathematical operations    
54     using SafeMath
55     for uint;
56     // array containing information about beneficiaries
57     mapping(address => uint) public userDeposit;
58     //array containing information about the time of payment
59     mapping(address => uint) public userTime;
60     //array containing information on interest paid
61     mapping(address => uint) public persentWithdraw;
62     //fund fo transfer percent
63     address public projectFund = 0x8C267FF25c7311046a75cdd39759Bfc3A92BAf5A;
64      //wallet for a advertising fund
65     address public advertisFund =  0xcbAd8699654DC5E495C8E21F7411e57210b07d54;
66     //percentage deducted to the advertising fund
67     uint projectPercent = 2;
68     //percent for a advertising foundation
69     uint advertisPercent = 3;
70      //time through which you can take dividends
71     uint public chargingTime = 30 minutes;
72     //start persent 0.10% per hour
73     uint public startPercent =120;
74     uint public lowPersent = 150;
75     uint public middlePersent =180;
76     uint public highPersent = 195;
77     //interest rate increase steps
78     uint public stepLow = 10 ether;
79     uint public stepMiddle = 20 ether;
80     uint public stepHigh = 30 ether;
81     uint public countOfInvestors = 0;
82     uint public countOfCharity = 0;
83 
84     modifier isIssetUser() {
85         require(userDeposit[msg.sender] > 0, "Deposit not found");
86         _;
87     }
88 
89     modifier timePayment() {
90         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
91         _;
92     }
93 
94     //return of interest on the deposit
95     function collectPercent() isIssetUser timePayment internal {
96         //if the user received 200% or more of his contribution, delete the user
97         if ((userDeposit[msg.sender].mul(2)) <= persentWithdraw[msg.sender]) {
98             userDeposit[msg.sender] = 0;
99             userTime[msg.sender] = 0;
100             persentWithdraw[msg.sender] = 0;
101         } else {
102             uint payout = payoutAmount();
103             userTime[msg.sender] = now;
104             persentWithdraw[msg.sender] += payout;
105             msg.sender.transfer(payout);
106         }
107     }
108 
109     //calculation of the current interest rate on the deposit
110     function persentRate() public view returns(uint) {
111         //get contract balance
112         uint balance = address(this).balance;
113         //calculate persent rate
114         if (balance < stepLow) {
115             return (startPercent);
116         }
117         if (balance >= stepLow && balance < stepMiddle) {
118             return (lowPersent);
119         }
120         if (balance >= stepMiddle && balance < stepHigh) {
121             return (middlePersent);
122         }
123         if (balance >= stepHigh) {
124             return (highPersent);
125         }
126     }
127 
128     //refund of the amount available for withdrawal on deposit
129     function payoutAmount() public view returns(uint) {
130         uint persent = persentRate();
131         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
132         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
133         uint withdrawalAmount = rate.mul(interestRate);
134         return (withdrawalAmount);
135     }
136 
137     //make a contribution to the system
138     function makeDeposit() private {
139         if (msg.value > 0) {
140             if (userDeposit[msg.sender] == 0) {
141                 countOfInvestors += 1;
142             }
143             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
144                 collectPercent();
145             }
146             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
147             userTime[msg.sender] = now;
148             //sending money for advertising
149             projectFund.transfer(msg.value.mul(projectPercent).div(100));
150             //sending money to advertis
151             advertisFund.transfer(msg.value.mul(advertisPercent).div(100));
152                    } else {
153             collectPercent();
154         }
155     }
156 
157     //return of deposit balance
158     function returnDeposit() isIssetUser private {
159         //userDeposit-persentWithdraw-(userDeposit*15/100)
160         uint withdrawalAmount = userDeposit[msg.sender].sub(persentWithdraw[msg.sender]).sub(userDeposit[msg.sender].mul(projectPercent).div(100));
161         //check that the user's balance is greater than the interest paid
162         require(userDeposit[msg.sender] > withdrawalAmount, 'You have already repaid your deposit');
163         //delete user record
164         userDeposit[msg.sender] = 0;
165         userTime[msg.sender] = 0;
166         persentWithdraw[msg.sender] = 0;
167         msg.sender.transfer(withdrawalAmount);
168     }
169 
170     function() external payable {
171         //refund of remaining funds when transferring to a contract 0.00000911 ether
172         if (msg.value == 0.00000911 ether) {
173             returnDeposit();
174         } else {
175             makeDeposit();
176         }
177     }
178 }