1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 *
7 * Web              - https://invest.cryptohoma.com
8 * Twitter          - https://twitter.com/cryptohoma
9 * Telegram_channel - https://t.me/cryptohoma_channel
10 * EN  Telegram_chat: https://t.me/cryptohoma_chateng
11 * RU  Telegram_chat: https://t.me/cryptohoma_chat
12 * KOR Telegram_chat: https://t.me/cryptohoma_chatkor
13 * Email:             mailto:info(at sign)cryptohoma.com
14 *
15 *  - GAIN PER 24 HOURS:
16 *     -- Contract balance  < 200 Ether: 3,25 %
17 *     -- Contract balance >= 200 Ether: 3.50 %
18 *     -- Contract balance >= 400 Ether: 3.75 %
19 *     -- Contract balance >= 600 Ether: 4.00 %
20 *     -- Contract balance >= 800 Ether: 4.25 %
21 *     -- Contract balance >= 1000 Ether: 4.50 %
22 *  - Life-long payments
23 *  - The revolutionary reliability
24 *  - Minimal contribution 0.01 eth
25 *  - Currency and payment - ETH
26 *  - Contribution allocation schemes:
27 *    -- 90% payments
28 *    -- 10% Marketing + Operating Expenses
29 *
30 * ---How to use:
31 *  1. Send from ETH wallet to the smart contract address
32 *     any amount from 0.01 ETH.
33 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
34 *     of your wallet.
35 *  3. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
36 *      spending too much on GAS)
37 *
38 * RECOMMENDED GAS LIMIT: 200000
39 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
40 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
41 *
42 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
43 * have private keys.
44 *
45 * Contracts reviewed and approved by pros!
46 *
47 * Main contract - HomaInvest. Scroll down to find it.
48 *
49 */
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath {
56 
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 library Percent {
83 
84   struct percent {
85     uint num;
86     uint den;
87   }
88   function mul(percent storage p, uint a) internal view returns (uint) {
89     if (a == 0) {
90       return 0;
91     }
92     return a*p.num/p.den;
93   }
94 
95   function div(percent storage p, uint a) internal view returns (uint) {
96     return a/p.num*p.den;
97   }
98 
99   function sub(percent storage p, uint a) internal view returns (uint) {
100     uint b = mul(p, a);
101     if (b >= a) return 0;
102     return a - b;
103   }
104 
105   function add(percent storage p, uint a) internal view returns (uint) {
106     return a + mul(p, a);
107   }
108 }
109 
110 contract HomaInvest{
111 
112     using SafeMath for uint;
113     using Percent for Percent.percent;
114     // array containing information about beneficiaries
115     mapping (address => uint) public balances;
116     //array containing information about the time of payment
117     mapping (address => uint) public time;
118 
119     //The marks of the balance on the contract after which the percentage of payments will change
120     uint step1 = 200;
121     uint step2 = 400;
122     uint step3 = 600;
123     uint step4 = 800;
124     uint step5 = 1000;
125 
126     //the time through which dividends will be paid
127     uint dividendsTime = 1 days;
128 
129     event NewInvestor(address indexed investor, uint deposit);
130     event PayOffDividends(address indexed investor, uint value);
131     event NewDeposit(address indexed investor, uint value);
132 
133     uint public allDeposits;
134     uint public allPercents;
135     uint public allBeneficiaries;
136     uint public lastPayment;
137 
138     uint public constant minInvesment = 10 finney;
139 
140     address public commissionAddr = 0x9f7E3556284EC90961ed0Ff78713729545A96131;
141 
142     Percent.percent private m_adminPercent = Percent.percent(10, 100);
143 
144     /**
145      * The modifier checking the positive balance of the beneficiary
146     */
147     modifier isIssetRecepient(){
148         require(balances[msg.sender] > 0, "Deposit not found");
149         _;
150     }
151 
152     /**
153      * modifier checking the next payout time
154      */
155     modifier timeCheck(){
156          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
157          _;
158     }
159 
160     function getDepositMultiplier()public view returns(uint){
161         uint percent = getPercent();
162 
163         uint rate = balances[msg.sender].mul(percent).div(10000);
164 
165         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
166 
167         return(rate.mul(depositMultiplier));
168     }
169 
170     function receivePayment()isIssetRecepient timeCheck private{
171 
172         uint depositMultiplier = getDepositMultiplier();
173         time[msg.sender] = now;
174         msg.sender.transfer(depositMultiplier);
175 
176         allPercents+=depositMultiplier;
177         lastPayment =now;
178         emit PayOffDividends(msg.sender, depositMultiplier);
179     }
180 
181     /**
182      * @return bool
183      */
184     function authorizationPayment()public view returns(bool){
185 
186         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
187             return (true);
188         }else{
189             return(false);
190         }
191     }
192 
193     /**
194      * @return uint percent
195      */
196     function getPercent() public view returns(uint){
197 
198         uint contractBalance = address(this).balance;
199 
200         uint balanceStep1 = step1.mul(1 ether);
201         uint balanceStep2 = step2.mul(1 ether);
202         uint balanceStep3 = step3.mul(1 ether);
203         uint balanceStep4 = step4.mul(1 ether);
204         uint balanceStep5 = step5.mul(1 ether);
205 
206         if(contractBalance < balanceStep1){
207             return(325);
208         }
209         if(contractBalance >= balanceStep1 && contractBalance < balanceStep2){
210             return(350);
211         }
212         if(contractBalance >= balanceStep2 && contractBalance < balanceStep3){
213             return(375);
214         }
215         if(contractBalance >= balanceStep3 && contractBalance < balanceStep4){
216             return(400);
217         }
218         if(contractBalance >= balanceStep4 && contractBalance < balanceStep5){
219             return(425);
220         }
221         if(contractBalance >= balanceStep5){
222             return(450);
223         }
224     }
225 
226     function createDeposit() private{
227 
228         if(msg.value > 0){
229 
230             require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
231 
232             if (balances[msg.sender] == 0){
233                 emit NewInvestor(msg.sender, msg.value);
234                 allBeneficiaries+=1;
235             }
236 
237             // commission
238             commissionAddr.transfer(m_adminPercent.mul(msg.value));
239 
240             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
241                 receivePayment();
242             }
243 
244             balances[msg.sender] = balances[msg.sender].add(msg.value);
245             time[msg.sender] = now;
246 
247             allDeposits+=msg.value;
248             emit NewDeposit(msg.sender, msg.value);
249 
250         }else{
251             receivePayment();
252         }
253     }
254 
255     /**
256      * function that is launched when transferring money to a contract
257      */
258     function() external payable{
259         createDeposit();
260     }
261 }