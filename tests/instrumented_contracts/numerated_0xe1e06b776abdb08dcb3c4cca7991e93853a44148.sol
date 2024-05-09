1 pragma solidity 0.4.25;
2 /**
3 *
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 *
6 * Web               - https://slicesmart.net
7 * Telegram			- https://t.me/slicesmart
8 * Telegram_RU 		- https://t.me/slicesmart_ru
9 *
10 *  - GAIN PER 24 HOURS:
11 *     -- Contract balance  < 100 Ether: 2.50 %
12 *     -- Contract balance >= 100 Ether: 2.75 %
13 *     -- Contract balance >= 200 Ether: 3.00 %
14 *     -- Contract balance >= 300 Ether: 3.25 %
15 *     -- Contract balance >= 400 Ether: 3.50 %
16 *     -- Contract balance >= 500 Ether: 4.00 %
17 *  - Life-long payments
18 *  - The revolutionary reliability
19 *  - Minimal contribution 0.01 eth
20 *  - Currency and payment - ETH
21 *  - Contribution allocation schemes:
22 *    -- 90% payments
23 *    -- 10% Operating Expenses + Marketing
24 *
25 * ---How to use:
26 *  1. Send from ETH wallet to the smart contract address
27 *     any amount from 0.01 ETH.
28 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
29 *     of your wallet.
30 *  3. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
31 *      spending too much on GAS)
32 *
33 * RECOMMENDED GAS LIMIT: 200000
34 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
35 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
36 *
37 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
38 * have private keys.
39 *
40 * Contracts reviewed and approved by pros!
41 *
42 * Main contract - SliceSmart. Scroll down to find it.
43 *
44 */
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51 
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 library Percent {
75 
76   struct percent {
77     uint num;
78     uint den;
79   }
80   function mul(percent storage p, uint a) internal view returns (uint) {
81     if (a == 0) {
82       return 0;
83     }
84     return a*p.num/p.den;
85   }
86   function div(percent storage p, uint a) internal view returns (uint) {
87     return a/p.num*p.den;
88   }
89   function sub(percent storage p, uint a) internal view returns (uint) {
90     uint b = mul(p, a);
91     if (b >= a) return 0;
92     return a - b;
93   }
94   function add(percent storage p, uint a) internal view returns (uint) {
95     return a + mul(p, a);
96   }
97 }
98 
99 contract SliceSmart{
100 
101     using SafeMath for uint;
102     using Percent for Percent.percent;
103     // array containing information about beneficiaries
104     mapping (address => uint) public balances;
105     //array containing information about the time of payment
106     mapping (address => uint) public time;
107 
108     //The marks of the balance on the contract after which the percentage of payments will change
109     uint step1 = 100;
110     uint step2 = 200;
111     uint step3 = 300;
112     uint step4 = 400;
113     uint step5 = 500;
114 
115     //the time through which dividends will be paid
116     uint dividendsTime = 1 days;
117 
118     event NewInvestor(address indexed investor, uint deposit);
119     event PayOffDividends(address indexed investor, uint value);
120     event NewDeposit(address indexed investor, uint value);
121 
122     uint public allDeposits;
123     uint public allPercents;
124     uint public allBeneficiaries;
125     uint public lastPayment;
126 
127     uint public constant minInvesment = 10 finney;
128 
129     address public commissionAddr = 0xF9123c9aE03C8ae711e318f042Ade9793AdAF636;
130 
131     Percent.percent private m_adminPercent = Percent.percent(10, 100);
132 
133     /**
134      * The modifier checking the positive balance of the beneficiary
135     */
136     modifier isIssetRecepient(){
137         require(balances[msg.sender] > 0, "Deposit not found");
138         _;
139     }
140 
141     /**
142      * modifier checking the next payout time
143      */
144     modifier timeCheck(){
145          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
146          _;
147     }
148 
149     function getDepositMultiplier()public view returns(uint){
150         uint percent = getPercent();
151 
152         uint rate = balances[msg.sender].mul(percent).div(10000);
153 
154         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
155 
156         return(rate.mul(depositMultiplier));
157     }
158 
159     function receivePayment()isIssetRecepient timeCheck private{
160 
161         uint depositMultiplier = getDepositMultiplier();
162         time[msg.sender] = now;
163         msg.sender.transfer(depositMultiplier);
164 
165         allPercents+=depositMultiplier;
166         lastPayment =now;
167         emit PayOffDividends(msg.sender, depositMultiplier);
168     }
169 
170     /**
171      * @return bool
172      */
173     function authorizationPayment()public view returns(bool){
174 
175         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
176             return (true);
177         }else{
178             return(false);
179         }
180     }
181 
182     /**
183      * @return uint percent
184      */
185     function getPercent() public view returns(uint){
186 
187         uint contractBalance = address(this).balance;
188 
189         uint balanceStep1 = step1.mul(1 ether);
190         uint balanceStep2 = step2.mul(1 ether);
191         uint balanceStep3 = step3.mul(1 ether);
192         uint balanceStep4 = step4.mul(1 ether);
193         uint balanceStep5 = step5.mul(1 ether);
194 
195         if(contractBalance < balanceStep1){
196             return(250);
197         }
198         if(contractBalance >= balanceStep1 && contractBalance < balanceStep2){
199             return(275);
200         }
201         if(contractBalance >= balanceStep2 && contractBalance < balanceStep3){
202             return(300);
203         }
204         if(contractBalance >= balanceStep3 && contractBalance < balanceStep4){
205             return(325);
206         }
207         if(contractBalance >= balanceStep4 && contractBalance < balanceStep5){
208             return(350);
209         }
210         if(contractBalance >= balanceStep5){
211             return(400);
212         }
213     }
214 
215     function createDeposit() private{
216 
217         if(msg.value > 0){
218 
219             require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
220 
221             if (balances[msg.sender] == 0){
222                 emit NewInvestor(msg.sender, msg.value);
223                 allBeneficiaries+=1;
224             }
225 
226             // commission
227             commissionAddr.transfer(m_adminPercent.mul(msg.value));
228 
229             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
230                 receivePayment();
231             }
232 
233             balances[msg.sender] = balances[msg.sender].add(msg.value);
234             time[msg.sender] = now;
235 
236             allDeposits+=msg.value;
237             emit NewDeposit(msg.sender, msg.value);
238 
239         }else{
240             receivePayment();
241         }
242     }
243 
244     /**
245      * function that is launched when transferring money to a contract
246      */
247     function() external payable{
248         createDeposit();
249     }
250 }