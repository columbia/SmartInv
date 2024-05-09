1 /**
2 * @dev Cryptolotto referral system interface.
3 */
4 contract iCryptolottoReferral {
5     /**
6     * @dev Get partner by referral.
7     */
8     function getPartnerByReferral(address) public view returns (address) {}
9     
10     /**
11     * @dev Get partner percent.
12     */
13     function getPartnerPercent(address) public view returns (uint8) {}
14     
15     /**
16     * @dev Get sales partner percent by partner address.
17     */
18     function getSalesPartnerPercent(address) public view returns (uint8) {}
19     
20     /**
21     * @dev Get sales partner address by partner address.
22     */
23     function getSalesPartner(address) public view returns (address) {}
24     
25     /**
26     * @dev Add new referral.
27     */
28     function addReferral(address, address) public {}
29 }
30 
31 /**
32 * @dev Cryptolotto stats aggregator interface.
33 */
34 contract iCryptolottoStatsAggregator {
35     /**
36     * @dev Write info to log about the new winner.
37     */
38     function newWinner(address, uint, uint, uint, uint8, uint) public {}
39 }
40 
41 /**
42 * @dev Ownable contract interface.
43 */
44 contract iOwnable {
45     function getOwner() public view returns (address) {}
46     function allowed(address) public view returns (bool) {}
47 }
48 
49 
50 /**
51 * @title Cryptolotto1Day
52 * @dev This smart contract is a part of Cryptolotto (cryptolotto.cc) product.
53 *
54 * @dev Cryptolotto is a blockchain-based, Ethereum powered lottery which gives to users the most 
55 * @dev transparent and honest chances of winning.
56 *
57 * @dev The main idea of Cryptolotto is straightforward: people from all over the world during the 
58 * @dev set period of time are contributing an equal amount of ETH to one wallet. When a timer ends 
59 * @dev this smart-contract powered wallet automatically sends all received ETHs to a one randomly 
60 * @dev chosen wallet-participant.
61 *
62 * @dev Due to the fact that Cryptolotto is built on a blockchain technology, it eliminates any 
63 * @dev potential for intervention by third parties and gives 100% guarantee of an honest game.
64 * @dev There are no backdoors and no human or computer soft can interfere the process of picking a winner.
65 *
66 * @dev If during the game only one player joins it, then the player will receive all his ETH back.
67 * @dev If a player sends not the exact amount of ETH - he will receive all his ETH back.
68 * @dev Creators of the product can change the entrance price for the game. If the price is changed 
69 * @dev then new rules are applied when a new game starts.
70 *
71 * @dev The original idea of Cryptolotto belongs to t.me/crypto_god and t.me/crypto_creator - Founders. 
72 * @dev Cryptolotto smart-contracts are protected by copyright, trademark, patent, trade secret, 
73 * @dev other intellectual property, proprietary rights laws and other applicable laws.
74 *
75 * @dev All information related to the product can be found only on: 
76 * @dev - cryptolotto.cc
77 * @dev - github.com/cryptolotto
78 * @dev - instagram.com/cryptolotto
79 * @dev - facebook.com/cryptolotto
80 *
81 * @dev Cryptolotto was designed and developed by erde group (https://erde.group).
82 **/
83 contract Cryptolotto1Hour {
84     /**
85     * @dev Write to log info about the new game.
86     *
87     * @param _game Game number.
88     * @param _time Time when game stated.
89     */
90     event Game(uint _game, uint indexed _time);
91 
92     /**
93     * @dev Write to log info about the new game player.
94     *
95     * @param _address Player wallet address.
96     * @param _game Game number in which player buy ticket.
97     * @param _number Player number in the game.
98     * @param _time Time when player buy ticket.
99     */
100     event Ticket(
101         address indexed _address,
102         uint indexed _game,
103         uint _number,
104         uint _time
105     );
106 
107     /**
108     * @dev Write to log info about partner earnings.
109     *
110     * @param _partner Partner wallet address.
111     * @param _referral Referral wallet address.
112     * @param _amount Earning amount.
113     * @param _time The time when ether was earned.
114     */
115     event ToPartner(
116         address indexed _partner,
117         address _referral,
118         uint _amount,
119         uint _time
120     );
121 
122     /**
123     * @dev Write to log info about sales partner earnings.
124     *
125     * @param _salesPartner Sales partner wallet address.
126     * @param _partner Partner wallet address.
127     * @param _amount Earning amount.
128     * @param _time The time when ether was earned.
129     */
130     event ToSalesPartner(
131         address indexed _salesPartner,
132         address _partner,
133         uint _amount,
134         uint _time
135     );
136     
137     // Game type. Each game has own type.
138     uint8 public gType = 2;
139     // Game fee.
140     uint8 public fee = 10;
141     // Current game number.
142     uint public game;
143     // Ticket price.
144     uint public ticketPrice = 0.01 ether;
145     // New ticket price.
146     uint public newPrice;
147     // All-time game jackpot.
148     uint public allTimeJackpot = 0;
149     // All-time game players count
150     uint public allTimePlayers = 0;
151     
152     // Paid to partners.
153     uint public paidToPartners = 0;
154     // Game status.
155     bool public isActive = true;
156     // The variable that indicates game status switching.
157     bool public toogleStatus = false;
158     // The array of all games
159     uint[] public games;
160     
161     // Store game jackpot.
162     mapping(uint => uint) jackpot;
163     // Store game players.
164     mapping(uint => address[]) players;
165     
166     // Ownable contract
167     iOwnable public ownable;
168     // Stats aggregator contract.
169     iCryptolottoStatsAggregator public stats;
170     // Referral system contract.
171     iCryptolottoReferral public referralInstance;
172     // Funds distributor address.
173     address public fundsDistributor;
174 
175     /**
176     * @dev Check sender address and compare it to an owner.
177     */
178     modifier onlyOwner() {
179         require(ownable.allowed(msg.sender));
180         _;
181     }
182 
183     /**
184     * @dev Initialize game.
185     * @dev Create ownable and stats aggregator instances, 
186     * @dev set funds distributor contract address.
187     *
188     * @param ownableContract The address of previously deployed ownable contract.
189     * @param distributor The address of previously deployed funds distributor contract.
190     * @param statsA The address of previously deployed stats aggregator contract.
191     * @param referralSystem The address of previously deployed referral system contract.
192     */
193     function Cryptolotto1Hour(
194         address ownableContract,
195         address distributor,
196         address statsA,
197         address referralSystem
198     ) 
199         public
200     {
201         ownable = iOwnable(ownableContract);
202         stats = iCryptolottoStatsAggregator(statsA);
203         referralInstance = iCryptolottoReferral(referralSystem);
204         fundsDistributor = distributor;
205         startGame();
206     }
207 
208     /**
209     * @dev The method that allows buying tickets by directly sending ether to the contract.
210     */
211     function() public payable {
212         buyTicket(address(0));
213     }
214 
215     /**
216     * @dev Returns current game players.
217     */
218     function getPlayedGamePlayers() 
219         public
220         view
221         returns (uint)
222     {
223         return getPlayersInGame(game);
224     }
225 
226     /**
227     * @dev Get players by game.
228     *
229     * @param playedGame Game number.
230     */
231     function getPlayersInGame(uint playedGame) 
232         public 
233         view
234         returns (uint)
235     {
236         return players[playedGame].length;
237     }
238 
239     /**
240     * @dev Returns current game jackpot.
241     */
242     function getPlayedGameJackpot() 
243         public 
244         view
245         returns (uint) 
246     {
247         return getGameJackpot(game);
248     }
249     
250     /**
251     * @dev Get jackpot by game number.
252     *
253     * @param playedGame The number of the played game.
254     */
255     function getGameJackpot(uint playedGame) 
256         public 
257         view 
258         returns(uint)
259     {
260         return jackpot[playedGame];
261     }
262     
263     /**
264     * @dev Change game status.
265     * @dev If the game is active sets flag for game status changing. Otherwise, change game status.
266     */
267     function toogleActive() public onlyOwner() {
268         if (!isActive) {
269             isActive = true;
270         } else {
271             toogleStatus = !toogleStatus;
272         }
273     }
274 
275     /**
276     * @dev Start the new game.`
277     */
278     function start() public onlyOwner() {
279         if (players[game].length > 0) {
280             pickTheWinner();
281         }
282         startGame();
283     }
284 
285     /**
286     * @dev Change ticket price on next game.
287     *
288     * @param price New ticket price.``
289     */    
290     function changeTicketPrice(uint price) 
291         public 
292         onlyOwner() 
293     {
294         newPrice = price;
295     }
296 
297 
298     /**
299     * @dev Get random number.
300     * @dev Random number calculation depends on block timestamp,
301     * @dev difficulty, number and hash.
302     *
303     * @param min Minimal number.
304     * @param max Maximum number.
305     * @param time Timestamp.
306     * @param difficulty Block difficulty.
307     * @param number Block number.
308     * @param bHash Block hash.
309     */
310     function randomNumber(
311         uint min,
312         uint max,
313         uint time,
314         uint difficulty,
315         uint number,
316         bytes32 bHash
317     ) 
318         public 
319         pure 
320         returns (uint) 
321     {
322         min ++;
323         max ++;
324 
325         uint random = uint(keccak256(
326             time * 
327             difficulty * 
328             number *
329             uint(bHash)
330         ))%10 + 1;
331        
332         uint result = uint(keccak256(random))%(min+max)-min;
333         
334         if (result > max) {
335             result = max;
336         }
337         
338         if (result < min) {
339             result = min;
340         }
341         
342         result--;
343 
344         return result;
345     }
346     
347     /**
348     * @dev The payable method that accepts ether and adds the player to the game.
349     */
350     function buyTicket(address partner) public payable {
351         require(isActive);
352         require(msg.value == ticketPrice);
353         
354         jackpot[game] += msg.value;
355         
356         uint playerNumber =  players[game].length;
357         players[game].push(msg.sender);
358 
359         processReferralSystem(partner, msg.sender);
360 
361         emit Ticket(msg.sender, game, playerNumber, now);
362     }
363 
364     /**
365     * @dev Start the new game.
366     * @dev Checks ticket price changes, if exists new ticket price the price will be changed.
367     * @dev Checks game status changes, if exists request for changing game status game status 
368     * @dev will be changed.
369     */
370     function startGame() internal {
371         require(isActive);
372 
373         game = block.number;
374         if (newPrice != 0) {
375             ticketPrice = newPrice;
376             newPrice = 0;
377         }
378         if (toogleStatus) {
379             isActive = !isActive;
380             toogleStatus = false;
381         }
382         emit Game(game, now);
383     }
384 
385     /**
386     * @dev Pick the winner.
387     * @dev Check game players, depends on player count provides next logic:
388     * @dev - if in the game is only one player, by game rules the whole jackpot 
389     * @dev without commission returns to him.
390     * @dev - if more than one player smart contract randomly selects one player, 
391     * @dev calculates commission and after that jackpot transfers to the winner,
392     * @dev commision to founders.
393     */
394     function pickTheWinner() internal {
395         uint winner;
396         uint toPlayer;
397         if (players[game].length == 1) {
398             toPlayer = jackpot[game];
399             players[game][0].transfer(jackpot[game]);
400             winner = 0;
401         } else {
402             winner = randomNumber(
403                 0,
404                 players[game].length - 1,
405                 block.timestamp,
406                 block.difficulty,
407                 block.number,
408                 blockhash(block.number - 1)
409             );
410         
411             uint distribute = jackpot[game] * fee / 100;
412             toPlayer = jackpot[game] - distribute;
413             players[game][winner].transfer(toPlayer);
414 
415             transferToPartner(players[game][winner]);
416             
417             distribute -= paidToPartners;
418             bool result = address(fundsDistributor).call.gas(30000).value(distribute)();
419             if (!result) {
420                 revert();
421             }
422         }
423     
424         paidToPartners = 0;
425         stats.newWinner(
426             players[game][winner],
427             game,
428             players[game].length,
429             toPlayer,
430             gType,
431             winner
432         );
433         
434         allTimeJackpot += toPlayer;
435         allTimePlayers += players[game].length;
436     }
437 
438     /**
439     * @dev Checks if the player is in referral system.
440     * @dev Sending earned ether to partners.
441     *
442     * @param partner Partner address.
443     * @param referral Player address.
444     */
445     function processReferralSystem(address partner, address referral) 
446         internal 
447     {
448         address partnerRef = referralInstance.getPartnerByReferral(referral);
449         if (partner != address(0) || partnerRef != address(0)) {
450             if (partnerRef == address(0)) {
451                 referralInstance.addReferral(partner, referral);
452                 partnerRef = partner;
453             }
454 
455             if (players[game].length > 1) {
456                 transferToPartner(referral);
457             }
458         }
459     }
460 
461     /**
462     * @dev Sending earned ether to partners.
463     *
464     * @param referral Player address.
465     */
466     function transferToPartner(address referral) internal {
467         address partner = referralInstance.getPartnerByReferral(referral);
468         if (partner != address(0)) {
469             uint sum = getPartnerAmount(partner);
470             if (sum != 0) {
471                 partner.transfer(sum);
472                 paidToPartners += sum;
473 
474                 emit ToPartner(partner, referral, sum, now);
475 
476                 transferToSalesPartner(partner);
477             }
478         }
479     }
480 
481     /**
482     * @dev Sending earned ether to sales partners.
483     *
484     * @param partner Partner address.
485     */
486     function transferToSalesPartner(address partner) internal {
487         address salesPartner = referralInstance.getSalesPartner(partner);
488         if (salesPartner != address(0)) {
489             uint sum = getSalesPartnerAmount(partner);
490             if (sum != 0) {
491                 salesPartner.transfer(sum);
492                 paidToPartners += sum;
493 
494                 emit ToSalesPartner(salesPartner, partner, sum, now);
495             } 
496         }
497     }
498 
499     /**
500     * @dev Getting partner percent and calculate earned ether.
501     *
502     * @param partner Partner address.
503     */
504     function getPartnerAmount(address partner) 
505         internal
506         view
507         returns (uint) 
508     {
509         uint8 partnerPercent = referralInstance.getPartnerPercent(partner);
510         if (partnerPercent == 0) {
511             return 0;
512         }
513 
514         return calculateReferral(partnerPercent);
515     }
516 
517     /**
518     * @dev Getting sales partner percent and calculate earned ether.
519     *
520     * @param partner sales partner address.
521     */
522     function getSalesPartnerAmount(address partner) 
523         internal 
524         view 
525         returns (uint)
526     {
527         uint8 salesPartnerPercent = referralInstance.getSalesPartnerPercent(partner);
528         if (salesPartnerPercent == 0) {
529             return 0;
530         }
531 
532         return calculateReferral(salesPartnerPercent);
533     }
534 
535     /**
536     * @dev Calculate earned ether by partner percent.
537     *
538     * @param percent Partner percent.
539     */
540     function calculateReferral(uint8 percent)
541         internal 
542         view 
543         returns (uint) 
544     {
545         uint distribute =  ticketPrice * fee / 100;
546 
547         return distribute * percent / 100;
548     }
549 }