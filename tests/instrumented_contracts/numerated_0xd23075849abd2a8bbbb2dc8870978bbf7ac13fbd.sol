1 pragma solidity ^0.4.16;
2 
3 interface Game {
4     event GameStarted(uint betAmount);
5     event NewPlayerAdded(uint numPlayers, uint prizeAmount);
6     event GameFinished(address winner);
7     
8     function () public payable;                                   //Participate in game. Proxy for play method
9     function play() public payable;                               //Participate in game.
10     function getPrizeAmount() public constant returns (uint);     //Get potential or actual prize amount
11     function getNumWinners() public constant returns(uint, uint);
12     function getPlayers() public constant returns(address[]);           //Get full list of players
13     function getWinners() public view returns(address[] memory players,
14                                                 uint[] memory prizes);  //Get winners. Accessable only when finished
15     function getStat() public constant returns(uint, uint, uint);       //Short stat on game
16     
17     function calcaultePrizes() public returns (uint[]);
18     
19     function finish() public;                        //Closes game chooses winner
20     
21     function revoke() public;                        //Stop game and return money to players
22     // function move(address nextGame);              //Move players bets to another game
23 }
24 
25 library TicketLib {
26     struct Ticket {
27         bool is_winner;
28         bool is_active;
29         uint block_number;
30         uint block_time;
31         uint num_votes;
32         uint prize;
33     }
34 }
35 
36 contract UnilotPrizeCalculator {
37     //Calculation constants
38     uint  constant accuracy                   = 1000000000000000000;
39     uint  constant MAX_X_FOR_Y                = 195;  // 19.5
40     
41     uint  constant minPrizeCoeficent          = 1;
42     uint  constant percentOfWinners           = 5;    // 5%
43     uint  constant percentOfFixedPrizeWinners = 20;   // 20%
44     uint  constant gameCommision              = 20;   // 20%
45     uint  constant bonusGameCommision         = 5;    // 5%
46     uint  constant tokenHolerGameCommision    = 5;    // 5%
47     // End Calculation constants
48     
49     event Debug(uint);
50     
51     function getPrizeAmount(uint totalAmount)
52         public
53         pure
54         returns (uint result)
55     {
56         uint totalCommision = gameCommision
57                             + bonusGameCommision
58                             + tokenHolerGameCommision;
59         
60         //Calculation is odd on purpose.  It is a sort of ceiling effect to
61         // maximize amount of prize
62         result = ( totalAmount - ( ( totalAmount * totalCommision) / 100) );
63         
64         return result;
65     }
66     
67     function getNumWinners(uint numPlayers)
68         public
69         pure
70         returns (uint numWinners, uint numFixedAmountWinners)
71     {
72         // Calculation is odd on purpose. It is a sort of ceiling effect to
73         // maximize number of winners
74         uint totaNumlWinners = ( numPlayers - ( (numPlayers * ( 100 - percentOfWinners ) ) / 100 ) );
75         
76         
77         numFixedAmountWinners = (totaNumlWinners * percentOfFixedPrizeWinners) / 100;
78         numWinners = totaNumlWinners - numFixedAmountWinners;
79         
80         return (numWinners, numFixedAmountWinners);
81     }
82     
83     function calcaultePrizes(uint bet, uint numPlayers)
84         public
85         pure
86         returns (uint[50] memory prizes)
87     {
88         var (numWinners, numFixedAmountWinners) = getNumWinners(numPlayers);
89         
90         require( uint(numWinners + numFixedAmountWinners) <= prizes.length );
91         
92         uint[] memory y = new uint[]((numWinners - 1));
93         uint z = 0; // Sum of all Y values
94         
95         if ( numWinners == 1 ) {
96             prizes[0] = getPrizeAmount(uint(bet*numPlayers));
97             
98             return prizes;
99         } else if ( numWinners < 1 ) {
100             return prizes;
101         }
102         
103         for (uint i = 0; i < y.length; i++) {
104             y[i] = formula( (calculateStep(numWinners) * i) );
105             z += y[i];
106         }
107         
108         bool stop = false;
109         
110         for (i = 0; i < 10; i++) {
111             uint[5] memory chunk = distributePrizeCalculation(
112                 i, z, y, numPlayers, bet);
113             
114             for ( uint j = 0; j < chunk.length; j++ ) {
115                 if ( ( (i * chunk.length) + j ) >= ( numWinners + numFixedAmountWinners ) ) {
116                     stop = true;
117                     break;
118                 }
119                 
120                 prizes[ (i * chunk.length) + j ] = chunk[j];
121             }
122             
123             if ( stop ) {
124                 break;
125             }
126         }
127         
128         return prizes;
129     }
130     
131     function distributePrizeCalculation (uint chunkNumber, uint z, uint[] memory y, uint totalNumPlayers, uint bet)
132         private
133         pure
134         returns (uint[5] memory prizes)
135     {
136         var(numWinners, numFixedAmountWinners) = getNumWinners(totalNumPlayers);
137         uint prizeAmountForDeligation = getPrizeAmount( (totalNumPlayers * bet) );
138         prizeAmountForDeligation -= uint( ( bet * minPrizeCoeficent ) * uint( numWinners + numFixedAmountWinners ) );
139         
140         uint mainWinnerBaseAmount = ( (prizeAmountForDeligation * accuracy) / ( ( ( z * accuracy ) / ( 2 * y[0] ) ) + ( 1 * accuracy ) ) );
141         uint undeligatedAmount    = prizeAmountForDeligation;
142         
143         uint startPoint = chunkNumber * prizes.length;
144         
145         for ( uint i = 0; i < prizes.length; i++ ) {
146             if ( i >= uint(numWinners + numFixedAmountWinners) ) {
147                 break;
148             }
149             prizes[ i ] = (bet * minPrizeCoeficent);
150             uint extraPrize = 0;
151             
152             if ( i == ( numWinners - 1 ) ) {
153                 extraPrize = undeligatedAmount;
154             } else if ( i == 0 && chunkNumber == 0 ) {
155                 extraPrize = mainWinnerBaseAmount;
156             } else if ( ( startPoint + i ) < numWinners ) {
157                 extraPrize = ( ( y[ ( startPoint + i ) - 1 ] * (prizeAmountForDeligation - mainWinnerBaseAmount) ) / z);
158             }
159             
160             prizes[ i ] += extraPrize;
161             undeligatedAmount -= extraPrize;
162         }
163         
164         return prizes;
165     }
166     
167     function formula(uint x)
168         public
169         pure
170         returns (uint y)
171     {
172         y = ( (1 * accuracy**2) / (x + (5*accuracy/10))) - ((5 * accuracy) / 100);
173         
174         return y;
175     }
176     
177     function calculateStep(uint numWinners)
178         public
179         pure
180         returns(uint step)
181     {
182         step = ( MAX_X_FOR_Y * accuracy / 10 ) / numWinners;
183         
184         return step;
185     }
186 }
187 
188 contract BaseUnilotGame is Game {
189     enum State {
190         ACTIVE,
191         ENDED,
192         REVOKING,
193         REVOKED,
194         MOVED
195     }
196     
197     event PrizeResultCalculated(uint size, uint[] prizes);
198     
199     State state;
200     address administrator;
201     uint bet;
202     
203     mapping (address => TicketLib.Ticket) internal tickets;
204     address[] internal ticketIndex;
205     
206     UnilotPrizeCalculator calculator;
207     
208     //Modifiers
209     modifier onlyAdministrator() {
210         require(msg.sender == administrator);
211         _;
212     }
213     
214     modifier onlyPlayer() {
215         require(msg.sender != administrator);
216         _;
217     }
218     
219     modifier validBet() {
220         require(msg.value == bet);
221         _;
222     }
223     
224     modifier activeGame() {
225         require(state == State.ACTIVE);
226         _;
227     }
228     
229     modifier inactiveGame() {
230         require(state != State.ACTIVE);
231         _;
232     }
233     
234     modifier finishedGame() {
235         require(state == State.ENDED);
236         _;
237     }
238     
239     //Private methods
240     
241     
242     function ()
243         public
244         payable
245         validBet
246         onlyPlayer
247     {
248         play();
249     }
250     
251     function play() public payable;
252     
253     function getState()
254         public
255         view
256         returns(State)
257     {
258         return state;
259     }
260     
261     function getBet()
262         public
263         view
264         returns (uint)
265     {
266         return bet;
267     }
268     
269     function getPlayers()
270         public
271         constant
272         returns(address[])
273     {
274         return ticketIndex;
275     }
276     
277     function getPlayerDetails(address player)
278         public
279         view
280         inactiveGame
281         returns (bool, bool, uint, uint, uint, uint)
282     {
283         TicketLib.Ticket memory ticket = tickets[player];
284         
285         return (ticket.is_winner, ticket.is_active,
286         ticket.block_number, ticket.block_time, ticket.num_votes, ticket.prize);
287     }
288     
289     function getWinners()
290         public
291         view
292         finishedGame
293         returns(address[] memory players, uint[] memory prizes)
294     {
295         var(numWinners, numFixedAmountWinners) = getNumWinners();
296         uint totalNumWinners = numWinners + numFixedAmountWinners;
297         players = new address[](totalNumWinners);
298         prizes = new uint[](totalNumWinners);
299         
300         uint index = 0;
301         
302         for (uint i = 0; i < ticketIndex.length; i++) {
303             if (tickets[ticketIndex[i]].is_winner == true) {
304                 players[index] = ticketIndex[i];
305                 prizes[index] = tickets[ticketIndex[i]].prize;
306                 index++;
307             }
308         }
309         
310         return (players, prizes);
311     }
312     
313     function getNumWinners()
314         public
315         constant
316         returns (uint, uint)
317     {
318         var(numWinners, numFixedAmountWinners) = calculator.getNumWinners(ticketIndex.length);
319 
320         return (numWinners, numFixedAmountWinners);
321     }
322     
323     function getPrizeAmount()
324         public
325         constant
326         returns (uint result)
327     {
328         uint totalAmount = this.balance;
329         
330         if ( state == State.ENDED ) {
331             totalAmount = bet * ticketIndex.length;
332         }
333         
334         result = calculator.getPrizeAmount(totalAmount);
335         
336         return result;
337     }
338     
339     function getStat()
340         public
341         constant
342         returns ( uint, uint, uint )
343     {
344         var (numWinners, numFixedAmountWinners) = getNumWinners();
345         return (ticketIndex.length, getPrizeAmount(), uint(numWinners + numFixedAmountWinners));
346     }
347 
348     function calcaultePrizes()
349         public
350         returns(uint[] memory result)
351     {
352         var(numWinners, numFixedAmountWinners) = getNumWinners();
353         uint totalNumWinners = ( numWinners + numFixedAmountWinners );
354         result = new uint[]( totalNumWinners );
355         
356         
357         uint[50] memory prizes = calculator.calcaultePrizes(
358         bet, ticketIndex.length);
359         
360         for (uint i = 0; i < totalNumWinners; i++) {
361             result[i] = prizes[i];
362         }
363         
364         return result;
365     }
366     
367     function revoke()
368         public
369         onlyAdministrator
370         activeGame
371     {
372         for (uint i = 0; i < ticketIndex.length; i++) {
373             tickets[ticketIndex[i]].is_active = false;
374             ticketIndex[i].transfer(bet);
375         }
376         
377         state = State.REVOKED;
378     }
379 }
380 
381 contract UnilotTailEther is BaseUnilotGame {
382     
383     uint winnerIndex;
384     
385     //Public methods
386     function UnilotTailEther(uint betAmount, address calculatorContractAddress)
387         public
388     {
389         state = State.ACTIVE;
390         administrator = msg.sender;
391         bet = betAmount;
392         
393         calculator = UnilotPrizeCalculator(calculatorContractAddress);
394         
395         GameStarted(betAmount);
396     }
397     
398     function play()
399         public
400         payable
401         validBet
402         onlyPlayer
403     {
404         require(tickets[msg.sender].block_number == 0);
405         require(ticketIndex.length < 200);
406         
407         tickets[msg.sender].is_winner    = false;
408         tickets[msg.sender].is_active    = true;
409         tickets[msg.sender].block_number = block.number;
410         tickets[msg.sender].block_time   = block.timestamp;
411         tickets[msg.sender].num_votes    = 0;
412         
413         ticketIndex.push(msg.sender);
414         
415         NewPlayerAdded(ticketIndex.length, getPrizeAmount());
416     }
417     
418     function finish()
419         public
420         onlyAdministrator
421         activeGame
422     {
423         uint max_votes;
424         
425         for (uint i = 0; i < ticketIndex.length; i++) {
426             TicketLib.Ticket memory ticket = tickets[ticketIndex[i]];
427             uint vote = ( ( ticket.block_number * ticket.block_time ) + uint(ticketIndex[i]) ) % ticketIndex.length;
428             
429             tickets[ticketIndex[vote]].num_votes += 1;
430             uint ticketNumVotes = tickets[ticketIndex[vote]].num_votes;
431             
432             if ( ticketNumVotes > max_votes ) {
433                 max_votes = ticketNumVotes;
434                 winnerIndex = vote;
435             }
436         }
437         
438         uint[] memory prizes = calcaultePrizes();
439         
440         uint lastId = winnerIndex;
441         
442         for ( i = 0; i < prizes.length; i++ ) {
443             if (tickets[ticketIndex[lastId]].is_active) {
444                 tickets[ticketIndex[lastId]].prize = prizes[i];
445                 tickets[ticketIndex[lastId]].is_winner = true;
446                 ticketIndex[lastId].transfer(prizes[i]);
447             } else {
448                 i--;
449             }
450             
451             if ( lastId <= 0 ) {
452                 lastId = ticketIndex.length;
453             }
454             
455             lastId -= 1;
456         }
457         
458         administrator.transfer(this.balance);
459         
460         state = State.ENDED;
461         
462         GameFinished(ticketIndex[winnerIndex]);
463     }
464 }