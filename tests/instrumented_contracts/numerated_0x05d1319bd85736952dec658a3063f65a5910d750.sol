1 pragma solidity ^0.4.24;
2 
3 // * Digital Game - Version 1.
4 // * The user selects three digits, the platform generates trusted random 
5 //   number to lottery and distributes the reward.
6 
7 contract DigitalGame {
8   /// *** Constants
9 
10   uint constant MIN_BET_MONEY = 1 finney;
11   uint constant MAX_BET_MONEY = 10 ether;
12   uint constant MIN_BET_NUMBER = 2;
13   uint constant MAX_STAGE = 5;
14 
15   // Calculate invitation dividends based on bet amount
16   // - first generation reward: 0.5%
17   // - second generation reward: 0.3%
18   // - third generation reward: 0.2%
19   uint constant FIRST_GENERATION_REWARD = 5;
20   uint constant SECOND_GENERATION_REWARD = 3;
21   uint constant THIRD_GENERATION_REWARD = 2;
22 
23   address public OWNER_ADDR;
24   address public RECOMM_ADDR;
25   address public SPARE_RECOMM_ADDR;
26 
27   uint public lastStage;
28   uint public lastRound;
29 
30   /// *** Struct
31 
32   struct UserRecomm {
33     address addr;
34   }
35 
36   struct StageInfo {
37     uint round;
38     bytes32 seedHash;
39     uint userNumber;
40     uint amount;
41     uint lastTime;
42   }
43 
44   struct UserBet {
45     address addr;
46     uint amount;
47     uint[] content;
48     uint count;
49     uint createAt;
50   }
51   
52   address[] private userRecomms;
53   UserBet[] private WaitAwardBets;
54 
55   /// *** Mapping
56 
57   mapping(uint => StageInfo) public stages;
58   mapping(address => address) public users;
59   mapping(uint => UserBet[]) public userBets;
60   mapping(uint => mapping(uint => mapping(address => bool))) private userBetAddrs;
61 
62   /// *** Event
63 
64   event eventUserBet(
65     string eventType,
66     address addr,
67     uint amount,
68     uint stage,
69     uint round,
70     uint count,
71     uint[] content,
72     uint createAt
73   );
74 
75   event eventLottery(
76     string eventType,
77     uint stage,
78     uint round,
79     uint[] lotteryContent,
80     uint createAt
81   );
82 
83   event eventDividend(
84     string eventType,
85     address addr,
86     uint amount,
87     uint stage,
88     uint round,
89     uint count,
90     uint[] content,
91     uint level,
92     address recommAddr,
93     uint recommReward,
94     uint createAt
95   );
96 
97   event eventReward(
98     string eventType,
99     address addr,
100     uint amount,
101     uint stage,
102     uint round,
103     uint count,
104     uint[] content,
105     uint[] lotteryContent,
106     uint reward,
107     uint createAt
108   );
109 
110   /// *** Modifier
111 
112   modifier checkBetTime(uint lastTime) {
113     require(now <= lastTime + 5 minutes, 'Current time is not allowed to bet');
114     _;
115   }
116 
117   modifier checkRewardTime(uint lastTime) {
118     require(
119       now >= lastTime + 10 minutes,
120       'Current time is not allowed to reward'
121     );
122     _;
123   }
124 
125   modifier isSecretNumber(uint stage, string seed) {
126     require(
127       keccak256(abi.encodePacked(seed)) == stages[stage].seedHash,
128       'Encrypted numbers are illegal'
129     );
130     _;
131   }
132 
133   modifier verifyStage(uint stage) {
134     require(
135       stage >= 1 && stage <= MAX_STAGE,
136       'Stage no greater than 5 (MAX_STAGE)'
137     );
138     _;
139   }
140 
141   modifier verifySeedHash(uint stage, bytes32 seedHash) {
142     require(
143       stages[stage].seedHash == seedHash && seedHash != 0,
144       'The hash of the stage is illegal'
145     );
146     _;
147   }
148 
149   modifier onlyOwner() {
150     require(OWNER_ADDR == msg.sender, 'Permission denied');
151     _;
152   }
153 
154   constructor() public {
155     for (uint i = 1; i <= MAX_STAGE; i++) {
156       stages[i].round = 1;
157       stages[i].seedHash = 0x0;
158       stages[i].userNumber = 0;
159       stages[i].amount = 0;
160       stages[i].lastTime = now;
161     }
162 
163     OWNER_ADDR = msg.sender;
164     RECOMM_ADDR = msg.sender;
165     SPARE_RECOMM_ADDR = msg.sender;
166 
167     lastStage = 1;
168     lastRound = 1;
169   }
170 
171   function bet(
172     uint stage,
173     uint round,
174     uint[] content,
175     uint count,
176     address recommAddr,
177     bytes32 seedHash
178   ) public
179   payable
180   verifyStage(stage)
181   verifySeedHash(stage, seedHash)
182   checkBetTime(stages[stage].lastTime) {
183     require(stages[stage].round == round, 'Round illegal');
184     require(content.length == 3, 'The bet is 3 digits');
185 
186     require((
187         msg.value >= MIN_BET_MONEY
188             && msg.value <= MAX_BET_MONEY
189             && msg.value == MIN_BET_MONEY * (10 ** (stage - 1)) * count
190       ),
191       'The amount of the bet is illegal'
192     );
193     
194     require(msg.sender != recommAddr, 'The recommender cannot be himself');
195     
196     
197     if (users[msg.sender] == 0) {
198       if (recommAddr != RECOMM_ADDR) {
199         require(
200             users[recommAddr] != 0,
201             'Referrer is not legal'
202         );
203       }
204       users[msg.sender] = recommAddr;
205     }
206 
207     generateUserRelation(msg.sender, 3);
208     require(userRecomms.length <= 3, 'User relationship error');
209 
210     sendInviteDividends(stage, round, count, content);
211 
212     if (!userBetAddrs[stage][stages[stage].round][msg.sender]) {
213       stages[stage].userNumber++;
214       userBetAddrs[stage][stages[stage].round][msg.sender] = true;
215     }
216 
217     userBets[stage].push(UserBet(
218       msg.sender,
219       msg.value,
220       content,
221       count,
222       now
223     ));
224 
225     emit eventUserBet(
226       'userBet',
227       msg.sender,
228       msg.value,
229       stage,
230       round,
231       count,
232       content,
233       now
234     );
235   }
236 
237   function generateUserRelation(
238     address addr,
239     uint generation
240   ) private returns(bool) {
241     userRecomms.push(users[addr]);
242     if (users[addr] != RECOMM_ADDR && users[addr] != 0 && generation > 1) {
243         generateUserRelation(users[addr], generation - 1);
244     }
245   }
246 
247   function sendInviteDividends(
248     uint stage,
249     uint round,
250     uint count,
251     uint[] content
252   ) private {
253     uint[3] memory GENERATION_REWARD = [
254       FIRST_GENERATION_REWARD,
255       SECOND_GENERATION_REWARD,
256       THIRD_GENERATION_REWARD
257     ];
258     uint recomms = 0;
259     for (uint j = 0; j < userRecomms.length; j++) {
260       recomms += msg.value * GENERATION_REWARD[j] / 1000;
261       userRecomms[j].transfer(msg.value * GENERATION_REWARD[j] / 1000);
262 
263       emit eventDividend(
264         'dividend',
265         msg.sender,
266         msg.value,
267         stage,
268         round,
269         count,
270         content,
271         j,
272         userRecomms[j],
273         msg.value * GENERATION_REWARD[j] / 1000,
274         now
275       );
276     }
277 
278     stages[stage].amount += (msg.value - recomms);
279     delete userRecomms;
280   }
281 
282   function distributionReward(
283     uint stage,
284     string seed,
285     bytes32 seedHash
286   ) public
287   checkRewardTime(stages[stage].lastTime)
288   isSecretNumber(stage, seed)
289   verifyStage(stage)
290   onlyOwner {
291     if (stages[stage].userNumber >= MIN_BET_NUMBER) {
292       uint[] memory randoms = generateRandom(
293         seed,
294         stage,
295         userBets[stage].length
296       );
297       require(randoms.length == 3, 'Random number is illegal');
298 
299       bool isReward = CalcWinnersAndReward(randoms, stage);
300 
301       emit eventLottery(
302         'lottery',
303         stage,
304         stages[stage].round,
305         randoms,
306         now
307       );
308 
309       if (isReward) {
310         stages[stage].amount = 0;
311         
312         lastStage = stage;
313         lastRound = stages[stage].round;
314       }
315       
316       delete userBets[stage];
317       
318       stages[stage].round += 1;
319       stages[stage].userNumber = 0;
320       stages[stage].seedHash = seedHash;
321       
322       stages[stage].lastTime = now + 5 minutes;
323     } else {
324       stages[stage].lastTime = now;
325     }
326   }
327 
328   function CalcWinnersAndReward(
329     uint[] randoms,
330     uint stage
331   ) private onlyOwner returns(bool) {
332     uint counts = 0;
333     for (uint i = 0; i < userBets[stage].length; i++) {
334       if (randoms[0] == userBets[stage][i].content[0]
335         && randoms[1] == userBets[stage][i].content[1]
336         && randoms[2] == userBets[stage][i].content[2]) {
337         counts = counts + userBets[stage][i].count;
338         WaitAwardBets.push(UserBet(
339           userBets[stage][i].addr,
340           userBets[stage][i].amount,
341           userBets[stage][i].content,
342           userBets[stage][i].count,
343           userBets[stage][i].createAt
344         ));
345       }
346     }
347     if (WaitAwardBets.length == 0) {
348       for (uint j = 0; j < userBets[stage].length; j++) {
349         if ((randoms[0] == userBets[stage][j].content[0]
350             && randoms[1] == userBets[stage][j].content[1])
351               || (randoms[1] == userBets[stage][j].content[1]
352             && randoms[2] == userBets[stage][j].content[2])
353               || (randoms[0] == userBets[stage][j].content[0]
354             && randoms[2] == userBets[stage][j].content[2])) {
355           counts += userBets[stage][j].count;
356           WaitAwardBets.push(UserBet(
357             userBets[stage][j].addr,
358             userBets[stage][j].amount,
359             userBets[stage][j].content,
360             userBets[stage][j].count,
361             userBets[stage][j].createAt
362           ));
363         }
364       }
365     }
366     if (WaitAwardBets.length == 0) {
367       for (uint k = 0; k < userBets[stage].length; k++) {
368         if (randoms[0] == userBets[stage][k].content[0]
369             || randoms[1] == userBets[stage][k].content[1]
370             || randoms[2] == userBets[stage][k].content[2]) {
371           counts += userBets[stage][k].count;
372           WaitAwardBets.push(UserBet(
373             userBets[stage][k].addr,
374             userBets[stage][k].amount,
375             userBets[stage][k].content,
376             userBets[stage][k].count,
377             userBets[stage][k].createAt
378           ));
379         }
380       }
381     }
382 
383     uint extractReward = stages[stage].amount / 100;
384     RECOMM_ADDR.transfer(extractReward);
385     SPARE_RECOMM_ADDR.transfer(extractReward);
386     OWNER_ADDR.transfer(extractReward);
387 
388     if (WaitAwardBets.length != 0) {
389       issueReward(stage, extractReward, randoms, counts);
390       delete WaitAwardBets;
391       return true;
392     }
393     stages[stage].amount = stages[stage].amount - extractReward - extractReward - extractReward;
394     return false;
395   }
396   
397   function issueReward(
398     uint stage,
399     uint extractReward,
400     uint[] randoms,
401     uint counts
402   ) private onlyOwner {
403     uint userAward = stages[stage].amount - extractReward - extractReward - extractReward;
404     for (uint m = 0; m < WaitAwardBets.length; m++) {
405       uint reward = userAward * WaitAwardBets[m].count / counts;
406       WaitAwardBets[m].addr.transfer(reward);
407 
408       emit eventReward(
409         'reward',
410         WaitAwardBets[m].addr,
411         WaitAwardBets[m].amount,
412         stage,
413         stages[stage].round,
414         WaitAwardBets[m].count,
415         WaitAwardBets[m].content,
416         randoms,
417         reward,
418         now
419       );
420     }
421   }
422 
423   function generateRandom(
424     string seed,
425     uint stage,
426     uint betNum
427   ) private view onlyOwner
428   isSecretNumber(stage, seed) returns(uint[]) {
429     uint[] memory randoms = new uint[](3);
430     for (uint i = 0; i < 3; i++) {
431       randoms[i] = uint(
432         keccak256(abi.encodePacked(betNum, block.difficulty, seed, now, i))
433       ) % 9 + 1;
434     }
435     return randoms;
436   }
437 
438   function setSeedHash(uint stage, bytes32 seedHash) public onlyOwner {
439     require(
440       stages[stage].seedHash == 0,
441       'No need to set seed hash'
442     );
443     stages[stage].seedHash = seedHash;
444   }
445 
446   function setDefaultRecommAddr(address _RECOMM_ADDR) public onlyOwner {
447     RECOMM_ADDR = _RECOMM_ADDR;
448   }
449 
450   function setSpareRecommAddr(address _SPARE_RECOMM_ADDR) public onlyOwner {
451     SPARE_RECOMM_ADDR = _SPARE_RECOMM_ADDR;
452   }
453 
454   function getDefaultRecommAddr() public view returns(address) {
455     return RECOMM_ADDR;
456   }
457 
458   function getSpareRecommAddr() public view returns(address) {
459     return SPARE_RECOMM_ADDR;
460   }
461 }