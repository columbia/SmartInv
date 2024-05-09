1 pragma solidity ^0.4.11;
2 
3 contract Banker {
4     uint256 maxBetWei;
5 
6     address public owner;
7     address public banker;
8 
9     struct Bet {
10         address player;
11         uint256 transferredAmount; // For refund.
12         bytes32 betData;
13         uint256 placedOnBlock;
14         uint256 lastRevealBlock;
15     }
16 
17     mapping (uint256 => uint8) odds;
18     mapping (uint256 => Bet) bets;
19 
20     event BetIsPlaced(
21         uint256 transferredAmount,
22         uint256 magicNumber,
23         bytes32 betData,
24         uint256 lastRevealBlock
25     );
26 
27     enum RevealFailStatus { InsufficientContractBalance }
28 
29     event BetCannotBeRevealed(uint256 magicNumber, RevealFailStatus reason);
30 
31     event BetIsRevealed(uint256 magicNumber, uint256 dice, uint256 winAmount);
32 
33     modifier ownerOnly() {
34         require(msg.sender == owner, "Only owner can call this function.");
35         _;
36     }
37 
38     constructor() public {
39         owner = msg.sender;
40 
41         maxBetWei = 1 ether / 10;
42 
43         // Initialize odds.
44         odds[1] = 35;
45         odds[2] = 17;
46         odds[3] = 11;
47         odds[4] = 8;
48         odds[5] = 6;
49         odds[6] = 5;
50         odds[12] = 2;
51         odds[18] = 1;
52     }
53 
54     function setMaxBetWei(uint256 numOfWei) public ownerOnly {
55         maxBetWei = numOfWei;
56     }
57 
58     function deposit() public payable {}
59 
60     function setBanker(address newBanker) public ownerOnly {
61         banker = newBanker;
62     }
63 
64     function withdrawToOwner(uint256 weiToWithdraw) public ownerOnly {
65         require(
66             address(this).balance >= weiToWithdraw,
67             "The value of this withdrawal is invalid."
68         );
69 
70         owner.transfer(weiToWithdraw);
71     }
72 
73     function convertAmountToWei(uint32 amount) private pure returns (uint256) {
74         return uint256(amount) * (1 finney * 10);
75     }
76 
77     function calcBetAmount(bytes32 betData) private pure returns (uint32) {
78         uint8 numOfBets = uint8(betData[0]);
79         require(numOfBets > 0 && numOfBets <= 15, "Invalid number value of bets.");
80 
81         uint8 p = 1;
82         uint32 betAmount = 0;
83 
84         for (uint8 i = 0; i < numOfBets; ++i) {
85             uint8 amount = uint8(betData[p++]);
86             require(
87                 amount == 100 || amount == 50 || amount == 20 || amount == 10 ||
88                     amount == 5 || amount == 2 || amount == 1,
89                 "Invalid bet amount."
90             );
91 
92             betAmount += amount;
93 
94             // Skip numbers.
95             uint8 numOfNumsOrIndex = uint8(betData[p++]);
96             if (numOfNumsOrIndex <= 4) {
97                 p += numOfNumsOrIndex;
98             } else {
99                 require(numOfNumsOrIndex >= 129 && numOfNumsOrIndex <= 152, "Invalid bet index.");
100             }
101 
102             // Note: When numOfNumsOrIndex > 4 (Actually it should be larger than 128),
103             //       there is no number follows. So we do not skip any byte in this case.
104         }
105 
106         return betAmount;
107     }
108 
109     function calcWinAmountOnNumber(bytes32 betData, uint8 number) private view returns (uint32) {
110         uint8 numOfBets = uint8(betData[0]);
111         require(numOfBets <= 15, "Too many bets.");
112 
113         // Reading index of betData.
114         uint8 p = 1;
115         uint32 winAmount = 0;
116 
117         // Loop every bet.
118         for (uint8 i = 0; i < numOfBets; ++i) {
119             require(p < 32, "Out of betData's range.");
120 
121             // Now read the bet amount (in ROU).
122             uint8 amount = uint8(betData[p++]);
123             require(
124                 amount == 100 || amount == 50 || amount == 20 || amount == 10 ||
125                     amount == 5 || amount == 2 || amount == 1,
126                 "Invalid bet amount."
127             );
128 
129             // The number of numbers to bet.
130             uint8 numOfNumsOrIndex = uint8(betData[p++]);
131 
132             // Read and check numbers.
133             if (numOfNumsOrIndex <= 4) {
134                 // We will read numbers from the following bytes.
135                 bool hit = false;
136                 for (uint8 j = 0; j < numOfNumsOrIndex; ++j) {
137                     require(p < 32, "Out of betData's range.");
138 
139                     uint8 thisNumber = uint8(betData[p++]);
140                     require(thisNumber >= 0 && thisNumber <= 37, "Invalid bet number.");
141 
142                     if (!hit && thisNumber == number) {
143                         hit = true;
144                         // Add win amount.
145                         winAmount += uint32(odds[numOfNumsOrIndex] + 1) * amount;
146                     }
147                 }
148             } else {
149                 // This is the index from table.
150                 require(numOfNumsOrIndex >= 129 && numOfNumsOrIndex <= 152, "Bad bet index.");
151 
152                 uint8 numOfNums = 0;
153 
154                 if (numOfNumsOrIndex == 129 && (number >= 1 && number <= 6)) {
155                     numOfNums = 6;
156                 }
157 
158                 if (numOfNumsOrIndex == 130 && (number >= 4 && number <= 9)) {
159                     numOfNums = 6;
160                 }
161 
162                 if (numOfNumsOrIndex == 131 && (number >= 7 && number <= 12)) {
163                     numOfNums = 6;
164                 }
165 
166                 if (numOfNumsOrIndex == 132 && (number >= 10 && number <= 15)) {
167                     numOfNums = 6;
168                 }
169 
170                 if (numOfNumsOrIndex == 133 && (number >= 13 && number <= 18)) {
171                     numOfNums = 6;
172                 }
173 
174                 if (numOfNumsOrIndex == 134 && (number >= 16 && number <= 21)) {
175                     numOfNums = 6;
176                 }
177 
178                 if (numOfNumsOrIndex == 135 && (number >= 19 && number <= 24)) {
179                     numOfNums = 6;
180                 }
181 
182                 if (numOfNumsOrIndex == 136 && (number >= 22 && number <= 27)) {
183                     numOfNums = 6;
184                 }
185 
186                 if (numOfNumsOrIndex == 137 && (number >= 25 && number <= 30)) {
187                     numOfNums = 6;
188                 }
189 
190                 if (numOfNumsOrIndex == 138 && (number >= 28 && number <= 33)) {
191                     numOfNums = 6;
192                 }
193 
194                 if (numOfNumsOrIndex == 139 && (number >= 31 && number <= 36)) {
195                     numOfNums = 6;
196                 }
197 
198                 if (numOfNumsOrIndex == 140 && ((number >= 0 && number <= 3) || number == 37)) {
199                     numOfNums = 5;
200                 }
201 
202                 uint8 n;
203 
204                 if (numOfNumsOrIndex == 141) {
205                     for (n = 1; n <= 34; n += 3) {
206                         if (n == number) {
207                             numOfNums = 12;
208                             break;
209                         }
210                     }
211                 }
212 
213                 if (numOfNumsOrIndex == 142) {
214                     for (n = 2; n <= 35; n += 3) {
215                         if (n == number) {
216                             numOfNums = 12;
217                             break;
218                         }
219                     }
220                 }
221 
222                 if (numOfNumsOrIndex == 143) {
223                     for (n = 3; n <= 36; n += 3) {
224                         if (n == number) {
225                             numOfNums = 12;
226                             break;
227                         }
228                     }
229                 }
230 
231                 if (numOfNumsOrIndex == 144 && (number >= 1 && number <= 12)) {
232                     numOfNums = 12;
233                 }
234 
235                 if (numOfNumsOrIndex == 145 && (number >= 13 && number <= 24)) {
236                     numOfNums = 12;
237                 }
238 
239                 if (numOfNumsOrIndex == 146 && (number >= 25 && number <= 36)) {
240                     numOfNums = 12;
241                 }
242 
243                 if (numOfNumsOrIndex == 147) {
244                     for (n = 1; n <= 35; n += 2) {
245                         if (n == number) {
246                             numOfNums = 18;
247                             break;
248                         }
249                     }
250                 }
251 
252                 if (numOfNumsOrIndex == 148) {
253                     for (n = 2; n <= 36; n += 2) {
254                         if (n == number) {
255                             numOfNums = 18;
256                             break;
257                         }
258                     }
259                 }
260 
261                 if (numOfNumsOrIndex == 149 &&
262                     (number == 1 || number == 3 || number == 5 || number == 7 || number == 9 || number == 12 ||
263                     number == 14 || number == 16 || number == 18 || number == 19 || number == 21 || number == 23 ||
264                     number == 25 || number == 27 || number == 30 || number == 32 || number == 34 || number == 36)) {
265                     numOfNums = 18;
266                 }
267 
268                 if (numOfNumsOrIndex == 150 &&
269                     (number == 2 || number == 4 || number == 6 || number == 8 || number == 10 || number == 11 ||
270                     number == 13 || number == 15 || number == 17 || number == 20 || number == 22 || number == 24 ||
271                     number == 26 || number == 28 || number == 29 || number == 31 || number == 33 || number == 35)) {
272                     numOfNums = 18;
273                 }
274 
275                 if (numOfNumsOrIndex == 151 && (number >= 1 && number <= 18)) {
276                     numOfNums = 18;
277                 }
278 
279                 if (numOfNumsOrIndex == 152 && (number >= 19 && number <= 36)) {
280                     numOfNums = 18;
281                 }
282 
283                 // Increase winAmount.
284                 if (numOfNums > 0) {
285                     winAmount += uint32(odds[numOfNums] + 1) * amount;
286                 }
287             }
288 
289         }
290 
291         return winAmount;
292     }
293 
294     function calcMaxWinAmount(bytes32 betData) private view returns (uint32) {
295         uint32 maxWinAmount = 0;
296         for (uint8 guessWinNumber = 0; guessWinNumber <= 37; ++guessWinNumber) {
297             uint32 amount = calcWinAmountOnNumber(betData, guessWinNumber);
298             if (amount > maxWinAmount) {
299                 maxWinAmount = amount;
300             }
301         }
302         return maxWinAmount;
303     }
304 
305     function clearBet(uint256 magicNumber) private {
306         Bet storage bet = bets[magicNumber];
307 
308         // Clear the slot.
309         bet.player = address(0);
310         bet.transferredAmount = 0;
311         bet.betData = bytes32(0);
312         bet.placedOnBlock = 0;
313         bet.lastRevealBlock = 0;
314     }
315 
316     function placeBet(
317         uint256 magicNumber,
318         uint256 expiredAfterBlock,
319         bytes32 betData,
320         bytes32 r,
321         bytes32 s
322     )
323         public
324         payable
325     {
326         require(
327             block.number <= expiredAfterBlock,
328             "Timeout of current bet to place."
329         );
330 
331         // Check the slot and make sure there is no playing bet.
332         Bet storage bet = bets[magicNumber];
333         require(bet.player == address(0), "The slot is not empty.");
334 
335         // Throw if there are not enough wei are provided by customer.
336         uint32 betAmount = calcBetAmount(betData);
337         uint256 betWei = convertAmountToWei(betAmount);
338 
339         require(msg.value >= betWei, "There are not enough wei are provided by customer.");
340         require(betWei <= maxBetWei, "Exceed the maximum.");
341 
342         // Check the signature.
343         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
344         bytes32 hash = keccak256(
345             abi.encodePacked(magicNumber, expiredAfterBlock)
346         );
347         address signer = ecrecover(
348             keccak256(abi.encodePacked(prefix, hash)),
349             28, r, s
350         );
351         require(
352             signer == banker,
353             "The signature is not signed by the banker."
354         );
355 
356         // Prepare and save bet record.
357         bet.player = msg.sender;
358         bet.transferredAmount = msg.value;
359         bet.betData = betData;
360         bet.placedOnBlock = block.number;
361         bet.lastRevealBlock = expiredAfterBlock;
362         bets[magicNumber] = bet;
363 
364         emit BetIsPlaced(bet.transferredAmount, magicNumber, betData, expiredAfterBlock);
365     }
366 
367     function revealBet(uint256 randomNumber) public {
368         // Get the magic-number and find the slot of the bet.
369         uint256 magicNumber = uint256(
370             keccak256(abi.encodePacked(randomNumber))
371         );
372         Bet storage bet = bets[magicNumber];
373 
374         // Save to local variables.
375         address betPlayer = bet.player;
376         bytes32 betbetData = bet.betData;
377         uint256 betPlacedOnBlock = bet.placedOnBlock;
378         uint256 betLastRevealBlock = bet.lastRevealBlock;
379 
380         require(
381             betPlayer != address(0),
382             "The bet slot cannot be empty."
383         );
384 
385         require(
386             betPlacedOnBlock < block.number,
387             "Cannot reveal the bet on the same block where it was placed."
388         );
389 
390         require(
391             block.number <= betLastRevealBlock,
392             "The bet is out of the block range (Timeout!)."
393         );
394 
395         // Calculate the result.
396         bytes32 n = keccak256(
397             abi.encodePacked(randomNumber, blockhash(betPlacedOnBlock))
398         );
399         uint8 spinNumber = uint8(uint256(n) % 38);
400 
401         // Calculate win amount.
402         uint32 winAmount = calcWinAmountOnNumber(betbetData, spinNumber);
403         uint256 winWei = 0;
404         if (winAmount > 0) {
405             winWei = convertAmountToWei(winAmount);
406             if (address(this).balance < winWei) {
407                 emit BetCannotBeRevealed(magicNumber, RevealFailStatus.InsufficientContractBalance);
408                 return;
409             }
410             betPlayer.transfer(winWei);
411         }
412 
413         emit BetIsRevealed(magicNumber, spinNumber, winAmount);
414         clearBet(magicNumber);
415     }
416 
417     function refundBet(uint256 magicNumber) public {
418         Bet storage bet = bets[magicNumber];
419 
420         address player = bet.player;
421         uint256 transferredAmount = bet.transferredAmount;
422         uint256 lastRevealBlock = bet.lastRevealBlock;
423 
424         require(player != address(0), "The bet slot is empty.");
425 
426         require(block.number > lastRevealBlock, "The bet is still in play.");
427 
428         player.transfer(transferredAmount);
429 
430         // Clear the slot.
431         clearBet(magicNumber);
432     }
433 }