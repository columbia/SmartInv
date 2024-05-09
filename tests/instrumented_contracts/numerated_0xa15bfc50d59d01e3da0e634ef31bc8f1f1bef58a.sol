1 pragma solidity ^0.4.16;
2 
3 interface Game {
4     event GameStarted(uint betAmount);
5     event NewPlayerAdded(uint numPlayers, uint prizeAmount);
6     event GameFinished(address winner);
7 
8     function () public payable;                                   //Participate in game. Proxy for play method
9     function getPrizeAmount() public constant returns (uint);     //Get potential or actual prize amount
10     function getNumWinners() public constant returns(uint, uint);
11     function getPlayers() public constant returns(address[]);           //Get full list of players
12     function getWinners() public view returns(address[] memory players,
13                                                 uint[] memory prizes);  //Get winners. Accessable only when finished
14     function getStat() public constant returns(uint, uint, uint);       //Short stat on game
15 
16     function calcaultePrizes() public returns (uint[]);
17 
18     function finish() public;                        //Closes game chooses winner
19 
20     function revoke() public;                        //Stop game and return money to players
21     // function move(address nextGame);              //Move players bets to another game
22 }
23 
24 library TicketLib {
25     struct Ticket {
26         uint40 block_number;
27         uint32 block_time;
28         uint prize;
29     }
30 }
31 
32 contract UnilotPrizeCalculator {
33     //Calculation constants
34     uint64  constant accuracy                   = 1000000000000000000;
35     uint8  constant MAX_X_FOR_Y                = 195;  // 19.5
36 
37     uint8  constant minPrizeCoeficent          = 1;
38     uint8  constant percentOfWinners           = 5;    // 5%
39     uint8  constant percentOfFixedPrizeWinners = 20;   // 20%
40     uint8  constant gameCommision              = 20;   // 20%
41     uint8  constant bonusGameCommision         = 5;    // 5%
42     uint8  constant tokenHolerGameCommision    = 5;    // 5%
43     // End Calculation constants
44 
45     event Debug(uint);
46 
47     function getPrizeAmount(uint totalAmount)
48         public
49         pure
50         returns (uint result)
51     {
52         uint totalCommision = gameCommision
53                             + bonusGameCommision
54                             + tokenHolerGameCommision;
55 
56         //Calculation is odd on purpose.  It is a sort of ceiling effect to
57         // maximize amount of prize
58         result = ( totalAmount - ( ( totalAmount * totalCommision) / 100) );
59 
60         return result;
61     }
62 
63     function getNumWinners(uint numPlayers)
64         public
65         pure
66         returns (uint16 numWinners, uint16 numFixedAmountWinners)
67     {
68         // Calculation is odd on purpose. It is a sort of ceiling effect to
69         // maximize number of winners
70         uint16 totaNumlWinners = uint16( numPlayers - ( (numPlayers * ( 100 - percentOfWinners ) ) / 100 ) );
71 
72 
73         numFixedAmountWinners = uint16( (totaNumlWinners * percentOfFixedPrizeWinners) / 100 );
74         numWinners = uint16( totaNumlWinners - numFixedAmountWinners );
75 
76         return (numWinners, numFixedAmountWinners);
77     }
78 
79     function calcaultePrizes(uint bet, uint numPlayers)
80         public
81         pure
82         returns (uint[50] memory prizes)
83     {
84         var (numWinners, numFixedAmountWinners) = getNumWinners(numPlayers);
85 
86         require( uint(numWinners + numFixedAmountWinners) <= prizes.length );
87 
88         uint[] memory y = new uint[]((numWinners - 1));
89         uint z = 0; // Sum of all Y values
90 
91         if ( numWinners == 1 ) {
92             prizes[0] = getPrizeAmount(uint(bet*numPlayers));
93 
94             return prizes;
95         } else if ( numWinners < 1 ) {
96             return prizes;
97         }
98 
99         for (uint i = 0; i < y.length; i++) {
100             y[i] = formula( (calculateStep(numWinners) * i) );
101             z += y[i];
102         }
103 
104         bool stop = false;
105 
106         for (i = 0; i < 10; i++) {
107             uint[5] memory chunk = distributePrizeCalculation(
108                 i, z, y, numPlayers, bet);
109 
110             for ( uint j = 0; j < chunk.length; j++ ) {
111                 if ( ( (i * chunk.length) + j ) >= ( numWinners + numFixedAmountWinners ) ) {
112                     stop = true;
113                     break;
114                 }
115 
116                 prizes[ (i * chunk.length) + j ] = chunk[j];
117             }
118 
119             if ( stop ) {
120                 break;
121             }
122         }
123 
124         return prizes;
125     }
126 
127     function distributePrizeCalculation (uint chunkNumber, uint z, uint[] memory y, uint totalNumPlayers, uint bet)
128         private
129         pure
130         returns (uint[5] memory prizes)
131     {
132         var(numWinners, numFixedAmountWinners) = getNumWinners(totalNumPlayers);
133         uint prizeAmountForDeligation = getPrizeAmount( (totalNumPlayers * bet) );
134         prizeAmountForDeligation -= uint( ( bet * minPrizeCoeficent ) * uint( numWinners + numFixedAmountWinners ) );
135 
136         uint mainWinnerBaseAmount = ( (prizeAmountForDeligation * accuracy) / ( ( ( z * accuracy ) / ( 2 * y[0] ) ) + ( 1 * accuracy ) ) );
137         uint undeligatedAmount    = prizeAmountForDeligation;
138 
139         uint startPoint = chunkNumber * prizes.length;
140 
141         for ( uint i = 0; i < prizes.length; i++ ) {
142             if ( i >= uint(numWinners + numFixedAmountWinners) ) {
143                 break;
144             }
145             prizes[ i ] = (bet * minPrizeCoeficent);
146             uint extraPrize = 0;
147 
148             if ( i == ( numWinners - 1 ) ) {
149                 extraPrize = undeligatedAmount;
150             } else if ( i == 0 && chunkNumber == 0 ) {
151                 extraPrize = mainWinnerBaseAmount;
152             } else if ( ( startPoint + i ) < numWinners ) {
153                 extraPrize = ( ( y[ ( startPoint + i ) - 1 ] * (prizeAmountForDeligation - mainWinnerBaseAmount) ) / z);
154             }
155 
156             prizes[ i ] += extraPrize;
157             undeligatedAmount -= extraPrize;
158         }
159 
160         return prizes;
161     }
162 
163     function formula(uint x)
164         public
165         pure
166         returns (uint y)
167     {
168         y = ( (1 * accuracy**2) / (x + (5*accuracy/10))) - ((5 * accuracy) / 100);
169 
170         return y;
171     }
172 
173     function calculateStep(uint numWinners)
174         public
175         pure
176         returns(uint step)
177     {
178         step = ( MAX_X_FOR_Y * accuracy / 10 ) / numWinners;
179 
180         return step;
181     }
182 }
183 
184 contract BaseUnilotGame is Game {
185     enum State {
186         ACTIVE,
187         ENDED,
188         REVOKING,
189         REVOKED,
190         MOVED
191     }
192 
193     event PrizeResultCalculated(uint size, uint[] prizes);
194 
195     State state;
196     address administrator;
197     uint bet;
198 
199     mapping (address => TicketLib.Ticket) internal tickets;
200     address[] internal ticketIndex;
201 
202     UnilotPrizeCalculator calculator;
203 
204     //Modifiers
205     modifier onlyAdministrator() {
206         require(msg.sender == administrator);
207         _;
208     }
209 
210     modifier onlyPlayer() {
211         require(msg.sender != administrator);
212         _;
213     }
214 
215     modifier validBet() {
216         require(msg.value == bet);
217         _;
218     }
219 
220     modifier activeGame() {
221         require(state == State.ACTIVE);
222         _;
223     }
224 
225     modifier inactiveGame() {
226         require(state != State.ACTIVE);
227         _;
228     }
229 
230     modifier finishedGame() {
231         require(state == State.ENDED);
232         _;
233     }
234 
235     //Private methods
236 
237     function getState()
238         public
239         view
240         returns(State)
241     {
242         return state;
243     }
244 
245     function getBet()
246         public
247         view
248         returns (uint)
249     {
250         return bet;
251     }
252 
253     function getPlayers()
254         public
255         constant
256         returns(address[])
257     {
258         return ticketIndex;
259     }
260 
261     function getPlayerDetails(address player)
262         public
263         view
264         inactiveGame
265         returns (uint, uint, uint)
266     {
267         TicketLib.Ticket memory ticket = tickets[player];
268 
269         return (ticket.block_number, ticket.block_time, ticket.prize);
270     }
271 
272     function getNumWinners()
273         public
274         constant
275         returns (uint, uint)
276     {
277         var(numWinners, numFixedAmountWinners) = calculator.getNumWinners(ticketIndex.length);
278 
279         return (numWinners, numFixedAmountWinners);
280     }
281 
282     function getPrizeAmount()
283         public
284         constant
285         returns (uint result)
286     {
287         uint totalAmount = this.balance;
288 
289         if ( state == State.ENDED ) {
290             totalAmount = bet * ticketIndex.length;
291         }
292 
293         result = calculator.getPrizeAmount(totalAmount);
294 
295         return result;
296     }
297 
298     function getStat()
299         public
300         constant
301         returns ( uint, uint, uint )
302     {
303         var (numWinners, numFixedAmountWinners) = getNumWinners();
304         return (ticketIndex.length, getPrizeAmount(), uint(numWinners + numFixedAmountWinners));
305     }
306 
307     function calcaultePrizes()
308         public
309         returns(uint[] memory result)
310     {
311         var(numWinners, numFixedAmountWinners) = getNumWinners();
312         uint16 totalNumWinners = uint16( numWinners + numFixedAmountWinners );
313         result = new uint[]( totalNumWinners );
314 
315 
316         uint[50] memory prizes = calculator.calcaultePrizes(
317         bet, ticketIndex.length);
318 
319         for (uint16 i = 0; i < totalNumWinners; i++) {
320             result[i] = prizes[i];
321         }
322 
323         return result;
324     }
325 
326     function revoke()
327         public
328         onlyAdministrator
329         activeGame
330     {
331         for (uint24 i = 0; i < ticketIndex.length; i++) {
332             ticketIndex[i].transfer(bet);
333         }
334 
335         state = State.REVOKED;
336     }
337 }
338 
339 
340 contract UnilotTailEther is BaseUnilotGame {
341 
342     uint64 winnerIndex;
343 
344     //Public methods
345     function UnilotTailEther(uint betAmount, address calculatorContractAddress)
346         public
347     {
348         state = State.ACTIVE;
349         administrator = msg.sender;
350         bet = betAmount;
351 
352         calculator = UnilotPrizeCalculator(calculatorContractAddress);
353 
354         GameStarted(betAmount);
355     }
356 
357     function getWinners()
358         public
359         view
360         finishedGame
361         returns(address[] memory players, uint[] memory prizes)
362     {
363         var(numWinners, numFixedAmountWinners) = getNumWinners();
364         uint totalNumWinners = numWinners + numFixedAmountWinners;
365 
366         players = new address[](totalNumWinners);
367         prizes = new uint[](totalNumWinners);
368 
369         uint index;
370 
371         for (uint i = 0; i < totalNumWinners; i++) {
372             if ( i > winnerIndex ) {
373                 index = ( ( players.length ) - ( i - winnerIndex ) );
374             } else {
375                 index = ( winnerIndex - i );
376             }
377 
378             players[i] = ticketIndex[index];
379             prizes[i] = tickets[players[i]].prize;
380         }
381 
382         return (players, prizes);
383     }
384 
385     function ()
386         public
387         payable
388         validBet
389         onlyPlayer
390     {
391         require(tickets[msg.sender].block_number == 0);
392         require(ticketIndex.length <= 1000);
393 
394         tickets[msg.sender].block_number = uint40(block.number);
395         tickets[msg.sender].block_time   = uint32(block.timestamp);
396 
397         ticketIndex.push(msg.sender);
398 
399         NewPlayerAdded(ticketIndex.length, getPrizeAmount());
400     }
401 
402     function finish()
403         public
404         onlyAdministrator
405         activeGame
406     {
407         uint64 max_votes;
408         uint64[] memory num_votes = new uint64[](ticketIndex.length);
409 
410         for (uint i = 0; i < ticketIndex.length; i++) {
411             TicketLib.Ticket memory ticket = tickets[ticketIndex[i]];
412             uint64 vote = uint64( ( ( ticket.block_number * ticket.block_time ) + uint( ticketIndex[i]) ) % ticketIndex.length );
413 
414             num_votes[vote] += 1;
415 
416             if ( num_votes[vote] > max_votes ) {
417                 max_votes = num_votes[vote];
418                 winnerIndex = vote;
419             }
420         }
421 
422         uint[] memory prizes = calcaultePrizes();
423 
424         uint lastId = winnerIndex;
425 
426         for ( i = 0; i < prizes.length; i++ ) {
427             tickets[ticketIndex[lastId]].prize = prizes[i];
428             ticketIndex[lastId].transfer(prizes[i]);
429 
430             if ( lastId <= 0 ) {
431                 lastId = ticketIndex.length;
432             }
433 
434             lastId -= 1;
435         }
436 
437         administrator.transfer(this.balance);
438 
439         state = State.ENDED;
440 
441         GameFinished(ticketIndex[winnerIndex]);
442     }
443 }