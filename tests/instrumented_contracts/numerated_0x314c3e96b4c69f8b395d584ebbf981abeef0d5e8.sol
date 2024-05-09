1 pragma solidity ^0.4.24;
2 
3 contract S3Devents {
4     // fired at end of buy or reload
5     event onEndTx
6     (
7         uint256 compressedData,
8         uint256 compressedIDs,
9         address playerAddress,
10         uint256 ethIn,
11         uint256 keysBought,
12         address winnerAddr,
13         uint256 amountWon,
14         uint256 newPot,
15         uint256 genAmount,
16         uint256 potAmount
17     );
18 
19 	// fired whenever theres a withdraw
20     event onWithdraw
21     (
22         uint256 indexed playerID,
23         address playerAddress,
24         uint256 ethOut,
25         uint256 timeStamp
26     );
27 
28     // fired whenever a withdraw forces end round to be ran
29     event onWithdrawAndDistribute
30     (
31         address playerAddress,
32         uint256 ethOut,
33         uint256 compressedData,
34         uint256 compressedIDs,
35         address winnerAddr,
36         uint256 amountWon,
37         uint256 newPot,
38         uint256 genAmount
39     );
40 
41     // (Solitaire3D long only) fired whenever a player tries a buy after round timer
42     // hit zero, and causes end round to be ran.
43     event onBuyAndDistribute
44     (
45         address playerAddress,
46         uint256 ethIn,
47         uint256 compressedData,
48         uint256 compressedIDs,
49         address winnerAddr,
50         uint256 amountWon,
51         uint256 newPot,
52         uint256 genAmount
53     );
54 }
55 
56 contract modularLong is S3Devents { }
57 
58 contract S3DSimple is modularLong {
59     using SafeMath for *;
60     using S3DKeysCalcLong for uint256;
61 
62     string constant public name = "Solitaire 3D";
63     string constant public symbol = "Solitaire";
64     uint256 private rndExtra_ = 30 seconds;     // length of the very first ICO
65     uint256 private rndGap_ = 30 seconds;         // length of ICO phase, set to 1 year for EOS.
66     uint256 constant private rndInit_ = 10 minutes;                // round timer starts at this
67     uint256 constant private rndInc_ = 60 seconds;              // every full key purchased adds this much to the timer
68     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
69     address constant private developer = 0xA7759a5CAcE1a3b54E872879Cf3942C5D4ff5897;
70     address constant private operator = 0xc3F465FD001f78DCEeF6f47FD18E3B04F95f2337;
71 
72     uint256 public rID_;    // round id number / total rounds that have happened
73 
74     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
75     mapping (uint256 => S3Ddatasets.Player) public plyr_;   // (pID => data) player data
76     mapping (uint256 => mapping (uint256 => S3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
77 
78     mapping (uint256 => S3Ddatasets.Round) public round_;   // (rID => data) round data
79     uint256 public pID_;
80     S3Ddatasets.TeamFee public fee_;
81 
82     constructor()
83         public
84     {
85 
86         fee_ = S3Ddatasets.TeamFee(50);   //20% to pot, 15% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
87         plyr_[1].addr = 0xA7759a5CAcE1a3b54E872879Cf3942C5D4ff5897;
88         pIDxAddr_[0xA7759a5CAcE1a3b54E872879Cf3942C5D4ff5897] = 1;
89         pID_ = 1;
90     }
91     /**
92      * @dev used to make sure no one can interact with contract until it has
93      * been activated.
94      */
95     modifier isActivated() {
96         require(activated_ == true, "its not ready yet.  check ?eta in discord");
97         _;
98     }
99 
100     /**
101      * @dev prevents contracts from interacting with Solitaire3D
102      */
103     modifier isHuman() {
104         address _addr = msg.sender;
105         uint256 _codeLength;
106 
107         assembly {_codeLength := extcodesize(_addr)}
108         require(_codeLength == 0, "sorry humans only");
109         _;
110     }
111 
112     /**
113      * @dev sets boundaries for incoming tx
114      */
115     modifier isWithinLimits(uint256 _eth) {
116         require(_eth >= 0, "pocket lint: not a valid currency");
117         require(_eth <= 100000000000000000000000, "no vitalik, no");
118         _;
119     }
120 
121     /**
122      * @dev emergency buy uses last stored affiliate ID and team snek
123      */
124     function()
125         isActivated()
126         isHuman()
127         isWithinLimits(msg.value)
128         public
129         payable
130     {
131         // set up our tx event data and determine if player is new or not
132         S3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
133 
134         // fetch player id
135         uint256 _pID = pIDxAddr_[msg.sender];
136 
137         // buy core
138         if (msg.value > 1000000000){
139             buyCore(_pID, _eventData_);
140         }else{
141             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
142             withdraw();
143         }
144 
145     }
146 
147     /**
148      * @dev withdraws all of your earnings.
149      * -functionhash- 0x3ccfd60b
150      */
151     function withdraw()
152         isActivated()
153         isHuman()
154         public
155     {
156         // setup local rID
157         uint256 _rID = rID_;
158 
159         // grab time
160         uint256 _now = now;
161 
162         // fetch player ID
163         uint256 _pID = pIDxAddr_[msg.sender];
164 
165         // setup temp var for player eth
166         uint256 _eth;
167 
168         // check to see if round has ended and no one has run round end yet
169         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
170         {
171             // set up our tx event data
172             S3Ddatasets.EventReturns memory _eventData_;
173 
174             // end the round (distributes pot)
175             round_[_rID].ended = true;
176             _eventData_ = endRound(_eventData_);
177 
178 			// get their earnings
179             _eth = withdrawEarnings(_pID);
180 
181             // gib moni
182             if (_eth > 0)
183                 plyr_[_pID].addr.transfer(_eth);
184 
185             // build event data
186             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
187             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
188 
189             // fire withdraw and distribute event
190             emit S3Devents.onWithdrawAndDistribute
191             (
192                 msg.sender,
193                 _eth,
194                 _eventData_.compressedData,
195                 _eventData_.compressedIDs,
196                 _eventData_.winnerAddr,
197                 _eventData_.amountWon,
198                 _eventData_.newPot,
199                 _eventData_.genAmount
200             );
201 
202         // in any other situation
203         } else {
204             // get their earnings
205             _eth = withdrawEarnings(_pID);
206 
207             // gib moni
208             if (_eth > 0)
209                 plyr_[_pID].addr.transfer(_eth);
210 
211             // fire withdraw event
212             emit S3Devents.onWithdraw(_pID, msg.sender, _eth, _now);
213         }
214     }
215 
216 //==============================================================================
217 //     _  _ _|__|_ _  _ _  .
218 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
219 //=====_|=======================================================================
220     /**
221      * @dev return the price buyer will pay for next 1 individual key.
222      * -functionhash- 0x018a25e8
223      * @return price for next key bought (in wei format)
224      */
225     function getBuyPrice()
226         public
227         view
228         returns(uint256)
229     {
230         // setup local rID
231         uint256 _rID = rID_;
232 
233         // grab time
234         uint256 _now = now;
235 
236         // are we in a round?
237         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
238             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
239         else // rounds over.  need price for new round
240             return ( 75000000000000 ); // init
241     }
242 
243     /**
244      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
245      * provider
246      * -functionhash- 0xc7e284b8
247      * @return time left in seconds
248      */
249     function getTimeLeft()
250         public
251         view
252         returns(uint256)
253     {
254         // setup local rID
255         uint256 _rID = rID_;
256 
257         // grab time
258         uint256 _now = now;
259 
260         if (_now < round_[_rID].end)
261             if (_now > round_[_rID].strt + rndGap_)
262                 return( (round_[_rID].end).sub(_now) );
263             else
264                 return( (round_[_rID].strt + rndGap_).sub(_now) );
265         else
266             return(0);
267     }
268 
269     /**
270      * @dev returns player earnings per vaults
271      * -functionhash- 0x63066434
272      * @return winnings vault
273      * @return general vault
274      * @return affiliate vault
275      */
276     function getPlayerVaults(uint256 _pID)
277         public
278         view
279         returns(uint256 ,uint256)
280     {
281         // setup local rID
282         uint256 _rID = rID_;
283 
284         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
285         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
286         {
287             // if player is winner
288             if (round_[_rID].plyr == _pID)
289             {
290                 return
291                 (
292                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(90)) / 100 ),
293                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   )
294                 );
295             // if player is not the winner
296             } else {
297                 return
298                 (
299                     plyr_[_pID].win,
300                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  )
301                 );
302             }
303 
304         // if round is still going on, or round has ended and round end has been ran
305         } else {
306             return
307             (
308                 plyr_[_pID].win,
309                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd))
310             );
311         }
312     }
313 
314     /**
315      * solidity hates stack limits.  this lets us avoid that hate
316      */
317     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
318         private
319         view
320         returns(uint256)
321     {
322         return(((((round_[_rID].mask) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000);
323     }
324 
325     function getCurrentRoundInfo()
326         public
327         view
328         returns(uint256, uint256, uint256, uint256, uint256, address)
329     {
330         // setup local rID
331         uint256 _rID = rID_;
332 
333         return
334         (
335             _rID,                           //0
336             round_[_rID].keys,              //1
337             round_[_rID].end,               //2
338             round_[_rID].strt,              //3
339             round_[_rID].pot,               //4
340             plyr_[round_[_rID].plyr].addr  //5
341         );
342     }
343 
344     function getPlayerInfoByAddress(address _addr)
345         public
346         view
347         returns(uint256, uint256, uint256, uint256, uint256)
348     {
349         // setup local rID
350         uint256 _rID = rID_;
351 
352         if (_addr == address(0))
353         {
354             _addr == msg.sender;
355         }
356         uint256 _pID = pIDxAddr_[_addr];
357 
358         return
359         (
360             _pID,                               //0
361             plyrRnds_[_pID][_rID].keys,         //1
362             plyr_[_pID].win,                    //2
363             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), //3
364             plyrRnds_[_pID][_rID].eth           //4
365         );
366     }
367 
368 //==============================================================================
369 //     _ _  _ _   | _  _ . _  .
370 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
371 //=====================_|=======================================================
372     /**
373      * @dev logic runs whenever a buy order is executed.  determines how to handle
374      * incoming eth depending on if we are in an active round or not
375      */
376     function buyCore(uint256 _pID, S3Ddatasets.EventReturns memory _eventData_)
377         private
378     {
379         // setup local rID
380         uint256 _rID = rID_;
381 
382         // grab time
383         uint256 _now = now;
384 
385         // if round is active
386         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
387         {
388             // call core
389             core(_rID, _pID, msg.value, _eventData_);
390 
391         // if round is not active
392         } else {
393             // check to see if end round needs to be ran
394             if (_now > round_[_rID].end && round_[_rID].ended == false)
395             {
396                 // end the round (distributes pot) & start new round
397 			    round_[_rID].ended = true;
398                 _eventData_ = endRound(_eventData_);
399 
400                 // build event data
401                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
402                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
403 
404                 // fire buy and distribute event
405                 emit S3Devents.onBuyAndDistribute
406                 (
407                     msg.sender,
408                     msg.value,
409                     _eventData_.compressedData,
410                     _eventData_.compressedIDs,
411                     _eventData_.winnerAddr,
412                     _eventData_.amountWon,
413                     _eventData_.newPot,
414                     _eventData_.genAmount
415                 );
416             }
417 
418             // put eth in players vault
419             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
420         }
421     }
422     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
423         private
424         view
425         returns(uint256)
426     {
427         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
428     }
429 
430     /**
431      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
432      */
433     function updateGenVault(uint256 _pID, uint256 _rIDlast)
434         private
435     {
436         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
437         if (_earnings > 0)
438         {
439             // put in gen vault
440             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
441             // zero out their earnings by updating mask
442             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
443         }
444     }
445     function managePlayer(uint256 _pID, S3Ddatasets.EventReturns memory _eventData_)
446         private
447         returns (S3Ddatasets.EventReturns)
448     {
449         // if player has played a previous round, move their unmasked earnings
450         // from that round to gen vault.
451         if (plyr_[_pID].lrnd != 0)
452             updateGenVault(_pID, plyr_[_pID].lrnd);
453 
454         // update player's last round played
455         plyr_[_pID].lrnd = rID_;
456 
457         // set the joined round bool to true
458         _eventData_.compressedData = _eventData_.compressedData + 10;
459 
460         return(_eventData_);
461     }
462     /**
463      * @dev this is the core logic for any buy/reload that happens while a round
464      * is live.
465      */
466     function core(uint256 _rID, uint256 _pID, uint256 _eth, S3Ddatasets.EventReturns memory _eventData_)
467         private
468     {
469 
470         if (plyrRnds_[_pID][_rID].keys == 0)
471             _eventData_ = managePlayer(_pID, _eventData_);
472         // if eth left is greater than min eth allowed (sorry no pocket lint)
473         if (_eth > 1000000000)
474         {
475 
476             // mint the new keys
477             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
478 
479             // if they bought at least 1 whole key
480             if (_keys >= 1000000000000000000)
481             {
482                 updateTimer(_keys, _rID);
483 
484                 // set new leaders
485                 if (round_[_rID].plyr != _pID)
486                     round_[_rID].plyr = _pID;
487 
488                 // set the new leader bool to true
489                 _eventData_.compressedData = _eventData_.compressedData + 100;
490             }
491 
492             // update player
493             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
494             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
495 
496             // update round
497             round_[_rID].keys = _keys.add(round_[_rID].keys);
498             round_[_rID].eth = _eth.add(round_[_rID].eth);
499 
500             // distribute eth
501             _eventData_ = distributeExternal(_eth, _eventData_);
502             _eventData_ = distributeInternal(_rID, _pID, _eth, _keys, _eventData_);
503 
504             // call end tx function to fire end tx event.
505             endTx(_pID, _eth, _keys, _eventData_);
506         }
507     }
508 
509     /**
510      * @dev returns the amount of keys you would get given an amount of eth.
511      * -functionhash- 0xce89c80c
512      * @param _rID round ID you want price for
513      * @param _eth amount of eth sent in
514      * @return keys received
515      */
516     function calcKeysReceived(uint256 _rID, uint256 _eth)
517         public
518         view
519         returns(uint256)
520     {
521         // grab time
522         uint256 _now = now;
523 
524         // are we in a round?
525         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
526             return ( (round_[_rID].eth).keysRec(_eth) );
527         else // rounds over.  need keys for new round
528             return ( (_eth).keys() );
529     }
530 
531     /**
532      * @dev returns current eth price for X keys.
533      * -functionhash- 0xcf808000
534      * @param _keys number of keys desired (in 18 decimal format)
535      * @return amount of eth needed to send
536      */
537     function iWantXKeys(uint256 _keys)
538         public
539         view
540         returns(uint256)
541     {
542         // setup local rID
543         uint256 _rID = rID_;
544 
545         // grab time
546         uint256 _now = now;
547 
548         // are we in a round?
549         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
550             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
551         else // rounds over.  need price for new round
552             return ( (_keys).eth() );
553     }
554 
555     /**
556      * @dev gets existing or registers new pID.  use this when a player may be new
557      * @return pID
558      */
559     function determinePID(S3Ddatasets.EventReturns memory _eventData_)
560         private
561         returns (S3Ddatasets.EventReturns)
562     {
563         uint256 _pID = pIDxAddr_[msg.sender];
564         // if player is new to this version of Solitaire3D
565         if (_pID == 0)
566         {
567             // grab their player ID, name and last aff ID, from player names contract
568 
569             pID_++;
570             _pID = pID_;
571             // set up player account
572             pIDxAddr_[msg.sender] = _pID;
573             plyr_[_pID].addr = msg.sender;
574 
575             // set the new player bool to true
576             _eventData_.compressedData = _eventData_.compressedData + 1;
577         }
578         return (_eventData_);
579     }
580 
581     /**
582      * @dev ends the round. manages paying out winner/splitting up pot
583      */
584     function endRound(S3Ddatasets.EventReturns memory _eventData_)
585         private
586         returns (S3Ddatasets.EventReturns)
587     {
588         // setup local rID
589         uint256 _rID = rID_;
590 
591         // grab our winning player and team id's
592         uint256 _winPID = round_[_rID].plyr;
593 
594         // grab our pot amount
595         uint256 _pot = round_[_rID].pot;
596 
597         // calculate our winner share, community developers, gen share,
598         // p3d share, and amount reserved for next pot
599         uint256 _win = (_pot.mul(90)) / 100;
600         uint256 _com = (_pot / 20);
601         uint256 _res = ((_pot.sub(_win)).sub(_com)).sub(_com);
602 
603         // pay our winner
604         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
605 
606         if (_com > 0) {
607             developer.transfer(_com);
608             operator.transfer(_com);
609         }
610 
611         // prepare event data
612         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
613         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000);
614         _eventData_.winnerAddr = plyr_[_winPID].addr;
615         _eventData_.amountWon = _win;
616         _eventData_.genAmount = 0;
617         _eventData_.newPot = _res;
618 
619         // start next round
620         rID_++;
621         _rID++;
622         round_[_rID].strt = now;
623         round_[_rID].end = now.add(rndInit_).add(rndGap_);
624         round_[_rID].pot = _res;
625 
626         return(_eventData_);
627     }
628     /**
629      * @dev updates round timer based on number of whole keys bought.
630      */
631     function updateTimer(uint256 _keys, uint256 _rID)
632         private
633     {
634         // grab time
635         uint256 _now = now;
636 
637         // calculate time based on number of keys bought
638         uint256 _newTime;
639         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
640             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
641         else
642             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
643 
644         // compare to max and set new end time
645         if (_newTime < (rndMax_).add(_now))
646             round_[_rID].end = _newTime;
647         else
648             round_[_rID].end = rndMax_.add(_now);
649     }
650     /**
651      * @dev distributes eth based on fees to com, aff, and p3d
652      */
653     function distributeExternal(uint256 _eth, S3Ddatasets.EventReturns memory _eventData_)
654         private
655         returns(S3Ddatasets.EventReturns)
656     {
657 
658         // pay 5% to developer and operator
659         uint256 _long = _eth / 20;
660         developer.transfer(_long);
661         operator.transfer(_long);
662 
663         return(_eventData_);
664     }
665 
666     /**
667      * @dev distributes eth based on fees to gen and pot
668      */
669     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _keys, S3Ddatasets.EventReturns memory _eventData_)
670         private
671         returns(S3Ddatasets.EventReturns)
672     {
673         // calculate gen share
674         uint256 _gen = (_eth.mul(fee_.gen)) / 100;
675 
676         // update eth balance (eth = eth - (dev share + oper share))
677         _eth = _eth.sub(((_eth.mul(10)) / 100));
678 
679         // calculate pot
680         uint256 _pot = _eth.sub(_gen);
681 
682         // distribute gen share (thats what updateMasks() does) and adjust
683         // balances for dust.
684         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
685         if (_dust > 0)
686             _gen = _gen.sub(_dust);
687 
688         // add eth to pot
689         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
690 
691         // set up event data
692         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
693         _eventData_.potAmount = _pot;
694 
695         return(_eventData_);
696     }
697 
698     /**
699      * @dev updates masks for round and player when keys are bought
700      * @return dust left over
701      */
702     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
703         private
704         returns(uint256)
705     {
706 
707         // calc profit per key & round mask based on this buy:  (dust goes to pot)
708         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
709         round_[_rID].mask = _ppt.add(round_[_rID].mask);
710 
711         // calculate player earning from their own buy (only based on the keys
712         // they just bought).  & update player earnings mask
713         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
714         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
715 
716         // calculate & return dust
717         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
718     }
719 
720     /**
721      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
722      * @return earnings in wei format
723      */
724     function withdrawEarnings(uint256 _pID)
725         private
726         returns(uint256)
727     {
728         updateGenVault(_pID, plyr_[_pID].lrnd);
729         // from vaults
730         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen);
731         if (_earnings > 0)
732         {
733             plyr_[_pID].win = 0;
734             plyr_[_pID].gen = 0;
735         }
736 
737         return(_earnings);
738     }
739 
740     /**
741      * @dev prepares compression data and fires event for buy or reload tx's
742      */
743     function endTx(uint256 _pID, uint256 _eth, uint256 _keys, S3Ddatasets.EventReturns memory _eventData_)
744         private
745     {
746         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000);
747         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
748 
749         emit S3Devents.onEndTx
750         (
751             _eventData_.compressedData,
752             _eventData_.compressedIDs,
753             msg.sender,
754             _eth,
755             _keys,
756             _eventData_.winnerAddr,
757             _eventData_.amountWon,
758             _eventData_.newPot,
759             _eventData_.genAmount,
760             _eventData_.potAmount
761         );
762     }
763 
764     bool public activated_ = false;
765     function activate()
766         public
767     {
768         // only team just can activate
769         require(
770             msg.sender == 0xA7759a5CAcE1a3b54E872879Cf3942C5D4ff5897,
771             "only team just can activate"
772         );
773 
774         // can only be ran once
775         require(activated_ == false, "Solitaire3D already activated");
776 
777         // activate the contract
778         activated_ = true;
779 
780         // lets start first round
781 		rID_ = 1;
782         round_[1].strt = now + rndExtra_ - rndGap_;
783         round_[1].end = now + rndInit_ + rndExtra_;
784     }
785 }
786 
787 library S3Ddatasets {
788 
789     struct EventReturns {
790         uint256 compressedData;
791         uint256 compressedIDs;
792         address winnerAddr;         // winner address
793         uint256 amountWon;          // amount won
794         uint256 newPot;             // amount in new pot
795         uint256 potAmount;          // amount added to pot
796         uint256 genAmount;
797     }
798     struct Player {
799         address addr;   // player address
800         uint256 win;    // winnings vault
801         uint256 gen;    // general vault
802         uint256 lrnd;   // last round played
803     }
804     struct PlayerRounds {
805         uint256 eth;    // eth player has added to round (used for eth limiter)
806         uint256 keys;   // keys
807         uint256 mask;   // player mask
808     }
809     struct Round {
810         uint256 plyr;   // pID of player in lead
811         uint256 end;    // time ends/ended
812         bool ended;     // has round end function been ran
813         uint256 strt;   // time round started
814         uint256 keys;   // keys
815         uint256 eth;    // total eth in
816         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
817         uint256 mask;   // global mask
818     }
819     struct TeamFee {
820         uint256 gen;    // % of buy in thats paid to key holders of current round
821     }
822     struct PotSplit {
823         uint256 gen;    // % of pot thats paid to key holders of current round
824     }
825 }
826 
827 //==============================================================================
828 //  |  _      _ _ | _  .
829 //  |<(/_\/  (_(_||(_  .
830 //=======/======================================================================
831 library S3DKeysCalcLong {
832     using SafeMath for *;
833     /**
834      * @dev calculates number of keys received given X eth
835      * @param _curEth current amount of eth in contract
836      * @param _newEth eth being spent
837      * @return amount of ticket purchased
838      */
839     function keysRec(uint256 _curEth, uint256 _newEth)
840         internal
841         pure
842         returns (uint256)
843     {
844         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
845     }
846 
847     /**
848      * @dev calculates amount of eth received if you sold X keys
849      * @param _curKeys current amount of keys that exist
850      * @param _sellKeys amount of keys you wish to sell
851      * @return amount of eth received
852      */
853     function ethRec(uint256 _curKeys, uint256 _sellKeys)
854         internal
855         pure
856         returns (uint256)
857     {
858         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
859     }
860 
861     /**
862      * @dev calculates how many keys would exist with given an amount of eth
863      * @param _eth eth "in contract"
864      * @return number of keys that would exist
865      */
866     function keys(uint256 _eth)
867         internal
868         pure
869         returns(uint256)
870     {
871         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
872     }
873 
874     /**
875      * @dev calculates how much eth would be in contract given a number of keys
876      * @param _keys number of keys "in contract"
877      * @return eth that would exists
878      */
879     function eth(uint256 _keys)
880         internal
881         pure
882         returns(uint256)
883     {
884         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
885     }
886 }
887 
888 /**
889  * @title SafeMath v0.1.9
890  * @dev Math operations with safety checks that throw on error
891  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
892  * - added sqrt
893  * - added sq
894  * - added pwr
895  * - changed asserts to requires with error log outputs
896  * - removed div, its useless
897  */
898 library SafeMath {
899 
900     /**
901     * @dev Multiplies two numbers, throws on overflow.
902     */
903     function mul(uint256 a, uint256 b)
904         internal
905         pure
906         returns (uint256 c)
907     {
908         if (a == 0) {
909             return 0;
910         }
911         c = a * b;
912         require(c / a == b, "SafeMath mul failed");
913         return c;
914     }
915 
916     /**
917     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
918     */
919     function sub(uint256 a, uint256 b)
920         internal
921         pure
922         returns (uint256)
923     {
924         require(b <= a, "SafeMath sub failed");
925         return a - b;
926     }
927 
928     /**
929     * @dev Adds two numbers, throws on overflow.
930     */
931     function add(uint256 a, uint256 b)
932         internal
933         pure
934         returns (uint256 c)
935     {
936         c = a + b;
937         require(c >= a, "SafeMath add failed");
938         return c;
939     }
940 
941     /**
942      * @dev gives square root of given x.
943      */
944     function sqrt(uint256 x)
945         internal
946         pure
947         returns (uint256 y)
948     {
949         uint256 z = ((add(x,1)) / 2);
950         y = x;
951         while (z < y)
952         {
953             y = z;
954             z = ((add((x / z),z)) / 2);
955         }
956     }
957 
958     /**
959      * @dev gives square. multiplies x by x
960      */
961     function sq(uint256 x)
962         internal
963         pure
964         returns (uint256)
965     {
966         return (mul(x,x));
967     }
968 
969     /**
970      * @dev x to the power of y
971      */
972     function pwr(uint256 x, uint256 y)
973         internal
974         pure
975         returns (uint256)
976     {
977         if (x==0)
978             return (0);
979         else if (y==0)
980             return (1);
981         else
982         {
983             uint256 z = x;
984             for (uint256 i=1; i < y; i++)
985                 z = mul(z,x);
986             return (z);
987         }
988     }
989 }