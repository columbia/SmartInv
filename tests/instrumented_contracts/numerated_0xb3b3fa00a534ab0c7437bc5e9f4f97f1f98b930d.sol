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
57      //uint256 constant private rndGap_ = 5 minutes;
58 
59      uint256 ticketstotal_ = 1500;       // ticket total amonuts
60      uint256 grouptotal_ = 250;    // ticketstotal_ divend to six parts
61      //uint ticketprice_ = 0.005 ether;   // current ticket init price
62      uint256 jackpot = 10 ether;
63      uint256 public rID_= 0;      // current round id number / total rounds that have happened
64      uint256 _headtickets = 500;  // head of 500, distributes valuet
65      bool public activated_ = false;
66      
67      //address community_addr = 0x2b5006d3dce09dafec33bfd08ebec9327f1612d8;    // community addr
68      //address prize_addr = 0x2b5006d3dce09dafec33bfd08ebec9327f1612d8;        // prize addr
69  
70      
71      address community_addr = 0x180A14aF38384dc15Ce96cbcabCfC8F47794AC3E;    // community addr
72      address prize_addr = 0x180A14aF38384dc15Ce96cbcabCfC8F47794AC3E;        // prize addr
73      address activate_addr2 = 0x180A14aF38384dc15Ce96cbcabCfC8F47794AC3E;    // activate addr2
74      address activate_addr1 = 0x6C7DFE3c255a098Ea031f334436DD50345cFC737;    // activate addr1
75      PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xc87a693dbba31aefb9457683b7d245dad756db88);
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
100         if (
101             msg.sender == activate_addr2 || msg.sender == activate_addr1
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
336             //endRound();
337             bool autopurchase = endRound();
338             // put eth in players vault
339             if (autopurchase){
340                 ticket(_pID, rID_, _tickets, _affID, msg.value);
341             }else{
342                 plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
343             }
344         }
345     }
346     
347     function withdraw() 
348         isHuman()
349         public
350     {
351         // setup local rID 
352         //uint256 _rID = rID_;
353         // grab time
354         uint256 _now = now;
355         // fetch player ID
356         uint256 _pID = pIDxAddr_[msg.sender];
357         // setup temp var for player eth
358         uint256 _eth;
359         // check to see if round has ended and no one has run round end yet
360         
361         _eth = withdrawEarnings(_pID);
362         if (_eth > 0){
363             plyr_[_pID].addr.transfer(_eth);
364             emit Coinevents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
365         }
366     }
367 
368     function reloadEarnings(uint256 _pID, uint256 _eth)
369         private
370         returns(uint256)
371     {
372         // update gen vault
373         updateTicketVault(_pID, plyr_[_pID].lrnd);
374         
375         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
376         require(_earnings >= _eth, "earnings too lower");
377 
378         if (plyr_[_pID].gen >= _eth) {
379             plyr_[_pID].gen = plyr_[_pID].gen.sub(_eth);
380             return;
381         }else{
382             _eth = _eth.sub(plyr_[_pID].gen);
383             plyr_[_pID].gen = 0;
384         }
385         
386         if (plyr_[_pID].aff >= _eth){
387             plyr_[_pID].aff = plyr_[_pID].aff.sub(_eth);
388             return;
389         }else{
390             _eth = _eth.sub(plyr_[_pID].aff);
391             plyr_[_pID].aff = 0;
392         }
393         
394         plyr_[_pID].win = plyr_[_pID].win.sub(_eth);
395 
396     }
397     
398     function withdrawEarnings(uint256 _pID)
399         private
400         returns(uint256)
401     {
402         // update gen vault
403         updateTicketVault(_pID, plyr_[_pID].lrnd);
404         
405         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
406         if (_earnings > 0)
407         {
408             plyr_[_pID].win = 0;  // winner
409             plyr_[_pID].gen = 0;  //ticket valuet
410             plyr_[_pID].aff = 0;  // aff player
411         }
412 
413         return(_earnings);
414     }
415     // aquire buy ticket price
416     function getBuyPrice()
417         public 
418         view 
419         returns(uint256)
420     {
421         return round_[rID_].jackpot.mul(150) / 100 / 1500;
422     }
423     
424     /**
425      * @dev logic runs whenever a buy order is executed.  determines how to handle 
426      * incoming eth depending on if we are in an active round or not
427     */
428     function buyTicket( uint256 _pID, uint256 _affID, uint256 _tickets) 
429          private
430     {
431         //************** ******************
432         // setup local rID
433         uint256 _rID = rID_;
434         // grab time
435         uint256 _now = now;
436         
437         // if round is active
438         if (_now > round_[_rID].start && _now < round_[_rID].end){
439             // call ticket
440             ticket(_pID, _rID, _tickets, _affID, msg.value);
441             if (round_[_rID].tickets == ticketstotal_){
442                 round_[_rID].ended = true;
443                 round_[_rID].end = now;
444                 endRound();
445             }
446         }else if (_now > round_[_rID].end && round_[_rID].ended == false){
447             // end the round (distributes pot) & start new round
448             round_[_rID].ended = true;
449             //_eventData_ = endRound(_eventData_);
450             bool autopurchase = endRound();
451             // put eth in players vault
452             if (autopurchase){
453                 ticket(_pID, _rID, _tickets, _affID, msg.value);
454             }else{
455                 plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
456             }
457             //plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
458         }
459         //ticket(_pID, _rID, _tickets, _affID, msg.value);
460     }
461     
462     function ticket(uint256 _pID, uint256 _rID, uint256 _tickets, uint256 _affID, uint256 _eth)
463         private
464     {
465          // if player is new to round
466         if (plyrRnds_[_pID][rID_].tickets == 0){
467             managePlayer(_pID);
468             round_[rID_].playernums += 1;
469             plyrRnds_[_affID][rID_].affnums += 1;
470         }
471 
472         // ********** buy ticket *************
473         uint tickets = round_[rID_].tickets;
474         uint groups = (tickets + _tickets  - 1) / grouptotal_ - tickets / grouptotal_;
475         uint offset = tickets / grouptotal_;
476        
477         if (groups == 0){
478             if (((tickets + _tickets) % grouptotal_) == 0){
479                 orders[rID_][_pID][offset] = calulateXticket(orders[rID_][_pID][offset], grouptotal_, tickets % grouptotal_);
480             }else{
481                 orders[rID_][_pID][offset] = calulateXticket(orders[rID_][_pID][offset], (tickets + _tickets) % grouptotal_, tickets % grouptotal_);
482             }
483         }else{
484             for(uint256 i = 0; i < groups + 1; i++){
485                 if (i == 0){
486                      orders[rID_][_pID][offset+i] = calulateXticket(orders[rID_][_pID][offset + i], grouptotal_, tickets % grouptotal_);
487                 }
488                 if (i > 0 && i < groups){
489                     orders[rID_][_pID][offset + i] = calulateXticket(orders[rID_][_pID][offset + i], grouptotal_, 0);
490                 }
491                 if (i == groups){
492                     if (((tickets + _tickets) % grouptotal_) == 0){
493                         orders[rID_][_pID][offset + i] = calulateXticket(orders[rID_][_pID][offset + i], grouptotal_, 0);
494                     }else{
495                         orders[rID_][_pID][offset + i] = calulateXticket(orders[rID_][_pID][offset + i], (tickets + _tickets) % grouptotal_, 0);
496                     }
497                 }
498             }
499         }
500         
501         if (round_[rID_].tickets < _headtickets){
502             if (_tickets.add(round_[rID_].tickets) <= _headtickets){
503                 plyrRnds_[_pID][rID_].luckytickets = _tickets.add(plyrRnds_[_pID][rID_].luckytickets);
504             }
505             else{
506                 plyrRnds_[_pID][rID_].luckytickets = (_headtickets - round_[rID_].tickets).add(plyrRnds_[_pID][rID_].luckytickets); 
507             }
508         }
509         // set up purchase tickets
510         round_[rID_].tickets = _tickets.add(round_[rID_].tickets);
511         plyrRnds_[_pID][rID_].tickets = _tickets.add(plyrRnds_[_pID][rID_].tickets);
512         plyrRnds_[_pID][rID_].eth = _eth.add(plyrRnds_[_pID][rID_].eth);
513         round_[rID_].blocknum = block.number;
514        
515         // distributes valuet
516         distributeVault(_pID, rID_, _affID, _eth, _tickets);
517         // order event log
518         //emit onBuy(msg.sender, tickets+1, tickets +_tickets,_rID, _eth, plyr_[_pID].name);
519         emit Coinevents.onBuy(msg.sender, tickets+1, tickets +_tickets,rID_, plyr_[_pID].name);
520     }
521 
522     function distributeVault(uint256 _pID, uint256 _rID, uint256 _affID, uint256 _eth, uint256 _tickets)
523         private
524     {    
525          // distributes gen
526          uint256 _gen = 0;
527          uint256 _genvault = 0;
528          uint256 ticketprice_ = getBuyPrice();
529          if (round_[_rID].tickets > _headtickets){
530              if (round_[_rID].tickets.sub(_tickets) > _headtickets){
531                  _gen = _tickets;
532                  //plyrRnds_[_pID][_rID].luckytickets = 
533              }else{
534                  _gen = round_[_rID].tickets.sub(_headtickets);
535              }
536          }
537          
538          if (_gen > 0){
539              //_genvault = (((_gen / _tickets).mul(_eth)).mul(20)) / 100;   // 20 % to gen tickets
540              _genvault = ((ticketprice_ * _gen).mul(20)) / 100;
541              round_[_rID].mask = _genvault.add(round_[_rID].mask);   // update mask
542          }
543          
544          uint256 _aff = _eth / 10;  //to================10%(aff)
545          uint256 _com = _eth / 20;  //to================5%(community)
546          uint256 _found = _eth.mul(32) / 100;
547          round_[_rID].found = _found.add(round_[_rID].found);  //to============prize found
548          if (_affID != 0){
549              plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
550              community_addr.transfer(_com);
551          }else{
552              _com = _com.add(_aff);
553              community_addr.transfer(_com);
554          }
555          // ============to perhaps next round pool
556          uint256 _nextpot = _eth.sub(_genvault);
557          if (_affID != 0){
558              _nextpot = _nextpot.sub(_aff);
559          }
560          _nextpot = _nextpot.sub(_com);
561          _nextpot = _nextpot.sub(_found);
562          round_[_rID].nextpot = _nextpot.add(round_[_rID].nextpot);  // next round pool
563     }
564     
565     
566     function calulateXticket(uint256 _target, uint256 _start, uint256 _end) pure private returns(uint256){
567         return _target ^ (2 ** _start - 2 ** _end); 
568     }
569     
570     function endRound() 
571         private
572         returns(bool)
573     {
574         // setup local rID
575         uint256 _rID = rID_;
576         uint256 prize_callback = 0;
577         round_[_rID].lucknum = randNums();
578         bool autopurchase = false;
579         
580         // 1. if win
581         if (round_[_rID].tickets >= round_[_rID].lucknum){
582            // community_addr.transfer(round_[_rID].income.sub(_com).sub(_gen));
583             // need administrators take in 10 ETH activate next round
584             prize_callback = round_[_rID].found.add(round_[_rID].nextpot);
585             if (prize_callback > 0) {
586                 prize_addr.transfer(prize_callback);
587                 activated_ = false;   // need administrators to activate
588                 emit onSettle(_rID, round_[_rID].tickets, address(0), round_[_rID].lucknum, round_[_rID].jackpot);
589             }
590         }else{ 
591             // 2. if nobody win
592             // directly start next round
593             prize_callback = round_[_rID].found;
594             if (prize_callback > 0) {
595                 prize_addr.transfer(prize_callback);
596             }
597             rID_ ++;
598             _rID ++;
599             round_[_rID].start = now;
600             round_[_rID].end = now.add(rndGap_);
601             round_[_rID].jackpot = round_[_rID-1].jackpot.add(round_[_rID-1].nextpot);
602             autopurchase = true;
603             emit onSettle(_rID-1, round_[_rID-1].tickets, address(0), round_[_rID-1].lucknum, round_[_rID-1].jackpot);
604         }
605         return autopurchase;
606 
607     }
608  
609      /**
610      * @dev moves any unmasked earnings to ticket vault.  updates earnings
611      */   
612      // _pID: player pid _rIDlast: last roundid
613     function updateTicketVault(uint256 _pID, uint256 _rIDlast) private{
614         
615          uint256 _gen = (plyrRnds_[_pID][_rIDlast].luckytickets.mul(round_[_rIDlast].mask / _headtickets)).sub(plyrRnds_[_pID][_rIDlast].mask);
616          
617          uint256 _jackpot = 0;
618          if (judgeWin(_rIDlast, _pID) && address(round_[_rIDlast].winner) == 0) {
619              _jackpot = round_[_rIDlast].jackpot;
620              round_[_rIDlast].winner = msg.sender;
621          }
622          plyr_[_pID].gen = _gen.add(plyr_[_pID].gen);     // ticket valuet
623          plyr_[_pID].win = _jackpot.add(plyr_[_pID].win); // player win
624          plyrRnds_[_pID][_rIDlast].mask = plyrRnds_[_pID][_rIDlast].mask.add(_gen);
625     }
626     
627     
628     function managePlayer(uint256 _pID)
629         private
630     {
631         // if player has played a previous round, move their unmasked earnings
632         // from that round to gen vault.
633         if (plyr_[_pID].lrnd != 0)
634             updateTicketVault(_pID, plyr_[_pID].lrnd);
635             
636         // update player's last round played
637         plyr_[_pID].lrnd = rID_;
638 
639     }
640     //==============================================================================
641     //     _ _ | _   | _ _|_ _  _ _  .
642     //    (_(_||(_|_||(_| | (_)| _\  .
643     //==============================================================================
644     /**
645      * @dev calculates unmasked earnings (just calculates, does not update ticket)
646      * @return earnings in wei format
647      */
648      //计算每轮中pid前500ticket的分红
649     function calcTicketEarnings(uint256 _pID, uint256 _rIDlast)
650         private
651         view
652         returns(uint256)
653     {   // per round ticket valuet
654         return (plyrRnds_[_pID][_rIDlast].luckytickets.mul(round_[_rIDlast].mask / _headtickets)).sub(plyrRnds_[_pID][_rIDlast].mask);
655     }
656     
657     //====================/=========================================================
658     /** upon contract deploy, it will be deactivated.  this is a one time
659      * use function that will activate the contract.  we do this so devs 
660      * have time to set things up on the web end                            **/
661     
662     function activate()
663         isHuman()
664         public
665         payable
666     {
667         // can only be ran once
668         require(
669             msg.sender == activate_addr2 ||msg.sender == activate_addr1);
670         
671         require(activated_ == false, "LuckyCoin already activated");
672         //uint256 _jackpot = 10 ether;
673         require(msg.value == jackpot, "activate game need 10 ether");
674         
675         if (rID_ != 0) {
676             require(round_[rID_].tickets >= round_[rID_].lucknum, "nobody win");
677         }
678         //activate the contract 
679         activated_ = true;
680         //lets start first round
681         rID_ ++;
682         round_[rID_].start = now;
683         round_[rID_].end = now + rndGap_;
684         round_[rID_].jackpot = msg.value;
685         emit onActivate(rID_);
686     }
687     
688     /**
689 	 * @dev receives name/player info from names contract 
690      */
691     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
692         external
693     {
694         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
695         if (pIDxAddr_[_addr] != _pID)
696             pIDxAddr_[_addr] = _pID;
697         if (pIDxName_[_name] != _pID)
698             pIDxName_[_name] = _pID;
699         if (plyr_[_pID].addr != _addr)
700             plyr_[_pID].addr = _addr;
701         if (plyr_[_pID].name != _name)
702             plyr_[_pID].name = _name;
703         if (plyr_[_pID].laff != _laff)
704             plyr_[_pID].laff = _laff;
705         if (plyrNames_[_pID][_name] == false)
706             plyrNames_[_pID][_name] = true;
707     }
708     
709 //==============================PLAYER==========================================    
710     /**
711      * @dev receives entire player name list 
712      */
713     function receivePlayerNameList(uint256 _pID, bytes32 _name)
714         external
715     {
716         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
717         if(plyrNames_[_pID][_name] == false)
718             plyrNames_[_pID][_name] = true;
719     }
720     
721     /**
722      * @dev gets existing or registers new pID.  use this when a player may be new
723      * @return pID 
724      */        
725     function determinePID()
726         private
727         //returns (Coindatasets.EventReturns)
728     {
729         uint256 _pID = pIDxAddr_[msg.sender];
730         // if player is new to this version of luckycoin
731         if (_pID == 0)
732         {
733             // grab their player ID, name and last aff ID, from player names contract 
734             _pID = PlayerBook.getPlayerID(msg.sender);
735             bytes32 _name = PlayerBook.getPlayerName(_pID);
736             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
737             
738             // set up player account 
739             pIDxAddr_[msg.sender] = _pID;
740             plyr_[_pID].addr = msg.sender;
741             
742             if (_name != "")
743             {
744                 pIDxName_[_name] = _pID;
745                 plyr_[_pID].name = _name;
746                 plyrNames_[_pID][_name] = true;
747             }
748             
749             if (_laff != 0 && _laff != _pID)
750                 plyr_[_pID].laff = _laff;
751             
752             // set the new player bool to true
753             //_eventData_.compressedData = _eventData_.compressedData + 1;
754         } 
755         //return (_eventData_);
756     }
757     
758     // only support Name by name
759     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
760         isHuman()
761         public
762         payable
763     {
764         bytes32 _name = _nameString.nameFilter();
765         address _addr = msg.sender;
766         uint256 _paid = msg.value;
767         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
768         
769         uint256 _pID = pIDxAddr_[_addr];
770         
771         // fire event
772         emit Coinevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
773     }
774     
775     function registerNameXaddr(string _nameString, address _affCode, bool _all)
776         isHuman()
777         public
778         payable
779     {
780         bytes32 _name = _nameString.nameFilter();
781         address _addr = msg.sender;
782         uint256 _paid = msg.value;
783         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
784         
785         uint256 _pID = pIDxAddr_[_addr];
786         // fire event
787         emit Coinevents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
788     }
789     
790     /**
791      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
792      * provider
793      * -functionhash- 0xc7e284b8
794      * @return time left in seconds
795     */
796     function getTimeLeft()
797         public
798         view
799         returns(uint256)
800     {
801         // setup local rID
802         uint256 _rID = rID_;
803         
804         // grab time
805         uint256 _now = now;
806         
807         if (_now < round_[_rID].end){
808             return( (round_[_rID].end).sub(_now) );
809         }
810         else
811             return(0);
812     }
813     
814     function getCurrentRoundInfo() 
815         public
816         view
817         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bool)
818     {
819         // setup local rID
820         uint256 _rID = rID_;
821         return 
822         (
823             rID_,
824             round_[_rID].tickets,
825             round_[_rID].start,
826             round_[_rID].end,
827             round_[_rID].jackpot,
828             round_[_rID].nextpot,
829             round_[_rID].lucknum,
830             round_[_rID].mask,
831             round_[_rID].playernums,
832             round_[_rID].winner,
833             round_[_rID].ended
834         );
835     }
836     
837     function getPlayerInfoByAddress(address _addr)
838         public 
839         view 
840         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256)
841     {
842         // setup local rID
843         uint256 _rID = rID_;
844         
845         if (_addr == address(0))
846         {
847             _addr == msg.sender;
848         }
849         uint256 _pID = pIDxAddr_[_addr];
850         uint256 _lrnd =  plyr_[_pID].lrnd;
851         uint256 _jackpot = 0;
852         if (judgeWin(_lrnd, _pID) && address(round_[_lrnd].winner) == 0){
853             _jackpot = round_[_lrnd].jackpot;
854         }
855         
856         return
857         (
858             _pID,                               //0
859             plyr_[_pID].name,                   //1
860             plyrRnds_[_pID][_rID].tickets,      //2
861             plyr_[_pID].win.add(_jackpot),                    //3
862             plyr_[_pID].gen.add(calcTicketEarnings(_pID, _lrnd)),  //4
863             plyr_[_pID].aff,                    //5
864             plyrRnds_[_pID][_rID].eth,           //6
865             plyrRnds_[_pID][_rID].affnums        // 7
866         );
867     }
868 
869     // generate a number between 1-1500 
870     function randNums() public view returns(uint256) {
871         return uint256(keccak256(block.difficulty, now, block.coinbase)) % ticketstotal_ + 1;
872     }
873     
874     // search user if win
875     function judgeWin(uint256 _rid, uint256 _pID)private view returns(bool){
876         uint256 _group = (round_[_rid].lucknum -1) / grouptotal_;
877         uint256 _temp = round_[_rid].lucknum % grouptotal_;
878         if (_temp == 0){
879             _temp = grouptotal_;
880         }
881 
882         if (orders[_rid][_pID][_group] & (2 **(_temp-1)) == 2 **(_temp-1)){
883             return true;
884         }else{
885             return false;
886         }
887     }
888 
889     // search the tickets owns
890     function searchtickets()public view returns(uint256, uint256, uint256, uint256,uint256, uint256){
891          uint256 _pID = pIDxAddr_[msg.sender];
892          return (
893              orders[rID_][_pID][0],
894              orders[rID_][_pID][1],
895              orders[rID_][_pID][2],
896              orders[rID_][_pID][3],
897              orders[rID_][_pID][4],
898              orders[rID_][_pID][5]
899             );
900      }
901      // search the tickets by address
902     function searchTicketsXaddr(address addr) public view returns(uint256, uint256, uint256, uint256,uint256, uint256){
903         uint256 _pID = pIDxAddr_[addr];
904         return (
905              orders[rID_][_pID][0],
906              orders[rID_][_pID][1],
907              orders[rID_][_pID][2],
908              orders[rID_][_pID][3],
909              orders[rID_][_pID][4],
910              orders[rID_][_pID][5]
911             );
912      }
913 }
914 
915 
916 library Coindatasets {
917     struct EventReturns {
918         uint256 compressedData;
919         uint256 compressedIDs;
920         address winnerAddr;         // winner address
921         bytes32 winnerName;         // winner name
922         uint256 amountWon;          // amount won
923         uint256 newPot;             // amount in new pot
924         uint256 genAmount;          // amount distributed to gen
925         uint256 potAmount;          // amount added to pot
926     }
927     
928      struct Round {
929         uint256 tickets; // already purchase ticket
930         bool ended;     // has round end function been ran
931         uint256 jackpot;    // eth to pot, perhaps next round pot
932         uint256 start;   // time round started
933         uint256 end;    // time ends/ended
934         address winner;  //win address
935         uint256 mask;   // global mask
936         uint256 found; // jackpot found
937         uint256 lucknum;  // win num
938         uint256 nextpot;  // next pot
939         uint256 blocknum; // current blocknum
940         uint256 playernums; // playernums
941       }
942       
943     struct Player {
944         address addr;   // player address
945         bytes32 name;   // player name
946         uint256 win;    // winnings vault
947         uint256 gen;    // general vault
948         uint256 aff;    // affiliate vault
949         uint256 lrnd;   // last round played
950         uint256 laff;   // last affiliate id used
951         uint256 luckytickets;  // head 500 will acquire distributes vault
952     }
953     
954     struct PotSplit {
955         uint256 community;    // % of pot thats paid to key holders of current round
956         uint256 gen;    // % of pot thats paid to tickets holders
957         uint256 laff;   // last affiliate id used
958     }
959     
960     struct PlayerRounds {
961         uint256 eth;    // eth player has added to round
962         uint256 tickets;   // tickets
963         uint256 mask;  // player mask,
964         uint256 affnums;
965         uint256 luckytickets; // player luckytickets
966     }
967 }
968 
969 
970 interface PlayerBookInterface {
971     function getPlayerID(address _addr) external returns (uint256);
972     function getPlayerName(uint256 _pID) external view returns (bytes32);
973     function getPlayerLAff(uint256 _pID) external view returns (uint256);
974     function getPlayerAddr(uint256 _pID) external view returns (address);
975     function getNameFee() external view returns (uint256);
976     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
977     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
978     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
979 }
980 
981 
982 
983 library NameFilter {
984     /**
985      * @dev filters name strings
986      * -converts uppercase to lower case.  
987      * -makes sure it does not start/end with a space
988      * -makes sure it does not contain multiple spaces in a row
989      * -cannot be only numbers
990      * -cannot start with 0x 
991      * -restricts characters to A-Z, a-z, 0-9, and space.
992      * @return reprocessed string in bytes32 format
993      */
994     function nameFilter(string _input)
995         internal
996         pure
997         returns(bytes32)
998     {
999         bytes memory _temp = bytes(_input);
1000         uint256 _length = _temp.length;
1001         
1002         //sorry limited to 32 characters
1003         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1004         // make sure it doesnt start with or end with space
1005         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1006         // make sure first two characters are not 0x
1007         if (_temp[0] == 0x30)
1008         {
1009             require(_temp[1] != 0x78, "string cannot start with 0x");
1010             require(_temp[1] != 0x58, "string cannot start with 0X");
1011         }
1012         
1013         // create a bool to track if we have a non number character
1014         bool _hasNonNumber;
1015         
1016         // convert & check
1017         for (uint256 i = 0; i < _length; i++)
1018         {
1019             // if its uppercase A-Z
1020             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1021             {
1022                 // convert to lower case a-z
1023                 _temp[i] = byte(uint(_temp[i]) + 32);
1024                 
1025                 // we have a non number
1026                 if (_hasNonNumber == false)
1027                     _hasNonNumber = true;
1028             } else {
1029                 require
1030                 (
1031                     // require character is a space
1032                     _temp[i] == 0x20 || 
1033                     // OR lowercase a-z
1034                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1035                     // or 0-9
1036                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1037                     "string contains invalid characters"
1038                 );
1039                 // make sure theres not 2x spaces in a row
1040                 if (_temp[i] == 0x20)
1041                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1042                 
1043                 // see if we have a character other than a number
1044                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1045                     _hasNonNumber = true;    
1046             }
1047         }
1048         
1049         require(_hasNonNumber == true, "string cannot be only numbers");
1050         
1051         bytes32 _ret;
1052         assembly {
1053             _ret := mload(add(_temp, 32))
1054         }
1055         return (_ret);
1056     }
1057 }
1058 
1059 
1060 
1061 
1062 /**
1063  * @title SafeMath v0.1.9
1064  * @dev Math operations with safety checks that throw on error
1065  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1066  * - added sqrt
1067  * - added sq
1068  * - added pwr
1069  * - changed asserts to requires with error log outputs
1070  * - removed div, its useless
1071  */
1072 library SafeMath {
1073 
1074     /**
1075     * @dev Multiplies two numbers, throws on overflow.
1076     */
1077     function mul(uint256 a, uint256 b)
1078         internal
1079         pure
1080         returns (uint256 c)
1081     {
1082         if (a == 0) {
1083             return 0;
1084         }
1085         c = a * b;
1086         require(c / a == b);
1087         return c;
1088     }
1089 
1090     /**
1091     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1092     */
1093     function sub(uint256 a, uint256 b)
1094         internal
1095         pure
1096         returns (uint256)
1097     {
1098         require(b <= a);
1099         return a - b;
1100     }
1101 
1102     /**
1103     * @dev Adds two numbers, throws on overflow.
1104     */
1105     function add(uint256 a, uint256 b)
1106         internal
1107         pure
1108         returns (uint256 c)
1109     {
1110         c = a + b;
1111         require(c >= a);
1112         return c;
1113     }
1114 
1115     /**
1116      * @dev gives square root of given x.
1117      */
1118     function sqrt(uint256 x)
1119         internal
1120         pure
1121         returns (uint256 y)
1122     {
1123         uint256 z = ((add(x,1)) / 2);
1124         y = x;
1125         while (z < y)
1126         {
1127             y = z;
1128             z = ((add((x / z),z)) / 2);
1129         }
1130     }
1131 
1132     /**
1133      * @dev gives square. multiplies x by x
1134      */
1135     function sq(uint256 x)
1136         internal
1137         pure
1138         returns (uint256)
1139     {
1140         return (mul(x,x));
1141     }
1142 
1143     /**
1144      * @dev x to the power of y
1145      */
1146     function pwr(uint256 x, uint256 y)
1147         internal
1148         pure
1149         returns (uint256)
1150     {
1151         if (x==0)
1152             return (0);
1153         else if (y==0)
1154             return (1);
1155         else
1156         {
1157             uint256 z = x;
1158             for (uint256 i=1; i < y; i++)
1159                 z = mul(z,x);
1160             return (z);
1161         }
1162     }
1163 }