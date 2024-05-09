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
24 contract MyDice is DSSafeAddSub {
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
43 		_;
44     }
45 
46     /*
47      * checks payouts are currently active
48     */
49     modifier payoutsAreActive {
50 		require(payoutsPaused == false);
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
69 	bool public gamePaused;
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
84     uint public  underNumber = 5000;
85 
86     mapping (address => uint) playerPendingWithdrawals;
87 
88     /*
89      * events
90     */
91     /* Status: 0=lose, 1=win, 2=win + failed send,*/
92 	event LogResult(uint indexed BetID, address indexed PlayerAddress, uint indexed PlayerNumber, uint DiceResult, uint Value, int Status,uint BetValue,uint targetNumber);
93     /* log owner transfers */
94     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
95     /*test*/
96     event LogRandom(uint result,uint randomNum);
97 
98     /*
99      * init
100     */
101     function MyDice() {
102 
103         owner = msg.sender;
104 
105 
106         /* init 935 = 93.5% (6.5% houseEdge)*/
107         ownerSetHouseEdge(935);
108 
109         // 25,000 = 2.5% is our max profit of the house
110         ownerSetMaxProfitAsPercentOfHouse(25000);
111         /* init min bet (0.2 ether) */
112 
113         ownerSetMinBet(200000000000000000);
114 
115     }
116 
117     function GetRandomNumber() internal 
118         returns(uint randonmNumber)
119     {
120         nonce++;
121         randomNumber = randomNumber % block.timestamp + uint256(block.blockhash(block.number - 1));
122         randomNumber = randomNumber + block.timestamp * block.difficulty * block.number + 1;
123         randomNumber = randomNumber % 80100011001110010011000010110111001101011011110017;
124 
125         randomNumber = uint(sha3(randomNumber,nonce,10 + 10*1000000000000000000/msg.value));
126 
127         return (randomNumber % 10000 + 1);
128     }
129 
130     /*
131      * public function
132      * player submit bet
133      * only if game is active & bet is valid can query oraclize and set player vars
134     */
135     function playerRollDice(uint rollUnder) public
136         payable
137         gameIsActive
138         betIsValid(msg.value, rollUnder)
139 	{
140     
141         totalBets += 1;
142 
143         uint randReuslt = GetRandomNumber();
144         LogRandom(randReuslt,randomNumber);
145 
146         /*
147         * pay winner
148         * update contract balance to calculate new max bet
149         * send reward
150         * if send of reward fails save value to playerPendingWithdrawals
151         */
152         if(randReuslt < rollUnder){
153 
154             uint playerProfit = ((((msg.value * (maxNumber-(safeSub(rollUnder,1)))) / (safeSub(rollUnder,1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;
155 
156             /* safely reduce contract balance by player profit */
157             contractBalance = safeSub(contractBalance, playerProfit);
158 
159             /* safely calculate total payout as player profit plus original wager */
160             uint reward = safeAdd(playerProfit, msg.value);
161 
162             totalUserProfit = totalUserProfit + playerProfit; // total profits
163 
164             LogResult(totalBets, msg.sender, underNumber, randReuslt, reward, 1, msg.value,underNumber);
165 
166             /* update maximum profit */
167             setMaxProfit();
168 
169             /*
170             * send win - external call to an untrusted contract
171             * if send fails map reward value to playerPendingWithdrawals[address]
172             * for withdrawal later via playerWithdrawPendingTransactions
173             */
174             if(!msg.sender.send(reward)){
175                 LogResult(totalBets, msg.sender, underNumber, randReuslt, reward, 2, msg.value,underNumber);
176 
177                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
178                 playerPendingWithdrawals[msg.sender] = safeAdd(playerPendingWithdrawals[msg.sender], reward);
179             }
180 
181             return;
182         }
183 
184         /*
185         * no win
186         * send 1 wei to a losing bet
187         * update contract balance to calculate new max bet
188         */
189         if(randReuslt >= rollUnder){
190 
191             LogResult(totalBets, msg.sender, underNumber, randReuslt, msg.value, 0, msg.value,underNumber);
192 
193             /*
194             *  safe adjust contractBalance
195             *  setMaxProfit
196             *  send 1 wei to losing bet
197             */
198             contractBalance = safeAdd(contractBalance, msg.value-1);
199 
200             /* update maximum profit */
201             setMaxProfit();
202 
203             /*
204             * send 1 wei - external call to an untrusted contract
205             */
206             if(!msg.sender.send(1)){
207                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
208                playerPendingWithdrawals[msg.sender] = safeAdd(playerPendingWithdrawals[msg.sender], 1);
209             }
210 
211             return;
212 
213         }
214     }
215 
216 
217     /*
218     * public function
219     * in case of a failed refund or win send
220     */
221     function playerWithdrawPendingTransactions() public
222         payoutsAreActive
223         returns (bool)
224      {
225         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
226         playerPendingWithdrawals[msg.sender] = 0;
227         /* external call to untrusted contract */
228         if (msg.sender.call.value(withdrawAmount)()) {
229             return true;
230         } else {
231             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
232             /* player can try to withdraw again later */
233             playerPendingWithdrawals[msg.sender] = withdrawAmount;
234             return false;
235         }
236     }
237 
238     /* check for pending withdrawals  */
239     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
240         return playerPendingWithdrawals[addressToCheck];
241     }
242 
243     /*
244     * internal function
245     * sets max profit
246     */
247     function setMaxProfit() internal {
248         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxBetDivisor;
249     }
250 
251     /*
252     * owner address only functions
253     */
254     function ()
255         payable
256     {
257         playerRollDice(underNumber);
258     }
259 
260     function setNonce(uint value) public
261         onlyOwner
262     {
263         nonce = value;
264     }
265 
266     function ownerAddBankroll()
267     payable
268     onlyOwner
269     {
270         /* safely update contract balance */
271         contractBalance = safeAdd(contractBalance, msg.value);
272         /* update the maximum profit */
273         setMaxProfit();
274     }
275 
276     function getcontractBalance() public 
277     onlyOwner 
278     returns(uint)
279     {
280         return contractBalance;
281     }
282 
283     function getTotalBets() public
284     onlyOwner
285     returns(uint)
286     {
287         return totalBets;
288     }
289 
290     /* only owner address can set houseEdge */
291     function ownerSetHouseEdge(uint newHouseEdge) public
292 		onlyOwner
293     {
294         houseEdge = newHouseEdge;
295     }
296 
297     function getHouseEdge() public 
298     onlyOwner 
299     returns(uint)
300     {
301         return houseEdge;
302     }
303 
304     /* only owner address can set maxProfitAsPercentOfHouse */
305     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
306 		onlyOwner
307     {
308         /* restrict to maximum profit of 5% of total house balance*/
309         require(newMaxProfitAsPercent <= 50000);
310         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
311         setMaxProfit();
312     }
313 
314     function getMaxProfitAsPercentOfHouse() public 
315     onlyOwner 
316     returns(uint)
317     {
318         return maxProfitAsPercentOfHouse;
319     }
320 
321     /* only owner address can set minBet */
322     function ownerSetMinBet(uint newMinimumBet) public
323 		onlyOwner
324     {
325         minBet = newMinimumBet;
326     }
327 
328     function getMinBet() public 
329     onlyOwner 
330     returns(uint)
331     {
332         return minBet;
333     }
334 
335     /* only owner address can transfer ether */
336     function ownerTransferEther(address sendTo, uint amount) public
337 		onlyOwner
338     {
339         /* safely update contract balance when sending out funds*/
340         contractBalance = safeSub(contractBalance, amount);
341         /* update max profit */
342         setMaxProfit();
343         require(sendTo.send(amount));
344         LogOwnerTransfer(sendTo, amount);
345     }
346 
347     /* only owner address can set emergency pause #1 */
348     function ownerPauseGame(bool newStatus) public
349 		onlyOwner
350     {
351 		gamePaused = newStatus;
352     }
353 
354     /* only owner address can set emergency pause #2 */
355     function ownerPausePayouts(bool newPayoutStatus) public
356 		onlyOwner
357     {
358 		payoutsPaused = newPayoutStatus;
359     }
360 
361 
362     /* only owner address can set owner address */
363     function ownerChangeOwner(address newOwner) public
364 		onlyOwner
365 	{
366         owner = newOwner;
367     }
368 
369     /* only owner address can suicide - emergency */
370     function ownerkill() public
371 		onlyOwner
372 	{
373 		suicide(owner);
374 	}
375 
376 }