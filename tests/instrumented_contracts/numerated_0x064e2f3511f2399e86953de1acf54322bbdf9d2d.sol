1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * ETHXETH CRYPTOCURRENCY DISTRIBUTION PROTOCOL
6 *
7 * Web              - ethxeth.ml
8 * Twitter          - twitter.com/ethxeth
9 * Telegram         - t.me/ethxeth
10 *
11 *  - GAIN PER 24 HOURS:
12 *     -- Contract balance << 200 Ether: 3,25 %
13 *     -- Contract balance >= 200 Ether: 3.50 %
14 *     -- Contract balance >= 400 Ether: 3.75 %
15 *     -- Contract balance >= 600 Ether: 4.00 %
16 *     -- Contract balance >= 800 Ether: 4.25 %
17 *     -- Contract balance >= 1000 Ether: 4.50 %
18 * 
19 *  - Life-long payments
20 *  - The revolutionary reliability
21 *  - Minimal contribution 0.01 eth
22 *  - Currency and payment - ETH
23 *  - Contribution allocation schemes:
24 *    -- 90% payments
25 *    -- 10% Marketing + Operating Expenses
26 *
27 * ---How to use:
28 *  1. Send from ETH wallet to the smart contract address
29 *     any amount from 0.01 ETH.
30 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
31 *     of your wallet.
32 *  3. Claim your profit by sending 0 ETH transaction (every day, every week, i don't care unless you're
33 *      spending too much on GAS)
34 *
35 * RECOMMENDED GAS LIMIT: 200000
36 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
37 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
38 *
39 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
40 * have private keys.
41 *
42 * Contracts reviewed and approved by pros!
43 *
44 * Main contract - EthXEth. Scroll down to find it.
45 *
46 */
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 library Percent {
80 
81   struct percent {
82     uint num;
83     uint den;
84   }
85   function mul(percent storage p, uint a) internal view returns (uint) {
86     if (a == 0) {
87       return 0;
88     }
89     return a*p.num/p.den;
90   }
91 
92   function div(percent storage p, uint a) internal view returns (uint) {
93     return a/p.num*p.den;
94   }
95 
96   function sub(percent storage p, uint a) internal view returns (uint) {
97     uint b = mul(p, a);
98     if (b >= a) return 0;
99     return a - b;
100   }
101 
102   function add(percent storage p, uint a) internal view returns (uint) {
103     return a + mul(p, a);
104   }
105 }
106 
107 contract EthXEth{
108 
109     using SafeMath for uint;
110     using Percent for Percent.percent;
111     // array containing information about beneficiaries
112     mapping (address => uint) public balances;
113     //array containing information about the time of payment
114     mapping (address => uint) public time;
115 
116     //The marks of the balance on the contract after which the percentage of payments will change
117     uint step1 = 200;
118     uint step2 = 400;
119     uint step3 = 600;
120     uint step4 = 800;
121     uint step5 = 1000;
122 
123     //the time through which dividends will be paid
124     uint dividendsTime = 1 days;
125 
126     event NewInvestor(address indexed investor, uint deposit);
127     event PayOffDividends(address indexed investor, uint value);
128     event NewDeposit(address indexed investor, uint value);
129 
130     uint public allDeposits;
131     uint public allPercents;
132     uint public allBeneficiaries;
133     uint public lastPayment;
134 
135     uint public constant minInvesment = 10 finney;
136 
137     address public commissionAddr = 0xead85d8ff7d6bc58e8f0fdf91999c35949375f1a;
138 
139     Percent.percent private m_adminPercent = Percent.percent(10, 100);
140 
141     /**
142      * The modifier checking the positive balance of the beneficiary
143     */
144     modifier isIssetRecepient(){
145         require(balances[msg.sender] > 0, "Deposit not found");
146         _;
147     }
148 
149     /**
150      * modifier checking the next payout time
151      */
152     modifier timeCheck(){
153          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
154          _;
155     }
156 
157     function getDepositMultiplier()public view returns(uint){
158         uint percent = getPercent();
159 
160         uint rate = balances[msg.sender].mul(percent).div(10000);
161 
162         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
163 
164         return(rate.mul(depositMultiplier));
165     }
166 
167     function receivePayment()isIssetRecepient timeCheck private{
168 
169         uint depositMultiplier = getDepositMultiplier();
170         time[msg.sender] = now;
171         msg.sender.transfer(depositMultiplier);
172 
173         allPercents+=depositMultiplier;
174         lastPayment =now;
175         emit PayOffDividends(msg.sender, depositMultiplier);
176     }
177 
178     /**
179      * @return bool
180      */
181     function authorizationPayment()public view returns(bool){
182 
183         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
184             return (true);
185         }else{
186             return(false);
187         }
188     }
189 
190     /**
191      * @return uint percent
192      */
193     function getPercent() public view returns(uint){
194 
195         uint contractBalance = address(this).balance;
196 
197         uint balanceStep1 = step1.mul(1 ether);
198         uint balanceStep2 = step2.mul(1 ether);
199         uint balanceStep3 = step3.mul(1 ether);
200         uint balanceStep4 = step4.mul(1 ether);
201         uint balanceStep5 = step5.mul(1 ether);
202 
203         if(contractBalance < balanceStep1){
204             return(325);
205         }
206         if(contractBalance >= balanceStep1 && contractBalance < balanceStep2){
207             return(350);
208         }
209         if(contractBalance >= balanceStep2 && contractBalance < balanceStep3){
210             return(375);
211         }
212         if(contractBalance >= balanceStep3 && contractBalance < balanceStep4){
213             return(400);
214         }
215         if(contractBalance >= balanceStep4 && contractBalance < balanceStep5){
216             return(425);
217         }
218         if(contractBalance >= balanceStep5){
219             return(450);
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
235             commissionAddr.transfer(m_adminPercent.mul(msg.value));
236 
237             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
238                 receivePayment();
239             }
240 
241             balances[msg.sender] = balances[msg.sender].add(msg.value);
242             time[msg.sender] = now;
243 
244             allDeposits+=msg.value;
245             emit NewDeposit(msg.sender, msg.value);
246 
247         }else{
248             receivePayment();
249         }
250     }
251 
252     /**
253      * function that is launched when transferring money to a contract
254      */
255     function() external payable{
256         createDeposit();
257     }
258 }