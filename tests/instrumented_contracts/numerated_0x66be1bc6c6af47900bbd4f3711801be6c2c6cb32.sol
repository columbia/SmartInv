1 pragma solidity 0.5.16;
2 
3 contract ThreeFMutual {
4     using SafeMath for *;
5 
6     //*********
7     // STRUCTS
8     //*********
9     struct Player {
10         uint256 id;             // agent id
11         bytes32 name;           // agent name
12         uint256 ref;            // referral vault
13         bool isAgent;           // referral activated
14         bool claimed;           // insurance claimed
15         uint256 eth;            // eth player has paid
16         uint256 shares;         // shares
17         uint256 units;          // uints of insurance
18         uint256 plyrLastSeen;   // last day player played
19         uint256 mask;           // player mask
20         uint256 level;          // agent level
21         uint256 accumulatedRef; // accumulated referral income
22     }
23 
24 
25     //***************
26     // EXTERNAL DATA
27     //***************
28 
29     VAT vat = VAT(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
30     Underwriter underwriter = Underwriter(0xE58cDe3CbEeCC8d9306f482729084B909Afa2357);
31     Agency agency = Agency(0x7Bc360ebD65eFa503FF189A0F81f61f85D310Ec3);
32     
33     address payable constant private hakka = address(0x83D0D842e6DB3B020f384a2af11bD14787BEC8E7);
34     address payable constant private IIP = address(0x9933AD4D38702cdC28C5DB2F421F1F02CF530780);
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
46     uint256 public ethOfShare;      // virtual eth pointer
47     uint256 public shares;          // total share
48     uint256 public pool;            // eth gonna pay to beneficiary
49     uint256 public today;           // today's date
50     uint256 public _now;            // current time
51     uint256 public mask;            // global mask
52     uint256 public agents;          // number of agent
53 
54     // player data
55     mapping(address => Player) public player;       // player data
56     mapping(uint256 => address) public agentxID_;   // return agent address by id
57     mapping(bytes32 => address) public agentxName_; // return agent address by name
58 
59     // constant parameters
60     uint256 constant maxInsurePeriod = 100;
61     uint256 constant maxLevel = 10;
62 
63     // rate of buying x day insurance
64     uint256[101] public rate =
65     [0,
66     1000000000000000000,
67     1990000000000000000,
68     2970100000000000000,
69     3940399000000000000,
70     4900995010000000000,
71     5851985059900000000,
72     6793465209301000000,
73     7725530557207990000,
74     8648275251635910100,
75     9561792499119550999,
76     10466174574128355489,
77     11361512828387071934,
78     12247897700103201215,
79     13125418723102169203,
80     13994164535871147511,
81     14854222890512436036,
82     15705680661607311676,
83     16548623854991238559,
84     17383137616441326173,
85     18209306240276912911,
86     19027213177874143782,
87     19836941046095402344,
88     20638571635634448321,
89     21432185919278103838,
90     22217864060085322800,
91     22995685419484469572,
92     23765728565289624876,
93     24528071279636728627,
94     25282790566840361341,
95     26029962661171957728,
96     26769663034560238151,
97     27501966404214635769,
98     28226946740172489411,
99     28944677272770764517,
100     29655230500043056872,
101     30358678195042626303,
102     31055091413092200040,
103     31744540498961278040,
104     32427095093971665260,
105     33102824143031948607,
106     33771795901601629121,
107     34434077942585612830,
108     35089737163159756702,
109     35738839791528159135,
110     36381451393612877544,
111     37017636879676748769,
112     37647460510879981281,
113     38270985905771181468,
114     38888276046713469653,
115     39499393286246334956,
116     40104399353383871606,
117     40703355359850032890,
118     41296321806251532561,
119     41883358588189017235,
120     42464525002307127063,
121     43039879752284055792,
122     43609480954761215234,
123     44173386145213603082,
124     44731652283761467051,
125     45284335760923852380,
126     45831492403314613856,
127     46373177479281467717,
128     46909445704488653040,
129     47440351247443766510,
130     47965947734969328845,
131     48486288257619635557,
132     49001425375043439201,
133     49511411121293004809,
134     50016297010080074761,
135     50516134039979274013,
136     51010972699579481273,
137     51500862972583686460,
138     51985854342857849595,
139     52465995799429271099,
140     52941335841434978388,
141     53411922483020628604,
142     53877803258190422318,
143     54339025225608518095,
144     54795634973352432914,
145     55247678623618908585,
146     55695201837382719499,
147     56138249819008892304,
148     56576867320818803381,
149     57011098647610615347,
150     57440987661134509194,
151     57866577784523164102,
152     58287912006677932461,
153     58705032886611153136,
154     59117982557745041605,
155     59526802732167591189,
156     59931534704845915277,
157     60332219357797456124,
158     60728897164219481563,
159     61121608192577286747,
160     61510392110651513880,
161     61895288189544998741,
162     62276335307649548754,
163     62653571954573053266,
164     63027036235027322733,
165     63396765872677049506];
166 
167     // threshold of agent upgrade
168     uint256[10] public requirement =
169     [0,
170     73890560989306501,
171     200855369231876674,
172     545981500331442382,
173     1484131591025766010,
174     4034287934927351160,
175     10966331584284585813,
176     29809579870417282259,
177     81030839275753838749,
178     220264657948067161559];
179 
180 
181     //******************
182     // EVENT
183     //******************
184     event UPGRADE (address indexed agent, uint256 indexed level);
185     event BUYINSURANCE(address indexed buyer, uint256 indexed start, uint256 unit,  uint256 date);
186 
187 
188     //******************
189     // MODIFIER
190     //******************
191     modifier isHuman() {
192         require(msg.sender == tx.origin, "sorry humans only");
193         _;
194     }
195 
196     //******************
197     // CORE FUNCTIONS
198     //******************
199 
200     /**
201      * @dev Constructor
202      * @notice Initialize the time
203      */
204     constructor() public {
205         _now = now;
206         today = _now / 1 days;
207     }
208 
209     /**
210      * @dev Ticker
211      * @notice It is called everytime when a player interacts with this contract
212      * @return true if MakerDAO has been shut down, false otherwise
213      */
214     function tick()
215         internal
216         returns(bool)
217     {
218         if(!ended) {
219             if (_now != now) {
220                 _now = now;
221                 uint256 _today = _now / 1 days; // the current day as soon as ticker is called
222 
223                 //check MakerDAO status
224                 if(vat.live() == 0) {
225                     ended = true;
226                     end = now;
227                 }
228 
229                 // calculate the outdated issuedInsurance
230                 while (today < _today) {
231                     issuedInsurance = issuedInsurance.sub(unitToExpire[today]);
232                     unitToExpire[today] = 0;
233                     today += 1;
234                 }
235             }
236         }
237         
238         return ended;
239     }
240 
241     /**
242      * @dev Register
243      * @notice Register a name by a human player
244      */
245     function register(string calldata _nameString)
246         external
247         payable
248         isHuman()
249     {
250         bytes32 _name = agency.register(_nameString);
251         address _agent = msg.sender;
252         require(msg.value >= 10000000000000000, "insufficient amount");
253         require(agentxName_[_name] == address(0), "name registered");
254 
255         if(!player[_agent].isAgent){
256             agents += 1;
257             player[_agent].isAgent = true;
258             player[_agent].id = agents;
259             player[_agent].level = 1;
260             agentxID_[agents] = _agent;
261             emit UPGRADE(_agent,player[_agent].level);
262         }
263         // set name active for the player
264         player[_agent].name = _name;
265         agentxName_[_name] = _agent;
266         sendContract(hakka, msg.value);
267 
268     }
269 
270     /**
271      * @dev Upgrade
272      * @notice Upgrade when a player's referral bonus meet the requirement
273      */
274     function upgrade()
275         external
276         isHuman()
277     {
278         address _agent = msg.sender;
279         require(player[_agent].isAgent);
280         require(player[_agent].level < maxLevel);
281 
282         if(player[_agent].accumulatedRef >= requirement[player[_agent].level]) {
283             player[_agent].level = (1).add(player[_agent].level);
284             emit UPGRADE(_agent,player[_agent].level);
285         }
286     }
287 
288     //using address for referral
289     function buy(address payable _agent, uint256 _date)
290         isHuman()
291         public
292         payable
293     {
294         // ticker
295         if(tick()){
296             sendHuman(msg.sender, msg.value);
297             return;
298         }
299 
300         // validate agent
301         if(!player[_agent].isAgent){
302             _agent = address(0);
303         }
304 
305         buyCore(msg.sender, msg.value, _date, _agent);
306     }
307 
308     //using ID for referral
309     function buy(uint256 _agentId, uint256 _date)
310         isHuman()
311         public
312         payable
313     {
314         // ticker
315         if(tick()){
316             sendHuman(msg.sender, msg.value);
317             return;
318         }
319 
320         //query agent
321         address payable _agent = address(uint160(agentxID_[_agentId]));
322 
323         buyCore(msg.sender, msg.value, _date, _agent);
324     }
325 
326     //using name for referral
327     function buy(bytes32 _agentName, uint256 _date)
328         isHuman()
329         public
330         payable
331     {
332         // ticker
333         if(tick()){
334             sendHuman(msg.sender, msg.value);
335             return;
336         }
337 
338         //query agent
339         address payable _agent = address(uint160(agentxName_[_agentName]));
340 
341         buyCore(msg.sender, msg.value, _date, _agent);
342     }
343 
344     // contract wallets, sorry insurance only for human
345     function buy()
346         public
347         payable
348     {
349         // ticker
350         if(tick()) {
351             if(msg.sender == tx.origin)
352                 sendHuman(msg.sender, msg.value);
353             else
354                 sendContract(msg.sender, msg.value);
355             return;
356         }
357 
358         buyCore(msg.sender, msg.value, 0, address(0));
359     }
360 
361     // fallback
362     function () external payable {
363         buy();
364     }
365 
366     /**
367      * @dev Core part of buying
368      */
369     function buyCore(address _buyer, uint256 _eth, uint256 _date, address payable _agent) internal {
370 
371         updatePlayerUnit(_buyer);
372         
373         require(_eth >= 1000000000, "pocket lint: not a valid currency");
374         require(_eth <= 10000000000000000000000, "no vitalik, no");
375 
376         if(_date > maxInsurePeriod){
377             _date = maxInsurePeriod;
378         }
379         uint256 _rate = rate[_date] + 1000000000000000000;
380         uint256 ethToBuyShare = _eth.mul(1000000000000000000) / _rate;
381         //-- ethToBuyShare is a virtual amount used to represent the eth player paid for buying shares
382         //which is usually different from _eth
383 
384         // get value of shares and insurances can be bought
385         uint256 _share = underwriter.mintShare(ethOfShare, ethToBuyShare);
386         uint256 _unit = (_date == 0)? 0: _share;
387         uint256 newDate = today + _date - 1;
388 
389 
390         // update global data
391         ethOfShare = ethOfShare.add(ethToBuyShare);
392         shares = shares.add(_share);
393         unitToExpire[newDate] = unitToExpire[newDate].add(_unit);
394         issuedInsurance = issuedInsurance.add(_unit);
395 
396         // update player data
397         player[_buyer].eth = player[_buyer].eth.add(_eth);
398         player[_buyer].shares = player[_buyer].shares.add(_share);
399         player[_buyer].units = player[_buyer].units.add(_unit);
400         unitToExpirePlayer[_buyer][newDate] = unitToExpirePlayer[_buyer][newDate].add(_unit);
401 
402         distributeEx(_eth, _agent);
403         distributeIn(_buyer, _eth, _share);
404         emit BUYINSURANCE(_buyer, today, _unit, _date);
405         emit Transfer(address(0), _buyer, _share);
406     }
407 
408     /**
409      * @dev Update player's units of insurance
410      */
411     function updatePlayerUnit(address _player) internal {
412         uint256 _today = player[_player].plyrLastSeen;
413         uint256 expiredUnit = 0;
414         if(_today != 0){
415             while(_today < today){
416                 expiredUnit = expiredUnit.add(unitToExpirePlayer[_player][_today]);
417                 unitToExpirePlayer[_player][_today] = 0;
418                 _today += 1;
419             }
420             player[_player].units = player[_player].units.sub(expiredUnit);
421         }
422         player[_player].plyrLastSeen = today;
423     }
424 
425     /**
426      * @dev pay external stakeholder
427      */
428     function distributeEx(uint256 _eth, address payable _agent) internal {
429         // 20% to external
430         uint256 ex = _eth / 5 ;
431 
432         // 10% to IIP
433         uint256 _iip = _eth / 10;
434 
435         if(player[_agent].isAgent){
436             uint256 refRate = player[_agent].level.add(6);
437             uint256 _ref = _eth.mul(refRate) / 100;
438             player[_agent].ref = player[_agent].ref.add(_ref);
439             player[_agent].accumulatedRef = player[_agent].accumulatedRef.add(_ref);
440             ex = ex.sub(_ref);
441         }
442 
443         sendContract(IIP, _iip);
444         sendContract(hakka, ex);
445     }
446 
447     /**
448      * @dev Distribute to internal
449      */
450     function distributeIn(address _buyer, uint256 _eth, uint256 _shares) internal {
451         // 15% to share holder
452         uint256 _div = _eth.mul(3) / 20;
453 
454         // 55% to insurance pool
455         uint256 _pool = _eth.mul(55) / 100;
456 
457         // distribute dividend share and collect dust
458         uint256 _dust = updateMasks(_buyer, _div, _shares);
459 
460         // add eth to pool
461         pool = pool.add(_dust).add(_pool);
462 
463         
464     }
465 
466     function updateMasks(address  _player, uint256 _div, uint256 _shares)
467         private
468         returns(uint256)
469     {
470         // calculate profit per share & global mask based on this buy: (dust goes to pool)
471         uint256 _ppt = _div.mul(1000000000000000000) / shares;
472         mask = mask.add(_ppt);
473 
474         // calculate player earning from their own buy (only based on the shares
475         // they just bought). & update player earnings mask
476         uint256 _pearn = (_ppt.mul(_shares)) / 1000000000000000000;
477         player[_player].mask = (((mask.mul(_shares)) / 1000000000000000000).sub(_pearn)).add(player[_player].mask);
478 
479         // calculate & return dust
480         return(_div.sub( _ppt.mul(shares) / 1000000000000000000));
481     }
482 
483     /**
484      * @dev Submit a claim from a beneficiary
485      */
486     function claim()
487         isHuman()
488         public
489     {
490         require(tick(), "not yet"); // MakerDAO shutdown!
491         address payable beneficiary = msg.sender;
492         require(!player[beneficiary].claimed, "already claimed");
493         updatePlayerUnit(beneficiary);
494         uint256 amount = pool.mul(player[beneficiary].units) / issuedInsurance;
495         player[beneficiary].claimed = true;
496         sendHuman(beneficiary, amount);
497     }
498 
499     /**
500      * @dev Withdraw dividends and ref
501      */
502     function withdraw()
503         public
504     {
505         // get player earnings
506         uint256 _eth;
507         _eth = withdrawEarnings(msg.sender);
508 
509         // pay
510         if (_eth > 0) {
511             if(msg.sender == tx.origin)
512                 sendHuman(msg.sender, _eth);
513             else
514                 sendContract(msg.sender, _eth);
515         }
516     }
517 
518     function withdrawEarnings(address _player)
519         private
520         returns(uint256)
521     {
522         uint256 _div = calcUnMaskedEarnings(_player); //dividend
523         uint256 _ref = player[_player].ref; // referral 
524         uint256 _earnings = _div.add(_ref);
525 
526         if (_earnings > 0) {
527             player[_player].ref = 0;
528             player[_player].mask = _div.add(player[_player].mask);
529         }
530 
531         return(_earnings);
532     }
533 
534     function calcUnMaskedEarnings(address _player)
535         private
536         view
537         returns(uint256)
538     {
539         return (mask.mul(player[_player].shares) / 1000000000000000000).sub(player[_player].mask);
540     }
541 
542     //******************
543     // GETTERS
544     //******************
545 
546     /**
547      * @dev Return the price buyer will pay for next 1 individual share.
548      * @return Price for next share bought (in wei format)
549      */
550     function getBuyPrice() external view returns(uint256) {
551         return underwriter.burnShare(shares.add(1000000000000000000), 1000000000000000000);
552     }
553 
554     /**
555      * @dev Get the units of insurance of player
556      * @return Amount of existing units of insurance
557      */
558     function getCurrentUnit(address _player)
559         external
560         view
561         returns(uint256)
562     {
563         uint256 _unit = player[_player].units;
564         uint256 _today = player[_player].plyrLastSeen;
565         uint256 expiredUnit = 0;
566         if(_today != 0) {
567             while(_today < today){
568                 expiredUnit = expiredUnit.add(unitToExpirePlayer[_player][_today]);
569                 _today += 1;
570             }
571 
572         }
573         return _unit == 0 ? 0 : _unit.sub(expiredUnit);
574     }
575 
576     /**
577      * @dev Get the list of units of insurace going to expire of a player
578      * @return List of units of insurance going to expire from a player
579      */
580     function getExpiringUnitListPlayer(address _player)
581         external
582         view
583         returns(uint256[maxInsurePeriod] memory expiringUnitList)
584     {
585         for(uint256 i=0; i<maxInsurePeriod; i++) {
586             expiringUnitList[i] = unitToExpirePlayer[_player][today+i];
587         }
588         return expiringUnitList;
589     }
590 
591     /**
592      * @dev Get the list of units of insurace going to expire
593      * @return List of units of insurance going to expire
594      */
595     function getExpiringUnitList()
596         external
597         view
598         returns(uint256[maxInsurePeriod] memory expiringUnitList)
599     {
600         for(uint256 i=0; i<maxInsurePeriod; i++){
601             expiringUnitList[i] = unitToExpire[today+i];
602         }
603         return expiringUnitList;
604     }
605 
606     //******************
607     // ERC20
608     //******************
609     string  public constant name     = "Third Floor Mutual";
610     string  public constant symbol   = "3FM";
611     uint8   public constant decimals = 18;
612 
613     function totalSupply() external view returns(uint256) {
614         if(ended) return 0;
615         return shares;
616     }
617 
618     function balanceOf(address who) external view returns(uint256) {
619         if(ended) return 0;
620         return player[who].shares;
621     }
622 
623     event Transfer(address indexed from, address indexed to, uint256 amount);
624 
625     //******************
626     // send eth
627     //******************
628 
629     function sendHuman(address to, uint256 amount) internal returns(bool success) {
630         address payable recipient = address(uint160(to));
631         (success, ) = recipient.call.value(amount)("");
632     }
633 
634     function sendContract(address to, uint256 amount) internal returns(bool success) {
635         address payable recipient = address(uint160(to));
636         (new SafeSend).value(amount)(recipient);
637         return true;
638     }
639 
640 }
641 
642 contract VAT {
643     function live() external returns(uint256);
644 }
645 
646 contract SafeSend {
647     constructor(address payable to) public payable {
648         selfdestruct(to);
649     }
650 }
651 
652 contract Underwriter {
653     function mintShare(uint256 _curEth, uint256 _newEth) external pure returns (uint256);
654     function burnShare(uint256 _curShares, uint256 _sellShares) external pure returns (uint256);
655     function shares(uint256 _eth) public pure returns(uint256);
656     function eth(uint256 _shares) public pure returns(uint256);
657 }
658 
659 
660 contract Agency {
661     function register(string memory _input) public pure returns(bytes32);
662 }
663 
664 library SafeMath {
665 
666     function mul(uint256 a, uint256 b)
667         internal
668         pure
669         returns (uint256 c)
670     {
671         if (a == 0) return 0;
672         c = a * b;
673         require(c / a == b);
674     }
675 
676     function sub(uint256 a, uint256 b)
677         internal
678         pure
679         returns (uint256 c)
680     {
681         require(b <= a);
682         c = a - b;
683     }
684 
685     function add(uint256 a, uint256 b)
686         internal
687         pure
688         returns (uint256 c)
689     {
690         c = a + b;
691         require(c >= a);
692     }
693 
694     function sqrt(uint256 x)
695         internal
696         pure
697         returns (uint256 y)
698     {
699         uint256 z = add(x >> 1, 1);
700         y = x;
701         while (z < y)
702         {
703             y = z;
704             z = ((add((x / z), z)) / 2);
705         }
706     }
707 
708     function sq(uint256 x)
709         internal
710         pure
711         returns (uint256)
712     {
713         return (mul(x,x));
714     }
715 
716     function pwr(uint256 x, uint256 y) internal pure returns(uint256 z) {
717         z = 1;
718         while(y != 0){
719             if(y % 2 == 1)
720                 z = mul(z,x);
721             x = sq(x);
722             y = y / 2;
723         }
724         return z;
725     }
726 
727 }