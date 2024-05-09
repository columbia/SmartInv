1 contract ShinySquirrels {
2 
3 // all the things
4 uint private minDeposit = 10 finney;
5 uint private maxDeposit = 5 ether;
6 uint private baseFee = 5;
7 uint private baseMultiplier = 100;
8 uint private maxMultiplier = 160;
9 uint private currentPosition = 0;
10 uint private balance = 0;
11 uint private feeBalance = 0;
12 uint private totalDeposits = 0;
13 uint private totalPaid = 0;
14 uint private totalSquirrels = 0;
15 uint private totalShinyThings = 0;
16 uint private totalSprockets = 0;
17 uint private totalStars = 0;
18 uint private totalHearts = 0;
19 uint private totalSkips = 0;
20 address private owner = msg.sender;
21  
22 struct PlayerEntry {
23     address addr;
24     uint deposit;
25     uint paid;
26     uint multiplier;
27     uint fee;
28     uint skip;
29     uint squirrels;
30     uint shinyThings;
31     uint sprockets;
32     uint stars;
33     uint hearts;
34 }
35  
36 struct PlayerStat {
37     address addr;
38     uint entries;
39     uint deposits;
40     uint paid;
41     uint skips;
42     uint squirrels;
43     uint shinyThings;
44     uint sprockets;
45     uint stars;
46     uint hearts;
47 }
48 
49 // player entries in the order received
50 PlayerEntry[] private players;
51 
52 // The Line of players, keeping track as new players cut in...
53 uint[] theLine;
54 
55 // individual player totals
56 mapping(address => PlayerStat) private playerStats;
57 
58 // Shiny new contract, no copy & paste here!
59 function ShinySquirrels() {
60     owner = msg.sender;
61 }
62  
63 function totals() constant returns(uint playerCount, uint currentPlaceInLine, uint playersWaiting, uint totalDepositsInFinneys, uint totalPaidOutInFinneys, uint squirrelFriends, uint shinyThingsFound, uint sprocketsCollected, uint starsWon, uint heartsEarned, uint balanceInFinneys, uint feeBalanceInFinneys) {
64     playerCount             = players.length;
65     currentPlaceInLine      = currentPosition;
66     playersWaiting          = waitingForPayout();
67     totalDepositsInFinneys  = totalDeposits / 1 finney;
68     totalPaidOutInFinneys   = totalPaid / 1 finney;
69     squirrelFriends         = totalSquirrels;
70     shinyThingsFound        = totalShinyThings;
71     sprocketsCollected      = totalSprockets;
72     starsWon                = totalStars;
73     heartsEarned            = totalHearts;
74     balanceInFinneys        = balance / 1 finney;
75     feeBalanceInFinneys     = feeBalance / 1 finney;
76 }
77 
78 function settings() constant returns(uint minimumDepositInFinneys, uint maximumDepositInFinneys) {
79     minimumDepositInFinneys = minDeposit / 1 finney;
80     maximumDepositInFinneys = maxDeposit / 1 finney;
81 }
82 
83 function playerByAddress(address addr) constant returns(uint entries, uint depositedInFinney, uint paidOutInFinney, uint skippedAhead, uint squirrels, uint shinyThings, uint sprockets, uint stars, uint hearts) {
84     entries          = playerStats[addr].entries;
85     depositedInFinney = playerStats[addr].deposits / 1 finney;
86     paidOutInFinney  = playerStats[addr].paid / 1 finney;
87     skippedAhead     = playerStats[addr].skips;
88     squirrels        = playerStats[addr].squirrels;
89     shinyThings      = playerStats[addr].shinyThings;
90     sprockets        = playerStats[addr].sprockets;
91     stars            = playerStats[addr].stars;
92     hearts           = playerStats[addr].hearts;
93 }
94 
95 // current number of players still waiting for their payout
96 function waitingForPayout() constant private returns(uint waiting) {
97     waiting = players.length - currentPosition;
98 }
99 
100 // the total payout this entry in line will receive
101 function entryPayout(uint index) constant private returns(uint payout) {
102     payout = players[theLine[index]].deposit * players[theLine[index]].multiplier / 100;
103 }
104 
105 // the payout amount still due to this entry in line
106 function entryPayoutDue(uint index) constant private returns(uint payoutDue) {
107     // subtract the amount they've been paid from the total they are to receive
108     payoutDue = entryPayout(index) - players[theLine[index]].paid;
109 }
110  
111 // public interface to the line of players
112 function lineOfPlayers(uint index) constant returns (address addr, uint orderJoined, uint depositInFinney, uint payoutInFinney, uint multiplierPercent, uint paid, uint skippedAhead, uint squirrels, uint shinyThings, uint sprockets, uint stars, uint hearts) {
113     PlayerEntry player = players[theLine[index]];
114     addr              = player.addr;
115     orderJoined       = theLine[index];
116     depositInFinney   = player.deposit / 1 finney;
117     payoutInFinney    = depositInFinney * player.multiplier / 100;
118     multiplierPercent = player.multiplier;
119     paid              = player.paid / 1 finney;
120     skippedAhead      = player.skip;
121     squirrels         = player.squirrels;
122     shinyThings       = player.shinyThings;
123     sprockets         = player.sprockets;
124     stars             = player.stars;
125     hearts            = player.hearts;
126 }
127 
128 function () {
129     play();
130 }
131  
132 function play() {
133     uint deposit = msg.value; // in wei
134      
135     // validate deposit is in range
136     if(deposit < minDeposit || deposit > maxDeposit) {
137         msg.sender.send(deposit);
138         return;
139     }
140      
141     uint multiplier  = baseMultiplier; // percent
142     uint fee         = baseFee; // percent
143     uint skip        = 0;
144     uint squirrels   = 0;
145     uint shinyThings = 0;
146     uint sprockets   = 0;
147     uint stars       = 0;
148     uint hearts      = 0;
149      
150     if(players.length % 5 == 0) {
151         multiplier += 2;
152         fee        += 1;
153         stars      += 1;
154          
155         if(deposit < 1 ether) {
156             multiplier  -= multiplier >= 7 ? 7 : multiplier;
157             fee         -= fee        >= 1 ? 1 : 0;
158             shinyThings += 1;
159         }
160         if(deposit >= 1 && waitingForPayout() >= 10) {
161             // at least 10 players waiting
162             skip += 4;
163             fee  += 3;
164         }
165         if(deposit >= 2 ether && deposit <= 3 ether) {
166             multiplier += 3;
167             fee        += 2;
168             hearts     += 1;
169         }
170         if(deposit >= 3 ether) {
171             stars += 1;
172         }
173 
174     } else if (players.length % 5 == 1) {
175         multiplier += 4;
176         fee        += 2;
177         squirrels  += 1;
178 
179         if(deposit < 1 ether) {
180             multiplier += 6;
181             fee        += 3;
182             squirrels  += 1;
183         }
184         if(deposit >= 2 ether) {
185             if(waitingForPayout() >= 20) {
186                 // at least 20 players waiting
187                 skip        += waitingForPayout() / 2; // skip half of them
188                 fee         += 2;
189                 shinyThings += 1;
190             } 
191 
192             multiplier += 4;
193             fee        += 4;
194             hearts     += 1;
195         }
196         if(deposit >= 4 ether) {
197             multiplier += 1;
198             fee       -= fee >= 1 ? 1 : 0;
199             skip      += 1;
200             hearts    += 1;
201             stars     += 1;
202         }
203 
204     } else if (players.length % 5 == 2) {
205         multiplier += 7;
206         fee        += 6;
207         sprockets  += 1;
208          
209         if(waitingForPayout() >= 10) {
210             // at least 10 players waiting
211             multiplier -= multiplier >= 8 ? 8 : multiplier;
212             fee        -= fee >= 1 ? 1 : 0;
213             skip       += 1;
214             squirrels  += 1;
215         }
216         if(deposit >= 3 ether) {
217             multiplier  += 2;
218             skip        += 1;
219             stars       += 1;
220             shinyThings += 1;
221         }
222         if(deposit == maxDeposit) {
223             multiplier += 2;
224             skip       += 1;
225             hearts     += 1;
226             squirrels  += 1;
227         }
228      
229     } else if (players.length % 5 == 3) {
230         multiplier  -= multiplier >= 5 ? 5 : multiplier; // on noes!
231         fee         += 0;
232         skip        += 3; // oh yay!
233         shinyThings += 1;
234          
235         if(deposit < 1 ether) {
236             multiplier -= multiplier >= 5 ? 5 : multiplier;
237             fee        += 2;
238             skip       += 5;
239             squirrels  += 1;
240         }
241         if(deposit == 1 ether) {
242             multiplier += 10;
243             fee        += 4;
244             skip       += 2;
245             hearts     += 1;
246         }
247         if(deposit == maxDeposit) {
248             multiplier += 1;
249             fee       += 5;
250             skip      += 1;
251             sprockets += 1;
252             stars     += 1;
253             hearts    += 1;
254         }
255      
256     } else if (players.length % 5 == 4) {
257         multiplier += 2;
258         fee        -= fee >= 1 ? 1 : fee;
259         squirrels  += 1;
260          
261         if(deposit < 1 ether) {
262             multiplier += 3;
263             fee        += 2;
264             skip       += 3;
265         }
266         if(deposit >= 2 ether) {
267             multiplier += 2;
268             fee        += 2;
269             skip       += 1;
270             stars      += 1;
271         }
272         if(deposit == maxDeposit/2) {
273             multiplier  += 2;
274             fee         += 5;
275             skip        += 3;
276             shinyThings += 1;
277             sprockets   += 1;
278         }
279         if(deposit >= 3 ether) {
280             multiplier += 1;
281             fee        += 1;
282             skip       += 1;
283             sprockets  += 1;
284             hearts     += 1;
285         }
286     }
287 
288     // track the accumulated bonus goodies!
289     playerStats[msg.sender].hearts      += hearts;
290     playerStats[msg.sender].stars       += stars;
291     playerStats[msg.sender].squirrels   += squirrels;
292     playerStats[msg.sender].shinyThings += shinyThings;
293     playerStats[msg.sender].sprockets   += sprockets;
294     
295     // track cummulative awarded goodies
296     totalHearts      += hearts;
297     totalStars       += stars;
298     totalSquirrels   += squirrels;
299     totalShinyThings += shinyThings;
300     totalSprockets   += sprockets;
301 
302     // got squirrels? skip in front of that many players!
303     skip += playerStats[msg.sender].squirrels;
304      
305     // one squirrel ran away!
306     playerStats[msg.sender].squirrels -= playerStats[msg.sender].squirrels >= 1 ? 1 : 0;
307      
308     // got stars? 2% multiplier bonus for every star!
309     multiplier += playerStats[msg.sender].stars * 2;
310      
311     // got hearts? -2% fee for every heart!
312     fee -= playerStats[msg.sender].hearts;
313      
314     // got sprockets? 1% multiplier bonus and -1% fee for every sprocket!
315     multiplier += playerStats[msg.sender].sprockets;
316     fee        -= fee > playerStats[msg.sender].sprockets ? playerStats[msg.sender].sprockets : fee;
317      
318     // got shiny things? skip 1 more player and -1% fee!
319     if(playerStats[msg.sender].shinyThings >= 1) {
320         skip += 1;
321         fee  -= fee >= 1 ? 1 : 0;
322     }
323      
324     // got a heart, star, squirrel, shiny thin, and sprocket?!? 50% bonus multiplier!!!
325     if(playerStats[msg.sender].hearts >= 1 && playerStats[msg.sender].stars >= 1 && playerStats[msg.sender].squirrels >= 1 && playerStats[msg.sender].shinyThings >= 1 && playerStats[msg.sender].sprockets >= 1) {
326         multiplier += 30;
327     }
328      
329     // got a heart and a star? trade them for +20% multiplier!!!
330     if(playerStats[msg.sender].hearts >= 1 && playerStats[msg.sender].stars >= 1) {
331         multiplier                     += 15;
332         playerStats[msg.sender].hearts -= 1;
333         playerStats[msg.sender].stars  -= 1;
334     }
335      
336     // got a sprocket and a shiny thing? trade them for 5 squirrels!
337     if(playerStats[msg.sender].sprockets >= 1 && playerStats[msg.sender].shinyThings >= 1) {
338         playerStats[msg.sender].squirrels   += 5;
339         playerStats[msg.sender].sprockets   -= 1;
340         playerStats[msg.sender].shinyThings -= 1;
341     }
342 
343     // stay within profitable and safe limits
344     if(multiplier > maxMultiplier) {
345         multiplier == maxMultiplier;
346     }
347     
348     // keep power players in check so regular players can still win some too
349     if(waitingForPayout() > 15 && skip > waitingForPayout()/2) {
350         // limit skip to half of waiting players
351         skip = waitingForPayout() / 2;
352     }
353 
354     // ledgers within ledgers     
355     feeBalance += deposit * fee / 100;
356     balance    += deposit - deposit * fee / 100;
357     totalDeposits += deposit;
358 
359     // prepare players array for a new entry    
360     uint playerIndex = players.length;
361     players.length += 1;
362 
363     // make room in The Line for one more
364     uint lineIndex = theLine.length;
365     theLine.length += 1;
366 
367     // skip ahead if you should be so lucky!
368     (skip, lineIndex) = skipInLine(skip, lineIndex);
369 
370     // record the players entry
371     players[playerIndex].addr        = msg.sender;
372     players[playerIndex].deposit     = deposit;
373     players[playerIndex].multiplier  = multiplier;
374     players[playerIndex].fee         = fee;
375     players[playerIndex].squirrels   = squirrels;
376     players[playerIndex].shinyThings = shinyThings;
377     players[playerIndex].sprockets   = sprockets;
378     players[playerIndex].stars       = stars;
379     players[playerIndex].hearts      = hearts;
380     players[playerIndex].skip        = skip;
381     
382     // add the player to The Line at whatever position they snuck in at    
383     theLine[lineIndex] = playerIndex;
384 
385     // track players cumulative stats
386     playerStats[msg.sender].entries  += 1;
387     playerStats[msg.sender].deposits += deposit;
388     playerStats[msg.sender].skips    += skip;
389     
390     // track total game skips
391     totalSkips += skip;
392     
393     // issue payouts while the balance allows
394     // rolling payouts occur as long as the balance is above zero
395     uint nextPayout = entryPayoutDue(currentPosition);
396     uint payout;
397     while(balance > 0) {
398         if(nextPayout <= balance) {
399             // the balance is great enough to pay the entire next balance due
400             // pay the balance due
401             payout = nextPayout;
402         } else {
403             // the balance is above zero, but less than the next balance due
404             // send them everything available
405             payout = balance;
406         }
407         // issue the payment
408         players[theLine[currentPosition]].addr.send(payout);
409         // mark the amount paid
410         players[theLine[currentPosition]].paid += payout;
411         // keep a global tally
412         playerStats[players[theLine[currentPosition]].addr].paid += payout;
413         balance    -= payout;
414         totalPaid  += payout;
415         // move to the next position in line if the last entry got paid out completely
416         if(balance > 0) {
417             currentPosition++;
418             nextPayout = entryPayoutDue(currentPosition);
419         }
420     }
421 }
422  
423 // jump in line, moving entries back towards the end one at a time
424 // presumes the line length has already been increased to accomodate the newcomer
425 // return the the number of positions skipped and the index of the vacant position in line
426 function skipInLine(uint skip, uint currentLineIndex) private returns (uint skipped, uint newLineIndex) {
427     // check for at least 1 player in line plus this new entry
428     if(skip > 0 && waitingForPayout() > 2) {
429         // -2 because we don't want to count the new empty slot at the end of the list
430         if(skip > waitingForPayout()-2) {
431             skip = waitingForPayout()-2;
432         }
433 
434         // move entries forward one by one
435         uint i = 0;
436         while(i < skip) {
437             theLine[currentLineIndex-i] = theLine[currentLineIndex-1-i];
438             i++;
439         }
440         
441         // don't leave a duplicate copy of the last entry processed
442         delete(theLine[currentLineIndex-i]);
443         
444         // the newly vacant position is i slots from the end
445         newLineIndex = currentLineIndex-i;
446     } else {
447         // no change
448         newLineIndex = currentLineIndex;
449         skip = 0;
450     }
451     skipped = skip;
452 }
453 
454 function DynamicPyramid() {
455     // Rubixi god-code, j/k :-P
456     playerStats[msg.sender].squirrels    = 0;
457     playerStats[msg.sender].shinyThings  = 0;
458     playerStats[msg.sender].sprockets    = 0;
459     playerStats[msg.sender].stars        = 0;
460     playerStats[msg.sender].hearts       = 0;
461 }
462  
463 function collectFees() {
464     if(msg.sender != owner) {
465         throw;
466     }
467     // game balance will always be zero due to automatic rolling payouts
468     if(address(this).balance > balance + feeBalance) {
469         // collect any funds outside of the game balance
470         feeBalance = address(this).balance - balance;
471     }
472     owner.send(feeBalance);
473     feeBalance = 0;
474 }
475 
476 function updateSettings(uint newMultiplier, uint newMaxMultiplier, uint newFee, uint newMinDeposit, uint newMaxDeposit, bool collect) {
477     // adjust the base settings within a small and limited range as the game matures and ether prices change
478     if(msg.sender != owner) throw;
479     if(newMultiplier < 80 || newMultiplier > 120) throw;
480     if(maxMultiplier < 125 || maxMultiplier > 200) throw;
481     if(newFee < 0 || newFee > 15) throw;
482     if(minDeposit < 1 finney || minDeposit > 1 ether) throw;
483     if(maxDeposit < 1 finney || maxDeposit > 25 ether) throw;
484     if(collect) collectFees();
485     baseMultiplier = newMultiplier;
486     maxMultiplier = newMaxMultiplier;
487     baseFee = newFee;
488     minDeposit = newMinDeposit;
489     maxDeposit = newMaxDeposit;
490 }
491 
492 
493 }