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
151   constructor(bytes32[4] hashes, uint lastTime) public {
152     for (uint i = 1; i <= MAX_STAGE; i++) {
153       stages[i].round = 1;
154       stages[i].seedHash = hashes[i-1];
155       stages[i].userNumber = 0;
156       stages[i].amount = 0;
157       stages[i].lastTime = lastTime;
158     }
159 
160     OWNER_ADDR = msg.sender;
161     RECOMM_ADDR = msg.sender;
162     SPARE_RECOMM_ADDR = msg.sender;
163   }
164 
165   function bet(
166     uint stage,
167     uint round,
168     uint[] content,
169     uint count,
170     address recommAddr,
171     bytes32 seedHash
172   ) public
173   payable
174   verifyStage(stage)
175   verifySeedHash(stage, seedHash)
176   checkBetTime(stages[stage].lastTime) {
177     require(stages[stage].round == round, 'Round illegal');
178     require(content.length == 3, 'The bet is 3 digits');
179 
180     require((
181         msg.value >= MIN_BET_MONEY
182             && msg.value <= MAX_BET_MONEY
183             && msg.value == MIN_BET_MONEY * (10 ** (stage - 1)) * count
184       ),
185       'The amount of the bet is illegal'
186     );
187     
188     require(msg.sender != recommAddr, 'The recommender cannot be himself');
189     
190     if (users[msg.sender] == 0) {
191       if (recommAddr != RECOMM_ADDR) {
192         require(
193             users[recommAddr] != 0,
194             'Referrer is not legal'
195         );
196       }
197       users[msg.sender] = recommAddr;
198     }
199 
200     generateUserRelation(msg.sender, 3);
201     require(userRecomms.length <= 3, 'User relationship error');
202 
203     sendInviteDividends(stage, round, count, content);
204 
205     if (!userBetAddrs[stage][stages[stage].round][msg.sender]) {
206       stages[stage].userNumber++;
207       userBetAddrs[stage][stages[stage].round][msg.sender] = true;
208     }
209 
210     userBets[stage].push(UserBet(
211       msg.sender,
212       msg.value,
213       content,
214       count,
215       now
216     ));
217 
218     emit eventUserBet(
219       'userBet',
220       msg.sender,
221       msg.value,
222       stage,
223       round,
224       count,
225       content,
226       now
227     );
228   }
229 
230   function generateUserRelation(
231     address addr,
232     uint generation
233   ) private returns(bool) {
234     userRecomms.push(users[addr]);
235     if (users[addr] != RECOMM_ADDR && users[addr] != 0 && generation > 1) {
236         generateUserRelation(users[addr], generation - 1);
237     }
238   }
239 
240   function sendInviteDividends(
241     uint stage,
242     uint round,
243     uint count,
244     uint[] content
245   ) private {
246     uint[3] memory GENERATION_REWARD = [
247       FIRST_GENERATION_REWARD,
248       SECOND_GENERATION_REWARD,
249       THIRD_GENERATION_REWARD
250     ];
251     uint recomms = 0;
252     for (uint j = 0; j < userRecomms.length; j++) {
253       recomms += msg.value * GENERATION_REWARD[j] / 100;
254       userRecomms[j].transfer(msg.value * GENERATION_REWARD[j] / 100);
255 
256       emit eventDividend(
257         'dividend',
258         msg.sender,
259         msg.value,
260         stage,
261         round,
262         count,
263         content,
264         j,
265         userRecomms[j],
266         msg.value * GENERATION_REWARD[j] / 100,
267         now
268       );
269     }
270 
271     stages[stage].amount += (msg.value - recomms);
272     delete userRecomms;
273   }
274 
275   function distributionReward(
276     uint stage,
277     string seed,
278     bytes32 seedHash
279   ) public
280   checkRewardTime(stages[stage].lastTime)
281   isSecretNumber(stage, seed)
282   verifyStage(stage)
283   onlyOwner {
284     if (stages[stage].userNumber >= MIN_BET_NUMBER) {
285       uint[] memory randoms = generateRandom(
286         seed,
287         stage,
288         userBets[stage].length
289       );
290       require(randoms.length == 3, 'Random number is illegal');
291 
292       bool isReward = CalcWinnersAndReward(randoms, stage);
293 
294       emit eventLottery(
295         'lottery',
296         stage,
297         stages[stage].round,
298         randoms,
299         now
300       );
301 
302       if (isReward) {
303         stages[stage].amount = 0;
304       }
305       
306       delete userBets[stage];
307       
308       stages[stage].round += 1;
309       stages[stage].userNumber = 0;
310       stages[stage].seedHash = seedHash;
311 
312       stages[stage].lastTime += 24 hours;
313     } else {
314       stages[stage].lastTime += 24 hours;
315     }
316   }
317 
318   function CalcWinnersAndReward(
319     uint[] randoms,
320     uint stage
321   ) private onlyOwner returns(bool) {
322     uint counts = 0;
323     for (uint i = 0; i < userBets[stage].length; i++) {
324       if (randoms[0] == userBets[stage][i].content[0]
325         && randoms[1] == userBets[stage][i].content[1]
326         && randoms[2] == userBets[stage][i].content[2]) {
327         counts = counts + userBets[stage][i].count;
328         WaitAwardBets.push(UserBet(
329           userBets[stage][i].addr,
330           userBets[stage][i].amount,
331           userBets[stage][i].content,
332           userBets[stage][i].count,
333           userBets[stage][i].createAt
334         ));
335       }
336     }
337     if (WaitAwardBets.length == 0) {
338       for (uint j = 0; j < userBets[stage].length; j++) {
339         if ((randoms[0] == userBets[stage][j].content[0]
340             && randoms[1] == userBets[stage][j].content[1])
341               || (randoms[1] == userBets[stage][j].content[1]
342             && randoms[2] == userBets[stage][j].content[2])
343               || (randoms[0] == userBets[stage][j].content[0]
344             && randoms[2] == userBets[stage][j].content[2])) {
345           counts += userBets[stage][j].count;
346           WaitAwardBets.push(UserBet(
347             userBets[stage][j].addr,
348             userBets[stage][j].amount,
349             userBets[stage][j].content,
350             userBets[stage][j].count,
351             userBets[stage][j].createAt
352           ));
353         }
354       }
355     }
356     if (WaitAwardBets.length == 0) {
357       for (uint k = 0; k < userBets[stage].length; k++) {
358         if (randoms[0] == userBets[stage][k].content[0]
359             || randoms[1] == userBets[stage][k].content[1]
360             || randoms[2] == userBets[stage][k].content[2]) {
361           counts += userBets[stage][k].count;
362           WaitAwardBets.push(UserBet(
363             userBets[stage][k].addr,
364             userBets[stage][k].amount,
365             userBets[stage][k].content,
366             userBets[stage][k].count,
367             userBets[stage][k].createAt
368           ));
369         }
370       }
371     }
372 
373     uint extractReward = stages[stage].amount / 100;
374     OWNER_ADDR.transfer(extractReward);
375     RECOMM_ADDR.transfer(extractReward);
376     SPARE_RECOMM_ADDR.transfer(extractReward);
377 
378     if (WaitAwardBets.length != 0) {
379       issueReward(stage, extractReward, randoms, counts);
380       delete WaitAwardBets;
381       return true;
382     }
383     stages[stage].amount = stages[stage].amount - (extractReward * 3);
384     return false;
385   }
386   
387   function issueReward(
388     uint stage,
389     uint extractReward,
390     uint[] randoms,
391     uint counts
392   ) private onlyOwner {
393     uint userAward = stages[stage].amount - (extractReward * 3);
394     for (uint m = 0; m < WaitAwardBets.length; m++) {
395       uint reward = userAward * WaitAwardBets[m].count / counts;
396       WaitAwardBets[m].addr.transfer(reward);
397 
398       emit eventReward(
399         'reward',
400         WaitAwardBets[m].addr,
401         WaitAwardBets[m].amount,
402         stage,
403         stages[stage].round,
404         WaitAwardBets[m].count,
405         WaitAwardBets[m].content,
406         randoms,
407         reward,
408         now
409       );
410     }
411   }
412 
413   function generateRandom(
414     string seed,
415     uint stage,
416     uint betNum
417   ) private view onlyOwner
418   isSecretNumber(stage, seed) returns(uint[]) {
419     uint[] memory randoms = new uint[](3);
420     for (uint i = 0; i < 3; i++) {
421       randoms[i] = uint(
422         keccak256(abi.encodePacked(betNum, block.difficulty, seed, now, i))
423       ) % 9 + 1;
424     }
425     return randoms;
426   }
427 
428   function setDefaultRecommAddr(address _RECOMM_ADDR) public onlyOwner {
429     RECOMM_ADDR = _RECOMM_ADDR;
430   }
431 
432   function setSpareRecommAddr(address _SPARE_RECOMM_ADDR) public onlyOwner {
433     SPARE_RECOMM_ADDR = _SPARE_RECOMM_ADDR;
434   }
435 }