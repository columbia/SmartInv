1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract TrumpBingo {
32 
33     /* GLOBAL CONSTANTS */
34     uint256 private minBid = 0.01 ether;
35     uint256 private feePercent = 5;  // only charged from profits
36     uint256 private jackpotPercent = 10;  // only charged from profits
37     uint256 private startingCoownerPrice = 10 ether;
38 
39     /* ADMIN AREA */
40 
41     bool public paused;
42 
43     address public ceoAddress;
44     address public feeAddress;
45     address public feedAddress;
46 
47     modifier notPaused() {
48         require(!paused);
49         _;
50     }
51 
52     modifier onlyFeed() {
53         require(msg.sender == feedAddress);
54         _;
55     }
56 
57     modifier onlyCEO() {
58         require(msg.sender == ceoAddress);
59         _;
60     }
61 
62     function setCEO(address _newCEO) public onlyCEO {
63         require(_newCEO != address(0));
64 
65         ceoAddress = _newCEO;
66     }
67 
68     function setFeedAddress(address _newFeed) public onlyCEO {
69         feedAddress = _newFeed;
70     }
71 
72     function setFeeAddress(address _newFee) public onlyCEO {
73         feeAddress = _newFee;
74     }
75 
76     function pauseContract() public onlyCEO {
77         paused = true;
78     }
79 
80     function unpauseContract() public onlyCEO {
81         paused = false;
82     }
83 
84     /* PROFITS */
85 
86     mapping (address => uint256) private profits;
87 
88     function getProfits(address who) public view returns (uint256) {
89         return profits[who];
90     }
91 
92     function withdraw(address who) public {
93         require(profits[who] > 0);
94         uint256 amount = profits[who];
95         profits[who] = 0;
96         who.transfer(amount);
97     }
98 
99     /* COOWNER MANAGEMENT */
100 
101     address public feeCoownerAddress;
102     uint256 public coownerPrice;
103 
104     function becomeCoowner() public payable {
105         if (msg.value < coownerPrice) {
106             revert();
107         }
108 
109         uint256 ourFee = coownerPrice / 10;
110         uint256 profit = coownerPrice - ourFee;
111         profits[feeCoownerAddress] += profit;
112         profits[feeAddress] += ourFee;
113         profits[msg.sender] += msg.value - coownerPrice;
114         coownerPrice = coownerPrice * 3 / 2;
115         feeCoownerAddress = msg.sender;
116     }
117 
118 
119     /* WORD MANAGEMENT */
120 
121     struct Word {
122         string word;
123         bool disabled;
124     }
125 
126 
127     event WordSetChanged();
128 
129     Word[] private words;
130     mapping (string => uint256) private idByWord;
131 
132     function getWordCount() public view returns (uint) {
133         return words.length;
134      }
135 
136     function getWord(uint index) public view returns (string word,
137                                                       bool disabled) {
138         require(index < words.length);
139         return (words[index].word, words[index].disabled);
140     }
141 
142     function getWordIndex(string word) public view returns (uint) {
143         return idByWord[word];
144      }
145 
146 
147     function addWord(string word) public onlyCEO {
148         uint index = idByWord[word];
149         require(index == 0);
150         index = words.push(Word({word: word, disabled: false})) - 1;
151         idByWord[word] = index;
152         bids.length = words.length;
153         WordSetChanged();
154     }
155 
156     function delWord(string word) public onlyCEO {
157         uint index = idByWord[word];
158         require(index > 0);
159         require(bids[index].bestBidder == address(0));
160         idByWord[word] = 0;
161         words[index].disabled = true;
162         WordSetChanged();
163     }
164 
165     /* WINNERS MANAGEMENT */
166     uint public prevTweetTime;
167     uint256 public prevRoundTweetId;
168     struct WinnerInfo {
169         address who;
170         uint256 howMuch;
171         uint256 wordId;
172     }
173 
174     WinnerInfo[] private prevRoundWinners;
175     uint private prevRoundWinnerCount;
176 
177     function getPrevRoundWinnerCount() public view returns (uint256 winnerCount)  {
178         winnerCount = prevRoundWinnerCount;
179     }
180 
181     function getPrevRoundWinner(uint i) public view returns (address who, uint256 howMuch, uint256 wordId) {
182         who = prevRoundWinners[i].who;
183         howMuch = prevRoundWinners[i].howMuch;
184         wordId = prevRoundWinners[i].wordId;
185     }
186 
187     function addWinner(address who, uint howMuch, uint wordId) private {
188         ++prevRoundWinnerCount;
189         if (prevRoundWinners.length < prevRoundWinnerCount) {
190             prevRoundWinners.length = prevRoundWinnerCount;
191         }
192         prevRoundWinners[prevRoundWinnerCount - 1].who = who;
193         prevRoundWinners[prevRoundWinnerCount - 1].howMuch = howMuch;
194         prevRoundWinners[prevRoundWinnerCount - 1].wordId = wordId;
195     }
196 
197     /* BIDS MANAGEMENT */
198     struct Bid {
199         uint256 cumValue;
200         uint256 validRoundNo;
201     }
202 
203     struct WordBids {
204         mapping (address => Bid) totalBids;
205         address bestBidder;
206     }
207 
208     uint256 private curRound;
209     WordBids[] private bids;
210 
211     uint256 private totalBank;
212     uint256 private totalJackpot;
213 
214     function getJackpot() public view returns (uint256) {
215         return totalJackpot;
216     }
217 
218     function getBank() public view returns (uint256) {
219         return totalBank;
220     }
221 
222     function getBestBidder(uint256 wordIndex) public view returns (address, uint256) {
223         return (bids[wordIndex].bestBidder, bids[wordIndex].totalBids[bids[wordIndex].bestBidder].cumValue);
224     }
225 
226     function getBestBid(uint256 wordIndex) public view returns (uint256) {
227         return bids[wordIndex].totalBids[bids[wordIndex].bestBidder].cumValue;
228     }
229 
230     function getMinAllowedBid(uint256 wordIndex) public view returns (uint256) {
231         return getBestBid(wordIndex) + minBid;
232     }
233 
234     function getTotalBid(address who, uint256 wordIndex) public view returns (uint256) {
235         if (bids[wordIndex].totalBids[who].validRoundNo != curRound) {
236             return 0;
237         }
238         return bids[wordIndex].totalBids[who].cumValue;
239     }
240 
241     function startNewRound() private {
242         totalBank = 0;
243         ++curRound;
244         for (uint i = 0; i < bids.length; ++i) {
245             bids[i].bestBidder = 0;
246         }
247     }
248 
249     event BestBidUpdate();
250 
251     function addBid(address who, uint wordIndex, uint256 value) private {
252         if (bids[wordIndex].totalBids[who].validRoundNo != curRound) {
253             bids[wordIndex].totalBids[who].cumValue = 0;
254             bids[wordIndex].totalBids[who].validRoundNo = curRound;
255         }
256 
257         uint256 newBid = value + bids[wordIndex].totalBids[who].cumValue;
258         uint256 minAllowedBid = getMinAllowedBid(wordIndex);
259         if (minAllowedBid > newBid) {
260             revert();
261         }
262 
263         bids[wordIndex].totalBids[who].cumValue = newBid;
264         bids[wordIndex].bestBidder = who;
265         totalBank += value;
266         BestBidUpdate();
267     }
268 
269     function calcPayouts(bool[] hasWon) private {
270         uint256 totalWon;
271         uint i;
272         for (i = 0; i < words.length; ++i) {
273             if (hasWon[i]) {
274                 totalWon += getBestBid(i);
275             }
276         }
277 
278         if (totalWon == 0) {
279             totalJackpot += totalBank;
280             return;
281         }
282         uint256 bank = totalJackpot / 2;
283         totalJackpot -= bank;
284         bank += totalBank;
285 
286         // charge only loosers
287         uint256 fee = uint256(SafeMath.div(SafeMath.mul(bank - totalWon, feePercent), 100));
288         bank -= fee;
289         profits[feeAddress] += fee / 2;
290         fee -= fee / 2;
291         profits[feeCoownerAddress] += fee;
292 
293         uint256 jackpotFill = uint256(SafeMath.div(SafeMath.mul(bank - totalWon, jackpotPercent), 100));
294         bank -= jackpotFill;
295         totalJackpot += jackpotFill;
296 
297         for (i = 0; i < words.length; ++i) {
298             if (hasWon[i] && bids[i].bestBidder != address(0)) {
299                 uint256 payout = uint256(SafeMath.div(SafeMath.mul(bank, getBestBid(i)), totalWon));
300                 profits[bids[i].bestBidder] += payout;
301                 addWinner(bids[i].bestBidder, payout, i);
302             }
303         }
304     }
305 
306     function getPotentialProfit(address who, string word) public view returns
307         (uint256 minNeededBid,
308          uint256 expectedProfit) {
309 
310         uint index = idByWord[word];
311         require(index > 0);
312 
313         uint currentBid = getTotalBid(who, index);
314         address bestBidder;
315         (bestBidder,) = getBestBidder(index);
316         if (bestBidder != who) {
317             minNeededBid = getMinAllowedBid(index) - currentBid;
318         }
319 
320         uint256 bank = totalJackpot / 2;
321         bank += totalBank;
322 
323         uint256 fee = uint256(SafeMath.div(SafeMath.mul(bank - currentBid, feePercent), 100));
324         bank -= fee;
325 
326         uint256 jackpotFill = uint256(SafeMath.div(SafeMath.mul(bank - currentBid, jackpotPercent), 100));
327         bank -= jackpotFill;
328 
329         expectedProfit = bank;
330     }
331 
332     function bid(string word) public payable notPaused {
333         uint index = idByWord[word];
334         require(index > 0);
335         addBid(msg.sender, index, msg.value);
336     }
337 
338     /* FEED TRUMP TWEET */
339 
340     function hasSubstring(string haystack, string needle) private pure returns (bool) {
341         uint needleSize = bytes(needle).length;
342         bytes32 hash = keccak256(needle);
343         for(uint i = 0; i < bytes(haystack).length - needleSize; i++) {
344             bytes32 testHash;
345             assembly {
346                 testHash := sha3(add(add(haystack, i), 32), needleSize)
347             }
348             if (hash == testHash)
349                 return true;
350         }
351         return false;
352     }
353 
354     event RoundFinished();
355     event NoBids();
356     event NoBingoWords();
357 
358     function feedTweet(uint tweetTime, uint256 tweetId, string tweet) public onlyFeed notPaused {
359         prevTweetTime = tweetTime;
360         if (totalBank == 0) {
361             NoBids();
362             return;
363         }
364 
365         bool[] memory hasWon = new bool[](words.length);
366         bool anyWordPresent = false;
367         for (uint i = 0; i < words.length; ++i) {
368             hasWon[i] = (!words[i].disabled) && hasSubstring(tweet, words[i].word);
369             if (hasWon[i]) {
370                 anyWordPresent = true;
371             }
372         }
373 
374         if (!anyWordPresent) {
375             NoBingoWords();
376             return;
377         }
378 
379         prevRoundTweetId = tweetId;
380         prevRoundWinnerCount = 0;
381         calcPayouts(hasWon);
382         RoundFinished();
383         startNewRound();
384     }
385 
386     /* CONSTRUCTOR */
387 
388     function TrumpBingo() public {
389         ceoAddress = msg.sender;
390         feeAddress = msg.sender;
391         feedAddress = msg.sender;
392         feeCoownerAddress = msg.sender;
393         coownerPrice = startingCoownerPrice;
394 
395         paused = false;
396         words.push(Word({word: "", disabled: true})); // fake '0' word
397         startNewRound();
398     }
399 
400 
401 }