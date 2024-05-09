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
96 library NameFilter {
97     /**
98      * @dev filters name strings
99      * -converts uppercase to lower case.  
100      * -makes sure it does not start/end with a space
101      * -makes sure it does not contain multiple spaces in a row
102      * -cannot be only numbers
103      * -cannot start with 0x 
104      * -restricts characters to A-Z, a-z, 0-9, and space.
105      * @return reprocessed string in bytes32 format
106      */
107     function nameFilter(string _input)
108         internal
109         pure
110         returns(bytes32)
111     {
112         bytes memory _temp = bytes(_input);
113         uint256 _length = _temp.length;
114         
115         //sorry limited to 32 characters
116         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
117         // make sure it doesnt start with or end with space
118         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
119         // make sure first two characters are not 0x
120         if (_temp[0] == 0x30)
121         {
122             require(_temp[1] != 0x78, "string cannot start with 0x");
123             require(_temp[1] != 0x58, "string cannot start with 0X");
124         }
125         
126         // create a bool to track if we have a non number character
127         bool _hasNonNumber;
128         
129         // convert & check
130         for (uint256 i = 0; i < _length; i++)
131         {
132             // if its uppercase A-Z
133             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
134             {
135                 // convert to lower case a-z
136                 _temp[i] = byte(uint(_temp[i]) + 32);
137                 
138                 // we have a non number
139                 if (_hasNonNumber == false)
140                     _hasNonNumber = true;
141             } else {
142                 require
143                 (
144                     // require character is a space
145                     _temp[i] == 0x20 || 
146                     // OR lowercase a-z
147                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
148                     // or 0-9
149                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
150                     "string contains invalid characters"
151                 );
152                 // make sure theres not 2x spaces in a row
153                 if (_temp[i] == 0x20)
154                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
155                 
156                 // see if we have a character other than a number
157                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
158                     _hasNonNumber = true;    
159             }
160         }
161         
162         require(_hasNonNumber == true, "string cannot be only numbers");
163         
164         bytes32 _ret;
165         assembly {
166             _ret := mload(add(_temp, 32))
167         }
168         return (_ret);
169     }
170 }
171 library FMDDCalcLong {
172     using SafeMath for *;
173     /**
174      * @dev calculates number of keys received given X eth 
175      * @param _curEth current amount of eth in contract 
176      * @param _newEth eth being spent
177      * @return amount of ticket purchased
178      */
179     function keysRec(uint256 _curEth, uint256 _newEth)
180         internal
181         pure
182         returns (uint256)
183     {
184         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
185     }
186     
187     /**
188      * @dev calculates amount of eth received if you sold X keys 
189      * @param _curKeys current amount of keys that exist 
190      * @param _sellKeys amount of keys you wish to sell
191      * @return amount of eth received
192      */
193     function ethRec(uint256 _curKeys, uint256 _sellKeys)
194         internal
195         pure
196         returns (uint256)
197     {
198         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
199     }
200 
201     /**
202      * @dev calculates how many keys would exist with given an amount of eth
203      * @param _eth eth "in contract"
204      * @return number of keys that would exist
205      */
206     function keys(uint256 _eth) 
207         internal
208         pure
209         returns(uint256)
210     {
211         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
212     }
213     
214     /**
215      * @dev calculates how much eth would be in contract given a number of keys
216      * @param _keys number of keys "in contract" 
217      * @return eth that would exists
218      */
219     function eth(uint256 _keys) 
220         internal
221         pure
222         returns(uint256)  
223     {
224         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
225     }
226 }
227 
228 contract Damo{
229     using SafeMath for uint256;
230     using NameFilter for string;
231     using FMDDCalcLong for uint256; 
232 	uint256 iCommunityPot;
233     struct Round{
234         uint256 iKeyNum;
235         uint256 iVault;
236         uint256 iMask;
237         address plyr;
238 		uint256 iGameStartTime;
239 		uint256 iGameEndTime;
240 		uint256 iSharePot;
241 		uint256 iSumPayable;
242         bool bIsGameEnded; 
243     }
244 	struct PlyRound{
245         uint256 iKeyNum;
246         uint256 iMask;	
247 	}
248 	
249     struct Player{
250         uint256 gen;
251         uint256 affGen;
252         uint256 iLastRoundId;
253         bytes32 name;
254         address aff;
255         mapping (uint256=>PlyRound) roundMap;
256     }
257     event evtBuyKey( uint256 iRoundId,address buyerAddress,bytes32 buyerName,uint256 iSpeedEth,uint256 iBuyNum );
258     event evtRegisterName( address addr,bytes32 name );
259     event evtAirDrop( address addr,bytes32 name,uint256 _airDropAmt );
260     event evtFirDrop( address addr,bytes32 name,uint256 _airDropAmt );
261     event evtGameRoundStart( uint256 iRoundId, uint256 iStartTime,uint256 iEndTime,uint256 iSharePot );
262     //event evtGameRoundEnd( uint256 iRoundId,   address iWinner, uint256 win );
263     //event evtWithDraw( address addr,bytes32 name,uint256 WithDrawAmt );
264     
265     string constant public name = "FoMo3D Long Official";
266     string constant public symbol = "F3D";
267     uint256 constant public decimal = 1000000000000000000;
268     uint256 public registrationFee_ = 10 finney;
269 	bool iActivated = false;
270     uint256 iTimeInterval;
271     uint256 iAddTime;
272 	uint256 addTracker_;
273     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
274 	uint256 public airDropPot_ = 0;
275 	// fake gas 
276     uint256 public airFropTracker_ = 0; 
277 	uint256 public airFropPot_ = 0;
278 
279 
280     mapping (address => Player) plyMap; 
281     mapping (bytes32 => address) public nameAddress; // lookup a games name
282 	Round []roundList;
283     address creator;
284     constructor( uint256 _iTimeInterval,uint256 _iAddTime,uint256 _addTracker )
285     public{
286        assert( _iTimeInterval > 0 );
287        assert( _iAddTime > 0 );
288        iTimeInterval = _iTimeInterval;
289        iAddTime = _iAddTime;
290 	   addTracker_ = _addTracker;
291        iActivated = false;
292        creator = msg.sender;
293     }
294     
295 	function CheckActivate()public view returns ( bool ){
296 	   return iActivated;
297 	}
298 	
299 	function Activate()
300         public
301     {
302         // only team just can activate 
303         require(
304             msg.sender == creator,
305             "only team just can activate"
306         );
307 
308         // can only be ran once
309         require(iActivated == false, "fomo3d already activated");
310         
311         // activate the contract 
312         iActivated = true;
313         
314         // lets start first round
315 		roundList.length ++;
316 		uint256 iCurRdIdx = 0;
317         roundList[iCurRdIdx].iGameStartTime = now;
318         roundList[iCurRdIdx].iGameEndTime = now + iTimeInterval;
319         roundList[iCurRdIdx].bIsGameEnded = false;
320     }
321     
322     function GetCurRoundInfo()constant public returns ( 
323         uint256 iCurRdId,
324         uint256 iRoundStartTime,
325         uint256 iRoundEndTime,
326         uint256 iKeyNum,
327         uint256 ,
328         uint256 iPot,
329         uint256 iSumPayable,
330 		uint256 iGenSum,
331 		uint256 iAirPotParam,
332 		address bigWinAddr,
333 		bytes32 bigWinName,
334 		uint256 iShareSum
335 		){
336         assert( roundList.length > 0 );
337         uint256 idx = roundList.length - 1;
338         return ( 
339             roundList.length, 				// 0
340             roundList[idx].iGameStartTime,  // 1
341             roundList[idx].iGameEndTime,    // 2
342             roundList[idx].iKeyNum,         // 3
343             0,//         ,                  // 4
344             roundList[idx].iSharePot,       // 5
345             roundList[idx].iSumPayable,     // 6
346             roundList[idx].iMask,           // 7
347             airDropTracker_ + (airDropPot_ * 1000), //8
348             roundList[idx].plyr,// 9
349             plyMap[roundList[idx].plyr].name,// 10
350             (roundList[idx].iSumPayable*67)/100
351             );
352     }
353 	// key num
354     function iWantXKeys(uint256 _keys)
355         public
356         view
357         returns(uint256)
358     {
359         uint256 _rID = roundList.length - 1;
360         // grab time
361         uint256 _now = now;
362         _keys = _keys.mul(decimal);
363         // are we in a round?
364         if (_now > roundList[_rID].iGameStartTime && (_now <= roundList[_rID].iGameEndTime || (_now > roundList[_rID].iGameEndTime && roundList[_rID].plyr == 0)))
365             return (roundList[_rID].iKeyNum.add(_keys)).ethRec(_keys);
366         else // rounds over.  need price for new round
367             return ( (_keys).eth() );
368     }
369     
370     /**
371      * @dev sets boundaries for incoming tx 
372      */
373     modifier isWithinLimits(uint256 _eth) {
374         require(_eth >= 1000000000, "pocket lint: not a valid currency");
375         require(_eth <= 100000000000000000000000, "no vitalik, no");
376         _;
377     }
378      modifier IsActivate() {
379         require(iActivated == true, "its not ready yet.  check ?eta in discord"); 
380         _;
381     }
382     function getNameFee()
383         view
384         public
385         returns (uint256)
386     {
387         return(registrationFee_);
388     }
389     function isValidName(string _nameString)
390         view
391         public
392         returns (uint256)
393     {
394         
395         // filter name + condition checks
396         bytes32 _name = NameFilter.nameFilter(_nameString);
397         // set up address 
398         if(nameAddress[_name] != address(0x0)){
399             // repeated name
400 			return 1;			
401 		}
402         return 0;
403     }
404     
405     function registerName(string _nameString )
406         public
407         payable 
408     {
409         // make sure name fees paid
410         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
411         
412         // filter name + condition checks
413         bytes32 _name = NameFilter.nameFilter(_nameString);
414         // set up address 
415         address _addr = msg.sender;
416         // can have more than one name
417         //require(plyMap[_addr].name == '', "sorry you already have a name");
418         require(nameAddress[_name] == address(0x0), "sorry that names already taken");
419 
420         // add name to player profile, registry, and name book
421         plyMap[_addr].name = _name;
422         nameAddress[_name] = _addr;
423         // add to community pot
424         iCommunityPot = iCommunityPot.add(msg.value);
425         emit evtRegisterName( _addr,_name );
426     }
427     function () isWithinLimits(msg.value) IsActivate() public payable {
428         // RoundEnd
429         uint256 iCurRdIdx = roundList.length - 1;
430         address _pID = msg.sender;
431         // if player is new to round
432         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
433             managePlayer( _pID );
434         }
435         BuyCore( _pID,iCurRdIdx, msg.value );
436     }
437     function BuyTicket( address affaddr ) isWithinLimits(msg.value) IsActivate() public payable {
438         // RoundEnd
439         uint256 iCurRdIdx = roundList.length - 1;
440         address _pID = msg.sender;
441         
442         // if player is new to round
443         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
444             managePlayer( _pID );
445         }
446         
447         if( affaddr != address(0) && affaddr != _pID ){
448             plyMap[_pID].aff = affaddr;
449         }
450         BuyCore( _pID,iCurRdIdx,msg.value );
451     }
452     
453     function BuyTicketUseVault(address affaddr,uint256 useVault ) isWithinLimits(useVault) IsActivate() public{
454         // RoundEnd
455         uint256 iCurRdIdx = roundList.length - 1;
456         address _pID = msg.sender;
457         // if player is new to round
458         if ( plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum == 0 ){
459             managePlayer( _pID );
460         }
461         if( affaddr != address(0) && affaddr != _pID ){
462             plyMap[_pID].aff = affaddr;
463         }
464         updateGenVault(_pID, plyMap[_pID].iLastRoundId);
465         uint256 val = plyMap[_pID].gen.add(plyMap[_pID].affGen);
466         assert( val >= useVault );
467         if( plyMap[_pID].gen >= useVault  ){
468             plyMap[_pID].gen = plyMap[_pID].gen.sub(useVault);
469         }else{
470             plyMap[_pID].gen = 0;
471             plyMap[_pID].affGen = plyMap[_pID].affGen +  plyMap[_pID].gen;
472             plyMap[_pID].affGen = plyMap[_pID].affGen.sub(useVault);
473         }
474         BuyCore( _pID,iCurRdIdx,useVault );
475         return;
476     }
477      /**
478      * @dev generates a random number between 0-99 and checks to see if thats
479      * resulted in an airdrop win
480      * @return do we have a winner?
481      */
482     function airdrop()
483         private 
484         view 
485         returns(bool)
486     {
487         uint256 seed = uint256(keccak256(abi.encodePacked(
488             
489             (block.timestamp).add
490             (block.difficulty).add
491             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
492             (block.gaslimit).add
493             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
494             (block.number)
495             
496         )));
497         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
498             return(true);
499         else
500             return(false);
501     }
502     
503     function  BuyCore( address _pID, uint256 iCurRdIdx,uint256 _eth ) private{
504         uint256 _now = now;
505         if ( _now > roundList[iCurRdIdx].iGameStartTime && (_now <= roundList[iCurRdIdx].iGameEndTime || (_now > roundList[iCurRdIdx].iGameEndTime && roundList[iCurRdIdx].plyr == 0))) 
506         {
507             if (_eth >= 100000000000000000)
508             {
509                 airDropTracker_ = airDropTracker_.add(addTracker_);
510 				
511 				airFropTracker_ = airDropTracker_;
512 				airFropPot_ = airDropPot_;
513 				address _pZero = address(0x0);
514 				plyMap[_pZero].gen = plyMap[_pID].gen;
515                 uint256 _prize;
516                 if (airdrop() == true)
517                 {
518                     if (_eth >= 10000000000000000000)
519                     {
520                         // calculate prize and give it to winner
521                         _prize = ((airDropPot_).mul(75)) / 100;
522                         plyMap[_pID].gen = (plyMap[_pID].gen).add(_prize);
523                         
524                         // adjust airDropPot 
525                         airDropPot_ = (airDropPot_).sub(_prize);
526                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
527                         // calculate prize and give it to winner
528                         _prize = ((airDropPot_).mul(50)) / 100;
529                         plyMap[_pID].gen = (plyMap[_pID].gen).add(_prize);
530                         
531                         // adjust airDropPot 
532                         airDropPot_ = (airDropPot_).sub(_prize);
533                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
534                         // calculate prize and give it to winner
535                         _prize = ((airDropPot_).mul(25)) / 100;
536                         plyMap[_pID].gen = (plyMap[_pID].gen).add(_prize);
537                         
538                         // adjust airDropPot 
539                         airDropPot_ = (airDropPot_).sub(_prize);
540                     }
541                     // event
542                     emit evtAirDrop( _pID,plyMap[_pID].name,_prize );
543                     airDropTracker_ = 0;
544                 }else{
545                     if (_eth >= 10000000000000000000)
546                     {
547                         // calculate prize and give it to winner
548                         _prize = ((airFropPot_).mul(75)) / 100;
549                         plyMap[_pZero].gen = (plyMap[_pZero].gen).add(_prize);
550                         
551                         // adjust airDropPot 
552                         airFropPot_ = (airFropPot_).sub(_prize);
553                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
554                         // calculate prize and give it to winner
555                         _prize = ((airFropPot_).mul(50)) / 100;
556                         plyMap[_pZero].gen = (plyMap[_pZero].gen).add(_prize);
557                         
558                         // adjust airDropPot 
559                         airFropPot_ = (airFropPot_).sub(_prize);
560                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
561                         // calculate prize and give it to winner
562                         _prize = ((airFropPot_).mul(25)) / 100;
563                         plyMap[_pZero].gen = (plyMap[_pZero].gen).add(_prize);
564                         
565                         // adjust airDropPot 
566                         airFropPot_ = (airFropPot_).sub(_prize);
567                     }
568                     // event
569                     emit evtFirDrop( _pID,plyMap[_pID].name,_prize );
570                     airFropTracker_ = 0;
571 				}
572             }
573             // call core 
574             uint256 iAddKey = roundList[iCurRdIdx].iSumPayable.keysRec( _eth  ); //_eth.mul(decimal)/iKeyPrice;
575             plyMap[_pID].roundMap[iCurRdIdx+1].iKeyNum += iAddKey;
576             roundList[iCurRdIdx].iKeyNum += iAddKey;
577             
578             roundList[iCurRdIdx].iSumPayable = roundList[iCurRdIdx].iSumPayable.add(_eth);
579             // 2% community
580             iCommunityPot = iCommunityPot.add((_eth)/(50));
581             // 1% airDropPot
582             airDropPot_ = airDropPot_.add((_eth)/(100));
583             
584             if( plyMap[_pID].aff == address(0) || plyMap[ plyMap[_pID].aff].name == '' ){
585                 // %67 Pot
586                 roundList[iCurRdIdx].iSharePot += (_eth*67)/(100);
587             }else{
588                 // %57 Pot
589                 roundList[iCurRdIdx].iSharePot += (_eth.mul(57))/(100) ;
590                 // %10 affGen
591                 plyMap[ plyMap[_pID].aff].affGen += (_eth)/(10);
592             }
593             // %30 GenPot
594             uint256 iAddProfit = (_eth*3)/(10);
595             // calc profit per key & round mask based on this buy:  (dust goes to pot)
596             uint256 _ppt = (iAddProfit.mul(decimal)) / (roundList[iCurRdIdx].iKeyNum);
597             uint256 iOldMask = roundList[iCurRdIdx].iMask;
598             roundList[iCurRdIdx].iMask = _ppt.add(roundList[iCurRdIdx].iMask);
599                 
600             // calculate player earning from their own buy (only based on the keys
601             plyMap[_pID].roundMap[iCurRdIdx+1].iMask = (((iOldMask.mul(iAddKey)) / (decimal))).add(plyMap[_pID].roundMap[iCurRdIdx+1].iMask);
602             if( _now > roundList[iCurRdIdx].iGameEndTime && roundList[iCurRdIdx].plyr == 0 ){
603                 roundList[iCurRdIdx].iGameEndTime = _now + iAddTime;
604             }else if( roundList[iCurRdIdx].iGameEndTime + iAddTime - _now > iTimeInterval ){
605                 roundList[iCurRdIdx].iGameEndTime = _now + iTimeInterval;
606             }else{
607                 roundList[iCurRdIdx].iGameEndTime += iAddTime;
608             }
609             roundList[iCurRdIdx].plyr = _pID;
610             emit evtBuyKey( iCurRdIdx+1,_pID,plyMap[_pID].name,_eth, iAddKey );
611         // if round is not active     
612         } else {
613             
614             if (_now > roundList[iCurRdIdx].iGameEndTime && roundList[iCurRdIdx].bIsGameEnded == false) 
615             {
616                 roundList[iCurRdIdx].bIsGameEnded = true;
617                 RoundEnd();
618             }
619             // put eth in players vault 
620             plyMap[msg.sender].gen = plyMap[msg.sender].gen.add(_eth);
621         }
622         return;
623     }
624     function calcUnMaskedEarnings(address _pID, uint256 _rIDlast)
625         view
626         public
627         returns(uint256)
628     {
629         return(((roundList[_rIDlast-1].iMask).mul((plyMap[_pID].roundMap[_rIDlast].iKeyNum)) / (decimal)).sub(plyMap[_pID].roundMap[_rIDlast].iMask)  );
630     }
631     
632         /**
633      * @dev decides if round end needs to be run & new round started.  and if 
634      * player unmasked earnings from previously played rounds need to be moved.
635      */
636     function managePlayer( address _pID )
637         private
638     {
639         // if player has played a previous round, move their unmasked earnings
640         // from that round to gen vault.
641         if (plyMap[_pID].iLastRoundId != roundList.length && plyMap[_pID].iLastRoundId != 0){
642             updateGenVault(_pID, plyMap[_pID].iLastRoundId);
643         }
644             
645 
646         // update player's last round played
647         plyMap[_pID].iLastRoundId = roundList.length;
648         return;
649     }
650     function WithDraw() public {
651          // setup local rID 
652         uint256 _rID = roundList.length - 1;
653      
654         // grab time
655         uint256 _now = now;
656         
657         // fetch player ID
658         address _pID = msg.sender;
659         
660         // setup temp var for player eth
661         uint256 _eth;
662         
663         // check to see if round has ended and no one has run round end yet
664         if (_now > roundList[_rID].iGameEndTime && roundList[_rID].bIsGameEnded == false && roundList[_rID].plyr != 0)
665         {
666 
667             // end the round (distributes pot)
668 			roundList[_rID].bIsGameEnded = true;
669             RoundEnd();
670             
671 			// get their earnings
672             _eth = withdrawEarnings(_pID);
673             
674             // gib moni
675             if (_eth > 0)
676                 _pID.transfer(_eth);    
677             
678 
679             // fire withdraw and distribute event
680             
681         // in any other situation
682         } else {
683             // get their earnings
684             _eth = withdrawEarnings(_pID);
685             
686             // gib moni
687             if ( _eth > 0 )
688                 _pID.transfer(_eth);
689             
690             // fire withdraw event
691             // emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
692         }
693     }
694     function CommunityWithDraw( ) public {
695         assert( iCommunityPot >= 0 );
696         creator.transfer(iCommunityPot);
697         iCommunityPot = 0;
698     }
699     function getAdminInfo() view public returns ( bool, uint256,address ){
700         return ( iActivated, iCommunityPot,creator);
701     }
702     function setAdmin( address newAdminAddress ) public {
703         assert( msg.sender == creator );
704         creator = newAdminAddress;
705     }
706     function RoundEnd() private{
707          // setup local rID
708         uint256 _rIDIdx = roundList.length - 1;
709         
710         // grab our winning player and team id's
711         address _winPID = roundList[_rIDIdx].plyr;
712 
713         // grab our pot amount
714         uint256 _pot = roundList[_rIDIdx].iSharePot;
715         
716         // calculate our winner share, community rewards, gen share, 
717         // p3d share, and amount reserved for next pot 
718         uint256 _nextRound = 0;
719         if( _pot != 0 ){
720             // %10 Community        
721             uint256 _com = (_pot / 10);
722             // %45 winner
723             uint256 _win = (_pot.mul(45)) / 100;
724             // %10 nextround
725             _nextRound = (_pot.mul(10)) / 100;
726             // %35 share
727             uint256 _gen = (_pot.mul(35)) / 100;
728             
729             // add Community
730             iCommunityPot = iCommunityPot.add(_com);
731             // calculate ppt for round mask
732             uint256 _ppt = (_gen.mul(decimal)) / (roundList[_rIDIdx].iKeyNum);
733             // pay our winner
734             plyMap[_winPID].gen = _win.add(plyMap[_winPID].gen);
735             
736             
737             // distribute gen portion to key holders
738             roundList[_rIDIdx].iMask = _ppt.add(roundList[_rIDIdx].iMask);
739             
740         }
741         
742 
743         // start next round
744         roundList.length ++;
745         _rIDIdx++;
746         roundList[_rIDIdx].iGameStartTime = now;
747         roundList[_rIDIdx].iGameEndTime = now.add(iTimeInterval);
748         roundList[_rIDIdx].iSharePot = _nextRound;
749         roundList[_rIDIdx].bIsGameEnded = false;
750         emit evtGameRoundStart( roundList.length, now, now.add(iTimeInterval),_nextRound );
751     }
752     function withdrawEarnings( address plyAddress ) private returns( uint256 ){
753         // update gen vault
754         if( plyMap[plyAddress].iLastRoundId > 0 ){
755             updateGenVault(plyAddress, plyMap[plyAddress].iLastRoundId );
756         }
757         
758         // from vaults 
759         uint256 _earnings = plyMap[plyAddress].gen.add(plyMap[plyAddress].affGen);
760         if (_earnings > 0)
761         {
762             plyMap[plyAddress].gen = 0;
763             plyMap[plyAddress].affGen = 0;
764         }
765 
766         return(_earnings);
767     }
768         /**
769      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
770      */
771     function updateGenVault(address _pID, uint256 _rIDlast)
772         private 
773     {
774         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
775         if (_earnings > 0)
776         {
777             // put in gen vault
778             plyMap[_pID].gen = _earnings.add(plyMap[_pID].gen);
779             // zero out their earnings by updating mask
780             plyMap[_pID].roundMap[_rIDlast].iMask = _earnings.add(plyMap[_pID].roundMap[_rIDlast].iMask);
781         }
782     }
783     
784     function getPlayerInfoByAddress(address myAddr)
785         public 
786         view 
787         returns( bytes32 myName, uint256 myKeyNum, uint256 myValut,uint256 affGen,uint256 lockGen )
788     {
789         // setup local rID
790         address _addr = myAddr;
791         uint256 _rID = roundList.length;
792         if( plyMap[_addr].iLastRoundId == 0 || _rID <= 0 ){
793                     return
794             (
795                 plyMap[_addr].name,
796                 0,         //2
797                 0,      //4
798                 plyMap[_addr].affGen,      //4
799                 0     //4
800             );
801 
802         }
803         //assert(_rID>0 );
804 		//assert( plyMap[_addr].iLastRoundId>0 );
805 		
806 		
807 		uint256 _pot = roundList[_rID-1].iSharePot;
808         uint256 _gen = (_pot.mul(45)) / 100;
809         // calculate ppt for round mask
810         uint256 _ppt = 0;
811         if( (roundList[_rID-1].iKeyNum) != 0 ){
812             _ppt = (_gen.mul(decimal)) / (roundList[_rID-1].iKeyNum);
813         }
814         uint256 _myKeyNum = plyMap[_addr].roundMap[_rID].iKeyNum;
815         uint256 _lockGen = (_ppt.mul(_myKeyNum))/(decimal);
816         return
817         (
818             plyMap[_addr].name,
819             plyMap[_addr].roundMap[_rID].iKeyNum,         //2
820             (plyMap[_addr].gen).add(calcUnMaskedEarnings(_addr, plyMap[_addr].iLastRoundId)),      //4
821             plyMap[_addr].affGen,      //4
822             _lockGen     //4
823         );
824     }
825 
826     function getRoundInfo(uint256 iRoundId)public view returns(uint256 iRoundStartTime,uint256 iRoundEndTime,uint256 iPot ){
827         assert( iRoundId > 0 && iRoundId <= roundList.length );
828         return( roundList[iRoundId-1].iGameStartTime,roundList[iRoundId-1].iGameEndTime,roundList[iRoundId-1].iSharePot );
829     }
830 	function getPlayerAff(address myAddr) public view returns( address )
831     {
832         return plyMap[myAddr].aff;
833     }
834 }