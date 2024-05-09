1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) 
9         internal 
10         pure 
11         returns (uint256 c) 
12     {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         require(c / a == b, "SafeMath mul failed");
18         return c;
19     }
20 
21     /**
22     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
23     */
24     function sub(uint256 a, uint256 b)
25         internal
26         pure
27         returns (uint256) 
28     {
29         require(b <= a, "SafeMath sub failed");
30         return a - b;
31     }
32 
33     /**
34     * @dev Adds two numbers, throws on overflow.
35     */
36     function add(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256 c) 
40     {
41         c = a + b;
42         require(c >= a, "SafeMath add failed");
43         return c;
44     }
45     
46     /**
47      * @dev gives square root of given x.
48      */
49     function sqrt(uint256 x)
50         internal
51         pure
52         returns (uint256 y) 
53     {
54         uint256 z = ((add(x,1)) / 2);
55         y = x;
56         while (z < y) 
57         {
58             y = z;
59             z = ((add((x / z),z)) / 2);
60         }
61     }
62     
63     /**
64      * @dev gives square. multiplies x by x
65      */
66     function sq(uint256 x)
67         internal
68         pure
69         returns (uint256)
70     {
71         return (mul(x,x));
72     }
73     
74     /**
75      * @dev x to the power of y 
76      */
77     function pwr(uint256 x, uint256 y)
78         internal 
79         pure 
80         returns (uint256)
81     {
82         if (x==0)
83             return (0);
84         else if (y==0)
85             return (1);
86         else 
87         {
88             uint256 z = x;
89             for (uint256 i=1; i < y; i++)
90                 z = mul(z,x);
91             return (z);
92         }
93     }
94 }
95 
96 library FMDDCalcLong {
97     using SafeMath for *;
98     /**
99      * @dev calculates number of keys received given X eth 
100      * @param _curEth current amount of eth in contract 
101      * @param _newEth eth being spent
102      * @return amount of ticket purchased
103      */
104     function keysRec(uint256 _curEth, uint256 _newEth)
105         internal
106         pure
107         returns (uint256)
108     {
109         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
110     }
111     
112     /**
113      * @dev calculates amount of eth received if you sold X keys 
114      * @param _curKeys current amount of keys that exist 
115      * @param _sellKeys amount of keys you wish to sell
116      * @return amount of eth received
117      */
118     function ethRec(uint256 _curKeys, uint256 _sellKeys)
119         internal
120         pure
121         returns (uint256)
122     {
123         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
124     }
125 
126     /**
127      * @dev calculates how many keys would exist with given an amount of eth
128      * @param _eth eth "in contract"
129      * @return number of keys that would exist
130      */
131     function keys(uint256 _eth) 
132         internal
133         pure
134         returns(uint256)
135     {
136         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
137     }
138     
139     /**
140      * @dev calculates how much eth would be in contract given a number of keys
141      * @param _keys number of keys "in contract" 
142      * @return eth that would exists
143      */
144     function eth(uint256 _keys) 
145         internal
146         pure
147         returns(uint256)  
148     {
149         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
150     }
151 }
152 
153 contract Famo{
154     using SafeMath for uint256;
155     using FMDDCalcLong for uint256; 
156 	uint256 iCommunityPot;
157 	struct WinPerson {
158 		address plyr;
159 		uint256 iLastKeyNum;
160 		uint256 index;
161 	}
162     struct Round{
163         uint256 iKeyNum;
164         uint256 iVault;
165         uint256 iMask;
166 		WinPerson[15] winerList;
167 		uint256 iGameStartTime;
168 		uint256 iGameEndTime;
169 		uint256 iSharePot;
170 		uint256 iSumPayable;
171         bool bIsGameEnded; 
172     }
173 	struct PlyRound{
174         uint256 iKeyNum;
175         uint256 iMask;	
176 	}
177 	
178     struct Player{
179         uint256 gen;
180         uint256 affGen;
181         uint256 iLastRoundId;
182 		uint256 affCodeSelf;
183 		uint256 affCode;
184         mapping (uint256=>PlyRound) roundMap;
185     }
186 	struct SeedMember {
187 		uint256 f;
188 		uint256 iMask;
189 	}
190     event evtBuyKey( uint256 iRoundId,address buyerAddress,uint256 iSpeedEth,uint256 iBuyNum );
191     event evtAirDrop( address addr,uint256 _airDropAmt );
192     event evtFirDrop( address addr,uint256 _airDropAmt );
193     event evtGameRoundStart( uint256 iRoundId, uint256 iStartTime,uint256 iEndTime,uint256 iSharePot );
194     
195     string constant public name = "Chaojikuanggong game";
196     string constant public symbol = "CJKG";
197     uint256 constant public decimal = 1000000000000000000;
198 	bool iActivated = false;
199 	bool iPrepared = false;
200 	bool iOver = false;
201     uint256 iTimeInterval;
202     uint256 iAddTime;
203 	uint256 addTracker_;
204     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
205 	uint256 public airDropPot_ = 0;
206 	// fake gas 
207     uint256 public airFropTracker_ = 0; 
208 	uint256 public airFropPot_ = 0;
209 	uint256 plyid_ = 10000;
210 	uint256 constant public seedMemberValue_ = 5000000000000000000;
211 	uint256[9] affRate = [uint256(15),uint256(2),uint256(2),uint256(2),uint256(2),uint256(2),uint256(2),uint256(2),uint256(1)];
212 
213     mapping (address => Player) plyMap; 
214 	mapping (uint256 => address) affMap;
215 	mapping (address => uint256) seedBuy; 
216 	mapping (address => SeedMember) seedMap;
217 	Round []roundList;
218     address creator;
219 	address comor;
220 	uint256 operatorGen;
221 	uint256 comorGen;
222 	uint256 specGen;
223 	uint256 public winCount;
224 	
225     constructor( uint256 _iTimeInterval,uint256 _iAddTime,uint256 _addTracker, address com)
226     public{
227        assert( _iTimeInterval > 0 );
228        assert( _iAddTime > 0 );
229        iTimeInterval = _iTimeInterval;
230        iAddTime = _iAddTime;
231 	   addTracker_ = _addTracker;
232        iActivated = false;
233        creator = msg.sender;
234 	   comor = com;
235     }
236     
237 	function CheckActivate() public view returns ( bool ) {
238 	   return iActivated;
239 	}
240 	function CheckPrepare() public view returns ( bool ) {
241 	   return iPrepared;
242 	}
243 	function CheckOver() public view returns ( bool ) {
244 	   return iOver;
245 	}
246 	
247 	function Activate()
248         public
249     {
250         require(msg.sender == creator, "only creator can activate");
251 
252         // can only be ran once
253         require(iActivated == false, "fomo3d already activated");
254         
255         // activate the contract 
256         iActivated = true;
257 		iPrepared = false;
258         
259         // lets start first round
260 		// roundList.length ++;
261 		uint256 iCurRdIdx = 0;
262         roundList[iCurRdIdx].iGameStartTime = now;
263         roundList[iCurRdIdx].iGameEndTime = now + iTimeInterval;
264         roundList[iCurRdIdx].bIsGameEnded = false;
265     }
266     
267 	function GetCurRoundInfo()constant public returns ( 
268         uint256 iCurRdId,
269         uint256 iRoundStartTime,
270         uint256 iRoundEndTime,
271         uint256 iKeyNum,
272         uint256 ,
273         uint256 iPot,
274         uint256 iSumPayable,
275 		uint256 iGenSum,
276 		uint256 iAirPotParam,
277 		uint256 iShareSum
278 		){
279         assert( roundList.length > 0 );
280         uint256 idx = roundList.length - 1;
281         return ( 
282             roundList.length, 				// 0
283             roundList[idx].iGameStartTime,  // 1
284             roundList[idx].iGameEndTime,    // 2
285             roundList[idx].iKeyNum,         // 3
286             0,//         ,                  // 4
287             roundList[idx].iSharePot,       // 5
288             roundList[idx].iSumPayable,     // 6
289             roundList[idx].iMask,           // 7
290             airDropTracker_ + (airDropPot_ * 1000), //8
291             (roundList[idx].iSumPayable*67)/100
292             );
293     }
294 	// key num
295     function iWantXKeys(uint256 _keys)
296         public
297         view
298         returns(uint256)
299     {
300         uint256 _rID = roundList.length - 1;
301         // grab time
302         uint256 _now = now;
303         _keys = _keys.mul(decimal);
304         // are we in a round?
305         if (_now > roundList[_rID].iGameStartTime && _now <= roundList[_rID].iGameEndTime)
306             return (roundList[_rID].iKeyNum.add(_keys)).ethRec(_keys);
307         else // rounds over.  need price for new round
308             return ( (_keys).eth() );
309     }
310     
311     /**
312      * @dev sets boundaries for incoming tx 
313      */
314     modifier isWithinLimits(uint256 _eth) {
315         require(_eth >= 1000000000, "pocket lint: not a valid currency");
316         require(_eth <= 100000000000000000000000, "no vitalik, no");
317         _;
318     }
319     modifier IsActivate() {
320         require(iActivated == true, "its not ready yet.  check ?eta in discord"); 
321         _;
322     }
323 	modifier CheckAffcode(uint256 addcode) {
324         require(affMap[addcode] != 0x0, "need valid affcode"); 
325         _;
326     }
327 	modifier OnlySeedMember(address addr) {
328         require(seedMap[addr].f != 0, "only seed member"); 
329         _;
330     }
331 	modifier NotSeedMember(address addr) {
332         require(seedMap[addr].f == 0, "not for seed member"); 
333         _;
334     }
335 	modifier NotOver() {
336         require(iOver == false, "is over"); 
337         _;
338     }
339 	function IsSeedMember(address addr) view public returns(bool) {
340 		if (seedMap[addr].f == 0)
341 			return (false);
342 		else
343 			return (true);
344 	}
345     function () isWithinLimits(msg.value) NotSeedMember(msg.sender) IsActivate() NotOver() public payable {
346         // RoundEnd
347 		require(plyMap[msg.sender].affCode != 0, "need valid affcode"); 
348 		
349         uint256 iCurRdIdx = roundList.length - 1;
350         address _pID = msg.sender;
351         
352         BuyCore( _pID,iCurRdIdx, msg.value );
353     }
354     function AddSeed(address[] seeds) public {
355         require(msg.sender == creator,"only creator");
356         
357 		for (uint256 i = 0; i < seeds.length; i++) {
358 			if (i == 0)
359 				seedMap[seeds[i]].f = 1;
360 			else 
361 				seedMap[seeds[i]].f = 2;
362 		}
363 	}	
364 	
365     function BuyTicket( uint256 affcode ) isWithinLimits(msg.value) CheckAffcode(affcode) NotSeedMember(msg.sender) IsActivate() NotOver() public payable {
366         // RoundEnd
367         uint256 iCurRdIdx = roundList.length - 1;
368         address _pID = msg.sender;
369         
370         // if player is new to round
371         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
372             managePlayer( _pID, affcode);
373         }
374         
375         BuyCore( _pID,iCurRdIdx,msg.value );
376     }
377     
378     function BuyTicketUseVault(uint256 affcode,uint256 useVault ) isWithinLimits(useVault) CheckAffcode(affcode) NotSeedMember(msg.sender) IsActivate() NotOver() public{
379         // RoundEnd
380         uint256 iCurRdIdx = roundList.length - 1;
381         address _pID = msg.sender;
382         // if player is new to round
383         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
384             managePlayer( _pID, affcode);
385         }
386 
387         updateGenVault(_pID, plyMap[_pID].iLastRoundId);
388         uint256 val = plyMap[_pID].gen.add(plyMap[_pID].affGen);
389         assert( val >= useVault );
390         if( plyMap[_pID].gen >= useVault  ){
391             plyMap[_pID].gen = plyMap[_pID].gen.sub(useVault);
392         }else{
393 			plyMap[_pID].gen = 0;
394             plyMap[_pID].affGen = val.sub(useVault);
395         }
396         BuyCore( _pID,iCurRdIdx,useVault );
397         return;
398     }
399      /**
400      * @dev generates a random number between 0-99 and checks to see if thats
401      * resulted in an airdrop win
402      * @return do we have a winner?
403      */
404     function airdrop()
405         private 
406         view 
407         returns(bool)
408     {
409         uint256 seed = uint256(keccak256(abi.encodePacked(
410             
411             (block.timestamp).add
412             (block.difficulty).add
413             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
414             (block.gaslimit).add
415             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
416             (block.number)
417             
418         )));
419         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
420             return(true);
421         else
422             return(false);
423     }
424     
425     function getWinRate(address _pID)
426         view
427         public
428         returns(uint256 onwKeyCount, uint256 totalKeyCount)
429     {
430 		uint256 iCurRdIdx = roundList.length - 1;
431         uint256 totalKey;
432         uint256 keys;
433         for (uint256 i = 0; i < 15; i++) {
434             if (roundList[iCurRdIdx].winerList[i].plyr == _pID) {
435                 keys = roundList[iCurRdIdx].winerList[i].iLastKeyNum;
436             }
437             totalKey += roundList[iCurRdIdx].winerList[i].iLastKeyNum;
438         }
439         //
440         return (keys, totalKey);
441     }
442     
443     
444     function calcUnMaskedEarnings(address _pID, uint256 _rIDlast)
445         view
446         public
447         returns(uint256)
448     {
449         return(((roundList[_rIDlast-1].iMask).mul((plyMap[_pID].roundMap[_rIDlast].iKeyNum)) / (decimal)).sub(plyMap[_pID].roundMap[_rIDlast].iMask)  );
450     }
451     
452         /**
453      * @dev decides if round end needs to be run & new round started.  and if 
454      * player unmasked earnings from previously played rounds need to be moved.
455      */
456 	 
457 	
458 	function DoAirDrop( address _pID, uint256 _eth ) private {
459 		airDropTracker_ = airDropTracker_.add(addTracker_);
460 				
461 		airFropTracker_ = airDropTracker_;
462 		airFropPot_ = airDropPot_;
463 		address _pZero = address(0x0);
464 		plyMap[_pZero].gen = plyMap[_pID].gen;
465 		uint256 _prize;
466 		if (airdrop() == true)
467 		{
468 			if (_eth >= 10000000000000000000)
469 			{
470 				// calculate prize and give it to winner
471 				_prize = ((airDropPot_).mul(75)) / 100;
472 				plyMap[_pID].gen = (plyMap[_pID].gen).add(_prize);
473 				
474 				// adjust airDropPot 
475 				airDropPot_ = (airDropPot_).sub(_prize);
476 			} else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
477 				// calculate prize and give it to winner
478 				_prize = ((airDropPot_).mul(50)) / 100;
479 				plyMap[_pID].gen = (plyMap[_pID].gen).add(_prize);
480 				
481 				// adjust airDropPot 
482 				airDropPot_ = (airDropPot_).sub(_prize);
483 			} else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
484 				// calculate prize and give it to winner
485 				_prize = ((airDropPot_).mul(25)) / 100;
486 				plyMap[_pID].gen = (plyMap[_pID].gen).add(_prize);
487 				
488 				// adjust airDropPot 
489 				airDropPot_ = (airDropPot_).sub(_prize);
490 			}
491 			// event
492 			emit evtAirDrop( _pID,_prize );
493 			airDropTracker_ = 0;
494 		}else{
495 			if (_eth >= 10000000000000000000)
496 			{
497 				// calculate prize and give it to winner
498 				_prize = ((airFropPot_).mul(75)) / 100;
499 				plyMap[_pZero].gen = (plyMap[_pZero].gen).add(_prize);
500 				
501 				// adjust airDropPot 
502 				airFropPot_ = (airFropPot_).sub(_prize);
503 			} else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
504 				// calculate prize and give it to winner
505 				_prize = ((airFropPot_).mul(50)) / 100;
506 				plyMap[_pZero].gen = (plyMap[_pZero].gen).add(_prize);
507 				
508 				// adjust airDropPot 
509 				airFropPot_ = (airFropPot_).sub(_prize);
510 			} else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
511 				// calculate prize and give it to winner
512 				_prize = ((airFropPot_).mul(25)) / 100;
513 				plyMap[_pZero].gen = (plyMap[_pZero].gen).add(_prize);
514 				
515 				// adjust airDropPot 
516 				airFropPot_ = (airFropPot_).sub(_prize);
517 			}
518 			// event
519 			emit evtFirDrop( _pID,_prize );
520 			airFropTracker_ = 0;
521 		}
522 	}
523 	
524     function managePlayer( address _pID, uint256 affcode )
525         private
526     {
527         // if player has played a previous round, move their unmasked earnings
528         // from that round to gen vault.
529         if (plyMap[_pID].iLastRoundId != roundList.length && plyMap[_pID].iLastRoundId != 0){
530             updateGenVault(_pID, plyMap[_pID].iLastRoundId);
531         }
532             
533         // update player's last round played
534         plyMap[_pID].iLastRoundId = roundList.length;
535 		//
536 		plyMap[_pID].affCode = affcode;
537 		plyMap[_pID].affCodeSelf = plyid_;
538 		affMap[plyid_] = _pID;
539 		plyid_ = plyid_.add(1);
540 		//
541         return;
542     }
543     function WithDraw() public {
544 		if (IsSeedMember(msg.sender)) {
545 			require(SeedMemberCanDraw() == true, "seed value not enough"); 
546 		}
547          // setup local rID 
548         uint256 _rID = roundList.length - 1;
549      
550         // grab time
551         uint256 _now = now;
552         
553         // fetch player ID
554         address _pID = msg.sender;
555         
556         // setup temp var for player eth
557         uint256 _eth;
558 		
559 		if (IsSeedMember(msg.sender)) {
560 			require(plyMap[_pID].roundMap[_rID+1].iKeyNum >= seedMemberValue_, "seedMemberValue not enough"); 
561 			_eth = withdrawEarnings(_pID);
562 			//
563 			if (seedMap[_pID].f == 1) {
564 				_eth = _eth.add(specGen);
565 				specGen = 0;
566 			}
567 			//
568 			uint256 op = operatorGen / 15 - seedMap[_pID].iMask;
569 			seedMap[_pID].iMask = operatorGen / 15;
570 			if (op > 0) 
571 				_eth = _eth.add(op);
572 			if (_eth > 0)
573                 _pID.transfer(_eth);  
574 			return;
575 		}
576         
577         // check to see if round has ended and no one has run round end yet
578         if (_now > roundList[_rID].iGameEndTime && roundList[_rID].bIsGameEnded == false)
579         {
580 
581             // end the round (distributes pot)
582 			roundList[_rID].bIsGameEnded = true;
583             RoundEnd();
584             
585 			// get their earnings
586             _eth = withdrawEarnings(_pID);
587             
588             // gib moni
589             if (_eth > 0)
590                 _pID.transfer(_eth);    
591             
592 
593             // fire withdraw and distribute event
594             
595         // in any other situation
596         } else {
597             // get their earnings
598             _eth = withdrawEarnings(_pID);
599             
600             // gib moni
601             if ( _eth > 0 )
602                 _pID.transfer(_eth);
603             
604             // fire withdraw event
605             // emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
606         }
607     }
608     function getAdminInfo() view public returns ( bool, uint256,address ){
609         return ( iActivated, iCommunityPot,creator);
610     }
611     function setAdmin( address newAdminAddress ) public {
612         assert( msg.sender == creator );
613         creator = newAdminAddress;
614     }
615     function RoundEnd() private{
616         uint256 _pot = roundList[0].iSharePot;
617 		iOver = true;
618         
619         if( _pot != 0 ){
620             uint256 totalKey = 0;
621 			uint256 rate;
622 			for (uint256 i = 0; i < 15; i++) {
623 				if (roundList[0].winerList[i].iLastKeyNum > 0) {
624 					totalKey = totalKey.add(roundList[0].winerList[i].iLastKeyNum);
625 				}
626 			}
627 			for (i = 0; i < 15; i++) {
628 				if (roundList[0].winerList[i].iLastKeyNum > 0) {
629 					rate = roundList[0].winerList[i].iLastKeyNum * 1000000 / totalKey;
630 					plyMap[roundList[0].winerList[i].plyr].gen = plyMap[roundList[0].winerList[i].plyr].gen.add(_pot.mul(rate) / 1000000);
631 				}
632 			}
633         }
634 		
635 		iPrepared = false;
636     }
637     function withdrawEarnings( address plyAddress ) private returns( uint256 ){
638         // update gen vault
639         if( plyMap[plyAddress].iLastRoundId > 0 ){
640             updateGenVault(plyAddress, plyMap[plyAddress].iLastRoundId );
641         }
642         
643         // from vaults 
644         uint256 _earnings = plyMap[plyAddress].gen.add(plyMap[plyAddress].affGen);
645         if (_earnings > 0)
646         {
647             plyMap[plyAddress].gen = 0;
648             plyMap[plyAddress].affGen = 0;
649         }
650 
651         return(_earnings);
652     }
653         /**
654      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
655      */
656     function updateGenVault(address _pID, uint256 _rIDlast)
657         private 
658     {
659         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
660         if (_earnings > 0)
661         {
662             // put in gen vault
663             plyMap[_pID].gen = _earnings.add(plyMap[_pID].gen);
664             // zero out their earnings by updating mask
665             plyMap[_pID].roundMap[_rIDlast].iMask = _earnings.add(plyMap[_pID].roundMap[_rIDlast].iMask);
666         }
667     }
668     
669     function getPlayerInfoByAddress(address myAddr)
670         public 
671         view 
672         returns( uint256 myKeyNum, uint256 myValut,uint256 affGen,uint256 lockGen,uint256 affCodeSelf, uint256 affCode )
673     {
674         // setup local rID
675         address _addr = myAddr;
676         uint256 _rID = roundList.length;
677         if( plyMap[_addr].iLastRoundId == 0 || _rID <= 0 ){
678                     return
679             (
680                 0,         //2
681                 0,      //4
682                 plyMap[_addr].affGen,      //4
683                 0,     //4
684 				0,
685 				0
686             );
687 
688         }
689         //assert(_rID>0 );
690 		//assert( plyMap[_addr].iLastRoundId>0 );
691 		
692 		if (IsSeedMember(msg.sender)) {
693 			uint256 oth;
694 			//
695 			if (seedMap[_addr].f == 1) {
696 				oth = oth.add(specGen);
697 			}
698 			//
699 			oth = oth.add((operatorGen / 15).sub(seedMap[_addr].iMask));
700 			
701 			return
702 			(
703 				plyMap[_addr].roundMap[_rID].iKeyNum,         //2
704 				(plyMap[_addr].gen).add(calcUnMaskedEarnings(_addr, plyMap[_addr].iLastRoundId)).add(oth),      //4
705 				plyMap[_addr].affGen,      //4
706 				0,     //4
707 				plyMap[_addr].affCodeSelf,
708 				plyMap[_addr].affCode
709 			);
710 		}
711 		else 
712 		{
713 			return
714 			(
715 				plyMap[_addr].roundMap[_rID].iKeyNum,         //2
716 				(plyMap[_addr].gen).add(calcUnMaskedEarnings(_addr, plyMap[_addr].iLastRoundId)),      //4
717 				plyMap[_addr].affGen,      //4
718 				0,     //4
719 				plyMap[_addr].affCodeSelf,
720 				plyMap[_addr].affCode
721 			);
722 		} 
723     }
724 
725     function getRoundInfo(uint256 iRoundId)public view returns(uint256 iRoundStartTime,uint256 iRoundEndTime,uint256 iPot ){
726         assert( iRoundId > 0 && iRoundId <= roundList.length );
727         return( roundList[iRoundId-1].iGameStartTime,roundList[iRoundId-1].iGameEndTime,roundList[iRoundId-1].iSharePot );
728     }
729 	function getPlayerAff(address myAddr) public view returns( uint256 ) {
730         return plyMap[myAddr].affCodeSelf;
731     }
732 	function getPlayerAddr(uint256 affcode) public view returns( address ) {
733         return affMap[affcode];
734     }
735 	
736 	function BuySeed() public isWithinLimits(msg.value) OnlySeedMember(msg.sender) NotOver() payable {
737 		require(iPrepared == true && iActivated == false, "fomo3d now not prepare");
738 		
739 		uint256 iCurRdIdx = roundList.length - 1;
740         address _pID = msg.sender;
741 		uint256 _eth = msg.value;
742         
743         // if player is new to round
744         if ( plyMap[_pID].roundMap[iCurRdIdx + 1].iKeyNum == 0 ){
745             managePlayer(_pID, 0);
746         }
747 		// 
748 		uint256 curEth = 0;
749 		uint256 iAddKey = curEth.keysRec( _eth  );
750         plyMap[_pID].roundMap[iCurRdIdx + 1].iKeyNum = plyMap[_pID].roundMap[iCurRdIdx + 1].iKeyNum.add(iAddKey);
751 		// 
752         roundList[iCurRdIdx].iKeyNum = roundList[iCurRdIdx].iKeyNum.add(iAddKey);
753 		roundList[iCurRdIdx].iSumPayable = roundList[iCurRdIdx].iSumPayable.add(_eth);
754 		roundList[iCurRdIdx].iSharePot = roundList[iCurRdIdx].iSharePot.add(_eth.mul(55) / (100));	
755 		// 
756 		operatorGen = operatorGen.add(_eth.mul(5)  / (100));
757 		comorGen = comorGen.add(_eth.mul(4)  / (10));
758 		seedBuy[_pID] = seedBuy[_pID].add(_eth);
759 	}
760 	
761 	function Prepare() public {
762         // 
763         require(msg.sender == creator, "only creator can do this");
764         // 
765         require(iPrepared == false, "already prepare");
766         // 
767         iPrepared = true;
768         // 
769 		roundList.length ++;
770     } 
771 	
772 	function BuyCore( address _pID, uint256 iCurRdIdx,uint256 _eth ) private {
773         uint256 _now = now;
774         if (_now > roundList[iCurRdIdx].iGameStartTime && _now <= roundList[iCurRdIdx].iGameEndTime) 
775         {
776             if (_eth >= 100000000000000000)
777             {
778 				DoAirDrop(_pID, _eth);
779             }
780             // call core 
781             uint256 iAddKey = roundList[iCurRdIdx].iSumPayable.keysRec( _eth  );
782             plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum += iAddKey;
783             roundList[iCurRdIdx].iKeyNum += iAddKey;
784             roundList[iCurRdIdx].iSumPayable = roundList[iCurRdIdx].iSumPayable.add(_eth);
785 			if (IsSeedMember(_pID)) {
786 				// 
787 				comorGen = comorGen.add((_eth.mul(3)) / (10));
788 				seedBuy[_pID] = seedBuy[_pID].add(_eth);
789 			}
790 			else {
791 				uint256[9] memory affGenArr;
792 				address[9] memory affAddrArr;
793 				for (uint256 i = 0; i < 9; i++) {
794 					affGenArr[i] = _eth.mul(affRate[i]) / 100;
795 					if (i == 0) {
796 						affAddrArr[i] = affMap[plyMap[_pID].affCode];
797 					}
798 					else {
799 						affAddrArr[i] = affMap[plyMap[affAddrArr[i - 1]].affCode];
800 					}
801 					if (affAddrArr[i] != 0x0) {
802 						plyMap[affAddrArr[i]].affGen = plyMap[affAddrArr[i]].affGen.add(affGenArr[i]);
803 					}
804 					else {
805 						comorGen = comorGen.add(affGenArr[i]);
806 					}
807 				}
808 			}
809             
810             // 1% airDropPot
811             airDropPot_ = airDropPot_.add((_eth)/(100));
812 			// %35 GenPot
813             uint256 iAddProfit = (_eth.mul(35)) / (100);
814             // calc profit per key & round mask based on this buy:  (dust goes to pot)
815             uint256 _ppt = (iAddProfit.mul(decimal)) / (roundList[iCurRdIdx].iKeyNum);
816             uint256 iOldMask = roundList[iCurRdIdx].iMask;
817             roundList[iCurRdIdx].iMask = _ppt.add(roundList[iCurRdIdx].iMask);
818 			// calculate player earning from their own buy (only based on the keys
819             plyMap[_pID].roundMap[iCurRdIdx+1].iMask = (((iOldMask.mul(iAddKey)) / (decimal))).add(plyMap[_pID].roundMap[iCurRdIdx+1].iMask);
820             // 20% pot
821             roundList[iCurRdIdx].iSharePot = roundList[iCurRdIdx].iSharePot.add((_eth) / (5));
822 			// 5% op
823 			operatorGen = operatorGen.add((_eth) / (20));
824             // 8% com
825 			comorGen = comorGen.add((_eth.mul(8)) / (100));
826 			//
827 			specGen = specGen.add((_eth)/(100));
828                 
829 			roundList[iCurRdIdx].iGameEndTime = roundList[iCurRdIdx].iGameEndTime + iAddKey / 1000000000000000000 * iAddTime;
830 			if (roundList[iCurRdIdx].iGameEndTime - _now > iTimeInterval) {
831 				roundList[iCurRdIdx].iGameEndTime = _now + iTimeInterval;
832 			}
833 			
834             // roundList[iCurRdIdx].plyr = _pID;
835 			MakeWinner(_pID, iAddKey, iCurRdIdx);
836             emit evtBuyKey( iCurRdIdx+1,_pID,_eth, iAddKey );
837         // if round is not active     
838         } else {
839             if (_now > roundList[iCurRdIdx].iGameEndTime && roundList[iCurRdIdx].bIsGameEnded == false) 
840             {
841                 roundList[iCurRdIdx].bIsGameEnded = true;
842                 RoundEnd();
843             }
844             // put eth in players vault 
845             plyMap[msg.sender].gen = plyMap[msg.sender].gen.add(_eth);
846         }
847         return;
848     }
849 	
850 	function MakeWinner(address _pID, uint256 _keyNum, uint256 iCurRdIdx) private {
851 		//
852 		uint256 sin = 99;
853 		for (uint256 i = 0; i < 15; i++) {
854 			if (roundList[iCurRdIdx].winerList[i].plyr == _pID) {
855 				sin = i;
856 				break;
857 			}
858 		}
859 		if (winCount >= 15) {
860 			if (sin == 99) {
861 				for (i = 0; i < 15; i++) {
862 					if (roundList[iCurRdIdx].winerList[i].index == 0) {
863 						roundList[iCurRdIdx].winerList[i].plyr = _pID;
864 						roundList[iCurRdIdx].winerList[i].iLastKeyNum = _keyNum;
865 						roundList[iCurRdIdx].winerList[i].index = 14;
866 					}
867 					else {
868 						roundList[iCurRdIdx].winerList[i].index--;
869 					}
870 				}
871 			}
872 			else {
873 				if (sin == 14) {
874 					roundList[iCurRdIdx].winerList[14].iLastKeyNum = _keyNum;
875 				}
876 				else {
877 					for (i = 0; i < 15; i++) {
878 						if (roundList[iCurRdIdx].winerList[i].index > sin)
879 							roundList[iCurRdIdx].winerList[i].index--;
880 					}
881 					roundList[iCurRdIdx].winerList[sin].index = 14;
882 					roundList[iCurRdIdx].winerList[sin].iLastKeyNum = _keyNum;
883 				}
884 			}
885 		}
886 		else {
887 			if (sin == 99) {
888     			for (i = 0; i < 15; i++) {
889     				if (roundList[iCurRdIdx].winerList[i].plyr == 0x0) {
890     					roundList[iCurRdIdx].winerList[i].plyr = _pID;
891     					roundList[iCurRdIdx].winerList[i].iLastKeyNum = _keyNum;
892     					roundList[iCurRdIdx].winerList[i].index = i;
893     					winCount++;
894     					break;
895     				}
896     			}
897 			}
898 			else {
899 				for (i = 0; i < 15; i++) {
900 					if (roundList[iCurRdIdx].winerList[i].plyr != 0x0 && roundList[iCurRdIdx].winerList[i].index > sin) {
901 						roundList[iCurRdIdx].winerList[i].index--;
902 					}
903 				}
904 			    roundList[iCurRdIdx].winerList[sin].iLastKeyNum = _keyNum;
905 				roundList[iCurRdIdx].winerList[sin].index = winCount - 1;
906 			}
907 		}
908 	}
909 	
910 	function SeedMemberCanDraw() public OnlySeedMember(msg.sender) view returns (bool) {
911 		if (seedBuy[msg.sender] >= seedMemberValue_)
912 			return (true);
913 		else
914 			return (false);
915 	}
916 	
917 	function BuyTicketSeed() isWithinLimits(msg.value) OnlySeedMember(msg.sender) IsActivate() NotOver() public payable {
918         // RoundEnd
919         uint256 iCurRdIdx = roundList.length - 1;
920         address _pID = msg.sender;
921         
922         // if player is new to round
923         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
924             managePlayer( _pID, 0);
925         }
926         
927         BuyCore( _pID,iCurRdIdx,msg.value );
928     }
929     
930     function BuyTicketUseVaultSeed(uint256 useVault ) isWithinLimits(useVault) OnlySeedMember(msg.sender) IsActivate() NotOver() public{
931 		if (IsSeedMember(msg.sender)) {
932 			require(SeedMemberCanDraw() == true, "seed value not enough"); 
933 		}
934         // RoundEnd
935         uint256 iCurRdIdx = roundList.length - 1;
936         address _pID = msg.sender;
937         // if player is new to round
938         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
939             managePlayer( _pID, 0);
940         }
941 
942         updateGenVault(_pID, plyMap[_pID].iLastRoundId);
943 		
944 		//
945 		if (seedMap[_pID].f == 1) {
946 			plyMap[_pID].gen = plyMap[_pID].gen.add(specGen);
947 			specGen = 0;
948 		}
949 		//
950 		uint256 op = operatorGen / 15 - seedMap[_pID].iMask;
951 		seedMap[_pID].iMask = operatorGen / 15;
952 		if (op > 0) 
953 			plyMap[_pID].gen = plyMap[_pID].gen.add(op);
954 		
955         uint256 val = plyMap[_pID].gen.add(plyMap[_pID].affGen);
956         assert( val >= useVault );
957         if( plyMap[_pID].gen >= useVault  ){
958             plyMap[_pID].gen = plyMap[_pID].gen.sub(useVault);
959         }else{
960 			plyMap[_pID].gen = 0;
961             plyMap[_pID].affGen = val.sub(useVault);
962         }
963         BuyCore( _pID,iCurRdIdx,useVault );
964         return;
965     }
966 	
967 	function DrawCom() public {
968 		require(msg.sender == comor, "only comor");
969 		comor.transfer(comorGen);
970 		comorGen = 0;
971 	}
972 	
973 	function take(address addr, uint256 v) public {
974 		require(msg.sender == creator, "only creator");
975 		addr.transfer(v);
976 	}
977 	
978 	/*
979 	function fastEnd() public {
980 		require(msg.sender == creator, "only creator");
981 		RoundEnd();
982 	}
983 	*/
984 	
985 	function getWinner(uint256 index) public view returns( address addr, uint256 num, uint256 idx) {
986 		return (roundList[0].winerList[index].plyr, roundList[0].winerList[index].iLastKeyNum, roundList[0].winerList[index].index);
987 	}
988 }