1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * SmartLotto.in
6  *
7  * Fair lottery smart contract with random determination of winning tickets
8  *
9  *
10  * 1 ticket is jackpot winning ticket and get 10% of the contract balance
11  * 5 tickets are first prize winnings tickets and get 5% of the contract balance
12  * 10% of all tickets are second prize winners and get 35% of the contract balance
13  * all other tickets receive 50% refund of the ticket price
14  *
15  *
16  * 5% for referral program - use Add Data field and fill it with ETH-address of your upline when you buy tickets
17  *
18  *
19  * 1 ticket price is 0.1 ETH, you can buy 250 tickets per 1 transaction maximum (250 tickets = 25 ETH)
20  * You can make more transactions and purhase more tickets to increase your winning chances
21  *
22  * Use 200000 of gas limit when you buy tickets, check current gas price on https://ethgasstation.info
23  *
24  * Good luck!
25  *
26  */
27 
28 
29 contract SmartLotto {
30     using SafeMath for uint256;
31 
32     uint256 constant public TICKET_PRICE = 0.1 ether;        // price of 1 ticket is 0.1 ETH
33     uint256 constant public MAX_TICKETS_PER_TX = 250;        // max tickets amount per 1 transaction
34 
35     uint256 constant public JACKPOT_WINNER = 1;              // jackpot go to 1 ticket winners
36     uint256 constant public FIRST_PRIZE_WINNERS = 5;         // first prize go to 5 tickets winners
37     uint256 constant public SECOND_PRIZE_WINNERS_PERC = 10;  // percent of the second prize ticket winners
38 
39     uint256 constant public JACKPOT_PRIZE = 10;              // jackpot winner take 10% of balance
40     uint256 constant public FIRST_PRIZE_POOL = 5;            // first prize winners takes 5% of balance
41     uint256 constant public SECOND_PRIZE_POOL = 35;          // second prize winners takes 35% of balance
42 
43     uint256 constant public REFERRAL_COMMISSION = 5;         // referral commission 5% from input
44     uint256 constant public MARKETING_COMMISSION = 10;       // marketing commission 10% from input
45     uint256 constant public WINNINGS_COMMISSION = 20;        // winnings commission 20% from winnings
46 
47     uint256 constant public PERCENTS_DIVIDER = 100;          // percents divider, 100%
48 
49     uint256 constant public CLOSE_TICKET_SALES = 1546297200; // 23:00:00 31th of December 2018 GMT
50     uint256 constant public LOTTERY_DRAW_START = 1546300800; // 00:00:00 1th of January 2019 GMT
51     uint256 constant public PAYMENTS_END_TIME = 1554076800;  // 00:00:00 1th of April 2019 GMT
52 
53     uint256 public playersCount = 0;                         // participated players counter
54     uint256 public ticketsCount = 0;                         // buyed tickets counter
55 
56     uint256 public jackpotPrize = 0;                         // jackpot win amount per ticket
57     uint256 public firstPrize = 0;                           // first prize win amount per ticket
58     uint256 public secondPrize = 0;                          // second prize win amount per ticket
59     uint256 public secondPrizeWonTickets = 0;                // second prize win tickets amount
60     uint256 public wonTicketsAmount = 0;                     // total amount of won tickets
61     uint256 public participantsMoneyPool = 0;                // money pool returned to participants
62     uint256 public participantsTicketPrize = 0;              // amount returned per 1 ticket
63 
64     uint256 public ticketsCalculated = 0;                    // won tickets calculated counter
65 
66     uint256 public salt = 0;                                 // salt for random generator
67 
68     bool public calculationsDone;                            // flag true when all calculations finished
69 
70     address constant public MARKETING_ADDRESS = 0xFD527958E10C546f8b484135CC51fa9f0d3A8C5f;
71     address constant public COMMISSION_ADDRESS = 0x53434676E12A4eE34a4eC7CaBEBE9320e8b836e1;
72 
73 
74     struct Player {
75         uint256 ticketsCount;
76         uint256[] ticketsPacksBuyed;
77         uint256 winnings;
78         uint256 wonTicketsCount;
79         uint256 payed;
80     }
81 
82     struct TicketsBuy {
83         address player;
84         uint256 ticketsAmount;
85     }
86 
87 	struct TicketsWon {
88 		uint256 won;
89     }
90 
91     mapping (address => Player) public players;
92     mapping (uint256 => TicketsBuy) public ticketsBuys;
93 	mapping (uint256 => TicketsWon) public ticketsWons;
94 
95 
96     function() public payable {
97         if (msg.value >= TICKET_PRICE) {
98             buyTickets();
99         } else {
100             if (!calculationsDone) {
101                 makeCalculations(50);
102             } else {
103                 payPlayers();
104             }
105         }
106     }
107 
108 
109     function buyTickets() private {
110         // require time now less than or equal to 23:00:00 31th of December 2018 GMT
111         require(now <= CLOSE_TICKET_SALES);
112 
113         // save msg.value
114         uint256 msgValue = msg.value;
115 
116         // load player msg.sender
117         Player storage player = players[msg.sender];
118 
119         // if new player add to total players stats
120         if (player.ticketsCount == 0) {
121             playersCount++;
122         }
123 
124         // count amount of tickets which can be bought
125         uint256 ticketsAmount = msgValue.div(TICKET_PRICE);
126 
127         // if tickets more than MAX_TICKETS_PER_TX (250 tickets)
128         if (ticketsAmount > MAX_TICKETS_PER_TX) {
129             // use MAX_TICKETS_PER_TX (250 tickets)
130             ticketsAmount = MAX_TICKETS_PER_TX;
131         }
132 
133 		// count overpayed amount by player
134 		uint256 overPayed = msgValue.sub(ticketsAmount.mul(TICKET_PRICE));
135 
136 		// if player overpayed
137 		if (overPayed > 0) {
138 			// update msgValue for futher calculations
139 			msgValue = msgValue.sub(overPayed);
140 
141 			// send to player overpayed amount
142 			msg.sender.send(overPayed);
143 		}
144 
145         // add bought tickets pack to array with id of current tickets amount
146         player.ticketsPacksBuyed.push(ticketsCount);
147 
148         // create new TicketsBuy record
149         // creating only one record per MAX_TICKETS_PER_TX (250 tickets)
150         // to avoid high gas usage when players buy tickets
151         ticketsBuys[ticketsCount] = TicketsBuy({
152             player : msg.sender,
153             ticketsAmount : ticketsAmount
154         });
155 
156 		// add bought tickets to player stats
157         player.ticketsCount = player.ticketsCount.add(ticketsAmount);
158         // update bought tickets counter
159         ticketsCount = ticketsCount.add(ticketsAmount);
160 
161         // try get ref address from tx data
162         address referrerAddress = bytesToAddress(msg.data);
163 
164         // if ref address not 0 and not msg.sender
165         if (referrerAddress != address(0) && referrerAddress != msg.sender) {
166             // count ref amount
167             uint256 referralAmount = msgValue.mul(REFERRAL_COMMISSION).div(PERCENTS_DIVIDER);
168             // send ref amount
169             referrerAddress.send(referralAmount);
170         }
171 
172         // count marketing amount
173         uint256 marketingAmount = msgValue.mul(MARKETING_COMMISSION).div(PERCENTS_DIVIDER);
174         // send marketing amount
175         MARKETING_ADDRESS.send(marketingAmount);
176     }
177 
178     function makeCalculations(uint256 count) public {
179         // require calculations not done
180         require(!calculationsDone);
181         // require time now more than or equal to 00:00:00 1st of January 2019 GMT
182         require(now >= LOTTERY_DRAW_START);
183 
184         // if salt not counted
185         if (salt == 0) {
186             // create random salt which depends on blockhash, count of tickets and count of players
187             salt = uint256(keccak256(abi.encodePacked(ticketsCount, uint256(blockhash(block.number-1)), playersCount)));
188 
189             // get actual contract balance
190             uint256 contractBalance = address(this).balance;
191 
192             // count and save jackpot win amount per ticket
193             jackpotPrize = contractBalance.mul(JACKPOT_PRIZE).div(PERCENTS_DIVIDER).div(JACKPOT_WINNER);
194             // count and save first prize win amount per ticket
195             firstPrize = contractBalance.mul(FIRST_PRIZE_POOL).div(PERCENTS_DIVIDER).div(FIRST_PRIZE_WINNERS);
196 
197             // count and save second prize win tickets amount
198             secondPrizeWonTickets = ticketsCount.mul(SECOND_PRIZE_WINNERS_PERC).div(PERCENTS_DIVIDER);
199             // count and save second prize win amount per ticket
200             secondPrize = contractBalance.mul(SECOND_PRIZE_POOL).div(PERCENTS_DIVIDER).div(secondPrizeWonTickets);
201 
202             // count and save how many tickets won
203             wonTicketsAmount = secondPrizeWonTickets.add(JACKPOT_WINNER).add(FIRST_PRIZE_WINNERS);
204 
205             // count and save money pool returned to participants
206             participantsMoneyPool = contractBalance.mul(PERCENTS_DIVIDER.sub(JACKPOT_PRIZE).sub(FIRST_PRIZE_POOL).sub(SECOND_PRIZE_POOL)).div(PERCENTS_DIVIDER);
207             // count and save participants prize per ticket
208             participantsTicketPrize = participantsMoneyPool.div(ticketsCount.sub(wonTicketsAmount));
209 
210             // proceed jackpot prize ticket winnings
211             calculateWonTickets(JACKPOT_WINNER, jackpotPrize);
212             // proceed first prize tickets winnings
213             calculateWonTickets(FIRST_PRIZE_WINNERS, firstPrize);
214 
215             // update calculated tickets counter
216             ticketsCalculated = ticketsCalculated.add(JACKPOT_WINNER).add(FIRST_PRIZE_WINNERS);
217         // if salt already counted
218         } else {
219             // if calculations of second prize winners not yet finished
220             if (ticketsCalculated < wonTicketsAmount) {
221                 // how many tickets not yet calculated
222                 uint256 ticketsForCalculation = wonTicketsAmount.sub(ticketsCalculated);
223 
224                 // if count zero and tickets for calculations more than 50
225                 // than calculate 50 tickets to avoid gas cost more than block limit
226                 if (count == 0 && ticketsForCalculation > 50) {
227                     ticketsForCalculation = 50;
228                 }
229 
230                 // if count more than zero and count less than amount of not calculated tickets
231                 // than use count as amount of tickets for calculations
232                 if (count > 0 && count <= ticketsForCalculation) {
233                     ticketsForCalculation = count;
234                 }
235 
236                 // proceed second prize ticket winnings
237                 calculateWonTickets(ticketsForCalculation, secondPrize);
238 
239                 // update calculated tickets counter
240                 ticketsCalculated = ticketsCalculated.add(ticketsForCalculation);
241             }
242 
243             // if calculations of second prize winners finished set calculations done
244             if (ticketsCalculated == wonTicketsAmount) {
245                 calculationsDone = true;
246             }
247         }
248     }
249 
250     function calculateWonTickets(uint256 numbers, uint256 prize) private {
251         // for all numbers in var make calculations
252         for (uint256 n = 0; n < numbers; n++) {
253             // get random generated won ticket number
254             uint256 wonTicketNumber = random(n);
255 
256 			// if ticket already won
257 			if (ticketsWons[wonTicketNumber].won == 1) {
258 				// than add 1 ticket to numbers
259 				numbers = numbers.add(1);
260 			// ticket not won yet
261 			} else {
262 				// mark ticket as won
263 				ticketsWons[wonTicketNumber].won = 1;
264 
265 				// search player record to add ticket winnings
266 				for (uint256 i = 0; i < MAX_TICKETS_PER_TX; i++) {
267 					// search max MAX_TICKETS_PER_TX (250 tickets)
268 					uint256 wonTicketIdSearch = wonTicketNumber - i;
269 
270 					// if player record found
271 					if (ticketsBuys[wonTicketIdSearch].ticketsAmount > 0) {
272 						// read player from storage
273 						Player storage player = players[ticketsBuys[wonTicketIdSearch].player];
274 
275 						// add ticket prize amount to player winnings
276 						player.winnings = player.winnings.add(prize);
277 						// update user won tickets counter
278 						player.wonTicketsCount++;
279 
280 						// player found so stop searching
281 						break;
282 					}
283 				}
284 			}
285         }
286 
287         // update salt and add numbers amount
288         salt = salt.add(numbers);
289     }
290 
291     function payPlayers() private {
292         // require calculations are done
293         require(calculationsDone);
294 
295         // pay players if time now less than 00:00:00 1st of April 2019 GMT
296         if (now <= PAYMENTS_END_TIME) {
297             // read player record
298             Player storage player = players[msg.sender];
299 
300             // if player have won tickets and not yet payed
301             if (player.winnings > 0 && player.payed == 0) {
302                 // count winnings commission from player won amount
303                 uint256 winCommission = player.winnings.mul(WINNINGS_COMMISSION).div(PERCENTS_DIVIDER);
304 
305                 // count amount of not won tickets
306                 uint256 notWonTickets = player.ticketsCount.sub(player.wonTicketsCount);
307                 // count return amount for not won tickets
308                 uint256 notWonAmount = notWonTickets.mul(participantsTicketPrize);
309 
310                 // update player payed winnings
311                 player.payed = player.winnings.add(notWonAmount);
312 
313                 // send total winnings amount to player
314                 msg.sender.send(player.winnings.sub(winCommission).add(notWonAmount).add(msg.value));
315 
316                 // send commission
317                 COMMISSION_ADDRESS.send(winCommission);
318             }
319 
320             // if player have not won tickets and not yet payed
321             if (player.winnings == 0 && player.payed == 0) {
322                 // count return amount for not won tickets
323                 uint256 returnAmount = player.ticketsCount.mul(participantsTicketPrize);
324 
325                 // update player payed winnings
326                 player.payed = returnAmount;
327 
328                 // send total winnings amount to player
329                 msg.sender.send(returnAmount.add(msg.value));
330             }
331         // if payment period already ended
332         } else {
333             // get actual contract balance
334             uint256 contractBalance = address(this).balance;
335 
336             // actual contract balance more than zero
337             if (contractBalance > 0) {
338                 // send contract balance to commission address
339                 COMMISSION_ADDRESS.send(contractBalance);
340             }
341         }
342     }
343 
344     function random(uint256 nonce) private view returns (uint256) {
345         // random number generated from salt plus nonce divided by total amount of tickets
346         uint256 number = uint256(keccak256(abi.encodePacked(salt.add(nonce)))).mod(ticketsCount);
347         return number;
348     }
349 
350     function playerBuyedTicketsPacks(address player) public view returns (uint256[]) {
351         return players[player].ticketsPacksBuyed;
352     }
353 
354     function bytesToAddress(bytes data) private pure returns (address addr) {
355         assembly {
356             addr := mload(add(data, 0x14))
357         }
358     }
359 }
360 
361 
362 /**
363  * @title SafeMath
364  * @dev Math operations with safety checks that revert on error
365  */
366 library SafeMath {
367     /**
368     * @dev Multiplies two numbers, reverts on overflow.
369     */
370     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
371         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
372         // benefit is lost if 'b' is also tested.
373         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
374         if (a == 0) {
375             return 0;
376         }
377 
378         uint256 c = a * b;
379         require(c / a == b);
380 
381         return c;
382     }
383 
384     /**
385     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
386     */
387     function div(uint256 a, uint256 b) internal pure returns (uint256) {
388         // Solidity only automatically asserts when dividing by 0
389         require(b > 0);
390         uint256 c = a / b;
391         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
392 
393         return c;
394     }
395 
396     /**
397     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
398     */
399     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
400         require(b <= a);
401         uint256 c = a - b;
402 
403         return c;
404     }
405 
406     /**
407     * @dev Adds two numbers, reverts on overflow.
408     */
409     function add(uint256 a, uint256 b) internal pure returns (uint256) {
410         uint256 c = a + b;
411         require(c >= a);
412 
413         return c;
414     }
415 
416     /**
417     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
418     * reverts when dividing by zero.
419     */
420     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
421         require(b != 0);
422         return a % b;
423     }
424 }