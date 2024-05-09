1 pragma solidity ^0.4.23;
2 
3 /**
4  *   _____  ___    ___   _____      _              
5  *   \_   \/ __\  / __\ /__   \___ | | _____ _ __  
6  *    / /\/__\// / /      / /\/ _ \| |/ / _ \ '_ \ 
7  * /\/ /_/ \/  \/ /___   / / | (_) |   <  __/ | | |
8  * \____/\_____/\____/   \/   \___/|_|\_\___|_| |_|
9  * 
10  * Token Address: 0xDEcF3A00E37BAdA548EC438dcef99B43D7F9F67d
11  */
12 contract Token {
13     string public symbol = "";
14     string public name = "";
15     uint8 public constant decimals = 18;
16     uint256 _totalSupply = 0;
17     address owner = 0;
18     bool setupDone = false;
19    
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22  
23     mapping(address => uint256) balances;
24  
25     mapping(address => mapping (address => uint256)) allowed;
26     function SetupToken(string tokenName, string tokenSymbol, uint256 tokenSupply);
27     function totalSupply() constant returns (uint256 totalSupply);
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _amount) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
31     function approve(address _spender, uint256 _amount) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33 }
34 
35 /**
36  *   _____  ___    ___     __       _   _                  
37  *   \_   \/ __\  / __\   / /  ___ | |_| |_ ___ _ __ _   _ 
38  *    / /\/__\// / /     / /  / _ \| __| __/ _ \ '__| | | |
39  * /\/ /_/ \/  \/ /___  / /__| (_) | |_| ||  __/ |  | |_| |
40  * \____/\_____/\____/  \____/\___/ \__|\__\___|_|   \__, |
41  *                                                   |___/ 
42  */
43 
44 contract IBCLottery
45 {
46     uint256 private ticketPrice_;
47     
48     // (user => Tikcet)
49     mapping(address => Ticket) internal ticketRecord_;
50     
51     Token public ibcToken_;
52     
53     address public officialWallet_;
54     address public devATeamWallet_;
55     address public devBTeamWallet_;
56     
57     // round => tokenRaised
58     uint256 public tokenRaised_;
59     uint256 public actualTokenRaised_;
60     mapping(address => uint256) public userPaidIn_;
61     
62     // On mainnet:
63     // ibc coin: 0xdecf3a00e37bada548ec438dcef99b43d7f9f67d
64     // official wallet: 0xe49c794d9eb5cE8E72C52Ab4dc7ccB233AA7Eb7C
65     // devA team wallet: 0xB034209C57134625CD95f8843e504bD0fA8664E5
66     // devB team wallet: 0x2ECBD107C3D3AdC43EeF22EE07b0401DF11E9472
67     constructor(
68         address _ibcoin,
69         address _officialWallet,
70         address _devATeamWallet,
71         address _devBTeamWallet
72     )
73         public
74     {
75         ibcToken_ = Token(_ibcoin);
76         officialWallet_ = _officialWallet;
77         devATeamWallet_ = _devATeamWallet;
78         devBTeamWallet_ = _devBTeamWallet;
79     }
80     
81     /**
82      *    __                 _       
83      *   /__\_   _____ _ __ | |_ ___ 
84      *  /_\ \ \ / / _ \ '_ \| __/ __|
85      * //__  \ V /  __/ | | | |_\__ \
86      * \__/   \_/ \___|_| |_|\__|___/                       
87      */
88      
89     event BuyTicket(
90         address indexed buyer,
91         uint256 price
92     );
93      
94      /**
95      *                   _ _  __ _           
96      *   /\/\   ___   __| (_)/ _(_) ___ _ __ 
97      *  /    \ / _ \ / _` | | |_| |/ _ \ '__|
98      * / /\/\ \ (_) | (_| | |  _| |  __/ |   
99      * \/    \/\___/ \__,_|_|_| |_|\___|_|                                  
100      */
101      
102     modifier onlyBoughtTicket(
103         address _user,
104         uint256 _timeLeft
105     )
106     {
107         require(hasValidTicketCore(_user, _timeLeft), "You don't have ticket yet!");
108         _;
109     }
110     
111     /**
112      *    ___       _     _ _          ___                 _   _                 
113      *   / _ \_   _| |__ | (_) ___    / __\   _ _ __   ___| |_(_) ___  _ __  ___ 
114      *  / /_)/ | | | '_ \| | |/ __|  / _\| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
115      * / ___/| |_| | |_) | | | (__  / /  | |_| | | | | (__| |_| | (_) | | | \__ \
116      * \/     \__,_|_.__/|_|_|\___| \/    \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
117      */
118     
119     function buyTicketCore(
120         uint256 _pot,
121         uint256 _timeLeft,
122         address _user
123     )
124         internal
125         returns
126         (bool)
127     {
128         if(!hasValidTicketCore(_user, _timeLeft)) {
129             if (_timeLeft == 0) return false;
130             // local allowance variable
131             uint256 _allowance = ibcToken_.allowance(_user, this);
132             
133             // check if allowance to this contract.
134             require(_allowance > 0, "Please approve token to this contract.");
135             
136             // how much IBC user should pay for ticket.
137             uint256 _ticketPrice = calculateTicketPrice(_pot, _timeLeft);
138             
139             // check if the allowance enough to pay the ticket.
140             require(_allowance >= _ticketPrice, "Insufficient allowance for this contract.");
141             
142             // transfer from token from user wallet to this contract.
143             require(ibcToken_.transferFrom(_user, this, _ticketPrice));
144             
145             // increase tocket raise for each round.
146             tokenRaised_ = tokenRaised_ + _ticketPrice;
147             
148             // assign ticket to user.
149             ticketRecord_[_user].hasTicket = true;
150             ticketRecord_[_user].expirationTime = now + 30 minutes;
151             ticketRecord_[_user].ticketPrice = _ticketPrice;
152             
153             emit BuyTicket(_user, _ticketPrice);
154         }
155         return true;
156     }
157     
158     function hasValidTicketCore(
159         address _user,
160         uint256 _timeLeft
161     )
162         view
163         internal
164         returns
165         (bool)
166     {
167         if (_timeLeft == 0) return false;
168         bool _hasTicket = ticketRecord_[_user].hasTicket;
169         uint256 _expirationTime = ticketRecord_[_user].expirationTime;
170         
171         return (_hasTicket && now <= _expirationTime);
172     }
173     
174     function calculateTicketPrice(
175         uint256 _pot,
176         uint256 _timeLeft
177     ) 
178         pure
179         internal
180         returns
181         (uint256)
182     {
183         uint256 _potFixed = _pot / 1000000000000000000;
184         
185         // calculate Left time
186         uint256 _leftHour = _timeLeft / 3600;
187         
188         // left hours over and equal 24 hours
189         // pot equal to 0
190         // this means initial status of the game,
191         // no need to calculate, return 1 IBC (10**18 wei)
192         if (_leftHour >= 24) return 1000000000000000000;
193         
194         // what the fuck is this condition XDDD
195         // when 10**8 ETH in pot, return 10**7 IBC
196         // it is impossible,
197         // total ETH supply only about 10**8 ETH,
198         if (_pot >= 100000000000000000000000000) 
199             return 10000000000000000000000000;
200         
201         /** 
202          * 1        -> 99       ETH in pot => 1        IBC (< 100)
203          * 100      -> 999      ETH in pot => 10      IBC (< 1000)
204          * 1000     -> 9999     ETH in pot => 100     IBC (< 10000)
205          * 10000    -> 99999    ETH in pot => 1000    IBC (< 100000)
206          * 100000   -> 999999   ETH in pot => 10000   IBC (< 1000000)
207          * 1000000  -> 9999999  ETH in pot => 100000  IBC (< 10000000)
208          * 10000000 -> 99999999 ETH in pot => 1000000 IBC (< 100000000)
209          * Why? 
210          * Total supply will be reached 120 million,
211          * the pot only 20% will be in pot.
212          * 
213          * Time left:
214          * 0  -> 2  hours left, ticket price * 8.
215          * 3  -> 5  hours left, ticket price * 7.
216          * 6  -> 8  hours left, ticket price * 6.
217          * 9  -> 11 hours left, ticket price * 5.
218          * 12 -> 14 hours left, ticket price * 4.
219          * 15 -> 17 hours left, ticket price * 3.
220          * 18 -> 20 hours left, ticket price * 2.
221          * 21 -> 23 hours left, ticket price * 1.
222          * */
223     
224         uint256 _gap = 100;
225         for(uint8 _step = 0; _step < 7; _gap = _gap * 10) {
226             if (_potFixed < _gap) {
227                 return (_gap / 100) * (8 - (_leftHour / 3)) * 1000000000000000000;
228             }    
229         }
230     }
231     
232     function getTokenRaised()
233         view
234         public
235         returns
236         (uint256, uint256)
237     {
238         // team funding:
239         // (tokenRaised_[_round] - (actualTokenRaised_ / 4))
240         // 25% token refund to user.
241         return (
242             tokenRaised_, 
243             actualTokenRaised_
244         );
245     }
246     
247     function getUserPaidIn(
248         address _address
249     )
250         view
251         public
252         returns
253         (uint256)
254     {
255         return userPaidIn_[_address];
256     }
257     
258     struct Ticket {
259         bool hasTicket;
260         uint256 expirationTime;
261         uint256 ticketPrice;
262     }
263 }
264 
265 /**
266  *     ___ _____   ___  __                 _       
267  *    / __\___ /  /   \/__\_   _____ _ __ | |_ ___ 
268  *   / _\   |_ \ / /\ /_\ \ \ / / _ \ '_ \| __/ __|
269  *  / /    ___) / /_///__  \ V /  __/ | | | |_\__ \
270  *  \/    |____/___,'\__/   \_/ \___|_| |_|\__|___/
271  * */
272 contract IBCLotteryEvents {
273     
274     // fired at end of buy or reload
275     event onEndTx
276     (
277         address playerAddress,
278         uint256 ethIn,
279         uint256 keysBought,
280         address winnerAddr,
281         uint256 amountWon,
282         uint256 newPot,
283         uint256 genAmount,
284         uint256 potAmount
285     );
286     
287 	// fired whenever theres a withdraw
288     event onWithdraw
289     (
290         uint256 indexed playerID,
291         address playerAddress,
292         uint256 ethOut,
293         uint256 timeStamp
294     );
295     
296     // fired whenever a withdraw forces end round to be ran
297     event onWithdrawAndDistribute
298     (
299         address playerAddress,
300         uint256 ethOut,
301         address winnerAddr,
302         uint256 amountWon,
303         uint256 newPot,
304         uint256 genAmount
305     );
306     
307     // hit zero, and causes end round to be ran.
308     event onBuyAndDistribute
309     (
310         address playerAddress,
311         uint256 ethIn,
312         address winnerAddr,
313         uint256 amountWon,
314         uint256 newPot,
315         uint256 genAmount
316     );
317     
318     event onBuyTicketAndDistribute
319     (
320         address playerAddress,
321         address winnerAddr,
322         uint256 amountWon,
323         uint256 newPot,
324         uint256 genAmount
325     );
326     
327     // hit zero, and causes end round to be ran.
328     event onReLoadAndDistribute
329     (
330         address playerAddress,
331         address winnerAddr,
332         uint256 amountWon,
333         uint256 newPot,
334         uint256 genAmount
335     );
336     
337     // fired whenever an affiliate is paid
338     event onAffiliatePayout
339     (
340         uint256 indexed affiliateID,
341         address affiliateAddress,
342         uint256 indexed buyerID,
343         uint256 amount,
344         uint256 timeStamp
345     );
346     
347     event onRefundTicket
348     (
349         uint256 indexed playerID,
350         uint256 refundAmount
351     );
352 }
353 
354 /**
355  *      ___            _                  _       
356  *     / __\___  _ __ | |_ _ __ __ _  ___| |_ ___ 
357  *    / /  / _ \| '_ \| __| '__/ _` |/ __| __/ __|
358  *   / /__| (_) | | | | |_| | | (_| | (__| |_\__ \
359  *   \____/\___/|_| |_|\__|_|  \__,_|\___|\__|___/
360  * */
361 
362 contract IBCLotteryGame is IBCLotteryEvents, IBCLottery {
363     using SafeMath for *;
364     using IBCLotteryKeysCalcLong for uint256;
365 	
366     /**
367      *    ___                       __      _   _   _                 
368      *   / _ \__ _ _ __ ___   ___  / _\ ___| |_| |_(_)_ __   __ _ ___ 
369      *  / /_\/ _` | '_ ` _ \ / _ \ \ \ / _ \ __| __| | '_ \ / _` / __|
370      * / /_\\ (_| | | | | | |  __/ _\ \  __/ |_| |_| | | | | (_| \__ \
371      * \____/\__,_|_| |_| |_|\___| \__/\___|\__|\__|_|_| |_|\__, |___/
372      *                                                      |___/     
373      * */
374     
375 	// round timer starts at this
376     // start at 24 hours
377     // this value used at: 
378     //   - endRound() function
379     //   - activate() function
380     uint256 private rndInit_ = 24 hours;
381     // The timer will be added after the whole key purchased.
382     // this value used at: 
383     //   - updateTimer() function
384     uint256 private rndInc_ = 1 minutes;
385     // Max length a round timer can be
386     // this value used at:
387     //   - updateTimer() function
388     uint256 private rndMax_ = 24 hours;
389     
390     // Auto Increment ID
391     // Inspired by MYSAL AUTO INCREMENT PRIMARY KEY.
392     uint256 private maxUserId_ = 0;
393     
394     address private owner_;
395 
396     /**
397      *    ___                          ___      _        
398      *   / _ \__ _ _ __ ___   ___     /   \__ _| |_ __ _ 
399      *  / /_\/ _` | '_ ` _ \ / _ \   / /\ / _` | __/ _` |
400      * / /_\\ (_| | | | | | |  __/  / /_// (_| | || (_| |
401      * \____/\__,_|_| |_| |_|\___| /___,' \__,_|\__\__,_|
402      * */
403 	uint256 public rID_;    // round id number / total rounds that have happened
404 
405     /**
406      *    ___ _                            ___      _        
407      *   / _ \ | __ _ _   _  ___ _ __     /   \__ _| |_ __ _ 
408      *  / /_)/ |/ _` | | | |/ _ \ '__|   / /\ / _` | __/ _` |
409      * / ___/| | (_| | |_| |  __/ |     / /_// (_| | || (_| |
410      * \/    |_|\__,_|\__, |\___|_|    /___,' \__,_|\__\__,_|
411      *                |___/                                  
412      * */
413     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
414     mapping (uint256 => IBCLotteryDatasets.Player) public plyr_;   // (pID => data) player data
415     mapping (uint256 => IBCLotteryDatasets.PlayerRounds) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
416 
417     /**
418      *    __                       _      ___      _        
419      *   /__\ ___  _   _ _ __   __| |    /   \__ _| |_ __ _ 
420      *  / \/// _ \| | | | '_ \ / _` |   / /\ / _` | __/ _` |
421      * / _  \ (_) | |_| | | | | (_| |  / /_// (_| | || (_| |
422      * \/ \_/\___/ \__,_|_| |_|\__,_| /___,' \__,_|\__\__,_|
423      * */
424     IBCLotteryDatasets.Round round_;   // (rID => data) round data
425 
426     /**
427      *     ___                _                   _             
428      *    / __\___  _ __  ___| |_ _ __ _   _  ___| |_ ___  _ __ 
429      *   / /  / _ \| '_ \/ __| __| '__| | | |/ __| __/ _ \| '__|
430      *  / /__| (_) | | | \__ \ |_| |  | |_| | (__| || (_) | |   
431      *  \____/\___/|_| |_|___/\__|_|   \__,_|\___|\__\___/|_|   
432      * */
433     constructor(
434         address _ibcoin,
435         address _officialWallet,
436         address _devATeamWallet,
437         address _devBTeamWallet
438     )
439         IBCLottery(_ibcoin, _officialWallet, _devATeamWallet, _devBTeamWallet)
440         public
441     {
442         owner_ = msg.sender;
443 	}
444     /**
445                          _ _  __ _               
446      *   /\/\   ___   __| (_)/ _(_) ___ _ __ ___ 
447      *  /    \ / _ \ / _` | | |_| |/ _ \ '__/ __|
448      * / /\/\ \ (_) | (_| | |  _| |  __/ |  \__ \
449      * \/    \/\___/ \__,_|_|_| |_|\___|_|  |___/
450      */
451     /**
452      * @dev used to make sure no one can interact with contract until it has 
453      * been activated. 
454      */
455     modifier isActivated() {
456         require(activated_ == true, "Be patient!!!"); 
457         _;
458     }
459     /**
460      * @dev prevents contracts from interacting this contract
461      */
462     modifier isHuman() {
463         address _addr = msg.sender;
464         uint256 _codeLength;
465         
466         assembly {_codeLength := extcodesize(_addr)}
467         require(_codeLength == 0, "sorry humans only");
468         _;
469     }
470     
471     modifier onlyInRound() {
472         require(!round_.ended, "The game has ended");
473         _;
474     }
475 
476     /**
477      * @dev sets boundaries for incoming tx 
478      */
479     modifier isWithinLimits(uint256 _eth) {
480         require(_eth >= 1000000000, "pocket lint: not a valid currency");
481         require(_eth <= 100000000000000000000000, "no vitalik, no");
482         _;    
483     }
484     
485     modifier onlyOwner(
486         address _address
487     ) {
488         require(_address == owner_, "You are not owner!!!!");
489         _;
490     }
491     
492     /**
493      *    ___       _     _ _          ___                 _   _                 
494      *   / _ \_   _| |__ | (_) ___    / __\   _ _ __   ___| |_(_) ___  _ __  ___ 
495      *  / /_)/ | | | '_ \| | |/ __|  / _\| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
496      * / ___/| |_| | |_) | | | (__  / /  | |_| | | | | (__| |_| | (_) | | | \__ \
497      * \/     \__,_|_.__/|_|_|\___| \/    \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
498      * */
499     /**
500      * @dev emergency buy uses last stored affiliate ID and team snek
501      */
502     function()
503         isActivated()
504         onlyInRound()
505         isHuman()
506         isWithinLimits(msg.value)
507         onlyBoughtTicket(msg.sender, getTimeLeft())
508         public
509         payable
510     {
511         // set up our tx event data and determine if player is new or not
512         IBCLotteryDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
513         
514         // fetch player id
515         uint256 _pID = pIDxAddr_[msg.sender];
516         
517         uint256 _affID = plyr_[_pID].laff;
518         
519         core(_pID, msg.value, _affID, _eventData_);
520     }
521     
522     /**
523      * @dev converts all incoming ethereum to keys.
524      * -functionhash- 0x8f38f309 (using ID for affiliate)
525      * -functionhash- 0x98a0871d (using address for affiliate)
526      * @param _affCode the ID/address/name of the player who gets the affiliate fee
527      */
528     
529     function buyXaddr(address _affCode)
530         isActivated()
531         onlyInRound()
532         isHuman()
533         isWithinLimits(msg.value)
534         onlyBoughtTicket(msg.sender, getTimeLeft())
535         public
536         payable
537     {
538         // set up our tx event data and determine if player is new or not
539         IBCLotteryDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
540         
541         // fetch player id
542         uint256 _pID = pIDxAddr_[msg.sender];
543 
544         // manage affiliate residuals
545         uint256 _affID = pIDxAddr_[_affCode];
546         // if no affiliate code was given or player tried to use their own, lolz
547         if (_affCode == address(0) 
548             || _affCode == msg.sender 
549             || plyrRnds_[_affID].keys < 1000000000000000000)
550         {
551             // use last stored affiliate code
552             _affID = plyr_[_pID].laff;
553         
554         // if affiliate code was given    
555         } else {
556             // get affiliate ID from aff Code 
557             _affID = pIDxAddr_[_affCode];
558             
559             // if affID is not the same as previously stored 
560             if (_affID != plyr_[_pID].laff)
561             {
562                 // update last affiliate
563                 plyr_[_pID].laff = _affID;
564             }
565         }
566         
567         core(_pID, msg.value, _affID, _eventData_);
568     }
569     
570     function buyTicket()
571         onlyInRound()
572         public
573         returns
574         (bool)
575     {
576         uint256 _now = now;
577         if (_now > round_.end && round_.ended == false && round_.plyr != 0) 
578         {
579             IBCLotteryDatasets.EventReturns memory _eventData_;
580             
581             // end the round (distributes pot) & start new round
582 		    round_.ended = true;
583             _eventData_ = endRound(_eventData_);
584             
585             // fire buy and distribute event 
586             emit IBCLotteryEvents.onBuyTicketAndDistribute
587             (
588                 msg.sender, 
589                 _eventData_.winnerAddr, 
590                 _eventData_.amountWon, 
591                 _eventData_.newPot, 
592                 _eventData_.genAmount
593             );
594         } else {
595             uint256 _pot = round_.pot;
596             uint256 _timeLeft = getTimeLeft();
597             return buyTicketCore(_pot, _timeLeft, msg.sender);
598         }
599     }
600 
601     /**
602      * @dev withdraws all of your earnings.
603      * -functionhash- 0x3ccfd60b
604      */
605     function withdraw()
606         isActivated()
607         isHuman()
608         public
609     {
610         // grab time
611         uint256 _now = now;
612         
613         // fetch player ID
614         uint256 _pID = pIDxAddr_[msg.sender];
615         
616         // setup temp var for player eth
617         uint256 _eth;
618         
619         // check to see if round has ended and no one has run round end yet
620         if (_now > round_.end && round_.ended == false && round_.plyr != 0)
621         {
622             // set up our tx event data
623             IBCLotteryDatasets.EventReturns memory _eventData_;
624             
625             // end the round (distributes pot)
626 			round_.ended = true;
627             _eventData_ = endRound(_eventData_);
628             
629 			// get their earnings
630             _eth = withdrawEarnings(_pID);
631             
632             // gib moni
633             if (_eth > 0)
634                 plyr_[_pID].addr.transfer(_eth);    
635             
636             // fire withdraw and distribute event
637             emit IBCLotteryEvents.onWithdrawAndDistribute
638             (
639                 msg.sender, 
640                 _eth, 
641                 _eventData_.winnerAddr, 
642                 _eventData_.amountWon, 
643                 _eventData_.newPot, 
644                 _eventData_.genAmount
645             );
646             
647         // in any other situation
648         } else {
649             // get their earnings
650             _eth = withdrawEarnings(_pID);
651             
652             // gib moni
653             if (_eth > 0)
654                 plyr_[_pID].addr.transfer(_eth);
655             
656             // fire withdraw event
657             emit IBCLotteryEvents.onWithdraw(_pID, msg.sender, _eth, _now);
658         }
659         
660         if (now > round_.end && round_.plyr != 0) {
661             refundTicket(_pID);
662         }
663     }
664 
665     /**
666      *    ___     _   _                
667      *   / _ \___| |_| |_ ___ _ __ ___ 
668      *  / /_\/ _ \ __| __/ _ \ '__/ __|
669      * / /_\\  __/ |_| ||  __/ |  \__ \
670      * \____/\___|\__|\__\___|_|  |___/
671      * */
672     /**
673      * @dev return the price buyer will pay for next 1 individual key.
674      * -functionhash- 0x018a25e8
675      * @return price for next key bought (in wei format)
676      */
677     function getBuyPrice()
678         public 
679         view 
680         returns(uint256)
681     {  
682         // grab time
683         uint256 _now = now;
684         
685         // are we in a round?
686         if (_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
687             return ( (round_.keys.add(1000000000000000000)).ethRec(1000000000000000000) );
688         else // rounds over.  need price for new round
689             return ( 75000000000000 ); // init
690     }
691     
692     /**
693      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
694      * provider
695      * -functionhash- 0xc7e284b8
696      * @return time left in seconds
697      */
698     function getTimeLeft()
699         public
700         view
701         returns(uint256)
702     {
703         // grab time
704         uint256 _now = now;
705         
706         if (_now < round_.end)
707             if (_now > round_.strt)
708                 return( (round_.end).sub(_now) );
709             else
710                 return( (round_.strt).sub(_now) );
711         else
712             return(0);
713     }
714     
715     /**
716      * @dev returns player earnings per vaults 
717      * -functionhash- 0x63066434
718      * @return winnings vault
719      * @return general vault
720      * @return affiliate vault
721      * @return token share vault
722      */
723     function getPlayerVaults(uint256 _pID)
724         public
725         view
726         returns(uint256 ,uint256, uint256, uint256)
727     {
728         uint256 _gen;
729         uint256 _limiter;
730         uint256 _genShow;
731         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
732         if (now > round_.end && round_.ended == false && round_.plyr != 0)
733         {
734             // if player is winner 
735             if (round_.plyr == _pID)
736             {
737                 _gen = (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask));
738                 _limiter = (plyrRnds_[_pID].eth.mul(22) / 10);
739                 _genShow = 0;
740                 
741                 if (plyrRnds_[_pID].genWithdraw.add(_gen) > _limiter) {
742                     _genShow = _limiter - plyrRnds_[_pID].genWithdraw;
743                 } else {
744                     _genShow = _gen;
745                 }
746                 
747                 return
748                 (
749                     (plyr_[_pID].win).add( ((round_.pot).mul(2)) / 5 ).add(getFinalDistribute(_pID)),
750                     _genShow,
751                     plyr_[_pID].aff,
752                     plyr_[_pID].tokenShare.add(getTokenShare(_pID))
753                 );
754             // if player is not the winner
755             } else {
756                 
757                 _gen = (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID).sub(plyrRnds_[_pID].mask));
758                 _limiter = (plyrRnds_[_pID].eth.mul(22) / 10);
759                 _genShow = 0;
760                 
761                 if (plyrRnds_[_pID].genWithdraw.add(_gen) > _limiter) {
762                     _genShow = _limiter - plyrRnds_[_pID].genWithdraw;
763                 } else {
764                     _genShow = _gen;
765                 }    
766                 
767                 return
768                 (
769                     (plyr_[_pID]).win.add(getFinalDistribute(_pID)),
770                     _genShow,
771                     plyr_[_pID].aff,
772                     plyr_[_pID].tokenShare.add(getTokenShare(_pID))
773                 );
774             }
775             
776         // if round is still going on, or round has ended and round end has been ran
777         } else {
778             _gen = (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID)) ;
779             _limiter = (plyrRnds_[_pID].eth.mul(22) / 10);
780             _genShow = 0;
781             
782             if (plyrRnds_[_pID].genWithdraw.add(_gen) > _limiter) {
783                 _genShow = _limiter - plyrRnds_[_pID].genWithdraw;
784             } else {
785                 _genShow = _gen;
786             }  
787             
788             return
789             (
790                 plyr_[_pID].win.add(getFinalDistribute(_pID)),
791                 _genShow,
792                 plyr_[_pID].aff,
793                 plyr_[_pID].tokenShare.add(getTokenShare(_pID))
794             );
795         }
796     }
797     
798     /**
799      * solidity hates stack limits.  this lets us avoid that hate 
800      */
801     function getPlayerVaultsHelper(uint256 _pID)
802         private
803         view
804         returns(uint256)
805     {
806         return(  (((round_.mask).mul(plyrRnds_[_pID].keys)) / 1000000000000000000)  );
807     }
808     
809     function getFinalDistribute(uint256 _pID)
810         private
811         view
812         returns(uint256)
813     {
814         uint256 _now = now;
815         
816         if (_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
817         {
818             return 0;
819         }
820         
821         uint256 _boughtTime = plyrRnds_[_pID].boughtTime;
822         
823         if(_boughtTime == 0) return 0;
824         
825         uint256 _firstKeyShare = round_.firstKeyShare;
826         
827         uint256 _eachKeyCanShare = round_.eachKeyCanShare;
828         uint256 _totalKeyCanShare = 0;
829         for (uint256 _bought = _boughtTime; _bought > 0; _bought --) {
830             uint256 _lastKey = plyrRnds_[_pID].boughtRecord[_bought].lastKey;
831             if (_lastKey < _firstKeyShare) break;
832             uint256 _amount = plyrRnds_[_pID].boughtRecord[_bought].amount;
833             uint256 _firstKey = _lastKey - _amount;
834             if (_firstKey > _firstKeyShare) {
835                 _totalKeyCanShare = _totalKeyCanShare.add(_amount);
836             } else {
837                 _totalKeyCanShare = _totalKeyCanShare.add(_lastKey - _firstKeyShare);
838             }
839         }
840         return (_totalKeyCanShare.mul(_eachKeyCanShare) / 1000000000000000000);
841     }
842     
843     function getTokenShare(uint256 _pID) 
844         private
845         view
846         returns(uint256)
847     {
848         uint256 _now = now;
849         
850         if(plyrRnds_[_pID].tokenShareCalc) {
851             return 0;
852         }
853         
854         if (_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
855         {
856             return 0;   
857         }
858         
859         address _address = plyr_[_pID].addr;
860         uint256 _userPaidIn = userPaidIn_[_address];
861         
862         return ((round_.tokenShare.mul(_userPaidIn)) / 1000000000000000000);
863     }
864     
865     
866     /**
867      * @dev returns all current round info needed for front end
868      * -functionhash- 0x747dff42
869      * @return round id 
870      * @return total keys for round 
871      * @return time round ends
872      * @return time round started
873      * @return current pot 
874      * @return player ID in lead 
875      * @return current player in leads address 
876      * @return token raised for buying ticket
877      * @return token actual raised for using ticket.
878      */
879     function getCurrentRoundInfo()
880         public
881         view
882         returns(uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
883     {
884         (uint256 _tokenRaised, uint256 _tokenActualRaised) = getTokenRaised();
885         
886         return
887         (
888             round_.keys,              //0
889             round_.end,               //1
890             round_.strt,              //2
891             round_.pot,               //3
892             round_.plyr,     //4
893             plyr_[round_.plyr].addr,  //5
894             _tokenRaised, // 6
895             _tokenActualRaised //7 
896         );
897     }
898 
899     /**
900      * @dev returns player info based on address.  if no address is given, it will 
901      * use msg.sender 
902      * -functionhash- 0xee0b5d8b
903      * @param _addr address of the player you want to lookup 
904      * @return player ID 
905      * @return keys owned (current round)
906      * @return winnings vault
907      * @return general vault 
908      * @return affiliate vault 
909 	 * @return player round eth
910      */
911     function getPlayerInfoByAddress(address _addr)
912         public 
913         view 
914         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256)
915     {
916         if (_addr == address(0))
917         {
918             _addr == msg.sender;
919         }
920         uint256 _pID = pIDxAddr_[_addr];
921         
922         uint256 _gen = (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID));
923         uint256 _limiter = (plyrRnds_[_pID].eth.mul(22) / 10);
924         uint256 _genShow = 0;
925         
926         if (plyrRnds_[_pID].genWithdraw.add(_gen) > _limiter) {
927             _genShow = _limiter - plyrRnds_[_pID].genWithdraw;
928         } else {
929             _genShow = _gen;
930         } 
931         
932         return
933         (
934             _pID,                               //0
935             plyrRnds_[_pID].keys,         //1
936             plyr_[_pID].win,                    //2
937             _genShow,       //3
938             plyr_[_pID].aff,                    //4
939             plyr_[_pID].tokenShare,             // 5
940             plyrRnds_[_pID].eth           //6
941         );
942     }
943 
944     /**
945      *    ___                   __             _      
946      *   / __\___  _ __ ___    / /  ___   __ _(_) ___ 
947      *  / /  / _ \| '__/ _ \  / /  / _ \ / _` | |/ __|
948      * / /__| (_) | | |  __/ / /__| (_) | (_| | | (__ 
949      * \____/\___/|_|  \___| \____/\___/ \__, |_|\___|
950      *                                   |___/        
951      * */
952     
953     /**
954      * @dev this is the core logic for any buy/reload that happens while a round 
955      * is live.
956      */
957     function core(uint256 _pID, uint256 _eth, uint256 _affID, IBCLotteryDatasets.EventReturns memory _eventData_)
958         private
959     {
960         // if player is new to round
961         if (plyrRnds_[_pID].keys == 0)
962             _eventData_ = managePlayer(_pID, _eventData_);
963         
964         // if eth left is greater than min eth allowed (sorry no pocket lint)
965         
966         // mint the new keys
967         uint256 _keys = (round_.eth).keysRec(_eth);
968         uint256 _keyBonus = getKeyBonus();
969         
970         _keys = (_keys.mul(_keyBonus) / 10);
971         
972         // if they bought at least 1 whole key
973         if (_keys >= 1000000000000000000 && _keyBonus == 10)
974         {
975             updateTimer(_keys);
976 
977             // set new leaders
978             if (round_.plyr != _pID)
979                 round_.plyr = _pID;  
980         }
981         
982         // new key cannot share over earning dividend.
983         if (round_.overEarningMask > 0) {
984             plyrRnds_[_pID].mask = plyrRnds_[_pID].mask.add(
985                 (round_.overEarningMask.mul(_keys) / 1000000000000000000)
986             );
987         }
988         
989         // update player 
990         plyrRnds_[_pID].keys = _keys.add(plyrRnds_[_pID].keys);
991         plyrRnds_[_pID].eth = _eth.add(plyrRnds_[_pID].eth);
992         
993         // update round
994         round_.keys = _keys.add(round_.keys);
995         round_.eth = _eth.add(round_.eth);
996         
997         uint256 _boughtTime = plyrRnds_[_pID].boughtTime + 1;
998         plyrRnds_[_pID].boughtTime = _boughtTime;
999         
1000         plyrRnds_[_pID].boughtRecord[_boughtTime].lastKey = round_.keys;
1001         plyrRnds_[_pID].boughtRecord[_boughtTime].amount = _keys;
1002 
1003         // distribute eth
1004         _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
1005         _eventData_ = distributeInternal(_pID, _eth, _keys, _eventData_);
1006         
1007         // call end tx function to fire end tx event.
1008         endTx(_eth, _keys, _eventData_);
1009     }
1010     /**
1011      *    ___      _            _       _   _                 
1012      *   / __\__ _| | ___ _   _| | __ _| |_(_) ___  _ __  ___ 
1013      *  / /  / _` | |/ __| | | | |/ _` | __| |/ _ \| '_ \/ __|
1014      * / /__| (_| | | (__| |_| | | (_| | |_| | (_) | | | \__ \
1015      * \____/\__,_|_|\___|\__,_|_|\__,_|\__|_|\___/|_| |_|___/
1016      * */
1017     /**
1018      * @dev calculates unmasked earnings (just calculates, does not update mask)
1019      * @return earnings in wei format
1020      */
1021     function calcUnMaskedEarnings(uint256 _pID)
1022         private
1023         view
1024         returns(uint256)
1025     {
1026         return(  (((round_.mask.add(round_.overEarningMask)).mul(plyrRnds_[_pID].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID].mask)  );
1027     }
1028     
1029     /** 
1030      * @dev returns the amount of keys you would get given an amount of eth. 
1031      * -functionhash- 0xce89c80c
1032      * @param _eth amount of eth sent in 
1033      * @return keys received 
1034      */
1035     function calcKeysReceived(uint256 _eth)
1036         public
1037         view
1038         returns(uint256)
1039     {
1040         // grab time
1041         uint256 _now = now;
1042         
1043         // are we in a round?
1044         if (_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1045             return ( (round_.eth).keysRec(_eth) );
1046         else // rounds over.  need keys for new round
1047             return ( (_eth).keys() );
1048     }
1049     
1050     /** 
1051      * @dev returns current eth price for X keys.  
1052      * -functionhash- 0xcf808000
1053      * @param _keys number of keys desired (in 18 decimal format)
1054      * @return amount of eth needed to send
1055      */
1056     function iWantXKeys(uint256 _keys)
1057         public
1058         view
1059         returns(uint256)
1060     {
1061         // grab time
1062         uint256 _now = now;
1063         
1064         // are we in a round?
1065         if (_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1066             return ( (round_.keys.add(_keys)).ethRec(_keys) );
1067         else // rounds over.  need price for new round
1068             return ( (_keys).eth() );
1069     }
1070 
1071     function getTicketPrice()
1072         public
1073         view
1074         returns(uint256)
1075     {
1076         uint256 _now = now;
1077         // in round
1078         if (_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0)))
1079         {
1080             uint256 _timeLeft = round_.end - now;
1081             return calculateTicketPrice(round_.pot, _timeLeft);
1082         }
1083         // not in round
1084         else {
1085             return 1000000000000000000;
1086         }
1087     }
1088 
1089     /**
1090      *   _____            _     
1091      *  /__   \___   ___ | |___ 
1092      *   / /\/ _ \ / _ \| / __|
1093      *  / / | (_) | (_) | \__ \
1094      *  \/   \___/ \___/|_|___/
1095      * */
1096         
1097     /**
1098      * @dev gets existing or registers new pID.  use this when a player may be new
1099      * @return pID 
1100      */
1101     function determinePID(IBCLotteryDatasets.EventReturns memory _eventData_)
1102         private
1103         returns (IBCLotteryDatasets.EventReturns)
1104     {
1105         uint256 _pID = pIDxAddr_[msg.sender];
1106         if (_pID == 0)
1107         {
1108             maxUserId_ = maxUserId_ + 1;
1109             _pID = maxUserId_;
1110             
1111             // set up player account 
1112             pIDxAddr_[msg.sender] = _pID;
1113             plyr_[_pID].addr = msg.sender;
1114         } 
1115         return (_eventData_);
1116     }
1117     
1118     function getKeyBonus()
1119         view
1120         internal
1121         returns
1122         (uint256)
1123     {
1124         uint256 _timeLeft = getTimeLeft();
1125         
1126         if(_timeLeft == 86400) return 10;
1127         
1128         uint256 _hoursLeft = _timeLeft / 3600;
1129         uint256 _minutesLeft = (_timeLeft % 3600) / 60;
1130         
1131         if(_minutesLeft <= 59 && _minutesLeft >= 5) return 10;
1132         
1133         uint256 _flag = 0;
1134         if (_hoursLeft <= 24 && _hoursLeft >= 12) {
1135             _flag = 3;
1136         } else {
1137             _flag = 6;
1138         }
1139         
1140         uint256 _randomNumber = getRandomNumber() % _flag;
1141         
1142         return ((5*_randomNumber) + 15);
1143     }
1144     
1145     /**
1146      * @dev decides if round end needs to be run & new round started.  and if 
1147      * player unmasked earnings from previously played rounds need to be moved.
1148      */
1149     function managePlayer(uint256 _pID, IBCLotteryDatasets.EventReturns memory _eventData_)
1150         private
1151         returns (IBCLotteryDatasets.EventReturns)
1152     {
1153         // if player has played a previous round, move their unmasked earnings
1154         // from that round to gen vault.
1155         if (plyr_[_pID].lrnd != 0)
1156             updateGenVault(_pID);
1157             
1158         // update player's last round played
1159         plyr_[_pID].lrnd = rID_;
1160         
1161         return(_eventData_);
1162     }
1163     
1164     /**
1165      * @dev ends the round. manages paying out winner/splitting up pot
1166      */
1167     function endRound(IBCLotteryDatasets.EventReturns memory _eventData_)
1168         private
1169         returns (IBCLotteryDatasets.EventReturns)
1170     {
1171         
1172         // grab our winning player and team id's
1173         uint256 _winPID = round_.plyr;
1174         
1175         // grab our pot amount
1176         uint256 _pot = round_.pot;
1177         
1178         // calculate our winner share, community rewards, gen share, 
1179         // all eth in 20% to pot,
1180         // winner share 40% of pot.
1181         // last 1% user share another 50% of pot.
1182         uint256 _win = ((_pot.mul(2)) / 5);
1183         
1184         // refund those ticket unused to ibcToken wallet.
1185         uint256 tokenBackToTeam = tokenRaised_ - actualTokenRaised_;
1186         if (tokenBackToTeam > 0) {
1187             ibcToken_.transfer(officialWallet_, tokenBackToTeam / 2);
1188             ibcToken_.transfer(devATeamWallet_, tokenBackToTeam / 2);
1189         }
1190         
1191         // pay our winner
1192         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1193         
1194             
1195         // prepare event data
1196         _eventData_.winnerAddr = plyr_[_winPID].addr;
1197         _eventData_.amountWon = _win;
1198         
1199         return(_eventData_);
1200     }
1201     
1202     /**
1203      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1204      */
1205     function updateGenVault(uint256 _pID)
1206         private 
1207     {
1208         uint256 _earnings = calcUnMaskedEarnings(_pID);
1209         if (_earnings > 0)
1210         {
1211             // put in gen vault
1212             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1213             // zero out their earnings by updating mask
1214             plyrRnds_[_pID].mask = _earnings.add(plyrRnds_[_pID].mask);
1215         }
1216     }
1217     
1218     function updateFinalDistribute(uint256 _pID)
1219         private
1220     {
1221         uint256 _now = now;
1222         if (!(_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))))
1223         {
1224             plyr_[_pID].win = plyr_[_pID].win + getFinalDistribute(_pID);
1225             plyrRnds_[_pID].boughtTime = 0;
1226         }
1227     }
1228     
1229     function updateTokenShare(uint256 _pID)
1230         internal
1231     {
1232         uint256 _now = now;
1233         if (!(_now > round_.strt && (_now <= round_.end || (_now > round_.end && round_.plyr == 0))))
1234         {
1235             if (!plyrRnds_[_pID].tokenShareCalc) {
1236                 plyr_[_pID].tokenShare = plyr_[_pID].tokenShare + getTokenShare(_pID);
1237                 plyrRnds_[_pID].tokenShareCalc = true;
1238             }
1239         }
1240     }
1241     
1242     /**
1243      * @dev updates round timer based on number of whole keys bought.
1244      */
1245     function updateTimer(uint256 _keys)
1246         private
1247     {
1248         // grab time
1249         uint256 _now = now;
1250         
1251         // calculate time based on number of keys bought
1252         uint256 _newTime;
1253         if (_now > round_.end && round_.plyr == 0)
1254             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1255         else
1256             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_.end);
1257         
1258         // compare to max and set new end time
1259         if (_newTime < (rndMax_).add(_now))
1260             round_.end = _newTime;
1261         else
1262             round_.end = rndMax_.add(_now);
1263     }
1264 
1265     /**
1266      * @dev distributes eth based on fees to com, aff, and p3d
1267      */
1268     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, IBCLotteryDatasets.EventReturns memory _eventData_)
1269         private 
1270         returns(IBCLotteryDatasets.EventReturns)
1271     {
1272         
1273         // distribute share to affiliate
1274         // 20% for affiliate
1275         // origin ((_eth / 5).mul(88) / 100)
1276         uint256 _aff = ((_eth).mul(88) / 500);
1277         
1278         // decide what to do with affiliate share of fees
1279         // affiliate must not be self, and must have a name registered
1280         // what is this?
1281         // all of player of this game has player ID.
1282         // bu to be an legal affiliate must register, register can give user a name.
1283         // those users who have name is an valid affiliate.
1284         if (_affID != _pID && _affID != 0) {
1285             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1286             emit IBCLotteryEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, _pID, _aff, now);
1287         } else if (!round_.firstPlayerIn){
1288             // first user send to dev A wallet.
1289             devATeamWallet_.transfer(_aff);
1290             round_.firstPlayerIn = true;
1291             emit IBCLotteryEvents.onAffiliatePayout(0, devATeamWallet_, _pID, _aff, now);
1292         } else {
1293             // no affiliate
1294             // send to offical wallet.
1295             devBTeamWallet_.transfer(_aff);
1296             emit IBCLotteryEvents.onAffiliatePayout(0, devBTeamWallet_, _pID, _aff, now);
1297         }
1298         
1299         return(_eventData_);
1300     }
1301     
1302     /**
1303      * @dev distributes eth based on fees to gen and pot
1304      */
1305     function distributeInternal(uint256 _pID, uint256 _eth, uint256 _keys, IBCLotteryDatasets.EventReturns memory _eventData_)
1306         private
1307         returns(IBCLotteryDatasets.EventReturns)
1308     {
1309         // calculate gen share 50%
1310         // origin = (_eth.mul(45).mul(88) / 100 / 100)
1311         uint256 _gen = (_eth.mul(3960) / 10000);
1312         
1313         // aff share 15%
1314         // _gen 50%
1315         // IBC share 10%
1316         // pot 25%
1317         
1318         // calculate pot 
1319         // origin: ((_eth / 4).mul(88) / 100)
1320         uint256 _pot = _pot.add((_eth.mul(88)) / 400);
1321         
1322         // distribute gen share (thats what updateMasks() does) and adjust
1323         // balances for dust.
1324         uint256 _dust = updateMasks(_pID, _gen, _keys);
1325         if (_dust > 0)
1326             _gen = _gen.sub(_dust);
1327         
1328         // add eth to pot
1329         round_.pot = _pot.add(_dust).add(round_.pot);
1330         
1331         // set up event data
1332         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1333         _eventData_.potAmount = _pot;
1334         
1335         return(_eventData_);
1336     }
1337     
1338     function refundTicket(uint256 _pID)
1339         public
1340     {
1341         address _playerAddress = plyr_[_pID].addr;
1342         uint256 _userPaidIn = userPaidIn_[_playerAddress];
1343         
1344         if (!plyr_[_pID].ibcRefund && _userPaidIn != 0) {
1345             // do not do refund at round 1.
1346             uint256 _refund = userPaidIn_[_playerAddress] / 4;
1347             plyr_[_pID].ibcRefund = true;
1348             ibcToken_.transfer(_playerAddress, _refund);
1349             emit onRefundTicket(
1350                 _pID,
1351                 _refund
1352             );
1353         }
1354     }
1355 
1356     /**
1357      * @dev updates masks for round and player when keys are bought
1358      * @return dust left over 
1359      */
1360     function updateMasks(uint256 _pID, uint256 _gen, uint256 _keys)
1361         private
1362         returns(uint256)
1363     {
1364         /* MASKING NOTES
1365             earnings masks are a tricky thing for people to wrap their minds around.
1366             the basic thing to understand here.  is were going to have a global
1367             tracker based on profit per share for each round, that increases in
1368             relevant proportion to the increase in share supply.
1369             
1370             the player will have an additional mask that basically says "based
1371             on the rounds mask, my shares, and how much i've already withdrawn,
1372             how much is still owed to me?"
1373         */
1374         
1375         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1376         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_.keys);
1377         round_.mask = _ppt.add(round_.mask);
1378             
1379         // calculate player earning from their own buy (only based on the keys
1380         // they just bought).  & update player earnings mask
1381         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1382         plyrRnds_[_pID].mask = (((round_.mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID].mask);
1383         
1384         // calculate & return dust
1385         return(_gen.sub((_ppt.mul(round_.keys)) / (1000000000000000000)));
1386     }
1387     
1388     /**
1389      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1390      * @return earnings in wei format
1391      */
1392     function withdrawEarnings(uint256 _pID)
1393         private
1394         returns(uint256)
1395     {
1396         // update gen vault
1397         updateGenVault(_pID);
1398         updateTokenShare(_pID);
1399         updateFinalDistribute(_pID);
1400         
1401         uint256 _playerGenWithdraw = plyrRnds_[_pID].genWithdraw;
1402         
1403         uint256 _limiter = (plyrRnds_[_pID].eth.mul(22) / 10);
1404         
1405         uint256 _withdrawGen = 0;
1406         
1407         if(_playerGenWithdraw.add(plyr_[_pID].gen) > _limiter) {
1408             _withdrawGen = _limiter - _playerGenWithdraw;
1409             
1410             uint256 _overEarning = _playerGenWithdraw.add(plyr_[_pID].gen) - _limiter;
1411             round_.overEarningMask = round_.overEarningMask.add(_overEarning.mul(1000000000000000000) / round_.keys);
1412             for (int i = 0; i < 5; i ++) {
1413                 round_.overEarningMask = round_.overEarningMask.add(_overEarning.mul(1000000000000000000) / round_.keys);
1414                 _overEarning = (round_.overEarningMask.mul(plyrRnds_[_pID].keys) / 1000000000000000000);
1415             }
1416             
1417             plyrRnds_[_pID].genWithdraw = _limiter;
1418         } else {
1419             _withdrawGen = plyr_[_pID].gen;
1420             
1421             plyrRnds_[_pID].genWithdraw = _playerGenWithdraw.add(plyr_[_pID].gen);
1422         }
1423         
1424         // from vaults 
1425         uint256 _earnings = (plyr_[_pID].win)
1426                             .add(_withdrawGen)
1427                             .add(plyr_[_pID].aff)
1428                             .add(plyr_[_pID].tokenShare);
1429         if (_earnings > 0)
1430         {
1431             plyr_[_pID].win = 0;
1432             plyr_[_pID].gen = 0;
1433             plyr_[_pID].aff = 0;
1434             plyr_[_pID].tokenShare = 0;
1435         }
1436 
1437         return(_earnings);
1438     }
1439     
1440     /**
1441      * @dev prepares compression data and fires event for buy or reload tx's
1442      */
1443     function endTx(uint256 _eth, uint256 _keys, IBCLotteryDatasets.EventReturns memory _eventData_)
1444         private
1445     {
1446         uint256 _pot = round_.pot;
1447         
1448         round_.firstKeyShare = ((round_.keys.mul(95)) / 100);
1449         uint256 _finalShareAmount = (round_.keys).sub(round_.firstKeyShare);
1450         round_.eachKeyCanShare = ((((_pot * 3) / 5).mul(1000000000000000000)) / _finalShareAmount);
1451         
1452         uint256 _ticketPrice = ticketRecord_[msg.sender].ticketPrice;
1453         
1454         userPaidIn_[msg.sender] = userPaidIn_[msg.sender] + _ticketPrice;
1455         actualTokenRaised_ = actualTokenRaised_ + _ticketPrice;
1456         
1457         ibcToken_.transfer(officialWallet_, (_ticketPrice / 2));
1458         ibcToken_.transfer(devATeamWallet_, (_ticketPrice / 4));
1459         
1460         // calculate share per token
1461         // origin: ((((round_.eth) / 10).mul(88)) / 100)
1462         uint256 totalTokenShare = (((round_.eth).mul(88)) / 1000);
1463         round_.tokenShare = ((totalTokenShare.mul(1000000000000000000)) / (actualTokenRaised_));
1464         
1465         devATeamWallet_.transfer(((_eth.mul(12)) / 100));
1466         
1467         ticketRecord_[msg.sender].hasTicket = false;
1468         
1469         emit IBCLotteryEvents.onEndTx
1470         (
1471             msg.sender,
1472             _eth,
1473             _keys,
1474             _eventData_.winnerAddr,
1475             _eventData_.amountWon,
1476             _eventData_.newPot,
1477             _eventData_.genAmount,
1478             _eventData_.potAmount
1479         );
1480     }
1481     
1482     function getRandomNumber() 
1483         view
1484         internal
1485         returns
1486         (uint8)
1487     {
1488         uint256 _timeLeft = getTimeLeft();
1489         return uint8(uint256(keccak256(
1490             abi.encodePacked(
1491             block.timestamp, 
1492             block.difficulty, 
1493             block.coinbase,
1494             _timeLeft,
1495             msg.sender
1496             )))%256);
1497     }
1498     
1499     function hasValidTicket()
1500         view
1501         public
1502         returns
1503         (bool)
1504     {
1505         address _buyer = msg.sender;
1506         uint256 _timeLeft = getTimeLeft();
1507         
1508         return hasValidTicketCore(_buyer, _timeLeft);
1509     }
1510     
1511     /**
1512      *    ___                                            _       
1513      *   /___\__      ___ __   ___ _ __       ___  _ __ | |_   _ 
1514      *  //  //\ \ /\ / / '_ \ / _ \ '__|____ / _ \| '_ \| | | | |
1515      * / \_//  \ V  V /| | | |  __/ | |_____| (_) | | | | | |_| |
1516      * \___/    \_/\_/ |_| |_|\___|_|        \___/|_| |_|_|\__, |
1517      *                                                     |___/ 
1518      * */
1519     /** upon contract deploy, it will be deactivated.  this is a one time
1520      * use function that will activate the contract.  we do this so devs 
1521      * have time to set things up on the web end                            **/
1522     bool public activated_ = false;
1523     function activate()
1524         onlyOwner(msg.sender)
1525         public
1526     {
1527         // can only be ran once
1528         require(activated_ == false, "IBCLottery already activated");
1529         
1530         // activate the contract 
1531         activated_ = true;
1532         
1533         // lets start first round
1534 		rID_ = 1;
1535         round_.strt = now;
1536         round_.end = now + rndInit_;
1537     }
1538 }
1539 
1540 /**
1541  *   __ _                   _                  
1542  *  / _\ |_ _ __ _   _  ___| |_ _   _ _ __ ___ 
1543  *  \ \| __| '__| | | |/ __| __| | | | '__/ _ \
1544  *  _\ \ |_| |  | |_| | (__| |_| |_| | | |  __/
1545  *  \__/\__|_|   \__,_|\___|\__|\__,_|_|  \___|
1546  * */
1547 
1548 library IBCLotteryDatasets {
1549     struct EventReturns {
1550         address winnerAddr;         // winner address
1551         uint256 amountWon;          // amount won
1552         uint256 newPot;             // amount in new pot
1553         uint256 genAmount;          // amount distributed to gen
1554         uint256 potAmount;          // amount added to pot
1555     }
1556     struct Player {
1557         address addr;   // player address
1558         uint256 win;    // winnings vault
1559         uint256 gen;    // general vault
1560         uint256 aff;    // affiliate vault
1561         uint256 tokenShare; // earning from token share
1562         uint256 lrnd;   // last round played
1563         uint256 laff;   // last affiliate id used
1564         bool ibcRefund;
1565     }
1566     struct PlayerRounds {
1567         uint256 eth;    // eth player has added to round (used for eth limiter)
1568         uint256 keys;   // keys
1569         uint256 mask;   // player mask
1570         bool tokenShareCalc; // if tokenShare value has been migrate.
1571         mapping(uint256 => BoughtRecord) boughtRecord;
1572         uint256 boughtTime;
1573         uint256 genWithdraw;
1574     }
1575     struct Round {
1576         uint256 plyr;   // pID of player in lead
1577         bool firstPlayerIn;
1578         uint256 end;    // time ends/ended
1579         bool ended;     // has round end function been ran
1580         uint256 strt;   // time round started
1581         uint256 keys;   // keys
1582         uint256 eth;    // total eth in
1583         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1584         uint256 mask;   // global mask
1585         uint256 tokenShare; // how many eth user share per token send in.
1586         uint256 firstKeyShare;
1587         uint256 eachKeyCanShare;
1588         uint256 overEarningMask;
1589     }
1590     struct TeamFee {
1591         uint256 gen;    // % of buy in thats paid to key holders of current round
1592     }
1593     struct BoughtRecord {
1594         uint256 lastKey;
1595         uint256 amount;
1596     }
1597 }
1598 
1599 /**
1600  *                       ___      _            _       _   _             
1601  *    /\ /\___ _   _    / __\__ _| | ___ _   _| | __ _| |_(_) ___  _ __  
1602  *   / //_/ _ \ | | |  / /  / _` | |/ __| | | | |/ _` | __| |/ _ \| '_ \ 
1603  *  / __ \  __/ |_| | / /__| (_| | | (__| |_| | | (_| | |_| | (_) | | | |
1604  *  \/  \/\___|\__, | \____/\__,_|_|\___|\__,_|_|\__,_|\__|_|\___/|_| |_|
1605  *             |___/                                                     
1606  * */
1607 library IBCLotteryKeysCalcLong {
1608     using SafeMath for *;
1609     /**
1610      * @dev calculates number of keys received given X eth 
1611      * @param _curEth current amount of eth in contract 
1612      * @param _newEth eth being spent
1613      * @return amount of ticket purchased
1614      */
1615     function keysRec(uint256 _curEth, uint256 _newEth)
1616         internal
1617         pure
1618         returns (uint256)
1619     {
1620         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1621     }
1622     
1623     /**
1624      * @dev calculates amount of eth received if you sold X keys 
1625      * @param _curKeys current amount of keys that exist 
1626      * @param _sellKeys amount of keys you wish to sell
1627      * @return amount of eth received
1628      */
1629     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1630         internal
1631         pure
1632         returns (uint256)
1633     {
1634         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1635     }
1636 
1637     /**
1638      * @dev calculates how many keys would exist with given an amount of eth
1639      * @param _eth eth "in contract"
1640      * @return number of keys that would exist
1641      */
1642     function keys(uint256 _eth) 
1643         internal
1644         pure
1645         returns(uint256)
1646     {
1647         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1648     }
1649     
1650     /**
1651      * @dev calculates how much eth would be in contract given a number of keys
1652      * @param _keys number of keys "in contract" 
1653      * @return eth that would exists
1654      */
1655     function eth(uint256 _keys) 
1656         internal
1657         pure
1658         returns(uint256)  
1659     {
1660         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1661     }
1662 }
1663 
1664 /**
1665  *  __        __                   _   _     
1666  * / _\ __ _ / _| ___  /\/\   __ _| |_| |__  
1667  * \ \ / _` | |_ / _ \/    \ / _` | __| '_ \ 
1668  * _\ \ (_| |  _|  __/ /\/\ \ (_| | |_| | | |
1669  * \__/\__,_|_|  \___\/    \/\__,_|\__|_| |_|
1670  */
1671 library SafeMath {
1672     
1673     /**
1674     * @dev Multiplies two numbers, throws on overflow.
1675     */
1676     function mul(uint256 a, uint256 b) 
1677         internal 
1678         pure 
1679         returns (uint256 c) 
1680     {
1681         if (a == 0) {
1682             return 0;
1683         }
1684         c = a * b;
1685         require(c / a == b, "SafeMath mul failed");
1686         return c;
1687     }
1688 
1689     /**
1690     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1691     */
1692     function sub(uint256 a, uint256 b)
1693         internal
1694         pure
1695         returns (uint256) 
1696     {
1697         require(b <= a, "SafeMath sub failed");
1698         return a - b;
1699     }
1700 
1701     /**
1702     * @dev Adds two numbers, throws on overflow.
1703     */
1704     function add(uint256 a, uint256 b)
1705         internal
1706         pure
1707         returns (uint256 c) 
1708     {
1709         c = a + b;
1710         require(c >= a, "SafeMath add failed");
1711         return c;
1712     }
1713     
1714     /**
1715      * @dev gives square root of given x.
1716      */
1717     function sqrt(uint256 x)
1718         internal
1719         pure
1720         returns (uint256 y) 
1721     {
1722         uint256 z = ((add(x,1)) / 2);
1723         y = x;
1724         while (z < y) 
1725         {
1726             y = z;
1727             z = ((add((x / z),z)) / 2);
1728         }
1729     }
1730     
1731     /**
1732      * @dev gives square. multiplies x by x
1733      */
1734     function sq(uint256 x)
1735         internal
1736         pure
1737         returns (uint256)
1738     {
1739         return (mul(x,x));
1740     }
1741     
1742     /**
1743      * @dev x to the power of y 
1744      */
1745     function pwr(uint256 x, uint256 y)
1746         internal 
1747         pure 
1748         returns (uint256)
1749     {
1750         if (x==0)
1751             return (0);
1752         else if (y==0)
1753             return (1);
1754         else 
1755         {
1756             uint256 z = x;
1757             for (uint256 i=1; i < y; i++)
1758                 z = mul(z,x);
1759             return (z);
1760         }
1761     }
1762 }