1 pragma solidity ^0.4.25;
2 
3 /**
4   CoinFlash contract: returns 111%-141% of each investment!
5 
6   Automatic payouts!
7 
8   No bugs, no backdoors, NO OWNER - fully automatic!
9 
10   Made and checked by professionals!
11  
12   1. Send any sum to smart contract address
13      - sum from 0.01 to 10 ETH
14      - min 250000 gas limit
15      - max 50 gwei gas price
16      - you are added to a queue
17   2. Wait a little bit
18   3. ...
19   4. PROFIT! You have got 111-141%
20 
21   How is that?
22   1. The first investor in the queue (you will become the
23      first in some time) receives next investments until
24      it become 111-141% of his initial investment.
25   
26   2. You will receive payments in several parts or all at once
27   
28   3. Once you receive 111-141% of your initial investment you are
29      removed from the queue.
30   
31   4. You can make multiple deposits
32   
33   5. The balance of this contract should normally be 0 because
34      all the money are immediately go to payouts
35   
36   6. The more deposits you make the more multiplier you get. See MULTIPLIERS var
37   
38   7. If you are the last depositor (no deposits after you in 20 mins)
39      you get 2% of all the ether that were on the contract. 
40      The last depositor Send 0 to withdraw it.
41      Do it BEFORE NEXT RESTART!
42   
43   8. The contract automatically restarts each 24 hours at 12:00 GMT
44   
45   9. Deposits will not be accepted 20 mins before next restart. But prize can be withdrawn.
46   
47 
48      So the last pays to the first (or to several first ones
49      if the deposit big enough) and the investors paid 111-141% are removed from the queue
50      
51 
52                 new investor --|               brand new investor --|
53                  investor5     |                 new investor       |
54                  investor4     |     =======>      investor5        |
55                  investor3     |                   investor4        |
56     (part. paid) investor2    <|                   investor3        |
57     (fully paid) investor1   <-|                   investor2   <----|  (pay until full %)
58 
59     快币合约: 几分钟内每笔投资返还111% - 141%
60     自动化转账
61     没有bug,没有后门,没有拥有者-完全自动化
62     由专业人士制作和检查
63     1. 发送金额到智能合约:
64      - 金额在0.01 - 10 ETH之间
65      - 最小GAS限制: 250000 wei
66      - 最大GAS价格: 50 Gwei
67      - 您将会被加入收益队列
68     2. 等一小会
69     3. ...
70     4. 获利! 你会获得111-114%的投资额
71 
72     - 具体过程
73     1. 当金额达到第一个在队列中的投资者的本金的111-141%时将获取下一个投资者的资金;
74     2. 你可以通过多次获取或者一次性获取收益;
75     3. 一旦你获取到的资金达到111-141%时,你将被移出队列;
76     4. 你可以进行多次投资;
77     5. 合约中的余额正常应该为0,因为通常所有入金都会立即兑付;
78     6. 你投资的次数越多, 你获得的收益越大;
79     7. 如果你是最后一个投资者(在20分钟内没有新进投资),你将获得本轮投资总额的2%奖金池, 最后一个投资者可以发送0ETH来提现;
80     8. 该合约在每天 20:00 时将自动重启;
81     9. 在重启前20分钟内不接受投资,但是奖池资金可以提取.
82     后一笔投资将会支付前一笔投资的收益(也可能是前几笔,如果后一笔投资的数额足够大的话)
83     投资者将会获取111-141%的回报,然后被移出队列
84 
85                  新的投资者   --|                  更新的投资者     --|
86                   投资者5       |                    新投资者        |
87                   投资者4       |     =======>       投资者5         |
88                   投资者3       |                    投资者4         |
89     (支付部分收益) 投资者2      <|                    投资者3         |
90     (支付全部收益) 投资者1     <-|                    投资者2    <----|  (当达到预期收益后支付)
91 */
92 
93 contract CoinFlash {
94     //Address for tech expences
95     address constant private TECH = 0x459ba253E69c77f14a83f61a4a11F068D84bD1e5;
96     //Address for promo expences
97     address constant private PROMO = 0x9D643A827dB1768f956fBAEd0616Aaa20F0C99c9;
98     uint constant public TECH_PERCENT = 3;
99     uint constant public PROMO_PERCENT = 3;
100     uint constant public PRIZE_PERCENT = 2;
101     uint constant public MAX_INVESTMENT = 10 ether;
102     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.05 ether;
103     uint constant public MAX_IDLE_TIME = 20 minutes; 
104 
105     uint8[] MULTIPLIERS = [
106         111, //For first deposit made at this stage
107         113, //For second
108         117, //For third
109         121, //For forth
110         125, //For fifth
111         130, //For sixth
112         135, //For seventh
113         141  //For eighth and on
114     ];
115 
116     struct Deposit {
117         address depositor;
118         uint128 deposit; 
119         uint128 expect;
120     }
121 
122     struct DepositCount {
123         int128 stage;
124         uint128 count;
125     }
126 
127     struct LastDepositInfo {
128         uint128 index;
129         uint128 time;
130     }
131 
132     Deposit[] private queue;
133     uint public currentReceiverIndex = 0;
134     uint public currentQueueSize = 0;
135     LastDepositInfo public lastDepositInfo;
136 
137     uint public prizeAmount = 0;
138     int public stage = 0;
139     mapping(address => DepositCount) public depositsMade;
140 
141 
142 
143     function () public payable {
144 	require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
145         if(msg.value > 0){
146             require(gasleft() >= 220000, "We require more gas!");
147             require(msg.value <= MAX_INVESTMENT, "The investment is too much!"); 
148 
149             checkAndUpdateStage();
150 
151             require(getStageStartTime(stage+1) >= now + MAX_IDLE_TIME);
152 
153             addDeposit(msg.sender, msg.value);
154 
155             pay();
156         }else if(msg.value == 0 && lastDepositInfo.index > 0 && msg.sender == queue[lastDepositInfo.index].depositor) {
157             withdrawPrize();
158         }
159     }
160 
161     function pay() private {
162         uint balance = address(this).balance;
163         uint128 money = 0;
164         if(balance > prizeAmount)
165             money = uint128(balance - prizeAmount);
166 
167         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
168 
169             Deposit storage dep = queue[i];
170 
171             if(money >= dep.expect){
172                 dep.depositor.transfer(dep.expect);
173 		        money -= dep.expect;
174 
175                 delete queue[i];
176             }else{
177                 dep.depositor.transfer(money); 
178                 dep.expect -= money;     
179                 break;                   
180             }
181 
182             if(gasleft() <= 50000)       
183                 break;                     
184         }
185 
186         currentReceiverIndex = i; 
187     }
188 
189     function addDeposit(address depositor, uint value) private {
190         DepositCount storage c = depositsMade[depositor];
191         if(c.stage != stage){
192             c.stage = int128(stage);
193             c.count = 0;
194         }
195 
196         if(value >= MIN_INVESTMENT_FOR_PRIZE)
197             lastDepositInfo = LastDepositInfo(uint128(currentQueueSize), uint128(now));
198 
199         uint multiplier = getDepositorMultiplier(depositor);
200         push(depositor, value, value*multiplier/100);
201 
202         c.count++;
203 
204         prizeAmount += value*PRIZE_PERCENT/100;
205 
206         uint support = value*TECH_PERCENT/100;
207         TECH.transfer(support);
208         uint adv = value*PROMO_PERCENT/100;
209         PROMO.transfer(adv);
210     }
211 
212     function checkAndUpdateStage() private{
213         int _stage = getCurrentStageByTime();
214 
215         require(_stage >= stage, "We should only go forward in time");
216 
217         if(_stage != stage){
218             proceedToNewStage(_stage);
219         }
220     }
221 
222     function proceedToNewStage(int _stage) private {
223         stage = _stage;
224         currentQueueSize = 0;
225         currentReceiverIndex = 0;
226         delete lastDepositInfo;
227     }
228 
229     function withdrawPrize() private {
230         require(lastDepositInfo.time > 0 && lastDepositInfo.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
231         require(currentReceiverIndex <= lastDepositInfo.index, "The last depositor should still be in queue");
232 
233         uint balance = address(this).balance;
234         if(prizeAmount > balance) 
235             prizeAmount = balance;
236 
237         uint prize = prizeAmount;
238         queue[lastDepositInfo.index].depositor.transfer(prize);
239 
240         prizeAmount = 0;
241         proceedToNewStage(stage + 1);
242     }
243 
244     function push(address depositor, uint deposit, uint expect) private {
245         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
246         assert(currentQueueSize <= queue.length); 
247         if(queue.length == currentQueueSize)
248             queue.push(dep);
249         else
250             queue[currentQueueSize] = dep;
251 
252         currentQueueSize++;
253     }
254 
255     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
256         Deposit storage dep = queue[idx];
257         return (dep.depositor, dep.deposit, dep.expect);
258     }
259 
260     function getDepositsCount(address depositor) public view returns (uint) {
261         uint c = 0;
262         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
263             if(queue[i].depositor == depositor)
264                 c++;
265         }
266         return c;
267     }
268 
269     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
270         uint c = getDepositsCount(depositor);
271 
272         idxs = new uint[](c);
273         deposits = new uint128[](c);
274         expects = new uint128[](c);
275 
276         if(c > 0) {
277             uint j = 0;
278             for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
279                 Deposit storage dep = queue[i];
280                 if(dep.depositor == depositor){
281                     idxs[j] = i;
282                     deposits[j] = dep.deposit;
283                     expects[j] = dep.expect;
284                     j++;
285                 }
286             }
287         }
288     }
289 
290     function getQueueLength() public view returns (uint) {
291         return currentQueueSize - currentReceiverIndex;
292     }
293 
294     function getDepositorMultiplier(address depositor) public view returns (uint) {
295         DepositCount storage c = depositsMade[depositor];
296         uint count = 0;
297         if(c.stage == getCurrentStageByTime())
298             count = c.count;
299         if(count < MULTIPLIERS.length)
300             return MULTIPLIERS[count];
301 
302         return MULTIPLIERS[MULTIPLIERS.length - 1];
303     }
304 
305     function getCurrentStageByTime() public view returns (int) {
306         return int(now - 12 hours) / 1 days - 17847; 
307     }
308 
309     function getStageStartTime(int _stage) public pure returns (uint) {
310         return 12 hours + uint(_stage + 17847)*1 days;
311     }
312 
313     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
314         if(currentReceiverIndex <= lastDepositInfo.index && lastDepositInfo.index < currentQueueSize){
315             Deposit storage d = queue[lastDepositInfo.index];
316             addr = d.depositor;
317             timeLeft = int(lastDepositInfo.time + MAX_IDLE_TIME) - int(now);
318         }
319     }
320 }