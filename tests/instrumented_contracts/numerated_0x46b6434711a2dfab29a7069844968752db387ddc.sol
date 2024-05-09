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
25     uint8 constant public maxNumber = 99;
26     uint8 constant public minNumber = 1;
27 
28     bool public gamePaused;
29     bool public recommendPaused;
30     bool public jackpotPaused;
31 
32     uint256 public contractBalance;
33     uint16 public houseEdge;
34     uint256 public maxProfit;
35     uint16 public maxProfitAsPercentOfHouse;
36     uint256 public minBet;
37     uint256 public maxBet;
38     uint16 public jackpotOfHouseEdge;
39     uint256 public minJackpotBet;
40     uint256 public recommendProportion;
41     uint256 playerProfit;
42     
43     uint256 public jackpotBlance;
44     address[] public jackpotPlayer;
45     uint256 public JackpotPeriods = 1;
46     uint64 public nextJackpotTime;
47     uint16 public jackpotPersent = 100;
48     
49     uint256 public totalWeiWon;
50     uint256 public totalWeiWagered;
51 
52     uint256 public betId;
53     uint256 seed;
54 
55     modifier betIsValid(uint256 _betSize, uint8 _start, uint8 _end) {
56         require(_betSize >= minBet && _betSize <= maxBet && _start >= minNumber && _end <= maxNumber);
57         _;
58     }
59     
60     modifier oddEvenBetIsValid(uint256 _betSize, uint8 _oddeven) {
61         require(_betSize >= minBet && _betSize <= maxBet && (_oddeven == 1 || _oddeven == 0));
62         _;
63     }
64 
65     modifier gameIsActive {
66         require(!gamePaused);
67         _;
68     }
69     
70     modifier recommendAreActive {
71         require(!recommendPaused);
72         _;
73     }
74 
75     modifier jackpotAreActive {
76         require(!jackpotPaused);
77         _;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85 
86     event LogResult(uint256 indexed BetID, address indexed PlayerAddress, uint8 DiceResult, uint256 Value, uint8 Status, uint8 Start, uint8 End, uint8 oddeven, uint256 BetValue);
87     event LogJackpot(uint indexed BetID, address indexed PlayerAddress, uint jackpotValue);
88     event LogRecommendProfit(uint indexed BetID, address indexed PlayerAddress, uint Profit);
89     event LogOwnerTransfer(address SentToAddress, uint AmountTransferred);
90     event SendJackpotSuccesss(address indexed winner, uint256 amount, uint256 JackpotPeriods);
91     
92 
93     function() public payable{
94         contractBalance = safeAdd(contractBalance, msg.value);
95         setMaxProfit();
96     }
97 
98     constructor() public {
99         owner = msg.sender;
100         houseEdge = 20; //2%
101         maxProfitAsPercentOfHouse = 100; //10%
102         minBet = 0.1 ether;
103         maxBet = 1 ether;
104         jackpotOfHouseEdge = 500; //50%
105         recommendProportion = 100; //10%
106         minJackpotBet = 0.1 ether;
107         jackpotPersent = 100; //10%
108     }
109 
110     function playerRoll(uint8 start, uint8 end, address inviter) public payable gameIsActive betIsValid(msg.value, start, end) {
111         betId += 1;
112         uint8 probability = end - start + 1;
113         playerProfit = ((msg.value * (100 - probability) / probability + msg.value) * (1000 - houseEdge) / 1000) - msg.value;
114         if(playerProfit > maxProfit) playerProfit = maxProfit;
115         uint8 random = uint8(rand() % 100 + 1);
116         totalWeiWagered += msg.value;
117         if(start <= random && random <= end){
118             totalWeiWon = safeAdd(totalWeiWon, playerProfit);
119             contractBalance = safeSub(contractBalance, playerProfit);
120             uint256 payout = safeAdd(playerProfit, msg.value);
121             setMaxProfit();
122             emit LogResult(betId, msg.sender, random, playerProfit, 1, start, end, 2, msg.value);
123 
124             uint256 houseEdgeFee = getHouseEdgeFee(probability, msg.value);
125             increaseJackpot(houseEdgeFee * jackpotOfHouseEdge / 1000, betId);
126             
127             if(inviter != address(0)){
128                 emit LogRecommendProfit(betId, msg.sender, playerProfit);
129                 sendProportion(inviter, houseEdgeFee * recommendProportion / 1000);
130             }
131             
132             msg.sender.transfer(payout);
133             return;
134         }else{
135             emit LogResult(betId, msg.sender, random, 0, 0, start, end, 2, msg.value);    
136             contractBalance = safeAdd(contractBalance, (msg.value-1));                                                      
137             setMaxProfit();
138             msg.sender.transfer(1);
139             return;
140         }
141 
142     }
143 
144     function oddEven(uint8 oddeven, address inviter) public payable gameIsActive oddEvenBetIsValid(msg.value, oddeven) {
145         betId += 1;
146         uint8 probability = 50;
147         playerProfit = ((msg.value * (100 - probability) / probability + msg.value) * (1000 - houseEdge) / 1000) - msg.value;
148         if(playerProfit > maxProfit) playerProfit = maxProfit;
149         uint8 random = uint8(rand() % 100 + 1);
150         totalWeiWagered += msg.value;
151         if(random % 2 == oddeven){
152             totalWeiWon = safeAdd(totalWeiWon, playerProfit);
153             contractBalance = safeSub(contractBalance, playerProfit);
154             uint256 payout = safeAdd(playerProfit, msg.value);
155             setMaxProfit();
156             emit LogResult(betId, msg.sender, random, playerProfit, 1, 0, 0, oddeven, msg.value);
157             
158             uint256 houseEdgeFee = getHouseEdgeFee(probability, msg.value);
159             increaseJackpot(houseEdgeFee * jackpotOfHouseEdge / 1000, betId);
160             
161             if(inviter != address(0)){
162                 emit LogRecommendProfit(betId, msg.sender, playerProfit);
163                 sendProportion(inviter, houseEdgeFee * recommendProportion / 1000);
164             }
165             
166             msg.sender.transfer(payout);  
167             return;
168         }else{
169             emit LogResult(betId, msg.sender, random, 0, 0, 0, 0, oddeven, msg.value); 
170             contractBalance = safeAdd(contractBalance, (msg.value-1));
171             setMaxProfit();
172             msg.sender.transfer(1);
173             return;
174         }
175     }
176 
177     function sendProportion(address inviter, uint256 amount) internal {
178         require(amount < contractBalance);
179         contractBalance = safeSub(contractBalance, amount);
180         inviter.transfer(amount);
181     }
182 
183 
184     function increaseJackpot(uint256 increaseAmount, uint256 _betId) internal {
185         require(increaseAmount < maxProfit);
186         emit LogJackpot(_betId, msg.sender, increaseAmount);
187         jackpotBlance = safeAdd(jackpotBlance, increaseAmount);
188         contractBalance = safeSub(contractBalance, increaseAmount);
189         if(msg.value >= minJackpotBet){
190             jackpotPlayer.push(msg.sender);
191         }
192     }
193     
194     function createWinner() public onlyOwner jackpotAreActive {
195         uint64 tmNow = uint64(block.timestamp);
196         require(tmNow >= nextJackpotTime);
197         require(jackpotPlayer.length > 0);
198         nextJackpotTime = tmNow + 72000;
199         JackpotPeriods += 1;
200         uint random = rand() % jackpotPlayer.length;
201         address winner = jackpotPlayer[random - 1];
202         jackpotPlayer.length = 0;
203         sendJackpot(winner);
204     }
205     
206     function sendJackpot(address winner) public onlyOwner jackpotAreActive {
207         uint256 amount = jackpotBlance * jackpotPersent / 1000;
208         require(jackpotBlance > amount);
209         emit SendJackpotSuccesss(winner, amount, JackpotPeriods);
210         jackpotBlance = safeSub(jackpotBlance, amount);
211         winner.transfer(amount);
212     }
213     
214     function sendValueToJackpot() payable public jackpotAreActive {
215         jackpotBlance = safeAdd(jackpotBlance, msg.value);
216     }
217     
218     function getHouseEdgeFee(uint256 _probability, uint256 _betValue) view internal returns (uint256){
219         return (_betValue * (100 - _probability) / _probability + _betValue) * houseEdge / 1000;
220     }
221 
222 
223     function rand() internal returns (uint256) {
224         seed = uint256(keccak256(msg.sender, blockhash(block.number - 1), block.coinbase, block.difficulty));
225         return seed;
226     }
227 
228     function setMaxProfit() internal {
229         maxProfit = contractBalance * maxProfitAsPercentOfHouse / 1000;  
230     }
231 
232     function ownerSetHouseEdge(uint16 newHouseEdge) public onlyOwner{
233         require(newHouseEdge <= 1000);
234         houseEdge = newHouseEdge;
235     }
236 
237     function ownerSetMinJackpoBet(uint256 newVal) public onlyOwner{
238         require(newVal <= 1 ether);
239         minJackpotBet = newVal;
240     }
241 
242     function ownerSetMaxProfitAsPercentOfHouse(uint8 newMaxProfitAsPercent) public onlyOwner{
243         require(newMaxProfitAsPercent <= 1000);
244         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
245         setMaxProfit();
246     }
247 
248     function ownerSetMinBet(uint256 newMinimumBet) public onlyOwner{
249         minBet = newMinimumBet;
250     }
251 
252     function ownerSetMaxBet(uint256 newMaxBet) public onlyOwner{
253         maxBet = newMaxBet;
254     }
255 
256     function ownerSetJackpotOfHouseEdge(uint16 newProportion) public onlyOwner{
257         require(newProportion < 1000);
258         jackpotOfHouseEdge = newProportion;
259     }
260 
261     function ownerSetRecommendProportion(uint16 newRecommendProportion) public onlyOwner{
262         require(newRecommendProportion < 1000);
263         recommendProportion = newRecommendProportion;
264     }
265 
266     function ownerPauseGame(bool newStatus) public onlyOwner{
267         gamePaused = newStatus;
268     }
269 
270     function ownerPauseJackpot(bool newStatus) public onlyOwner{
271         jackpotPaused = newStatus;
272     }
273 
274     function ownerPauseRecommend(bool newStatus) public onlyOwner{
275         recommendPaused = newStatus;
276     }
277 
278     function ownerTransferEther(address sendTo, uint256 amount) public onlyOwner{	
279         contractBalance = safeSub(contractBalance, amount);
280         sendTo.transfer(amount);
281         setMaxProfit();
282         emit LogOwnerTransfer(sendTo, amount);
283     }
284 
285     function ownerChangeOwner(address newOwner) public onlyOwner{
286         owner = newOwner;
287     }
288 
289     function ownerkill() public onlyOwner{
290         selfdestruct(owner);
291     }
292 }