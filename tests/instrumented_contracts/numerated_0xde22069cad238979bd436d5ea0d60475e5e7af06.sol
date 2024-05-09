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
40 
41     uint8  constant gameCommision              = 10;   // 10%
42     uint8  constant bonusGameCommision         = 10;   // 10%
43     uint8  constant tokenHolerGameCommision    = 0;    // 0%
44     // End Calculation constants
45 
46     event Debug(uint);
47 
48     function getPrizeAmount(uint totalAmount)
49         public
50         pure
51         returns (uint result)
52     {
53         uint totalCommision = gameCommision
54                             + bonusGameCommision
55                             + tokenHolerGameCommision;
56 
57         //Calculation is odd on purpose.  It is a sort of ceiling effect to
58         // maximize amount of prize
59         result = ( totalAmount - ( ( totalAmount * totalCommision) / 100) );
60 
61         return result;
62     }
63 
64     function getNumWinners(uint numPlayers)
65         public
66         pure
67         returns (uint16 numWinners, uint16 numFixedAmountWinners)
68     {
69         // Calculation is odd on purpose. It is a sort of ceiling effect to
70         // maximize number of winners
71         uint16 totaNumlWinners = uint16( numPlayers - ( (numPlayers * ( 100 - percentOfWinners ) ) / 100 ) );
72 
73 
74         numFixedAmountWinners = uint16( (totaNumlWinners * percentOfFixedPrizeWinners) / 100 );
75         numWinners = uint16( totaNumlWinners - numFixedAmountWinners );
76 
77         return (numWinners, numFixedAmountWinners);
78     }
79 
80     function calcaultePrizes(uint bet, uint numPlayers)
81         public
82         pure
83         returns (uint[50] memory prizes)
84     {
85         var (numWinners, numFixedAmountWinners) = getNumWinners(numPlayers);
86 
87         require( uint(numWinners + numFixedAmountWinners) <= prizes.length );
88 
89         uint[] memory y = new uint[]((numWinners - 1));
90         uint z = 0; // Sum of all Y values
91 
92         if ( numWinners == 1 ) {
93             prizes[0] = getPrizeAmount(uint(bet*numPlayers));
94 
95             return prizes;
96         } else if ( numWinners < 1 ) {
97             return prizes;
98         }
99 
100         for (uint i = 0; i < y.length; i++) {
101             y[i] = formula( (calculateStep(numWinners) * i) );
102             z += y[i];
103         }
104 
105         bool stop = false;
106 
107         for (i = 0; i < 10; i++) {
108             uint[5] memory chunk = distributePrizeCalculation(
109                 i, z, y, numPlayers, bet);
110 
111             for ( uint j = 0; j < chunk.length; j++ ) {
112                 if ( ( (i * chunk.length) + j ) >= ( numWinners + numFixedAmountWinners ) ) {
113                     stop = true;
114                     break;
115                 }
116 
117                 prizes[ (i * chunk.length) + j ] = chunk[j];
118             }
119 
120             if ( stop ) {
121                 break;
122             }
123         }
124 
125         return prizes;
126     }
127 
128     function distributePrizeCalculation (uint chunkNumber, uint z, uint[] memory y, uint totalNumPlayers, uint bet)
129         private
130         pure
131         returns (uint[5] memory prizes)
132     {
133         var(numWinners, numFixedAmountWinners) = getNumWinners(totalNumPlayers);
134         uint prizeAmountForDeligation = getPrizeAmount( (totalNumPlayers * bet) );
135         prizeAmountForDeligation -= uint( ( bet * minPrizeCoeficent ) * uint( numWinners + numFixedAmountWinners ) );
136 
137         uint mainWinnerBaseAmount = ( (prizeAmountForDeligation * accuracy) / ( ( ( z * accuracy ) / ( 2 * y[0] ) ) + ( 1 * accuracy ) ) );
138         uint undeligatedAmount    = prizeAmountForDeligation;
139 
140         uint startPoint = chunkNumber * prizes.length;
141 
142         for ( uint i = 0; i < prizes.length; i++ ) {
143             if ( i >= uint(numWinners + numFixedAmountWinners) ) {
144                 break;
145             }
146             prizes[ i ] = (bet * minPrizeCoeficent);
147             uint extraPrize = 0;
148 
149             if ( i == ( numWinners - 1 ) ) {
150                 extraPrize = undeligatedAmount;
151             } else if ( i == 0 && chunkNumber == 0 ) {
152                 extraPrize = mainWinnerBaseAmount;
153             } else if ( ( startPoint + i ) < numWinners ) {
154                 extraPrize = ( ( y[ ( startPoint + i ) - 1 ] * (prizeAmountForDeligation - mainWinnerBaseAmount) ) / z);
155             }
156 
157             prizes[ i ] += extraPrize;
158             undeligatedAmount -= extraPrize;
159         }
160 
161         return prizes;
162     }
163 
164     function formula(uint x)
165         public
166         pure
167         returns (uint y)
168     {
169         y = ( (1 * accuracy**2) / (x + (5*accuracy/10))) - ((5 * accuracy) / 100);
170 
171         return y;
172     }
173 
174     function calculateStep(uint numWinners)
175         public
176         pure
177         returns(uint step)
178     {
179         step = ( MAX_X_FOR_Y * accuracy / 10 ) / numWinners;
180 
181         return step;
182     }
183 }
184 
185 contract BaseUnilotGame is Game {
186     enum State {
187         ACTIVE,
188         ENDED,
189         REVOKING,
190         REVOKED,
191         MOVED
192     }
193 
194     event PrizeResultCalculated(uint size, uint[] prizes);
195 
196     State state;
197     address administrator;
198     uint bet;
199 
200     mapping (address => TicketLib.Ticket) internal tickets;
201     address[] internal ticketIndex;
202 
203     UnilotPrizeCalculator calculator;
204 
205     //Modifiers
206     modifier onlyAdministrator() {
207         require(msg.sender == administrator);
208         _;
209     }
210 
211     modifier onlyPlayer() {
212         require(msg.sender != administrator);
213         _;
214     }
215 
216     modifier validBet() {
217         require(msg.value == bet);
218         _;
219     }
220 
221     modifier activeGame() {
222         require(state == State.ACTIVE);
223         _;
224     }
225 
226     modifier inactiveGame() {
227         require(state != State.ACTIVE);
228         _;
229     }
230 
231     modifier finishedGame() {
232         require(state == State.ENDED);
233         _;
234     }
235 
236     //Private methods
237 
238     function getState()
239         public
240         view
241         returns(State)
242     {
243         return state;
244     }
245 
246     function getBet()
247         public
248         view
249         returns (uint)
250     {
251         return bet;
252     }
253 
254     function getPlayers()
255         public
256         constant
257         returns(address[])
258     {
259         return ticketIndex;
260     }
261 
262     function getPlayerDetails(address player)
263         public
264         view
265         inactiveGame
266         returns (uint, uint, uint)
267     {
268         TicketLib.Ticket memory ticket = tickets[player];
269 
270         return (ticket.block_number, ticket.block_time, ticket.prize);
271     }
272 
273     function getNumWinners()
274         public
275         constant
276         returns (uint, uint)
277     {
278         var(numWinners, numFixedAmountWinners) = calculator.getNumWinners(ticketIndex.length);
279 
280         return (numWinners, numFixedAmountWinners);
281     }
282 
283     function getPrizeAmount()
284         public
285         constant
286         returns (uint result)
287     {
288         uint totalAmount = this.balance;
289 
290         if ( state == State.ENDED ) {
291             totalAmount = bet * ticketIndex.length;
292         }
293 
294         result = calculator.getPrizeAmount(totalAmount);
295 
296         return result;
297     }
298 
299     function getStat()
300         public
301         constant
302         returns ( uint, uint, uint )
303     {
304         var (numWinners, numFixedAmountWinners) = getNumWinners();
305         return (ticketIndex.length, getPrizeAmount(), uint(numWinners + numFixedAmountWinners));
306     }
307 
308     function calcaultePrizes()
309         public
310         returns(uint[] memory result)
311     {
312         var(numWinners, numFixedAmountWinners) = getNumWinners();
313         uint16 totalNumWinners = uint16( numWinners + numFixedAmountWinners );
314         result = new uint[]( totalNumWinners );
315 
316 
317         uint[50] memory prizes = calculator.calcaultePrizes(
318         bet, ticketIndex.length);
319 
320         for (uint16 i = 0; i < totalNumWinners; i++) {
321             result[i] = prizes[i];
322         }
323 
324         return result;
325     }
326 
327     function revoke()
328         public
329         onlyAdministrator
330         activeGame
331     {
332         for (uint24 i = 0; i < ticketIndex.length; i++) {
333             ticketIndex[i].transfer(bet);
334         }
335 
336         state = State.REVOKED;
337     }
338 }
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