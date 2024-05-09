1 pragma solidity ^0.4.24;
2 
3 /**
4  * 
5  * ██████╗ ███████╗████████╗███████╗██████╗ ███╗   ██╗ █████╗ ██╗     
6  * ██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗████╗  ██║██╔══██╗██║     
7  * ██████╔╝█████╗     ██║   █████╗  ██████╔╝██╔██╗ ██║███████║██║   
8  * ██╔══██╗██╔══╝     ██║   ██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║     
9  * ██║  ██║███████╗   ██║   ███████╗██║  ██║██║ ╚████║██║  ██║███████╗
10  * ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
11  * 
12  *  Contacts:
13  * 
14  *   -- t.me/Reternal
15  *   -- https://www.reternal.net
16  * 
17  * - GAIN PER 24 HOURS:
18  * 
19  *     -- Individual balance < 1 Ether: 3.55%
20  *     -- Individual balance >= 1 Ether: 3.65%
21  *     -- Individual balance >= 4 Ether: 3.75%
22  *     -- Individual balance >= 12 Ether: 3.85%
23  *     -- Individual balance >= 50 Ether: 4%
24  * 
25  *     -- Contract balance < 200 Ether: 0%
26  *     -- Contract balance >= 200 Ether: 0.30%
27  *     -- Contract balance >= 500 Ether: 0.40%
28  *     -- Contract balance >= 900 Ether: 0.50%
29  *     -- Contract balance >= 1500 Ether: 0.65%
30  *     -- Contract balance >= 2000 Ether: 0.80%
31  * 
32  *  - Minimal contribution 0.01 eth
33  *  - Contribution allocation schemes:
34  *    -- 95% payments
35  *    -- 5% Marketing + Operating Expenses
36  * 
37  * - How to use:
38  *  1. Send from your personal ETH wallet to the smart-contract address any amount more than or equal to 0.01 ETH
39  *  2. Add your refferer's wallet to a HEX data in your transaction to 
40  *     get a bonus amount back to your wallet only for the FIRST deposit
41  *     IMPORTANT: if you want to support Reternal project, you can leave your HEX data field empty, 
42  *                if you have no referrer and do not want to support Reternal, you can type 'noreferrer'
43  *                if there is no referrer, you will not get any bonuses
44  *  3. Use etherscan.io to verify your transaction 
45  *  4. Claim your dividents by sending 0 ether transaction (available anytime)
46  *  5. You can reinvest anytime you want
47  *
48  * RECOMMENDED GAS LIMIT: 200000
49  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
50  * 
51  * The smart-contract has a "restart" function, more info at www.reternal.net
52  * 
53  * If you want to check your dividents, you can use etherscan.io site, following the "Internal Txns" tab of your wallet
54  * WARNING: do not use exchanges' wallets - you will loose your funds. Only use your personal wallet for transactions 
55  * 
56  */
57 
58 contract Reternal {
59     
60     // Investor's data storage
61     mapping (address => Investor) public investors;
62     address[] public addresses;
63     
64     struct Investor
65     {
66         uint id;
67         uint deposit;
68         uint depositCount;
69         uint block;
70         address referrer;
71     }
72     
73     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
74     address defaultReferrer = 0x25EDFd665C2898c2898E499Abd8428BaC616a0ED;
75     
76     uint public round;
77     uint public totalDepositAmount;
78     bool public pause;
79     uint public restartBlock;
80     bool ref_flag;
81     
82     // Investors' dividents increase goals due to a bank growth
83     uint bank1 = 200e18; // 200 eth
84     uint bank2 = 500e18; // 500 eth
85     uint bank3 = 900e18; // 900 eth
86     uint bank4 = 1500e18; // 1500 eth
87     uint bank5 = 2000e18; // 2000 eth
88     // Investors' dividents increase due to individual deposit amount
89     uint dep1 = 1e18; // 1 ETH
90     uint dep2 = 4e18; // 4 ETH
91     uint dep3 = 12e18; // 12 ETH
92     uint dep4 = 5e19; // 50 ETH
93     
94     event NewInvestor(address indexed investor, uint deposit, address referrer);
95     event PayOffDividends(address indexed investor, uint value);
96     event refPayout(address indexed investor, uint value, address referrer);
97     event NewDeposit(address indexed investor, uint value);
98     event NextRoundStarted(uint round, uint block, address addr, uint value);
99     
100     constructor() public {
101         addresses.length = 1;
102         round = 1;
103         pause = false;
104     }
105 
106     function restart() private {
107         address addr;
108 
109         for (uint i = addresses.length - 1; i > 0; i--) {
110             addr = addresses[i];
111             addresses.length -= 1;
112             delete investors[addr];
113         }
114         
115         emit NextRoundStarted(round, block.number, msg.sender, msg.value);
116         pause = false;
117         round += 1;
118         totalDepositAmount = 0;
119         
120         createDeposit();
121     }
122 
123     function getRaisedPercents(address addr) internal view  returns(uint){
124         // Individual deposit percentage sums up with 'Reternal total fund' percentage
125         uint percent = getIndividualPercent() + getBankPercent();
126         uint256 amount = investors[addr].deposit * percent / 100*(block.number-investors[addr].block)/6000;
127         return(amount / 100);
128     }
129     
130     function payDividends() private{
131         require(investors[msg.sender].id > 0, "Investor not found.");
132         // Investor's total raised amount
133         uint amount = getRaisedPercents(msg.sender);
134             
135         if (address(this).balance < amount) {
136             pause = true;
137             restartBlock = block.number + 6000;
138             return;
139         }
140         
141         // Service fee deduction 
142         uint FeeToWithdraw = amount * 5 / 100;
143         uint payment = amount - FeeToWithdraw;
144         
145         address(0xD9bE11E7412584368546b1CaE64b6C384AE85ebB).transfer(FeeToWithdraw);
146         msg.sender.transfer(payment);
147         emit PayOffDividends(msg.sender, amount);
148         
149     }
150     
151     function createDeposit() private{
152         Investor storage user = investors[msg.sender];
153         
154         if (user.id == 0) {
155             
156             // Check for malicious smart-contract
157             msg.sender.transfer(0 wei);
158             user.id = addresses.push(msg.sender);
159 
160             if (msg.data.length != 0) {
161                 address referrer = bytesToAddress(msg.data);
162                 
163                 // Check for referrer's registration. Check for self referring
164                 if (investors[referrer].id > 0 && referrer != msg.sender) {
165                     user.referrer = referrer;
166                     
167                     // Cashback only for the first deposit
168                     if (user.depositCount == 0) {
169                         uint cashback = msg.value / 100;
170                         if (msg.sender.send(cashback)) {
171                             emit refPayout(msg.sender, cashback, referrer);
172                         }
173                     }
174                 }
175             } else {
176                 // If data is empty:
177                 user.referrer = defaultReferrer;
178             }
179             
180             emit NewInvestor(msg.sender, msg.value, referrer);
181             
182         } else {
183             // Dividents payment for an investor
184             payDividends();
185         }
186         
187         // 2% from a referral deposit transfer to a referrer 
188         uint payReferrer = msg.value * 2 / 100; 
189         
190         if (user.referrer == defaultReferrer) {
191             user.referrer.transfer(payReferrer);
192         } else {
193             investors[referrer].deposit += payReferrer;
194         }
195         
196         
197         user.depositCount++;
198         user.deposit += msg.value;
199         user.block = block.number;
200         totalDepositAmount += msg.value;
201         emit NewDeposit(msg.sender, msg.value);
202     }
203 
204     function() external payable {
205         if(pause) {
206             if (restartBlock <= block.number) { restart(); }
207             require(!pause, "Eternal is restarting, wait for the block in restartBlock");
208         } else {
209             if (msg.value == 0) {
210                 payDividends();
211                 return;
212             }
213             require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
214             createDeposit();
215         }
216     }
217     
218     function getBankPercent() public view returns(uint){
219         
220         uint contractBalance = address(this).balance;
221         
222         uint totalBank1 = bank1;
223         uint totalBank2 = bank2;
224         uint totalBank3 = bank3;
225         uint totalBank4 = bank4;
226         uint totalBank5 = bank5;
227         
228         if(contractBalance < totalBank1){
229             return(0);
230         }
231         if(contractBalance >= totalBank1 && contractBalance < totalBank2){
232             return(30);
233         }
234         if(contractBalance >= totalBank2 && contractBalance < totalBank3){
235             return(40);
236         }
237         if(contractBalance >= totalBank3 && contractBalance < totalBank4){
238             return(50);
239         }
240         if(contractBalance >= totalBank4 && contractBalance < totalBank5){
241             return(65);
242         }
243         if(contractBalance >= totalBank5){
244             return(80);
245         }
246     }
247 
248     function getIndividualPercent() public view returns(uint){
249         
250         uint userBalance = investors[msg.sender].deposit;
251         
252         uint totalDeposit1 = dep1;
253         uint totalDeposit2 = dep2;
254         uint totalDeposit3 = dep3;
255         uint totalDeposit4 = dep4;
256         
257         if(userBalance < totalDeposit1){
258             return(355);
259         }
260         if(userBalance >= totalDeposit1 && userBalance < totalDeposit2){
261             return(365);
262         }
263         if(userBalance >= totalDeposit2 && userBalance < totalDeposit3){
264             return(375);
265         }
266         if(userBalance >= totalDeposit3 && userBalance < totalDeposit4){
267             return(385); 
268         }
269         if(userBalance >= totalDeposit4){
270             return(400);
271         }
272     }
273     
274     function getInvestorCount() public view returns (uint) {
275         return addresses.length - 1;
276     }
277     
278     function bytesToAddress(bytes bys) private pure returns (address addr) {
279         assembly {
280             addr := mload(add(bys, 20))
281         }
282     }
283 
284 }