1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6  * Web              - https://winethfree.com
7  * Twitter          - https://twitter.com/winethfree
8  * Telegram_channel - https://t.me/winethfree
9  * Telegram_group   - https://t.me/wef_group
10  *
11  * __          ___         ______ _______ _    _   ______
12  * \ \        / (_)       |  ____|__   __| |  | | |  ____|
13  *  \ \  /\  / / _ _ __   | |__     | |  | |__| | | |__ _ __ ___  ___
14  *   \ \/  \/ / | | '_ \  |  __|    | |  |  __  | |  __| '__/ _ \/ _ \
15  *    \  /\  /  | | | | | | |____   | |  | |  | | | |  | | |  __/  __/
16  *     \/  \/   |_|_| |_| |______|  |_|  |_|  |_| |_|  |_|  \___|\___|
17  */
18 
19 contract Accessibility {
20     address internal owner;
21     modifier onlyOwner() {
22         require(msg.sender == owner, "access denied");
23         _;
24     }
25 
26     modifier isHuman() {
27         address _addr = msg.sender;
28         uint _codeLength;
29 
30         assembly {_codeLength := extcodesize(_addr)}
31         require(_codeLength == 0, "sorry humans only");
32         _;
33     }
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 }
39 
40 contract SicBo is Accessibility {
41     // using SafeMath for *;
42 
43     struct Record {
44         uint blockNum;
45         address player;
46         uint8[] index;
47         uint16[] bet;
48     }
49 
50     uint public pWagerPrice = 10 finney;
51     uint public pMaxWins = 5 ether;
52 
53     uint public seqId = 0;
54     uint public drawId = 0;
55 
56     mapping(uint => Record) private gRecords;
57 
58     function() payable public {
59         gCroupiers[msg.sender] = true;
60     }
61 
62     mapping(address => bool) private gCroupiers;
63 
64     modifier onlyCroupier {
65         require(gCroupiers[msg.sender] == true, "OnlyCroupier methods called by non-croupier.");
66         _;
67     }
68 
69     function setCroupier(address addr) external onlyOwner {
70         gCroupiers[addr] = true;
71     }
72 
73     function setMaxWin(uint value) external onlyCroupier {
74         pMaxWins = value;
75     }
76 
77     function setWagerPrice(uint value) external onlyCroupier {
78         pWagerPrice = value;
79     }
80 
81     function withdraw(address receive, uint value) external onlyOwner {
82         require(address(this).balance >= value, "no enough balance");
83         receive.transfer(value);
84     }
85 
86     function sortRandomNums() private view returns(uint[] memory) {
87 
88         uint random = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.difficulty, block.coinbase, now)));
89 
90         uint[] memory nums = new uint[](3);
91         nums[0] = (random & 0xFFFFFFFFFFFFFFFF) % 6 + 1;
92         nums[1] = ((random >> 64) & 0xFFFFFFFFFFFFFFFF) % 6 + 1;
93         nums[2] = (random >> 128) % 6 + 1;
94 
95         sort(nums);
96         return(nums);
97     }
98 
99     function sort(uint[] memory data) private pure {
100         uint temp;
101         if (data[0] > data[1]) {
102             temp = data[0];
103             data[0] = data[1];
104             data[1] = temp;
105         }
106 
107         if (data[1] > data[2]) {
108             temp = data[1];
109             data[1] = data[2];
110             data[2] = temp;
111         }
112 
113         if (data[0] > data[1]) {
114             temp = data[0];
115             data[0] = data[1];
116             data[1] = temp;
117         }
118     }
119 
120     function betMatch(uint8[] memory index, uint16[] memory value, uint[] memory nums) private pure returns(uint win) {
121         uint sum = nums[0] + nums[1] + nums[2];
122 
123         uint wager;
124         uint matched;
125         uint i;
126         uint k;
127 
128         for (uint j = 0; j < index.length; j++) {
129             i = index[j];
130             wager = value[j];
131 
132             if (wager == 0)
133                 continue;
134 
135             if (i == 0) {
136                 // sum: 3 - 10, odds: 1
137                 if (sum < 11 && (nums[0] != nums[1] || nums[1] != nums[2])) {
138                     win += wager * 2;
139                 }
140             } else if (i == 1) {
141                 // sum: 11 - 18, odds: 1
142                 if (sum > 10 && (nums[0] != nums[1] || nums[1] != nums[2])) {
143                     win += wager * 2;
144                 }
145             } else if (i == 2) {
146                 // num: [1, 1, x], odds: 10
147                 if (nums[0] == 1 && nums[1] == 1) {
148                     win += wager * 11;
149                 }
150             } else if (i == 3) {
151                 // num: [2, 2, x], odds: 10
152                 if ((nums[0] == 2 && nums[1] == 2) || (nums[1] == 2 && nums[2] == 2)) {
153                     win += wager * 11;
154                 }
155             } else if (i == 4) {
156                 // num: [3, 3, x], odds: 10
157                 if ((nums[0] == 3 && nums[1] == 3) || (nums[1] == 3 && nums[2] == 3)) {
158                     win += wager * 11;
159                 }
160             } else if (i == 5) {
161                 // num: [4, 4, x], odds: 10
162                 if ((nums[0] == 4 && nums[1] == 4) || (nums[1] == 4 && nums[2] == 4)) {
163                     win += wager * 11;
164                 }
165             } else if (i == 6) {
166                 // num: [5, 5, x], odds: 10
167                 if ((nums[0] == 5 && nums[1] == 5) || (nums[1] == 5 && nums[2] == 5)) {
168                     win += wager * 11;
169                 }
170             } else if (i == 7) {
171                 // num: [6, 6, x], odds: 10
172                 if ((nums[0] == 6 && nums[1] == 6) || (nums[1] == 6 && nums[2] == 6)) {
173                     win += wager * 11;
174                 }
175             } else if (i == 8) {
176                 // num: [1, 1, 1], odds: 180
177                 if (sum == 3) {
178                     win += wager * 181;
179                 }
180             } else if (i == 9) {
181                 // num: [2, 2, 2], odds: 180
182                 if (nums[0] == 2 && nums[1] == 2 && nums[2] == 2) {
183                     win += wager * 181;
184                 }
185             } else if (i == 10) {
186                 // num: [3, 3, 3], odds: 180
187                 if (nums[0] == 3 && nums[1] == 3 && nums[2] == 3) {
188                     win += wager * 181;
189                 }
190             } else if (i == 11) {
191                 // num: [4, 4, 4], odds: 180
192                 if (nums[0] == 4 && nums[1] == 4 && nums[2] == 4) {
193                     win += wager * 181;
194                 }
195             } else if (i == 12) {
196                 // num: [5, 5, 5], odds: 180
197                 if (nums[0] == 5 && nums[1] == 5 && nums[2] == 5) {
198                     win += wager * 181;
199                 }
200             } else if (i == 13) {
201                 // num: [6, 6, 6], odds: 180
202                 if (sum == 18) {
203                     win += wager * 181;
204                 }
205             } else if (i == 14) {
206                 // num: [x, x, x], odds: 30
207                 if (nums[0] == nums[1] && nums[1] == nums[2]) {
208                     win += wager * 31;
209                 }
210             } else if (i == 15) {
211                 // sum: 4, odds: 60
212                 if (sum == 4) {
213                     win += wager * 61;
214                 }
215             } else if (i == 16) {
216                 // sum: 5, odds: 30
217                 if (sum == 5) {
218                     win += wager * 31;
219                 }
220             } else if (i == 17) {
221                 // sum: 6, odds: 18
222                 if (sum == 6) {
223                     win += wager * 19;
224                 }
225             } else if (i == 18) {
226                 // sum: 7, odds: 12
227                 if (sum == 7) {
228                     win += wager * 13;
229                 }
230             } else if (i == 19) {
231                 // sum: 8, odds: 8
232                 if (sum == 8) {
233                     win += wager * 9;
234                 }
235             } else if (i == 20) {
236                 // sum: 9, odds: 6
237                 if (sum == 9) {
238                     win += wager * 7;
239                 }
240             } else if (i == 21) {
241                 // sum: 10, odds: 6
242                 if (sum == 10) {
243                     win += wager * 7;
244                 }
245             } else if (i == 22) {
246                 // sum: 11, odds: 6
247                 if (sum == 11) {
248                     win += wager * 7;
249                 }
250             } else if (i == 23) {
251                 // sum: 12, odds: 6
252                 if (sum == 12) {
253                     win += wager * 7;
254                 }
255             } else if (i == 24) {
256                 // sum: 13, odds: 8
257                 if (sum == 13) {
258                     win += wager * 9;
259                 }
260             } else if (i == 25) {
261                 // sum: 14, odds: 12
262                 if (sum == 14) {
263                     win += wager * 13;
264                 }
265             } else if (i == 26) {
266                 // sum: 15, odds: 18
267                 if (sum == 15) {
268                     win += wager * 19;
269                 }
270             } else if (i == 27) {
271                 // sum: 16, odds: 30
272                 if (sum == 16) {
273                     win += wager * 31;
274                 }
275             } else if (i == 28) {
276                 // sum: 17, odds: 60
277                 if (sum == 17) {
278                     win += wager * 61;
279                 }
280             } else if (i == 29) {
281                 // num: [1, 2, x], odds: 5
282                 if (nums[0] == 1 && (nums[1] == 2 || nums[2] == 2)) {
283                     win += wager * 6;
284                 }
285             } else if (i == 30) {
286                 // num: [1, 3, x], odds: 5
287                 if (nums[0] == 1 && (nums[1] == 3 || nums[2] == 3)) {
288                     win += wager * 6;
289                 }
290             } else if (i == 31) {
291                 // num: [1, 4, x], odds: 5
292                 if (nums[0] == 1 && (nums[1] == 4 || nums[2] == 4)) {
293                     win += wager * 6;
294                 }
295             } else if (i == 32) {
296                 // num: [1, 5, x], odds: 5
297                 if (nums[0] == 1 && (nums[1] == 5 || nums[2] == 5)) {
298                     win += wager * 6;
299                 }
300             } else if (i == 33) {
301                 // num: [1, 6, x], odds: 5
302                 if (nums[0] == 1 && (nums[1] == 6 || nums[2] == 6)) {
303                     win += wager * 6;
304                 }
305             } else if (i == 34) {
306                 // num: [2, 3, x], odds: 5
307                 if ((nums[0] == 2 && nums[1] == 3) || (nums[1] == 2 && nums[2] == 3)) {
308                     win += wager * 6;
309                 }
310             } else if (i == 35) {
311                 // num: [2, 4, x], odds: 5
312                 if ((nums[0] == 2 && nums[1] == 4) || (nums[1] == 2 && nums[2] == 4) || (nums[0] == 2 && nums[2] == 4)) {
313                     win += wager * 6;
314                 }
315             } else if (i == 36) {
316                 // num: [2, 5, x], odds: 5
317                 if ((nums[0] == 2 && nums[1] == 5) || (nums[1] == 2 && nums[2] == 5) || (nums[0] == 2 && nums[2] == 5)) {
318                     win += wager * 6;
319                 }
320             } else if (i == 37) {
321                 // num: [2, 6, x], odds: 5
322                 if ((nums[0] == 2 && nums[1] == 6) || (nums[1] == 2 && nums[2] == 6) || (nums[0] == 2 && nums[2] == 6)) {
323                     win += wager * 6;
324                 }
325             } else if (i == 38) {
326                 // num: [3, 4, x], odds: 5
327                 if ((nums[0] == 3 && nums[1] == 4) || (nums[1] == 3 && nums[2] == 4)) {
328                     win += wager * 6;
329                 }
330             } else if (i == 39) {
331                 // num: [3, 5, x], odds: 5
332                 if ((nums[0] == 3 && nums[1] == 5) || (nums[1] == 3 && nums[2] == 5) || (nums[0] == 3 && nums[2] == 5)) {
333                     win += wager * 6;
334                 }
335             } else if (i == 40) {
336                 // num: [3, 6, x], odds: 5
337                 if ((nums[0] == 3 && nums[1] == 6) || (nums[1] == 3 && nums[2] == 6) || (nums[0] == 3 && nums[2] == 6)) {
338                     win += wager * 6;
339                 }
340             } else if (i == 41) {
341                 // num: [4, 5, x], odds: 5
342                 if ((nums[0] == 4 && nums[1] == 5) || (nums[1] == 4 && nums[2] == 5)) {
343                     win += wager * 6;
344                 }
345             } else if (i == 42) {
346                 // num: [4, 6, x], odds: 5
347                 if ((nums[0] == 4 && nums[1] == 6) || (nums[1] == 4 && nums[2] == 6) || (nums[0] == 4 && nums[2] == 6)) {
348                     win += wager * 6;
349                 }
350             } else if (i == 43) {
351                 // num: [5, 6, x], odds: 5
352                 if ((nums[0] == 5 && nums[1] == 6) || (nums[1] == 5 && nums[2] == 6)) {
353                     win += wager * 6;
354                 }
355             } else if (i == 44) {
356                 // num: num of 1, odds: num of 1
357                 matched = 0;
358                 for (k = 0; k < 3; k++) {
359                     if (nums[k] == 1) {
360                         matched += 1;
361                     }
362                 }
363                 if (matched > 0) {
364                     win += wager * (matched + 1);
365                 }
366             } else if (i == 45) {
367                 // num: num of 2, odds: num of 2
368                 matched = 0;
369                 for (k = 0; k < 3; k++) {
370                     if (nums[k] == 2) {
371                         matched += 1;
372                     }
373                 }
374                 if (matched > 0) {
375                     win += wager * (matched + 1);
376                 }
377             } else if (i == 46) {
378                 // num: num of 3, odds: num of 3
379                 matched = 0;
380                 for (k = 0; k < 3; k++) {
381                     if (nums[k] == 3) {
382                         matched += 1;
383                     }
384                 }
385                 if (matched > 0) {
386                     win += wager * (matched + 1);
387                 }
388             } else if (i == 47) {
389                 // num: num of 4, odds: num of 4
390                 matched = 0;
391                 for (k = 0; k < 3; k++) {
392                     if (nums[k] == 4) {
393                         matched += 1;
394                     }
395                 }
396                 if (matched > 0) {
397                     win += wager * (matched + 1);
398                 }
399             } else if (i == 48) {
400                 // num: num of 5, odds: num of 5
401                 matched = 0;
402                 for (k = 0; k < 3; k++) {
403                     if (nums[k] == 5) {
404                         matched += 1;
405                     }
406                 }
407                 if (matched > 0) {
408                     win += wager * (matched + 1);
409                 }
410             } else {
411                 // num: num of 6, odds: num of 6
412                 matched = 0;
413                 for (k = 0; k < 3; k++) {
414                     if (nums[k] == 6) {
415                         matched += 1;
416                     }
417                 }
418                 if (matched > 0) {
419                     win += wager * (matched + 1);
420                 }
421             }
422         }
423     }
424 
425     event LogBet(address, uint8[], uint16[], uint[], uint);
426 
427     function doBet(uint8[] memory index, uint16[] memory bet) isHuman() payable public {
428         uint value = msg.value;
429         address sender = msg.sender;
430 
431         require(value >= pWagerPrice, "too little wager");
432         require(index.length == bet.length, "wrong params");
433         require(address(this).balance >= pMaxWins, "out of balance");
434 
435         uint wagers;
436         uint8 j;
437 
438         for (uint8 i = 0; i < index.length; i++) {
439             j = index[i];
440             require(j >= 0 && j < 50, "wrong index");
441             wagers += bet[i];
442         }
443         require(value / pWagerPrice == wagers, "wrong bet");
444 
445         uint id = seqId++;
446 
447         gRecords[id].blockNum = block.number;
448         gRecords[id].player = sender;
449         gRecords[id].index = index;
450         gRecords[id].bet = bet;
451     }
452 
453     function drawLottery(address player, uint8[] memory index, uint16[] memory bet, uint[] memory nums) private {
454         uint wins;
455         uint maxWins = pMaxWins / pWagerPrice;
456 
457         wins = betMatch(index, bet, nums);
458 
459         if (wins > 0) {
460             if ( wins > maxWins) {
461                 wins = maxWins;
462             }
463 
464             player.transfer(wins * pWagerPrice);
465         }
466 
467         emit LogBet(player, index, bet, nums, wins);
468     }
469 
470     function settleBet() external onlyCroupier {
471         uint[] memory nums = sortRandomNums();
472 
473         if (drawId == seqId)
474             return;
475 
476         for (uint i = drawId; i < seqId && gRecords[i].blockNum < block.number; i++) {
477             drawLottery(gRecords[i].player, gRecords[i].index, gRecords[i].bet, nums);
478         }
479         drawId = i;
480     }
481 }