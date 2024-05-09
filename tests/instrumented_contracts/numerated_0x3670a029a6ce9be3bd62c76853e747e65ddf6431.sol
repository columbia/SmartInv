1 pragma solidity ^0.4.25;
2 
3 contract NTA3DEvents {
4 
5     event onNewName (
6         uint256 indexed playerID,
7         address indexed playerAddress,
8         bytes32 indexed playerName,
9         uint256 timeStamp
10     );
11 
12     event onWithdraw
13     (
14         uint256 indexed playerID,
15         address playerAddress,
16         bytes32 playerName,
17         uint256 ethOut,
18         uint256 timeStamp
19     );
20 
21     event onBuyKey
22     (
23         uint256 indexed playerID,
24         address indexed playerAddress,
25         bytes32 indexed playerName,
26         uint256 roundID,
27         uint256 ethIn,
28         uint256 keys,
29         uint256 timeStamp
30     );
31 
32     event onBuyCard
33     (
34         uint256 indexed playerID,
35         address indexed playerAddress,
36         bytes32 indexed playerName,
37         uint256 cardID,
38         uint256 ethIn,
39         uint256 timeStamp
40     );
41 
42     event onRoundEnd
43     (
44         address winnerAddr,
45         bytes32 winnerName,
46         uint256 roundID,
47         uint256 amountWon,
48         uint256 newPot,
49         uint256 timeStamp
50     );
51 
52     event onDrop
53     (
54         address dropwinner,
55         bytes32 winnerName,
56         uint256 roundID,
57         uint256 droptype, //0:smalldrop 1:bigdop
58         uint256 win,
59         uint256 timeStamp
60     );
61 
62 }
63 
64 contract NTA3D is NTA3DEvents {
65     using SafeMath for *;
66     using NameFilter for string;
67     using NTA3DKeysCalc for uint256;
68 
69     string constant public name = "No Tricks Allow 3D";
70     string constant public symbol = "NTA3D";
71     bool activated_;
72     address admin;
73     uint256 constant private rndStarts = 12 hours; // ??need to be continue
74     uint256 constant private rndPerKey = 15 seconds; // every key increase seconds
75     uint256 constant private rndMax = 12 hours;  //max count down time;
76     uint256 constant private cardValidity = 1 hours; //stock cards validity
77     uint256 constant private cardPrice = 0.05 ether; //stock cards validity
78     uint256 constant private DIVIDE = 1000; // common divide tool
79 
80     uint256 constant private smallDropTrigger = 100 ether;
81     uint256 constant private bigDropTrigger = 300000 * 1e18;
82     uint256 constant private keyPriceTrigger = 50000 * 1e18;
83     uint256 constant private keyPriceFirst = 0.0005 ether;
84     uint256 constant private oneOffInvest1 = 0.1 ether;//VIP 1
85     uint256 constant private oneOffInvest2 = 1 ether;// VIP 2
86 
87     //uint256 public airDropTracker_ = 0;
88     uint256 public rID;    // round id number / total rounds that have happened
89     uint256 public pID;    // total players
90 
91     //player map data
92     mapping (address => uint256) public pIDxAddr; // get pid by address
93     mapping (bytes32 => uint256) public pIDxName; // get name by pid
94     mapping (uint256 => NTAdatasets.Player) public pIDPlayer; // get player struct by pid\
95     mapping (uint256 => mapping (uint256 => NTAdatasets.PlayerRound)) public pIDPlayerRound; // pid => rid => playeround
96 
97     //stock cards
98     mapping (uint256 => NTAdatasets.Card) cIDCard; //get card by cID
99     address cardSeller;
100 
101     //team map data
102     //address gameFundsAddr = 0xFD7A82437F7134a34654D7Cb8F79985Df72D7076;
103     address[11] partner;
104     address to06;
105     address to04;
106     address to20A;
107     address to20B;
108     mapping (address => uint256) private gameFunds; // game develeopment get 5% funds
109     //uint256 private teamFee;    // team Fee 5%
110 
111     //round data
112     mapping (uint256 => NTAdatasets.Round) public rIDRound;   // round data
113 
114     // team dividens
115     mapping (uint256 => NTAdatasets.Deposit) public deposit;
116     mapping (uint256 => NTAdatasets.PotSplit) public potSplit;
117 
118     constructor() public {
119 
120         //constructor
121         activated_ = false;
122         admin = msg.sender;
123         // Team allocation structures
124         // 0 = BISHOP
125         // 1 = ROOK
126 
127         // BISHOP team: ==> |46% to all, 17% to winnerPot, 5% to develop funds, 5% to teamfee, 10% to cards,
128         //                  |7% to fisrt degree invatation
129         //                  |3% to second degree invatation, 2% to big airdrop, 5% to small airdrop
130         deposit[0] = NTAdatasets.Deposit(460, 170, 50, 50, 100, 100, 20, 50);
131         // ROOK team:   ==> |20% to all, 43% to winnerPot, 5% to develop funds, 5% to teamfee, 10% to cards,
132         //                  |7% to fisrt degree invatation
133         //                  |3% to second degree invatation, 2% to big airdrop, 5% to small airdrop
134         deposit[1] = NTAdatasets.Deposit(200, 430, 50, 50, 100, 100, 20, 50);
135 
136         // potSplit:    ==> |20% to all, 45% to lastwinner, 5% to inviter 1st, 3% to inviter 2nd, 2% to inviter 3rd,
137         //                  |8% to key buyer 1st, 5% to key buyer 2nd, 2% to key buyer 3rd, 10% to next round
138         potSplit[0] = NTAdatasets.PotSplit(200, 450, 50, 30, 20, 80, 50, 20, 100);
139         potSplit[1] = NTAdatasets.PotSplit(200, 450, 50, 30, 20, 80, 50, 20, 100);
140         //partner list 
141         //iniailize in active function
142         //develeopment
143         to06 = 0x9B53CC857cD9DD5EbE6bc07Bde67D8CE4076345f;
144         to04 = 0x5835a72118c0C784203B8d39936A0875497B6eCa;
145         to20A = 0xEc2441D3113fC2376cd127344331c0F1b959Ce1C;
146         to20B = 0xd1Dac908c97c0a885e9B413a84ACcC0010C002d2;
147         
148         //card
149         cardSeller = 0xeE4f032bdB0f9B51D6c7035d3DEFfc217D91225C;
150     }
151 
152 //==============================================================================
153 //
154 //    safety checks
155 //==============================================================================
156     //tested
157     modifier isActivated() {
158         require(activated_ == true, "its not ready yet");
159         _;
160     }
161 
162     /**
163      * @dev prevents contracts from interacting with fomo3d
164      */
165     //tested
166     modifier isHuman() {
167         address _addr = msg.sender;
168         uint256 _codeLength;
169 
170         assembly {_codeLength := extcodesize(_addr)}
171         require(_codeLength == 0, "sorry humans only");
172         _;
173     }
174     //tested
175     modifier isAdmin() {require(msg.sender == admin, "its can only be call by admin");_;}
176 
177     /**
178      * @dev sets boundaries for incoming tx
179      */
180     //tested
181     modifier isWithinLimits(uint256 _eth) {
182         require(_eth >= 1000000000, "pocket lint: not a valid currency");
183         require(_eth <= 100000000000000000000000, "no vitalik, no");
184         _;
185     }
186 
187 //==============================================================================
188 //
189 //    admin functions
190 //==============================================================================
191     //tested
192     function active() isAdmin() public {
193         activated_ = true;
194         partner[0] = 0xE27Aa5E7D8906779586CfB9DbA2935BDdd7c8210;
195         partner[1] = 0xD4638827Dc486cb59B5E5e47955059A160BaAE13;
196         partner[2] = 0xa088c667591e04cC78D6dfA3A392A132dc5A7f9d;
197         partner[3] = 0xed38deE26c751ff575d68D9Bf93C312e763f8F87;
198         partner[4] = 0x42A7B62f71b7778279DA2639ceb5DD6ee884f905;
199         partner[5] = 0xd471409F3eFE9Ca24b63855005B08D4548742a5b;
200         partner[6] = 0x41c9F005eD19C2B620152f5562D26029b32078B6;
201         partner[7] = 0x11b85bc860A6C38fa7fe6f54f18d350eF5f2787b;
202         partner[8] = 0x11a7c5E7887F2C34356925275882D4321a6B69A8;
203         partner[9] = 0xB5754c7bD005b6F25e1FDAA5f94b2b71e6eA260f;
204         partner[10] = 0x6fbC15cF6d0B05280E99f753E45B631815715E99;
205     }
206     //tested
207     function startFirstRound() isAdmin() isActivated() public {
208         //must not open before
209         require(rID == 0);
210         newRound(0);
211     }
212 
213     function teamWithdraw() public
214     isHuman()
215     isActivated()
216     {
217         uint256 _temp;
218         address to = msg.sender;
219         require(gameFunds[to] != 0, "you dont have funds");
220         _temp = gameFunds[to];
221         gameFunds[to] = 0;
222         to.transfer(_temp);
223     }
224 
225     function getTeamFee(address _addr)
226     public
227     view
228     returns(uint256) {
229         return gameFunds[_addr];
230     }
231 
232     function getScore(address _addr)
233     public
234     view
235     isAdmin()
236     returns(uint256) {
237         uint256 _pID = pIDxAddr[_addr];
238         if(_pID == 0 ) return 0;
239         else return pIDPlayerRound[_pID][rID].score;
240     }
241 
242 //==============================================================================
243 //
244 //    player functions
245 //==============================================================================
246 
247     //emergency buy uses BISHOP team to buy keys
248     function()
249     isActivated()
250     isHuman()
251     isWithinLimits(msg.value)
252     public
253     payable
254     {
255         //fetch player
256         require(rID != 0, "No round existed yet");
257         uint256 _pID = managePID(0);
258         //buy key
259         buyCore(_pID, 0);
260     }
261 
262     // buy with ID: inviter use pID to invate player to buy like "www.NTA3D.io/?id=101"
263     function buyXid(uint256 _team,uint256 _inviter)
264     isActivated()
265     isHuman()
266     isWithinLimits(msg.value)
267     public
268     payable
269     {
270         require(rID != 0, "No round existed yet");
271         uint256 _pID = managePID(_inviter);
272         if (_team < 0 || _team > 1 ) {
273             _team = 0;
274         }
275         buyCore(_pID, _team);
276     }
277 
278     // buy with ID: inviter use pID to invate player to buy like "www.NTA3D.io/?n=obama"
279     function buyXname(uint256 _team,string _invName)
280     isActivated()
281     isHuman()
282     isWithinLimits(msg.value)
283     public
284     payable
285     {
286         require(rID != 0, "No round existed yet");
287         bytes32 _name = _invName.nameFilter();
288         uint256 _invPID = pIDxName[_name];
289         uint256 _pID = managePID(_invPID);
290         if (_team < 0 || _team > 1 ) {
291             _team = 0;
292         }
293         buyCore(_pID, _team);
294     }
295 
296     function buyCardXname(uint256 _cID, string _invName)
297     isActivated()
298     isHuman()
299     isWithinLimits(msg.value)
300     public
301     payable {
302         uint256 _value = msg.value;
303         uint256 _now = now;
304         require(_cID < 20, "only has 20 cards");
305         require(_value == cardPrice, "the card cost 0.05 ether");
306         require(cIDCard[_cID].owner == 0 || (cIDCard[_cID].buyTime + cardValidity) < _now, "card is in used");
307         bytes32 _name = _invName.nameFilter();
308         uint256 _invPID = pIDxName[_name];
309         uint256 _pID = managePID(_invPID);
310         for (uint i = 0; i < 20; i++) {
311             require(_pID != cIDCard[i].owner, "you already registed a card");
312         }
313         gameFunds[cardSeller] = gameFunds[cardSeller].add(_value);
314         cIDCard[_cID].addr = msg.sender;
315         cIDCard[_cID].owner = _pID;
316         cIDCard[_cID].buyTime = _now;
317         cIDCard[_cID].earnings = 0;
318         emit onBuyCard(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _cID, _value, now);
319     }
320 
321     function buyCardXid(uint256 _cID, uint256 _inviter)
322     isActivated()
323     isHuman()
324     isWithinLimits(msg.value)
325     public
326     payable {
327         uint256 _value = msg.value;
328         uint256 _now = now;
329         require(_cID < 20, "only has 20 cards");
330         require(_value == cardPrice, "the card cost 0.05 ether");
331         require(cIDCard[_cID].owner == 0 || (cIDCard[_cID].buyTime + cardValidity) < _now, "card is in used");
332         uint256 _pID = managePID(_inviter);
333         for (uint i = 0; i < 20; i++) {
334             require(_pID != cIDCard[i].owner, "you already registed a card");
335         }
336         gameFunds[cardSeller] = gameFunds[cardSeller].add(_value);
337         cIDCard[_cID].addr = msg.sender;
338         cIDCard[_cID].owner = _pID;
339         cIDCard[_cID].buyTime = _now;
340         cIDCard[_cID].earnings = 0;
341         emit onBuyCard(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _cID, _value, now);
342     }
343 
344 
345     // regist a name
346     function registNameXid(string _nameString, uint256 _inviter)
347     isActivated()
348     isHuman()
349     public {
350         bytes32 _name = _nameString.nameFilter();
351         uint256 temp = pIDxName[_name];
352         require(temp == 0, "name already regist");
353         uint256 _pID = managePID(_inviter);
354         pIDxName[_name] = _pID;
355         pIDPlayer[_pID].name = _name;
356         //emit
357         emit onNewName(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, now);
358     }
359 
360     function registNameXname(string _nameString, string _inviterName)
361     isActivated()
362     isHuman()
363     public {
364         bytes32 _name = _nameString.nameFilter();
365         uint256 temp = pIDxName[_name];
366         require(temp == 0, "name already regist");
367         bytes32 _invName = _inviterName.nameFilter();
368         uint256 _invPID = pIDxName[_invName];
369         uint256 _pID = managePID(_invPID);
370         pIDxName[_name] = _pID;
371         pIDPlayer[_pID].name = _name;
372         //emit
373         emit onNewName(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, now);
374     }
375 
376     function withdraw()
377     isActivated()
378     isHuman()
379     public {
380         // setup local rID
381         uint256 _rID = rID;
382         // grab time
383         uint256 _now = now;
384         uint256 _pID = pIDxAddr[msg.sender];
385         require(_pID != 0, "cant find user");
386         uint256 _eth = 0;
387         if (rIDRound[_rID].end < _now && rIDRound[_rID].ended == false) {
388             rIDRound[_rID].ended = true;
389             endRound();
390         }
391         // get their earnings
392         _eth = withdrawEarnings(_pID);
393         // gib moni
394         if (_eth > 0)
395             pIDPlayer[_pID].addr.transfer(_eth);
396         //emit
397         emit onWithdraw(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _eth, now);
398     }
399 //==============================================================================
400 //
401 //    view functions
402 //==============================================================================
403     /**
404      * return the price buyer will pay for next 1 individual key.
405      * @return price for next key bought (in wei format)
406      */
407      //tested
408     function getBuyPrice(uint256 _key)
409     public
410     view
411     returns(uint256) {
412         // setup local rID
413         uint256 _rID = rID;
414         // grab time
415         uint256 _now = now;
416         uint256 _keys = rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys;
417         // round is active
418         if (rIDRound[_rID].end >= _now || (rIDRound[_rID].end < _now && rIDRound[_rID].leadPID == 0))
419             return _keys.ethRec(_key * 1e18);
420         else
421             return keyPriceFirst;
422     }
423 
424     /**
425      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
426      * @return time left in seconds
427      */
428      //tested
429     function getTimeLeft()
430     public
431     view
432     returns(uint256) {
433         // setup local rID
434         uint256 _rID = rID;
435         // grab time
436         uint256 _now = now;
437 
438         if (rIDRound[_rID].end >= _now)
439             return (rIDRound[_rID].end.sub(_now));
440         else
441             return 0;
442     }
443 
444     //tested
445     function getPlayerVaults()
446     public
447     view
448     returns(uint256, uint256, uint256, uint256, uint256) {
449         // setup local rID
450         uint256 _rID = rID;
451         uint256 _now = now;
452         uint256 _pID = pIDxAddr[msg.sender];
453         if (_pID == 0)
454             return (0, 0, 0, 0, 0);
455         uint256 _last = pIDPlayer[_pID].lrnd;
456         uint256 _inv = pIDPlayerRound[_pID][_last].inv;
457         uint256 _invMask = pIDPlayerRound[_pID][_last].invMask;
458         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
459         if (rIDRound[_rID].end < _now && rIDRound[_rID].ended == false && rIDRound[_rID].leadPID != 0) {
460             // if player is winner
461             if (rIDRound[_rID].leadPID == _pID)
462                 return (
463                     (pIDPlayer[_pID].win).add((rIDRound[_rID].pot).mul(45) / 100),
464                     pIDPlayer[_pID].gen.add(calcUnMaskedEarnings(_pID, pIDPlayer[_pID].lrnd)),
465                     pIDPlayer[_pID].inv.add(_inv).sub0(_invMask),
466                     pIDPlayer[_pID].tim.add(calcTeamEarnings(_pID, pIDPlayer[_pID].lrnd)),
467                     pIDPlayer[_pID].crd
468                 );
469             else
470                 return (
471                     pIDPlayer[_pID].win,
472                     pIDPlayer[_pID].gen.add(calcUnMaskedEarnings(_pID, pIDPlayer[_pID].lrnd)),
473                     pIDPlayer[_pID].inv.add(_inv).sub0(_invMask),
474                     pIDPlayer[_pID].tim.add(calcTeamEarnings(_pID, pIDPlayer[_pID].lrnd)),
475                     pIDPlayer[_pID].crd
476                 );
477         } else {
478              return (
479                     pIDPlayer[_pID].win,
480                     pIDPlayer[_pID].gen.add(calcUnMaskedEarnings(_pID, pIDPlayer[_pID].lrnd)),
481                     pIDPlayer[_pID].inv.add(_inv).sub0(_invMask),
482                     pIDPlayer[_pID].tim.add(calcTeamEarnings(_pID, pIDPlayer[_pID].lrnd)),
483                     pIDPlayer[_pID].crd
484                 );
485         }
486     }
487 
488     function getCurrentRoundInfo()
489     public
490     view
491     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256) {
492         // setup local rID
493         uint256 _rID = rID;
494         return(_rID,
495             rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys,    //total key
496             rIDRound[_rID].eth,      //total eth
497             rIDRound[_rID].strt,     //start time
498             rIDRound[_rID].end,      //end time
499             rIDRound[_rID].pot,      //last winer pot
500             rIDRound[_rID].leadPID,  //current last player
501             pIDPlayer[rIDRound[_rID].leadPID].addr, //cureest last player address
502             pIDPlayer[rIDRound[_rID].leadPID].name, //cureest last player name
503             rIDRound[_rID].smallDrop,
504             rIDRound[_rID].bigDrop,
505             rIDRound[_rID].teamPot   //teampot
506             );
507     }
508 
509     function getRankList()
510     public
511     view
512             //invitetop3   amout      keyTop3      key
513     returns (address[3], uint256[3], bytes32[3], address[3], uint256[3], bytes32[3]) {
514         uint256 _rID = rID;
515         address[3] memory inv;
516         address[3] memory key;
517         bytes32[3] memory invname;
518         uint256[3] memory invRef;
519         uint256[3] memory keyamt;
520         bytes32[3] memory keyname;
521         inv[0] = pIDPlayer[rIDRound[_rID].invTop3[0]].addr;
522         inv[1] = pIDPlayer[rIDRound[_rID].invTop3[1]].addr;
523         inv[2] = pIDPlayer[rIDRound[_rID].invTop3[2]].addr;
524         invRef[0] = pIDPlayerRound[rIDRound[_rID].invTop3[0]][_rID].inv;
525         invRef[1] = pIDPlayerRound[rIDRound[_rID].invTop3[1]][_rID].inv;
526         invRef[2] = pIDPlayerRound[rIDRound[_rID].invTop3[2]][_rID].inv;
527         invname[0] = pIDPlayer[rIDRound[_rID].invTop3[0]].name;
528         invname[1] = pIDPlayer[rIDRound[_rID].invTop3[1]].name;
529         invname[2] = pIDPlayer[rIDRound[_rID].invTop3[2]].name;
530 
531         key[0] = pIDPlayer[rIDRound[_rID].keyTop3[0]].addr;
532         key[1] = pIDPlayer[rIDRound[_rID].keyTop3[1]].addr;
533         key[2] = pIDPlayer[rIDRound[_rID].keyTop3[2]].addr;
534         keyamt[0] = pIDPlayerRound[rIDRound[_rID].keyTop3[0]][_rID].team1Keys + pIDPlayerRound[rIDRound[_rID].keyTop3[0]][_rID].team2Keys;
535         keyamt[1] = pIDPlayerRound[rIDRound[_rID].keyTop3[1]][_rID].team1Keys + pIDPlayerRound[rIDRound[_rID].keyTop3[1]][_rID].team2Keys;
536         keyamt[2] = pIDPlayerRound[rIDRound[_rID].keyTop3[2]][_rID].team1Keys + pIDPlayerRound[rIDRound[_rID].keyTop3[2]][_rID].team2Keys;
537         keyname[0] = pIDPlayer[rIDRound[_rID].keyTop3[0]].name;
538         keyname[1] = pIDPlayer[rIDRound[_rID].keyTop3[1]].name;
539         keyname[2] = pIDPlayer[rIDRound[_rID].keyTop3[2]].name;
540 
541         return (inv, invRef, invname, key, keyamt, keyname);
542     }
543 
544     /**
545      * @dev returns player info based on address.  if no address is given, it will
546      * use msg.sender
547      * -functionhash- 0xee0b5d8b
548      * @param _addr address of the player you want to lookup
549      * @return player ID
550      * @return player name
551      * @return keys owned (current round)
552      * @return winnings vault
553      * @return general vault
554      * @return affiliate vault
555 	 * @return player round eth
556      */
557     //tested
558     function getPlayerInfoByAddress(address _addr)
559         public
560         view
561         returns(uint256, bytes32, uint256, uint256, uint256)
562     {
563         // setup local rID
564         uint256 _rID = rID;
565 
566         if (_addr == address(0))
567         {
568             _addr == msg.sender;
569         }
570         uint256 _pID = pIDxAddr[_addr];
571         if (_pID == 0)
572             return (0, 0x0, 0, 0, 0);
573         else
574             return
575             (
576             _pID,                               //0
577             pIDPlayer[_pID].name,                   //1
578             pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys,
579             pIDPlayerRound[_pID][_rID].eth,           //6
580             pIDPlayer[_pID].vip
581             );
582     }
583 
584     function getCards(uint256 _id)
585     public
586     view
587     returns(uint256, address, bytes32, uint256, uint256) {
588         bytes32 _name = pIDPlayer[cIDCard[_id].owner].name;
589         return (
590             cIDCard[_id].owner,
591             cIDCard[_id].addr,
592             _name,
593             cIDCard[_id].buyTime,
594             cIDCard[_id].earnings
595         );
596     }
597 //==============================================================================
598 //
599 //    private functions
600 //==============================================================================
601 
602     //tested
603     function managePID(uint256 _inviter) private returns(uint256) {
604         uint256 _pID = pIDxAddr[msg.sender];
605         if (_pID == 0) {
606             pID++;
607             pIDxAddr[msg.sender] = pID;
608             pIDPlayer[pID].addr = msg.sender;
609             pIDPlayer[pID].name = 0x0;
610             _pID = pID;
611         }
612             // handle direct and second hand inviter
613         if (pIDPlayer[_pID].inviter1 == 0 && pIDPlayer[_inviter].addr != address(0) && _pID != _inviter) {
614             pIDPlayer[_pID].inviter1 = _inviter;
615             uint256 _in = pIDPlayer[_inviter].inviter1;
616             if (_in != 0) {
617                     pIDPlayer[_pID].inviter2 = _in;
618                 }
619             }
620         // oneoff invite get invitation link
621         if (msg.value >= oneOffInvest2) {
622             pIDPlayer[_pID].vip = 2;
623         } else if (msg.value >= oneOffInvest1) {
624             if (pIDPlayer[_pID].vip != 2)
625                 pIDPlayer[_pID].vip = 1;
626         }
627         return _pID;
628     }
629 
630     function buyCore(uint256 _pID, uint256 _team) private {
631         // setup local rID
632         uint256 _rID = rID;
633         // grab time
634         uint256 _now = now;
635 
636         //update last round;
637         if (pIDPlayer[_pID].lrnd != _rID)
638             updateVault(_pID);
639         pIDPlayer[_pID].lrnd = _rID;
640         uint256 _inv1 = pIDPlayer[_pID].inviter1;
641         uint256 _inv2 = pIDPlayer[_pID].inviter2;
642 
643         // round is active
644         if (rIDRound[_rID].end >= _now || (rIDRound[_rID].end < _now && rIDRound[_rID].leadPID == 0)) {
645             core(_rID, _pID, msg.value, _team);
646             if (_inv1 != 0)
647                 doRankInv(_rID, _inv1, rIDRound[_rID].invTop3, pIDPlayerRound[_inv1][_rID].inv);
648             if (_inv2 != 0)
649                 doRankInv(_rID, _inv2, rIDRound[_rID].invTop3, pIDPlayerRound[_inv2][_rID].inv);
650             doRankKey(_rID, _pID, rIDRound[_rID].keyTop3, pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys);
651             emit onBuyKey(
652                 _pID,
653                 pIDPlayer[_pID].addr,
654                 pIDPlayer[_pID].name, _rID,
655                 msg.value,
656                 pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys,
657                 now);
658         } else {
659             if (rIDRound[_rID].end < _now && rIDRound[_rID].ended == false) {
660                 rIDRound[_rID].ended = true;
661                 endRound();
662                 //if you trigger the endround. whatever how much you pay ,you will fail to buykey
663                 //and the eth will return to your gen.
664                 pIDPlayer[_pID].gen = pIDPlayer[_pID].gen.add(msg.value);
665             }
666         }
667     }
668 
669     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team) private {
670 
671         NTAdatasets.Round storage _roundID = rIDRound[_rID];
672         NTAdatasets.Deposit storage _deposit = deposit[_team];
673         //NTAdatasets.PlayerRound storage _playerRound = pIDPlayerRound[_pID][_rID];
674         // calculate how many keys they can get
675         uint256 _keysAll = _roundID.team1Keys + _roundID.team2Keys;//(rIDRound[_rID].eth).keysRec(_eth);
676         uint256 _keys = _keysAll.keysRec(rIDRound[_rID].eth + _eth);
677         if (_keys >= 1000000000000000000) {
678             updateTimer(_keys, _rID);
679         }
680 
681         uint256 _left = _eth;
682         //2% to bigDrop
683         uint256 _temp = _eth.mul(_deposit.bigDrop) / DIVIDE;
684         doBigDrop(_rID, _pID, _keys, _temp);
685         _left = _left.sub0(_temp);
686 
687         //5% to smallDrop
688         _temp = _eth.mul(_deposit.smallDrop) / DIVIDE;
689         doSmallDrop(_rID, _pID, _eth, _temp);
690         _left = _left.sub0(_temp);
691 
692         _roundID.eth = _roundID.eth.add(_eth);
693         pIDPlayerRound[_pID][_rID].eth = pIDPlayerRound[_pID][_rID].eth.add(_eth);
694         if (_team == 0) {
695             _roundID.team1Keys = _roundID.team1Keys.add(_keys);
696             pIDPlayerRound[_pID][_rID].team1Keys = pIDPlayerRound[_pID][_rID].team1Keys.add(_keys);
697         } else {
698             _roundID.team2Keys = _roundID.team2Keys.add(_keys);
699             pIDPlayerRound[_pID][_rID].team2Keys = pIDPlayerRound[_pID][_rID].team2Keys.add(_keys);
700         }
701 
702 
703         //X% to all
704         uint256 _all = _eth.mul(_deposit.allPlayer) / DIVIDE;
705         _roundID.playerPot = _roundID.playerPot.add(_all);
706         uint256 _dust = updateMasks(_rID, _pID, _all, _keys);
707         _roundID.pot = _roundID.pot.add(_dust);
708         _left = _left.sub0(_all);
709 
710         //X% to winnerPot
711         _temp = _eth.mul(_deposit.pot) / DIVIDE;
712         _roundID.pot = _roundID.pot.add(_temp);
713         _left = _left.sub0(_temp);
714 
715         //5% to develop funds
716         _temp = _eth.mul(_deposit.devfunds) / DIVIDE;
717         doDevelopFunds(_temp);
718         //gameFunds[gameFundsAddr] = gameFunds[gameFundsAddr].add(_temp);
719         _left = _left.sub0(_temp);
720 
721         //5% to team fee
722         _temp = _eth.mul(_deposit.teamFee) / DIVIDE;
723         //gameFunds[partner1] = gameFunds[partner1].add(_temp.mul(50) / DIVIDE);
724         _dust = doPartnerShares(_temp);
725         _left = _left.sub0(_temp).add(_dust);
726 
727         //10% to cards
728         _temp = _eth.mul(_deposit.cards) / DIVIDE;
729         _left = _left.sub0(_temp).add(distributeCards(_temp));
730         // if no cards ,the money will add into left
731 
732         // 10% to invatation
733         _temp = _eth.mul(_deposit.inviter) / DIVIDE;
734         _dust = doInvite(_rID, _pID, _temp);
735         _left = _left.sub0(_temp).add(_dust);
736 
737         //update round;
738         if (_keys >= 1000000000000000000) {
739             _roundID.leadPID = _pID;
740             _roundID.team = _team;
741         }
742 
743 
744         _roundID.smallDrop = _roundID.smallDrop.add(_left);
745     }
746 
747     //tested
748     function doInvite(uint256 _rID, uint256 _pID, uint256 _value) private returns(uint256){
749         uint256 _score = msg.value;
750         uint256 _left = _value;
751         uint256 _inviter1 = pIDPlayer[_pID].inviter1;
752         uint256 _fee;
753         uint256 _inviter2 = pIDPlayer[_pID].inviter2;
754         if (_inviter1 != 0) 
755             pIDPlayerRound[_inviter1][_rID].score = pIDPlayerRound[_inviter1][_rID].score.add(_score);
756         if (_inviter2 != 0) 
757             pIDPlayerRound[_inviter2][_rID].score = pIDPlayerRound[_inviter2][_rID].score.add(_score);
758         //invitor
759         if (_inviter1 == 0 || pIDPlayer[_inviter1].vip == 0)
760             return _left;
761         if (pIDPlayer[_inviter1].vip == 1) {
762             _fee = _value.mul(70) / 100;
763             _inviter2 = pIDPlayer[_pID].inviter2;
764             _left = _left.sub0(_fee);
765             pIDPlayerRound[_inviter1][_rID].inv = pIDPlayerRound[_inviter1][_rID].inv.add(_fee);
766             if (_inviter2 == 0 || pIDPlayer[_inviter2].vip != 2)
767                 return _left;
768             else {
769                 _fee = _value.mul(30) / 100;
770                 _left = _left.sub0(_fee);
771                 pIDPlayerRound[_inviter2][_rID].inv = pIDPlayerRound[_inviter2][_rID].inv.add(_fee);
772                 return _left;
773             }
774         } else if (pIDPlayer[_inviter1].vip == 2) {
775             _left = _left.sub0(_value);
776             pIDPlayerRound[_inviter1][_rID].inv = pIDPlayerRound[_inviter1][_rID].inv.add(_value);
777             return _left;
778         } else {
779             return _left;
780         }
781     }
782 
783     function doRankInv(uint256 _rID, uint256 _pID, uint256[3] storage rank, uint256 _value) private {
784 
785         if (_value >= pIDPlayerRound[rank[0]][_rID].inv && _value != 0) {
786             if (_pID != rank[0]) {
787             uint256 temp = rank[0];
788             rank[0] = _pID;
789             if (rank[1] == _pID) {
790                 rank[1] = temp;
791             } else {
792                 rank[2] = rank[1];
793                 rank[1] = temp;
794             }
795             }
796         } else if (_value >= pIDPlayerRound[rank[1]][_rID].inv && _value != 0) {
797             if (_pID != rank[1]) {
798             rank[2] = rank[1];
799             rank[1] = _pID;
800             }
801         } else if (_value >= pIDPlayerRound[rank[2]][_rID].inv && _value != 0) {
802             rank[2] = _pID;
803         }
804     }
805 
806     function doRankKey(uint256 _rID, uint256 _pID, uint256[3] storage rank, uint256 _value) private {
807 
808         if (_value >= (pIDPlayerRound[rank[0]][_rID].team1Keys + pIDPlayerRound[rank[0]][_rID].team2Keys)) {
809             if (_pID != rank[0]) {
810             uint256 temp = rank[0];
811             rank[0] = _pID;
812             if (rank[1] == _pID) {
813                 rank[1] = temp;
814             } else {
815                 rank[2] = rank[1];
816                 rank[1] = temp;
817             }
818             }
819         } else if (_value >= (pIDPlayerRound[rank[1]][_rID].team1Keys + pIDPlayerRound[rank[1]][_rID].team2Keys)) {
820             if (_pID != rank[1]){
821             rank[2] = rank[1];
822             rank[1] = _pID;
823             }
824         } else if (_value >= (pIDPlayerRound[rank[2]][_rID].team1Keys + pIDPlayerRound[rank[2]][_rID].team2Keys)) {
825             rank[2] = _pID;
826         }
827     }
828 
829     //tested
830     function doSmallDrop(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _small) private {
831         // modulo current round eth, and add player eth to see if it can trigger the trigger;
832         uint256 _remain = rIDRound[_rID].eth % smallDropTrigger;
833         if ((_remain + _eth) >= smallDropTrigger) {
834             uint256 _reward = rIDRound[_rID].smallDrop;
835             rIDRound[_rID].smallDrop = 0;
836             pIDPlayer[_pID].win = pIDPlayer[_pID].win.add(_reward);
837             rIDRound[_rID].smallDrop = rIDRound[_rID].smallDrop.add(_small);
838             emit NTA3DEvents.onDrop(pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _rID, 0, _reward, now);
839             //emit
840         } else {
841             rIDRound[_rID].smallDrop = rIDRound[_rID].smallDrop.add(_small);
842         }
843     }
844 
845     //tested
846     function doBigDrop(uint256 _rID, uint256 _pID, uint256 _key, uint256 _big) private {
847         uint256 _keys = rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys;
848         uint256 _remain = _keys % bigDropTrigger;
849         if ((_remain + _key) >= bigDropTrigger) {
850             uint256 _reward = rIDRound[_rID].bigDrop;
851             rIDRound[_rID].bigDrop = 0;
852             pIDPlayer[_pID].win = pIDPlayer[_pID].win.add(_reward);
853             rIDRound[_rID].bigDrop = rIDRound[_rID].bigDrop.add(_big);
854             emit NTA3DEvents.onDrop(pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _rID, 1, _reward, now);
855             //emit
856         } else {
857             rIDRound[_rID].bigDrop = rIDRound[_rID].bigDrop.add(_big);
858         }
859     }
860 
861     function distributeCards(uint256 _eth) private returns(uint256){
862         uint256 _each = _eth / 20;
863         uint256 _remain = _eth;
864         for (uint i = 0; i < 20; i++) {
865             uint256 _pID = cIDCard[i].owner;
866             if (_pID != 0) {
867                 pIDPlayer[_pID].crd = pIDPlayer[_pID].crd.add(_each);
868                 cIDCard[i].earnings = cIDCard[i].earnings.add(_each);
869                 _remain = _remain.sub0(_each);
870             }
871         }
872         return _remain;
873     }
874     
875     function doPartnerShares(uint256 _eth) private returns(uint256) {
876         uint i;
877         uint256 _temp;
878         uint256 _left = _eth;
879         //first 10%
880         _temp = _eth.mul(10) / 100;
881         gameFunds[partner[0]] = gameFunds[partner[0]].add(_temp);
882         for(i = 1; i < 11; i++) {
883             _temp = _eth.mul(9) / 100;
884             gameFunds[partner[i]] = gameFunds[partner[i]].add(_temp);
885             _left = _left.sub0(_temp);
886         }
887         return _left;
888     }
889     
890     function doDevelopFunds(uint256 _eth) private{
891         uint256 _temp;
892         _temp = _eth.mul(12) / 100;
893         gameFunds[to06] = gameFunds[to06].add(_temp);
894         _temp = _eth.mul(8) / 100;    
895         gameFunds[to04] = gameFunds[to04].add(_temp);
896         _temp = _eth.mul(40) / 100;
897         gameFunds[to20A] = gameFunds[to20A].add(_temp);
898         _temp = _eth.mul(40) / 100;
899         gameFunds[to20B] = gameFunds[to20B].add(_temp);
900     }
901 
902     function endRound() private {
903         NTAdatasets.Round storage _roundID = rIDRound[rID];
904         NTAdatasets.PotSplit storage _potSplit = potSplit[0];
905         uint256 _winPID = _roundID.leadPID;
906         uint256 _pot = _roundID.pot;
907         uint256 _left = _pot;
908 
909         //the pot is too small endround will ignore the dividens
910         //new round will start at 0 eth
911         if(_pot < 10000000000000) {
912             emit onRoundEnd(pIDPlayer[_winPID].addr, pIDPlayer[_winPID].name, rID, _roundID.pot,0, now);
913             newRound(0);
914             return;
915         }
916 
917         // potSplit:    ==> |20% to all, 45% to lastwinner, 5% to inviter 1st, 3% to inviter 2nd, 2% to inviter 3rd,
918         //                  |8% to key buyer 1st, 5% to key buyer 2nd, 2% to key buyer 3rd, 10% to next round
919 
920         //20% to all
921         uint256 _all = _pot.mul(_potSplit.allPlayer) / DIVIDE;
922         _roundID.teamPot = _roundID.teamPot.add(_all);
923         _left = _left.sub0(_all);
924 
925         //45% to lastwinner
926         uint256 _temp = _pot.mul(_potSplit.lastWinner) / DIVIDE;
927         pIDPlayer[_winPID].win = pIDPlayer[_winPID].win.add(_temp);
928         _left = _left.sub0(_temp);
929 
930         //5% to inviter 1st, 3% to inviter 2nd, 2% to inviter 3rd
931         uint256 _inv1st = _pot.mul(_potSplit.inviter1st) / DIVIDE;
932         if (_roundID.invTop3[0] != 0) {
933             pIDPlayer[_roundID.invTop3[0]].win = pIDPlayer[_roundID.invTop3[0]].win.add(_inv1st);
934             _left = _left.sub0(_inv1st);
935         }
936 
937         _inv1st = _pot.mul(_potSplit.inviter2nd) / DIVIDE;
938         if (_roundID.invTop3[1] != 0) {
939             pIDPlayer[_roundID.invTop3[1]].win = pIDPlayer[_roundID.invTop3[1]].win.add(_inv1st);
940             _left = _left.sub0(_inv1st);
941         }
942 
943         _inv1st = _pot.mul(_potSplit.inviter3rd) / DIVIDE;
944         if (_roundID.invTop3[2] != 0) {
945             pIDPlayer[_roundID.invTop3[2]].win = pIDPlayer[_roundID.invTop3[2]].win.add(_inv1st);
946             _left = _left.sub0(_inv1st);
947         }
948 
949          //8% to key buyer 1st, 5% to key buyer 2nd, 2% to key buyer 3rd
950         _inv1st = _pot.mul(_potSplit.key1st) / DIVIDE;
951         if (_roundID.keyTop3[0] != 0) {
952             pIDPlayer[_roundID.keyTop3[0]].win = pIDPlayer[_roundID.keyTop3[0]].win.add(_inv1st);
953             _left = _left.sub0(_inv1st);
954         }
955 
956         _inv1st = _pot.mul(_potSplit.key2nd) / DIVIDE;
957         if (_roundID.keyTop3[1] != 0) {
958             pIDPlayer[_roundID.keyTop3[1]].win = pIDPlayer[_roundID.keyTop3[1]].win.add(_inv1st);
959             _left = _left.sub0(_inv1st);
960         }
961 
962         _inv1st = _pot.mul(_potSplit.key3rd) / DIVIDE;
963         if (_roundID.keyTop3[2] != 0) {
964             pIDPlayer[_roundID.keyTop3[2]].win = pIDPlayer[_roundID.keyTop3[2]].win.add(_inv1st);
965             _left = _left.sub0(_inv1st);
966         }
967 
968         //10% to next round
969         uint256 _newPot = _pot.mul(potSplit[0].next) / DIVIDE;
970         _left = _left.sub0(_newPot);
971         emit onRoundEnd(pIDPlayer[_winPID].addr, pIDPlayer[_winPID].name, rID, _roundID.pot, _newPot + _left, now);
972         //start new round
973         newRound(_newPot + _left);
974     }
975 
976     //tested
977     function newRound(uint256 _eth) private {
978         if (rIDRound[rID].ended == true || rID == 0) {
979             rID++;
980             rIDRound[rID].strt = now;
981             rIDRound[rID].end = now.add(rndMax);
982             rIDRound[rID].pot = rIDRound[rID].pot.add(_eth);
983         }
984     }
985 
986     function updateMasks(uint256 _rID, uint256 _pID, uint256 _all, uint256 _keys) private
987     returns(uint256) {
988         //calculate average share of each new eth in
989         uint256 _allKeys = rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys;
990         uint256 _unit = _all.mul(1000000000000000000) / _allKeys;
991         rIDRound[_rID].mask = rIDRound[_rID].mask.add(_unit);
992         //calculate this round player can get
993         uint256 _share = (_unit.mul(_keys)) / (1000000000000000000);
994         pIDPlayerRound[_pID][_rID].mask = pIDPlayerRound[_pID][_rID].mask.add((rIDRound[_rID].mask.mul(_keys) / (1000000000000000000)).sub(_share));
995         return(_all.sub(_unit.mul(_allKeys) / (1000000000000000000)));
996     }
997 
998     function withdrawEarnings(uint256 _pID) private returns(uint256) {
999         updateVault(_pID);
1000         uint256 earnings = (pIDPlayer[_pID].win).add(pIDPlayer[_pID].gen).add(pIDPlayer[_pID].inv).add(pIDPlayer[_pID].tim).add(pIDPlayer[_pID].crd);
1001         if (earnings > 0) {
1002             pIDPlayer[_pID].win = 0;
1003             pIDPlayer[_pID].gen = 0;
1004             pIDPlayer[_pID].inv = 0;
1005             pIDPlayer[_pID].tim = 0;
1006             pIDPlayer[_pID].crd = 0;
1007         }
1008         return earnings;
1009     }
1010 
1011     function updateVault(uint256 _pID) private {
1012         uint256 _rID = pIDPlayer[_pID].lrnd;
1013         updateGenVault(_pID, _rID);
1014         updateInvVault(_pID, _rID);
1015         uint256 _team = calcTeamEarnings(_pID, _rID);
1016         //already calculate team reward,ended round key and mask dont needed
1017         if(rIDRound[_rID].ended == true) {
1018             pIDPlayerRound[_pID][_rID].team1Keys = 0;
1019             pIDPlayerRound[_pID][_rID].team2Keys = 0;
1020             pIDPlayerRound[_pID][_rID].mask = 0;
1021         }
1022         pIDPlayer[_pID].tim = pIDPlayer[_pID].tim.add(_team);
1023     }
1024 
1025     function updateGenVault(uint256 _pID, uint256 _rID) private {
1026         uint256 _earnings = calcUnMaskedEarnings(_pID, _rID);
1027         //put invitation reward to gen
1028         if (_earnings > 0) {
1029             // put in gen vault
1030             pIDPlayer[_pID].gen = _earnings.add(pIDPlayer[_pID].gen);
1031             // zero out their earnings by updating mask
1032             pIDPlayerRound[_pID][_rID].mask = _earnings.add(pIDPlayerRound[_pID][_rID].mask);
1033         }
1034 
1035     }
1036 
1037     function updateInvVault(uint256 _pID, uint256 _rID) private {
1038         uint256 _inv = pIDPlayerRound[_pID][_rID].inv;
1039         uint256 _invMask = pIDPlayerRound[_pID][_rID].invMask;
1040         if (_inv > 0) {
1041             pIDPlayer[_pID].inv = pIDPlayer[_pID].inv.add(_inv).sub0(_invMask);
1042             pIDPlayerRound[_pID][_rID].invMask = pIDPlayerRound[_pID][_rID].invMask.add(_inv).sub0(_invMask);
1043         }
1044     }
1045 
1046     //calculate valut not update
1047     function calcUnMaskedEarnings(uint256 _pID, uint256 _rID) private view
1048     returns (uint256)
1049     {
1050         uint256 _all = pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys;
1051         return ((rIDRound[_rID].mask.mul(_all)) / (1000000000000000000)).sub(pIDPlayerRound[_pID][_rID].mask);
1052     }
1053 
1054     function calcTeamEarnings(uint256 _pID, uint256 _rID) private view
1055     returns (uint256)
1056     {
1057         uint256 _key1 = pIDPlayerRound[_pID][_rID].team1Keys;
1058         uint256 _key2 = pIDPlayerRound[_pID][_rID].team2Keys;
1059         if (rIDRound[_rID].ended == false)
1060             return 0;
1061         else {
1062             if (rIDRound[_rID].team == 0)
1063                 return rIDRound[_rID].teamPot.mul(_key1 / rIDRound[_rID].team1Keys);
1064             else
1065                 return rIDRound[_rID].teamPot.mul(_key2 / rIDRound[_rID].team2Keys);
1066         }
1067     }
1068     //tested
1069     function updateTimer(uint256 _keys, uint256 _rID) private {
1070         // grab time
1071         uint256 _now = now;
1072         // calculate new time
1073         uint256 _newTime;
1074         if (_now > rIDRound[_rID].end && rIDRound[_rID].leadPID == 0)
1075             _newTime = (((_keys) / (1000000000000000000)).mul(rndPerKey)).add(_now);
1076         else
1077             _newTime = (((_keys) / (1000000000000000000)).mul(rndPerKey)).add(rIDRound[_rID].end);
1078 
1079         // compare to max and set new end time
1080         if (_newTime < (rndMax).add(_now))
1081             rIDRound[_rID].end = _newTime;
1082         else
1083             rIDRound[_rID].end = rndMax.add(_now);
1084     }
1085 
1086 
1087 }
1088 
1089 library NTA3DKeysCalc {
1090     using SafeMath for *;
1091     uint256 constant private keyPriceTrigger = 50000 * 1e18;
1092     uint256 constant private keyPriceFirst = 0.0005 ether;
1093     uint256 constant private keyPriceAdd = 0.0001 ether;
1094     /**
1095      * @dev calculates number of keys received given X eth
1096      * _curEth current amount of eth in contract
1097      * _newEth eth being spent
1098      * @return amount of ticket purchased
1099      */
1100     function keysRec(uint256 _curKeys, uint256 _allEth)
1101         internal
1102         pure
1103         returns (uint256)
1104     {
1105         return(keys(_curKeys, _allEth));
1106     }
1107 
1108     /**
1109      * @dev calculates amount of eth received if you sold X keys
1110      * @param _curKeys current amount of keys that exist
1111      * @param _sellKeys amount of keys you wish to sell
1112      * @return amount of eth received
1113      */
1114     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1115         internal
1116         pure
1117         returns (uint256)
1118     {
1119         return(eth(_sellKeys.add(_curKeys)).sub(eth(_curKeys)));
1120     }
1121 
1122     /**
1123      * @dev calculates how many keys would exist with given an amount of eth
1124      * @param _eth eth "in contract"
1125      * @return number of keys that would exist
1126      */
1127     function keys(uint256 _keys, uint256 _eth)
1128         internal
1129         pure
1130         returns(uint256)
1131     {
1132         uint256 _times = _keys / keyPriceTrigger;
1133         uint i = 0;
1134         uint256 eth1;
1135         uint256 eth2;
1136         uint256 price;
1137         uint256 key2;
1138         for(i = _times;i < i + 200; i++) {
1139             if(eth(keyPriceTrigger * (i + 1)) >=  _eth) {
1140                 if(i == 0) eth1 = 0;
1141                 else eth1 = eth(keyPriceTrigger * i);
1142                 eth2 = _eth.sub(eth1);
1143                 price = i.mul(keyPriceAdd).add(keyPriceFirst);
1144                 key2 = (eth2 / price).mul(1e18);
1145                 return ((keyPriceTrigger * i + key2).sub0(_keys));
1146                 break;
1147             }
1148         }
1149         //too large 
1150         require(false, "too large eth in");
1151 
1152     }
1153 
1154     /**
1155      * @dev calculates how much eth would be in contract given a number of keys
1156      * @param _keys number of keys "in contract"
1157      * @return eth that would exists
1158      */
1159      //tested
1160     function eth(uint256 _keys)
1161         internal
1162         pure
1163         returns(uint256)
1164     {
1165         uint256 _times = _keys / keyPriceTrigger;//keyPriceTrigger;
1166         uint256 _remain = _keys % keyPriceTrigger;//keyPriceTrigger;
1167         uint256 _price = _times.mul(keyPriceAdd).add(keyPriceFirst);
1168         if (_times == 0) {
1169             return (keyPriceFirst.mul(_keys / 1e18));
1170         } else {
1171             uint256 _up = (_price.sub(keyPriceFirst)).mul(_remain / 1e18);
1172             uint256 _down = (_keys / 1e18).mul(keyPriceFirst);
1173             uint256 _add = (_times.mul(_times).sub(_times) / 2).mul(keyPriceAdd).mul(keyPriceTrigger / 1e18);
1174             return (_up + _down + _add);
1175         }
1176     }
1177 }
1178 
1179 library NTAdatasets {
1180 
1181     struct Player {
1182         address addr;   // player address
1183         bytes32 name;   // player name
1184         uint256 win;    // winnings vault
1185         uint256 gen;    // general vault
1186         uint256 inv;    // inviter vault
1187         uint256 tim;     //team pot
1188         uint256 crd;     //crd pot
1189         uint256 lrnd;   // last round played
1190         uint256 inviter1; // direct inviter
1191         uint256 inviter2; // second hand inviter
1192         uint256 vip; //0 no vip; 1 and 2
1193     }
1194 
1195     struct PlayerRound {
1196         uint256 eth;    // eth player has added to round (used for eth limiter)
1197         uint256 team1Keys;
1198         uint256 team2Keys;
1199         uint256 inv;
1200         uint256 mask;
1201         uint256 invMask;
1202         uint256 score;
1203     }
1204 
1205     struct Round {
1206         uint256 leadPID;   // pID of player in lead
1207         uint256 end;    // time ends/ended
1208         bool ended;     // has round end function been ran
1209         uint256 strt;   // time round started
1210         uint256 team1Keys;   // keys
1211         uint256 team2Keys;   // keys
1212         uint256 eth;    // total eth in
1213         uint256 pot;    // eth win pot
1214         uint256 team;
1215         uint256 teamPot;
1216         uint256 smallDrop;//50Eth airdrop
1217         uint256 bigDrop; //300000 eth airdrop
1218         uint256 playerPot;
1219         uint256 mask;
1220         uint256[3] invTop3;
1221         uint256[3] keyTop3;
1222     }
1223 
1224     struct Card {
1225         uint256 owner;  //pID of card owner
1226         address addr;
1227         uint256 buyTime; //validity time check
1228         uint256 earnings;
1229     }
1230 
1231     struct Deposit {
1232         uint256 allPlayer;  // all player this rounds by key
1233         uint256 pot;        // last winner pot
1234         uint256 devfunds;   // game development Pot
1235         uint256 teamFee;    // team fee
1236         uint256 cards;      // stock right cards
1237         uint256 inviter;
1238         uint256 bigDrop;
1239         uint256 smallDrop;
1240     }
1241 
1242     struct PotSplit {
1243         uint256 allPlayer;  // all player this rounds by key
1244         uint256 lastWinner; // final player
1245         uint256 inviter1st; // player who get 1st of invatation
1246         uint256 inviter2nd;
1247         uint256 inviter3rd;
1248         uint256 key1st;     // player who get 1st key amount
1249         uint256 key2nd;
1250         uint256 key3rd;
1251         uint256 next;        // next round
1252     }
1253 }
1254 
1255 library NameFilter {
1256     /**
1257      * @dev filters name strings
1258      * -converts uppercase to lower case.
1259      * -makes sure it does not start/end with a space
1260      * -makes sure it does not contain multiple spaces in a row
1261      * -cannot be only numbers
1262      * -cannot start with 0x
1263      * -restricts characters to A-Z, a-z, 0-9, and space.
1264      * @return reprocessed string in bytes32 format
1265      */
1266     function nameFilter(string _input)
1267         internal
1268         pure
1269         returns(bytes32)
1270     {
1271         bytes memory _temp = bytes(_input);
1272         uint256 _length = _temp.length;
1273 
1274         //sorry limited to 32 characters
1275         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1276         // make sure it doesnt start with or end with space
1277         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1278         // make sure first two characters are not 0x
1279         if (_temp[0] == 0x30)
1280         {
1281             require(_temp[1] != 0x78, "string cannot start with 0x");
1282             require(_temp[1] != 0x58, "string cannot start with 0X");
1283         }
1284 
1285         // create a bool to track if we have a non number character
1286         bool _hasNonNumber;
1287 
1288         // convert & check
1289         for (uint256 i = 0; i < _length; i++)
1290         {
1291             // if its uppercase A-Z
1292             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1293             {
1294                 // convert to lower case a-z
1295                 _temp[i] = byte(uint(_temp[i]) + 32);
1296 
1297                 // we have a non number
1298                 if (_hasNonNumber == false)
1299                     _hasNonNumber = true;
1300             } else {
1301                 require
1302                 (
1303                     // require character is a space
1304                     _temp[i] == 0x20 ||
1305                     // OR lowercase a-z
1306                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1307                     // or 0-9
1308                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1309                     "string contains invalid characters"
1310                 );
1311                 // make sure theres not 2x spaces in a row
1312                 if (_temp[i] == 0x20)
1313                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1314 
1315                 // see if we have a character other than a number
1316                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1317                     _hasNonNumber = true;
1318             }
1319         }
1320 
1321         require(_hasNonNumber == true, "string cannot be only numbers");
1322 
1323         bytes32 _ret;
1324         assembly {
1325             _ret := mload(add(_temp, 32))
1326         }
1327         return (_ret);
1328     }
1329 }
1330 
1331 /**
1332  * @title SafeMath v0.1.9
1333  * @dev Math operations with safety checks that throw on error
1334  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1335  * - added sqrt
1336  * - added sq
1337  * - added pwr
1338  * - changed asserts to requires with error log outputs
1339  * - removed div, its useless
1340  */
1341 library SafeMath {
1342 
1343     /**
1344     * @dev Multiplies two numbers, throws on overflow.
1345     */
1346     function mul(uint256 a, uint256 b)
1347         internal
1348         pure
1349         returns (uint256 c)
1350     {
1351         if (a == 0) {
1352             return 0;
1353         }
1354         c = a * b;
1355         require(c / a == b, "SafeMath mul failed");
1356         return c;
1357     }
1358 
1359     /**
1360     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1361     */
1362     function sub(uint256 a, uint256 b)
1363         internal
1364         pure
1365         returns (uint256)
1366     {
1367         require(b <= a, "SafeMath sub failed");
1368         return a - b;
1369     }
1370 
1371     /**
1372     * @dev Subtracts two numbers, no throw
1373     */
1374     function sub0(uint256 a, uint256 b)
1375         internal
1376         pure
1377         returns (uint256)
1378     {
1379         if (a < b) {
1380             return 0;
1381         } else {
1382             return a - b;
1383         }
1384     }
1385 
1386     /**
1387     * @dev Adds two numbers, throws on overflow.
1388     */
1389     function add(uint256 a, uint256 b)
1390         internal
1391         pure
1392         returns (uint256 c)
1393     {
1394         c = a + b;
1395         require(c >= a, "SafeMath add failed");
1396         return c;
1397     }
1398 
1399     /**
1400      * @dev gives square root of given x.
1401      */
1402     function sqrt(uint256 x)
1403         internal
1404         pure
1405         returns (uint256 y)
1406     {
1407         uint256 z = ((add(x,1)) / 2);
1408         y = x;
1409         while (z < y)
1410         {
1411             y = z;
1412             z = ((add((x / z),z)) / 2);
1413         }
1414     }
1415 
1416     /**
1417      * @dev gives square. multiplies x by x
1418      */
1419     function sq(uint256 x)
1420         internal
1421         pure
1422         returns (uint256)
1423     {
1424         return (mul(x,x));
1425     }
1426 
1427     /**
1428      * @dev x to the power of y
1429      */
1430     function pwr(uint256 x, uint256 y)
1431         internal
1432         pure
1433         returns (uint256)
1434     {
1435         if (x==0)
1436             return (0);
1437         else if (y==0)
1438             return (1);
1439         else
1440         {
1441             uint256 z = x;
1442             for (uint256 i=1; i < y; i++)
1443                 z = mul(z,x);
1444             return (z);
1445         }
1446     }
1447 }