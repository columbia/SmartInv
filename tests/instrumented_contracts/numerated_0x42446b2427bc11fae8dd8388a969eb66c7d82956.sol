1 pragma solidity ^0.4.24;
2 
3 
4 contract Accessibility {
5     address internal owner;
6     modifier onlyOwner() {
7         require(msg.sender == owner, "access denied");
8         _;
9     }
10 
11     modifier isHuman() {
12         address _addr = msg.sender;
13         uint _codeLength;
14 
15         assembly {_codeLength := extcodesize(_addr)}
16         require(_codeLength == 0, "sorry humans only");
17         _;
18     }
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 }
24 
25 contract SicBo is Accessibility {
26     // using SafeMath for *;
27 
28     uint public constant pWagerPrice = 10 finney;
29     uint public constant pMaxWins = 5 ether;
30 
31     function() payable public {
32 
33     }
34 
35     function withdraw(address receive, uint value) external onlyOwner {
36         require(address(this).balance >= value, "no enough balance");
37         receive.transfer(value);
38     }
39 
40     function sortRandomNums(uint input) private view returns(uint[] memory) {
41 
42         uint tmp = (now & input) % 247;
43         uint blockNum = block.number - 1 - tmp;
44         uint random = uint(keccak256(abi.encodePacked(input, blockhash(blockNum), block.difficulty, block.coinbase, now)));
45 
46         uint[] memory nums = new uint[](3);
47         nums[0] = (random & 0xFFFFFFFFFFFFFFFF) % 6 + 1;
48         nums[1] = ((random >> 64) & 0xFFFFFFFFFFFFFFFF) % 6 + 1;
49         nums[2] = (random >> 128) % 6 + 1;
50 
51         sort(nums);
52         return(nums);
53     }
54 
55     function sort(uint[] memory data) private pure {
56         uint temp;
57         if (data[0] > data[1]) {
58             temp = data[0];
59             data[0] = data[1];
60             data[1] = temp;
61         }
62 
63         if (data[1] > data[2]) {
64             temp = data[1];
65             data[1] = data[2];
66             data[2] = temp;
67         }
68 
69         if (data[0] > data[1]) {
70             temp = data[0];
71             data[0] = data[1];
72             data[1] = temp;
73         }
74     }
75 
76     function betMatch(uint8[] memory index, uint16[] memory value, uint[] memory nums) private pure returns(uint wagers, uint win) {
77         uint sum = nums[0] + nums[1] + nums[2];
78 
79         uint wager;
80         uint matched;
81         uint i;
82         uint k;
83 
84         for (uint j = 0; j < index.length; j++) {
85             i = index[j];
86             wager = value[j];
87 
88             if (wager == 0)
89                 continue;
90 
91             wagers += wager;
92 
93             if (i == 0) {
94                 // sum: 3 - 10, odds: 1
95                 if (sum < 11 && (nums[0] != nums[1] || nums[1] != nums[2])) {
96                     win += wager * 2;
97                 }
98             } else if (i == 1) {
99                 // sum: 11 - 18, odds: 1
100                 if (sum > 10 && (nums[0] != nums[1] || nums[1] != nums[2])) {
101                     win += wager * 2;
102                 }
103             } else if (i == 2) {
104                 // num: [1, 1, x], odds: 10
105                 if (nums[0] == 1 && nums[1] == 1) {
106                     win += wager * 11;
107                 }
108             } else if (i == 3) {
109                 // num: [2, 2, x], odds: 10
110                 if ((nums[0] == 2 && nums[1] == 2) || (nums[1] == 2 && nums[2] == 2)) {
111                     win += wager * 11;
112                 }
113             } else if (i == 4) {
114                 // num: [3, 3, x], odds: 10
115                 if ((nums[0] == 3 && nums[1] == 3) || (nums[1] == 3 && nums[2] == 3)) {
116                     win += wager * 11;
117                 }
118             } else if (i == 5) {
119                 // num: [4, 4, x], odds: 10
120                 if ((nums[0] == 4 && nums[1] == 4) || (nums[1] == 4 && nums[2] == 4)) {
121                     win += wager * 11;
122                 }
123             } else if (i == 6) {
124                 // num: [5, 5, x], odds: 10
125                 if ((nums[0] == 5 && nums[1] == 5) || (nums[1] == 5 && nums[2] == 5)) {
126                     win += wager * 11;
127                 }
128             } else if (i == 7) {
129                 // num: [6, 6, x], odds: 10
130                 if ((nums[0] == 6 && nums[1] == 6) || (nums[1] == 6 && nums[2] == 6)) {
131                     win += wager * 11;
132                 }
133             } else if (i == 8) {
134                 // num: [1, 1, 1], odds: 180
135                 if (sum == 3) {
136                     win += wager * 181;
137                 }
138             } else if (i == 9) {
139                 // num: [2, 2, 2], odds: 180
140                 if (nums[0] == 2 && nums[1] == 2 && nums[2] == 2) {
141                     win += wager * 181;
142                 }
143             } else if (i == 10) {
144                 // num: [3, 3, 3], odds: 180
145                 if (nums[0] == 3 && nums[1] == 3 && nums[2] == 3) {
146                     win += wager * 181;
147                 }
148             } else if (i == 11) {
149                 // num: [4, 4, 4], odds: 180
150                 if (nums[0] == 4 && nums[1] == 4 && nums[2] == 4) {
151                     win += wager * 181;
152                 }
153             } else if (i == 12) {
154                 // num: [5, 5, 5], odds: 180
155                 if (nums[0] == 5 && nums[1] == 5 && nums[2] == 5) {
156                     win += wager * 181;
157                 }
158             } else if (i == 13) {
159                 // num: [6, 6, 6], odds: 180
160                 if (sum == 18) {
161                     win += wager * 181;
162                 }
163             } else if (i == 14) {
164                 // num: [x, x, x], odds: 30
165                 if (nums[0] == nums[1] && nums[1] == nums[2]) {
166                     win += wager * 31;
167                 }
168             } else if (i == 15) {
169                 // sum: 4, odds: 60
170                 if (sum == 4) {
171                     win += wager * 61;
172                 }
173             } else if (i == 16) {
174                 // sum: 5, odds: 30
175                 if (sum == 5) {
176                     win += wager * 31;
177                 }
178             } else if (i == 17) {
179                 // sum: 6, odds: 18
180                 if (sum == 6) {
181                     win += wager * 19;
182                 }
183             } else if (i == 18) {
184                 // sum: 7, odds: 12
185                 if (sum == 7) {
186                     win += wager * 13;
187                 }
188             } else if (i == 19) {
189                 // sum: 8, odds: 8
190                 if (sum == 8) {
191                     win += wager * 9;
192                 }
193             } else if (i == 20) {
194                 // sum: 9, odds: 6
195                 if (sum == 9) {
196                     win += wager * 7;
197                 }
198             } else if (i == 21) {
199                 // sum: 10, odds: 6
200                 if (sum == 10) {
201                     win += wager * 7;
202                 }
203             } else if (i == 22) {
204                 // sum: 11, odds: 6
205                 if (sum == 11) {
206                     win += wager * 7;
207                 }
208             } else if (i == 23) {
209                 // sum: 12, odds: 6
210                 if (sum == 12) {
211                     win += wager * 7;
212                 }
213             } else if (i == 24) {
214                 // sum: 13, odds: 8
215                 if (sum == 13) {
216                     win += wager * 9;
217                 }
218             } else if (i == 25) {
219                 // sum: 14, odds: 12
220                 if (sum == 14) {
221                     win += wager * 13;
222                 }
223             } else if (i == 26) {
224                 // sum: 15, odds: 18
225                 if (sum == 15) {
226                     win += wager * 19;
227                 }
228             } else if (i == 27) {
229                 // sum: 16, odds: 30
230                 if (sum == 16) {
231                     win += wager * 31;
232                 }
233             } else if (i == 28) {
234                 // sum: 17, odds: 60
235                 if (sum == 17) {
236                     win += wager * 61;
237                 }
238             } else if (i == 29) {
239                 // num: [1, 2, x], odds: 5
240                 if (nums[0] == 1 && (nums[1] == 2 || nums[2] == 2)) {
241                     win += wager * 6;
242                 }
243             } else if (i == 30) {
244                 // num: [1, 3, x], odds: 5
245                 if (nums[0] == 1 && (nums[1] == 3 || nums[2] == 3)) {
246                     win += wager * 6;
247                 }
248             } else if (i == 31) {
249                 // num: [1, 4, x], odds: 5
250                 if (nums[0] == 1 && (nums[1] == 4 || nums[2] == 4)) {
251                     win += wager * 6;
252                 }
253             } else if (i == 32) {
254                 // num: [1, 5, x], odds: 5
255                 if (nums[0] == 1 && (nums[1] == 5 || nums[2] == 5)) {
256                     win += wager * 6;
257                 }
258             } else if (i == 33) {
259                 // num: [1, 6, x], odds: 5
260                 if (nums[0] == 1 && (nums[1] == 6 || nums[2] == 6)) {
261                     win += wager * 6;
262                 }
263             } else if (i == 34) {
264                 // num: [2, 3, x], odds: 5
265                 if ((nums[0] == 2 && nums[1] == 3) || (nums[1] == 2 && nums[2] == 3)) {
266                     win += wager * 6;
267                 }
268             } else if (i == 35) {
269                 // num: [2, 4, x], odds: 5
270                 if ((nums[0] == 2 && nums[1] == 4) || (nums[1] == 2 && nums[2] == 4) || (nums[0] == 2 && nums[2] == 4)) {
271                     win += wager * 6;
272                 }
273             } else if (i == 36) {
274                 // num: [2, 5, x], odds: 5
275                 if ((nums[0] == 2 && nums[1] == 5) || (nums[1] == 2 && nums[2] == 5) || (nums[0] == 2 && nums[2] == 5)) {
276                     win += wager * 6;
277                 }
278             } else if (i == 37) {
279                 // num: [2, 6, x], odds: 5
280                 if ((nums[0] == 2 && nums[1] == 6) || (nums[1] == 2 && nums[2] == 6) || (nums[0] == 2 && nums[2] == 6)) {
281                     win += wager * 6;
282                 }
283             } else if (i == 38) {
284                 // num: [3, 4, x], odds: 5
285                 if ((nums[0] == 3 && nums[1] == 4) || (nums[1] == 3 && nums[2] == 4)) {
286                     win += wager * 6;
287                 }
288             } else if (i == 39) {
289                 // num: [3, 5, x], odds: 5
290                 if ((nums[0] == 3 && nums[1] == 5) || (nums[1] == 3 && nums[2] == 5) || (nums[0] == 3 && nums[2] == 5)) {
291                     win += wager * 6;
292                 }
293             } else if (i == 40) {
294                 // num: [3, 6, x], odds: 5
295                 if ((nums[0] == 3 && nums[1] == 6) || (nums[1] == 3 && nums[2] == 6) || (nums[0] == 3 && nums[2] == 6)) {
296                     win += wager * 6;
297                 }
298             } else if (i == 41) {
299                 // num: [4, 5, x], odds: 5
300                 if ((nums[0] == 4 && nums[1] == 5) || (nums[1] == 4 && nums[2] == 5)) {
301                     win += wager * 6;
302                 }
303             } else if (i == 42) {
304                 // num: [4, 6, x], odds: 5
305                 if ((nums[0] == 4 && nums[1] == 6) || (nums[1] == 4 && nums[2] == 6) || (nums[0] == 4 && nums[2] == 6)) {
306                     win += wager * 6;
307                 }
308             } else if (i == 43) {
309                 // num: [5, 6, x], odds: 5
310                 if ((nums[0] == 5 && nums[1] == 6) || (nums[1] == 5 && nums[2] == 6)) {
311                     win += wager * 6;
312                 }
313             } else if (i == 44) {
314                 // num: num of 1, odds: num of 1
315                 matched = 0;
316                 for (k = 0; k < 3; k++) {
317                     if (nums[k] == 1) {
318                         matched += 1;
319                     }
320                 }
321                 if (matched > 0) {
322                     win += wager * (matched + 1);
323                 }
324             } else if (i == 45) {
325                 // num: num of 2, odds: num of 2
326                 matched = 0;
327                 for (k = 0; k < 3; k++) {
328                     if (nums[k] == 2) {
329                         matched += 1;
330                     }
331                 }
332                 if (matched > 0) {
333                     win += wager * (matched + 1);
334                 }
335             } else if (i == 46) {
336                 // num: num of 3, odds: num of 3
337                 matched = 0;
338                 for (k = 0; k < 3; k++) {
339                     if (nums[k] == 3) {
340                         matched += 1;
341                     }
342                 }
343                 if (matched > 0) {
344                     win += wager * (matched + 1);
345                 }
346             } else if (i == 47) {
347                 // num: num of 4, odds: num of 4
348                 matched = 0;
349                 for (k = 0; k < 3; k++) {
350                     if (nums[k] == 4) {
351                         matched += 1;
352                     }
353                 }
354                 if (matched > 0) {
355                     win += wager * (matched + 1);
356                 }
357             } else if (i == 48) {
358                 // num: num of 5, odds: num of 5
359                 matched = 0;
360                 for (k = 0; k < 3; k++) {
361                     if (nums[k] == 5) {
362                         matched += 1;
363                     }
364                 }
365                 if (matched > 0) {
366                     win += wager * (matched + 1);
367                 }
368             } else {
369                 // num: num of 6, odds: num of 6
370                 matched = 0;
371                 for (k = 0; k < 3; k++) {
372                     if (nums[k] == 6) {
373                         matched += 1;
374                     }
375                 }
376                 if (matched > 0) {
377                     win += wager * (matched + 1);
378                 }
379             }
380         }
381     }
382 
383     event LogBet(address, uint8[], uint16[], uint[], uint);
384 
385     function doBet(uint8[] memory index, uint16[] memory bet) isHuman() payable public {
386         uint value = msg.value;
387         address sender = msg.sender;
388 
389         require(value >= pWagerPrice, "too little wager");
390         require(index.length == bet.length, "wrong params");
391         require(address(this).balance >= pMaxWins, "out of balance");
392 
393         uint aggr;
394         uint8 j;
395 
396         for (uint8 i = 0; i < index.length; i++) {
397             j = index[i];
398             require(j >= 0 && j < 50, "wrong index");
399             aggr += (bet[i] << j);
400         }
401 
402         uint[] memory nums = sortRandomNums(aggr);
403 
404         uint wagers;
405         uint wins;
406         uint maxWins = pMaxWins / pWagerPrice;
407 
408         (wagers, wins) = betMatch(index, bet, nums);
409 
410         require(value / pWagerPrice == wagers, "wrong bet");
411 
412         if (wins > 0) {
413             if ( wins > maxWins) {
414                 wins = maxWins;
415             }
416 
417             sender.transfer(wins * pWagerPrice);
418         }
419 
420         emit LogBet(sender, index, bet, nums, wins);
421     }
422 }