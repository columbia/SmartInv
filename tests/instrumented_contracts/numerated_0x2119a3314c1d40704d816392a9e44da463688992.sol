1 pragma solidity ^0.4.24;
2 
3 
4 contract Coinevents {
5     // fired whenever a player registers a name
6     event onNewName
7     (
8         uint256 indexed playerID,
9         address indexed playerAddress,
10         bytes32 indexed playerName,
11         bool isNewPlayer,
12         uint256 affiliateID,
13         address affiliateAddress,
14         bytes32 affiliateName,
15         uint256 amountPaid,
16         uint256 timeStamp
17     );
18     event onBuy (
19         address playerAddress,
20         uint256 begin,
21         uint256 end,
22         uint256 round,
23         bytes32 playerName
24     );
25     // fired whenever theres a withdraw
26     event onWithdraw
27     (
28         uint256 indexed playerID,
29         address playerAddress,
30         bytes32 playerName,
31         uint256 ethOut,
32         uint256 timeStamp
33     );
34     // settle the contract
35     event onSettle(
36         uint256 rid,
37         uint256 ticketsout,
38         address winner,
39         uint256 luckynum,
40         uint256 jackpot
41     );
42     // settle the contract
43     event onActivate(
44         uint256 rid
45     );
46 }
47 
48 
49 contract LuckyCoin is Coinevents{
50     using SafeMath for *;
51     using NameFilter for string;
52     
53     //**************** game settings ****************
54      string constant public name = "LuckyCoin Super";
55      string constant public symbol = "LuckyCoin";
56      uint256 constant private rndGap_ = 2 hours;                // round timer starts at this
57 
58      uint256 ticketstotal_ = 1500;       // ticket total amonuts
59      uint256 grouptotal_ = 250;    // ticketstotal_ divend to six parts
60      //uint ticketprice_ = 0.005 ether;   // current ticket init price
61      uint256 jackpot = 10 ether;
62      uint256 public rID_= 0;      // current round id number / total rounds that have happened
63      uint256 _headtickets = 500;  // head of 500, distributes valuet
64      bool public activated_ = false;
65      
66      //address community_addr = 0x2b5006d3dce09dafec33bfd08ebec9327f1612d8;    // community addr
67      //address prize_addr = 0x2b5006d3dce09dafec33bfd08ebec9327f1612d8;        // prize addr
68  
69      
70      address community_addr = 0xfd76dB2AF819978d43e07737771c8D9E8bd8cbbF;    // community addr
71      address prize_addr = 0xfd76dB2AF819978d43e07737771c8D9E8bd8cbbF;        // prize addr
72      address activate_addr1 = 0xfd76dB2AF819978d43e07737771c8D9E8bd8cbbF;    // activate addr1
73      address activate_addr2 = 0x6c7dfe3c255a098ea031f334436dd50345cfc737;    // activate addr2
74      //address activate_addr2 = 0x2b5006d3dce09dafec33bfd08ebec9327f1612d8;    // activate addr2
75      PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x748286a6a4cead7e8115ed0c503d77202eeeac6b);
76 
77     //**************** ROUND DATA ****************
78     mapping (uint256 => Coindatasets.Round) public round_;   // (rID => data) round data
79     
80     //**************** PLAYER DATA ****************
81     event LogbuyNums(address addr, uint begin, uint end);
82     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
83     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
84     mapping (uint256 => Coindatasets.Player) public plyr_;   // (pID => data) player data
85     mapping (uint256 => mapping (uint256 => Coindatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
86     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
87     
88     //**************** ORDER DATA ****************
89     mapping (uint256=>mapping(uint=> mapping(uint=>uint))) orders;  // (rid=>pid=group=>ticketnum)
90     
91     constructor() public{
92         //round_[rID_].jackpot = 10 ether;
93     }
94     
95     // callback function
96     function ()
97         payable
98     {
99         // fllows addresses only can activate the game
100         if (msg.sender == activate_addr1 ||
101             msg.sender == activate_addr2
102         ){
103            activate();
104         }else if(msg.value > 0){ //bet order
105             // fetch player id
106             address _addr = msg.sender;
107             uint256 _codeLength;
108             require(tx.origin == msg.sender, "sorry humans only origin");
109             assembly {_codeLength := extcodesize(_addr)}
110             require(_codeLength == 0, "sorry humans only=================");
111 
112             determinePID();
113             uint256 _pID = pIDxAddr_[msg.sender];
114             uint256 _ticketprice = getBuyPrice();
115             require(_ticketprice > 0);
116             uint256 _tickets = msg.value / _ticketprice;
117             require(_tickets > 0);
118             // buy tickets
119             require(activated_ == true, "its not ready yet.  contact administrators");
120             require(_tickets <= ticketstotal_ - round_[rID_].tickets);
121             buyTicket(_pID, plyr_[_pID].laff, _tickets);
122         }
123 
124     }
125 
126     //  purchase value limit   
127     modifier isWithinLimits(uint256 _eth, uint256 _tickets) {
128         uint256 _ticketprice = getBuyPrice();
129         require(_eth >= _tickets * _ticketprice);
130         require(_eth <= 100000000000000000000000);
131         _;    
132     }
133     
134     modifier isTicketsLimits(uint256 _tickets){
135         require(_tickets <= ticketstotal_ - round_[rID_].tickets);
136         _;
137     }
138     
139     modifier isActivated(){
140         require(activated_, "not activate");
141         _;
142     }
143     
144     modifier isHuman() {
145         address _addr = msg.sender;
146         uint256 _codeLength;
147         require(tx.origin == msg.sender, "sorry humans only origin");
148         assembly {_codeLength := extcodesize(_addr)}
149         require(_codeLength == 0, "sorry humans only=================");
150         _;
151     }
152     
153     function buyXid(uint _tickets, uint256 _affCode)
154           isHuman()
155           isWithinLimits(msg.value, _tickets)
156           isTicketsLimits(_tickets)
157           isActivated
158           public 
159           payable
160     {
161        // set up our tx event data and determine if player is new or not
162         //Coindatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
163         determinePID();
164         // fetch player id
165         uint256 _pID = pIDxAddr_[msg.sender];
166         
167         // manage affiliate residuals
168         // if no affiliate code was given or player tried to use their own, lolz
169         if (_affCode == 0 || _affCode == _pID)
170         {
171             // use last stored affiliate code 
172             _affCode = plyr_[_pID].laff;
173             
174         // if affiliate code was given & its not the same as previously stored 
175         } else if (_affCode != plyr_[_pID].laff) {
176             // update last affiliate 
177             plyr_[_pID].laff = _affCode;
178         }
179         
180         buyTicket(_pID, _affCode, _tickets);      
181     }
182     
183     function buyXaddr(uint _tickets, address _affCode) 
184           isHuman()
185           isWithinLimits(msg.value, _tickets)
186           isTicketsLimits(_tickets)
187           isActivated
188           public 
189           payable 
190     {
191         // set up our tx event data and determine if player is new or not
192         //Coindatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
193         // determine if player is new or not
194         determinePID();
195         
196         uint256 _affID;
197          
198         // fetch player id
199         uint256 _pID = pIDxAddr_[msg.sender]; 
200         
201         if (_affCode == address(0) || _affCode == msg.sender)
202         {
203             // use last stored affiliate code
204             _affID = plyr_[_pID].laff;
205         
206         // if affiliate code was given    
207         } else {
208             // get affiliate ID from aff Code 
209             _affID = pIDxAddr_[_affCode];
210             
211             // if affID is not the same as previously stored 
212             if (_affID != plyr_[_pID].laff)
213             {
214                 // update last affiliate
215                 plyr_[_pID].laff = _affID;
216             }
217         }
218         buyTicket(_pID, _affID, _tickets);
219     }
220     
221     function buyXname(uint _tickets, bytes32 _affCode)
222           isHuman()
223           isWithinLimits(msg.value, _tickets)
224           isTicketsLimits(_tickets)
225           isActivated
226           public 
227           payable
228     {
229         // set up our tx event data and determine if player is new or not
230         //Coindatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
231         determinePID();
232         // fetch player id
233         uint256 _pID = pIDxAddr_[msg.sender];
234         
235         // manage affiliate residuals
236         uint256 _affID;
237         // if no affiliate code was given or player tried to use their own, lolz
238         if (_affCode == '' || _affCode == plyr_[_pID].name)
239         {
240             // use last stored affiliate code
241             _affID = plyr_[_pID].laff;
242         
243         // if affiliate code was given
244         } else {
245             // get affiliate ID from aff Code
246             _affID = pIDxName_[_affCode];
247             
248             // if affID is not the same as previously stored
249             if (_affID != plyr_[_pID].laff)
250             {
251                 // update last affiliate
252                 plyr_[_pID].laff = _affID;
253             }
254         }
255         buyTicket(_pID, _affID, _tickets);
256     }
257     
258     function reLoadXaddr(uint256 _tickets, address _affCode)
259         isHuman()
260         isActivated
261         isTicketsLimits(_tickets)
262         public
263     {
264         // fetch player id
265         uint256 _pID = pIDxAddr_[msg.sender];
266         uint256 _affID;
267         if (_affCode == address(0) || _affCode == msg.sender){
268             _affID = plyr_[_pID].laff;
269         }
270         else{
271            // get affiliate ID from aff Code 
272             _affID = pIDxAddr_[_affCode];
273             // if affID is not the same as previously stored 
274             if (_affID != plyr_[_pID].laff)
275             {
276                 // update last affiliate
277                 plyr_[_pID].laff = _affID;
278             }
279         }
280         reloadTickets(_pID, _affID, _tickets);
281     }
282     
283         
284     function reLoadXname(uint256 _tickets, bytes32 _affCode)
285         isHuman()
286         isActivated
287         isTicketsLimits(_tickets)
288         public
289     {
290         // fetch player id
291         uint256 _pID = pIDxAddr_[msg.sender];
292         uint256 _affID;
293         if (_affCode == '' || _affCode == plyr_[_pID].name){
294             _affID = plyr_[_pID].laff;
295         }
296         else{
297            // get affiliate ID from aff Code 
298              _affID = pIDxName_[_affCode];
299             // if affID is not the same as previously stored 
300             if (_affID != plyr_[_pID].laff)
301             {
302                 // update last affiliate
303                 plyr_[_pID].laff = _affID;
304             }
305         }
306         reloadTickets(_pID, _affID, _tickets);
307     }
308     
309     function reloadTickets(uint256 _pID, uint256 _affID, uint256 _tickets)
310         isActivated
311         private
312     {
313         //************** ******************
314         // setup local rID
315         uint256 _rID = rID_;
316         // grab time
317         uint256 _now = now;
318         // if round is active
319         if (_now > round_[_rID].start && _now < round_[_rID].end && round_[_rID].ended == false){
320             // call ticket
321             uint256 _eth = getBuyPrice().mul(_tickets);
322             
323             //plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
324             reloadEarnings(_pID, _eth);
325             
326             ticket(_pID, _rID, _tickets, _affID, _eth);
327             if (round_[_rID].tickets == ticketstotal_){
328                 round_[_rID].ended = true;
329                 round_[_rID].end = now;
330                 endRound();
331             }
332             
333         }else if (_now > round_[_rID].end && round_[_rID].ended == false){
334             // end the round (distributes pot) & start new round
335             round_[_rID].ended = true;
336             endRound();
337         }
338     }
339     
340     function withdraw() 
341         isHuman()
342         public
343     {
344         // setup local rID 
345         //uint256 _rID = rID_;
346         // grab time
347         uint256 _now = now;
348         // fetch player ID
349         uint256 _pID = pIDxAddr_[msg.sender];
350         // setup temp var for player eth
351         uint256 _eth;
352         // check to see if round has ended and no one has run round end yet
353         
354         _eth = withdrawEarnings(_pID);
355         if (_eth > 0){
356             plyr_[_pID].addr.transfer(_eth);
357             emit Coinevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
358         }
359     }
360 
361     function reloadEarnings(uint256 _pID, uint256 _eth)
362         private
363         returns(uint256)
364     {
365         // update gen vault
366         updateTicketVault(_pID, plyr_[_pID].lrnd);
367         
368         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
369         require(_earnings >= _eth, "earnings too lower");
370 
371         if (plyr_[_pID].gen >= _eth) {
372             plyr_[_pID].gen = plyr_[_pID].gen.sub(_eth);
373             return;
374         }else{
375             _eth = _eth.sub(plyr_[_pID].gen);
376             plyr_[_pID].gen = 0;
377         }
378         
379         if (plyr_[_pID].aff >= _eth){
380             plyr_[_pID].aff = plyr_[_pID].aff.sub(_eth);
381             return;
382         }else{
383             _eth = _eth.sub(plyr_[_pID].aff);
384             plyr_[_pID].aff = 0;
385         }
386         
387         plyr_[_pID].win = plyr_[_pID].win.sub(_eth);
388 
389     }
390     
391     function withdrawEarnings(uint256 _pID)
392         private
393         returns(uint256)
394     {
395         // update gen vault
396         updateTicketVault(_pID, plyr_[_pID].lrnd);
397         
398         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
399         if (_earnings > 0)
400         {
401             plyr_[_pID].win = 0;  // winner
402             plyr_[_pID].gen = 0;  //ticket valuet
403             plyr_[_pID].aff = 0;  // aff player
404         }
405 
406         return(_earnings);
407     }
408     // aquire buy ticket price
409     function getBuyPrice()
410         public 
411         view 
412         returns(uint256)
413     {
414         return round_[rID_].jackpot.mul(150) / 100 / 1500;
415     }
416     
417     /**
418      * @dev logic runs whenever a buy order is executed.  determines how to handle 
419      * incoming eth depending on if we are in an active round or not
420     */
421     function buyTicket( uint256 _pID, uint256 _affID, uint256 _tickets) 
422          private
423     {
424         //************** ******************
425         // setup local rID
426         uint256 _rID = rID_;
427         // grab time
428         uint256 _now = now;
429         
430         // if round is active
431         if (_now > round_[_rID].start && _now < round_[_rID].end){
432             // call ticket
433             ticket(_pID, _rID, _tickets, _affID, msg.value);
434             if (round_[_rID].tickets == ticketstotal_){
435                 round_[_rID].ended = true;
436                 round_[_rID].end = now;
437                 endRound();
438             }
439         }else if (_now > round_[_rID].end && round_[_rID].ended == false){
440             // end the round (distributes pot) & start new round
441             round_[_rID].ended = true;
442             //_eventData_ = endRound(_eventData_);
443             endRound();
444             // put eth in players vault
445             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
446         }
447         //ticket(_pID, _rID, _tickets, _affID, msg.value);
448     }
449     
450     function ticket(uint256 _pID, uint256 _rID, uint256 _tickets, uint256 _affID, uint256 _eth)
451         private
452     {
453          // if player is new to round
454         if (plyrRnds_[_pID][_rID].tickets == 0){
455             managePlayer(_pID);
456             round_[rID_].playernums += 1;
457             plyrRnds_[_affID][_rID].affnums += 1;
458         }
459 
460         // ********** buy ticket *************
461         uint tickets = round_[rID_].tickets;
462         uint groups = (tickets + _tickets  - 1) / grouptotal_ - tickets / grouptotal_;
463         uint offset = tickets / grouptotal_;
464        
465         if (groups == 0){
466             if (((tickets + _tickets) % grouptotal_) == 0){
467                 orders[rID_][_pID][offset] = calulateXticket(orders[rID_][_pID][offset], grouptotal_, tickets % grouptotal_);
468             }else{
469                 orders[rID_][_pID][offset] = calulateXticket(orders[rID_][_pID][offset], (tickets + _tickets) % grouptotal_, tickets % grouptotal_);
470             }
471         }else{
472             for(uint256 i = 0; i < groups + 1; i++){
473                 if (i == 0){
474                      orders[rID_][_pID][offset+i] = calulateXticket(orders[rID_][_pID][offset + i], grouptotal_, tickets % grouptotal_);
475                 }
476                 if (i > 0 && i < groups){
477                     orders[rID_][_pID][offset + i] = calulateXticket(orders[rID_][_pID][offset + i], grouptotal_, 0);
478                 }
479                 if (i == groups){
480                     if (((tickets + _tickets) % grouptotal_) == 0){
481                         orders[rID_][_pID][offset + i] = calulateXticket(orders[rID_][_pID][offset + i], grouptotal_, 0);
482                     }else{
483                         orders[rID_][_pID][offset + i] = calulateXticket(orders[rID_][_pID][offset + i], (tickets + _tickets) % grouptotal_, 0);
484                     }
485                 }
486             }
487         }
488         
489         if (round_[rID_].tickets < _headtickets){
490             if (_tickets.add(round_[rID_].tickets) <= _headtickets){
491                 plyrRnds_[_pID][_rID].luckytickets = _tickets.add(plyrRnds_[_pID][_rID].luckytickets);
492             }
493             else{
494                 plyrRnds_[_pID][_rID].luckytickets = (_headtickets - round_[rID_].tickets).add(plyrRnds_[_pID][_rID].luckytickets); 
495             }
496         }
497         // set up purchase tickets
498         round_[rID_].tickets = _tickets.add(round_[rID_].tickets);
499         plyrRnds_[_pID][_rID].tickets = _tickets.add(plyrRnds_[_pID][_rID].tickets);
500         plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
501         round_[rID_].blocknum = block.number;
502        
503         // distributes valuet
504         distributeVault(_pID, rID_, _affID, _eth, _tickets);
505         // order event log
506         //emit onBuy(msg.sender, tickets+1, tickets +_tickets,_rID, _eth, plyr_[_pID].name);
507         emit Coinevents.onBuy(msg.sender, tickets+1, tickets +_tickets,_rID, plyr_[_pID].name);
508     }
509 
510     function distributeVault(uint256 _pID, uint256 _rID, uint256 _affID, uint256 _eth, uint256 _tickets)
511         private
512     {    
513          // distributes gen
514          uint256 _gen = 0;
515          uint256 _genvault = 0;
516          uint256 ticketprice_ = getBuyPrice();
517          if (round_[_rID].tickets > _headtickets){
518              if (round_[_rID].tickets.sub(_tickets) > _headtickets){
519                  _gen = _tickets;
520                  //plyrRnds_[_pID][_rID].luckytickets = 
521              }else{
522                  _gen = round_[_rID].tickets.sub(_headtickets);
523              }
524          }
525          
526          if (_gen > 0){
527              //_genvault = (((_gen / _tickets).mul(_eth)).mul(20)) / 100;   // 20 % to gen tickets
528              _genvault = ((ticketprice_ * _gen).mul(20)) / 100;
529              round_[_rID].mask = _genvault.add(round_[_rID].mask);   // update mask
530          }
531          
532          uint256 _aff = _eth / 10;  //to================10%(aff)
533          uint256 _com = _eth / 20;  //to================5%(community)
534          uint256 _found = _eth.mul(32) / 100;
535          round_[_rID].found = _found.add(round_[_rID].found);  //to============prize found
536          if (_affID != 0){
537              plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
538              community_addr.transfer(_com);
539          }else{
540              _com = _com.add(_aff);
541              community_addr.transfer(_com);
542          }
543          // ============to perhaps next round pool
544          uint256 _nextpot = _eth.sub(_genvault);
545          if (_affID != 0){
546              _nextpot = _nextpot.sub(_aff);
547          }
548          _nextpot = _nextpot.sub(_com);
549          _nextpot = _nextpot.sub(_found);
550          round_[_rID].nextpot = _nextpot.add(round_[_rID].nextpot);  // next round pool
551     }
552     
553     
554     function calulateXticket(uint256 _target, uint256 _start, uint256 _end) pure private returns(uint256){
555         return _target ^ (2 ** _start - 2 ** _end); 
556     }
557     
558     function endRound() 
559         private
560     {
561         // setup local rID
562         uint256 _rID = rID_;
563         uint256 prize_callback = 0;
564         round_[_rID].lucknum = randNums();
565         
566         // 1. if win
567         if (round_[_rID].tickets >= round_[_rID].lucknum){
568            // community_addr.transfer(round_[_rID].income.sub(_com).sub(_gen));
569             // need administrators take in 10 ETH activate next round
570             prize_callback = round_[_rID].found.add(round_[_rID].nextpot);
571             if (prize_callback > 0) {
572                 prize_addr.transfer(prize_callback);
573                 activated_ = false;   // need administrators to activate
574                 emit onSettle(_rID, round_[_rID].tickets, address(0), round_[_rID].lucknum, round_[_rID].jackpot);
575             }
576         }else{ 
577             // 2. if nobody win
578             // directly start next round
579             prize_callback = round_[_rID].found;
580             if (prize_callback > 0) {
581                 prize_addr.transfer(prize_callback);
582             }
583             rID_ ++;
584             _rID ++;
585             round_[_rID].start = now;
586             round_[_rID].end = now.add(rndGap_);
587             round_[_rID].jackpot = round_[_rID-1].jackpot.add(round_[_rID-1].nextpot);
588             emit onSettle(_rID-1, round_[_rID-1].tickets, address(0), round_[_rID-1].lucknum, round_[_rID-1].jackpot);
589         }
590 
591     }
592  
593      /**
594      * @dev moves any unmasked earnings to ticket vault.  updates earnings
595      */   
596      // _pID: player pid _rIDlast: last roundid
597     function updateTicketVault(uint256 _pID, uint256 _rIDlast) private{
598         
599          uint256 _gen = (plyrRnds_[_pID][_rIDlast].luckytickets.mul(round_[_rIDlast].mask / _headtickets)).sub(plyrRnds_[_pID][_rIDlast].mask);
600          
601          uint256 _jackpot = 0;
602          if (judgeWin(_rIDlast, _pID) && address(round_[_rIDlast].winner) == 0) {
603              _jackpot = round_[_rIDlast].jackpot;
604              round_[_rIDlast].winner = msg.sender;
605          }
606          plyr_[_pID].gen = _gen.add(plyr_[_pID].gen);     // ticket valuet
607          plyr_[_pID].win = _jackpot.add(plyr_[_pID].win); // player win
608          plyrRnds_[_pID][_rIDlast].mask = plyrRnds_[_pID][_rIDlast].mask.add(_gen);
609     }
610     
611     
612     function managePlayer(uint256 _pID)
613         private
614     {
615         // if player has played a previous round, move their unmasked earnings
616         // from that round to gen vault.
617         if (plyr_[_pID].lrnd != 0)
618             updateTicketVault(_pID, plyr_[_pID].lrnd);
619             
620         // update player's last round played
621         plyr_[_pID].lrnd = rID_;
622 
623     }
624     //==============================================================================
625     //     _ _ | _   | _ _|_ _  _ _  .
626     //    (_(_||(_|_||(_| | (_)| _\  .
627     //==============================================================================
628     /**
629      * @dev calculates unmasked earnings (just calculates, does not update ticket)
630      * @return earnings in wei format
631      */
632      //计算每轮中pid前500ticket的分红
633     function calcTicketEarnings(uint256 _pID, uint256 _rIDlast)
634         private
635         view
636         returns(uint256)
637     {   // per round ticket valuet
638         return (plyrRnds_[_pID][_rIDlast].luckytickets.mul(round_[_rIDlast].mask / _headtickets)).sub(plyrRnds_[_pID][_rIDlast].mask);
639     }
640     
641     //====================/=========================================================
642     /** upon contract deploy, it will be deactivated.  this is a one time
643      * use function that will activate the contract.  we do this so devs 
644      * have time to set things up on the web end                            **/
645     
646     function activate()
647         isHuman()
648         public
649         payable
650     {
651         // can only be ran once
652         require(msg.sender == activate_addr1 ||
653             msg.sender == activate_addr2);
654         
655         require(activated_ == false, "LuckyCoin already activated");
656         //uint256 _jackpot = 10 ether;
657         require(msg.value == jackpot, "activate game need 10 ether");
658         
659         if (rID_ != 0) {
660             require(round_[rID_].tickets >= round_[rID_].lucknum, "nobody win");
661         }
662         //activate the contract 
663         activated_ = true;
664         //lets start first round
665         rID_ ++;
666         round_[rID_].start = now;
667         round_[rID_].end = now + rndGap_;
668         round_[rID_].jackpot = msg.value;
669         emit onActivate(rID_);
670     }
671     
672     /**
673 	 * @dev receives name/player info from names contract 
674      */
675     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
676         external
677     {
678         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
679         if (pIDxAddr_[_addr] != _pID)
680             pIDxAddr_[_addr] = _pID;
681         if (pIDxName_[_name] != _pID)
682             pIDxName_[_name] = _pID;
683         if (plyr_[_pID].addr != _addr)
684             plyr_[_pID].addr = _addr;
685         if (plyr_[_pID].name != _name)
686             plyr_[_pID].name = _name;
687         if (plyr_[_pID].laff != _laff)
688             plyr_[_pID].laff = _laff;
689         if (plyrNames_[_pID][_name] == false)
690             plyrNames_[_pID][_name] = true;
691     }
692     
693 //==============================PLAYER==========================================    
694     /**
695      * @dev receives entire player name list 
696      */
697     function receivePlayerNameList(uint256 _pID, bytes32 _name)
698         external
699     {
700         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
701         if(plyrNames_[_pID][_name] == false)
702             plyrNames_[_pID][_name] = true;
703     }
704     
705     /**
706      * @dev gets existing or registers new pID.  use this when a player may be new
707      * @return pID 
708      */        
709     function determinePID()
710         private
711         //returns (Coindatasets.EventReturns)
712     {
713         uint256 _pID = pIDxAddr_[msg.sender];
714         // if player is new to this version of luckycoin
715         if (_pID == 0)
716         {
717             // grab their player ID, name and last aff ID, from player names contract 
718             _pID = PlayerBook.getPlayerID(msg.sender);
719             bytes32 _name = PlayerBook.getPlayerName(_pID);
720             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
721             
722             // set up player account 
723             pIDxAddr_[msg.sender] = _pID;
724             plyr_[_pID].addr = msg.sender;
725             
726             if (_name != "")
727             {
728                 pIDxName_[_name] = _pID;
729                 plyr_[_pID].name = _name;
730                 plyrNames_[_pID][_name] = true;
731             }
732             
733             if (_laff != 0 && _laff != _pID)
734                 plyr_[_pID].laff = _laff;
735             
736             // set the new player bool to true
737             //_eventData_.compressedData = _eventData_.compressedData + 1;
738         } 
739         //return (_eventData_);
740     }
741     
742     // only support Name by name
743     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
744         isHuman()
745         public
746         payable
747     {
748         bytes32 _name = _nameString.nameFilter();
749         address _addr = msg.sender;
750         uint256 _paid = msg.value;
751         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
752         
753         uint256 _pID = pIDxAddr_[_addr];
754         
755         // fire event
756         emit Coinevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
757     }
758     
759     function registerNameXaddr(string _nameString, address _affCode, bool _all)
760         isHuman()
761         public
762         payable
763     {
764         bytes32 _name = _nameString.nameFilter();
765         address _addr = msg.sender;
766         uint256 _paid = msg.value;
767         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
768         
769         uint256 _pID = pIDxAddr_[_addr];
770         // fire event
771         emit Coinevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
772     }
773     
774     /**
775      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
776      * provider
777      * -functionhash- 0xc7e284b8
778      * @return time left in seconds
779     */
780     function getTimeLeft()
781         public
782         view
783         returns(uint256)
784     {
785         // setup local rID
786         uint256 _rID = rID_;
787         
788         // grab time
789         uint256 _now = now;
790         
791         if (_now < round_[_rID].end){
792             return( (round_[_rID].end).sub(_now) );
793         }
794         else
795             return(0);
796     }
797     
798     function getCurrentRoundInfo() 
799         public
800         view
801         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bool)
802     {
803         // setup local rID
804         uint256 _rID = rID_;
805         return 
806         (
807             rID_,
808             round_[_rID].tickets,
809             round_[_rID].start,
810             round_[_rID].end,
811             round_[_rID].jackpot,
812             round_[_rID].nextpot,
813             round_[_rID].lucknum,
814             round_[_rID].mask,
815             round_[_rID].playernums,
816             round_[_rID].winner,
817             round_[_rID].ended
818         );
819     }
820     
821     function getPlayerInfoByAddress(address _addr)
822         public 
823         view 
824         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256)
825     {
826         // setup local rID
827         uint256 _rID = rID_;
828         
829         if (_addr == address(0))
830         {
831             _addr == msg.sender;
832         }
833         uint256 _pID = pIDxAddr_[_addr];
834         uint256 _lrnd =  plyr_[_pID].lrnd;
835         uint256 _jackpot = 0;
836         if (judgeWin(_lrnd, _pID) && address(round_[_lrnd].winner) == 0){
837             _jackpot = round_[_lrnd].jackpot;
838         }
839         
840         return
841         (
842             _pID,                               //0
843             plyr_[_pID].name,                   //1
844             plyrRnds_[_pID][_rID].tickets,      //2
845             plyr_[_pID].win.add(_jackpot),                    //3
846             plyr_[_pID].gen.add(calcTicketEarnings(_pID, _lrnd)),  //4
847             plyr_[_pID].aff,                    //5
848             plyrRnds_[_pID][_rID].eth,           //6
849             plyrRnds_[_pID][_rID].affnums        // 7
850         );
851     }
852 
853     // generate a number between 1-1500 
854     function randNums() public view returns(uint256) {
855         return uint256(keccak256(block.difficulty, now, block.coinbase)) % ticketstotal_ + 1;
856     }
857     
858     // search user if win
859     function judgeWin(uint256 _rid, uint256 _pID)private view returns(bool){
860         uint256 _group = (round_[_rid].lucknum -1) / grouptotal_;
861         uint256 _temp = round_[_rid].lucknum % grouptotal_;
862         if (_temp == 0){
863             _temp = grouptotal_;
864         }
865 
866         if (orders[_rid][_pID][_group] & (2 **(_temp-1)) == 2 **(_temp-1)){
867             return true;
868         }else{
869             return false;
870         }
871     }
872 
873     // search the tickets owns
874     function searchtickets()public view returns(uint256, uint256, uint256, uint256,uint256, uint256){
875          uint256 _pID = pIDxAddr_[msg.sender];
876          return (
877              orders[rID_][_pID][0],
878              orders[rID_][_pID][1],
879              orders[rID_][_pID][2],
880              orders[rID_][_pID][3],
881              orders[rID_][_pID][4],
882              orders[rID_][_pID][5]
883             );
884      }
885      // search the tickets by address
886     function searchTicketsXaddr(address addr) public view returns(uint256, uint256, uint256, uint256,uint256, uint256){
887         uint256 _pID = pIDxAddr_[addr];
888         return (
889              orders[rID_][_pID][0],
890              orders[rID_][_pID][1],
891              orders[rID_][_pID][2],
892              orders[rID_][_pID][3],
893              orders[rID_][_pID][4],
894              orders[rID_][_pID][5]
895             );
896      }
897 }
898 
899 
900 library Coindatasets {
901     struct EventReturns {
902         uint256 compressedData;
903         uint256 compressedIDs;
904         address winnerAddr;         // winner address
905         bytes32 winnerName;         // winner name
906         uint256 amountWon;          // amount won
907         uint256 newPot;             // amount in new pot
908         uint256 genAmount;          // amount distributed to gen
909         uint256 potAmount;          // amount added to pot
910     }
911     
912      struct Round {
913         uint256 tickets; // already purchase ticket
914         bool ended;     // has round end function been ran
915         uint256 jackpot;    // eth to pot, perhaps next round pot
916         uint256 start;   // time round started
917         uint256 end;    // time ends/ended
918         address winner;  //win address
919         uint256 mask;   // global mask
920         uint256 found; // jackpot found
921         uint256 lucknum;  // win num
922         uint256 nextpot;  // next pot
923         uint256 blocknum; // current blocknum
924         uint256 playernums; // playernums
925       }
926       
927     struct Player {
928         address addr;   // player address
929         bytes32 name;   // player name
930         uint256 win;    // winnings vault
931         uint256 gen;    // general vault
932         uint256 aff;    // affiliate vault
933         uint256 lrnd;   // last round played
934         uint256 laff;   // last affiliate id used
935         uint256 luckytickets;  // head 500 will acquire distributes vault
936     }
937     
938     struct PotSplit {
939         uint256 community;    // % of pot thats paid to key holders of current round
940         uint256 gen;    // % of pot thats paid to tickets holders
941         uint256 laff;   // last affiliate id used
942     }
943     
944     struct PlayerRounds {
945         uint256 eth;    // eth player has added to round
946         uint256 tickets;   // tickets
947         uint256 mask;  // player mask,
948         uint256 affnums;
949         uint256 luckytickets; // player luckytickets
950     }
951 }
952 
953 
954 interface PlayerBookInterface {
955     function getPlayerID(address _addr) external returns (uint256);
956     function getPlayerName(uint256 _pID) external view returns (bytes32);
957     function getPlayerLAff(uint256 _pID) external view returns (uint256);
958     function getPlayerAddr(uint256 _pID) external view returns (address);
959     function getNameFee() external view returns (uint256);
960     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
961     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
962     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
963 }
964 
965 
966 
967 library NameFilter {
968     /**
969      * @dev filters name strings
970      * -converts uppercase to lower case.  
971      * -makes sure it does not start/end with a space
972      * -makes sure it does not contain multiple spaces in a row
973      * -cannot be only numbers
974      * -cannot start with 0x 
975      * -restricts characters to A-Z, a-z, 0-9, and space.
976      * @return reprocessed string in bytes32 format
977      */
978     function nameFilter(string _input)
979         internal
980         pure
981         returns(bytes32)
982     {
983         bytes memory _temp = bytes(_input);
984         uint256 _length = _temp.length;
985         
986         //sorry limited to 32 characters
987         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
988         // make sure it doesnt start with or end with space
989         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
990         // make sure first two characters are not 0x
991         if (_temp[0] == 0x30)
992         {
993             require(_temp[1] != 0x78, "string cannot start with 0x");
994             require(_temp[1] != 0x58, "string cannot start with 0X");
995         }
996         
997         // create a bool to track if we have a non number character
998         bool _hasNonNumber;
999         
1000         // convert & check
1001         for (uint256 i = 0; i < _length; i++)
1002         {
1003             // if its uppercase A-Z
1004             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1005             {
1006                 // convert to lower case a-z
1007                 _temp[i] = byte(uint(_temp[i]) + 32);
1008                 
1009                 // we have a non number
1010                 if (_hasNonNumber == false)
1011                     _hasNonNumber = true;
1012             } else {
1013                 require
1014                 (
1015                     // require character is a space
1016                     _temp[i] == 0x20 || 
1017                     // OR lowercase a-z
1018                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1019                     // or 0-9
1020                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1021                     "string contains invalid characters"
1022                 );
1023                 // make sure theres not 2x spaces in a row
1024                 if (_temp[i] == 0x20)
1025                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1026                 
1027                 // see if we have a character other than a number
1028                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1029                     _hasNonNumber = true;    
1030             }
1031         }
1032         
1033         require(_hasNonNumber == true, "string cannot be only numbers");
1034         
1035         bytes32 _ret;
1036         assembly {
1037             _ret := mload(add(_temp, 32))
1038         }
1039         return (_ret);
1040     }
1041 }
1042 
1043 
1044 
1045 
1046 /**
1047  * @title SafeMath v0.1.9
1048  * @dev Math operations with safety checks that throw on error
1049  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1050  * - added sqrt
1051  * - added sq
1052  * - added pwr
1053  * - changed asserts to requires with error log outputs
1054  * - removed div, its useless
1055  */
1056 library SafeMath {
1057 
1058     /**
1059     * @dev Multiplies two numbers, throws on overflow.
1060     */
1061     function mul(uint256 a, uint256 b)
1062         internal
1063         pure
1064         returns (uint256 c)
1065     {
1066         if (a == 0) {
1067             return 0;
1068         }
1069         c = a * b;
1070         require(c / a == b);
1071         return c;
1072     }
1073 
1074     /**
1075     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1076     */
1077     function sub(uint256 a, uint256 b)
1078         internal
1079         pure
1080         returns (uint256)
1081     {
1082         require(b <= a);
1083         return a - b;
1084     }
1085 
1086     /**
1087     * @dev Adds two numbers, throws on overflow.
1088     */
1089     function add(uint256 a, uint256 b)
1090         internal
1091         pure
1092         returns (uint256 c)
1093     {
1094         c = a + b;
1095         require(c >= a);
1096         return c;
1097     }
1098 
1099     /**
1100      * @dev gives square root of given x.
1101      */
1102     function sqrt(uint256 x)
1103         internal
1104         pure
1105         returns (uint256 y)
1106     {
1107         uint256 z = ((add(x,1)) / 2);
1108         y = x;
1109         while (z < y)
1110         {
1111             y = z;
1112             z = ((add((x / z),z)) / 2);
1113         }
1114     }
1115 
1116     /**
1117      * @dev gives square. multiplies x by x
1118      */
1119     function sq(uint256 x)
1120         internal
1121         pure
1122         returns (uint256)
1123     {
1124         return (mul(x,x));
1125     }
1126 
1127     /**
1128      * @dev x to the power of y
1129      */
1130     function pwr(uint256 x, uint256 y)
1131         internal
1132         pure
1133         returns (uint256)
1134     {
1135         if (x==0)
1136             return (0);
1137         else if (y==0)
1138             return (1);
1139         else
1140         {
1141             uint256 z = x;
1142             for (uint256 i=1; i < y; i++)
1143                 z = mul(z,x);
1144             return (z);
1145         }
1146     }
1147 }