1 pragma solidity ^0.4.9;
2 
3 contract PeerBet {
4     enum GameStatus { Open, Locked, Scored, Verified }
5     // BookType.None exists because parsing a log index for a value of 0 
6     // returns all values. It should not be used.
7     enum BookType { None, Spread, MoneyLine, OverUnder }
8     enum BetStatus { Open, Paid }
9 
10     // indexing on a string causes issues with web3, so category has to be an int
11     event GameCreated(bytes32 indexed id, address indexed creator, string home, 
12         string away, uint16 indexed category, uint64 locktime);
13     event BidPlaced(bytes32 indexed game_id, BookType book, 
14         address bidder, uint amount, bool home, int32 line);
15     event BetPlaced(bytes32 indexed game_id, BookType indexed book, 
16         address indexed user, bool home, uint amount, int32 line);
17     event GameScored(bytes32 indexed game_id, int homeScore, int awayScore, uint timestamp);
18     event GameVerified(bytes32 indexed game_id);
19     event Withdrawal(address indexed user, uint amount, uint timestamp);
20 
21     struct Bid {
22         address bidder;
23         uint amount; /* in wei */
24         bool home; /* true=home, false=away */
25         int32 line;
26     }
27 
28     struct Bet {
29         address home;
30         address away;
31         uint amount; /* in wei */
32         int32 line;
33         BetStatus status;
34     }
35 
36     struct Book {
37         Bid[] homeBids;
38         Bid[] awayBids;
39         Bet[] bets;
40     }
41 
42     struct GameResult {
43         int home;
44         int away;
45         uint timestamp; // when the game was scored
46     }
47 
48     struct Game {
49         bytes32 id;
50         address creator;
51         string home;
52         string away;
53         uint16 category;
54         uint64 locktime;
55         GameStatus status;
56         mapping(uint => Book) books;
57         GameResult result;
58     }
59 
60     address public owner;
61     Game[] games;
62     mapping(address => uint) public balances;
63 
64     function PeerBet() {
65         owner = msg.sender;
66     }
67 
68 	function createGame (string home, string away, uint16 category, uint64 locktime) returns (int) {
69         bytes32 id = getGameId(msg.sender, home, away, category, locktime);
70         Game memory game = Game(id, msg.sender, home, away, category, locktime, GameStatus.Open, GameResult(0,0,0));
71         games.push(game);
72         GameCreated(id, game.creator, home, away, category, locktime);
73         return -1;
74     }
75     
76     function cancelOpenBids(Book storage book) private returns (int) {
77         for (uint i=0; i < book.homeBids.length; i++) {
78             Bid bid = book.homeBids[i];
79             if (bid.amount == 0)
80                 continue;
81             balances[bid.bidder] += bid.amount;
82         }
83         delete book.homeBids;
84         for (i=0; i < book.awayBids.length; i++) {
85             bid = book.awayBids[i];
86             if (bid.amount == 0)
87                 continue;
88             balances[bid.bidder] += bid.amount;
89         }
90         delete book.awayBids;
91 
92         return -1;
93     }
94 
95     function cancelBets(Book storage book, BookType book_type) private returns (int) {
96         for (uint i=0; i < book.bets.length; i++) {
97             Bet bet = book.bets[i];
98             if (bet.status == BetStatus.Paid)
99                 continue;
100             uint awayBetAmount;
101             if (book_type == BookType.MoneyLine) {
102                 if (bet.line < 0)
103                     awayBetAmount = bet.amount * 100 / uint(bet.line);
104                 else
105                     awayBetAmount = bet.amount * uint(bet.line) / 100;
106             }
107             else
108                 awayBetAmount = bet.amount;
109             balances[bet.home] += bet.amount;
110             balances[bet.away] += awayBetAmount;
111         }
112         delete book.bets;
113 
114         return -1;
115     }
116 
117     function deleteGame(bytes32 game_id) returns (int) {
118         Game game = getGameById(game_id);
119         if (msg.sender != game.creator && (game.locktime + 86400*4) > now) return 1;
120 
121         for (uint i=1; i < 4; i++) {
122             Book book = game.books[i];
123             cancelOpenBids(book);
124             cancelBets(book, BookType(i));
125         }
126         for (i=0; i < games.length; i++) {
127             if (games[i].id == game_id) {
128                 games[i] = games[games.length - 1];
129                 games.length -= 1;
130                 break;
131             }
132         }
133         return -1;
134     }
135 
136     function payBets(bytes32 game_id) private returns (int) {
137         Game game = getGameById(game_id);
138 
139         Bet[] spreadBets = game.books[uint(BookType.Spread)].bets;
140         Bet[] moneyLineBets = game.books[uint(BookType.MoneyLine)].bets;
141         Bet[] overUnderBets = game.books[uint(BookType.OverUnder)].bets;
142 
143         // Spread
144         int resultSpread = game.result.away - game.result.home;
145         resultSpread *= 10; // because bet.line is 10x the actual line
146         for (uint i = 0; i < spreadBets.length; i++) {
147             Bet bet = spreadBets[i];
148             if (bet.status == BetStatus.Paid)
149                 continue;
150             if (resultSpread > bet.line) 
151                 balances[bet.away] += bet.amount * 2;
152             else if (resultSpread < bet.line)
153                 balances[bet.home] += bet.amount * 2;
154             else { // draw
155                 balances[bet.away] += bet.amount;
156                 balances[bet.home] += bet.amount;
157             }
158             bet.status = BetStatus.Paid;
159         }
160 
161         // MoneyLine
162         bool tie = game.result.home == game.result.away;
163         bool homeWin = game.result.home > game.result.away;
164         for (i=0; i < moneyLineBets.length; i++) {
165             bet = moneyLineBets[i];
166             if (bet.status == BetStatus.Paid)
167                 continue;
168             uint awayAmount;
169             if (bet.line < 0)
170                 awayAmount = bet.amount * 100 / uint(-bet.line);
171             else
172                 awayAmount = bet.amount * uint(bet.line) / 100;
173             if (tie) {
174                 balances[bet.home] += bet.amount;
175                 balances[bet.away] += awayAmount;
176             }
177             else if (homeWin)
178                 balances[bet.home] += (bet.amount + awayAmount);
179             else
180                 balances[bet.away] += (bet.amount + awayAmount);
181             bet.status = BetStatus.Paid;
182         }
183 
184         // OverUnder - bet.line is 10x the actual line to allow half-point spreads
185         int totalPoints = (game.result.home + game.result.away) * 10;
186         for (i=0; i < overUnderBets.length; i++) {
187             bet = overUnderBets[i];
188             if (bet.status == BetStatus.Paid)
189                 continue;
190             if (totalPoints > bet.line)
191                 balances[bet.home] += bet.amount * 2;
192             else if (totalPoints < bet.line)
193                 balances[bet.away] += bet.amount * 2;
194             else {
195                 balances[bet.away] += bet.amount;
196                 balances[bet.home] += bet.amount;
197             }
198             bet.status = BetStatus.Paid;
199         }
200 
201         return -1;
202     }
203 
204     function verifyGameResult(bytes32 game_id) returns (int) {
205         Game game = getGameById(game_id);
206         if (msg.sender != game.creator) return 1;
207         if (game.status != GameStatus.Scored) return 2;
208         if (now < game.result.timestamp + 12*3600) return 3; // must wait 12 hours to verify 
209 
210         payBets(game_id);
211         game.status = GameStatus.Verified;
212         GameVerified(game_id);
213 
214         return -1;
215     }
216 
217     function setGameResult(bytes32 game_id, int homeScore, int awayScore) returns (int) {
218         Game game = getGameById(game_id);
219         if (msg.sender != game.creator) return 1;
220         if (game.locktime > now) return 2;
221         if (game.status == GameStatus.Verified) return 3;
222 
223         for (uint i = 1; i < 4; i++)
224             cancelOpenBids(game.books[i]);
225 
226         game.result.home = homeScore;
227         game.result.away = awayScore;
228         game.result.timestamp = now;
229         game.status = GameStatus.Scored;
230         GameScored(game_id, homeScore, awayScore, now);
231 
232         return -1;
233     }
234 
235     // line is actually 10x the line to allow for half-point spreads
236     function bid(bytes32 game_id, BookType book_type, bool home, int32 line) payable returns (int) {
237         if (book_type == BookType.None)
238             return 5;
239 
240         Game game = getGameById(game_id);
241         Book book = game.books[uint(book_type)];
242         Bid memory bid = Bid(msg.sender, msg.value, home, line);
243 
244         // validate inputs: game status, gametime, line amount
245         if (game.status != GameStatus.Open)
246             return 1;
247         if (now > game.locktime) {
248             game.status = GameStatus.Locked;    
249             for (uint i = 1; i < 4; i++)
250                 cancelOpenBids(game.books[i]);
251             return 2;
252         }
253         if ((book_type == BookType.Spread || book_type == BookType.OverUnder)
254             && line % 5 != 0)
255             return 3;
256         else if (book_type == BookType.MoneyLine && line < 100 && line >= -100)
257             return 4;
258 
259         Bid memory remainingBid = matchExistingBids(bid, game_id, book_type);
260 
261         // Use leftover funds to place open bids (maker)
262         if (bid.amount > 0) {
263             Bid[] bidStack = home ? book.homeBids : book.awayBids;
264             if (book_type == BookType.OverUnder && home)
265                 addBidToStack(remainingBid, bidStack, true);
266             else
267                 addBidToStack(remainingBid, bidStack, false);
268             BidPlaced(game_id, book_type, remainingBid.bidder, remainingBid.amount, home, line);
269         }
270 
271         return -1;
272     }
273 
274     // returning an array of structs is not allowed, so its time for a hackjob
275     // that returns a raw bytes dump of the combined home and away bids
276     // clients will have to parse the hex dump to get the bids out
277     // This function is for DEBUGGING PURPOSES ONLY. Using it in a production
278     // setting will return very large byte arrays that will consume your bandwidth
279     // if you are not running a full node  
280     function getOpenBids(bytes32 game_id, BookType book_type) constant returns (bytes) {
281         Game game = getGameById(game_id);
282         Book book = game.books[uint(book_type)];
283         uint nBids = book.homeBids.length + book.awayBids.length;
284         bytes memory s = new bytes(57 * nBids);
285         uint k = 0;
286         for (uint i=0; i < nBids; i++) {
287             if (i < book.homeBids.length)
288                 Bid bid = book.homeBids[i];
289             else
290                 bid = book.awayBids[i - book.homeBids.length];
291             bytes20 bidder = bytes20(bid.bidder);
292             bytes32 amount = bytes32(bid.amount);
293             byte home = bid.home ? byte(1) : byte(0);
294             bytes4 line = bytes4(bid.line);
295 
296             for (uint j=0; j < 20; j++) { s[k] = bidder[j]; k++; }
297             for (j=0; j < 32; j++) { s[k] = amount[j]; k++; }
298             s[k] = home; k++;
299             for (j=0; j < 4; j++) { s[k] = line[j]; k++; }
300 
301         }
302 
303         return s;
304     }
305 
306     // for functions throwing a stack too deep error, this helper will free up 2 local variable spots
307     function getBook(bytes32 game_id, BookType book_type) constant private returns (Book storage) {
308         Game game = getGameById(game_id);
309         Book book = game.books[uint(book_type)];
310         return book;
311     }
312 
313     
314     // for over/under bids, the home boolean is equivalent to the over
315     function matchExistingBids(Bid bid, bytes32 game_id, BookType book_type) private returns (Bid) {
316         Book book = getBook(game_id, book_type);
317         bool home = bid.home;
318         Bid[] matchStack = home ?  book.awayBids : book.homeBids;
319         int i = int(matchStack.length) - 1;
320         while (i >= 0 && bid.amount > 0) {
321             uint j = uint(i);
322             if (matchStack[j].amount == 0) { // deleted bids
323                 i--;
324                 continue;
325             }
326             if (book_type == BookType.OverUnder) {
327                 if (home && bid.line < matchStack[j].line 
328                 || !home && bid.line > matchStack[j].line)
329                 break;
330             }
331             else if (-bid.line < matchStack[j].line)
332                 break;
333 
334             // determined required bet amount to match stack bid
335             uint requiredBet;
336             if (book_type == BookType.Spread || book_type == BookType.OverUnder)
337                 requiredBet = matchStack[j].amount;
338             else if (matchStack[j].line > 0) { // implied MoneyLine
339                 requiredBet = matchStack[j].amount * uint(matchStack[j].line) / 100;
340             }
341             else { // implied MoneyLine and negative line
342                 requiredBet = matchStack[j].amount * 100 / uint(-matchStack[j].line);
343             }
344 
345             // determine bet amounts on both sides
346             uint betAmount;
347             uint opposingBetAmount;
348             if (bid.amount < requiredBet) {
349                 betAmount = bid.amount;
350                 if (book_type == BookType.Spread || book_type == BookType.OverUnder)
351                     opposingBetAmount = bid.amount;
352                 else if (matchStack[j].line > 0)
353                     opposingBetAmount = betAmount * 100 / uint(matchStack[j].line);
354                 else
355                     opposingBetAmount = bid.amount * uint(-matchStack[j].line) / 100;
356             }
357             else {
358                 betAmount = requiredBet;
359                 opposingBetAmount = matchStack[j].amount;
360             }
361             bid.amount -= betAmount;
362             matchStack[j].amount -= opposingBetAmount;
363 
364             int32 myLine;
365             if (book_type == BookType.OverUnder)
366                 myLine = matchStack[j].line;
367             else
368                 myLine = -matchStack[j].line;
369             Bet memory bet = Bet(
370                 home ? bid.bidder : matchStack[j].bidder,
371                 home ? matchStack[j].bidder : bid.bidder,
372                 home ? betAmount : opposingBetAmount,
373                 home ? myLine : matchStack[j].line,
374                 BetStatus.Open
375             );
376             book.bets.push(bet);
377             BetPlaced(game_id, book_type, bid.bidder, home, betAmount, myLine);
378             BetPlaced(game_id, book_type, matchStack[j].bidder, 
379                 !home, opposingBetAmount, matchStack[j].line);
380             i--;
381         }
382         return bid;
383     }
384 
385     function cancelBid(bytes32 game_id, BookType book_type, int32 line, bool home) returns (int) {
386         Book book = getBook(game_id, book_type);
387         Bid[] stack = home ? book.homeBids : book.awayBids;
388         address bidder = msg.sender;
389 
390         // Delete bid in stack, refund amount to user
391         for (uint i=0; i < stack.length; i++) {
392             if (stack[i].amount > 0 && stack[i].bidder == bidder && stack[i].line == line) {
393                 balances[bidder] += stack[i].amount;
394                 delete stack[i];
395                 return -1;
396             }
397         }
398         return 1;
399     }
400 
401     function kill () {
402         if (msg.sender == owner) selfdestruct(owner);
403     }
404 
405     function getGameId (address creator, string home, string away, uint16 category, uint64 locktime) constant returns (bytes32) {
406         uint i = 0;
407         bytes memory a = bytes(home);
408         bytes memory b = bytes(away);
409         bytes2 c = bytes2(category);
410         bytes8 d = bytes8(locktime);
411         bytes20 e = bytes20(creator);
412 
413         uint length = a.length + b.length + c.length + d.length + e.length;
414         bytes memory toHash = new bytes(length);
415         uint k = 0;
416         for (i = 0; i < a.length; i++) { toHash[k] = a[i]; k++; }
417         for (i = 0; i < b.length; i++) { toHash[k] = b[i]; k++; }
418         for (i = 0; i < c.length; i++) { toHash[k] = c[i]; k++; }
419         for (i = 0; i < d.length; i++) { toHash[k] = d[i]; k++; }
420         for (i = 0; i < e.length; i++) { toHash[k] = e[i]; k++; }
421         return sha3(toHash);
422     }
423     
424     function getActiveGames () constant returns (bytes32[]) {
425         bytes32[] memory game_ids = new bytes32[](games.length);
426         for (uint i=0; i < games.length; i++) {
427             game_ids[i] = (games[i].id);
428         }
429         return game_ids;
430     }
431         
432     function addBidToStack(Bid bid, Bid[] storage stack, bool reverse) private returns (int) {
433         if (stack.length == 0) {
434             stack.push(bid);
435             return -1;
436         }
437         
438         // determine position of new bid in stack
439         uint insertIndex = stack.length;
440         if (reverse) {
441             while (insertIndex > 0 && bid.line <= stack[insertIndex-1].line)
442                 insertIndex--;
443         }
444         else {
445             while (insertIndex > 0 && bid.line >= stack[insertIndex-1].line)
446                 insertIndex--;
447         }
448         
449         // try to find deleted slot to fill
450         if (insertIndex > 0 && stack[insertIndex - 1].amount == 0) {
451             stack[insertIndex - 1] = bid;
452             return -1;
453         }
454         uint shiftEndIndex = insertIndex;
455         while (shiftEndIndex < stack.length && stack[shiftEndIndex].amount > 0) {
456             shiftEndIndex++;
457         }
458         
459         // shift bids down (up to deleted index if one exists)
460         if (shiftEndIndex == stack.length)
461             stack.length += 1;
462         for (uint i = shiftEndIndex; i > insertIndex; i--) {
463             stack[i] = stack[i-1];
464         } 
465 
466         stack[insertIndex] = bid;
467         
468 
469         return -1;
470     }
471 
472     function getGameById(bytes32 game_id) constant private returns (Game storage) {
473         bool game_exists = false;
474         for (uint i = 0; i < games.length; i++) {
475             if (games[i].id == game_id) {
476                 Game game = games[i];
477                 game_exists = true;
478                 break;
479             }
480         }
481         if (!game_exists)
482             throw;
483         return game;
484     }
485 
486 
487     function withdraw() returns (int) {
488         var balance = balances[msg.sender];
489         balances[msg.sender] = 0;
490         if (!msg.sender.send(balance)) {
491             balances[msg.sender] = balance;
492             return 1;
493         }
494         Withdrawal(msg.sender, balance, now);
495         return -1;
496     }
497 
498 }