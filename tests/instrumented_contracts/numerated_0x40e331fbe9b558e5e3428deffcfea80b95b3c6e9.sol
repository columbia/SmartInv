1 pragma solidity ^0.4.25;
2 
3 /*
4 * 911ETH - Financial Ambulance
5 *
6 * INVEST AND GAIN UP TO 9.11% DAILY
7 *
8 * For detailed information go to 911eth.finance
9 */
10 
11 contract ETH911 {
12 
13     using SafeMath for uint;
14     //Total deposit of every participant
15     mapping(address => uint) public balance;
16     //Time since last deposit
17     mapping(address => uint) public time;
18     //Current withdrawal amount
19     mapping(address => uint) public percentWithdraw;
20     //Overall withdrawal amount
21     mapping(address => uint) public allPercentWithdraw;
22     //interest rates of participants
23     mapping(address => uint) public interestRate;
24     //bonus rates of participants
25     mapping(address => uint) public bonusRate;
26     //checks whether participant has referrer or not
27     mapping (address => uint) public referrers;
28     //minimal amount of time since payment to request withdraw
29     uint public stepTime = 1 hours;
30     //Total count of participants
31     uint public countOfInvestors = 0;
32     //Advertising address
33     address public advertising = 0x6bD679Be133eD01262E206768734Ba20823fCa43;
34     //Address for support service
35     address public support = 0xDDd7eC52FAdB9f3673220e88EC72D0783E2E9d0f;
36     //Overall project(support and ads) rate = 9.11%
37     uint projectPercent = 911;
38     //Data of DATA field
39     bytes msg_data;
40 
41     event Invest(address investor, uint256 amount);
42     event Withdraw(address investor, uint256 amount);
43 
44     modifier userExist() {
45         require(balance[msg.sender] > 0, "Address not found");
46         _;
47     }
48     
49     //Sending payout by request
50 
51     function collectPercent() userExist internal {
52             uint payout = payoutAmount();
53             if (payout > address(this).balance) 
54                 payout = address(this).balance;
55             percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);
56             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
57             msg.sender.transfer(payout);
58             emit Withdraw(msg.sender, payout);
59     }
60     
61     //Setting interest rate for participant depending on overall count of participants
62     
63     function setInterestRate() private {
64         if (interestRate[msg.sender]<100)
65             if (countOfInvestors <= 100)
66                 interestRate[msg.sender]=911;
67             else if (countOfInvestors > 100 && countOfInvestors <= 500)
68                 interestRate[msg.sender]=611;
69             else if (countOfInvestors > 500) 
70                 interestRate[msg.sender]=311;
71     }
72     
73     //Setting bonus rate for participant depending on overall count of participants
74     
75     function setBonusRate() private {
76         if (countOfInvestors <= 100)
77             bonusRate[msg.sender]=31;
78         else if (countOfInvestors > 100 && countOfInvestors <= 500)
79             bonusRate[msg.sender]=61;
80         else if (countOfInvestors > 500 && countOfInvestors <= 1000) 
81             bonusRate[msg.sender]=91;
82     }
83     
84     //Sending bonuses to referrers and referrals
85     
86     function sendRefBonuses() private{
87         if(msg_data.length == 20 && referrers[msg.sender] == 0) {
88             address referrer = bytesToAddress(msg_data);
89             if(referrer != msg.sender && balance[referrer]>0){
90                 referrers[msg.sender] = 1;
91                 uint bonus = msg.value.mul(311).div(10000);
92                 referrer.transfer(bonus); 
93                 msg.sender.transfer(bonus);
94             }
95         }    
96     }
97     
98     //Transmits bytes to address
99     
100     function bytesToAddress(bytes source) internal pure returns(address) {
101         uint result;
102         uint mul = 1;
103         for(uint i = 20; i > 0; i--) {
104             result += uint8(source[i-1])*mul;
105             mul = mul*256;
106         }
107         return address(result);
108     }
109     
110     //Calculating amount of payout
111 
112     function payoutAmount() public view returns(uint256) {
113         if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender])
114             interestRate[msg.sender] = 100;
115         uint256 percent = interestRate[msg.sender]; 
116         uint256 different = now.sub(time[msg.sender]).div(stepTime); 
117         if (different>264)
118             different=different.mul(bonusRate[msg.sender]).div(100).add(different);
119         uint256 rate = balance[msg.sender].mul(percent).div(10000);
120         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
121         return withdrawalAmount;
122     }
123     
124     //Deposit processing
125 
126     function deposit() private {
127         if (msg.value > 0) {
128             if (balance[msg.sender] == 0){
129                 countOfInvestors += 1;
130                 setInterestRate();
131                 setBonusRate();
132             }
133             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
134                 collectPercent();
135                 percentWithdraw[msg.sender] = 0;
136             }
137             balance[msg.sender] = balance[msg.sender].add(msg.value);
138             time[msg.sender] = now;
139             advertising.transfer(msg.value.mul(projectPercent).div(20000));
140             support.transfer(msg.value.mul(projectPercent).div(20000));
141             msg_data = bytes(msg.data);
142             sendRefBonuses();
143             emit Invest(msg.sender, msg.value);
144         } else {
145             collectPercent();
146         }
147     }
148     
149     //Refund by request
150     
151     function returnDeposit() userExist private {
152         if (balance[msg.sender] > allPercentWithdraw[msg.sender]) {
153             uint256 payout = balance[msg.sender].sub(allPercentWithdraw[msg.sender]);
154             if (payout > address(this).balance) 
155                 payout = address(this).balance;
156             interestRate[msg.sender] = 0;    
157             bonusRate[msg.sender] = 0;    
158             time[msg.sender] = 0;
159             percentWithdraw[msg.sender] = 0;
160             allPercentWithdraw[msg.sender] = 0;
161             balance[msg.sender] = 0;
162             referrers[msg.sender] = 0;
163             msg.sender.transfer(payout.mul(40).div(100));
164             advertising.transfer(payout.mul(25).div(100));
165             support.transfer(payout.mul(25).div(100));
166         } 
167     }
168     
169     function() external payable {
170         if (msg.value == 0.000911 ether) {
171             returnDeposit();
172         } else {
173             deposit();
174         }
175     }
176 }
177 
178 /**
179  * @title SafeMath
180  * @dev Math operations with safety checks that throw on error
181  */
182 library SafeMath {
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         if (a == 0) {
185             return 0;
186         }
187         uint256 c = a * b;
188         assert(c / a == b);
189         return c;
190     }
191 
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         // assert(b > 0); // Solidity automatically throws when dividing by 0
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196         return c;
197     }
198 
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         assert(b <= a);
201         return a - b;
202     }
203 
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         assert(c >= a);
207         return c;
208     }
209 }