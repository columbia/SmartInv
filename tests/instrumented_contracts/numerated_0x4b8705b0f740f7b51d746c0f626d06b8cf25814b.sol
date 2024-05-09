1 pragma solidity ^0.4.25;
2 
3 /**
4  *  X2Profit contract
5  *
6  *  Improved, no bugs and backdoors! Your investments are safe!
7  *
8  *  LOW RISK! You can take your deposit back ANY TIME!
9  *     - Send 0.00000112 ETH to contract address
10  *
11  *  NO DEPOSIT FEES! All the money go to contract!
12  *
13  *  HIGH RETURN! Get 0.27% - 0.4% per hour (6.5% - 9.6% per day)
14  *
15  *  Contract balance          daily percent
16  *       < 1000                   ~6.5%
17  *    1000 - 2500                 ~7.7%
18  *    2500 - 5000                 ~9.1%
19  *      >= 5000                   ~9.6%
20  *
21  *  LOW WITHDRAWAL FEES! Advertising 4%-10%, charity 1%
22  *
23  *  LONG LIFE! Maximum return is bounded by x2. Anyone has right to be rich!
24  *
25  *  HOLD LONG AND GET BONUS!
26  *  1. If you hold long enough you can take more than x2 (one time only)
27  *  2. The more you hold the less you pay for adv:
28  *     < 1 day            10%
29  *     1 - 3 days          9%
30  *     3 - 7 days          8%
31  *     1 - 2 weeks         7%
32  *     2 - 3 weeks         6%
33  *     3 - 4 weeks         5%
34  *       > 4 weeks         4%
35  *  Because large balance is good advertisement on itself!
36  *
37  *  INSTRUCTIONS:
38  *
39  *  TO INVEST: send ETH to contract address
40  *  TO WITHDRAW INTEREST: send 0 ETH to contract address
41  *  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address
42  *  TO GET BACK YOUR DEPOSIT: send 0.00000112 ETH to contract address
43  *
44  */
45 contract X2Profit {
46     //use library for safe math operations
47     using SafeMath for uint;
48 
49     // array containing information about beneficiaries
50     mapping(address => uint) public userDeposit;
51     //array containing information about the time of payment
52     mapping(address => uint) public userTime;
53     //array containing information on interest paid
54     mapping(address => uint) public percentWithdrawn;
55     //array containing information on interest paid (without tax)
56     mapping(address => uint) public percentWithdrawnPure;
57 
58     //fund fo transfer percent for advertising
59     address private constant ADDRESS_ADV_FUND = 0xE6AD1c76ec266348CB8E8aD2B1C95F372ad66c0e;
60     //wallet for a charitable foundation
61     address private constant ADDRESS_CHARITY_FUND = 0xC43Cf609440b53E25cdFfB4422EFdED78475C76B;
62     //time through which you can take dividends
63     uint private constant TIME_QUANT = 1 hours;
64 
65     //percent for a charitable foundation
66     uint private constant PERCENT_CHARITY_FUND = 1000;
67     //start percent 0.27% per hour
68     uint private constant PERCENT_START = 270;
69     uint private constant PERCENT_LOW = 320;
70     uint private constant PERCENT_MIDDLE = 380;
71     uint private constant PERCENT_HIGH = 400;
72 
73     //Adv tax for holders (10% for impatient, 4% for strong holders)
74     uint private constant PERCENT_ADV_VERY_HIGH = 10000;
75     uint private constant PERCENT_ADV_HIGH = 9000;
76     uint private constant PERCENT_ADV_ABOVE_MIDDLE = 8000;
77     uint private constant PERCENT_ADV_MIDDLE = 7000;
78     uint private constant PERCENT_ADV_BELOW_MIDDLE = 6000;
79     uint private constant PERCENT_ADV_LOW = 5000;
80     uint private constant PERCENT_ADV_LOWEST = 4000;
81 
82     //All percent should be divided by this
83     uint private constant PERCENT_DIVIDER = 100000;
84 
85     //interest rate increase steps
86     uint private constant STEP_LOW = 1000 ether;
87     uint private constant STEP_MIDDLE = 2500 ether;
88     uint private constant STEP_HIGH = 5000 ether;
89     
90     uint public countOfInvestors = 0;
91     uint public countOfCharity = 0;
92 
93     modifier isIssetUser() {
94         require(userDeposit[msg.sender] > 0, "Deposit not found");
95         _;
96     }
97 
98     modifier timePayment() {
99         require(now >= userTime[msg.sender].add(TIME_QUANT), "Too fast payout request");
100         _;
101     }
102 
103     //return of interest on the deposit
104     function collectPercent() isIssetUser timePayment internal {
105 
106         //if the user received 200% or more of his contribution, delete the user
107         if ((userDeposit[msg.sender].mul(2)) <= percentWithdrawnPure[msg.sender]) {
108             _delete(msg.sender); //User has withdrawn more than x2
109         } else {
110             uint payout = payoutAmount(msg.sender);
111             _payout(msg.sender, payout);
112         }
113     }
114 
115     //calculation of the current interest rate on the deposit
116     function percentRate() public view returns(uint) {
117         //get contract balance
118         uint balance = address(this).balance;
119 
120         //calculate percent rate
121         if (balance < STEP_LOW) {
122             return (PERCENT_START);
123         }
124         if (balance < STEP_MIDDLE) {
125             return (PERCENT_LOW);
126         }
127         if (balance < STEP_HIGH) {
128             return (PERCENT_MIDDLE);
129         }
130 
131         return (PERCENT_HIGH);
132     }
133 
134     //calculate the amount available for withdrawal on deposit
135     function payoutAmount(address addr) public view returns(uint) {
136         uint percent = percentRate();
137         uint rate = userDeposit[addr].mul(percent).div(PERCENT_DIVIDER);
138         uint interestRate = now.sub(userTime[addr]).div(TIME_QUANT);
139         uint withdrawalAmount = rate.mul(interestRate);
140         return (withdrawalAmount);
141     }
142 
143     function holderAdvPercent(address addr) public view returns(uint) {
144         uint timeHeld = (now - userTime[addr]);
145         if(timeHeld < 1 days)
146             return PERCENT_ADV_VERY_HIGH;
147         if(timeHeld < 3 days)
148             return PERCENT_ADV_HIGH;
149         if(timeHeld < 1 weeks)
150             return PERCENT_ADV_ABOVE_MIDDLE;
151         if(timeHeld < 2 weeks)
152             return PERCENT_ADV_MIDDLE;
153         if(timeHeld < 3 weeks)
154             return PERCENT_ADV_BELOW_MIDDLE;
155         if(timeHeld < 4 weeks)
156             return PERCENT_ADV_LOW;
157         return PERCENT_ADV_LOWEST;
158     }
159 
160     //make a deposit
161     function makeDeposit() private {
162         if (msg.value > 0) {
163             if (userDeposit[msg.sender] == 0) {
164                 countOfInvestors += 1;
165             }
166             if (userDeposit[msg.sender] > 0 && now >= userTime[msg.sender].add(TIME_QUANT)) {
167                 collectPercent();
168             }
169             userDeposit[msg.sender] += msg.value;
170             userTime[msg.sender] = now;
171         } else {
172             collectPercent();
173         }
174     }
175 
176     //return of deposit balance
177     function returnDeposit() isIssetUser private {
178         //percentWithdrawn already include all taxes for charity and ads
179         //So we need pay taxes only for the rest of deposit
180         uint withdrawalAmount = userDeposit[msg.sender]
181             .sub(percentWithdrawn[msg.sender]);
182 
183         //Pay the rest of deposit and take taxes
184         _payout(msg.sender, withdrawalAmount);
185 
186         //delete user record
187         _delete(msg.sender);
188     }
189 
190     function() external payable {
191         //refund of remaining funds when transferring to a contract 0.00000112 ether
192         if (msg.value == 0.00000112 ether) {
193             returnDeposit();
194         } else {
195             makeDeposit();
196         }
197     }
198 
199     //Pays out, takes taxes according to holding time
200     function _payout(address addr, uint amount) private {
201         //Remember this payout
202         percentWithdrawn[addr] += amount;
203 
204         //Get current holder adv percent
205         uint advPct = holderAdvPercent(addr);
206         //Calculate pure payout that user receives
207         uint interestPure = amount.mul(PERCENT_DIVIDER - PERCENT_CHARITY_FUND - advPct).div(PERCENT_DIVIDER);
208         percentWithdrawnPure[addr] += interestPure;
209         userTime[addr] = now;
210 
211         //calculate money to charity
212         uint charityMoney = amount.mul(PERCENT_CHARITY_FUND).div(PERCENT_DIVIDER);
213         countOfCharity += charityMoney;
214 
215         //calculate money for advertising
216         uint advTax = amount.sub(interestPure).sub(charityMoney);
217 
218         //send money
219         ADDRESS_ADV_FUND.transfer(advTax);
220         ADDRESS_CHARITY_FUND.transfer(charityMoney);
221         addr.transfer(interestPure);
222     }
223 
224     //Clears user from registry
225     function _delete(address addr) private {
226         userDeposit[addr] = 0;
227         userTime[addr] = 0;
228         percentWithdrawn[addr] = 0;
229         percentWithdrawnPure[addr] = 0;
230     }
231 }
232 
233 /**
234  * @title SafeMath
235  * @dev Math operations with safety checks that throw on error
236  */
237 library SafeMath {
238 
239     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
240         uint256 c = a * b;
241         assert(a == 0 || c / a == b);
242         return c;
243     }
244 
245     function div(uint256 a, uint256 b) internal pure returns(uint256) {
246         // assert(b > 0); // Solidity automatically throws when dividing by 0
247         uint256 c = a / b;
248         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
249         return c;
250     }
251 
252     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
253         assert(b <= a);
254         return a - b;
255     }
256 
257     function add(uint256 a, uint256 b) internal pure returns(uint256) {
258         uint256 c = a + b;
259         assert(c >= a);
260         return c;
261     }
262 
263 }