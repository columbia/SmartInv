1 pragma solidity ^0.4.23;
2 
3 contract SafeMath {
4     function safeToAdd(uint a, uint b) pure internal returns (bool) {
5         return (a + b >= a);
6     }
7     function safeAdd(uint a, uint b) pure internal returns (uint) {
8         require(safeToAdd(a, b));
9         return a + b;
10     }
11 
12     function safeToSubtract(uint a, uint b) pure internal returns (bool) {
13         return (b <= a);
14     }
15 
16     function safeSub(uint a, uint b) pure internal returns (uint) {
17         require(safeToSubtract(a, b));
18         return a - b;
19     }
20 }
21 
22 contract DiceRoll is SafeMath {
23 
24     address public owner;
25     uint constant public maxProfitDivisor = 1000000;
26     uint constant public houseEdgeDivisor = 1000;
27     uint constant public maxNumber = 99;
28     uint constant public minNumber = 1;
29 
30     bool public gamePaused;
31     bool public recommendPaused;
32     bool public jackpotPaused;
33 
34     uint public contractBalance;
35     uint public houseEdge;
36     uint public maxProfit;
37     uint public maxProfitAsPercentOfHouse;
38     uint public minBet;
39     uint public maxBet;
40     uint public jackpotOfHouseEdge;
41     uint public minJackpotBet;
42     uint public recommendProportion;
43     address public jackpotContract;
44     
45     uint public jackpot;
46     uint public totalWeiWon;
47     uint public totalWeiWagered;
48     uint public totalBets;
49 
50     uint public betId;
51     uint public random;
52     uint public probability;
53     uint public playerProfit;
54     uint public playerTempReward;
55     uint256 seed;
56 
57     modifier betIsValid(uint _betSize, uint _start, uint _end) {
58         require(_betSize >= minBet && _betSize <= maxBet && _start >= minNumber && _end <= maxNumber);
59         _;
60     }
61     
62     modifier oddEvenBetIsValid(uint _betSize, uint _oddeven) {
63         require(_betSize >= minBet && _betSize <= maxBet && (_oddeven == 1 || _oddeven == 0));
64         _;
65     }
66 
67     modifier gameIsActive {
68         require(!gamePaused);
69         _;
70     }
71     
72     modifier recommendAreActive {
73         require(!recommendPaused);
74         _;
75     }
76 
77     modifier jackpotAreActive {
78         require(!jackpotPaused);
79         _;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87 
88     event LogResult(uint indexed BetID, address indexed PlayerAddress, uint DiceResult, uint Value, uint Status, uint Start, uint End, uint oddeven, uint BetValue);
89     event LogJackpot(uint indexed BetID, address indexed PlayerAddress, uint jackpotValue);
90     event LogRecommendProfit(uint indexed BetID, address indexed PlayerAddress, uint Profit);
91     event LogOwnerTransfer(address SentToAddress, uint AmountTransferred);
92     
93 
94     function() public payable{
95         contractBalance = safeAdd(contractBalance, msg.value);
96         setMaxProfit();
97     }
98 
99     constructor() public {
100         owner = msg.sender;
101         ownerSetHouseEdge(20);
102         ownerSetMaxProfitAsPercentOfHouse(100000);
103         ownerSetMinBet(0.1 ether);
104         ownerSetMaxBet(1 ether);
105         ownerSetJackpotOfHouseEdge(500);
106         ownerSetRecommendProportion(100);
107         ownerSetMinJackpoBet(0.1 ether);
108     }
109 
110     function playerRoll(uint start, uint end, address inviter) public payable gameIsActive betIsValid(msg.value, start, end) {
111         betId += 1;
112         probability = end - start + 1;
113         playerProfit = getDiceWinAmount(msg.value, probability);
114         if(playerProfit > maxProfit) playerProfit = maxProfit;
115         random = rand() % 100 + 1;
116         totalBets += 1;
117         totalWeiWagered += msg.value;
118         if(start <= random && random <= end){
119             contractBalance = safeSub(contractBalance, playerProfit); 
120             totalWeiWon = safeAdd(totalWeiWon, playerProfit);
121             playerTempReward = safeAdd(playerProfit, msg.value);
122             emit LogResult(betId, msg.sender, random, playerProfit, 1, start, end, 0, msg.value);
123             setMaxProfit();
124             uint playerHouseEdge = getHouseEdgeAmount(msg.value, probability);
125             increaseJackpot(getJackpotFee(playerHouseEdge),betId);
126             if(inviter != address(0)){
127                 emit LogRecommendProfit(betId, msg.sender, playerProfit);
128                 sendProportion(inviter, playerHouseEdge * recommendProportion / 1000);
129             }
130             msg.sender.transfer(playerTempReward);
131             return;
132         }else{
133             emit LogResult(betId, msg.sender, random, 0, 0, start, end, 0, msg.value);
134             contractBalance = safeAdd(contractBalance, (msg.value-1));                                                                      
135             setMaxProfit();          
136             msg.sender.transfer(1);
137             return;
138         }
139 
140     }
141 
142     function oddEven(uint oddeven, address inviter) public payable gameIsActive oddEvenBetIsValid(msg.value, oddeven) {
143         betId += 1;
144         probability = 50;
145         playerProfit = getDiceWinAmount(msg.value, probability);
146         if(playerProfit > maxProfit) playerProfit = maxProfit;
147         random = rand() % 100 + 1;
148         totalBets += 1;
149         totalWeiWagered += msg.value;
150         if(random % 2 == oddeven){
151             contractBalance = safeSub(contractBalance, playerProfit); 
152             totalWeiWon = safeAdd(totalWeiWon, playerProfit);
153             playerTempReward = safeAdd(playerProfit, msg.value); 
154             emit LogResult(betId, msg.sender, random, playerProfit, 1, 0, 0, oddeven, msg.value);
155             setMaxProfit();
156             uint playerHouseEdge = getHouseEdgeAmount(msg.value, probability);
157             increaseJackpot(getJackpotFee(playerHouseEdge),betId);
158             if(inviter != address(0)){
159                 emit LogRecommendProfit(betId, msg.sender, playerProfit);
160                 sendProportion(inviter, playerHouseEdge * recommendProportion / 1000);
161             }
162             msg.sender.transfer(playerTempReward);  
163             return;
164         }else{
165             emit LogResult(betId, msg.sender, random, playerProfit, 0, 0, 0, oddeven, msg.value); 
166             contractBalance = safeAdd(contractBalance, (msg.value-1));
167             setMaxProfit();         
168             msg.sender.transfer(1);
169             return;
170         }
171     }
172 
173     function sendProportion(address inviter, uint amount) internal {
174         require(amount < contractBalance);
175         inviter.transfer(amount);
176     }
177 
178 
179     function increaseJackpot(uint increaseAmount, uint _betId) internal {
180         require (increaseAmount <= contractBalance);
181         emit LogJackpot(_betId, msg.sender, increaseAmount);
182         jackpot += increaseAmount;
183         jackpotContract.transfer(increaseAmount);
184         if(msg.value >= minJackpotBet){
185             bool result = jackpotContract.call(bytes4(keccak256("addPlayer(address)")),msg.sender);
186             require(result);
187         }
188         
189     }
190 
191     function getDiceWinAmount(uint _amount, uint _probability) view internal returns (uint) {
192         require(_probability > 0 && _probability < 100);
193         return ((_amount * (100 - _probability) / _probability + _amount) * (houseEdgeDivisor - houseEdge) / houseEdgeDivisor) - _amount;
194     }
195 
196     function getHouseEdgeAmount(uint _amount, uint _probability) view internal returns (uint) {
197         require(_probability > 0 && _probability < 100);
198         return (_amount * (100 - _probability) / _probability + _amount) * houseEdge / houseEdgeDivisor;
199     }
200 
201     function getJackpotFee(uint houseEdgeAmount) view internal returns (uint) {
202         return houseEdgeAmount * jackpotOfHouseEdge / 1000;
203     }
204 
205     function rand() internal returns (uint256) {
206         seed = uint256(keccak256(msg.sender, blockhash(block.number - 1), block.coinbase, block.difficulty));
207         return seed;
208     }
209 
210     function OwnerSetPrizePool(address _addr) external onlyOwner {
211         require(_addr != address(0));
212         jackpotContract = _addr;
213     }
214 
215     function ownerUpdateContractBalance(uint newContractBalanceInWei) public onlyOwner{
216         contractBalance = newContractBalanceInWei;
217     }
218 
219     function ownerSetHouseEdge(uint newHouseEdge) public onlyOwner{
220         require(newHouseEdge <= 1000);
221         houseEdge = newHouseEdge;
222     }
223 
224     function ownerSetMinJackpoBet(uint newVal) public onlyOwner{
225         require(newVal <= 10 ether);
226         minJackpotBet = newVal;
227     }
228 
229     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public onlyOwner{
230         require(newMaxProfitAsPercent <= 100000);
231         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
232         setMaxProfit();
233     }
234 
235     function ownerSetMinBet(uint newMinimumBet) public onlyOwner{
236         minBet = newMinimumBet;
237     }
238 
239     function ownerSetMaxBet(uint newMaxBet) public onlyOwner{
240         maxBet = newMaxBet;
241     }
242 
243     function ownerSetJackpotOfHouseEdge(uint newProportion) public onlyOwner{
244         require(newProportion <= 1000);
245         jackpotOfHouseEdge = newProportion;
246     }
247 
248     function ownerSetRecommendProportion(uint newRecommendProportion) public onlyOwner{
249         require(newRecommendProportion <= 1000);
250         recommendProportion = newRecommendProportion;
251     }
252     
253     function setMaxProfit() internal {
254         maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;  
255     }
256     
257     function ownerSetjackpotContract(address newJackpotContract) public onlyOwner{
258         jackpotContract = newJackpotContract;
259     }
260 
261 
262     function ownerPauseGame(bool newStatus) public onlyOwner{
263         gamePaused = newStatus;
264     }
265 
266     function ownerPauseJackpot(bool newStatus) public onlyOwner{
267         jackpotPaused = newStatus;
268     }
269 
270     function ownerPauseRecommend(bool newStatus) public onlyOwner{
271         recommendPaused = newStatus;
272     }
273 
274     function ownerTransferEther(address sendTo, uint amount) public onlyOwner{        
275         contractBalance = safeSub(contractBalance, amount);		
276         setMaxProfit();
277         sendTo.transfer(amount);
278         emit LogOwnerTransfer(sendTo, amount);
279     }
280 
281     function ownerChangeOwner(address newOwner) public onlyOwner{
282         owner = newOwner;
283     }
284 
285     function ownerkill() public onlyOwner{
286         selfdestruct(owner);
287     }
288 }