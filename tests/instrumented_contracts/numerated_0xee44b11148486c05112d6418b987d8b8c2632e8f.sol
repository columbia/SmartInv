1 pragma solidity ^0.4.19;
2 
3 contract Spineth
4 {
5     /// The states the game will transition through
6     enum State
7     {
8         WaitingForPlayers, // the game has been created by a player and is waiting for an opponent
9         WaitingForReveal, // someone has joined and also placed a bet, we are now waiting for the creator to their reveal bet
10         Complete // the outcome of the game is determined and players can withdraw their earnings
11     }
12 
13     /// All possible event types
14     enum Event
15     {
16         Create,
17         Cancel,
18         Join,
19         Reveal,
20         Expire,
21         Complete,
22         Withdraw,
23         StartReveal
24     }
25     
26     // The game state associated with a single game between two players
27     struct GameInstance
28     {
29         // Address for players of this game
30         // player1 is always the creator
31         address player1;
32         address player2;
33     
34         // How much is being bet this game
35         uint betAmountInWei;
36     
37         // The wheelBet for each player
38         // For player1, the bet starts as a hash and is only changed to the real bet once revealed
39         uint wheelBetPlayer1;
40         uint wheelBetPlayer2;
41     
42         // The final wheel position after game is complete
43         uint wheelResult;
44     
45         // The time by which the creator of the game must reveal his bet after an opponent joins
46         // If the creator does not reveal in time, the opponent can expire the game, causing them to win the maximal amount of their bet
47         uint expireTime;
48 
49         // Current state of the game    
50         State state;
51 
52         // Tracks whether each player has withdrawn their earnings yet
53         bool withdrawnPlayer1;
54         bool withdrawnPlayer2;
55     }
56 
57     /// How many places there are on the wheel that a bet can be placed
58     uint public constant WHEEL_SIZE = 19;
59     
60     /// What percentage of your opponent's bet a player wins for each place on 
61     /// the wheel they are closer to the result than their opponent
62     /// i.e. If player1 distance from result = 4 and player2 distance from result = 6
63     /// then player1 earns (6-4) x WIN_PERCENT_PER_DISTANCE = 20% of player2's bet
64     uint public constant WIN_PERCENT_PER_DISTANCE = 10;
65 
66     /// The percentage charged on earnings that are won
67     uint public constant FEE_PERCENT = 2;
68 
69     /// The minimum amount that can be bet
70     uint public minBetWei = 1 finney;
71     
72     /// The maximum amount that can be bet
73     uint public maxBetWei = 10 ether;
74     
75     /// The amount of time creators have to reavel their bets before
76     /// the game can be expired by an opponent
77     uint public maxRevealSeconds = 3600 * 24;
78 
79     /// The account that will receive fees and can configure min/max bet options
80     address public authority;
81 
82     /// Counters that tracks how many games have been created by each player
83     /// This is used to generate a unique game id per player
84     mapping(address => uint) private counterContext;
85 
86     /// Context for all created games
87     mapping(uint => GameInstance) public gameContext;
88 
89     /// List of all currently open gameids
90     uint[] public openGames;
91 
92     /// Indexes specific to each player
93     mapping(address => uint[]) public playerActiveGames;
94     mapping(address => uint[]) public playerCompleteGames;    
95 
96     /// Event fired when a game's state changes
97     event GameEvent(uint indexed gameId, address indexed player, Event indexed eventType);
98 
99     /// Create the contract and verify constant configurations make sense
100     function Spineth() public
101     {
102         // Make sure that the maximum possible win distance (WHEEL_SIZE / 2)
103         // multiplied by the WIN_PERCENT_PER_DISTANCE is less than 100%
104         // If it's not, then a maximally won bet can't be paid out
105         require((WHEEL_SIZE / 2) * WIN_PERCENT_PER_DISTANCE < 100);
106 
107         authority = msg.sender;
108     }
109     
110     // Change authority
111     // Can only be called by authority
112     function changeAuthority(address newAuthority) public
113     {
114         require(msg.sender == authority);
115 
116         authority = newAuthority;
117     }
118 
119     // Change min/max bet amounts
120     // Can only be called by authority
121     function changeBetLimits(uint minBet, uint maxBet) public
122     {
123         require(msg.sender == authority);
124         require(maxBet >= minBet);
125 
126         minBetWei = minBet;
127         maxBetWei = maxBet;
128     }
129     
130     // Internal helper function to add elements to an array
131     function arrayAdd(uint[] storage array, uint element) private
132     {
133         array.push(element);
134     }
135 
136     // Internal helper function to remove element from an array
137     function arrayRemove(uint[] storage array, uint element) private
138     {
139         for(uint i = 0; i < array.length; ++i)
140         {
141             if(array[i] == element)
142             {
143                 array[i] = array[array.length - 1];
144                 delete array[array.length - 1];
145                 --array.length;
146                 break;
147             }
148         }
149     }
150 
151     /// Get next game id to be associated with a player address
152     function getNextGameId(address player) public view
153         returns (uint)
154     {
155         uint counter = counterContext[player];
156 
157         // Addresses are 160 bits so we can safely shift them up by (256 - 160 = 96 bits)
158         // to make room for the counter in the bottom 96 bits
159         // This means a single player cannot theoretically create more than 2^96 games
160         // which should more than enough for the lifetime of any player.
161         uint result = (uint(player) << 96) + counter;
162 
163         // Check that we didn't overflow the counter (this will never happen)
164         require((result >> 96) == uint(player));
165 
166         return result;
167     }
168 
169     /// Used to calculate the bet hash given a wheel bet and a player secret.
170     /// Used by a game creator to calculate their bet bash off chain first.
171     /// When bet is revealed, contract will use this function to verify the revealed bet is valid
172     function createWheelBetHash(uint gameId, uint wheelBet, uint playerSecret) public pure
173         returns (uint)
174     {
175         require(wheelBet < WHEEL_SIZE);
176         return uint(keccak256(gameId, wheelBet, playerSecret));
177     }
178     
179     /// Create and initialize a game instance with the sent bet amount.
180     /// The creator will automatically become a participant of the game.
181     /// gameId must be the return value of getNextGameId(...) for the sender
182     /// wheelPositionHash should be calculated using createWheelBetHash(...)
183     function createGame(uint gameId, uint wheelPositionHash) public payable
184     {
185         // Make sure the player passed the correct value for the game id
186         require(getNextGameId(msg.sender) == gameId);
187 
188         // Get the game instance and ensure that it doesn't already exist
189         GameInstance storage game = gameContext[gameId];
190         require(game.betAmountInWei == 0); 
191         
192         // Must provide non-zero bet
193         require(msg.value > 0);
194         
195         // Restrict betting amount
196         // NOTE: Game creation can be disabled by setting min/max bet to 0
197         require(msg.value >= minBetWei && msg.value <= maxBetWei);
198 
199         // Increment the create game counter for this player
200         counterContext[msg.sender] = counterContext[msg.sender] + 1;
201 
202         // Update game state
203         // The creator becomes player1
204         game.state = State.WaitingForPlayers;
205         game.betAmountInWei = msg.value;
206         game.player1 = msg.sender;
207         game.wheelBetPlayer1 = wheelPositionHash;
208         
209         // This game is now open to others and active for the player
210         arrayAdd(openGames, gameId);
211         arrayAdd(playerActiveGames[msg.sender], gameId);
212 
213         // Fire event for the creation of this game
214         GameEvent(gameId, msg.sender, Event.Create);
215     }
216     
217     /// Cancel a game that was created but never had another player join
218     /// A creator can use this function if they have been waiting too long for another
219     /// player and want to get their bet funds back. NOTE. Once someone joins
220     /// the game can no longer be cancelled.
221     function cancelGame(uint gameId) public
222     {
223         // Get the game instance and check that it exists
224         GameInstance storage game = gameContext[gameId];
225         require(game.betAmountInWei > 0); 
226 
227         // Can only cancel if we are still waiting for other participants
228         require(game.state == State.WaitingForPlayers);
229         
230         // Is the sender the creator?
231         require(game.player1 == msg.sender);
232 
233         // Update game state
234         // Mark earnings as already withdrawn since we are returning the bet amount
235         game.state = State.Complete;
236         game.withdrawnPlayer1 = true;
237 
238         // This game is no longer open and no longer active for the player
239         arrayRemove(openGames, gameId);
240         arrayRemove(playerActiveGames[msg.sender], gameId);
241 
242         // Fire event for player canceling this game
243         GameEvent(gameId, msg.sender, Event.Cancel);
244 
245         // Transfer the player's bet amount back to them
246         msg.sender.transfer(game.betAmountInWei);
247     }
248 
249     /// Join an open game instance
250     /// Sender must provide an amount of wei equal to betAmountInWei
251     /// After the second player has joined, the creator will have maxRevealSeconds to reveal their bet
252     function joinGame(uint gameId, uint wheelBet) public payable
253     {
254         // Get the game instance and check that it exists
255         GameInstance storage game = gameContext[gameId];
256         require(game.betAmountInWei > 0); 
257         
258         // Only allowed to participate while we are waiting for players
259         require(game.state == State.WaitingForPlayers);
260         
261         // Can't join a game that you created
262         require(game.player1 != msg.sender);
263         
264         // Is there space available?
265         require(game.player2 == 0);
266 
267         // Must pay the amount of the bet to play
268         require(msg.value == game.betAmountInWei);
269 
270         // Make sure the wheelBet makes sense
271         require(wheelBet < WHEEL_SIZE);
272 
273         // Update game state
274         // The sender becomes player2
275         game.state = State.WaitingForReveal;
276         game.player2 = msg.sender;
277         game.wheelBetPlayer2 = wheelBet;
278         game.expireTime = now + maxRevealSeconds; // After expireTime the game can be expired
279 
280         // This game is no longer open, and is now active for the joiner
281         arrayRemove(openGames, gameId);
282         arrayAdd(playerActiveGames[msg.sender], gameId);
283 
284         // Fire event for player joining this game
285         GameEvent(gameId, msg.sender, Event.Join);
286 
287         // Fire event for creator, letting them know they need to reveal their bet now
288         GameEvent(gameId, game.player1, Event.StartReveal);
289     }
290     
291     /// This can be called by the joining player to force the game to end once the expire
292     /// time has been reached. This is a safety measure to ensure the game can be completed
293     /// in case where the creator decides to not to reveal their bet. In this case, the creator
294     /// will lose the maximal amount of their bet
295     function expireGame(uint gameId) public
296     {
297         // Get the game instance and check that it exists
298         GameInstance storage game = gameContext[gameId];
299         require(game.betAmountInWei > 0); 
300 
301         // Only expire from the WaitingForReveal state
302         require(game.state == State.WaitingForReveal);
303         
304         // Has enough time passed to perform this action?
305         require(now > game.expireTime);
306         
307         // Can only expire the game if you are the second player
308         require(msg.sender == game.player2);
309 
310         // Player1 (creator) did not reveal bet in time
311         // Complete the game in favor of player2
312         game.wheelResult = game.wheelBetPlayer2;
313         game.wheelBetPlayer1 = (game.wheelBetPlayer2 + (WHEEL_SIZE / 2)) % WHEEL_SIZE;
314         
315         // This game is complete, the withdrawEarnings flow can now be invoked
316         game.state = State.Complete;
317 
318         // Fire an event for the player forcing this game to end
319         GameEvent(gameId, game.player1, Event.Expire);
320         GameEvent(gameId, game.player2, Event.Expire);
321     }
322     
323     /// Once a player has joined the game, the creator must reveal their bet
324     /// by providing the same playerSecret that was passed to createGame(...)
325     function revealBet(uint gameId, uint playerSecret) public
326     {
327         // Get the game instance and check that it exists
328         GameInstance storage game = gameContext[gameId];
329         require(game.betAmountInWei > 0); 
330 
331         // We can only reveal bets during the revealing bets state
332         require(game.state == State.WaitingForReveal);
333 
334         // Only the creator does this
335         require(game.player1 == msg.sender);
336 
337         uint i; // Loop counter used below
338 
339         // Find the wheelBet the player made by enumerating the hash
340         // possibilities. It is done this way so the player only has to
341         // remember their secret in order to revel the bet
342         for(i = 0; i < WHEEL_SIZE; ++i)
343         {
344             // Find the bet that was provided in createGame(...)
345             if(createWheelBetHash(gameId, i, playerSecret) == game.wheelBetPlayer1)
346             {
347                 // Update the bet to the revealed value
348                 game.wheelBetPlayer1 = i;
349                 break;
350             }
351         }
352         
353         // Make sure we successfully revealed the bet, otherwise
354         // the playerSecret was invalid
355         require(i < WHEEL_SIZE);
356         
357         // Fire an event for the revealing of the bet
358         GameEvent(gameId, msg.sender, Event.Reveal);
359 
360         // Use the revealed bets to calculate the wheelResult
361         // NOTE: Neither player knew the unrevealed state of both bets when making their
362         // bet, so the combination can be used to generate a random number neither player could anticipate.
363         // This algorithm was tested for good outcome distribution for arbitrary hash values
364         uint256 hashResult = uint256(keccak256(gameId, now, game.wheelBetPlayer1, game.wheelBetPlayer2));
365         uint32 randomSeed = uint32(hashResult >> 0)
366                           ^ uint32(hashResult >> 32)
367                           ^ uint32(hashResult >> 64)
368                           ^ uint32(hashResult >> 96)
369                           ^ uint32(hashResult >> 128)
370                           ^ uint32(hashResult >> 160)
371                           ^ uint32(hashResult >> 192)
372                           ^ uint32(hashResult >> 224);
373 
374         uint32 randomNumber = randomSeed;
375         uint32 randMax = 0xFFFFFFFF; // We use the whole 32 bit range
376 
377         // Generate random numbers until we get a value in the unbiased range (see below)
378         do
379         {
380             randomNumber ^= (randomNumber >> 11);
381             randomNumber ^= (randomNumber << 7) & 0x9D2C5680;
382             randomNumber ^= (randomNumber << 15) & 0xEFC60000;
383             randomNumber ^= (randomNumber >> 18);
384         }
385         // Since WHEEL_SIZE is not divisible by randMax, using modulo below will introduce bias for
386         // numbers at the end of the randMax range. To remedy this, we discard these out of range numbers
387         // and generate additional numbers until we are in the largest range divisble by WHEEL_SIZE.
388         // This range will ensure we do not introduce any modulo bias
389         while(randomNumber >= (randMax - (randMax % WHEEL_SIZE)));
390 
391         // Update game state        
392         game.wheelResult = randomNumber % WHEEL_SIZE;
393         game.state = State.Complete;
394         
395         // Fire an event for the completion of the game
396         GameEvent(gameId, game.player1, Event.Complete);
397         GameEvent(gameId, game.player2, Event.Complete);
398     }
399 
400     /// A utility function to get the minimum distance between two selections
401     /// on a wheel of WHEEL_SIZE wrapping around at 0
402     function getWheelDistance(uint value1, uint value2) private pure
403         returns (uint)
404     {
405         // Make sure the values are within range
406         require(value1 < WHEEL_SIZE && value2 < WHEEL_SIZE);
407 
408         // Calculate the distance of value1 with respect to value2
409         uint dist1 = (WHEEL_SIZE + value1 - value2) % WHEEL_SIZE;
410         
411         // Calculate the distance going the other way around the wheel
412         uint dist2 = WHEEL_SIZE - dist1;
413 
414         // Whichever distance is shorter is the wheel distance
415         return (dist1 < dist2) ? dist1 : dist2;
416     }
417 
418     /// Once the game is complete, use this function to get the results of
419     /// the game. Returns:
420     /// - the amount of wei charged for the fee
421     /// - the amount of wei to be paid out to player1
422     /// - the amount of wei to be paid out to player2
423     /// The sum of all the return values is exactly equal to the contributions
424     /// of both player bets. i.e. 
425     ///     feeWei + weiPlayer1 + weiPlayer2 = 2 * betAmountInWei
426     function calculateEarnings(uint gameId) public view
427         returns (uint feeWei, uint weiPlayer1, uint weiPlayer2)
428     {
429         // Get the game instance and check that it exists
430         GameInstance storage game = gameContext[gameId];
431         require(game.betAmountInWei > 0); 
432 
433         // It doesn't make sense to call this function when the game isn't complete
434         require(game.state == State.Complete);
435         
436         uint distancePlayer1 = getWheelDistance(game.wheelBetPlayer1, game.wheelResult);
437         uint distancePlayer2 = getWheelDistance(game.wheelBetPlayer2, game.wheelResult);
438 
439         // Outcome if there is a tie
440         feeWei = 0;
441         weiPlayer1 = game.betAmountInWei;
442         weiPlayer2 = game.betAmountInWei;
443 
444         uint winDist = 0;
445         uint winWei = 0;
446         
447         // Player one was closer, so they won
448         if(distancePlayer1 < distancePlayer2)
449         {
450             winDist = distancePlayer2 - distancePlayer1;
451             winWei = game.betAmountInWei * (winDist * WIN_PERCENT_PER_DISTANCE) / 100;
452 
453             feeWei = winWei * FEE_PERCENT / 100;
454             weiPlayer1 += winWei - feeWei;
455             weiPlayer2 -= winWei;
456         }
457         // Player two was closer, so they won
458         else if(distancePlayer2 < distancePlayer1)
459         {
460             winDist = distancePlayer1 - distancePlayer2;
461             winWei = game.betAmountInWei * (winDist * WIN_PERCENT_PER_DISTANCE) / 100;
462 
463             feeWei = winWei * FEE_PERCENT / 100;
464             weiPlayer2 += winWei - feeWei;
465             weiPlayer1 -= winWei;
466         }
467         // Same distance, so it was a tie (see above)
468     }
469     
470     /// Once the game is complete, each player can withdraw their earnings
471     /// A fee is charged on winnings only and provided to the contract authority
472     function withdrawEarnings(uint gameId) public
473     {
474         // Get the game instance and check that it exists
475         GameInstance storage game = gameContext[gameId];
476         require(game.betAmountInWei > 0); 
477 
478         require(game.state == State.Complete);
479         
480         var (feeWei, weiPlayer1, weiPlayer2) = calculateEarnings(gameId);
481 
482         bool payFee = false;
483         uint withdrawAmount = 0;
484 
485         if(game.player1 == msg.sender)
486         {
487             // Can't have already withrawn
488             require(game.withdrawnPlayer1 == false);
489             
490             game.withdrawnPlayer1 = true; // They can't withdraw again
491             
492             // If player1 was the winner, they will pay the fee
493             if(weiPlayer1 > weiPlayer2)
494             {
495                 payFee = true;
496             }
497             
498             withdrawAmount = weiPlayer1;
499         }
500         else if(game.player2 == msg.sender)
501         {
502             // Can't have already withrawn
503             require(game.withdrawnPlayer2 == false);
504             
505             game.withdrawnPlayer2 = true;
506 
507             // If player2 was the winner, they will pay the fee
508             if(weiPlayer2 > weiPlayer1)
509             {
510                 payFee = true;
511             }
512             
513             withdrawAmount = weiPlayer2;
514         }
515         else
516         {
517             // The sender isn't a participant
518             revert();
519         }
520 
521         // This game is no longer active for this player, and now moved to complete for this player
522         arrayRemove(playerActiveGames[msg.sender], gameId);
523         arrayAdd(playerCompleteGames[msg.sender], gameId);
524 
525         // Fire an event for the withdrawing of funds
526         GameEvent(gameId, msg.sender, Event.Withdraw);
527 
528         // Pay the fee, if necessary
529         if(payFee == true)
530         {
531             authority.transfer(feeWei);
532         }
533     
534         // Transfer sender their outcome
535         msg.sender.transfer(withdrawAmount);
536     }
537 }