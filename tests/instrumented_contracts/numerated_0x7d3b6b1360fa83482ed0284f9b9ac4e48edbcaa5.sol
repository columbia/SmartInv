1 pragma solidity ^0.4.24;
2 
3 contract dPonzi {
4     address public manager;
5 
6     struct PlayerStruct {
7         uint key;
8         uint food;
9         uint idx;
10         uint gametime;
11         uint flag;
12     }
13 
14     struct RefStruct {
15         address player;
16         uint flag;
17     }
18 
19     struct RefStructAdd {
20         bool flag;
21         string name;
22     }
23 
24     struct PotCntStruct {
25         address[] player;
26         address lastPlayer;
27         uint last;
28         uint balance;
29         uint keys;
30         uint food;
31         uint gtime;
32         uint gameTime;
33         uint lastRecord;
34         uint entryAmount;
35         mapping(string => PackageStruct) potStruct;
36     }
37 
38     struct IdxStruct {
39       mapping(address => PlayerStruct) playerStruct;
40     }
41 
42     struct PackageStruct {
43       uint entryAmount;
44     }
45 
46     mapping(string => PotCntStruct) potCntInfo;
47     mapping(string => IdxStruct) idxStruct;
48     mapping(string => RefStruct) idxR;
49     mapping(address => RefStructAdd) public idxRadd;
50 
51 
52     constructor() public {
53         manager = msg.sender;
54 
55         potCntInfo['d'].gameTime   = 0;
56         potCntInfo['7'].gameTime   = 0;
57         potCntInfo['30'].gameTime  = 0;
58         potCntInfo['90'].gameTime  = 0;
59         potCntInfo['180'].gameTime = 0;
60         potCntInfo['365'].gameTime = 0;
61 
62         potCntInfo['i'].entryAmount   = 10;
63         potCntInfo['d'].entryAmount   = 1;
64         potCntInfo['7'].entryAmount   = 4;
65         potCntInfo['30'].entryAmount  = 8;
66         potCntInfo['90'].entryAmount  = 15;
67         potCntInfo['180'].entryAmount = 25;
68         potCntInfo['365'].entryAmount = 5;
69         potCntInfo['l'].entryAmount   = 2;
70     }
71 
72     function enter(string package, address advisor) public payable {
73         require(msg.value >= 0.01 ether, "0 ether is not allowed");
74 
75         uint key = 0;
76         uint multiplier = 100000000000000;
77 
78         if(keccak256(abi.encodePacked(package)) == keccak256("BasicK")) {
79             require(msg.value == 0.01 ether, "Invalid Package Amount");
80             key = 1;
81         }
82         else if (keccak256(abi.encodePacked(package)) == keccak256("PremiumK")){
83             require(msg.value == 0.1 ether, "Invalid Package Amount");
84             key = 11;
85             multiplier = multiplier * 10;
86         }
87         else if (keccak256(abi.encodePacked(package)) == keccak256("LuxuryK")){
88             require(msg.value == 1 ether, "Invalid Package Amount");
89             key = 120;
90             multiplier = multiplier * 100;
91             addRoyLuxList('l', 'idxLuxury', now, 500);
92         }
93         else if (keccak256(abi.encodePacked(package)) == keccak256("RoyalK")){
94             require(msg.value == 10 ether, "Invalid Package Amount");
95             key = 1300;
96             multiplier = multiplier * 1000;
97             addRoyLuxList('r', 'idxRoyal', now, 100);
98         }
99 
100         if (key > 0){
101             if ( idxRadd[advisor].flag ) {
102                 advisor.transfer(potCntInfo['i'].entryAmount * multiplier);
103             }
104             else {
105                 potCntInfo['i'].balance += potCntInfo['i'].entryAmount * multiplier;
106             }
107             potCntInfo['d'].balance   += potCntInfo['d'].entryAmount    * multiplier;
108             potCntInfo['7'].balance   += potCntInfo['7'].entryAmount    * multiplier;
109             potCntInfo['30'].balance  += potCntInfo['30'].entryAmount   * multiplier;
110             potCntInfo['90'].balance  += potCntInfo['90'].entryAmount   * multiplier;
111             potCntInfo['180'].balance += potCntInfo['180'].entryAmount  * multiplier;
112             potCntInfo['365'].balance += potCntInfo['365'].entryAmount  * multiplier;
113             potCntInfo['l'].balance   += potCntInfo['l'].entryAmount    * multiplier;
114             potCntInfo['r'].balance   += potCntInfo['365'].entryAmount  * multiplier;
115             potCntInfo['i'].balance   += potCntInfo['i'].entryAmount    * multiplier;
116             potCntInfo['dv'].balance  += potCntInfo['90'].entryAmount   * multiplier;
117 
118             addPlayerMapping('d',   'idxDaily',  key, 0, 0);
119             addPlayerMapping('7',   'idx7Pot',   key, 60, 3600);
120             addPlayerMapping('30',  'idx30Pot',  key, 90, 10800);
121             addPlayerMapping('90',  'idx90Pot',  key, 120, 21600);
122             addPlayerMapping('180', 'idx180Pot', key, 150, 43200);
123             addPlayerMapping('365', 'idx365Pot', key, 0, 0);
124         }
125     }
126 
127     function addPlayerMapping(string x1, string x2, uint key, uint timeAdd, uint hardCap ) private{
128       if(potCntInfo[x1].last <= now){
129         potCntInfo[x1].last = now;
130       }
131 
132       if(keccak256(abi.encodePacked(x1)) == keccak256("d")) {
133           if (potCntInfo[x1].gameTime == 0) {
134               potCntInfo[x1].gameTime   = now%86400 == 0 ? (now-28800) : now-28800-(now%86400);
135               potCntInfo[x1].gtime   = now;
136               potCntInfo[x1].last = potCntInfo[x1].gameTime + 1 days;
137           }
138       }
139       else if(keccak256(abi.encodePacked(x1)) == keccak256("365")) {
140         if (potCntInfo[x1].gameTime == 0) {
141             potCntInfo[x1].gameTime = now%86400 == 0 ? (now-28800) : now-28800-(now%86400);
142             potCntInfo[x1].gtime = now;
143             potCntInfo[x1].last = potCntInfo[x1].gameTime + 365 days;
144             potCntInfo['l'].gameTime = potCntInfo[x1].gameTime;
145             potCntInfo['r'].gameTime = potCntInfo[x1].gameTime;
146             potCntInfo['l'].gtime   = now;
147             potCntInfo['r'].gtime   = now;
148         }
149       }else  {
150           if (potCntInfo[x1].gameTime == 0) {
151               potCntInfo[x1].gameTime   = now%86400 == 0 ? (now-28800) : now-28800-(now%86400);
152               potCntInfo[x1].gtime   = now;
153               potCntInfo[x1].last = (now + (key * timeAdd))>=now+hardCap ? now + hardCap : now + (key * timeAdd);
154           }
155           else {
156               potCntInfo[x1].last = (potCntInfo[x1].last + (key * timeAdd))>=now+hardCap ? now + hardCap : potCntInfo[x1].last + (key * timeAdd);
157           }
158       }
159 
160       if (idxStruct[x2].playerStruct[msg.sender].flag == 0) {
161           potCntInfo[x1].player.push(msg.sender);
162           idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(key, 0, potCntInfo[x1].player.length, potCntInfo[x1].gtime, 1);
163       }
164       else if (idxStruct[x2].playerStruct[msg.sender].gametime != potCntInfo[x1].gtime){
165           potCntInfo[x1].player.push(msg.sender);
166           idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(key, 0, potCntInfo[x1].player.length, potCntInfo[x1].gtime, 1);
167       }
168       else {
169           idxStruct[x2].playerStruct[msg.sender].key += key;
170       }
171       potCntInfo[x1].keys += key;
172       potCntInfo[x1].lastPlayer = msg.sender;
173     }
174 
175     function joinboard(string name) public payable {
176         require(msg.value >= 0.01 ether, "0 ether is not allowed");
177 
178         if (idxR[name].flag == 0 ) {
179             idxR[name] = RefStruct(msg.sender, 1);
180             potCntInfo['i'].balance += msg.value;
181             idxRadd[msg.sender].name = name;
182             idxRadd[msg.sender].flag = true;
183         }
184         else {
185             revert("Name is not unique");
186         }
187     }
188 
189     function pickFood(uint pickTime, string x1, string x2, uint num, uint c) public restricted {
190         uint i = 0;
191         uint pCounter = 0;
192         uint food = 0;
193         if (potCntInfo[x1].player.length > 0 && potCntInfo[x1].food < num) {
194             do {
195                 pCounter = random(potCntInfo[x1].player.length, pickTime+i+pCounter+food);
196                 food = random(idxStruct[x2].playerStruct[potCntInfo[x1].player[pCounter]].key, pickTime+i+pCounter+food);
197                 if (potCntInfo[x1].food + food > num) {
198                     idxStruct[x2].playerStruct[potCntInfo[x1].player[pCounter]].food += num-potCntInfo[x1].food;
199                     potCntInfo[x1].food = num;
200                     break;
201                 }
202                 else {
203                     idxStruct[x2].playerStruct[potCntInfo[x1].player[pCounter]].food += food;
204                     potCntInfo[x1].food += food;
205                 }
206                 i++;
207 
208                 if(potCntInfo[x1].food == num) {
209                     break;
210                 }
211             }
212             while (i < c);
213             potCntInfo[x1].lastRecord = potCntInfo[x1].food == num ? 1 : 0;
214         }
215         else {
216             potCntInfo[x1].lastRecord = 1;
217         }
218     }
219 
220     function pickWinner(uint pickTime, bool sendDaily, bool send7Pot, bool send30Pot, bool send90Pot, bool send180Pot, bool send365Pot) public restricted{
221         hitPotProcess('7', send7Pot,  pickTime);
222         hitPotProcess('30', send30Pot, pickTime);
223         hitPotProcess('90', send90Pot, pickTime);
224         hitPotProcess('180', send180Pot, pickTime);
225 
226         maturityProcess('d', sendDaily, pickTime, 86400);
227         maturityProcess('7', send7Pot, pickTime, 604800);
228         maturityProcess('30', send30Pot, pickTime, 2592000);
229         maturityProcess('90', send90Pot, pickTime, 7776000);
230         maturityProcess('180', send180Pot, pickTime, 15552000);
231         maturityProcess('365', send365Pot, pickTime, 31536000);
232         maturityProcess('l', send365Pot, pickTime, 31536000);
233         maturityProcess('r', send365Pot, pickTime, 31536000);
234     }
235 
236     function hitPotProcess(string x1, bool send, uint pickTime) private {
237         if( pickTime > potCntInfo[x1].last) {
238             if (potCntInfo[x1].balance > 0 && send) {
239                 if (pickTime - potCntInfo[x1].last >= 20) {
240                     potCntInfo[x1].balance = 0;
241                     potCntInfo[x1].food = 0;
242                     potCntInfo[x1].keys = 0;
243                     delete potCntInfo[x1].player;
244                     potCntInfo[x1].gameTime = 0;
245                     potCntInfo[x1].gtime = pickTime;
246                 }
247             }
248         }
249     }
250 
251     function maturityProcess(string x1, bool send, uint pickTime, uint addTime) private {
252       if( pickTime > potCntInfo[x1].gameTime) {
253           if ( (pickTime - potCntInfo[x1].gameTime) >= addTime) {
254             if (potCntInfo[x1].balance > 0 && send) {
255                 potCntInfo[x1].balance = 0;
256                 potCntInfo[x1].food = 0;
257                 potCntInfo[x1].keys = 0;
258                 delete potCntInfo[x1].player;
259                 potCntInfo[x1].gameTime = 0;
260                 potCntInfo[x1].gtime    = pickTime;
261             }
262         }
263       }
264     }
265 
266     modifier restricted() {
267         require(msg.sender == manager, "Only manager is allowed");
268         _;
269     }
270 
271     function random(uint maxNum, uint timestamp) private view returns (uint){
272         return uint(keccak256(abi.encodePacked(block.difficulty, timestamp, potCntInfo['d'].balance, potCntInfo['7'].balance, potCntInfo['30'].balance, potCntInfo['90'].balance, potCntInfo['180'].balance, potCntInfo['365'].balance))) % maxNum;
273     }
274 
275     function addRoyLuxList(string x1, string x2, uint timestamp, uint num) private {
276         uint pick;
277 
278         if ( potCntInfo[x1].player.length < num) {
279             if (idxStruct[x2].playerStruct[msg.sender].flag == 0 ) {
280                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, potCntInfo[x1].player.length, potCntInfo['365'].gtime, 1);
281                 potCntInfo[x1].player.push(msg.sender);
282             }
283             else if (idxStruct[x2].playerStruct[msg.sender].gametime != potCntInfo['365'].gtime ) {
284                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, potCntInfo[x1].player.length, potCntInfo['365'].gtime, 1);
285                 potCntInfo[x1].player.push(msg.sender);
286             }
287         }
288         else {
289             if (idxStruct[x2].playerStruct[msg.sender].flag == 0 ) {
290                 pick = random(potCntInfo[x1].player.length, timestamp);
291                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].idx, potCntInfo['365'].gtime, 1);
292                 idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].flag = 0;
293                 potCntInfo[x1].player[pick] = msg.sender;
294             }
295             else if (idxStruct[x2].playerStruct[msg.sender].gametime != potCntInfo['365'].gtime ) {
296                 pick = random(potCntInfo[x1].player.length, timestamp);
297                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].idx, potCntInfo['365'].gtime, 1);
298                 idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].flag = 0;
299                 potCntInfo[x1].player[pick] = msg.sender;
300             }
301         }
302     }
303 
304     function getPotCnt(string x) public constant returns(uint count, uint pLast, uint pot, uint keystore, uint gtime, uint gameTime, uint food) {
305         return (potCntInfo[x].player.length, potCntInfo[x].last, potCntInfo[x].balance, potCntInfo[x].keys, potCntInfo[x].gtime, potCntInfo[x].gameTime, potCntInfo[x].food);
306     }
307 
308     function getIdx(string x1, string x2, uint p) public constant returns(address p1, uint key, uint food, uint gametime, uint flag) {
309         return (potCntInfo[x1].player[p], idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].key, idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].food, idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].gametime, idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].flag);
310     }
311 
312     function getLast(string x) public constant returns(uint lastRecord) {
313         return potCntInfo[x].lastRecord;
314     }
315 
316     function getLastPlayer(string x) public constant returns(address lastPlayer) {
317         return potCntInfo[x].lastPlayer;
318     }
319 
320     function sendFood(address p, uint food) public restricted {
321          p.transfer(food);
322     }
323 
324     function sendFoods(address[500] p, uint[500] food) public restricted {
325         for(uint k = 0; k < p.length; k++){
326             if (food[k] == 0) {
327                 return;
328             }
329             p[k].transfer(food[k]);
330         }
331     }
332 
333     function sendItDv(string x1) public restricted {
334         msg.sender.transfer(potCntInfo[x1].balance);
335         potCntInfo[x1].balance = 0;
336     }
337 
338     function sendDv(string x1) public restricted {
339         potCntInfo[x1].balance = 0;
340     }
341 
342     function getReffAdd(string x) public constant returns(address){
343       if( idxR[x].flag == 1){
344         return idxR[x].player;
345       }else{
346         revert("Not found!");
347       }
348     }
349 
350     function getReffName(address x) public constant returns(string){
351       if( idxRadd[x].flag){
352         return idxRadd[x].name;
353       }else{
354         revert("Not found!");
355       }
356     }
357 }