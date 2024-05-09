1 pragma solidity ^0.4.9;
2 
3 contract SportsBet {
4     enum GameStatus { Open, Locked, Scored }
5     enum BookType { Spread, MoneyLine, OverUnder }
6     enum BetStatus { Open, Paid }
7 
8     // indexing on a string causes issues with web3, so category has to be an int
9     event GameCreated(bytes32 indexed id, string home, 
10         string away, uint16 indexed category, uint64 locktime);
11     event BidPlaced(bytes32 indexed game_id, BookType book, 
12         address bidder, uint amount, bool home, int32 line);
13     event BetPlaced(bytes32 indexed game_id, BookType indexed book, 
14         address indexed user, bool home, uint amount, int32 line);
15     event GameScored(bytes32 indexed game_id, int homeScore, int awayScore);
16     event Withdrawal(address indexed user, uint amount, uint timestamp);
17 
18     struct Bid {
19         address bidder;
20         uint amount; /* in wei */
21         bool home; /* true=home, false=away */
22         int32 line;
23     }
24 
25     struct Bet {
26         address home;
27         address away;
28         uint amount; /* in wei */
29         int32 line;
30         BetStatus status;
31     }
32 
33     struct Book {
34         Bid[] homeBids;
35         Bid[] awayBids;
36         Bet[] bets;
37     }
38 
39     struct GameResult {
40         int home;
41         int away;
42     }
43 
44     struct Game {
45         bytes32 id;
46         string home;
47         string away;
48         uint16 category;
49         uint64 locktime;
50         GameStatus status;
51         mapping(uint => Book) books;
52         GameResult result;
53     }
54 
55     address public owner;
56     Game[] games;
57     mapping(address => uint) public balances;
58 
59     function SportsBet() {
60         owner = msg.sender;
61     }
62 
63 	function createGame (string home, string away, uint16 category, uint64 locktime) returns (int) {
64         if (msg.sender != owner) return 1;
65         bytes32 id = getGameId(home, away, category, locktime);
66         mapping(uint => Book) books;
67         Bid[] memory homeBids;
68         Bid[] memory awayBids;
69         Bet[] memory bets;
70         GameResult memory result = GameResult(0,0);
71         Game memory game = Game(id, home, away, category, locktime, GameStatus.Open, result);
72         games.push(game);
73         GameCreated(id, home, away, category, locktime);
74         return -1;
75     }
76     
77     function cancelOpenBids(bytes32 game_id) private returns (int) {
78         Game game = getGameById(game_id);
79         Book book = game.books[uint(BookType.Spread)];
80 
81         for (uint i=0; i < book.homeBids.length; i++) {
82             Bid bid = book.homeBids[i];
83             if (bid.amount == 0)
84                 continue;
85             balances[bid.bidder] += bid.amount;
86             delete book.homeBids[i];
87         }
88         for (i=0; i < book.awayBids.length; i++) {
89             bid = book.awayBids[i];
90             if (bid.amount == 0)
91                 continue;
92             balances[bid.bidder] += bid.amount;
93             delete book.awayBids[i];
94         }
95 
96         return -1;
97     }
98 
99     function setGameResult (bytes32 game_id, int homeScore, int awayScore) returns (int) {
100         if (msg.sender != owner) return 1;
101 
102         Game game = getGameById(game_id);
103         if (game.locktime > now) return 2;
104         if (game.status == GameStatus.Scored) return 3;
105 
106         cancelOpenBids(game_id);
107 
108         game.result.home = homeScore;
109         game.result.away = awayScore;
110         game.status = GameStatus.Scored;
111         GameScored(game_id, homeScore, awayScore);
112 
113         // Currently only handles spread bets
114         Bet[] bets = game.books[uint(BookType.Spread)].bets;
115         int resultSpread = awayScore - homeScore;
116         resultSpread *= 10; // because bet.line is 10x the actual line
117         for (uint i = 0; i < bets.length; i++) {
118             Bet bet = bets[i];
119             if (resultSpread > bet.line) 
120                 balances[bet.away] += bet.amount * 2;
121             else if (resultSpread < bet.line)
122                 balances[bet.home] += bet.amount * 2;
123             else { // draw
124                 balances[bet.away] += bet.amount;
125                 balances[bet.home] += bet.amount;
126             }
127             bet.status = BetStatus.Paid;
128         }
129 
130         return -1;
131     }
132 
133     // This will eventually be expanded to include MoneyLine and OverUnder bets
134     // line is actually 10x the line to allow for half-point spreads
135     function bidSpread(bytes32 game_id, bool home, int32 line) payable returns (int) {
136         Game game = getGameById(game_id);
137         Book book = game.books[uint(BookType.Spread)];
138         Bid memory bid = Bid(msg.sender, msg.value, home, line);
139 
140         // validate inputs: game status, gametime, line amount
141         if (game.status == GameStatus.Locked)
142             return 1;
143         if (now > game.locktime) {
144             game.status = GameStatus.Locked;    
145             cancelOpenBids(game_id);
146             return 2;
147         }
148         if (line % 5 != 0)
149             return 3;
150 
151         Bid memory remainingBid = matchExistingBids(bid, book, home, game_id);
152 
153         // Use leftover funds to place open bids (maker)
154         if (bid.amount > 0) {
155             Bid[] bidStack = home ? book.homeBids : book.awayBids;
156             addBidToStack(remainingBid, bidStack);
157             BidPlaced(game_id, BookType.Spread, remainingBid.bidder, remainingBid.amount, home, line);
158         }
159 
160         return -1;
161     }
162 
163     // returning an array of structs is not allowed, so its time for a hackjob
164     // that returns a raw bytes dump of the combined home and away bids
165     // clients will have to parse the hex dump to get the bids out
166     // This function is for DEBUGGING PURPOSES ONLY. Using it in a production
167     // setting will return very large byte arrays that will consume your bandwidth
168     // if you are using Metamask or not running a full node  
169     function getOpenBids(bytes32 game_id) constant returns (bytes) {
170         Game game = getGameById(game_id);
171         Book book = game.books[uint(BookType.Spread)];
172         uint nBids = book.homeBids.length + book.awayBids.length;
173         bytes memory s = new bytes(57 * nBids);
174         uint k = 0;
175         for (uint i=0; i < nBids; i++) {
176             Bid bid;
177             if (i < book.homeBids.length)
178                 bid = book.homeBids[i];
179             else
180                 bid = book.awayBids[i - book.homeBids.length];
181             bytes20 bidder = bytes20(bid.bidder);
182             bytes32 amount = bytes32(bid.amount);
183             byte home = bid.home ? byte(1) : byte(0);
184             bytes4 line = bytes4(bid.line);
185 
186             for (uint j=0; j < 20; j++) { s[k] = bidder[j]; k++; }
187             for (j=0; j < 32; j++) { s[k] = amount[j]; k++; }
188             s[k] = home; k++;
189             for (j=0; j < 4; j++) { s[k] = line[j]; k++; }
190 
191         }
192 
193         return s;
194     }
195 
196     // Unfortunately this function had too many local variables, so a 
197     // bunch of unruly code had to be used to eliminate some variables
198     function getOpenBidsByLine(bytes32 game_id) constant returns (bytes) {
199         Book book = getBook(game_id, BookType.Spread);
200 
201         uint away_lines_length = getUniqueLineCount(book.awayBids);
202         uint home_lines_length = getUniqueLineCount(book.homeBids);
203 
204         // group bid amounts by line
205         mapping(int32 => uint)[2] line_amounts;
206         int32[] memory away_lines = new int32[](away_lines_length);
207         int32[] memory home_lines = new int32[](home_lines_length);
208 
209         uint k = 0;
210         for (uint i=0; i < book.homeBids.length; i++) {
211             Bid bid = book.homeBids[i]; 
212             if (bid.amount == 0) // ignore deleted bids
213                 continue;
214             if (line_amounts[0][bid.line] == 0) {
215                 home_lines[k] = bid.line;
216                 k++;
217             }
218             line_amounts[0][bid.line] += bid.amount;
219         }
220         k = 0;
221         for (i=0; i < book.awayBids.length; i++) {
222             bid = book.awayBids[i]; 
223             if (bid.amount == 0) // ignore deleted bids
224                 continue;
225             if (line_amounts[1][bid.line] == 0) {
226                 away_lines[k] = bid.line;
227                 k++;
228             }
229             line_amounts[1][bid.line] += bid.amount;
230         }
231 
232         bytes memory s = new bytes(37 * (home_lines_length + away_lines_length));
233         k = 0;
234         for (i=0; i < home_lines_length; i++) {
235             bytes4 line = bytes4(home_lines[i]);
236             bytes32 amount = bytes32(line_amounts[0][home_lines[i]]);
237             for (uint j=0; j < 32; j++) { s[k] = amount[j]; k++; }
238             s[k] = byte(1); k++;
239             for (j=0; j < 4; j++) { s[k] = line[j]; k++; }
240         }
241         for (i=0; i < away_lines_length; i++) {
242             line = bytes4(away_lines[i]);
243             amount = bytes32(line_amounts[1][away_lines[i]]);
244             for (j=0; j < 32; j++) { s[k] = amount[j]; k++; }
245             s[k] = byte(0); k++;
246             for (j=0; j < 4; j++) { s[k] = line[j]; k++; }
247         }
248         
249         return s;
250     }
251 
252     function getUniqueLineCount(Bid[] stack) private constant returns (uint) {
253         uint line_count = 0;
254         int lastIndex = -1;
255         for (uint i=0; i < stack.length; i++) {
256             if (stack[i].amount == 0) // ignore deleted bids
257                 continue;
258             if (lastIndex == -1)
259                 line_count++;
260             else if (stack[i].line != stack[uint(lastIndex)].line)
261                 line_count++;
262             lastIndex = int(i);
263         }
264         return line_count;
265     }
266 
267     function getOpenBidsByBidder(bytes32 game_id, address bidder) constant returns (bytes) {
268         Game game = getGameById(game_id);
269         Book book = game.books[uint(BookType.Spread)];
270         uint nBids = book.homeBids.length + book.awayBids.length;
271         uint myBids = 0;
272 
273         // count number of bids by bidder
274         for (uint i=0; i < nBids; i++) {
275             Bid bid = i < book.homeBids.length ? book.homeBids[i] : book.awayBids[i - book.homeBids.length];
276             if (bid.bidder == bidder)
277                 myBids += 1;
278         }
279 
280         bytes memory s = new bytes(37 * myBids);
281         uint k = 0;
282         for (i=0; i < nBids; i++) {
283             bid = i < book.homeBids.length ? book.homeBids[i] : book.awayBids[i - book.homeBids.length];
284             if (bid.bidder != bidder) // ignore other people's bids
285                 continue; 
286             bytes32 amount = bytes32(bid.amount);
287             byte home = bid.home ? byte(1) : byte(0);
288             bytes4 line = bytes4(bid.line);
289 
290             for (uint j=0; j < 32; j++) { s[k] = amount[j]; k++; }
291             s[k] = home; k++;
292             for (j=0; j < 4; j++) { s[k] = line[j]; k++; }
293         }
294         return s;
295     }
296         
297 
298     // for functions throwing a stack too deep error, this helper will free up 2 local variable spots
299     function getBook(bytes32 game_id, BookType book_type) constant private returns (Book storage) {
300         Game game = getGameById(game_id);
301         Book book = game.books[uint(book_type)];
302         return book;
303     }
304     
305     function matchExistingBids(Bid bid, Book storage book, bool home, bytes32 game_id) private returns (Bid) {
306         Bid[] matchStack = home ?  book.awayBids : book.homeBids;
307         int i = int(matchStack.length) - 1;
308         while (i >= 0 && bid.amount > 0) {
309             uint j = uint(i);
310             if (matchStack[j].amount == 0) { // deleted bids
311                 i--;
312                 continue;
313             }
314             if (-bid.line < matchStack[j].line)
315                 break;
316 
317             address homeAddress = home ? bid.bidder : matchStack[j].bidder;
318             address awayAddress = home ? matchStack[j].bidder : bid.bidder;
319             int32 betLine = home ? -matchStack[j].line : matchStack[j].line;
320             uint betAmount;
321             if (bid.amount < matchStack[j].amount) {
322                 betAmount = bid.amount;
323                 matchStack[j].amount -= betAmount;
324             }
325             else {
326                 betAmount = matchStack[j].amount;
327                 delete matchStack[j];
328             }
329             bid.amount -= betAmount;
330 
331             Bet memory bet = Bet(homeAddress, awayAddress, betAmount, betLine, BetStatus.Open);
332             book.bets.push(bet);
333             BetPlaced(game_id, BookType.Spread, homeAddress, true, betAmount, betLine);
334             BetPlaced(game_id, BookType.Spread, awayAddress, false, betAmount, -betLine);
335             i--;
336         }
337         return bid;
338     }
339 
340     function cancelBid(address bidder, bytes32 game_id, int32 line, bool home) returns (bool) {
341         Game game = getGameById(game_id);
342         Book book = game.books[uint(BookType.Spread)];
343         Bid[] stack = home ? book.homeBids : book.awayBids;
344 
345         // Delete bid in stack, refund amount to user
346         bool found = false;
347         for (uint i=0; i < stack.length; i++) {
348             if (stack[i].bidder == bidder && stack[i].line == line) {
349                 balances[bidder] += stack[i].amount;
350                 delete stack[i];
351                 found = true;
352             }
353         }
354         return found;
355     }
356 
357     function kill () {
358         if (msg.sender == owner) selfdestruct(owner);
359     }
360 
361     function getGameId (string home, string away, uint16 category, uint64 locktime) constant returns (bytes32) {
362         uint i = 0;
363         bytes memory a = bytes(home);
364         bytes memory b = bytes(away);
365         bytes2 c = bytes2(category);
366         bytes8 d = bytes8(locktime);
367 
368         uint length = a.length + b.length + c.length + d.length;
369         bytes memory toHash = new bytes(length);
370         uint k = 0;
371         for (i = 0; i < a.length; i++) { toHash[k] = a[i]; k++; }
372         for (i = 0; i < b.length; i++) { toHash[k] = b[i]; k++; }
373         for (i = 0; i < c.length; i++) { toHash[k] = c[i]; k++; }
374         for (i = 0; i < d.length; i++) { toHash[k] = d[i]; k++; }
375         return keccak256(toHash);
376         
377     }
378     
379     function getActiveGames () constant returns (bytes32[]) {
380         bytes32[] memory game_ids = new bytes32[](games.length);
381         for (uint i=0; i < games.length; i++) {
382             game_ids[i] = (games[i].id);
383         }
384         return game_ids;
385     }
386         
387     function addBidToStack(Bid bid, Bid[] storage stack) private returns (int) {
388         stack.push(bid); // make stack one item larger
389 
390         if (stack.length <= 1)
391             return 0;
392 
393         // insert into sorted stack
394         uint i = stack.length - 2;
395         uint lastIndex = stack.length - 1;
396         while (true) {
397             if (stack[i].amount == 0) { // ignore deleted bids
398                 if (i == 0)
399                     break;
400                 i--;
401                 continue;
402             }
403             if (stack[i].line > bid.line)
404                 break;
405             stack[lastIndex] = stack[i];
406             lastIndex = i;
407 
408             // uint exhibits undefined behavior when you take it negative
409             // so we have to break manually
410             if (i == 0) 
411                 break;
412             i--;
413         }
414         stack[lastIndex] = bid;
415         return -1;
416     }
417     
418     function getGameById(bytes32 game_id) private returns (Game storage) {
419         bool game_exists = false;
420         for (uint i = 0; i < games.length; i++) {
421             if (games[i].id == game_id) {
422                 Game game = games[i];
423                 game_exists = true;
424                 break;
425             }
426         }
427         if (!game_exists)
428             throw;
429         return game;
430     }
431 
432 
433     function withdraw() returns (int) {
434         var balance = balances[msg.sender];
435         balances[msg.sender] = 0;
436         if (!msg.sender.send(balance)) {
437             balances[msg.sender] = balance;
438             return 1;
439         }
440         Withdrawal(msg.sender, balance, now);
441         return -1;
442     }
443 
444 }