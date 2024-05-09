1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) 
6         internal 
7         pure 
8         returns (uint256 c) 
9     {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         require(c / a == b, "SafeMath mul failed");
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b)
19         internal
20         pure
21         returns (uint256) 
22     {
23         require(b <= a, "SafeMath sub failed");
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b)
28         internal
29         pure
30         returns (uint256 c) 
31     {
32         c = a + b;
33         require(c >= a, "SafeMath add failed");
34         return c;
35     }
36     
37     function sqrt(uint256 x)
38         internal
39         pure
40         returns (uint256 y) 
41     {
42         uint256 z = ((add(x,1)) / 2);
43         y = x;
44         while (z < y) 
45         {
46             y = z;
47             z = ((add((x / z),z)) / 2);
48         }
49     }
50 
51     function sq(uint256 x)
52         internal
53         pure
54         returns (uint256)
55     {
56         return (mul(x,x));
57     }
58     
59     function pwr(uint256 x, uint256 y)
60         internal 
61         pure 
62         returns (uint256)
63     {
64         if (x==0)
65             return (0);
66         else if (y==0)
67             return (1);
68         else 
69         {
70             uint256 z = x;
71             for (uint256 i=1; i < y; i++)
72                 z = mul(z,x);
73             return (z);
74         }
75     }
76 }
77 
78 library F3DKeysCalcLong {
79     using SafeMath for *;
80 
81     function keysRec(uint256 _curEth, uint256 _newEth)
82         internal
83         pure
84         returns (uint256)
85     {
86         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
87     }
88     
89     function ethRec(uint256 _curKeys, uint256 _sellKeys)
90         internal
91         pure
92         returns (uint256)
93     {
94         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
95     }
96 
97     function keys(uint256 _eth) 
98         internal
99         pure
100         returns(uint256)
101     {
102         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
103     }
104 
105     function eth(uint256 _keys) 
106         internal
107         pure
108         returns(uint256)  
109     {
110         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
111     }
112 }
113 
114 library NameFilter {
115 
116     function nameFilter(string _input)
117         internal
118         pure
119         returns(bytes32)
120     {
121         bytes memory _temp = bytes(_input);
122         uint256 _length = _temp.length;
123         
124         //sorry limited to 32 characters
125         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
126         // make sure it doesnt start with or end with space
127         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
128         // make sure first two characters are not 0x
129         if (_temp[0] == 0x30)
130         {
131             require(_temp[1] != 0x78, "string cannot start with 0x");
132             require(_temp[1] != 0x58, "string cannot start with 0X");
133         }
134         
135         // create a bool to track if we have a non number character
136         bool _hasNonNumber;
137         
138         // convert & check
139         for (uint256 i = 0; i < _length; i++)
140         {
141             // if its uppercase A-Z
142             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
143             {
144                 // convert to lower case a-z
145                 _temp[i] = byte(uint(_temp[i]) + 32);
146                 
147                 // we have a non number
148                 if (_hasNonNumber == false)
149                     _hasNonNumber = true;
150             } else {
151                 require
152                 (
153                     // require character is a space
154                     _temp[i] == 0x20 || 
155                     // OR lowercase a-z
156                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
157                     // or 0-9
158                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
159                     "string contains invalid characters"
160                 );
161                 // make sure theres not 2x spaces in a row
162                 if (_temp[i] == 0x20)
163                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
164                 
165                 // see if we have a character other than a number
166                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
167                     _hasNonNumber = true;    
168             }
169         }
170         
171         require(_hasNonNumber == true, "string cannot be only numbers");
172         
173         bytes32 _ret;
174         assembly {
175             _ret := mload(add(_temp, 32))
176         }
177         return (_ret);
178     }
179 }
180 
181 library F3Ddatasets {
182     //compressedData key
183     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
184         // 0 - new player (bool)
185         // 1 - joined round (bool)
186         // 2 - new  leader (bool)
187         // 3-5 - air drop tracker (uint 0-999)
188         // 6-16 - round end time
189         // 17 - winnerTeam
190         // 18 - 28 timestamp 
191         // 29 - team
192         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
193         // 31 - airdrop happened bool
194         // 32 - airdrop tier 
195         // 33 - airdrop amount won
196     //compressedIDs key
197     // [77-52][51-26][25-0]
198         // 0-25 - pID 
199         // 26-51 - winPID
200         // 52-77 - rID
201     struct EventReturns {
202         uint256 compressedData;
203         uint256 compressedIDs;
204         address winnerAddr;         // winner address
205         bytes32 winnerName;         // winner name
206         uint256 amountWon;          // amount won
207         uint256 newPot;             // amount in new pot
208         uint256 P3DAmount;          // amount distributed to p3d
209         uint256 genAmount;          // amount distributed to gen
210         uint256 potAmount;          // amount added to pot
211     }
212     struct Player {
213         address addr;   // player address
214         bytes32 name;   // player name
215         uint256 win;    // winnings vault
216         uint256 gen;    // general vault
217         uint256 aff;    // affiliate vault
218         uint256 lrnd;   // last round played
219         uint256 laff;   // last affiliate id used
220     }
221     struct PlayerRounds {
222         uint256 eth;    // eth player has added to round (used for eth limiter)
223         uint256 keys;   // keys
224         uint256 mask;   // player mask 
225         uint256 ico;    // ICO phase investment
226     }
227     struct Round {
228         uint256 plyr;   // pID of player in lead
229         uint256 team;   // tID of team in lead
230         uint256 end;    // time ends/ended
231         bool ended;     // has round end function been ran
232         uint256 strt;   // time round started
233         uint256 keys;   // keys
234         uint256 eth;    // total eth in
235         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
236         uint256 mask;   // global mask
237         uint256 ico;    // total eth sent in during ICO phase
238         uint256 icoGen; // total eth for gen during ICO phase
239         uint256 icoAvg; // average key price for ICO phase
240     }
241     struct TeamFee {
242         uint256 gen;    // % of buy in thats paid to key holders of current round
243         uint256 p3d;    // % of buy in thats paid to p3d holders
244     }
245     struct PotSplit {
246         uint256 gen;    // % of pot thats paid to key holders of current round
247         uint256 p3d;    // % of pot thats paid to p3d holders
248     }
249 }
250 
251 contract F3Devents {
252 
253     event onNewName
254     (
255         uint256 indexed playerID,
256         address indexed playerAddress,
257         bytes32 indexed playerName,
258         bool isNewPlayer,
259         uint256 affiliateID,
260         address affiliateAddress,
261         bytes32 affiliateName,
262         uint256 amountPaid,
263         uint256 timeStamp
264     );
265 
266     event onEndTx
267     (
268         uint256 compressedData,     
269         uint256 compressedIDs,      
270         bytes32 playerName,
271         address playerAddress,
272         uint256 ethIn,
273         uint256 keysBought,
274         address winnerAddr,
275         bytes32 winnerName,
276         uint256 amountWon,
277         uint256 newPot,
278         uint256 P3DAmount,
279         uint256 genAmount,
280         uint256 potAmount,
281         uint256 airDropPot
282     );
283 
284     event onWithdraw
285     (
286         uint256 indexed playerID,
287         address playerAddress,
288         bytes32 playerName,
289         uint256 ethOut,
290         uint256 timeStamp
291     );
292 
293     event onWithdrawAndDistribute
294     (
295         address playerAddress,
296         bytes32 playerName,
297         uint256 ethOut,
298         uint256 compressedData,
299         uint256 compressedIDs,
300         address winnerAddr,
301         bytes32 winnerName,
302         uint256 amountWon,
303         uint256 newPot,
304         uint256 P3DAmount,
305         uint256 genAmount
306     );
307     
308     event onBuyAndDistribute
309     (
310         address playerAddress,
311         bytes32 playerName,
312         uint256 ethIn,
313         uint256 compressedData,
314         uint256 compressedIDs,
315         address winnerAddr,
316         bytes32 winnerName,
317         uint256 amountWon,
318         uint256 newPot,
319         uint256 P3DAmount,
320         uint256 genAmount
321     );
322     
323     event onReLoadAndDistribute
324     (
325         address playerAddress,
326         bytes32 playerName,
327         uint256 compressedData,
328         uint256 compressedIDs,
329         address winnerAddr,
330         bytes32 winnerName,
331         uint256 amountWon,
332         uint256 newPot,
333         uint256 P3DAmount,
334         uint256 genAmount
335     );
336     
337     event onAffiliatePayout
338     (
339         uint256 indexed affiliateID,
340         address affiliateAddress,
341         bytes32 affiliateName,
342         uint256 indexed roundID,
343         uint256 indexed buyerID,
344         uint256 amount,
345         uint256 timeStamp
346     );
347 
348     event onPotSwapDeposit
349     (
350         uint256 roundID,
351         uint256 amountAddedToPot
352     );
353 }
354 
355 contract SuperFoMo3D is F3Devents {
356     using SafeMath for uint;
357     using NameFilter for string;
358     using F3DKeysCalcLong for uint256;
359     
360     string constant public name = "SuperFoMo3D";
361     string constant public symbol = "SuperF3D";
362     uint256 public airDropPot_;             
363     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.
364     uint256 public rID_;    // round id number / total rounds that have happened
365     address actor = 0x0;
366     bool public activated = false;
367     
368     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
369     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
370     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
371     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // player round data by player id & round id
372     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.
373     mapping (address => uint256) customerBalance;           // customer balance data
374     
375     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
376     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // eth in per team, by round id and team id
377     
378     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
379     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
380     
381     DiviesInterface constant private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
382     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
383 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xD60d353610D9a5Ca478769D371b53CEfAA7B6E4c);
384     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
385     
386     //==========================================================================
387     //  Modifier
388     //==========================================================================
389     modifier isActor
390     {
391         require(msg.sender == actor,'do not have permission');
392         _;
393     }
394     
395     modifier isActivated {
396         require(activated == true, "F3DPlus is not activated yet"); 
397         _;
398     }
399     
400     modifier isInLimits(uint256 _value)
401     {
402         require(_value >= 1000000000,'value too low');
403         require(_value <= 100000000000000000000000,'over the maximum limit');
404         _;
405     }
406     
407     modifier isEther
408     {
409         address _addr = msg.sender;
410         uint256 _codeLength;
411         
412         assembly {_codeLength := extcodesize(_addr)}
413         require(_codeLength == 0, "ether only");
414         _;
415     }
416     //==========================================================================
417     //  Methods
418     //==========================================================================
419     
420     constructor()
421         public
422     {
423         actor = msg.sender;
424     }
425     
426     function activate()
427         public
428         isActor
429         isEther
430     {
431         require(activated == false,'is already activated');
432         activated = true;
433     }
434     
435     function deactivated()
436         public
437         isActor
438         isEther
439         isActivated
440     {
441         activated = false;
442     }
443     
444     function deposit() 
445         payable
446         public
447         isEther
448         isInLimits(msg.value)
449         returns (uint256 balance)
450     {
451         customerBalance[msg.sender] = customerBalance[msg.sender].add(msg.value);
452         return customerBalance[msg.sender];
453     }
454     
455     function withdraw(uint256 _value)
456         public
457         isEther
458         isInLimits(_value)
459         returns(uint256)
460     {
461         require(customerBalance[msg.sender] >= _value,'please ensure you have enough balance');
462         msg.sender.transfer(_value);
463         customerBalance[msg.sender] = customerBalance[msg.sender].sub(_value);
464         return customerBalance[msg.sender];
465     }
466     
467     function withdrawEarnings(uint256 _pID)
468         private
469         returns(uint256)
470     {
471         // update gen vault
472         updateGenVault(_pID, plyr_[_pID].lrnd);
473         
474         // from vaults 
475         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
476         if (_earnings > 0)
477         {
478             plyr_[_pID].win = 0;
479             plyr_[_pID].gen = 0;
480             plyr_[_pID].aff = 0;
481         }
482 
483         return(_earnings);
484     }
485     
486     //get the total balance of this contract
487     function getTotalBalance()
488         public
489         constant returns (uint)
490     {
491         return address(this).balance;
492     }
493         
494     //get the balance of customer
495     function getCustomerBalance(address _addr)
496         public
497         constant returns (uint)
498     {
499         return customerBalance[_addr];
500     }
501         
502     function potSwap()
503         public
504         isActivated
505         payable
506     {
507         // setup local rID
508         uint256 _rID = rID_ + 1;
509         
510         round_[_rID].pot = round_[_rID].pot.add(msg.value);
511         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
512     }
513     
514     function registerName(string _nameString, address _affCode, bool _all)
515         isActivated
516         isEther
517         public
518         payable
519     {
520         bytes32 _name = _nameString.nameFilter();
521         address _addr = msg.sender;
522         uint256 _paid = msg.value;
523         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
524         
525         uint256 _pID = pIDxAddr_[_addr];
526         
527         // fire event
528         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
529     }
530     
531     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
532         private
533         isActivated
534         returns(F3Ddatasets.EventReturns)
535     {
536         uint256 _com = _eth / 50;
537         uint256 _p3d;
538         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
539         {
540             _p3d = _com;
541             _com = 0;
542         }
543         uint256 _aff = _eth / 10;
544         if (_affID != _pID && plyr_[_affID].name != '') {
545             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
546             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
547         } else {
548             _p3d = _aff;
549         }
550         
551         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
552         if (_p3d > 0)
553         {
554             // set up event data
555             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
556         }
557         
558         return(_eventData_);
559     }
560         
561     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
562         private
563         isActivated
564         returns(F3Ddatasets.EventReturns)
565     {
566         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
567 
568         uint256 _air = (_eth / 100);
569         airDropPot_ = airDropPot_.add(_air);
570         
571         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
572         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
573 
574         uint256 _pot = _eth.sub(_gen);
575 
576         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
577         if (_dust > 0)
578             _gen = _gen.sub(_dust);
579 
580         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
581 
582         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
583         _eventData_.potAmount = _pot;
584         
585         return(_eventData_);
586     }
587     
588     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
589         private
590         isActivated
591         returns(uint256)
592     {
593 
594         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
595         round_[_rID].mask = _ppt.add(round_[_rID].mask);
596 
597         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
598         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
599 
600         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
601     }
602     
603     function endRound(F3Ddatasets.EventReturns memory _eventData_)
604         private
605         isActivated
606         returns (F3Ddatasets.EventReturns)
607     {
608         // setup local rID
609         uint256 _rID = rID_;
610         
611         // grab our winning player and team id's
612         uint256 _winPID = round_[_rID].plyr;
613         uint256 _winTID = round_[_rID].team;
614         
615         // grab our pot amount
616         uint256 _pot = round_[_rID].pot;
617         
618         // calculate our winner share, community rewards, gen share, 
619         // p3d share, and amount reserved for next pot 
620         uint256 _win = (_pot.mul(48)) / 100;
621         uint256 _com = (_pot / 50);
622         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
623         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
624         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
625         
626         // calculate ppt for round mask
627         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
628         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
629         if (_dust > 0)
630         {
631             _gen = _gen.sub(_dust);
632             _res = _res.add(_dust);
633         }
634         
635         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
636         
637         // community rewards
638         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
639         {
640             _p3d = _p3d.add(_com);
641             _com = 0;
642         }
643         
644         // distribute gen portion to key holders
645         round_[_rID].mask = _ppt.add(round_[_rID].mask);
646             
647         // prepare event data
648         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
649         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
650         _eventData_.winnerAddr = plyr_[_winPID].addr;
651         _eventData_.winnerName = plyr_[_winPID].name;
652         _eventData_.amountWon = _win;
653         _eventData_.genAmount = _gen;
654         _eventData_.P3DAmount = _p3d;
655         _eventData_.newPot = _res;
656         
657         // start next round
658         rID_++;
659         _rID++;
660         round_[_rID].strt = now;
661         round_[_rID].pot = _res;
662         
663         return(_eventData_);
664     }
665     
666     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
667         private
668         returns (F3Ddatasets.EventReturns)
669     {
670         uint256 _pID = pIDxAddr_[msg.sender];
671         // if player is new to this version of fomo3d
672         if (_pID == 0)
673         {
674             // grab their player ID, name and last aff ID, from player names contract 
675             _pID = PlayerBook.getPlayerID(msg.sender);
676             bytes32 _name = PlayerBook.getPlayerName(_pID);
677             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
678             
679             // set up player account 
680             pIDxAddr_[msg.sender] = _pID;
681             plyr_[_pID].addr = msg.sender;
682             
683             if (_name != "")
684             {
685                 pIDxName_[_name] = _pID;
686                 plyr_[_pID].name = _name;
687                 plyrNames_[_pID][_name] = true;
688             }
689             
690             if (_laff != 0 && _laff != _pID)
691                 plyr_[_pID].laff = _laff;
692             
693             // set the new player bool to true
694             _eventData_.compressedData = _eventData_.compressedData + 1;
695         } 
696         return (_eventData_);
697     }
698     
699     function sendBonus(address _addr,uint256 _bonus)
700         public
701         isActor
702         isEther
703         isInLimits(_bonus)
704         returns (bool)
705     {
706         //must have enough balance 
707         require(address(this).balance >= _bonus,'out of balance');
708         _addr.transfer(_bonus);
709         
710         return true;
711     }
712     
713     function getKeys(uint256 _keys)
714         public
715         view
716         returns(uint256)
717     {
718         uint256 _rID = rID_;
719         uint256 _now = now;
720         
721         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
722             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
723         else // rounds over.  need price for new round
724             return ( (_keys).eth() );
725     }
726     
727     function verifyTeam(uint256 _team)
728         private
729         pure
730         returns (uint256)
731     {
732         if (_team < 0 || _team > 3)
733             return(2);
734         else
735             return(_team);
736     }
737     
738     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
739         private
740         view
741         returns(uint256)
742     {
743         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
744     }
745     
746     function updateGenVault(uint256 _pID, uint256 _rIDlast)
747         private
748     {
749         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
750         if (_earnings > 0)
751         {
752             // put in gen vault
753             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
754             // zero out their earnings by updating mask
755             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
756         }
757     }
758     
759     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
760         private
761         isActor
762         returns (F3Ddatasets.EventReturns)
763     {
764         // if player has played a previous round, move their unmasked earnings
765         // from that round to gen vault.
766         if (plyr_[_pID].lrnd != 0)
767             updateGenVault(_pID, plyr_[_pID].lrnd);
768             
769         // update player's last round played
770         plyr_[_pID].lrnd = rID_;
771             
772         // set the joined round bool to true
773         _eventData_.compressedData = _eventData_.compressedData + 10;
774         
775         return(_eventData_);
776     }
777     
778     function()
779         public
780         payable
781     {
782         revert('do not send eth directly');
783     }
784     
785 }
786 
787 interface F3DexternalSettingsInterface {
788     function getFastGap() external returns(uint256);
789     function getLongGap() external returns(uint256);
790     function getFastExtra() external returns(uint256);
791     function getLongExtra() external returns(uint256);
792 }
793 
794 interface DiviesInterface {
795     function deposit() external payable;
796 }
797 
798 interface JIincForwarderInterface {
799     function deposit() external payable returns(bool);
800     function status() external view returns(address, address, bool);
801     function startMigration(address _newCorpBank) external returns(bool);
802     function cancelMigration() external returns(bool);
803     function finishMigration() external returns(bool);
804     function setup(address _firstCorpBank) external;
805 }
806 
807 interface PlayerBookInterface {
808     function getPlayerID(address _addr) external returns (uint256);
809     function getPlayerName(uint256 _pID) external view returns (bytes32);
810     function getPlayerLAff(uint256 _pID) external view returns (uint256);
811     function getPlayerAddr(uint256 _pID) external view returns (address);
812     function getNameFee() external view returns (uint256);
813     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
814     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
815     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
816 }