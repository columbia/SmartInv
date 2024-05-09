1 /**
2  * Source Code first verified at https://etherscan.io on Friday, May 10, 2019
3  (UTC) */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8 *
9 * MAVRO.ORG
10 *
11 * Telegram_channel -  https://t.me/Mavro_MMM
12 * Chat RU:            https://t.me/mavroorg
13 * CHAT International: https://t.me/mavro_international
14 * Twitter          -  https://twitter.com/Sergey_Mavrody
15 * VK               -  https://vk.com/mavro_official
16 *
17 *  - GAIN PER 24 HOURS:
18 *     -- Contract balance  < 200 Ether: 0.7 %
19 *     -- Contract balance >= 200 Ether: 0.8 %
20 *     -- Contract balance >= 400 Ether: 0.9 %
21 *     -- Contract balance >= 600 Ether: 1 %
22 *     -- Contract balance >= 800 Ether: 1.1 %
23 *     -- Contract balance >= 1000 Ether: 1.2 %
24 *  - Life-long payments
25 *  - Minimal contribution 0.01 eth
26 *  - Currency and payment - ETH
27 *  - Contribution allocation schemes:
28 *    -- 85% payments
29 *    -- 15% Marketing + Operating Expenses
30 *
31 * ---How to use:
32 *  1. Send from ETH wallet to the smart contract address
33 *     any amount from 0.01 ETH.
34 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
35 *     of your wallet.
36 *  3. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
37 *      spending too much on GAS)
38 *
39 * RECOMMENDED GAS LIMIT: 150000
40 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
41 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
42 *
43 */
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 library Percent {
77 
78   struct percent {
79     uint num;
80     uint den;
81   }
82   function mul(percent storage p, uint a) internal view returns (uint) {
83     if (a == 0) {
84       return 0;
85     }
86     return a*p.num/p.den;
87   }
88 
89   function div(percent storage p, uint a) internal view returns (uint) {
90     return a/p.num*p.den;
91   }
92 
93   function sub(percent storage p, uint a) internal view returns (uint) {
94     uint b = mul(p, a);
95     if (b >= a) return 0;
96     return a - b;
97   }
98 
99   function add(percent storage p, uint a) internal view returns (uint) {
100     return a + mul(p, a);
101   }
102 }
103 
104 contract MavroOrg{
105 
106     using SafeMath for uint;
107     using Percent for Percent.percent;
108     // array containing information about beneficiaries
109     mapping (address => uint) public balances;
110     //array containing information about the time of payment
111     mapping (address => uint) public time;
112 
113     //The marks of the balance on the contract after which the percentage of payments will change
114     uint step1 = 200;
115     uint step2 = 400;
116     uint step3 = 600;
117     uint step4 = 800;
118     uint step5 = 1000;
119 
120     //the time through which dividends will be paid
121     uint dividendsTime = 1 days;
122 
123     event NewInvestor(address indexed investor, uint deposit);
124     event PayOffDividends(address indexed investor, uint value);
125     event NewDeposit(address indexed investor, uint value);
126 
127     uint public allDeposits;
128     uint public allPercents;
129     uint public allBeneficiaries;
130     uint public lastPayment;
131 
132     uint public constant minInvesment = 10 finney;
133 
134     address public commissionAddr = 0x2eB660298263C5dd82b857EA26360dacd5fbB34d;
135 
136     Percent.percent private m_adminPercent = Percent.percent(15, 100);
137 
138     /**
139      * The modifier checking the positive balance of the beneficiary
140     */
141     modifier isIssetRecepient(){
142         require(balances[msg.sender] > 0, "Deposit not found");
143         _;
144     }
145 
146     /**
147      * modifier checking the next payout time
148      */
149     modifier timeCheck(){
150          require(now >= time[msg.sender].add(dividendsTime), "Too fast payout request. The time of payment has not yet come");
151          _;
152     }
153 
154     function getDepositMultiplier()public view returns(uint){
155         uint percent = getPercent();
156 
157         uint rate = balances[msg.sender].mul(percent).div(10000);
158 
159         uint depositMultiplier = now.sub(time[msg.sender]).div(dividendsTime);
160 
161         return(rate.mul(depositMultiplier));
162     }
163 
164     function receivePayment()isIssetRecepient timeCheck private{
165 
166         uint depositMultiplier = getDepositMultiplier();
167         time[msg.sender] = now;
168         msg.sender.transfer(depositMultiplier);
169 
170         allPercents+=depositMultiplier;
171         lastPayment =now;
172         emit PayOffDividends(msg.sender, depositMultiplier);
173     }
174 
175     /**
176      * @return bool
177      */
178     function authorizationPayment()public view returns(bool){
179 
180         if (balances[msg.sender] > 0 && now >= (time[msg.sender].add(dividendsTime))){
181             return (true);
182         }else{
183             return(false);
184         }
185     }
186 
187     /**
188      * @return uint percent
189      */
190     function getPercent() public view returns(uint){
191 
192         uint contractBalance = address(this).balance;
193 
194         uint balanceStep1 = step1.mul(1 ether);
195         uint balanceStep2 = step2.mul(1 ether);
196         uint balanceStep3 = step3.mul(1 ether);
197         uint balanceStep4 = step4.mul(1 ether);
198         uint balanceStep5 = step5.mul(1 ether);
199 
200         if(contractBalance < balanceStep1){
201             return(70);
202         }
203         if(contractBalance >= balanceStep1 && contractBalance < balanceStep2){
204             return(80);
205         }
206         if(contractBalance >= balanceStep2 && contractBalance < balanceStep3){
207             return(90);
208         }
209         if(contractBalance >= balanceStep3 && contractBalance < balanceStep4){
210             return(100);
211         }
212         if(contractBalance >= balanceStep4 && contractBalance < balanceStep5){
213             return(110);
214         }
215         if(contractBalance >= balanceStep5){
216             return(120);
217         }
218     }
219 
220     function createDeposit() private{
221 
222         if(msg.value > 0){
223 
224             require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
225 
226             if (balances[msg.sender] == 0){
227                 emit NewInvestor(msg.sender, msg.value);
228                 allBeneficiaries+=1;
229             }
230 
231             // commission
232             commissionAddr.transfer(m_adminPercent.mul(msg.value));
233 
234             if(getDepositMultiplier() > 0 && now >= time[msg.sender].add(dividendsTime) ){
235                 receivePayment();
236             }
237 
238             balances[msg.sender] = balances[msg.sender].add(msg.value);
239             time[msg.sender] = now;
240 
241             allDeposits+=msg.value;
242             emit NewDeposit(msg.sender, msg.value);
243 
244         }else{
245             receivePayment();
246         }
247     }
248 
249     /**
250      * function that is launched when transferring money to a contract
251      */
252     function() external payable{
253         createDeposit();
254     }
255 }