1 pragma solidity ^0.4.24;
2 
3 /*
4 * ETHERLIFE INTERNATIONAL ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 * Web:               https://etherlife.io
6 * Telegram_channel:  https://t.me/etherlife
7 * EN  Telegram_chat: https://t.me/etherlife_eng
8 * RU  Telegram_chat: https://t.me/EtherLife_rus
9 * Email:             support@etherlife.io
10 * 
11 * 
12 *  - GAIN 4% - 0,5% per 24 HOURS
13 *  - Life-long payments
14 *  - The revolutionary reliability
15 *  - Minimal contribution 0.1 eth
16 *  - Currency and payment - ETH only
17 *  - Contribution allocation schemes:
18 *       - 89% payments;
19 *       - 4% marketing;
20 *       - 7% technical support & dev.
21 *
22 * HOW TO USE:
23 *  1. Send from ETH wallet to the smart contract address 0x29BeF3878B85522Ef2AFA541dD7477c9e0a2c122 any amount from 0.1 ETH.
24 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
25 *     of your wallet.
26 *  3a. Claim your profit by sending 0 ether transaction.
27 *  OR
28 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the 
29 *      accrued interest automatically summed to your new contribution.
30 *
31 * RECOMMEND
32 * GAS LIMIT: 200000
33 * GAS PRICE: https://ethgasstation.info/
34 * 
35 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet. 
36 *
37 * AFFILIATE PROGRAM:
38 * 1 LEVEL - 2 %
39 * 2 LEVEL - 1 %
40 * 3 LEVEL - 0.5 %
41 * 4 LEVEL - 0.25 %
42 * 5 LEVEL - 0.25 %
43 *
44 * ATTENTION!
45 * It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
46 * have private keys.
47 *
48 * Contracts reviewed and approved by octopus.
49 */
50 
51 
52 library SafeMath {
53 
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
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
82 contract EtherLife
83 {   
84     using SafeMath for uint;
85     address public owner;
86     
87     struct deposit {
88         uint time;
89         uint value;
90         uint timeOfLastWithdraw;
91     }
92     
93     mapping(address => deposit) public deposits;
94     mapping(address => address) public parents;
95     address[] public investors;
96     
97     uint public constant minDepositSum = 100 finney; // 0.1 ether;
98     
99     event Deposit(address indexed from, uint256 value, uint256 startTime);
100     event Withdraw(address indexed from, uint256 value);
101     event ReferrerBonus(address indexed from, address indexed to, uint8 level, uint256 value);
102     
103     constructor () public 
104     {
105         owner = msg.sender;
106     }
107     
108     modifier checkSender() 
109     {
110         require(msg.sender != address(0));
111         _;
112     }
113     
114     function bytesToAddress(bytes source) internal pure returns(address parsedAddress) 
115     {
116         assembly {
117             parsedAddress := mload(add(source,0x14))
118         }
119         return parsedAddress;
120     }
121 
122     function () checkSender public payable 
123     {
124         if(msg.value == 0)
125         {
126             withdraw();
127             return;
128         }
129         
130         require(msg.value >= minDepositSum);
131         
132         uint bonus = checkReferrer(msg.sender, msg.value);
133         
134         payFee(msg.value);
135         addDeposit(msg.sender, msg.value, bonus);
136         
137         payRewards(msg.sender, msg.value);
138     }
139     
140     function getInvestorsLength() public view returns (uint)
141     {
142         return investors.length;
143     }
144     
145     function getParents(address investorAddress) public view returns (address[])
146     {
147         address[] memory refLevels = new address[](5);
148         address current = investorAddress;
149         
150         for(uint8 i = 0; i < 5; i++)
151         {
152              current = parents[current];
153              if(current == address(0)) break;
154              refLevels[i] = current;
155         }
156         
157         return refLevels;
158     }
159     
160     function calculateRewardForLevel(uint8 level, uint value) public pure returns (uint)
161     {
162         if(level == 1) return value.div(50);           // 2%
163         if(level == 2) return value.div(100);          // 1%
164         if(level == 3) return value.div(200);          // 0.5%
165         if(level == 4) return value.div(400);          // 0.25%
166         if(level == 5) return value.div(400);          // 0.25%
167         
168         return 0;
169     }
170     
171     function calculateWithdrawalSumForPeriod(uint period, uint depositValue, uint duration) public pure returns (uint)
172     {
173         if(period == 1) return depositValue * 4 / 100 * duration / 1 days;          // 4%
174         else if(period == 2) return depositValue * 3 / 100 * duration / 1 days;     // 3%
175         else if(period == 3) return depositValue * 2 / 100 * duration / 1 days;     // 2%
176         else if(period == 4) return depositValue / 100 * duration / 1 days;         // 1%
177         else if(period == 5) return depositValue / 200 * duration / 1 days;         // 0.5%
178         return 0;
179     }
180     
181     function calculateWithdrawalSum(uint currentTime, uint depositTime, uint depositValue, uint timeOfLastWithdraw) public pure returns (uint)
182     {
183         uint startTime = 0;
184         uint endTime = 0;
185         uint sum = 0;
186         int duration = 0;
187         
188         uint timeEndOfPeriod = 0;
189         uint timeEndOfPrevPeriod = 0;
190         
191         for(uint i = 1; i <= 5; i++)
192         {
193             timeEndOfPeriod = depositTime.add(i.mul(30 days));
194             
195             if(i == 1)
196             {
197                 startTime = timeOfLastWithdraw;
198                 endTime = currentTime > timeEndOfPeriod ? timeEndOfPeriod : currentTime;
199             }
200             else if(i == 5) 
201             {
202                 timeEndOfPrevPeriod = timeEndOfPeriod.sub(30 days);
203                 startTime = timeOfLastWithdraw > timeEndOfPrevPeriod ? timeOfLastWithdraw : timeEndOfPrevPeriod;
204                 endTime = currentTime;
205             }
206             else
207             {
208                 timeEndOfPrevPeriod = timeEndOfPeriod.sub(30 days);
209                 startTime = timeOfLastWithdraw > timeEndOfPrevPeriod ? timeOfLastWithdraw : timeEndOfPrevPeriod;
210                 endTime = currentTime > timeEndOfPeriod ? timeEndOfPeriod : currentTime;    
211             }
212             
213             duration = int(endTime - startTime);
214             if(duration >= 0)
215             {
216                 sum = sum.add(calculateWithdrawalSumForPeriod(i, depositValue, uint(duration)));
217                 timeOfLastWithdraw = endTime;
218             }
219         }
220         
221         return sum;
222     }
223     
224     function checkReferrer(address investorAddress, uint weiAmount) internal returns (uint)
225     {
226         if(deposits[investorAddress].value == 0 && msg.data.length == 20)
227         {
228             address referrerAddress = bytesToAddress(bytes(msg.data));
229             require(referrerAddress != investorAddress);     
230             require(deposits[referrerAddress].value > 0);        
231             
232             parents[investorAddress] = referrerAddress;
233             return weiAmount / 100; // 1%
234         }
235         
236         return 0;
237     }
238     
239     function payRewards(address investorAddress, uint depositValue) internal
240     {   
241         address[] memory parentAddresses = getParents(investorAddress);
242         for(uint8 i = 0; i < parentAddresses.length; i++)
243         {
244             address parent = parentAddresses[i];
245             if(parent == address(0)) break;
246             
247             uint rewardValue = calculateRewardForLevel(i + 1, depositValue);
248             parent.transfer(rewardValue);
249             
250             emit ReferrerBonus(investorAddress, parent, i + 1, rewardValue);
251         }
252     }
253     
254     function addDeposit(address investorAddress, uint weiAmount, uint bonus) internal
255     {   
256         if(deposits[investorAddress].value == 0)
257         {
258             deposits[investorAddress].time = now;
259             deposits[investorAddress].timeOfLastWithdraw = deposits[investorAddress].time;
260             deposits[investorAddress].value = weiAmount.add(bonus);
261             investors.push(investorAddress);
262         }
263         else
264         {
265             payWithdraw(investorAddress);
266             deposits[investorAddress].value = deposits[investorAddress].value.add(weiAmount);
267         }
268         
269         emit Deposit(msg.sender, msg.value, deposits[investorAddress].timeOfLastWithdraw);
270     }
271     
272     function payFee(uint weiAmount) internal
273     {
274         uint fee = weiAmount.mul(11).div(100); // 11%
275         owner.transfer(fee);
276     }
277     
278     function calculateNewTime(uint startTime, uint endTime) public pure returns (uint) 
279     {
280         uint daysCount = endTime.sub(startTime).div(1 days);
281         return startTime.add(daysCount.mul(1 days));
282     }
283     
284     function payWithdraw(address to) internal
285     {
286         require(deposits[to].value > 0);
287         require(now - deposits[to].timeOfLastWithdraw >= 1 days);
288         
289         uint sum = calculateWithdrawalSum(now, deposits[to].time, deposits[to].value, deposits[to].timeOfLastWithdraw);
290         require(sum > 0);
291         
292         deposits[to].timeOfLastWithdraw = now;
293         
294         to.transfer(sum);
295         emit Withdraw(to, sum);
296     }
297     
298     function withdraw() checkSender public
299     {
300         payWithdraw(msg.sender);
301     }
302 }