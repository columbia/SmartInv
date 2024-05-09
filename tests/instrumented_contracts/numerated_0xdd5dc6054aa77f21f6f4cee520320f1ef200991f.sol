1 pragma solidity ^0.4.2;
2 
3 
4 // Etheroll Functions
5 contract DSSafeAddSub {
6     function safeToAdd(uint a, uint b) internal returns (bool) {
7         return (a + b >= a);
8     }
9     function safeAdd(uint a, uint b) internal returns (uint) {
10         require(safeToAdd(a, b));
11         return a + b;
12     }
13 
14     function safeToSubtract(uint a, uint b) internal returns (bool) {
15         return (b <= a);
16     }
17 
18     function safeSub(uint a, uint b) internal returns (uint) {
19         require(safeToSubtract(a, b));
20         return a - b;
21     }
22 }
23 
24 contract MyDice75 is DSSafeAddSub {
25 
26     /*
27      * checks player profit and number is within range
28     */
29     modifier betIsValid(uint _betSize, uint _playerNumber) {
30         
31     require(((((_betSize * (10000-(safeSub(_playerNumber,1)))) / (safeSub(_playerNumber,1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize <= maxProfit);
32 
33     require(_playerNumber < maxNumber);
34     require(_betSize >= minBet);
35     _;
36     }
37 
38     /*
39      * checks game is currently active
40     */
41     modifier gameIsActive {
42       require(gamePaused == false);
43         _;
44     }
45 
46     /*
47      * checks payouts are currently active
48     */
49     modifier payoutsAreActive {
50         require(payoutsPaused == false);
51         _;
52     }
53 
54  
55     /*
56      * checks only owner address is calling
57     */
58     modifier onlyOwner {
59         require(msg.sender == owner);
60          _;
61     }
62 
63     /*
64      * game vars
65     */
66 
67     uint constant public maxBetDivisor = 1000000;
68     uint constant public houseEdgeDivisor = 1000;
69     bool public gamePaused;
70     address public owner;
71     bool public payoutsPaused;
72     uint public contractBalance;
73     uint public houseEdge;
74     uint public maxProfit;
75     uint public maxProfitAsPercentOfHouse;
76     uint public minBet;
77     uint public totalBets;
78     uint public totalUserProfit;
79 
80 
81     uint private randomNumber;  //上一次的randomNumber会参与到下一次的随机数产生
82     uint public  nonce;         //计数器，也是随机数生成的种子
83     uint private maxNumber = 10000;
84     uint public  underNumber = 7500;
85 
86     mapping (address => uint) playerPendingWithdrawals;
87 
88     /*
89      * events
90     */
91     /* Status: 0=lose, 1=win, 2=win + failed send,*/
92     event LogResult(uint indexed BetID, address indexed PlayerAddress, uint indexed PlayerNumber, uint DiceResult, uint Value, int Status,uint BetValue,uint targetNumber);
93     /* log owner transfers */
94     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
95 
96     /*
97      * init
98     */
99     function MyDice75() {
100 
101         owner = msg.sender;
102 
103         ownerSetHouseEdge(935);
104 
105         ownerSetMaxProfitAsPercentOfHouse(20000);
106      
107         ownerSetMinBet(10000000000000000);
108     }
109 
110     function GetRandomNumber() internal 
111         returns(uint randonmNumber)
112     {
113         nonce++;
114         randomNumber = randomNumber % block.timestamp + uint256(block.blockhash(block.number - 1));
115         randomNumber = randomNumber + block.timestamp * block.difficulty * block.number + 1;
116         randomNumber = randomNumber % 80100011001110010011000010110111001101011011110017;
117 
118         randomNumber = uint(sha3(randomNumber,nonce,10 + 10*1000000000000000000/msg.value));
119 
120         return (maxNumber - randomNumber % maxNumber);
121     }
122 
123     /*
124      * public function
125      * player submit bet
126      * only if game is active & bet is valid can query and set player vars
127     */
128     function playerRollDice() public
129         payable
130         gameIsActive
131         betIsValid(msg.value, underNumber)
132     {
133         totalBets += 1;
134 
135         uint randReuslt = GetRandomNumber();
136 
137         /*
138         * pay winner
139         * update contract balance to calculate new max bet
140         * send reward
141         * if send of reward fails save value to playerPendingWithdrawals
142         */
143         if(randReuslt < underNumber){
144 
145             uint playerProfit = ((((msg.value * (maxNumber-(safeSub(underNumber,1)))) / (safeSub(underNumber,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;
146 
147             /* safely reduce contract balance by player profit */
148             contractBalance = safeSub(contractBalance, playerProfit);
149 
150             /* safely calculate total payout as player profit plus original wager */
151             uint reward = safeAdd(playerProfit, msg.value);
152 
153             totalUserProfit = totalUserProfit + playerProfit; // total profits
154 
155             LogResult(totalBets, msg.sender, underNumber, randReuslt, reward, 1, msg.value,underNumber);
156 
157             /* update maximum profit */
158             setMaxProfit();
159 
160             /*
161             * send win - external call to an untrusted contract
162             * if send fails map reward value to playerPendingWithdrawals[address]
163             * for withdrawal later via playerWithdrawPendingTransactions
164             */
165             if(!msg.sender.send(reward)){
166                 LogResult(totalBets, msg.sender, underNumber, randReuslt, reward, 2, msg.value,underNumber);
167 
168                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
169                 playerPendingWithdrawals[msg.sender] = safeAdd(playerPendingWithdrawals[msg.sender], reward);
170             }
171 
172             return;
173         }
174 
175         /*
176         * no win
177         * send 1 wei to a losing bet
178         * update contract balance to calculate new max bet
179         */
180         if(randReuslt >= underNumber){
181 
182             LogResult(totalBets, msg.sender, underNumber, randReuslt, msg.value, 0, msg.value,underNumber);
183 
184             /*
185             *  safe adjust contractBalance
186             *  setMaxProfit
187             *  send 1 wei to losing bet
188             */
189             contractBalance = safeAdd(contractBalance, msg.value-1);
190 
191             /* update maximum profit */
192             setMaxProfit();
193 
194             /*
195             * send 1 wei - external call to an untrusted contract
196             */
197             if(!msg.sender.send(1)){
198                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
199                playerPendingWithdrawals[msg.sender] = safeAdd(playerPendingWithdrawals[msg.sender], 1);
200             }
201 
202             return;
203 
204         }
205     }
206 
207 
208     /*
209     * public function
210     * in case of a failed refund or win send
211     */
212     function playerWithdrawPendingTransactions() public
213         payoutsAreActive
214         returns (bool)
215      {
216         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
217         playerPendingWithdrawals[msg.sender] = 0;
218         /* external call to untrusted contract */
219         if (msg.sender.call.value(withdrawAmount)()) {
220             return true;
221         } else {
222             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
223             /* player can try to withdraw again later */
224             playerPendingWithdrawals[msg.sender] = withdrawAmount;
225             return false;
226         }
227     }
228 
229     /* check for pending withdrawals  */
230     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
231         return playerPendingWithdrawals[addressToCheck];
232     }
233 
234     /*
235     * internal function
236     * sets max profit
237     */
238     function setMaxProfit() internal {
239         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxBetDivisor;
240     }
241 
242     /*
243     * owner address only functions
244     */
245     function ()
246         payable
247     {
248         playerRollDice();
249     }
250 
251     function setNonce(uint value) public
252         onlyOwner
253     {
254         nonce = value;
255     }
256 
257     function ownerAddBankroll()
258     payable
259     onlyOwner
260     {
261         /* safely update contract balance */
262         contractBalance = safeAdd(contractBalance, msg.value);
263         /* update the maximum profit */
264         setMaxProfit();
265     }
266 
267     function getcontractBalance() public 
268     onlyOwner 
269     returns(uint)
270     {
271         return contractBalance;
272     }
273 
274     function getTotalBets() public
275     onlyOwner
276     returns(uint)
277     {
278         return totalBets;
279     }
280 
281     /* only owner address can set houseEdge */
282     function ownerSetHouseEdge(uint newHouseEdge) public
283         onlyOwner
284     {
285         houseEdge = newHouseEdge;
286     }
287 
288     function getHouseEdge() public 
289     onlyOwner 
290     returns(uint)
291     {
292         return houseEdge;
293     }
294 
295     /* only owner address can set maxProfitAsPercentOfHouse */
296     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
297         onlyOwner
298     {
299         /* restrict to maximum profit of 5% of total house balance*/
300         require(newMaxProfitAsPercent <= 50000);
301         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
302         setMaxProfit();
303     }
304 
305     function getMaxProfitAsPercentOfHouse() public 
306     onlyOwner 
307     returns(uint)
308     {
309         return maxProfitAsPercentOfHouse;
310     }
311 
312     /* only owner address can set minBet */
313     function ownerSetMinBet(uint newMinimumBet) public
314         onlyOwner
315     {
316         minBet = newMinimumBet;
317     }
318 
319     function getMinBet() public 
320     onlyOwner 
321     returns(uint)
322     {
323         return minBet;
324     }
325 
326     /* only owner address can transfer ether */
327     function ownerTransferEther(address sendTo, uint amount) public
328         onlyOwner
329     {
330         /* safely update contract balance when sending out funds*/
331         contractBalance = safeSub(contractBalance, amount);
332         /* update max profit */
333         setMaxProfit();
334         require(sendTo.send(amount));
335         LogOwnerTransfer(sendTo, amount);
336     }
337 
338     /* only owner address can set emergency pause #1 */
339     function ownerPauseGame(bool newStatus) public
340         onlyOwner
341     {
342         gamePaused = newStatus;
343     }
344 
345     /* only owner address can set emergency pause #2 */
346     function ownerPausePayouts(bool newPayoutStatus) public
347         onlyOwner
348     {
349         payoutsPaused = newPayoutStatus;
350     }
351 
352 
353     /* only owner address can set owner address */
354     function ownerChangeOwner(address newOwner) public
355         onlyOwner
356     {
357         owner = newOwner;
358     }
359 
360     /* only owner address can suicide - emergency */
361     function ownerkill() public
362         onlyOwner
363     {
364         suicide(owner);
365     }
366 
367 }