1 pragma solidity ^0.4.24;
2 
3 // * Digital Game - Version 1.
4 // * The user selects three digits, the platform generates trusted random 
5 //   number to lottery and distributes the reward.
6 
7 contract DigitalGame {
8   /// *** Constants
9 
10   uint constant MIN_BET_MONEY = 10 finney;
11   uint constant MAX_BET_MONEY = 10 ether;
12   uint constant MIN_BET_NUMBER = 2;
13   uint constant MAX_STAGE = 4;
14 
15   // Calculate invitation dividends based on bet amount
16   // - first generation reward: 3%
17   // - second generation reward: 2%
18   // - third generation reward: 1%
19   uint constant FIRST_GENERATION_REWARD = 3;
20   uint constant SECOND_GENERATION_REWARD = 2;
21   uint constant THIRD_GENERATION_REWARD = 1;
22 
23   address public OWNER_ADDR;
24   address public RECOMM_ADDR;
25   address public SPARE_RECOMM_ADDR;
26 
27   /// *** Struct
28 
29   struct UserRecomm {
30     address addr;
31   }
32 
33   struct StageInfo {
34     uint round;
35     bytes32 seedHash;
36     uint userNumber;
37     uint amount;
38     uint lastTime;
39   }
40 
41   struct UserBet {
42     address addr;
43     uint amount;
44     uint[] content;
45     uint count;
46     uint createAt;
47   }
48   
49   address[] private userRecomms;
50   UserBet[] private WaitAwardBets;
51 
52   /// *** Mapping
53 
54   mapping(uint => StageInfo) public stages;
55   mapping(address => address) public users;
56   mapping(uint => UserBet[]) public userBets;
57   mapping(uint => mapping(uint => mapping(address => bool))) private userBetAddrs;
58 
59   /// *** Event
60 
61   event eventUserBet(
62     string eventType,
63     address addr,
64     uint amount,
65     uint stage,
66     uint round,
67     uint count,
68     uint[] content,
69     uint createAt
70   );
71 
72   event eventLottery(
73     string eventType,
74     uint stage,
75     uint round,
76     uint[] lotteryContent,
77     uint createAt
78   );
79 
80   event eventDividend(
81     string eventType,
82     address addr,
83     uint amount,
84     uint stage,
85     uint round,
86     uint count,
87     uint[] content,
88     uint level,
89     address recommAddr,
90     uint recommReward,
91     uint createAt
92   );
93 
94   event eventReward(
95     string eventType,
96     address addr,
97     uint amount,
98     uint stage,
99     uint round,
100     uint count,
101     uint[] content,
102     uint[] lotteryContent,
103     uint reward,
104     uint createAt
105   );
106 
107   /// *** Modifier
108 
109   modifier checkBetTime(uint lastTime) {
110     require(now <= lastTime, 'Current time is not allowed to bet');
111     _;
112   }
113 
114   modifier checkRewardTime(uint lastTime) {
115     require(
116       now >= lastTime + 1 hours,
117       'Current time is not allowed to reward'
118     );
119     _;
120   }
121 
122   modifier isSecretNumber(uint stage, string seed) {
123     require(
124       keccak256(abi.encodePacked(seed)) == stages[stage].seedHash,
125       'Encrypted numbers are illegal'
126     );
127     _;
128   }
129 
130   modifier verifyStage(uint stage) {
131     require(
132       stage >= 1 && stage <= MAX_STAGE,
133       'Stage no greater than MAX_STAGE'
134     );
135     _;
136   }
137 
138   modifier verifySeedHash(uint stage, bytes32 seedHash) {
139     require(
140       stages[stage].seedHash == seedHash && seedHash != 0,
141       'The hash of the stage is illegal'
142     );
143     _;
144   }
145 
146   modifier onlyOwner() {
147     require(OWNER_ADDR == msg.sender, 'Permission denied');
148     _;
149   }
150 
151   constructor(
152     bytes32[4] hashes,
153     uint lastTime,
154     address recommAddr,
155     address spareRecommAddr
156   ) public {
157     for (uint i = 1; i <= MAX_STAGE; i++) {
158       stages[i].round = 1;
159       stages[i].seedHash = hashes[i-1];
160       stages[i].userNumber = 0;
161       stages[i].amount = 0;
162       stages[i].lastTime = lastTime;
163     }
164 
165     OWNER_ADDR = msg.sender;
166     RECOMM_ADDR = recommAddr;
167     SPARE_RECOMM_ADDR = spareRecommAddr;
168   }
169 
170   function bet(
171     uint stage,
172     uint round,
173     uint[] content,
174     uint count,
175     address recommAddr,
176     bytes32 seedHash
177   ) public
178   payable
179   verifyStage(stage)
180   verifySeedHash(stage, seedHash)
181   checkBetTime(stages[stage].lastTime) {
182     require(stages[stage].round == round, 'Round illegal');
183     require(content.length == 3, 'The bet is 3 digits');
184 
185     require((
186         msg.value >= MIN_BET_MONEY
187             && msg.value <= MAX_BET_MONEY
188             && msg.value == MIN_BET_MONEY * (10 ** (stage - 1)) * count
189       ),
190       'The amount of the bet is illegal'
191     );
192     
193     require(msg.sender != recommAddr, 'The recommender cannot be himself');
194     
195     if (users[msg.sender] == 0) {
196       if (recommAddr != RECOMM_ADDR) {
197         require(
198             users[recommAddr] != 0,
199             'Referrer is not legal'
200         );
201       }
202       users[msg.sender] = recommAddr;
203     }
204 
205     generateUserRelation(msg.sender, 3);
206     require(userRecomms.length <= 3, 'User relationship error');
207 
208     sendInviteDividends(stage, round, count, content);
209 
210     if (!userBetAddrs[stage][stages[stage].round][msg.sender]) {
211       stages[stage].userNumber++;
212       userBetAddrs[stage][stages[stage].round][msg.sender] = true;
213     }
214 
215     userBets[stage].push(UserBet(
216       msg.sender,
217       msg.value,
218       content,
219       count,
220       now
221     ));
222 
223     emit eventUserBet(
224       'userBet',
225       msg.sender,
226       msg.value,
227       stage,
228       round,
229       count,
230       content,
231       now
232     );
233   }
234 
235   function generateUserRelation(
236     address addr,
237     uint generation
238   ) private returns(bool) {
239     userRecomms.push(users[addr]);
240     if (users[addr] != RECOMM_ADDR && users[addr] != 0 && generation > 1) {
241         generateUserRelation(users[addr], generation - 1);
242     }
243   }
244 
245   function sendInviteDividends(
246     uint stage,
247     uint round,
248     uint count,
249     uint[] content
250   ) private {
251     uint[3] memory GENERATION_REWARD = [
252       FIRST_GENERATION_REWARD,
253       SECOND_GENERATION_REWARD,
254       THIRD_GENERATION_REWARD
255     ];
256     uint recomms = 0;
257     for (uint j = 0; j < userRecomms.length; j++) {
258       recomms += msg.value * GENERATION_REWARD[j] / 100;
259       userRecomms[j].transfer(msg.value * GENERATION_REWARD[j] / 100);
260 
261       emit eventDividend(
262         'dividend',
263         msg.sender,
264         msg.value,
265         stage,
266         round,
267         count,
268         content,
269         j,
270         userRecomms[j],
271         msg.value * GENERATION_REWARD[j] / 100,
272         now
273       );
274     }
275 
276     stages[stage].amount += (msg.value - recomms);
277     delete userRecomms;
278   }
279 
280   function distributionReward(
281     uint stage,
282     string seed,
283     bytes32 seedHash
284   ) public
285   checkRewardTime(stages[stage].lastTime)
286   isSecretNumber(stage, seed)
287   verifyStage(stage)
288   onlyOwner {
289     if (stages[stage].userNumber >= MIN_BET_NUMBER) {
290       uint[] memory randoms = generateRandom(
291         seed,
292         stage,
293         userBets[stage].length
294       );
295       require(randoms.length == 3, 'Random number is illegal');
296 
297       bool isReward = CalcWinnersAndReward(randoms, stage);
298 
299       emit eventLottery(
300         'lottery',
301         stage,
302         stages[stage].round,
303         randoms,
304         now
305       );
306 
307       if (isReward) {
308         stages[stage].amount = 0;
309       }
310       
311       delete userBets[stage];
312       
313       stages[stage].round += 1;
314       stages[stage].userNumber = 0;
315       stages[stage].seedHash = seedHash;
316 
317       stages[stage].lastTime += 24 hours;
318     } else {
319       stages[stage].lastTime += 24 hours;
320     }
321   }
322 
323   function CalcWinnersAndReward(
324     uint[] randoms,
325     uint stage
326   ) private onlyOwner returns(bool) {
327     uint counts = 0;
328     for (uint i = 0; i < userBets[stage].length; i++) {
329       if (randoms[0] == userBets[stage][i].content[0]
330         && randoms[1] == userBets[stage][i].content[1]
331         && randoms[2] == userBets[stage][i].content[2]) {
332         counts = counts + userBets[stage][i].count;
333         WaitAwardBets.push(UserBet(
334           userBets[stage][i].addr,
335           userBets[stage][i].amount,
336           userBets[stage][i].content,
337           userBets[stage][i].count,
338           userBets[stage][i].createAt
339         ));
340       }
341     }
342     if (WaitAwardBets.length == 0) {
343       for (uint j = 0; j < userBets[stage].length; j++) {
344         if ((randoms[0] == userBets[stage][j].content[0]
345             && randoms[1] == userBets[stage][j].content[1])
346               || (randoms[1] == userBets[stage][j].content[1]
347             && randoms[2] == userBets[stage][j].content[2])
348               || (randoms[0] == userBets[stage][j].content[0]
349             && randoms[2] == userBets[stage][j].content[2])) {
350           counts += userBets[stage][j].count;
351           WaitAwardBets.push(UserBet(
352             userBets[stage][j].addr,
353             userBets[stage][j].amount,
354             userBets[stage][j].content,
355             userBets[stage][j].count,
356             userBets[stage][j].createAt
357           ));
358         }
359       }
360     }
361     if (WaitAwardBets.length == 0) {
362       for (uint k = 0; k < userBets[stage].length; k++) {
363         if (randoms[0] == userBets[stage][k].content[0]
364             || randoms[1] == userBets[stage][k].content[1]
365             || randoms[2] == userBets[stage][k].content[2]) {
366           counts += userBets[stage][k].count;
367           WaitAwardBets.push(UserBet(
368             userBets[stage][k].addr,
369             userBets[stage][k].amount,
370             userBets[stage][k].content,
371             userBets[stage][k].count,
372             userBets[stage][k].createAt
373           ));
374         }
375       }
376     }
377 
378     uint extractReward = stages[stage].amount / 100;
379     OWNER_ADDR.transfer(extractReward);
380     RECOMM_ADDR.transfer(extractReward);
381     SPARE_RECOMM_ADDR.transfer(extractReward);
382 
383     if (WaitAwardBets.length != 0) {
384       issueReward(stage, extractReward, randoms, counts);
385       delete WaitAwardBets;
386       return true;
387     }
388     stages[stage].amount = stages[stage].amount - (extractReward * 3);
389     return false;
390   }
391   
392   function issueReward(
393     uint stage,
394     uint extractReward,
395     uint[] randoms,
396     uint counts
397   ) private onlyOwner {
398     uint userAward = stages[stage].amount - (extractReward * 3);
399     for (uint m = 0; m < WaitAwardBets.length; m++) {
400       uint reward = userAward * WaitAwardBets[m].count / counts;
401       WaitAwardBets[m].addr.transfer(reward);
402 
403       emit eventReward(
404         'reward',
405         WaitAwardBets[m].addr,
406         WaitAwardBets[m].amount,
407         stage,
408         stages[stage].round,
409         WaitAwardBets[m].count,
410         WaitAwardBets[m].content,
411         randoms,
412         reward,
413         now
414       );
415     }
416   }
417 
418   function generateRandom(
419     string seed,
420     uint stage,
421     uint betNum
422   ) private view onlyOwner
423   isSecretNumber(stage, seed) returns(uint[]) {
424     uint[] memory randoms = new uint[](3);
425     for (uint i = 0; i < 3; i++) {
426       randoms[i] = uint(
427         keccak256(abi.encodePacked(betNum, block.difficulty, seed, now, i))
428       ) % 9 + 1;
429     }
430     return randoms;
431   }
432 
433   function setDefaultRecommAddr(address _RECOMM_ADDR) public onlyOwner {
434     RECOMM_ADDR = _RECOMM_ADDR;
435   }
436 
437   function setSpareRecommAddr(address _SPARE_RECOMM_ADDR) public onlyOwner {
438     SPARE_RECOMM_ADDR = _SPARE_RECOMM_ADDR;
439   }
440 }