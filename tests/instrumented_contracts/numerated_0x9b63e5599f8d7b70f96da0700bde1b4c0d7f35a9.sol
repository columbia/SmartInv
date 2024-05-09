1 pragma solidity 0.4.25;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31 }
32 
33 contract DoubleUp {
34     //using the library of safe mathematical operations    
35     using SafeMath
36     for uint;
37     //array of last users withdrawal
38     mapping(address => uint) public usersTime;
39     //array of users investment ammount
40     mapping(address => uint) public usersInvestment;
41     //array of dividends user have withdrawn
42     mapping(address => uint) public dividends;
43     //wallet for a project foundation
44     address public projectFund = 0xe8eb761B83e035b0804C60D2025Ec00f347EC793;
45     //fund to project
46     uint public projectPercent = 9;
47     //percent of refferer
48     uint public referrerPercent = 2;
49     //percent of refferal
50     uint public referralPercent = 1;
51     //the ammount of returned from the begin of this day (GMT)
52     uint public ruturnedOfThisDay = 0;
53     //the day of last return
54     uint public dayOfLastReturn = 0;
55     //max ammount of return per day
56     uint public maxReturn = 500 ether;
57     //percents:
58     uint public startPercent = 200;     //2% per day
59     uint public lowPercent = 300;       //3% per day
60     uint public middlePercent = 400;    //4% per day
61     uint public highPercent = 500;      //5% per day
62     //interest rate
63     uint public stepLow = 1000 ether;
64     uint public stepMiddle = 2500 ether;
65     uint public stepHigh = 5000 ether;
66     uint public countOfInvestors = 0;
67 
68     modifier isIssetUser() {
69         require(usersInvestment[msg.sender] > 0, "Deposit not found");
70         _;
71     }
72 
73     //pay dividends on the deposit
74     function collectPercent() isIssetUser internal {
75         //if the user received 200% or more of his contribution, delete the user
76         if ((usersInvestment[msg.sender].mul(2)) <= dividends[msg.sender]) {
77             //this should never execute, but lets stay it here
78             usersInvestment[msg.sender] = 0;
79             usersTime[msg.sender] = 0;
80             dividends[msg.sender] = 0;
81         } else {
82             uint payout = payoutAmount();
83             usersTime[msg.sender] = now;
84             dividends[msg.sender] += payout;
85             msg.sender.transfer(payout);
86             //check again for 200%
87             if ((usersInvestment[msg.sender].mul(2)) <= dividends[msg.sender]) {
88                 usersInvestment[msg.sender] = 0;
89                 usersTime[msg.sender] = 0;
90                 dividends[msg.sender] = 0;
91             }    
92         }
93     }
94 
95     //calculation of the current percent rate
96     function percentRate() public view returns(uint) {
97         //get contract balance
98         uint balance = address(this).balance;
99         //calculate percent rate
100         if (balance < stepLow) {
101             return (startPercent);
102         }
103         if (balance >= stepLow && balance < stepMiddle) {
104             return (lowPercent);
105         }
106         if (balance >= stepMiddle && balance < stepHigh) {
107             return (middlePercent);
108         }
109         if (balance >= stepHigh) {
110             return (highPercent);
111         }
112     }
113 
114     //refund of the amount available for withdrawal on deposit
115     function payoutAmount() public view returns(uint) {
116         uint percent = percentRate();
117         uint rate = usersInvestment[msg.sender].mul(percent).div(10000);//per day
118         uint interestRate = now.sub(usersTime[msg.sender]);
119         uint withdrawalAmount = rate.mul(interestRate).div(60*60*24);
120         uint rest = (usersInvestment[msg.sender].mul(2)).sub(dividends[msg.sender]);
121         if(withdrawalAmount>rest) withdrawalAmount = rest;
122         return (withdrawalAmount);
123     }
124 
125     //make a contribution to the fund
126     function makeDeposit() private {
127         if (msg.value > 0) {
128             //check for referral
129             uint projectTransferPercent = projectPercent;
130             if(msg.data.length == 20 && msg.value >= 5 ether){
131                 address referrer = _bytesToAddress(msg.data);
132                 if(usersInvestment[referrer] >= 1 ether){
133                     referrer.transfer(msg.value.mul(referrerPercent).div(100));
134                     msg.sender.transfer(msg.value.mul(referralPercent).div(100));
135                     projectTransferPercent = projectTransferPercent.sub(referrerPercent.add(referralPercent));
136                 }
137             }
138             if (usersInvestment[msg.sender] > 0) {
139                 collectPercent();
140             }
141             else {
142                 countOfInvestors += 1;
143             }
144             usersInvestment[msg.sender] = usersInvestment[msg.sender].add(msg.value);
145             usersTime[msg.sender] = now;
146             //sending money for advertising
147             projectFund.transfer(msg.value.mul(projectTransferPercent).div(100));
148         } else {
149             collectPercent();
150         }
151     }
152 
153     //return of deposit balance
154     function returnDeposit() isIssetUser private {
155         
156         //check for day limit
157         require(((maxReturn.sub(ruturnedOfThisDay) > 0) || (dayOfLastReturn != now.div(1 days))), 'Day limit of return is ended');
158         //check that user didnt get more than 91% of his deposit 
159         require(usersInvestment[msg.sender].sub(usersInvestment[msg.sender].mul(projectPercent).div(100)) > dividends[msg.sender].add(payoutAmount()), 'You have already repaid your 91% of deposit. Use 0!');
160         
161         //pay dividents
162         collectPercent();
163         //userDeposit-percentWithdraw-(userDeposit*projectPercent/100)
164         uint withdrawalAmount = usersInvestment[msg.sender].sub(dividends[msg.sender]).sub(usersInvestment[msg.sender].mul(projectPercent).div(100));
165         //if this day is different from the day of last return then recharge max reurn 
166         if(dayOfLastReturn!=now.div(1 days)) { ruturnedOfThisDay = 0; dayOfLastReturn = now.div(1 days); }
167         
168         if(withdrawalAmount > maxReturn.sub(ruturnedOfThisDay)){
169             withdrawalAmount = maxReturn.sub(ruturnedOfThisDay);
170             //recalculate the rest of users investment (like he make it right now)
171             usersInvestment[msg.sender] = usersInvestment[msg.sender].sub(withdrawalAmount.add(dividends[msg.sender]).mul(100).div(100-projectPercent));
172             usersTime[msg.sender] = now;
173             dividends[msg.sender] = 0;
174         }
175         else
176         {
177              //delete user record
178             usersInvestment[msg.sender] = 0;
179             usersTime[msg.sender] = 0;
180             dividends[msg.sender] = 0;
181         }
182         ruturnedOfThisDay += withdrawalAmount;
183         msg.sender.transfer(withdrawalAmount);
184     }
185 
186     function() external payable {
187         //refund of remaining funds when transferring to a contract 0.00000112 ether
188         if (msg.value == 0.00000112 ether) {
189             returnDeposit();
190         } else {
191             makeDeposit();
192         }
193     }
194     
195     function _bytesToAddress(bytes data) private pure returns(address addr) {
196         assembly {
197             addr := mload(add(data, 20)) 
198         }
199     }
200 }