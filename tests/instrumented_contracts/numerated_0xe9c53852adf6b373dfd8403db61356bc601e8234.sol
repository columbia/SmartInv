1 pragma solidity 0.4.24;
2 
3 // _____________________________________________________________
4 //                  .''
5 //        ._.-.___.' (`\
6 //       //(        ( `'
7 //      '/ )\ ).__. )
8 //      ' <' `\ ._/'\
9 // ________`___\_____\__________________________________________
10 //                                            .''
11 //     ___ _____ _ __ ___  ___      ._.-.___.' (`\
12 //    / _//_  _//// // _/ / o |    //(        ( `'
13 //   / _/  / / / ` // _/ /  ,'    '/ )\ ).__. )
14 //  /___/ /_/ /_n_//___//_/`_\    ' <' `\ ._/'\
15 // __________________________________`___\_____\________________
16 //                                                    .''
17 //     __   ___  ___   ___  _  __           ._.-.___.' (`\
18 //    /  \ / _/ / o | / o.)| |/,'          //(        ( `'
19 //   / o |/ _/ /  ,' / o \ | ,'           '/ )\ ).__. )
20 //  /__,'/___//_/`_\/___,'/_/             ' <' `\ ._/'\
21 // __________________________________________`___\_____\________
22 //                            .''
23 //                  ._.-.___.' (`\
24 //                 //(        ( `'
25 //                '/ )\ ).__. )
26 //                ' <' `\ ._/'\
27 // __________________`___\_____\________________________________
28 //
29 // This product is protected under license.  Any unauthorized copy, modification, or use without 
30 // express written consent from the creators is prohibited.
31 //
32 contract EtherDerby {
33     using SafeMath for *;
34     using CalcCarrots for uint256;
35 
36     // settings
37     string constant public name = "EtherDerby";
38     uint256 constant private ROUNDMAX = 4 hours;
39     uint256 constant private MULTIPLIER = 2**64;
40     uint256 constant private DECIMALS = 18;
41     uint256 constant public REGISTERFEE = 20 finney;
42 
43     address constant private DEVADDR = 0xC17A40cB38598520bd7C0D5BFF97D441A810a008;
44 
45     // horse Identifiers
46     uint8 constant private H1 = 1;
47     uint8 constant private H2 = 2;
48     uint8 constant private H3 = 3;
49     uint8 constant private H4 = 4;
50 
51     //  ___  _ _  ___   __   _  ___  _
52     // |_ _|| U || __| |  \ / \|_ _|/ \
53     //  | | |   || _|  | o ) o || || o |
54     //  |_| |_n_||___| |__/|_n_||_||_n_|
55     //
56 
57     struct Round {
58         uint8 winner; // horse in the lead
59         mapping (uint8 => uint256) eth; // total eth per horse
60         mapping (uint8 => uint256) carrots; // total eth per horse
61     }
62 
63     struct Player {
64         address addr; // player address
65         bytes32 name; // player name
66         uint256 totalWinnings; // player winnings
67         uint256 totalReferrals; // player referral bonuses
68         int256  dividendPayouts; // running count of payouts player has received (important that it can be negative)
69 
70         mapping (uint256 => mapping (uint8 => uint256)) eth; // round -> horse -> eTH invested
71         mapping (uint256 => mapping (uint8 => uint256)) carrots; // round -> horse -> carrots purchased
72         mapping (uint256 => mapping (uint8 => uint256)) referrals; // round -> horse -> referrals (eth)
73 
74         mapping (uint8 => uint256) totalEth; // total carrots invested in each horse by the player
75         mapping (uint8 => uint256) totalCarrots; // total carrots invested in each horse by the player
76 
77         uint256 totalWithdrawn; // running total of ETH withdrawn by the player
78         uint256 totalReinvested; // running total of ETH reinvested by the player
79 
80         uint256 roundLastManaged; // round players winnings were last recorded
81         uint256 roundLastReferred; // round player was last referred and therefore had its referrals managed
82         address lastRef; // address of player who last referred this player
83     }
84 
85     struct Horse {
86         bytes32 name;
87         uint256 totalEth;
88         uint256 totalCarrots;
89         uint256 mostCarrotsOwned;
90         address owner;
91     }
92 
93     uint256 rID_ = 0; // current round number
94     mapping (uint256 => Round) public rounds_; // data for each round
95     uint256 roundEnds_; // time current round is over
96     mapping (address => Player) public players_; // data for each player
97     mapping (uint8 => Horse) horses_; // data for each horse
98     uint256 private earningsPerCarrot_; // used to keep track of dividends rewarded to carrot holders
99 
100     mapping (bytes32 => address) registeredNames_;
101 
102     //  ___  _ _  ___  _  _  ___ __
103     // | __|| | || __|| \| ||_ _/ _|
104     // | _| | V || _| | \\ | | |\_ \
105     // |___| \_/ |___||_|\_| |_||__/
106     //
107 
108     /**
109      * @dev fired for every set of carrots purchased or reinvested in
110      * @param playerAddress player making the purchase
111      * @param playerName players name if they have registered
112      * @param roundId round for which carrots were purchased
113      * @param horse array of two horses (stack limit hit so we use array)
114      *   0 - horse which horse carrots were purchased for
115      *   1 - horse now in the lead
116      * @param horseName horse name at the time of purchase
117      * @param roundEnds round end time
118      * @param timestamp block timestamp when purchase occurred
119      * @param data contains the following (stack limit hit so we use array)
120      *   0 - amount of eth
121      *   1 - amount of carrots
122      *   2 - horses total eth for the round
123      *   3 - horses total carrots for the round
124      *   4 - players total eth for the round
125      *   5 - players total carrots for the round
126      */
127     event OnCarrotsPurchased
128     (
129         address indexed playerAddress,
130         bytes32 playerName,
131         uint256 roundId,
132         uint8[2] horse,
133         bytes32 indexed horseName,
134         uint256[6] data,
135         uint256 roundEnds,
136         uint256 timestamp
137     );
138 
139     /**
140      * @dev fired each time a player withdraws ETH
141      * @param playerAddress players address
142      * @param eth amount withdrawn
143      */
144     event OnEthWithdrawn
145     (
146         address indexed playerAddress,
147         uint256 eth
148     );
149 
150     /**
151      * @dev fired whenever a horse is given a new name
152      * @param playerAddress which player named the horse
153      * @param horse number of horse being named
154      * @param horseName new name of horse
155      * @param mostCarrotsOwned number of carrots by owned to name the horse
156      * @param timestamp block timestamp when horse is named
157      */
158     event OnHorseNamed
159     (
160       address playerAddress,
161       bytes32 playerName,
162       uint8 horse,
163       bytes32 horseName,
164       uint256 mostCarrotsOwned,
165       uint256 timestamp
166     );
167 
168     /**
169      * @dev fired whenever a player registers a name
170      * @param playerAddress which player registered a name
171      * @param playerName name being registered
172      * @param ethDonated amount of eth donated with registration
173      * @param timestamp block timestamp when name registered
174      */
175     event OnNameRegistered
176     (
177         address playerAddress,
178         bytes32 playerName,
179         uint256 ethDonated,
180         uint256 timestamp
181     );
182 
183     /**
184      * @dev fired when a transaction is rejected
185      * mainly used to make it easier to write front end code
186      * @param playerAddress player making the purchase
187      * @param reason why the transaction failed
188      */
189     event OnTransactionFail
190     (
191         address indexed playerAddress,
192         bytes32 reason
193     );
194 
195     constructor()
196       public
197     {
198         // start with Round 0 ending before now so that first purchase begins Round 1
199         // subtract an hour to make sure the first purchase doesn't go to round 0 (ex. same block)
200         roundEnds_ = block.timestamp - 1 hours;
201 
202         // default horse names
203         horses_[H1].name = "horse1";
204         horses_[H2].name = "horse2";
205         horses_[H3].name = "horse3";
206         horses_[H4].name = "horse4";
207     }
208 
209     //  _   _  _  __  _  ___  _  ___  ___  __
210     // | \_/ |/ \|  \| || __|| || __|| o \/ _|
211     // | \_/ ( o ) o ) || _| | || _| |   /\_ \
212     // |_| |_|\_/|__/|_||_|  |_||___||_|\\|__/
213     //
214 
215     /**
216      * @dev verifies that a valid horse is provided
217      */
218     modifier isValidHorse(uint8 _horse) {
219         require(_horse == H1 || _horse == H2 || _horse == H3 || _horse == H4, "unknown horse selected");
220         _;
221     }
222 
223     /**
224      * @dev prevents smart contracts from interacting with EtherDerby
225      */
226     modifier isHuman() {
227         address addr = msg.sender;
228         uint256 codeLength;
229 
230         assembly {codeLength := extcodesize(addr)}
231         require(codeLength == 0, "Humans only ;)");
232         require(msg.sender == tx.origin, "Humans only ;)");
233         _;
234     }
235 
236     /**
237      * @dev verifies that all purchases sent include a reasonable amount of ETH
238      */
239     modifier isWithinLimits(uint256 _eth) {
240         require(_eth >= 1000000000, "Not enough eth!");
241         require(_eth <= 100000000000000000000000, "Go away whale!");
242         _;
243     }
244 
245 
246     //  ___ _ _  ___ _    _  __   ___  _ _  _  _  __  ___  _  _  _  _  __
247     // | o \ | || o ) |  | |/ _| | __|| | || \| |/ _||_ _|| |/ \| \| |/ _|
248     // |  _/ U || o \ |_ | ( (_  | _| | U || \\ ( (_  | | | ( o ) \\ |\_ \
249     // |_| |___||___/___||_|\__| |_|  |___||_|\_|\__| |_| |_|\_/|_|\_||__/
250     //
251 
252     /**
253      * @dev register a name with Ether Derby to generate a referral link
254      * @param _nameStr the name being registered (see NameValidator library below
255      * for name requirements)
256      */
257     function registerName(string _nameStr)
258         public
259         payable
260         isHuman()
261     {
262         require(msg.value >= REGISTERFEE, "You must pay the partner fee of 20 finney");
263 
264         bytes32 nameToRegister = NameValidator.validate(_nameStr);
265 
266         require(registeredNames_[nameToRegister] == 0, "Name already in use");
267 
268         registeredNames_[nameToRegister] = msg.sender;
269         players_[msg.sender].name = nameToRegister;
270 
271         // partner fee goes to devs
272         players_[DEVADDR].totalReferrals = msg.value.add(players_[DEVADDR].totalReferrals);
273 
274         emit OnNameRegistered(msg.sender, nameToRegister, msg.value, block.timestamp);
275     }
276 
277     /**
278      * @dev buy carrots with ETH
279      * @param _horse the horse carrots are being purchased for
280      * @param _round the round these carrots should be purchased for (send 0 to
281      * buy for whatever the current round is)
282      * @param _referrerName the player for which to reward referral bonuses to
283      */
284     function buyCarrots(uint8 _horse, uint256 _round, bytes32 _referrerName)
285         public
286         payable
287         isHuman()
288         isWithinLimits(msg.value)
289         isValidHorse(_horse)
290     {
291         if (isInvalidRound(_round)) {
292             emit OnTransactionFail(msg.sender, "Invalid round");
293             msg.sender.transfer(msg.value);
294             return;
295         }
296         buyCarrotsInternal(_horse, msg.value, _referrerName);
297     }
298 
299     /**
300      * @dev buy carrots with current earnings left in smart contract
301      * @param _horse the horse carrots are being purchased for
302      * @param _round the round these carrots should be purchased for (send 0 to
303      * buy for whatever the current round is)
304      * @param _referrerName the player for which to reward referral bonuses to
305      */
306     function reinvestInCarrots(uint8 _horse, uint256 _round, uint256 _value, bytes32 _referrerName)
307         public
308         isHuman()
309         isWithinLimits(_value)
310         isValidHorse(_horse)
311     {
312         if (isInvalidRound(_round)) {
313             emit OnTransactionFail(msg.sender, "Invalid round");
314             return;
315         }
316         if (calcPlayerEarnings() < _value) {
317             // Not enough earnings in player vault
318             emit OnTransactionFail(msg.sender, "Insufficient funds");
319             return;
320         }
321         players_[msg.sender].totalReinvested = _value.add(players_[msg.sender].totalReinvested);
322 
323         buyCarrotsInternal(_horse, _value, _referrerName);
324     }
325 
326     /**
327      * @dev name horse by purchasing enough carrots to become majority holder
328      * @param _horse the horse being named
329      * @param _nameStr the desired horse name (See NameValidator for requirements)
330      * @param _referrerName the player for which to reward referral bonuses to
331      */
332     function nameHorse(uint8 _horse, string _nameStr, bytes32 _referrerName)
333       public
334       payable
335       isHuman()
336       isValidHorse(_horse)
337     {
338         if ((rounds_[getCurrentRound()].eth[_horse])
339             .carrotsReceived(msg.value)
340             .add(players_[msg.sender].totalCarrots[_horse]) < 
341                 horses_[_horse].mostCarrotsOwned) {
342             emit OnTransactionFail(msg.sender, "Insufficient funds");
343             if (msg.value > 0) {
344                 msg.sender.transfer(msg.value);
345             }
346             return;
347         }
348         if (msg.value > 0) {
349             buyCarrotsInternal(_horse, msg.value, _referrerName);    
350         }
351         horses_[_horse].name = NameValidator.validate(_nameStr);
352         if (horses_[_horse].owner != msg.sender) {
353             horses_[_horse].owner = msg.sender;
354         }
355         emit OnHorseNamed(
356             msg.sender,
357             players_[msg.sender].name,
358             _horse,
359             horses_[_horse].name,
360             horses_[_horse].mostCarrotsOwned,
361             block.timestamp
362         );
363     }
364 
365     /**
366      * @dev withdraw all earnings made so far. includes winnings, dividends, and referrals
367      */
368     function withdrawEarnings()
369         public
370         isHuman()
371     {
372         managePlayer();
373         manageReferrer(msg.sender);
374 
375         uint256 earnings = calcPlayerEarnings();
376         if (earnings > 0) {
377             players_[msg.sender].totalWithdrawn = earnings.add(players_[msg.sender].totalWithdrawn);
378             msg.sender.transfer(earnings);
379         }
380         emit OnEthWithdrawn(msg.sender, earnings);
381     }
382 
383     /**
384      * @dev fallback function puts incoming eth into devs referrals
385      */
386     function()
387         public
388         payable
389     {
390         players_[DEVADDR].totalReferrals = msg.value.add(players_[DEVADDR].totalReferrals);
391     }
392 
393     //  ___ ___ _  _ _   _  ___  ___   _ _  ___  _    ___ ___  ___  __
394     // | o \ o \ || | | / \|_ _|| __| | U || __|| |  | o \ __|| o \/ _|
395     // |  _/   / || V || o || | | _|  |   || _| | |_ |  _/ _| |   /\_ \
396     // |_| |_|\\_| \_/ |_n_||_| |___| |_n_||___||___||_| |___||_|\\|__/
397     //
398 
399     /**
400      * @dev core helper method for purchasing carrots
401      * @param _horse the horse carrots are being purchased for
402      * @param _value amount of eth to spend on carrots
403      * @param _referrerName the player for which to reward referral bonuses to
404      */
405     function buyCarrotsInternal(uint8 _horse, uint256 _value, bytes32 _referrerName)
406         private
407     {
408         // check if new round needs started and update horses pending data if necessary
409         manageRound();
410 
411         // update players winnings and reset pending data if necessary
412         managePlayer();
413 
414         address referrer = getReferrer(_referrerName);
415         // update referrers total referrals and reset pending referrals if necessary
416         manageReferrer(referrer);
417         if (referrer != DEVADDR) {
418             // also manage dev account unless referrer is dev
419             manageReferrer(DEVADDR);
420         }
421 
422         uint256 carrots = (rounds_[rID_].eth[_horse]).carrotsReceived(_value);
423 
424         /*******************/
425         /*  Update Player  */
426         /*******************/
427 
428         players_[msg.sender].eth[rID_][_horse] = 
429             _value.add(players_[msg.sender].eth[rID_][_horse]);
430         players_[msg.sender].carrots[rID_][_horse] = 
431             carrots.add(players_[msg.sender].carrots[rID_][_horse]);
432         players_[msg.sender].totalEth[_horse] =
433             _value.add(players_[msg.sender].totalEth[_horse]);
434         players_[msg.sender].totalCarrots[_horse] =
435             carrots.add(players_[msg.sender].totalCarrots[_horse]);
436 
437         // players don't recieve dividends before buying the carrots
438         players_[msg.sender].dividendPayouts += SafeConversions.SafeSigned(earningsPerCarrot_.mul(carrots));
439 
440         /*******************/
441         /* Update Referrer */
442         /*******************/
443 
444         players_[referrer].referrals[rID_][_horse] = 
445             ninePercent(_value).add(players_[referrer].referrals[rID_][_horse]);
446         // one percent to devs
447         // reuse referrals since functionality is the same
448         players_[DEVADDR].referrals[rID_][_horse] =
449             _value.div(100).add(players_[DEVADDR].referrals[rID_][_horse]);
450 
451         // check if players new amount of total carrots for this horse is greater than mostCarrotsOwned and update
452         if (players_[msg.sender].totalCarrots[_horse] > horses_[_horse].mostCarrotsOwned) {
453           horses_[_horse].mostCarrotsOwned = players_[msg.sender].totalCarrots[_horse];
454         }
455 
456         /*******************/
457         /*  Update  Round  */
458         /*******************/
459 
460         rounds_[rID_].eth[_horse] = _value.add(rounds_[rID_].eth[_horse]);
461         rounds_[rID_].carrots[_horse] = carrots.add(rounds_[rID_].carrots[_horse]);
462 
463         // if this horses carrots now exceeds current winner, update current winner
464         if (rounds_[rID_].winner != _horse &&
465             rounds_[rID_].carrots[_horse] > rounds_[rID_].carrots[rounds_[rID_].winner]) {
466             rounds_[rID_].winner = _horse;
467         }
468 
469         /*******************/
470         /*  Update  Horse  */
471         /*******************/
472 
473         horses_[_horse].totalCarrots = carrots.add(horses_[_horse].totalCarrots);
474         horses_[_horse].totalEth = _value.add(horses_[_horse].totalEth);
475 
476         emit OnCarrotsPurchased(
477             msg.sender,
478             players_[msg.sender].name,
479             rID_,
480             [
481                 _horse,
482                 rounds_[rID_].winner
483             ],
484             horses_[_horse].name,
485             [
486                 _value,
487                 carrots,
488                 rounds_[rID_].eth[_horse],
489                 rounds_[rID_].carrots[_horse],
490                 players_[msg.sender].eth[rID_][_horse],
491                 players_[msg.sender].carrots[rID_][_horse]
492             ],
493             roundEnds_,
494             block.timestamp
495         );
496     }
497 
498     /**
499      * @dev check if now is past current rounds ends time. if so, compute round
500      * details and update all storage to start the next round
501      */
502     function manageRound()
503       private
504     {
505         if (!isRoundOver()) {
506             return;
507         }
508         // round over, update dividends and start next round
509         uint256 earningsPerCarrotThisRound = fromEthToDivies(calcRoundLosingHorsesEth(rID_));
510 
511         if (earningsPerCarrotThisRound > 0) {
512             earningsPerCarrot_ = earningsPerCarrot_.add(earningsPerCarrotThisRound);  
513         }
514 
515         rID_++;
516         roundEnds_ = block.timestamp + ROUNDMAX;
517     }
518 
519     /**
520      * @dev check if a player has winnings from a previous round that have yet to
521      * be recorded. this needs to be called before any player interacts with Ether
522      * Derby to make sure there data is kept up to date
523      */
524     function managePlayer()
525         private
526     {
527         uint256 unrecordedWinnings = calcUnrecordedWinnings();
528         if (unrecordedWinnings > 0) {
529             players_[msg.sender].totalWinnings = unrecordedWinnings.add(players_[msg.sender].totalWinnings);
530         }
531         // if managePlayer is being called while round is over, calcUnrecordedWinnings will include
532         // winnings from the current round. it's important that we store rID_+1 here to make sure
533         // users can't double withdraw winnings from current round
534         if (players_[msg.sender].roundLastManaged == rID_ && isRoundOver()) {
535             players_[msg.sender].roundLastManaged = rID_.add(1);
536         }
537         else if (players_[msg.sender].roundLastManaged < rID_) {
538             players_[msg.sender].roundLastManaged = rID_;
539         }
540     }
541 
542     /**
543      * @dev check if a player has referral bonuses from a previous round that have yet 
544      * to be recorded
545      */
546     function manageReferrer(address _referrer)
547         private
548     {
549         uint256 unrecordedRefferals = calcUnrecordedRefferals(_referrer);
550         if (unrecordedRefferals > 0) {
551             players_[_referrer].totalReferrals =
552                 unrecordedRefferals.add(players_[_referrer].totalReferrals);
553         }
554 
555         if (players_[_referrer].roundLastReferred == rID_ && isRoundOver()) {
556             players_[_referrer].roundLastReferred = rID_.add(1);
557         }
558         else if (players_[_referrer].roundLastReferred < rID_) {
559             players_[_referrer].roundLastReferred = rID_;
560         }
561     }
562 
563     /**
564      * @dev calculate total amount of carrots that have been purchased
565      */
566     function calcTotalCarrots()
567         private
568         view
569         returns (uint256)
570     {
571         return horses_[H1].totalCarrots
572             .add(horses_[H2].totalCarrots)
573             .add(horses_[H3].totalCarrots)
574             .add(horses_[H4].totalCarrots);
575     }
576 
577     /**
578      * @dev calculate players total amount of carrots including the unrecorded
579      */
580     function calcPlayerTotalCarrots()
581         private
582         view
583         returns (uint256)
584     {
585         return players_[msg.sender].totalCarrots[H1]
586             .add(players_[msg.sender].totalCarrots[H2])
587             .add(players_[msg.sender].totalCarrots[H3])
588             .add(players_[msg.sender].totalCarrots[H4]);
589     }
590 
591     /**
592      * @dev calculate players total amount of eth spent including unrecorded
593      */
594     function calcPlayerTotalEth()
595         private
596         view
597         returns (uint256)
598     {
599         return players_[msg.sender].totalEth[H1]
600             .add(players_[msg.sender].totalEth[H2])
601             .add(players_[msg.sender].totalEth[H3])
602             .add(players_[msg.sender].totalEth[H4]);
603     }
604 
605     /**
606      * @dev calculate players total earnings (able to be withdrawn)
607      */
608     function calcPlayerEarnings()
609         private
610         view
611         returns (uint256)
612     {
613         return calcPlayerWinnings()
614             .add(calcPlayerDividends())
615             .add(calcPlayerReferrals())
616             .sub(players_[msg.sender].totalWithdrawn)
617             .sub(players_[msg.sender].totalReinvested);
618     }
619 
620     /**
621      * @dev calculate players total winning including the unrecorded
622      */
623     function calcPlayerWinnings()
624         private
625         view
626         returns (uint256)
627     {
628         return players_[msg.sender].totalWinnings.add(calcUnrecordedWinnings());
629     }
630 
631     /**
632      * @dev calculate players total dividends including the unrecorded
633      */
634     function calcPlayerDividends()
635       private
636       view
637       returns (uint256)
638     {
639         uint256 unrecordedDividends = calcUnrecordedDividends();
640         uint256 carrotBalance = calcPlayerTotalCarrots();
641         int256 totalDividends = SafeConversions.SafeSigned(carrotBalance.mul(earningsPerCarrot_).add(unrecordedDividends));
642         return SafeConversions.SafeUnsigned(totalDividends - players_[msg.sender].dividendPayouts).div(MULTIPLIER);
643     }
644 
645     /**
646      * @dev calculate players total referral bonus including the unrecorded
647      */
648     function calcPlayerReferrals()
649         private
650         view
651         returns (uint256)
652     {
653         return players_[msg.sender].totalReferrals.add(calcUnrecordedRefferals(msg.sender));
654     }
655 
656     /**
657      * @dev calculate players unrecorded winnings (those not yet in Player.totalWinnings)
658      */
659     function calcUnrecordedWinnings()
660         private
661         view
662         returns (uint256)
663     {
664         uint256 round = players_[msg.sender].roundLastManaged;
665         if ((round == 0) || (round > rID_) || (round == rID_ && !isRoundOver())) {
666             // all winnings have been recorded
667             return 0;
668         }
669         // round is <= rID_, not 0, and if equal then round is over
670         // (players eth spent on the winning horse during their last round) +
671         // ((players carrots for winning horse during their last round) * 
672         // (80% of losing horses eth)) / total carrots purchased for winning horse
673         return players_[msg.sender].eth[round][rounds_[round].winner]
674             .add((players_[msg.sender].carrots[round][rounds_[round].winner]
675             .mul(eightyPercent(calcRoundLosingHorsesEth(round))))
676             .div(rounds_[round].carrots[rounds_[round].winner]));
677     }
678 
679     /**
680      * @dev calculate players unrecorded dividends (those not yet reflected in earningsPerCarrot_)
681      */
682     function calcUnrecordedDividends()
683         private
684         view
685         returns (uint256)
686     {
687         if (!isRoundOver()) {
688             // round is not over
689             return 0;
690         }
691         // round has ended but next round has not yet been started, so
692         // dividends from the current round are reflected in earningsPerCarrot_
693         return fromEthToDivies(calcRoundLosingHorsesEth(rID_)).mul(calcPlayerTotalCarrots());
694     }
695 
696     /**
697      * @dev calculate players unrecorded referral bonus (those not yet in Player.referrals)
698      */
699     function calcUnrecordedRefferals(address _player)
700         private
701         view
702         returns (uint256 ret)
703     {
704         uint256 round = players_[_player].roundLastReferred;
705         if (!((round == 0) || (round > rID_) || (round == rID_ && !isRoundOver()))) {
706             for (uint8 i = H1; i <= H4; i++) {
707                 if (rounds_[round].winner != i) {
708                     ret = ret.add(players_[_player].referrals[round][i]);
709                 }
710             }
711         }
712     }
713 
714     /**
715      * @dev calculate total eth from all horses except the winner
716      */
717     function calcRoundLosingHorsesEth(uint256 _round)
718         private
719         view
720         returns (uint256 ret)
721     {
722         for (uint8 i = H1; i <= H4; i++) {
723             if (rounds_[_round].winner != i) {
724                 ret = ret.add(rounds_[_round].eth[i]);
725             }
726         }
727     }
728 
729     /**
730      * @dev calculate the change in earningsPerCarrot_ based on new eth coming in
731      * @param _value amount of ETH being sent out as dividends to all carrot holders
732      */
733     function fromEthToDivies(uint256 _value)
734         private
735         view
736         returns (uint256)
737     {
738         // edge case where dividing by 0 would happen
739         uint256 totalCarrots = calcTotalCarrots();
740         if (totalCarrots == 0) {
741             return 0;
742         }
743         // multiply by MULTIPLIER to prevent integer division from returning 0
744         // when totalCarrots > losingHorsesEth
745         // divide by 10 because only 10% of losing horses ETH goes to dividends
746         return _value.mul(MULTIPLIER).div(10).div(totalCarrots);
747     }
748 
749     /**
750      * @dev convert registered name to an address
751      * @param _referrerName name of player that referred current player
752      * @return address of referrer if valid, or last person to refer the current player,
753      * or the devs as a backup referrer
754      */
755     function getReferrer(bytes32 _referrerName)
756         private
757         returns (address)
758     {
759         address referrer;
760         // referrer is not empty, unregistered, or same as buyer
761         if (_referrerName != "" && registeredNames_[_referrerName] != 0 && _referrerName != players_[msg.sender].name) {
762             referrer = registeredNames_[_referrerName];
763         } else if (players_[msg.sender].lastRef != 0) {
764             referrer = players_[msg.sender].lastRef;
765         } else {
766             // fallback to Devs if no referrer provided
767             referrer = DEVADDR;
768         }
769         if (players_[msg.sender].lastRef != referrer) {
770             // store last referred to allow partner to continue receiving
771             // future purchases from this player
772             players_[msg.sender].lastRef = referrer;
773         }
774         return referrer;
775     }
776 
777     /**
778      * @dev calculate price of buying carrots
779      * @param _horse which horse to calculate price for
780      * @param _carrots how many carrots desired
781      * @return ETH required to purchase X many carrots (in large format)
782      */
783     function calculateCurrentPrice(uint8 _horse, uint256 _carrots)
784         private
785         view
786         returns(uint256)
787     {
788         uint256 currTotal = 0;
789         if (!isRoundOver()) {
790             // Round is ongoing
791             currTotal = rounds_[rID_].carrots[_horse];
792         }
793         return currTotal.add(_carrots).ethReceived(_carrots);
794     }
795 
796     /**
797      * @dev check if a round number is valid to make a purchase for
798      * @param _round round to check
799      * @return true if _round is current (or next if current is over)
800      */
801     function isInvalidRound(uint256 _round)
802         private
803         view
804         returns(bool)
805     {
806         // passing _round as 0 means buy for current round
807         return _round != 0 && _round != getCurrentRound();
808     }
809 
810     /**
811      * @dev get current round
812      */
813     function getCurrentRound()
814         private
815         view
816         returns(uint256)
817     {
818         if (isRoundOver()) {
819             return (rID_ + 1);
820         }
821         return rID_;
822     }
823 
824     /**
825      * @dev check if current round has ended based on current block timestamp
826      * @return true if round is over, false otherwise
827      */
828     function isRoundOver()
829         private
830         view
831         returns (bool)
832     {
833         return block.timestamp >= roundEnds_;
834     }
835 
836     /**
837      * @dev compute eighty percent as whats left after subtracting 10%, 1% and 9%
838      * @param num_ number to compute 80% of
839      */
840     function eightyPercent(uint256 num_)
841         private
842         pure
843         returns (uint256)
844     {
845         // 100% - 9% - 1% - 10% = 80%
846         return num_.sub(ninePercent(num_)).sub(num_.div(100)).sub(num_.div(10));
847     }
848 
849     /**
850      * @dev compute eighty percent as whats left after subtracting 10% twice
851      * @param num_ number to compute 80% of
852      */
853     function ninePercent(uint256 num_)
854         private
855         pure
856         returns (uint256)
857     {
858         return num_.mul(9).div(100);
859     }
860 
861     //  _____ _____  ___  ___ _  _   _   _     _ _  _   _   _  ___  ___  _ _  _  __  __
862     // | __\ V /_ _|| __|| o \ \| | / \ | |   | | || | | \_/ || __||_ _|| U |/ \|  \/ _|
863     // | _| ) ( | | | _| |   / \\ || o || |_  | U || | | \_/ || _|  | | |   ( o ) o )_ \
864     // |___/_n_\|_| |___||_|\\_|\_||_n_||___| |___||_| |_| |_||___| |_| |_n_|\_/|__/|__/
865     //
866 
867     /**
868      * @dev get stats from current round (or the last round if new has not yet started)
869      * @return round id
870      * @return round end time
871      * @return horse in the lead
872      * @return eth for each horse
873      * @return carrots for each horse
874      * @return eth invested for each horse
875      * @return carrots invested for each horse
876      * @return horse names
877      */
878     function getRoundStats()
879         public
880         view
881         returns(uint256, uint256, uint8, uint256[4], uint256[4], uint256[4], uint256[4], bytes32[4])
882     {
883         return
884         (
885             rID_,
886             roundEnds_,
887             rounds_[rID_].winner,
888             [
889                 rounds_[rID_].eth[H1],
890                 rounds_[rID_].eth[H2],
891                 rounds_[rID_].eth[H3],
892                 rounds_[rID_].eth[H4]
893             ],
894             [
895                 rounds_[rID_].carrots[H1],
896                 rounds_[rID_].carrots[H2],
897                 rounds_[rID_].carrots[H3],
898                 rounds_[rID_].carrots[H4]
899             ],
900             [
901                 players_[msg.sender].eth[rID_][H1],
902                 players_[msg.sender].eth[rID_][H2],
903                 players_[msg.sender].eth[rID_][H3],
904                 players_[msg.sender].eth[rID_][H4]
905             ],
906             [
907                 players_[msg.sender].carrots[rID_][H1],
908                 players_[msg.sender].carrots[rID_][H2],
909                 players_[msg.sender].carrots[rID_][H3],
910                 players_[msg.sender].carrots[rID_][H4]
911             ],
912             [
913                 horses_[H1].name,
914                 horses_[H2].name,
915                 horses_[H3].name,
916                 horses_[H4].name
917             ]
918         );
919     }
920 
921     /**
922      * @dev get minimal details about a specific round (returns all 0s if round not over)
923      * @param _round which round to query
924      * @return horse that won
925      * @return eth for each horse
926      * @return carrots for each horse
927      * @return eth invested for each horse
928      * @return carrots invested for each horse
929      */
930     function getPastRoundStats(uint256 _round) 
931         public
932         view
933         returns(uint8, uint256[4], uint256[4], uint256[4], uint256[4])
934     {
935         if ((_round == 0) || (_round > rID_) || (_round == rID_ && !isRoundOver())) {
936             return;
937         }
938         return
939         (
940             rounds_[rID_].winner,
941             [
942                 rounds_[_round].eth[H1],
943                 rounds_[_round].eth[H2],
944                 rounds_[_round].eth[H3],
945                 rounds_[_round].eth[H4]
946             ],
947             [
948                 rounds_[_round].carrots[H1],
949                 rounds_[_round].carrots[H2],
950                 rounds_[_round].carrots[H3],
951                 rounds_[_round].carrots[H4]
952             ],
953             [
954                 players_[msg.sender].eth[_round][H1],
955                 players_[msg.sender].eth[_round][H2],
956                 players_[msg.sender].eth[_round][H3],
957                 players_[msg.sender].eth[_round][H4]
958             ],
959             [
960                 players_[msg.sender].carrots[_round][H1],
961                 players_[msg.sender].carrots[_round][H2],
962                 players_[msg.sender].carrots[_round][H3],
963                 players_[msg.sender].carrots[_round][H4]
964             ]
965         );
966     }
967 
968     /**
969      * @dev get stats for player
970      * @return total winnings
971      * @return total dividends
972      * @return total referral bonus
973      * @return total reinvested
974      * @return total withdrawn
975      */
976     function getPlayerStats()
977         public 
978         view
979         returns(uint256, uint256, uint256, uint256, uint256)
980     {
981         return
982         (
983             calcPlayerWinnings(),
984             calcPlayerDividends(),
985             calcPlayerReferrals(),
986             players_[msg.sender].totalReinvested,
987             players_[msg.sender].totalWithdrawn
988         );
989     }
990 
991     /**
992      * @dev get name of player
993      * @return players registered name if there is one
994      */
995     function getPlayerName()
996       public
997       view
998       returns(bytes32)
999     {
1000         return players_[msg.sender].name;
1001     }
1002 
1003     /**
1004      * @dev check if name is available
1005      * @param _name name to check
1006      * @return bool whether or not it is available
1007      */
1008     function isNameAvailable(bytes32 _name)
1009       public
1010       view
1011       returns(bool)
1012     {
1013         return registeredNames_[_name] == 0;
1014     }
1015 
1016     /**
1017      * @dev get overall stats for EtherDerby
1018      * @return total eth for each horse
1019      * @return total carrots for each horse
1020      * @return player total eth for each horse
1021      * @return player total carrots for each horse
1022      * @return horse names
1023      */
1024     function getStats()
1025         public
1026         view
1027         returns(uint256[4], uint256[4], uint256[4], uint256[4], bytes32[4])
1028     {
1029         return
1030         (
1031             [
1032                 horses_[H1].totalEth,
1033                 horses_[H2].totalEth,
1034                 horses_[H3].totalEth,
1035                 horses_[H4].totalEth
1036             ],
1037             [
1038                 horses_[H1].totalCarrots,
1039                 horses_[H2].totalCarrots,
1040                 horses_[H3].totalCarrots,
1041                 horses_[H4].totalCarrots
1042             ],
1043             [
1044                 players_[msg.sender].totalEth[H1],
1045                 players_[msg.sender].totalEth[H2],
1046                 players_[msg.sender].totalEth[H3],
1047                 players_[msg.sender].totalEth[H4]
1048             ],
1049             [
1050                 players_[msg.sender].totalCarrots[H1],
1051                 players_[msg.sender].totalCarrots[H2],
1052                 players_[msg.sender].totalCarrots[H3],
1053                 players_[msg.sender].totalCarrots[H4]
1054             ],
1055             [
1056                 horses_[H1].name,
1057                 horses_[H2].name,
1058                 horses_[H3].name,
1059                 horses_[H4].name
1060             ]
1061         );
1062     }
1063 
1064     /**
1065      * @dev returns data for past 50 rounds
1066      * @param roundStart which round to start returning data at (0 means current)
1067      * @return round number this index in the arrays corresponds to
1068      * @return winning horses for past 50 finished rounds
1069      * @return horse1 carrot amounts for past 50 rounds
1070      * @return horse2 carrot amounts for past 50 rounds
1071      * @return horse3 carrot amounts for past 50 rounds
1072      * @return horse4 carrot amounts for past 50 rounds
1073      * @return horse1 players carrots for past 50 rounds
1074      * @return horse2 players carrots for past 50 rounds
1075      * @return horse3 players carrots for past 50 rounds
1076      * @return horse4 players carrots for past 50 rounds
1077      * @return horseEth total eth amounts for past 50 rounds
1078      * @return playerEth total player eth amounts for past 50 rounds
1079      */
1080     function getPastRounds(uint256 roundStart)
1081         public
1082         view
1083         returns(
1084             uint256[50] roundNums,
1085             uint8[50] winners,
1086             uint256[50] horse1Carrots,
1087             uint256[50] horse2Carrots,
1088             uint256[50] horse3Carrots,
1089             uint256[50] horse4Carrots,
1090             uint256[50] horse1PlayerCarrots,
1091             uint256[50] horse2PlayerCarrots,
1092             uint256[50] horse3PlayerCarrots,
1093             uint256[50] horse4PlayerCarrots,
1094             uint256[50] horseEth,
1095             uint256[50] playerEth
1096         )
1097     {
1098         uint256 index = 0;
1099         uint256 round = rID_;
1100         if (roundStart != 0 && roundStart <= rID_) {
1101             round = roundStart;
1102         }
1103         while (index < 50 && round > 0) {
1104             if (round == rID_ && !isRoundOver()) {
1105                 round--;
1106                 continue;
1107             }
1108             roundNums[index] = round;
1109             winners[index] = rounds_[round].winner;
1110             horse1Carrots[index] = rounds_[round].carrots[H1];
1111             horse2Carrots[index] = rounds_[round].carrots[H2];
1112             horse3Carrots[index] = rounds_[round].carrots[H3];
1113             horse4Carrots[index] = rounds_[round].carrots[H4];
1114             horse1PlayerCarrots[index] = players_[msg.sender].carrots[round][H1];
1115             horse2PlayerCarrots[index] = players_[msg.sender].carrots[round][H2];
1116             horse3PlayerCarrots[index] = players_[msg.sender].carrots[round][H3];
1117             horse4PlayerCarrots[index] = players_[msg.sender].carrots[round][H4];
1118             horseEth[index] = rounds_[round].eth[H1]
1119                 .add(rounds_[round].eth[H2])
1120                 .add(rounds_[round].eth[H3])
1121                 .add(rounds_[round].eth[H4]);
1122             playerEth[index] = players_[msg.sender].eth[round][H1]
1123                 .add(players_[msg.sender].eth[round][H2])
1124                 .add(players_[msg.sender].eth[round][H3])
1125                 .add(players_[msg.sender].eth[round][H4]);
1126             index++;
1127             round--;
1128         }
1129     }
1130 
1131     /**
1132      * @dev calculate price of buying carrots for a specific horse
1133      * @param _horse which horse to calculate price for
1134      * @param _carrots how many carrots desired
1135      * @return ETH required to purchase X many carrots
1136      */
1137     function getPriceOfXCarrots(uint8 _horse, uint256 _carrots)
1138         public
1139         view
1140         isValidHorse(_horse)
1141         returns(uint256)
1142     {
1143         return calculateCurrentPrice(_horse, _carrots.mul(1000000000000000000));
1144     }
1145 
1146     /**
1147      * @dev calculate price to become majority carrot holder for a specific horse
1148      * @param _horse which horse to calculate price for
1149      * @return carrotsRequired
1150      * @return ethRequired
1151      * @return currentMax
1152      * @return owner
1153      * @return ownerName
1154      */
1155     function getPriceToName(uint8 _horse)
1156         public
1157         view
1158         isValidHorse(_horse)
1159         returns(
1160             uint256 carrotsRequired,
1161             uint256 ethRequired,
1162             uint256 currentMax,
1163             address owner,
1164             bytes32 ownerName
1165         )
1166     {
1167         if (players_[msg.sender].totalCarrots[_horse] < horses_[_horse].mostCarrotsOwned) {
1168             // player is not already majority holder
1169             // Have user buy one carrot more than current max
1170             carrotsRequired = horses_[_horse].mostCarrotsOwned.sub(players_[msg.sender].totalCarrots[_horse]).add(10**DECIMALS);
1171             ethRequired = calculateCurrentPrice(_horse, carrotsRequired);
1172         }
1173         currentMax = horses_[_horse].mostCarrotsOwned;
1174         owner = horses_[_horse].owner;
1175         ownerName = players_[horses_[_horse].owner].name;
1176     }
1177 }
1178 
1179 
1180 //   __   _   ___ ___  _ ___    __   _   _   __  _ _  _     _  ___ _  ___
1181 //  / _| / \ | o \ o \/ \_ _|  / _| / \ | | / _|| | || |   / \|_ _/ \| o \
1182 // ( (_ | o ||   /   ( o ) |  ( (_ | o || |( (_ | U || |_ | o || ( o )   /
1183 //  \__||_n_||_|\\_|\\\_/|_|   \__||_n_||___\__||___||___||_n_||_|\_/|_|\\
1184 //
1185 library CalcCarrots {
1186     using SafeMath for *;
1187 
1188     /**
1189      * @dev calculates number of carrots recieved given X eth
1190      */
1191     function carrotsReceived(uint256 _currEth, uint256 _newEth)
1192         internal
1193         pure
1194         returns (uint256)
1195     {
1196         return carrots((_currEth).add(_newEth)).sub(carrots(_currEth));
1197     }
1198 
1199     /**
1200      * @dev calculates amount of eth received if you sold X carrots
1201      */
1202     function ethReceived(uint256 _currCarrots, uint256 _sellCarrots)
1203         internal
1204         pure
1205         returns (uint256)
1206     {
1207         return eth(_currCarrots).sub(eth(_currCarrots.sub(_sellCarrots)));
1208     }
1209 
1210     /**
1211      * @dev calculates how many carrots for a single horse given an amount
1212      * of eth spent on that horse
1213      */
1214     function carrots(uint256 _eth)
1215         internal
1216         pure
1217         returns (uint256)
1218     {
1219         return ((((_eth).mul(62831853072000000000000000000000000000000000000)
1220             .add(9996858654086510028837239824000000000000000000000000000000000000)).sqrt())
1221             .sub(99984292036732000000000000000000)) / (31415926536);
1222     }
1223 
1224     /**
1225      * @dev calculates how much eth would be in the contract for a single
1226      * horse given an amount of carrots bought for that horse
1227      */
1228     function eth(uint256 _carrots)
1229         internal
1230         pure
1231         returns (uint256)
1232     {
1233         return ((15707963268).mul(_carrots.mul(_carrots)).add(((199968584073464)
1234             .mul(_carrots.mul(1000000000000000000))) / (2))) / (1000000000000000000000000000000000000);
1235     }
1236 }
1237 
1238 
1239 //  __  _   ___  ___   _   _   _  ___  _ _
1240 // / _|/ \ | __|| __| | \_/ | / \|_ _|| U |
1241 // \_ \ o || _| | _|  | \_/ || o || | |   |
1242 // |__/_n_||_|  |___| |_| |_||_n_||_| |_n_|
1243 //
1244 
1245 /**
1246  * @title SafeMath library from OpenZeppelin
1247  * @dev Math operations with safety checks that throw on error
1248  */
1249 library SafeMath {
1250 
1251     /**
1252     * @dev Multiplies two numbers, throws on overflow.
1253     */
1254     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1255         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1256         // benefit is lost if 'b' is also tested.
1257         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1258         if (a == 0) {
1259             return 0;
1260         }
1261 
1262         c = a * b;
1263         assert(c / a == b);
1264         return c;
1265     }
1266 
1267     /**
1268     * @dev Integer division of two numbers, truncating the quotient.
1269     */
1270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1271         // assert(b > 0); // Solidity automatically throws when dividing by 0
1272         // uint256 c = a / b;
1273         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1274         return a / b;
1275     }
1276 
1277     /**
1278     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1279     */
1280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1281         assert(b <= a);
1282         return a - b;
1283     }
1284 
1285     /**
1286     * @dev Adds two numbers, throws on overflow.
1287     */
1288     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1289         c = a + b;
1290         assert(c >= a);
1291         return c;
1292     }
1293 
1294     /**
1295      * @dev Gives square root of given x.
1296      */
1297     function sqrt(uint256 x)
1298         internal
1299         pure
1300         returns (uint256 y)
1301     {
1302         uint256 z = ((add(x,1)) / 2);
1303         y = x;
1304         while (z < y)
1305         {
1306             y = z;
1307             z = ((add((x / z),z)) / 2);
1308         }
1309     }
1310 }
1311 
1312 library SafeConversions {
1313     function SafeSigned(uint256 a) internal pure returns (int256) {
1314         int256 b = int256(a);
1315         // If a is too large, the signed version will be negative.
1316         assert(b >= 0);
1317         return b;
1318     }
1319 
1320     function SafeUnsigned(int256 a) internal pure returns (uint256) {
1321         // Only negative numbers are unsafe to make unsigned.
1322         assert(a >= 0);
1323         return uint256(a);
1324     }
1325 }
1326 
1327 library NameValidator {
1328     /**
1329      * @dev throws on invalid name
1330      * -converts uppercase to lower case
1331      * -cannot contain space
1332      * -cannot be only numbers
1333      * -cannot be an address (start with 0x)
1334      * -restricts characters to A-Z, a-z, 0-9
1335      * @return validated string in bytes32 format
1336      */
1337     function validate(string _input)
1338         internal
1339         pure
1340         returns(bytes32)
1341     {
1342         bytes memory temp = bytes(_input);
1343         uint256 length = temp.length;
1344         
1345         // limited to 15 characters
1346         require (length <= 15 && length > 0, "name must be between 1 and 15 characters");
1347         // cannot be an address
1348         if (temp[0] == 0x30) {
1349             require(temp[1] != 0x78, "name cannot start with 0x");
1350             require(temp[1] != 0x58, "name cannot start with 0X");
1351         }
1352         bool _hasNonNumber;
1353         for (uint256 i = 0; i < length; i++) {
1354             // if its uppercase A-Z
1355             if (temp[i] > 0x40 && temp[i] < 0x5b) {
1356                 // convert to lower case
1357                 temp[i] = byte(uint(temp[i]) + 32);
1358                 // character is non number
1359                 if (_hasNonNumber == false) {
1360                     _hasNonNumber = true;
1361                 }
1362             } else {
1363                 // character should be only lowercase a-z or 0-9
1364                 require ((temp[i] > 0x60 && temp[i] < 0x7b) || (temp[i] > 0x2f && temp[i] < 0x3a), "name contains invalid characters");
1365 
1366                 // check if character is non number 
1367                 if (_hasNonNumber == false && (temp[i] < 0x30 || temp[i] > 0x39)) {
1368                     _hasNonNumber = true;    
1369                 }
1370             }
1371         }
1372         require(_hasNonNumber == true, "name cannot be only numbers");
1373         bytes32 _ret;
1374         assembly {
1375             _ret := mload(add(temp, 32))
1376         }
1377         return (_ret);
1378     }
1379 }