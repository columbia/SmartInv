1 pragma solidity ^0.4.25;
2 
3 contract Formula1Game {
4 
5     address public support;
6 
7 	uint constant public PRIZE_PERCENT = 5;
8     uint constant public SUPPORT_PERCENT = 2;
9     
10     uint constant public MAX_INVESTMENT =  0.1 ether;
11     uint constant public MIN_INVESTMENT = 0.01 ether;
12     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.01 ether;
13     uint constant public GAS_PRICE_MAX = 14; 
14     uint constant public MAX_IDLE_TIME = 10 minutes; 
15 
16     uint constant public SIZE_TO_SAVE_INVEST = 10; 
17     uint constant public TIME_TO_SAVE_INVEST = 5 minutes; 
18     
19     uint8[] MULTIPLIERS = [
20         125, 
21         135, 
22         145 
23     ];
24 
25     struct Deposit {
26         address depositor; 
27         uint128 deposit;  
28         uint128 expect;    
29     }
30 
31     struct DepositCount {
32         int128 stage;
33         uint128 count;
34     }
35 
36     struct LastDepositInfo {
37         uint128 index;
38         uint128 time;
39     }
40 
41     Deposit[] private queue;  
42 
43     uint public currentReceiverIndex = 0; 
44     uint public currentQueueSize = 0; 
45     LastDepositInfo public lastDepositInfoForPrize; 
46     LastDepositInfo public previosDepositInfoForPrize; 
47 
48     uint public prizeAmount = 0; 
49     uint public prizeStageAmount = 0; 
50     int public stage = 0; 
51     uint128 public lastDepositTime = 0; 
52     
53     mapping(address => DepositCount) public depositsMade; 
54 
55     constructor() public {
56         support = msg.sender; 
57         proceedToNewStage(getCurrentStageByTime() + 1);
58     }
59     
60     function () public payable {
61         require(tx.gasprice <= GAS_PRICE_MAX * 1000000000);
62         require(gasleft() >= 250000, "We require more gas!"); 
63         
64         checkAndUpdateStage();
65         
66         if(msg.value > 0){
67             require(msg.value >= MIN_INVESTMENT && msg.value <= MAX_INVESTMENT); 
68             require(lastDepositInfoForPrize.time <= now + MAX_IDLE_TIME); 
69             
70             require(getNextStageStartTime() >= now + MAX_IDLE_TIME + 10 minutes);
71             
72             if(currentQueueSize < SIZE_TO_SAVE_INVEST){ 
73                 
74                 addDeposit(msg.sender, msg.value);
75                 
76             } else {
77                 
78                 addDeposit(msg.sender, msg.value);
79                 pay(); 
80                 
81             }
82             
83         } else if(msg.value == 0 && currentQueueSize > SIZE_TO_SAVE_INVEST){
84             
85             withdrawPrize(); 
86             
87         } else if(msg.value == 0){
88             
89             require(currentQueueSize <= SIZE_TO_SAVE_INVEST); 
90             require(lastDepositTime > 0 && (now - lastDepositTime) >= TIME_TO_SAVE_INVEST); 
91             
92             returnPays(); 
93             
94         } 
95     }
96 
97     function pay() private {
98         
99         uint balance = address(this).balance;
100         uint128 money = 0;
101         
102         if(balance > prizeStageAmount) 
103             money = uint128(balance - prizeStageAmount);
104         
105         uint128 moneyS = uint128(money*SUPPORT_PERCENT/100);
106         support.send(moneyS);
107         money -= moneyS;
108         
109         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
110 
111             Deposit storage dep = queue[i]; 
112 
113             if(money >= dep.expect){  
114                     
115                 dep.depositor.send(dep.expect); 
116                 money -= dep.expect;          
117                 
118                 delete queue[i];
119                 
120             }else{
121                 
122                 dep.depositor.send(money);      
123                 money -= dep.expect;            
124                 break;                     
125             }
126 
127             if(gasleft() <= 50000)         
128                 break;                     
129         }
130 
131         currentReceiverIndex = i; 
132     }
133     
134     function returnPays() private {
135         
136         uint balance = address(this).balance;
137         uint128 money = 0;
138         
139         if(balance > prizeAmount) 
140             money = uint128(balance - prizeAmount);
141         
142         
143         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
144 
145             Deposit storage dep = queue[i]; 
146 
147                 dep.depositor.send(dep.deposit); 
148                 money -= dep.deposit;            
149                 
150                 
151                 delete queue[i];
152 
153         }
154 
155         prizeStageAmount = 0; 
156         proceedToNewStage(getCurrentStageByTime() + 1);
157     }
158 
159     function addDeposit(address depositor, uint value) private {
160         
161         DepositCount storage c = depositsMade[depositor];
162         if(c.stage != stage){
163             c.stage = int128(stage);
164             c.count = 0;
165         }
166 
167         
168         if(value >= MIN_INVESTMENT_FOR_PRIZE){
169             previosDepositInfoForPrize = lastDepositInfoForPrize;
170             lastDepositInfoForPrize = LastDepositInfo(uint128(currentQueueSize), uint128(now));
171         }
172 
173         
174         uint multiplier = getDepositorMultiplier(depositor);
175         
176         push(depositor, value, value*multiplier/100);
177 
178         
179         c.count++;
180 
181         lastDepositTime = uint128(now);
182         
183         
184         prizeStageAmount += value*PRIZE_PERCENT/100;
185     }
186 
187     function checkAndUpdateStage() private {
188         int _stage = getCurrentStageByTime();
189 
190         require(_stage >= stage); 
191 
192         if(_stage != stage){
193             proceedToNewStage(_stage);
194         }
195     }
196 
197     function proceedToNewStage(int _stage) private {
198         
199         stage = _stage;
200         currentQueueSize = 0; 
201         currentReceiverIndex = 0;
202         lastDepositTime = 0;
203         prizeAmount += prizeStageAmount; 
204         prizeStageAmount = 0;
205         delete queue;
206         delete previosDepositInfoForPrize;
207         delete lastDepositInfoForPrize;
208     }
209 
210     function withdrawPrize() private {
211         
212         require(lastDepositInfoForPrize.time > 0 && lastDepositInfoForPrize.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
213         
214         require(currentReceiverIndex <= lastDepositInfoForPrize.index, "The last depositor should still be in queue");
215 
216         uint balance = address(this).balance;
217         
218         uint prize = balance;
219         if(previosDepositInfoForPrize.index > 0){
220             uint prizePrevios = prize*10/100;
221             queue[previosDepositInfoForPrize.index].depositor.transfer(prizePrevios);
222             prize -= prizePrevios;
223         }
224 
225         queue[lastDepositInfoForPrize.index].depositor.send(prize);
226         
227         proceedToNewStage(getCurrentStageByTime() + 1);
228     }
229 
230     function push(address depositor, uint deposit, uint expect) private {
231         
232         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
233         assert(currentQueueSize <= queue.length); 
234         if(queue.length == currentQueueSize)
235             queue.push(dep);
236         else
237             queue[currentQueueSize] = dep;
238 
239         currentQueueSize++;
240     }
241 
242     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
243         Deposit storage dep = queue[idx];
244         return (dep.depositor, dep.deposit, dep.expect);
245     }
246 
247     function getDepositsCount(address depositor) public view returns (uint) {
248         uint c = 0;
249         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
250             if(queue[i].depositor == depositor)
251                 c++;
252         }
253         return c;
254     }
255 
256     function getQueueLength() public view returns (uint) {
257         return currentQueueSize - currentReceiverIndex;
258     }
259 
260     function getDepositorMultiplier(address depositor) public view returns (uint) {
261         DepositCount storage c = depositsMade[depositor];
262         uint count = 0;
263         if(c.stage == getCurrentStageByTime())
264             count = c.count;
265         if(count < MULTIPLIERS.length)
266             return MULTIPLIERS[count];
267 
268         return MULTIPLIERS[MULTIPLIERS.length - 1];
269     }
270 
271     function getCurrentStageByTime() public view returns (int) {
272         return int(now - 17847 * 86400 - 9 * 3600) / (24 * 60 * 60);
273     }
274 
275     function getNextStageStartTime() public view returns (uint) {
276         return 17847 * 86400 + 9 * 3600 + uint((getCurrentStageByTime() + 1) * 24 * 60 * 60); 
277     }
278 
279     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
280         if(currentReceiverIndex <= lastDepositInfoForPrize.index && lastDepositInfoForPrize.index < currentQueueSize){
281             Deposit storage d = queue[lastDepositInfoForPrize.index];
282             addr = d.depositor;
283             timeLeft = int(lastDepositInfoForPrize.time + MAX_IDLE_TIME) - int(now);
284         }
285     }
286 }