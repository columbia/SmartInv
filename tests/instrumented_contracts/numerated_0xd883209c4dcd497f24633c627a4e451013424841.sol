1 pragma solidity ^0.4.24;
2 
3 contract dPonzi {
4     address public manager;//who originally create the contract
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
26         uint last;
27         uint balance;
28         uint keys;
29         uint food;
30         uint gtime;
31         uint gameTime;
32         uint lastRecord;
33         uint entryAmount;
34         mapping(string => PackageStruct) potStruct;
35     }
36 
37     struct IdxStruct {
38       mapping(address => PlayerStruct) playerStruct;
39     }
40 
41     struct PackageStruct {
42       uint entryAmount;
43     }
44 
45     mapping(string => PotCntStruct) potCntInfo;
46     mapping(string => IdxStruct) idxStruct;
47     mapping(string => RefStruct) idxR;
48     mapping(address => RefStructAdd) public idxRadd;
49 
50 
51     constructor() public {
52         manager = msg.sender;
53 
54         potCntInfo['d'].gameTime = now;
55         potCntInfo['7'].gameTime = now;
56         potCntInfo['30'].gameTime = now;
57         potCntInfo['90'].gameTime = now;
58         potCntInfo['180'].gameTime = now;
59         potCntInfo['365'].gameTime = now;
60         potCntInfo['l'].gameTime = now;
61         potCntInfo['r'].gameTime = now;
62 
63         potCntInfo['d'].gtime   = now;
64         potCntInfo['7'].gtime   = now;
65         potCntInfo['30'].gtime  = now;
66         potCntInfo['90'].gtime  = now;
67         potCntInfo['180'].gtime = now;
68         potCntInfo['365'].gtime = now;
69         potCntInfo['l'].gtime   = now;
70         potCntInfo['r'].gtime   = now;
71 
72         potCntInfo['d'].last  = now;
73         potCntInfo['7'].last  = now;
74         potCntInfo['30'].last = now;
75         potCntInfo['90'].last = now;
76         potCntInfo['180'].last  = now;
77 
78         //declare precalculated entry amount to save gas during entry
79         potCntInfo['i'].entryAmount     = 10;
80         potCntInfo['d'].entryAmount     = 1;
81         potCntInfo['7'].entryAmount     = 4;
82         potCntInfo['30'].entryAmount    = 8;
83         // pot 90 and  pot dividend share the same 15%
84         potCntInfo['90'].entryAmount    = 15;
85         potCntInfo['180'].entryAmount   = 25;
86         //pot 365 and pot royal share the same 5%
87         potCntInfo['365'].entryAmount   = 5;
88         potCntInfo['l'].entryAmount     = 2;
89     }
90 
91     function enter(string package, address advisor) public payable {
92         require(msg.value >= 0.01 ether, "0 ether is not allowed");
93 
94         uint key = 0;
95         uint multiplier = 100000000000000;
96 
97         if(keccak256(abi.encodePacked(package)) == keccak256("BasicK")) {
98             require(msg.value == 0.01 ether, "Invalid Package Amount");
99             key = 1;
100         }
101         else if (keccak256(abi.encodePacked(package)) == keccak256("PremiumK")){
102             require(msg.value == 0.1 ether, "Invalid Package Amount");
103             key = 11;
104             multiplier = multiplier * 10;
105         }
106         else if (keccak256(abi.encodePacked(package)) == keccak256("LuxuryK")){
107             require(msg.value == 1 ether, "Invalid Package Amount");
108             key = 120;
109             multiplier = multiplier * 100;
110             addRoyLuxList('l', 'idxLuxury', now, 500);
111         }
112         else if (keccak256(abi.encodePacked(package)) == keccak256("RoyalK")){
113             require(msg.value == 10 ether, "Invalid Package Amount");
114             key = 1300;
115             multiplier = multiplier * 1000;
116             addRoyLuxList('r', 'idxRoyal', now, 100);
117         }
118 
119         if (key > 0){
120             if ( idxRadd[advisor].flag ) {
121                 advisor.transfer(potCntInfo['i'].entryAmount * multiplier);
122             }
123             else {
124                 potCntInfo['i'].balance += potCntInfo['i'].entryAmount * multiplier;
125             }
126             //Allocation
127             potCntInfo['d'].balance   += potCntInfo['d'].entryAmount    * multiplier;
128             potCntInfo['7'].balance   += potCntInfo['7'].entryAmount    * multiplier;
129             potCntInfo['30'].balance  += potCntInfo['30'].entryAmount   * multiplier;
130             potCntInfo['90'].balance  += potCntInfo['90'].entryAmount   * multiplier;
131             potCntInfo['180'].balance += potCntInfo['180'].entryAmount  * multiplier;
132             potCntInfo['365'].balance += potCntInfo['365'].entryAmount  * multiplier;
133             potCntInfo['l'].balance   += potCntInfo['l'].entryAmount    * multiplier;
134             potCntInfo['r'].balance   += potCntInfo['365'].entryAmount  * multiplier;
135             //admin amount
136             potCntInfo['i'].balance   += potCntInfo['i'].entryAmount    * multiplier;
137             potCntInfo['dv'].balance  += potCntInfo['90'].entryAmount   * multiplier;
138 
139             addPlayerMapping('d',   'idxDaily',  key, 30);//30 + 20
140             addPlayerMapping('7',   'idx7Pot',   key, 60);
141             addPlayerMapping('30',  'idx30Pot',  key, 90);
142             addPlayerMapping('90',  'idx90Pot',  key, 120);
143             addPlayerMapping('180', 'idx180Pot', key, 150);
144             addPlayerMapping('365', 'idx365Pot', key, 0);
145         }
146     }
147 
148     function addPlayerMapping(string x1, string x2, uint key, uint timeAdd ) private{
149       //if smaller, which means the game is expired.
150       if(potCntInfo[x1].last <= now){
151         potCntInfo[x1].last = now;
152       }
153       /* potCntInfo[x1].last += (key * timeAdd); */
154       potCntInfo[x1].last += (key * timeAdd);
155 
156       //Add into Players Mapping
157       if (idxStruct[x2].playerStruct[msg.sender].flag == 0) {
158           potCntInfo[x1].player.push(msg.sender);
159           idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(key, 0, potCntInfo[x1].player.length, potCntInfo[x1].gtime, 1);
160       }
161       else if (idxStruct[x2].playerStruct[msg.sender].gametime != potCntInfo['d'].gtime){
162           potCntInfo[x1].player.push(msg.sender);
163           idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(key, 0, potCntInfo[x1].player.length, potCntInfo[x1].gtime, 1);
164       }
165       else {
166           idxStruct[x2].playerStruct[msg.sender].key += key;
167       }
168       potCntInfo[x1].keys += key;
169     }
170 
171     function joinboard(string name) public payable {
172         require(msg.value >= 0.01 ether, "0 ether is not allowed");
173 
174         if (idxR[name].flag == 0 ) {
175             idxR[name] = RefStruct(msg.sender, 1);
176             potCntInfo['i'].balance += msg.value;
177             /* add to address mapping  */
178             idxRadd[msg.sender].name = name;
179             idxRadd[msg.sender].flag = true;
180         }
181         else {
182             revert("Name is not unique");
183         }
184     }
185 
186 
187     function pickFood(uint pickTime, string x1, string x2, uint num) public restricted {
188         uint i=0;
189         uint j=0;
190         if (potCntInfo[x1].player.length > 0 && potCntInfo[x1].food <= num) {//if pot.player has player and pot has food less than pass in num
191             do {
192                 j = potCntInfo[x1].keys < num ? j : random(potCntInfo[x1].player.length, pickTime);//random pick players in pot
193                 if (idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].food > 0) {//if potplayer[address] has food > 0, get next potPlayer[address]
194                     j++;
195                 }
196                 else {
197                     idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].food = potCntInfo[x1].keys < num ? idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].key : random(idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].key, pickTime);
198                     if (potCntInfo[x1].food + idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].food > num) {//if pot.food + potPlayer.food > num
199                         idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].food = num-potCntInfo[x1].food;
200                         potCntInfo[x1].food = num;
201                         break;
202                     }
203                     else {
204                         potCntInfo[x1].food += idxStruct[x2].playerStruct[potCntInfo[x1].player[j]].food;
205                     }
206                     j++; i++;
207                 }
208 
209                 if( potCntInfo[x1].keys < num && j == potCntInfo[x1].player.length) {//exit loop when pot.keys less than num
210                     break;
211                 }
212 
213                 if(potCntInfo[x1].food == num) {//exit loop when pot.food less than num
214                     break;
215                 }
216             }
217             while (i<10);
218             potCntInfo[x1].lastRecord = potCntInfo[x1].keys < num ? (potCntInfo[x1].keys == potCntInfo[x1].food ? 1 : 0) : (potCntInfo[x1].food == num ? 1 : 0);
219         }
220         else {
221             potCntInfo[x1].lastRecord = 1;
222         }
223     }
224 
225     function pickWinner(uint pickTime, bool sendDaily, bool send7Pot, bool send30Pot, bool send90Pot, bool send180Pot, bool send365Pot) public restricted{
226 
227         //Hit the Daily pot
228         hitPotProcess('d', sendDaily, pickTime);
229         //Hit the 7 day pot
230         hitPotProcess('7', send7Pot,  pickTime);
231         //Hit the 30 day pot
232         hitPotProcess('30', send30Pot, pickTime);
233         //Hit the 90 day pot
234         hitPotProcess('90', send90Pot, pickTime);
235         //Hit the 180 day pot
236         hitPotProcess('180', send180Pot, pickTime);
237 
238         //Hit daily pot maturity
239         maturityProcess('d', sendDaily, pickTime, 86400);
240         //Hit 7 pot maturity
241         maturityProcess('7', send7Pot, pickTime, 604800);
242         //Hit 30 pot maturity
243         maturityProcess('30', send30Pot, pickTime, 2592000);
244         //Hit 90 pot maturity
245         maturityProcess('90', send90Pot, pickTime, 7776000);
246         //Hit 180 pot maturity
247         maturityProcess('180', send180Pot, pickTime, 15552000);
248         //Hit 365 pot maturity
249         maturityProcess('365', send365Pot, pickTime, 31536000);
250 
251 
252         //Hit 365 days pot maturity
253         if (potCntInfo['365'].balance > 0 && send365Pot) {
254             if (pickTime - potCntInfo['365'].gameTime >= 31536000) {
255                 maturityProcess('l', send365Pot, pickTime, 31536000);
256                 maturityProcess('r', send365Pot, pickTime, 31536000);
257             }
258         }
259     }
260 
261     function hitPotProcess(string x1, bool send, uint pickTime) private {
262       if (potCntInfo[x1].balance > 0 && send) {
263           if (pickTime - potCntInfo[x1].last >= 20) { //additional 20 seconds for safe
264               potCntInfo[x1].balance = 0;
265               potCntInfo[x1].food = 0;
266               potCntInfo[x1].keys = 0;
267               delete potCntInfo[x1].player;
268               potCntInfo[x1].gtime = pickTime;
269           }
270       }
271     }
272 
273     function maturityProcess(string x1, bool send, uint pickTime, uint addTime) private {
274       if (potCntInfo[x1].balance > 0 && send) {
275           if (pickTime - potCntInfo[x1].gameTime >= addTime) {
276               potCntInfo[x1].balance = 0;
277               potCntInfo[x1].food = 0;
278               potCntInfo[x1].keys = 0;
279               delete potCntInfo[x1].player;
280               potCntInfo[x1].gameTime = pickTime;
281               potCntInfo[x1].gtime = pickTime;
282           }
283       }
284     }
285 
286     //Start : Util Function
287     modifier restricted() {
288         require(msg.sender == manager, "Only manager is allowed");//must be manager to call this function
289         _;
290     }
291 
292     function random(uint maxNum, uint timestamp) private view returns (uint){
293         return uint(keccak256(abi.encodePacked(block.difficulty, timestamp, potCntInfo['d'].balance, potCntInfo['7'].balance, potCntInfo['30'].balance, potCntInfo['90'].balance, potCntInfo['180'].balance, potCntInfo['365'].balance))) % maxNum;
294     }
295 
296     function addRoyLuxList(string x1, string x2, uint timestamp, uint num) private {
297         uint pick;
298 
299         if ( potCntInfo[x1].player.length < num) {
300             if (idxStruct[x2].playerStruct[msg.sender].flag == 0 ) {
301                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, potCntInfo[x1].player.length, potCntInfo['365'].gtime, 1);
302                 potCntInfo[x1].player.push(msg.sender);
303             }
304             else if (idxStruct[x2].playerStruct[msg.sender].gametime != potCntInfo['365'].gtime ) {
305                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, potCntInfo[x1].player.length, potCntInfo['365'].gtime, 1);
306                 potCntInfo[x1].player.push(msg.sender);
307             }
308         }
309         else {
310             if (idxStruct[x2].playerStruct[msg.sender].flag == 0 ) {
311                 pick = random(potCntInfo[x1].player.length, timestamp);
312                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].idx, potCntInfo['365'].gtime, 1);
313                 idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].flag = 0;
314                 potCntInfo[x1].player[pick] = msg.sender;
315             }
316             else if (idxStruct[x2].playerStruct[msg.sender].gametime != potCntInfo['365'].gtime ) {
317                 pick = random(potCntInfo[x1].player.length, timestamp);
318                 idxStruct[x2].playerStruct[msg.sender] = PlayerStruct(0, 0, idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].idx, potCntInfo['365'].gtime, 1);
319                 idxStruct[x2].playerStruct[potCntInfo[x1].player[pick]].flag = 0;
320                 potCntInfo[x1].player[pick] = msg.sender;
321             }
322         }
323     }
324 
325     function getPotCnt(string x) public constant returns(uint count, uint pLast, uint pot, uint keystore, uint gtime, uint gameTime, uint food) {
326         return (potCntInfo[x].player.length, potCntInfo[x].last, potCntInfo[x].balance, potCntInfo[x].keys, potCntInfo[x].gtime, potCntInfo[x].gameTime, potCntInfo[x].food);
327     }
328 
329     function getIdx(string x1, string x2, uint p) public constant returns(address p1, uint food, uint gametime, uint flag) {
330         return (potCntInfo[x1].player[p], idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].food, idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].gametime, idxStruct[x2].playerStruct[potCntInfo[x1].player[p]].flag);
331     }
332 
333     function getLast(string x) public constant returns(uint lastRecord) {
334         return potCntInfo[x].lastRecord;
335     }
336 
337     function sendFoods(address[500] p, uint[500] food) public restricted {
338         for(uint k = 0; k < p.length; k++){
339             if (food[k] == 0) {
340                 return;
341             }
342             p[k].transfer(food[k]);
343         }
344     }
345 
346     function sendItDv(string x1) public restricted {
347         msg.sender.transfer(potCntInfo[x1].balance);
348         potCntInfo[x1].balance = 0;
349     }
350 
351     function getReffAdd(string x) public constant returns(address){
352       if( idxR[x].flag == 1){
353         return idxR[x].player;
354       }else{
355         revert("Not found!");
356       }
357     }
358 
359     function getReffName(address x) public constant returns(string){
360       if( idxRadd[x].flag){
361         return idxRadd[x].name;
362       }else{
363         revert("Not found!");
364       }
365     }
366 
367     //End : Util Function
368 }