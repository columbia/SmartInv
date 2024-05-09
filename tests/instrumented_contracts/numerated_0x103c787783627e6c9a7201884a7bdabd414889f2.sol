1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 *
7 * Web              - http://www.ethbank.space
8 * Facebook         - https://facebook.com/ethbankspace
9 * Instagram        - https://www.instagram.com/ethbank/
10 * Telegram_chat    - https://t.me/ethbankspace
11 *
12 *  - GAIN PER 24 HOURS:
13 *     -- Contract balance  < 100 Ether: 3 %
14 *     -- Contract balance >= 100 Ether: 5 %
15 *     -- Contract balance >= 300 Ether: 7 %
16 *     -- Contract balance >= 600 Ether: 9 %
17 *     -- Contract balance >= 1000 Ether: 10 %
18 *  - Life-long payments
19 *  - The revolutionary reliability
20 *  - Minimal contribution 0.01 eth
21 *  - Currency and payment - ETH
22 *  - Contribution allocation schemes:
23 *    -- 90% payments
24 *    -- 10% Marketing + Operating Expenses
25 *
26 * ---How to use:
27 *  1. Send from ETH wallet to the smart contract address
28 *     any amount from 0.01 ETH.
29 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
30 *     of your wallet.
31 *  3. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
32 *      spending too much on GAS)
33 *
34 * RECOMMENDED GAS LIMIT: 180000
35 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
36 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
37 *
38 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
39 * have private keys.
40 *
41 * Contracts reviewed and approved by pros!
42 *
43 * Main contract - ETHBank. Scroll down to find it.
44 *
45 */
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a * b;
55     assert(a == 0 || c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 library Percent {
79 
80   struct percent {
81     uint num;
82     uint den;
83   }
84   function mul(percent storage p, uint a) internal view returns (uint) {
85     if (a == 0) {
86       return 0;
87     }
88     return a*p.num/p.den;
89   }
90 
91   function div(percent storage p, uint a) internal view returns (uint) {
92     return a/p.num*p.den;
93   }
94 
95   function sub(percent storage p, uint a) internal view returns (uint) {
96     uint b = mul(p, a);
97     if (b >= a) return 0;
98     return a - b;
99   }
100 
101   function add(percent storage p, uint a) internal view returns (uint) {
102     return a + mul(p, a);
103   }
104 }
105 
106 contract ETHBank{
107 
108     using SafeMath for uint;
109     using Percent for Percent.percent;
110     // array containing information about beneficiaries
111     mapping (address => uint) public balances;
112     //array containing information about the time of payment
113     mapping (address => uint) public time;
114 
115     //The marks of the balance on the contract after which the percentage of payments will change
116     uint step1 = 100;
117     uint step2 = 300;
118     uint step3 = 600;
119     uint step4 = 1000;
120 
121     //the time through which dividends will be paid
122     uint dividendsTime = 15 minutes;
123 
124     event NewInvestor(address indexed investor, uint deposit);
125     event PayOffDividends(address indexed investor, uint value);
126     event NewDeposit(address indexed investor, uint value);
127 
128     uint public allDeposits;
129     uint public allPercents;
130     uint public allBeneficiaries;
131     uint public lastPayment;
132 
133     uint public constant minInvesment = 10 finney;
134 
135     address public adminAddr      = 0x36881f6d5aAAE61374ab5747B6001b339d50aF84;
136     address public marketAddr     = 0x3aEE679504D751473e35683993EBe89816fC133e;
137     address public commissionAddr = 0xfe8849F86C349Ea77ba2a87226A02323B83DB880;
138 
139     Percent.percent private m_adminPercent      = Percent.percent(2, 100);
140     Percent.percent private m_marketPercent     = Percent.percent(4, 100);
141     Percent.percent private m_commissionPercent = Percent.percent(4, 100);
142 
143     /**
144      * The modifier checking the positive balance of the beneficiary
145     */
146     modifier isIssetRecepient(){
147         require(balances[msg.sender] > 0, "Deposit not found");
148         _;
149     }
150 
151     /**
152      * modifier checking the next payout time
153      */
154     modifier timeCheck(){
155          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
156          _;
157     }
158 
159     function getDepositMultiplier()public view returns(uint){
160         uint percent = getPercent();
161 
162         uint rate = balances[msg.sender].mul(percent).div(10000000);
163 
164         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
165 
166         return(rate.mul(depositMultiplier));
167     }
168 
169     function receivePayment()isIssetRecepient timeCheck private{
170 
171         uint depositMultiplier = getDepositMultiplier();
172         time[msg.sender] = now;
173         msg.sender.transfer(depositMultiplier);
174 
175         allPercents+=depositMultiplier;
176         lastPayment =now;
177         emit PayOffDividends(msg.sender, depositMultiplier);
178     }
179 
180     /**
181      * @return bool
182      */
183     function authorizationPayment()public view returns(bool){
184 
185         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
186             return (true);
187         }else{
188             return(false);
189         }
190     }
191 
192     /**
193      * @return uint percent
194      */
195     function getPercent() public view returns(uint){
196 
197         uint contractBalance = address(this).balance;
198 
199         uint balanceStep1 = step1.mul(1 ether);
200         uint balanceStep2 = step2.mul(1 ether);
201         uint balanceStep3 = step3.mul(1 ether);
202         uint balanceStep4 = step4.mul(1 ether);
203     /**
204      * percents per 15 mins 
205      */
206         if(contractBalance < balanceStep1){
207             return(3125);
208         }
209         if(contractBalance >= balanceStep1 && contractBalance < balanceStep2){
210             return(5208);
211         }
212         if(contractBalance >= balanceStep2 && contractBalance < balanceStep3){
213             return(7292);
214         }
215         if(contractBalance >= balanceStep3 && contractBalance < balanceStep4){
216             return(9375);
217         }
218         if(contractBalance >= balanceStep4){
219             return(1042);
220         }
221     }
222 
223     function createDeposit() private{
224 
225         if(msg.value > 0){
226 
227             require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
228 
229             if (balances[msg.sender] == 0){
230                 emit NewInvestor(msg.sender, msg.value);
231                 allBeneficiaries+=1;
232             }
233 
234             // commission
235             adminAddr.transfer(m_adminPercent.mul(msg.value));
236             marketAddr.transfer(m_marketPercent.mul(msg.value));
237             commissionAddr.transfer(m_commissionPercent.mul(msg.value));
238 
239             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
240                 receivePayment();
241             }
242 
243             balances[msg.sender] = balances[msg.sender].add(msg.value);
244             time[msg.sender] = now;
245 
246             allDeposits+=msg.value;
247             emit NewDeposit(msg.sender, msg.value);
248 
249         }else{
250             receivePayment();
251         }
252     }
253 
254     /**
255      * function that is launched when transferring money to a contract
256      */
257     function() external payable{
258         createDeposit();
259     }
260 }