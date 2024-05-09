1 pragma solidity ^0.4.24;
2 
3 
4 contract FoMoInsurance {
5     using SafeMath for *;
6     using NameFilter for string;
7     using F3DKeysCalcLong for uint256;
8 
9 
10     //*********
11     // STRUCTS
12     //*********
13     struct Player {
14         uint256 id;     // player id
15         bytes32 name;   // player name
16         uint256 gen;    // general vault
17         uint256 aff;    // affiliate vault
18         bool isAgent;   // referral activated
19         uint256 eth;    // eth player has added to round
20         uint256 keys;   // keys
21         uint256 units;  // uints of insurance
22         uint256 plyrLastSeen; // last day player played
23         uint256 mask;   // player mask
24         uint256 level;
25         uint256 accumulatedAff;
26     }
27 
28 
29     //***************
30     // EXTERNAL DATA
31     //***************
32     FoMo3Dlong constant private FoMoLong = FoMo3Dlong(0xA62142888ABa8370742bE823c1782D17A0389Da1);
33     DiviesInterface constant private Divies = DiviesInterface(0x93B2dbDd3F242EED7D7c7180c5A4Eddc4BaAE3E7);
34     address constant private community = address(0xe853A139b87dD816f052A60Ef646Fd89f7964545);
35     uint256 public end;
36     bool public ended;
37 
38 
39     //******************
40     // GLOBAL VARIABLES
41     //******************
42     mapping(address => mapping(uint256 => uint256)) public unitToExpirePlayer;
43     mapping(uint256 => uint256) public unitToExpire; // unit of insurance due at day x
44 
45     uint256 public issuedInsurance; // all issued insurance
46     uint256 public ethOfKey;        // virtual eth of bought keys
47     uint256 public keys;            // totalSupply of key
48     uint256 public pot;             // eth gonna pay to beneficiary
49     uint256 public today;           // today's date
50     uint256 public _now;            // current time
51     uint256 public mask;            // global mask
52     uint256 public agents;          // number of agent
53 
54     // player data
55     mapping(address => Player) public player; // player data
56     mapping(uint256 => address) public agentxID_; // return agent address by id
57     mapping(bytes32 => address) public agentxName_; // return agent address by name
58 
59     // constant parameters
60     uint256 constant maxInsurePeriod = 100;
61     uint256 constant thisRoundIndex = 2;
62     uint256 constant maxLevel = 10;
63 
64     // rate of buying x day insurance
65     uint256[101] public rate =
66     [0,
67     1000000000000000000,
68     1990000000000000000,
69     2970100000000000000,
70     3940399000000000000,
71     4900995010000000000,
72     5851985059900000000,
73     6793465209301000000,
74     7725530557207990000,
75     8648275251635910100,
76     9561792499119550999,
77     10466174574128355489,
78     11361512828387071934,
79     12247897700103201215,
80     13125418723102169203,
81     13994164535871147511,
82     14854222890512436036,
83     15705680661607311676,
84     16548623854991238559,
85     17383137616441326173,
86     18209306240276912911,
87     19027213177874143782,
88     19836941046095402344,
89     20638571635634448321,
90     21432185919278103838,
91     22217864060085322800,
92     22995685419484469572,
93     23765728565289624876,
94     24528071279636728627,
95     25282790566840361341,
96     26029962661171957728,
97     26769663034560238151,
98     27501966404214635769,
99     28226946740172489411,
100     28944677272770764517,
101     29655230500043056872,
102     30358678195042626303,
103     31055091413092200040,
104     31744540498961278040,
105     32427095093971665260,
106     33102824143031948607,
107     33771795901601629121,
108     34434077942585612830,
109     35089737163159756702,
110     35738839791528159135,
111     36381451393612877544,
112     37017636879676748769,
113     37647460510879981281,
114     38270985905771181468,
115     38888276046713469653,
116     39499393286246334956,
117     40104399353383871606,
118     40703355359850032890,
119     41296321806251532561,
120     41883358588189017235,
121     42464525002307127063,
122     43039879752284055792,
123     43609480954761215234,
124     44173386145213603082,
125     44731652283761467051,
126     45284335760923852380,
127     45831492403314613856,
128     46373177479281467717,
129     46909445704488653040,
130     47440351247443766510,
131     47965947734969328845,
132     48486288257619635557,
133     49001425375043439201,
134     49511411121293004809,
135     50016297010080074761,
136     50516134039979274013,
137     51010972699579481273,
138     51500862972583686460,
139     51985854342857849595,
140     52465995799429271099,
141     52941335841434978388,
142     53411922483020628604,
143     53877803258190422318,
144     54339025225608518095,
145     54795634973352432914,
146     55247678623618908585,
147     55695201837382719499,
148     56138249819008892304,
149     56576867320818803381,
150     57011098647610615347,
151     57440987661134509194,
152     57866577784523164102,
153     58287912006677932461,
154     58705032886611153136,
155     59117982557745041605,
156     59526802732167591189,
157     59931534704845915277,
158     60332219357797456124,
159     60728897164219481563,
160     61121608192577286747,
161     61510392110651513880,
162     61895288189544998741,
163     62276335307649548754,
164     62653571954573053266,
165     63027036235027322733,
166     63396765872677049506];
167 
168     // threshold of agent upgrade
169     uint256[10] public requirement =
170     [0,
171     73890560989306501,
172     200855369231876674,
173     545981500331442382,
174     1484131591025766010,
175     4034287934927351160,
176     10966331584284585813,
177     29809579870417282259,
178     81030839275753838749,
179     220264657948067161559];
180 
181 
182     //******************
183     // EVENT
184     //******************
185     event UPGRADE (address indexed agent, uint256 level);
186     event BUYINSURANCE(address indexed buyer, uint256 indexed start, uint256 unit,  uint256 date);
187 
188 
189     //******************
190     // MODIFIER
191     //******************
192     modifier isHuman() {
193         address _addr = msg.sender;
194         uint256 _codeLength;
195 
196         assembly {_codeLength := extcodesize(_addr)}
197         require(_codeLength == 0, "sorry humans only");
198         _;
199     }
200 
201 
202     /**
203      * @dev Constructor
204      * @notice Initialize the time
205      */
206     constructor() public {
207         _now = now;
208         today = _now / 1 days;
209     }
210 
211     /**
212      * @dev Ticker
213      * @notice It is called everytime when a player interacts with this contract
214      * @return true is Fomo3D is ended, false otherwise
215      */
216     function tick() internal returns(bool) {
217         if (_now != now) {
218             _now = now;
219             uint256 _today; // the current day as soon as ticker is called
220 
221             //check if fomo3D ends
222             (,,end, ended,,,,,,,,) = FoMoLong.round_(thisRoundIndex);
223             if (!ended) {
224                 _today = _now / 1 days;
225             }
226             else {
227                 _today = end / 1 days;
228             }
229 
230             // calculate the outdated issuedInsurance
231             while (today < _today) {
232                 issuedInsurance = issuedInsurance.sub(unitToExpire[today]);
233                 today += 1;
234             }
235         }
236         return ended;
237     }
238 
239     /**
240      * @dev Register
241      * @notice Register a name by a human player
242      */
243     function register(string _nameString) external payable isHuman() {
244         bytes32 _name = _nameString.nameFilter();
245         address _agent = msg.sender;
246         require(msg.value >= 10000000000000000);
247         require(agentxName_[_name] == address(0));
248 
249         if(!player[_agent].isAgent){
250             agents += 1;
251             player[_agent].isAgent = true;
252             player[_agent].id = agents;
253             player[_agent].level = 1;
254             agentxID_[agents] = _agent;
255         }
256         // set name active for the player
257         player[_agent].name = _name;
258         agentxName_[_name] = _agent;
259 
260         if(!community.send(msg.value)){
261             pot = pot.add(msg.value);
262         }
263     }
264 
265     /**
266      * @dev Upgrade
267      * @notice Upgrade when a player's affiliate bonus meet the promotion
268      */
269     function upgrade() external isHuman(){
270         address _agent = msg.sender;
271         require(player[_agent].isAgent);
272         require(player[_agent].level < maxLevel);
273 
274         if(player[_agent].accumulatedAff >= requirement[player[_agent].level]){
275             player[_agent].level = (1).add(player[_agent].level);
276             emit UPGRADE(_agent,player[_agent].level);
277         }
278     }
279 
280     /**
281      * @dev Buy, using address for referral
282      */
283     function buyXaddr(address _agent, uint256 _date)
284         isHuman()
285         public
286         payable
287     {
288         // ticker
289         if(tick()){
290             msg.sender.transfer(msg.value);
291             return;
292         }
293 
294         // validate agent
295         if(!player[_agent].isAgent){
296             _agent = address(0);
297         }
298 
299         buyCore(msg.sender, msg.value, _date, _agent);
300     }
301 
302     function buyXid(uint256 _agentId, uint256 _date)
303         isHuman()
304         public
305         payable
306     {
307         // ticker
308         if(tick()){
309             msg.sender.transfer(msg.value);
310             return;
311         }
312 
313         address _agent = agentxID_[_agentId];
314 
315         // validate agent
316         if(!player[_agent].isAgent){
317             _agent = address(0);
318         }
319 
320         buyCore(msg.sender, msg.value, _date, _agent);
321     }
322 
323     function buyXname(bytes32 _agentName, uint256 _date)
324         isHuman()
325         public
326         payable
327     {
328         // ticker
329         if(tick()){
330             msg.sender.transfer(msg.value);
331             return;
332         }
333 
334         address _agent = agentxName_[_agentName];
335 
336         // validate agent
337         if(!player[_agent].isAgent){
338             _agent = address(0);
339         }
340 
341         buyCore(msg.sender, msg.value, _date, _agent);
342     }
343 
344     /**
345      * @dev Core part of buying
346      */
347     function buyCore(address _buyer, uint256 _eth, uint256 _date, address _agent) internal {
348 
349         updatePlayerUnit(_buyer);
350         
351         require(_eth >= 1000000000, "pocket lint: not a valid currency");
352 
353         if(_date > maxInsurePeriod){
354             _date = maxInsurePeriod;
355         }
356         uint256 _rate = rate[_date] + 1000000000000000000;
357         uint256 ethToBuyKey = _eth.mul(1000000000000000000) / _rate;
358         //-- ethToBuyKey is a virtual amount used to represent the eth player paid for buying keys, which is usually different from _eth
359 
360         // get value of keys and insurances can be bought
361         uint256 _key = ethOfKey.keysRec(ethToBuyKey);
362         uint256 _unit = (_date == 0)? 0: _key;
363         uint256 newDate = today + _date - 1;
364 
365 
366         // update global data
367         ethOfKey = ethOfKey.add(ethToBuyKey);
368         keys = keys.add(_key);
369         unitToExpire[newDate] = unitToExpire[newDate].add(_unit);
370         issuedInsurance = issuedInsurance.add(_unit);
371 
372         // update player data
373         player[_buyer].eth = player[_buyer].eth.add(_eth);
374         player[_buyer].keys = player[_buyer].keys.add(_key);
375         player[_buyer].units = player[_buyer].units.add(_unit);
376         unitToExpirePlayer[_buyer][newDate] = unitToExpirePlayer[_buyer][newDate].add(_unit);
377 
378         distributeEx(_eth, _agent);
379         distributeIn(_buyer, _eth, _key);
380         emit BUYINSURANCE(_buyer, today, _unit, _date);
381     }
382 
383     /**
384      * @dev Update player's units of insurance
385      */
386     function updatePlayerUnit(address _player) internal {
387         uint256 _today = player[_player].plyrLastSeen;
388         uint256 expiredUnit = 0;
389         if(_today != 0){
390             while(_today < today){
391                 expiredUnit = expiredUnit.add(unitToExpirePlayer[_player][_today]);
392                 _today += 1;
393             }
394             player[_player].units = player[_player].units.sub(expiredUnit);
395         }
396         player[_player].plyrLastSeen = today;
397     }
398 
399     /**
400      * @dev Distribute to the external
401      */
402     function distributeEx(uint256 _eth, address _agent) internal {
403         uint256 ex = _eth / 4 ;
404         uint256 affRate;
405         if(player[_agent].isAgent){
406             affRate = player[_agent].level.add(6);
407         }
408         uint256 _aff = _eth.mul(affRate) / 100;
409         if (_aff > 0) {
410             player[_agent].aff = player[_agent].aff.add(_aff);
411             player[_agent].accumulatedAff = player[_agent].accumulatedAff.add(_aff);
412         }
413         ex = ex.sub(_aff);
414         uint256 _com = ex / 3;
415         uint256 _p3d = ex.sub(_com);
416 
417         if(!community.send(_com)){
418             pot = pot.add(_com);
419         }
420         Divies.deposit.value(_p3d)();
421     }
422 
423     /**
424      * @dev Distribute to the internal
425      */
426     function distributeIn(address _buyer, uint256 _eth, uint256 _keys) internal {
427         uint256 _gen = _eth.mul(3) / 20;
428 
429         // update eth balance (eth = eth - (com share + aff share + p3d share))
430         _eth = _eth.sub(_eth / 4);
431 
432         // calculate pot
433         uint256 _pot = _eth.sub(_gen);
434 
435         // distribute gen share (that's what updateMasks() does) and adjust
436         // balances for dust.
437         uint256 _dust = updateMasks(_buyer, _gen, _keys);
438         if (_dust > 0)
439             _gen = _gen.sub(_dust);
440 
441         // add eth to pot
442         pot = pot.add(_dust).add(_pot);
443     }
444 
445     function updateMasks(address  _player, uint256 _gen, uint256 _keys)
446         private
447         returns(uint256)
448     {
449         /* MASKING NOTES
450             earnings masks are a tricky thing for people to wrap their minds around.
451             the basic thing to understand here is we're going to have a global
452             tracker based on profit per share for each round, that increases in
453             relevant proportion to the increase in share supply.
454 
455             the player will have an additional mask that basically says "based
456             on the global mask, my shares, and how much i've already withdrawn,
457             how much is still owed to me?"
458         */
459 
460         // calculate profit per key & global mask based on this buy:  (dust goes to pot)
461         uint256 _ppt = _gen.mul(1000000000000000000) / keys;
462         mask = mask.add(_ppt);
463 
464         // calculate player earning from their own buy (only based on the keys
465         // they just bought). & update player earnings mask
466         uint256 _pearn = (_ppt.mul(_keys)) / 1000000000000000000;
467         player[_player].mask = (((mask.mul(_keys)) / 1000000000000000000).sub(_pearn)).add(player[_player].mask);
468 
469         // calculate & return dust
470         return(_gen.sub( _ppt.mul(keys) / 1000000000000000000));
471     }
472 
473     /**
474      * @dev Submit a claim from the beneficiary
475      */
476     function claim() isHuman() public {
477         require(tick());
478         address beneficiary = msg.sender;
479         updatePlayerUnit(beneficiary);
480         uint256 amount = pot.mul(player[beneficiary].units) / issuedInsurance;
481         player[beneficiary].units = 0;
482         beneficiary.transfer(amount);
483     }
484 
485     /**
486      * @dev Withdraw dividends and aff
487      */
488     function withdraw() isHuman() public {
489         // setup temp var for player eth
490         uint256 _eth;
491 
492         // get their earnings
493         _eth = withdrawEarnings(msg.sender);
494 
495         // gib moni
496         if (_eth > 0)
497             msg.sender.transfer(_eth);
498     }
499 
500     function withdrawEarnings(address _player)
501         private
502         returns(uint256)
503     {
504         // update gen vault
505         updateGenVault(_player);
506 
507         // from vaults
508         uint256 _earnings = player[_player].gen.add(player[_player].aff);
509         if (_earnings > 0) {
510             player[_player].gen = 0;
511             player[_player].aff = 0;
512         }
513 
514         return(_earnings);
515     }
516 
517     function updateGenVault(address _player)
518         private
519     {
520         uint256 _earnings = calcUnMaskedEarnings(_player);
521         if (_earnings > 0) {
522             // put in gen vault
523             player[_player].gen = _earnings.add(player[_player].gen);
524             // zero out their earnings by updating mask
525             player[_player].mask = _earnings.add(player[_player].mask);
526         }
527     }
528 
529     function calcUnMaskedEarnings(address _player)
530         private
531         view
532         returns(uint256)
533     {
534         return(  (mask.mul(player[_player].keys) / 1000000000000000000).sub(player[_player].mask)  );
535     }
536 
537     /**
538      * @dev Return the price buyer will pay for next 1 individual key.
539      * @return Price for next key bought (in wei format)
540      */
541     function getBuyPrice() public view returns(uint256) {
542         return(keys.add(1000000000000000000).ethRec(1000000000000000000));
543     }
544 
545     /**
546      * @dev Get the units of insurance of player
547      * @return Amount of existing units of insurance
548      */
549     function getCurrentUnit(address _player) public view returns(uint256) {
550         uint256 _unit = player[_player].units;
551         uint256 _today = player[_player].plyrLastSeen;
552         uint256 expiredUnit = 0;
553         if(_today != 0){
554             while(_today < today){
555                 expiredUnit = expiredUnit.add(unitToExpirePlayer[_player][_today]);
556                 _today += 1;
557             }
558 
559         }
560         return( _unit == 0 ? 0 : _unit.sub(expiredUnit));
561     }
562 
563     /**
564      * @dev Get the list of units of insurace going to expire of a player
565      * @return List of units of insurance going to expire from a player
566      */
567     function getExpiringUnitListPlayer(address _player)
568         public
569         view
570         returns(uint256[maxInsurePeriod] expiringUnitList)
571     {
572         for(uint256 i=0; i<maxInsurePeriod; i++) {
573             expiringUnitList[i] = unitToExpirePlayer[_player][today+i];
574         }
575         return(expiringUnitList);
576     }
577 
578     /**
579      * @dev Get the list of units of insurace going to expire
580      * @return List of units of insurance going to expire
581      */
582     function getExpiringUnitList()
583         public
584         view
585         returns(uint256[maxInsurePeriod] expiringUnitList)
586     {
587         for(uint256 i=0; i<maxInsurePeriod; i++){
588             expiringUnitList[i] = unitToExpire[today+i];
589         }
590         return(expiringUnitList);
591     }
592 }
593 
594 contract FoMo3Dlong {
595 //==============================================================================
596 //     _| _ _|_ _    _ _ _|_    _   .
597 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
598 //=============================|================================================
599     uint256 public rID_;    // round id number / total rounds that have happened
600 //****************
601 // ROUND DATA
602 //****************
603     mapping (uint256 => F3Ddatasets.Round) public round_;
604 }
605 
606 interface DiviesInterface {
607     function deposit() external payable;
608 }
609 
610 library F3DKeysCalcLong {
611     using SafeMath for *;
612     /**
613      * @dev calculates number of keys received given X eth
614      * @param _curEth current amount of eth in contract
615      * @param _newEth eth being spent
616      * @return amount of ticket purchased
617      */
618     function keysRec(uint256 _curEth, uint256 _newEth)
619         internal
620         pure
621         returns (uint256)
622     {
623         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
624     }
625 
626     /**
627      * @dev calculates amount of eth received if you sold X keys
628      * @param _curKeys current amount of keys that exist
629      * @param _sellKeys amount of keys you wish to sell
630      * @return amount of eth received
631      */
632     function ethRec(uint256 _curKeys, uint256 _sellKeys)
633         internal
634         pure
635         returns (uint256)
636     {
637         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
638     }
639 
640     /**
641      * @dev calculates how many keys would exist with given an amount of eth
642      * @param _eth eth "in contract"
643      * @return number of keys that would exist
644      */
645     function keys(uint256 _eth)
646         internal
647         pure
648         returns(uint256)
649     {
650         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
651     }
652 
653     /**
654      * @dev calculates how much eth would be in contract given a number of keys
655      * @param _keys number of keys "in contract"
656      * @return eth that would exists
657      */
658     function eth(uint256 _keys)
659         internal
660         pure
661         returns(uint256)
662     {
663         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
664     }
665 }
666 
667 library F3Ddatasets {
668     struct Round {
669         uint256 plyr;   // pID of player in lead
670         uint256 team;   // tID of team in lead
671         uint256 end;    // time ends/ended
672         bool ended;     // has round end function been ran
673         uint256 strt;   // time round started
674         uint256 keys;   // keys
675         uint256 eth;    // total eth in
676         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
677         uint256 mask;   // global mask
678         uint256 ico;    // total eth sent in during ICO phase
679         uint256 icoGen; // total eth for gen during ICO phase
680         uint256 icoAvg; // average key price for ICO phase
681     }
682 }
683 
684 library NameFilter {
685     /**
686      * @dev filters name strings
687      * -converts uppercase to lower case.
688      * -makes sure it does not start/end with a space
689      * -makes sure it does not contain multiple spaces in a row
690      * -cannot be only numbers
691      * -cannot start with 0x
692      * -restricts characters to A-Z, a-z, 0-9, and space.
693      * @return reprocessed string in bytes32 format
694      */
695     function nameFilter(string _input)
696         internal
697         pure
698         returns(bytes32)
699     {
700         bytes memory _temp = bytes(_input);
701         uint256 _length = _temp.length;
702 
703         //sorry limited to 32 characters
704         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
705         // make sure it doesnt start with or end with space
706         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
707         // make sure first two characters are not 0x
708         if (_temp[0] == 0x30)
709         {
710             require(_temp[1] != 0x78, "string cannot start with 0x");
711             require(_temp[1] != 0x58, "string cannot start with 0X");
712         }
713 
714         // create a bool to track if we have a non number character
715         bool _hasNonNumber;
716 
717         // convert & check
718         for (uint256 i = 0; i < _length; i++)
719         {
720             // if its uppercase A-Z
721             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
722             {
723                 // convert to lower case a-z
724                 _temp[i] = byte(uint(_temp[i]) + 32);
725 
726                 // we have a non number
727                 if (_hasNonNumber == false)
728                     _hasNonNumber = true;
729             } else {
730                 require
731                 (
732                     // require character is a space
733                     _temp[i] == 0x20 ||
734                     // OR lowercase a-z
735                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
736                     // or 0-9
737                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
738                     "string contains invalid characters"
739                 );
740                 // make sure theres not 2x spaces in a row
741                 if (_temp[i] == 0x20)
742                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
743 
744                 // see if we have a character other than a number
745                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
746                     _hasNonNumber = true;
747             }
748         }
749 
750         require(_hasNonNumber == true, "string cannot be only numbers");
751 
752         bytes32 _ret;
753         assembly {
754             _ret := mload(add(_temp, 32))
755         }
756         return (_ret);
757     }
758 }
759 
760 library SafeMath {
761     /**
762     * @dev Multiplies two numbers, throws on overflow.
763     */
764     function mul(uint256 a, uint256 b)
765         internal
766         pure
767         returns (uint256 c)
768     {
769         if (a == 0) {
770             return 0;
771         }
772         c = a * b;
773         require(c / a == b, "SafeMath mul failed");
774         return c;
775     }
776 
777     /**
778     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
779     */
780     function sub(uint256 a, uint256 b)
781         internal
782         pure
783         returns (uint256)
784     {
785         require(b <= a, "SafeMath sub failed");
786         return a - b;
787     }
788 
789     /**
790     * @dev Adds two numbers, throws on overflow.
791     */
792     function add(uint256 a, uint256 b)
793         internal
794         pure
795         returns (uint256 c)
796     {
797         c = a + b;
798         require(c >= a, "SafeMath add failed");
799         return c;
800     }
801 
802     /**
803      * @dev gives square root of given x.
804      */
805     function sqrt(uint256 x)
806         internal
807         pure
808         returns (uint256 y)
809     {
810         uint256 z = ((add(x,1)) / 2);
811         y = x;
812         while (z < y)
813         {
814             y = z;
815             z = ((add((x / z),z)) / 2);
816         }
817     }
818 
819     /**
820      * @dev gives square. multiplies x by x
821      */
822     function sq(uint256 x)
823         internal
824         pure
825         returns (uint256)
826     {
827         return (mul(x,x));
828     }
829 
830     /**
831      * @dev x to the power of y
832      */
833     function pwr(uint256 x, uint256 y)
834         internal
835         pure
836         returns (uint256)
837     {
838         if (x==0)
839             return (0);
840         else if (y==0)
841             return (1);
842         else
843         {
844             uint256 z = x;
845             for (uint256 i=1; i < y; i++)
846                 z = mul(z,x);
847             return (z);
848         }
849     }
850 }