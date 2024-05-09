1 pragma solidity ^0.4.25;
2 
3 contract NTA3DEvents {
4 
5     event onWithdraw
6     (
7         uint256 indexed playerID,
8         address playerAddress,
9         bytes32 playerName,
10         uint256 ethOut,
11         uint256 timeStamp
12     );
13 
14     event onBuyKey
15     (
16         uint256 indexed playerID,
17         address indexed playerAddress,
18         bytes32 indexed playerName,
19         uint256 roundID,
20         uint256 ethIn,
21         uint256 keys,
22         uint256 timeStamp
23     );
24 
25     event onBuyCard
26     (
27         uint256 indexed playerID,
28         address indexed playerAddress,
29         bytes32 indexed playerName,
30         uint256 cardID,
31         uint256 ethIn,
32         uint256 timeStamp
33     );
34 
35     event onRoundEnd
36     (
37         address winnerAddr,
38         bytes32 winnerName,
39         uint256 roundID,
40         uint256 amountWon,
41         uint256 newPot,
42         uint256 timeStamp
43     );
44 
45     event onDrop
46     (
47         address dropwinner,
48         bytes32 winnerName,
49         uint256 roundID,
50         uint256 droptype, //0:smalldrop 1:bigdop
51         uint256 win,
52         uint256 timeStamp
53     );
54 
55 }
56 
57 contract NTA3D is NTA3DEvents {
58     using SafeMath for *;
59     using NameFilter for string;
60     using NTA3DKeysCalc for uint256;
61 
62     string constant public name = "No Tricks Allow 3D";
63     string constant public symbol = "NTA3D";
64     bool activated_;
65     address admin;
66     uint256 constant private rndStarts = 12 hours; // ??need to be continue
67     uint256 constant private rndPerKey = 15 seconds; // every key increase seconds
68     uint256 constant private rndMax = 12 hours;  //max count down time;
69     uint256 constant private cardValidity = 1 hours; //stock cards validity
70     uint256 constant private cardPrice = 0.05 ether; //stock cards validity
71     uint256 constant private DIVIDE = 1000; // common divide tool
72 
73     uint256 constant private smallDropTrigger = 50 ether;
74     uint256 constant private bigDropTrigger = 300000 * 1e18;
75     uint256 constant private keyPriceTrigger = 50000 * 1e18;
76     uint256 constant private keyPriceFirst = 0.0005 ether;
77     uint256 constant private oneOffInvest1 = 0.1 ether;//VIP 1
78     uint256 constant private oneOffInvest2 = 1 ether;// VIP 2
79 
80     //uint256 public airDropTracker_ = 0;
81     uint256 public rID;    // round id number / total rounds that have happened
82     uint256 public pID;    // total players
83 
84     //player map data
85     mapping (address => uint256) public pIDxAddr; // get pid by address
86     mapping (bytes32 => uint256) public pIDxName; // get name by pid
87     mapping (uint256 => NTAdatasets.Player) public pIDPlayer; // get player struct by pid\
88     mapping (uint256 => mapping (uint256 => NTAdatasets.PlayerRound)) public pIDPlayerRound; // pid => rid => playeround
89 
90     //stock cards
91     mapping (uint256 => NTAdatasets.Card) cIDCard; //get card by cID
92     address cardSeller;
93 
94     //team map data
95     //address gameFundsAddr = 0xFD7A82437F7134a34654D7Cb8F79985Df72D7076;
96     address[11] partner;
97     address to06;
98     address to04;
99     address to20A;
100     address to20B;
101     mapping (address => uint256) private gameFunds; // game develeopment get 5% funds
102     //uint256 private teamFee;    // team Fee 5%
103 
104     //round data
105     mapping (uint256 => NTAdatasets.Round) public rIDRound;   // round data
106 
107     // team dividens
108     mapping (uint256 => NTAdatasets.Deposit) public deposit;
109     mapping (uint256 => NTAdatasets.PotSplit) public potSplit;
110 
111     constructor() public {
112 
113         //constructor
114         activated_ = false;
115         admin = msg.sender;
116         // Team allocation structures
117         // 0 = BISHOP
118         // 1 = ROOK
119                 // BISHOP team: ==> |46% to all, 17% to winnerPot, 5% to develop funds, 5% to teamfee, 10% to cards,
120         //                  |7% to fisrt degree invatation
121         //                  |3% to second degree invatation, 2% to big airdrop, 5% to small airdrop
122         deposit[0] = NTAdatasets.Deposit(460, 170, 50, 50, 100, 100, 20, 50);
123         // ROOK team:   ==> |20% to all, 43% to winnerPot, 5% to develop funds, 5% to teamfee, 10% to cards,
124         //                  |7% to fisrt degree invatation
125         //                  |3% to second degree invatation, 2% to big airdrop, 5% to small airdrop
126         deposit[1] = NTAdatasets.Deposit(200, 430, 50, 50, 100, 100, 20, 50);
127 
128         // potSplit:    ==> |20% to all, 45% to lastwinner, 5% to inviter 1st, 3% to inviter 2nd, 2% to inviter 3rd,
129         //                  |8% to key buyer 1st, 5% to key buyer 2nd, 2% to key buyer 3rd, 10% to next round
130         potSplit[0] = NTAdatasets.PotSplit(200, 450, 50, 30, 20, 80, 50, 20, 100);
131         potSplit[1] = NTAdatasets.PotSplit(200, 450, 50, 30, 20, 80, 50, 20, 100);
132     }
133 
134 //==============================================================================
135 //
136 //    safety checks
137 //==============================================================================
138     //tested
139     modifier isActivated() {
140         require(activated_ == true, "its not ready yet");
141         _;
142     }
143 
144     /**
145      * @dev prevents contracts from interacting with fomo3d
146      */
147     //tested
148     modifier isHuman() {
149         address _addr = msg.sender;
150         uint256 _codeLength;
151 
152         assembly {_codeLength := extcodesize(_addr)}
153         require(_codeLength == 0, "sorry humans only");
154         _;
155     }
156     //tested
157     modifier isAdmin() {require(msg.sender == admin, "its can only be call by admin");_;}
158 
159     /**
160      * @dev sets boundaries for incoming tx
161      */
162     //tested
163     modifier isWithinLimits(uint256 _eth) {
164         require(_eth >= 1000000000, "pocket lint: not a valid currency");
165         require(_eth <= 100000000000000000000000, "no vitalik, no");
166         _;
167     }
168 
169 //==============================================================================
170 //
171 //    admin functions
172 //==============================================================================
173     //tested
174     function activeNTA() isAdmin() public {
175         activated_ = true;
176         partner[0] = 0xE27Aa5E7D8906779586CfB9DbA2935BDdd7c8210;
177         partner[1] = 0xD4638827Dc486cb59B5E5e47955059A160BaAE13;
178         partner[2] = 0xa088c667591e04cC78D6dfA3A392A132dc5A7f9d;
179         partner[3] = 0xed38deE26c751ff575d68D9Bf93C312e763f8F87;
180         partner[4] = 0x42A7B62f71b7778279DA2639ceb5DD6ee884f905;
181         partner[5] = 0xd471409F3eFE9Ca24b63855005B08D4548742a5b;
182         partner[6] = 0x41c9F005eD19C2B620152f5562D26029b32078B6;
183         partner[7] = 0x11b85bc860A6C38fa7fe6f54f18d350eF5f2787b;
184         partner[8] = 0x11a7c5E7887F2C34356925275882D4321a6B69A8;
185         partner[9] = 0xB5754c7bD005b6F25e1FDAA5f94b2b71e6eA260f;
186         partner[10] = 0x6fbC15cF6d0B05280E99f753E45B631815715E99;
187         to06 = 0x9B53CC857cD9DD5EbE6bc07Bde67D8CE4076345f;
188         to04 = 0x5835a72118c0C784203B8d39936A0875497B6eCa;
189         to20A = 0xEc2441D3113fC2376cd127344331c0F1b959Ce1C;
190         to20B = 0xd1Dac908c97c0a885e9B413a84ACcC0010C002d2;
191         //card
192         cardSeller = 0xeE4f032bdB0f9B51D6c7035d3DEFfc217D91225C;
193     }
194     //tested
195     function startFirstRound() isAdmin() isActivated() public {
196         //must not open before
197         require(rID == 0);
198         newRound(0);
199     }
200 
201     function teamWithdraw() public
202     isHuman()
203     isActivated()
204     {
205         uint256 _temp;
206         address to = msg.sender;
207         require(gameFunds[to] != 0, "you dont have funds");
208         _temp = gameFunds[to];
209         gameFunds[to] = 0;
210         to.transfer(_temp);
211     }
212 
213     function getTeamFee(address _addr)
214     public
215     view
216     returns(uint256) {
217         return gameFunds[_addr];
218     }
219 
220     function getScore(address _addr)
221     public
222     view
223     isAdmin()
224     returns(uint256) {
225         uint256 _pID = pIDxAddr[_addr];
226         if(_pID == 0 ) return 0;
227         else return pIDPlayerRound[_pID][rID].score;
228     }
229 
230     function setInviterCode(address _addr, uint256 _inv, uint256 _vip, string _nameString)
231     public
232     isAdmin() {
233         //this is for popularzing channel
234         bytes32 _name = _nameString.nameFilter();
235         uint256 temp = pIDxName[_name];
236         require(temp == 0, "name already regist");
237         uint256 _pID = pIDxAddr[_addr];
238         if(_pID == 0) {
239             pID++;
240             _pID = pID;
241             pIDxAddr[_addr] = _pID;
242             pIDPlayer[_pID].addr = _addr;
243             pIDPlayer[_pID].name = _name;
244             pIDxName[_name] = _pID;
245             pIDPlayer[_pID].inviter1 = _inv;
246             pIDPlayer[_pID].vip = _vip;
247         } else {
248             if(_inv != 0)
249                 pIDPlayer[_pID].inviter1 = _inv;
250             pIDPlayer[_pID].name = _name;
251             pIDxName[_name] = _pID;
252             pIDPlayer[_pID].vip = _vip;
253         }
254     }
255 
256 //==============================================================================
257 //
258 //    player functions
259 //==============================================================================
260     //emergency buy uses BISHOP team to buy keys
261     function()
262     isActivated()
263     isHuman()
264     isWithinLimits(msg.value)
265     public
266     payable
267     {
268         //fetch player
269         require(rID != 0, "No round existed yet");
270         uint256 _pID = managePID(0);
271         //buy key
272         buyCore(_pID, 0);
273     }
274 
275     // buy with ID: inviter use pID to invate player to buy like "www.NTA3D.io/?id=101"
276     function buyXid(uint256 _team,uint256 _inviter)
277     isActivated()
278     isHuman()
279     isWithinLimits(msg.value)
280     public
281     payable
282     {
283         require(rID != 0, "No round existed yet");
284         uint256 _pID = managePID(_inviter);
285         if (_team < 0 || _team > 1 ) {
286             _team = 0;
287         }
288         buyCore(_pID, _team);
289     }
290 
291     // buy with ID: inviter use pID to invate player to buy like "www.NTA3D.io/?n=obama"
292     function buyXname(uint256 _team,string _invName)
293     isActivated()
294     isHuman()
295     isWithinLimits(msg.value)
296     public
297     payable
298     {
299         require(rID != 0, "No round existed yet");
300         bytes32 _name = _invName.nameFilter();
301         uint256 _invPID = pIDxName[_name];
302         uint256 _pID = managePID(_invPID);
303         if (_team < 0 || _team > 1 ) {
304             _team = 0;
305         }
306         buyCore(_pID, _team);
307     }
308 
309     function buyCardXname(uint256 _cID, string _invName)
310     isActivated()
311     isHuman()
312     isWithinLimits(msg.value)
313     public
314     payable {
315         uint256 _value = msg.value;
316         uint256 _now = now;
317         require(_cID < 20, "only has 20 cards");
318         require(_value == cardPrice, "the card cost 0.05 ether");
319         require(cIDCard[_cID].owner == 0 || (cIDCard[_cID].buyTime + cardValidity) < _now, "card is in used");
320         bytes32 _name = _invName.nameFilter();
321         uint256 _invPID = pIDxName[_name];
322         uint256 _pID = managePID(_invPID);
323         for (uint i = 0; i < 20; i++) {
324             require(_pID != cIDCard[i].owner, "you already registed a card");
325         }
326         gameFunds[cardSeller] = gameFunds[cardSeller].add(_value);
327         cIDCard[_cID].addr = msg.sender;
328         cIDCard[_cID].owner = _pID;
329         cIDCard[_cID].buyTime = _now;
330         cIDCard[_cID].earnings = 0;
331         emit onBuyCard(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _cID, _value, now);
332     }
333 
334     function buyCardXid(uint256 _cID, uint256 _inviter)
335     isActivated()
336     isHuman()
337     isWithinLimits(msg.value)
338     public
339     payable {
340         uint256 _value = msg.value;
341         uint256 _now = now;
342         require(_cID < 20, "only has 20 cards");
343         require(_value == cardPrice, "the card cost 0.05 ether");
344         require(cIDCard[_cID].owner == 0 || (cIDCard[_cID].buyTime + cardValidity) < _now, "card is in used");
345         uint256 _pID = managePID(_inviter);
346         for (uint i = 0; i < 20; i++) {
347             require(_pID != cIDCard[i].owner, "you already registed a card");
348         }
349         gameFunds[cardSeller] = gameFunds[cardSeller].add(_value);
350         cIDCard[_cID].addr = msg.sender;
351         cIDCard[_cID].owner = _pID;
352         cIDCard[_cID].buyTime = _now;
353         cIDCard[_cID].earnings = 0;
354         emit onBuyCard(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _cID, _value, now);
355     }
356 
357 
358     // regist a name
359     function registNameXid(string _nameString, uint256 _inviter)
360     isActivated()
361     isHuman()
362     public {
363         bytes32 _name = _nameString.nameFilter();
364         uint256 temp = pIDxName[_name];
365         require(temp == 0, "name already regist");
366         uint256 _pID = managePID(_inviter);
367         pIDxName[_name] = _pID;
368         pIDPlayer[_pID].name = _name;
369     }
370 
371     function registNameXname(string _nameString, string _inviterName)
372     isActivated()
373     isHuman()
374     public {
375         bytes32 _name = _nameString.nameFilter();
376         uint256 temp = pIDxName[_name];
377         require(temp == 0, "name already regist");
378         bytes32 _invName = _inviterName.nameFilter();
379         uint256 _invPID = pIDxName[_invName];
380         uint256 _pID = managePID(_invPID);
381         pIDxName[_name] = _pID;
382         pIDPlayer[_pID].name = _name;
383     }
384 
385     function withdraw()
386     isActivated()
387     isHuman()
388     public {
389         // setup local rID
390         uint256 _rID = rID;
391         // grab time
392         uint256 _now = now;
393         uint256 _pID = pIDxAddr[msg.sender];
394         require(_pID != 0, "cant find user");
395         uint256 _eth = 0;
396         if (rIDRound[_rID].end < _now && rIDRound[_rID].ended == false) {
397             rIDRound[_rID].ended = true;
398             endRound();
399         }
400         // get their earnings
401         _eth = withdrawEarnings(_pID);
402         // gib moni
403         if (_eth > 0)
404             pIDPlayer[_pID].addr.transfer(_eth);
405         //emit
406         emit onWithdraw(_pID, pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _eth, now);
407     }
408 //==============================================================================
409 //
410 //    view functions
411 //==============================================================================
412     /**
413      * return the price buyer will pay for next 1 individual key.
414      * @return price for next key bought (in wei format)
415      */
416      //tested
417     function getBuyPrice(uint256 _key)
418     public
419     view
420     returns(uint256) {
421         // setup local rID
422         uint256 _rID = rID;
423         // grab time
424         uint256 _now = now;
425         uint256 _keys = rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys;
426         // round is active
427         if (rIDRound[_rID].end >= _now || (rIDRound[_rID].end < _now && rIDRound[_rID].leadPID == 0))
428             return _keys.ethRec(_key * 1e18);
429         else
430             return keyPriceFirst;
431     }
432 
433     /**
434      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
435      * @return time left in seconds
436      */
437      //tested
438     function getTimeLeft()
439     public
440     view
441     returns(uint256) {
442         // setup local rID
443         uint256 _rID = rID;
444         // grab time
445         uint256 _now = now;
446 
447         if (rIDRound[_rID].end >= _now)
448             return (rIDRound[_rID].end.sub(_now));
449         else
450             return 0;
451     }
452 
453     //tested
454     function getPlayerVaults()
455     public
456     view
457     returns(uint256, uint256, uint256, uint256, uint256) {
458         // setup local rID
459         uint256 _rID = rID;
460         uint256 _now = now;
461         uint256 _pID = pIDxAddr[msg.sender];
462         if (_pID == 0)
463             return (0, 0, 0, 0, 0);
464         uint256 _last = pIDPlayer[_pID].lrnd;
465         uint256 _inv = pIDPlayerRound[_pID][_last].inv;
466         uint256 _invMask = pIDPlayerRound[_pID][_last].invMask;
467         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
468         if (rIDRound[_rID].end < _now && rIDRound[_rID].ended == false && rIDRound[_rID].leadPID != 0) {
469             // if player is winner
470             if (rIDRound[_rID].leadPID == _pID)
471                 return (
472                     (pIDPlayer[_pID].win).add((rIDRound[_rID].pot).mul(45) / 100),
473                     pIDPlayer[_pID].gen.add(calcUnMaskedEarnings(_pID, pIDPlayer[_pID].lrnd)),
474                     pIDPlayer[_pID].inv.add(_inv).sub0(_invMask),
475                     pIDPlayer[_pID].tim.add(calcTeamEarnings(_pID, pIDPlayer[_pID].lrnd)),
476                     pIDPlayer[_pID].crd
477                 );
478             else
479                 return (
480                     pIDPlayer[_pID].win,
481                     pIDPlayer[_pID].gen.add(calcUnMaskedEarnings(_pID, pIDPlayer[_pID].lrnd)),
482                     pIDPlayer[_pID].inv.add(_inv).sub0(_invMask),
483                     pIDPlayer[_pID].tim.add(calcTeamEarnings(_pID, pIDPlayer[_pID].lrnd)),
484                     pIDPlayer[_pID].crd
485                 );
486         } else {
487              return (
488                     pIDPlayer[_pID].win,
489                     pIDPlayer[_pID].gen.add(calcUnMaskedEarnings(_pID, pIDPlayer[_pID].lrnd)),
490                     pIDPlayer[_pID].inv.add(_inv).sub0(_invMask),
491                     pIDPlayer[_pID].tim.add(calcTeamEarnings(_pID, pIDPlayer[_pID].lrnd)),
492                     pIDPlayer[_pID].crd
493                 );
494         }
495     }
496 
497     function getCurrentRoundInfo()
498     public
499     view
500     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256) {
501         // setup local rID
502         uint256 _rID = rID;
503         return(_rID,
504             rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys,    //total key
505             rIDRound[_rID].eth,      //total eth
506             rIDRound[_rID].strt,     //start time
507             rIDRound[_rID].end,      //end time
508             rIDRound[_rID].pot,      //last winer pot
509             rIDRound[_rID].leadPID,  //current last player
510             pIDPlayer[rIDRound[_rID].leadPID].addr, //cureest last player address
511             pIDPlayer[rIDRound[_rID].leadPID].name, //cureest last player name
512             rIDRound[_rID].smallDrop,
513             rIDRound[_rID].bigDrop,
514             rIDRound[_rID].teamPot   //teampot
515             );
516     }
517 
518     function getRankList()
519     public
520     view
521             //invitetop3   amout      keyTop3      key
522     returns (address[3], uint256[3], bytes32[3], address[3], uint256[3], bytes32[3]) {
523         uint256 _rID = rID;
524         address[3] memory inv;
525         address[3] memory key;
526         bytes32[3] memory invname;
527         uint256[3] memory invRef;
528         uint256[3] memory keyamt;
529         bytes32[3] memory keyname;
530         inv[0] = pIDPlayer[rIDRound[_rID].invTop3[0]].addr;
531         inv[1] = pIDPlayer[rIDRound[_rID].invTop3[1]].addr;
532         inv[2] = pIDPlayer[rIDRound[_rID].invTop3[2]].addr;
533         invRef[0] = pIDPlayerRound[rIDRound[_rID].invTop3[0]][_rID].inv;
534         invRef[1] = pIDPlayerRound[rIDRound[_rID].invTop3[1]][_rID].inv;
535         invRef[2] = pIDPlayerRound[rIDRound[_rID].invTop3[2]][_rID].inv;
536         invname[0] = pIDPlayer[rIDRound[_rID].invTop3[0]].name;
537         invname[1] = pIDPlayer[rIDRound[_rID].invTop3[1]].name;
538         invname[2] = pIDPlayer[rIDRound[_rID].invTop3[2]].name;
539 
540         key[0] = pIDPlayer[rIDRound[_rID].keyTop3[0]].addr;
541         key[1] = pIDPlayer[rIDRound[_rID].keyTop3[1]].addr;
542         key[2] = pIDPlayer[rIDRound[_rID].keyTop3[2]].addr;
543         keyamt[0] = pIDPlayerRound[rIDRound[_rID].keyTop3[0]][_rID].team1Keys + pIDPlayerRound[rIDRound[_rID].keyTop3[0]][_rID].team2Keys;
544         keyamt[1] = pIDPlayerRound[rIDRound[_rID].keyTop3[1]][_rID].team1Keys + pIDPlayerRound[rIDRound[_rID].keyTop3[1]][_rID].team2Keys;
545         keyamt[2] = pIDPlayerRound[rIDRound[_rID].keyTop3[2]][_rID].team1Keys + pIDPlayerRound[rIDRound[_rID].keyTop3[2]][_rID].team2Keys;
546         keyname[0] = pIDPlayer[rIDRound[_rID].keyTop3[0]].name;
547         keyname[1] = pIDPlayer[rIDRound[_rID].keyTop3[1]].name;
548         keyname[2] = pIDPlayer[rIDRound[_rID].keyTop3[2]].name;
549 
550         return (inv, invRef, invname, key, keyamt, keyname);
551     }
552 
553     /**
554      * @dev returns player info based on address.  if no address is given, it will
555      * use msg.sender
556      * -functionhash- 0xee0b5d8b
557      * @param _addr address of the player you want to lookup
558      * @return player ID
559      * @return player name
560      * @return keys owned (current round)
561      * @return winnings vault
562      * @return general vault
563      * @return affiliate vault
564 	 * @return player round eth
565      */
566     //tested
567     function getPlayerInfoByAddress(address _addr)
568         public
569         view
570         returns(uint256, bytes32, uint256, uint256, uint256)
571     {
572         // setup local rID
573         uint256 _rID = rID;
574 
575         if (_addr == address(0))
576         {
577             _addr == msg.sender;
578         }
579         uint256 _pID = pIDxAddr[_addr];
580         if (_pID == 0)
581             return (0, 0x0, 0, 0, 0);
582         else
583             return
584             (
585             _pID,                               //0
586             pIDPlayer[_pID].name,                   //1
587             pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys,
588             pIDPlayerRound[_pID][_rID].eth,           //6
589             pIDPlayer[_pID].vip
590             );
591     }
592 
593     function getCards(uint256 _id)
594     public
595     view
596     returns(uint256, address, bytes32, uint256, uint256) {
597         bytes32 _name = pIDPlayer[cIDCard[_id].owner].name;
598         return (
599             cIDCard[_id].owner,
600             cIDCard[_id].addr,
601             _name,
602             cIDCard[_id].buyTime,
603             cIDCard[_id].earnings
604         );
605     }
606 //==============================================================================
607 //
608 //    private functions
609 //==============================================================================
610 
611     //tested
612     function managePID(uint256 _inviter) private returns(uint256) {
613         uint256 _pID = pIDxAddr[msg.sender];
614         if (_pID == 0) {
615             pID++;
616             pIDxAddr[msg.sender] = pID;
617             pIDPlayer[pID].addr = msg.sender;
618             pIDPlayer[pID].name = 0x0;
619             _pID = pID;
620         }
621             // handle direct and second hand inviter
622         if (pIDPlayer[_pID].inviter1 == 0 && pIDPlayer[_inviter].addr != address(0) && _pID != _inviter) {
623             pIDPlayer[_pID].inviter1 = _inviter;
624             uint256 _in = pIDPlayer[_inviter].inviter1;
625             if (_in != 0) {
626                     pIDPlayer[_pID].inviter2 = _in;
627                 }
628             }
629         // oneoff invite get invitation link
630         if (msg.value >= oneOffInvest2) {
631             pIDPlayer[_pID].vip = 2;
632         } else if (msg.value >= oneOffInvest1) {
633             if (pIDPlayer[_pID].vip != 2)
634                 pIDPlayer[_pID].vip = 1;
635         }
636         return _pID;
637     }
638 
639     function buyCore(uint256 _pID, uint256 _team) private {
640         // setup local rID
641         uint256 _rID = rID;
642         // grab time
643         uint256 _now = now;
644 
645         //update last round;
646         if (pIDPlayer[_pID].lrnd != _rID)
647             updateVault(_pID);
648         pIDPlayer[_pID].lrnd = _rID;
649         uint256 _inv1 = pIDPlayer[_pID].inviter1;
650         uint256 _inv2 = pIDPlayer[_pID].inviter2;
651 
652         // round is active
653         if (rIDRound[_rID].end >= _now || (rIDRound[_rID].end < _now && rIDRound[_rID].leadPID == 0)) {
654             core(_rID, _pID, msg.value, _team);
655             if (_inv1 != 0)
656                 doRankInv(_rID, _inv1, rIDRound[_rID].invTop3, pIDPlayerRound[_inv1][_rID].inv);
657             if (_inv2 != 0)
658                 doRankInv(_rID, _inv2, rIDRound[_rID].invTop3, pIDPlayerRound[_inv2][_rID].inv);
659             doRankKey(_rID, _pID, rIDRound[_rID].keyTop3, pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys);
660             emit onBuyKey(
661                 _pID,
662                 pIDPlayer[_pID].addr,
663                 pIDPlayer[_pID].name, _rID,
664                 msg.value,
665                 pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys,
666                 now);
667         } else {
668             if (rIDRound[_rID].end < _now && rIDRound[_rID].ended == false) {
669                 rIDRound[_rID].ended = true;
670                 endRound();
671                 //if you trigger the endround. whatever how much you pay ,you will fail to buykey
672                 //and the eth will return to your gen.
673                 pIDPlayer[_pID].gen = pIDPlayer[_pID].gen.add(msg.value);
674             }
675         }
676     }
677 
678     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team) private {
679 
680         NTAdatasets.Round storage _roundID = rIDRound[_rID];
681         NTAdatasets.Deposit storage _deposit = deposit[_team];
682         //NTAdatasets.PlayerRound storage _playerRound = pIDPlayerRound[_pID][_rID];
683         // calculate how many keys they can get
684         uint256 _keysAll = _roundID.team1Keys + _roundID.team2Keys;//(rIDRound[_rID].eth).keysRec(_eth);
685         uint256 _keys = _keysAll.keysRec(rIDRound[_rID].eth + _eth);
686         if (_keys >= 1000000000000000000) {
687             updateTimer(_keys, _rID);
688         }
689 
690         uint256 _left = _eth;
691         //2% to bigDrop
692         uint256 _temp = _eth.mul(_deposit.bigDrop) / DIVIDE;
693         doBigDrop(_rID, _pID, _keys, _temp);
694         _left = _left.sub0(_temp);
695 
696         //5% to smallDrop
697         _temp = _eth.mul(_deposit.smallDrop) / DIVIDE;
698         doSmallDrop(_rID, _pID, _eth, _temp);
699         _left = _left.sub0(_temp);
700 
701         _roundID.eth = _roundID.eth.add(_eth);
702         pIDPlayerRound[_pID][_rID].eth = pIDPlayerRound[_pID][_rID].eth.add(_eth);
703         if (_team == 0) {
704             _roundID.team1Keys = _roundID.team1Keys.add(_keys);
705             pIDPlayerRound[_pID][_rID].team1Keys = pIDPlayerRound[_pID][_rID].team1Keys.add(_keys);
706         } else {
707             _roundID.team2Keys = _roundID.team2Keys.add(_keys);
708             pIDPlayerRound[_pID][_rID].team2Keys = pIDPlayerRound[_pID][_rID].team2Keys.add(_keys);
709         }
710 
711 
712         //X% to all
713         uint256 _all = _eth.mul(_deposit.allPlayer) / DIVIDE;
714         _roundID.playerPot = _roundID.playerPot.add(_all);
715         uint256 _dust = updateMasks(_rID, _pID, _all, _keys);
716         _roundID.pot = _roundID.pot.add(_dust);
717         _left = _left.sub0(_all);
718 
719         //X% to winnerPot
720         _temp = _eth.mul(_deposit.pot) / DIVIDE;
721         _roundID.pot = _roundID.pot.add(_temp);
722         _left = _left.sub0(_temp);
723 
724         //5% to develop funds
725         _temp = _eth.mul(_deposit.devfunds) / DIVIDE;
726         doDevelopFunds(_temp);
727         //gameFunds[gameFundsAddr] = gameFunds[gameFundsAddr].add(_temp);
728         _left = _left.sub0(_temp);
729 
730         //5% to team fee
731         _temp = _eth.mul(_deposit.teamFee) / DIVIDE;
732         //gameFunds[partner1] = gameFunds[partner1].add(_temp.mul(50) / DIVIDE);
733         _dust = doPartnerShares(_temp);
734         _left = _left.sub0(_temp).add(_dust);
735 
736         //10% to cards
737         _temp = _eth.mul(_deposit.cards) / DIVIDE;
738         _left = _left.sub0(_temp).add(distributeCards(_temp));
739         // if no cards ,the money will add into left
740 
741         // 10% to invatation
742         _temp = _eth.mul(_deposit.inviter) / DIVIDE;
743         _dust = doInvite(_rID, _pID, _temp);
744         _left = _left.sub0(_temp).add(_dust);
745 
746         //update round;
747         if (_keys >= 1000000000000000000) {
748             _roundID.leadPID = _pID;
749             _roundID.team = _team;
750         }
751 
752 
753         _roundID.smallDrop = _roundID.smallDrop.add(_left);
754     }
755 
756     //tested
757     function doInvite(uint256 _rID, uint256 _pID, uint256 _value) private returns(uint256){
758         uint256 _score = msg.value;
759         uint256 _left = _value;
760         uint256 _inviter1 = pIDPlayer[_pID].inviter1;
761         uint256 _fee;
762         uint256 _inviter2 = pIDPlayer[_pID].inviter2;
763         if (_inviter1 != 0)
764             pIDPlayerRound[_inviter1][_rID].score = pIDPlayerRound[_inviter1][_rID].score.add(_score);
765         if (_inviter2 != 0)
766             pIDPlayerRound[_inviter2][_rID].score = pIDPlayerRound[_inviter2][_rID].score.add(_score);
767         //invitor
768         if (_inviter1 == 0 || pIDPlayer[_inviter1].vip == 0)
769             return _left;
770         if (pIDPlayer[_inviter1].vip == 1) {
771             _fee = _value.mul(70) / 100;
772             _inviter2 = pIDPlayer[_pID].inviter2;
773             _left = _left.sub0(_fee);
774             pIDPlayerRound[_inviter1][_rID].inv = pIDPlayerRound[_inviter1][_rID].inv.add(_fee);
775             if (_inviter2 == 0 || pIDPlayer[_inviter2].vip != 2)
776                 return _left;
777             else {
778                 _fee = _value.mul(30) / 100;
779                 _left = _left.sub0(_fee);
780                 pIDPlayerRound[_inviter2][_rID].inv = pIDPlayerRound[_inviter2][_rID].inv.add(_fee);
781                 return _left;
782             }
783         } else if (pIDPlayer[_inviter1].vip == 2) {
784             _left = _left.sub0(_value);
785             pIDPlayerRound[_inviter1][_rID].inv = pIDPlayerRound[_inviter1][_rID].inv.add(_value);
786             return _left;
787         } else {
788             return _left;
789         }
790     }
791 
792     function doRankInv(uint256 _rID, uint256 _pID, uint256[3] storage rank, uint256 _value) private {
793 
794         if (_value >= pIDPlayerRound[rank[0]][_rID].inv && _value != 0) {
795             if (_pID != rank[0]) {
796             uint256 temp = rank[0];
797             rank[0] = _pID;
798             if (rank[1] == _pID) {
799                 rank[1] = temp;
800             } else {
801                 rank[2] = rank[1];
802                 rank[1] = temp;
803             }
804             }
805         } else if (_value >= pIDPlayerRound[rank[1]][_rID].inv && _value != 0) {
806             if (_pID != rank[1]) {
807             rank[2] = rank[1];
808             rank[1] = _pID;
809             }
810         } else if (_value >= pIDPlayerRound[rank[2]][_rID].inv && _value != 0) {
811             rank[2] = _pID;
812         }
813     }
814 
815     function doRankKey(uint256 _rID, uint256 _pID, uint256[3] storage rank, uint256 _value) private {
816 
817         if (_value >= (pIDPlayerRound[rank[0]][_rID].team1Keys + pIDPlayerRound[rank[0]][_rID].team2Keys)) {
818             if (_pID != rank[0]) {
819             uint256 temp = rank[0];
820             rank[0] = _pID;
821             if (rank[1] == _pID) {
822                 rank[1] = temp;
823             } else {
824                 rank[2] = rank[1];
825                 rank[1] = temp;
826             }
827             }
828         } else if (_value >= (pIDPlayerRound[rank[1]][_rID].team1Keys + pIDPlayerRound[rank[1]][_rID].team2Keys)) {
829             if (_pID != rank[1]){
830             rank[2] = rank[1];
831             rank[1] = _pID;
832             }
833         } else if (_value >= (pIDPlayerRound[rank[2]][_rID].team1Keys + pIDPlayerRound[rank[2]][_rID].team2Keys)) {
834             rank[2] = _pID;
835         }
836     }
837 
838     //tested
839     function doSmallDrop(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _small) private {
840         // modulo current round eth, and add player eth to see if it can trigger the trigger;
841         uint256 _remain = rIDRound[_rID].eth % smallDropTrigger;
842         if ((_remain + _eth) >= smallDropTrigger) {
843             uint256 _reward = rIDRound[_rID].smallDrop;
844             rIDRound[_rID].smallDrop = 0;
845             pIDPlayer[_pID].win = pIDPlayer[_pID].win.add(_reward);
846             rIDRound[_rID].smallDrop = rIDRound[_rID].smallDrop.add(_small);
847             emit NTA3DEvents.onDrop(pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _rID, 0, _reward, now);
848             //emit
849         } else {
850             rIDRound[_rID].smallDrop = rIDRound[_rID].smallDrop.add(_small);
851         }
852     }
853 
854     //tested
855     function doBigDrop(uint256 _rID, uint256 _pID, uint256 _key, uint256 _big) private {
856         uint256 _keys = rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys;
857         uint256 _remain = _keys % bigDropTrigger;
858         if ((_remain + _key) >= bigDropTrigger) {
859             uint256 _reward = rIDRound[_rID].bigDrop;
860             rIDRound[_rID].bigDrop = 0;
861             pIDPlayer[_pID].win = pIDPlayer[_pID].win.add(_reward);
862             rIDRound[_rID].bigDrop = rIDRound[_rID].bigDrop.add(_big);
863             emit NTA3DEvents.onDrop(pIDPlayer[_pID].addr, pIDPlayer[_pID].name, _rID, 1, _reward, now);
864             //emit
865         } else {
866             rIDRound[_rID].bigDrop = rIDRound[_rID].bigDrop.add(_big);
867         }
868     }
869 
870     function distributeCards(uint256 _eth) private returns(uint256){
871         uint256 _each = _eth / 20;
872         uint256 _remain = _eth;
873         for (uint i = 0; i < 20; i++) {
874             uint256 _pID = cIDCard[i].owner;
875             if (_pID != 0) {
876                 pIDPlayer[_pID].crd = pIDPlayer[_pID].crd.add(_each);
877                 cIDCard[i].earnings = cIDCard[i].earnings.add(_each);
878                 _remain = _remain.sub0(_each);
879             }
880         }
881         return _remain;
882     }
883 
884     function doPartnerShares(uint256 _eth) private returns(uint256) {
885         uint i;
886         uint256 _temp;
887         uint256 _left = _eth;
888         //first 10%
889         _temp = _eth.mul(10) / 100;
890         gameFunds[partner[0]] = gameFunds[partner[0]].add(_temp);
891         for(i = 1; i < 11; i++) {
892             _temp = _eth.mul(9) / 100;
893             gameFunds[partner[i]] = gameFunds[partner[i]].add(_temp);
894             _left = _left.sub0(_temp);
895         }
896         return _left;
897     }
898 
899     function doDevelopFunds(uint256 _eth) private{
900         uint256 _temp;
901         _temp = _eth.mul(12) / 100;
902         gameFunds[to06] = gameFunds[to06].add(_temp);
903         _temp = _eth.mul(8) / 100;
904         gameFunds[to04] = gameFunds[to04].add(_temp);
905         _temp = _eth.mul(40) / 100;
906         gameFunds[to20A] = gameFunds[to20A].add(_temp);
907         _temp = _eth.mul(40) / 100;
908         gameFunds[to20B] = gameFunds[to20B].add(_temp);
909     }
910 
911     function endRound() private {
912         NTAdatasets.Round storage _roundID = rIDRound[rID];
913         NTAdatasets.PotSplit storage _potSplit = potSplit[0];
914         uint256 _winPID = _roundID.leadPID;
915         uint256 _pot = _roundID.pot;
916         uint256 _left = _pot;
917 
918         //the pot is too small endround will ignore the dividens
919         //new round will start at 0 eth
920         if(_pot < 10000000000000) {
921             emit onRoundEnd(pIDPlayer[_winPID].addr, pIDPlayer[_winPID].name, rID, _roundID.pot,0, now);
922             newRound(0);
923             return;
924         }
925 
926         // potSplit:    ==> |20% to all, 45% to lastwinner, 5% to inviter 1st, 3% to inviter 2nd, 2% to inviter 3rd,
927         //                  |8% to key buyer 1st, 5% to key buyer 2nd, 2% to key buyer 3rd, 10% to next round
928 
929         //20% to all
930         uint256 _all = _pot.mul(_potSplit.allPlayer) / DIVIDE;
931         _roundID.teamPot = _roundID.teamPot.add(_all);
932         _left = _left.sub0(_all);
933 
934         //45% to lastwinner
935         uint256 _temp = _pot.mul(_potSplit.lastWinner) / DIVIDE;
936         pIDPlayer[_winPID].win = pIDPlayer[_winPID].win.add(_temp);
937         _left = _left.sub0(_temp);
938 
939         //5% to inviter 1st, 3% to inviter 2nd, 2% to inviter 3rd
940         uint256 _inv1st = _pot.mul(_potSplit.inviter1st) / DIVIDE;
941         if (_roundID.invTop3[0] != 0) {
942             pIDPlayer[_roundID.invTop3[0]].win = pIDPlayer[_roundID.invTop3[0]].win.add(_inv1st);
943             _left = _left.sub0(_inv1st);
944         }
945 
946         _inv1st = _pot.mul(_potSplit.inviter2nd) / DIVIDE;
947         if (_roundID.invTop3[1] != 0) {
948             pIDPlayer[_roundID.invTop3[1]].win = pIDPlayer[_roundID.invTop3[1]].win.add(_inv1st);
949             _left = _left.sub0(_inv1st);
950         }
951 
952         _inv1st = _pot.mul(_potSplit.inviter3rd) / DIVIDE;
953         if (_roundID.invTop3[2] != 0) {
954             pIDPlayer[_roundID.invTop3[2]].win = pIDPlayer[_roundID.invTop3[2]].win.add(_inv1st);
955             _left = _left.sub0(_inv1st);
956         }
957 
958          //8% to key buyer 1st, 5% to key buyer 2nd, 2% to key buyer 3rd
959         _inv1st = _pot.mul(_potSplit.key1st) / DIVIDE;
960         if (_roundID.keyTop3[0] != 0) {
961             pIDPlayer[_roundID.keyTop3[0]].win = pIDPlayer[_roundID.keyTop3[0]].win.add(_inv1st);
962             _left = _left.sub0(_inv1st);
963         }
964 
965         _inv1st = _pot.mul(_potSplit.key2nd) / DIVIDE;
966         if (_roundID.keyTop3[1] != 0) {
967             pIDPlayer[_roundID.keyTop3[1]].win = pIDPlayer[_roundID.keyTop3[1]].win.add(_inv1st);
968             _left = _left.sub0(_inv1st);
969         }
970 
971         _inv1st = _pot.mul(_potSplit.key3rd) / DIVIDE;
972         if (_roundID.keyTop3[2] != 0) {
973             pIDPlayer[_roundID.keyTop3[2]].win = pIDPlayer[_roundID.keyTop3[2]].win.add(_inv1st);
974             _left = _left.sub0(_inv1st);
975         }
976 
977         //10% to next round
978         uint256 _newPot = _pot.mul(potSplit[0].next) / DIVIDE;
979         _left = _left.sub0(_newPot);
980         emit onRoundEnd(pIDPlayer[_winPID].addr, pIDPlayer[_winPID].name, rID, _roundID.pot, _newPot + _left, now);
981         //start new round
982         newRound(_newPot + _left);
983     }
984 
985     //tested
986     function newRound(uint256 _eth) private {
987         if (rIDRound[rID].ended == true || rID == 0) {
988             rID++;
989             rIDRound[rID].strt = now;
990             rIDRound[rID].end = now.add(rndMax);
991             rIDRound[rID].pot = rIDRound[rID].pot.add(_eth);
992         }
993     }
994 
995     function updateMasks(uint256 _rID, uint256 _pID, uint256 _all, uint256 _keys) private
996     returns(uint256) {
997         //calculate average share of each new eth in
998         uint256 _allKeys = rIDRound[_rID].team1Keys + rIDRound[_rID].team2Keys;
999         uint256 _unit = _all.mul(1000000000000000000) / _allKeys;
1000         rIDRound[_rID].mask = rIDRound[_rID].mask.add(_unit);
1001         //calculate this round player can get
1002         uint256 _share = (_unit.mul(_keys)) / (1000000000000000000);
1003         pIDPlayerRound[_pID][_rID].mask = pIDPlayerRound[_pID][_rID].mask.add((rIDRound[_rID].mask.mul(_keys) / (1000000000000000000)).sub(_share));
1004         return(_all.sub(_unit.mul(_allKeys) / (1000000000000000000)));
1005     }
1006 
1007     function withdrawEarnings(uint256 _pID) private returns(uint256) {
1008         updateVault(_pID);
1009         uint256 earnings = (pIDPlayer[_pID].win).add(pIDPlayer[_pID].gen).add(pIDPlayer[_pID].inv).add(pIDPlayer[_pID].tim).add(pIDPlayer[_pID].crd);
1010         if (earnings > 0) {
1011             pIDPlayer[_pID].win = 0;
1012             pIDPlayer[_pID].gen = 0;
1013             pIDPlayer[_pID].inv = 0;
1014             pIDPlayer[_pID].tim = 0;
1015             pIDPlayer[_pID].crd = 0;
1016         }
1017         return earnings;
1018     }
1019 
1020     function updateVault(uint256 _pID) private {
1021         uint256 _rID = pIDPlayer[_pID].lrnd;
1022         updateGenVault(_pID, _rID);
1023         updateInvVault(_pID, _rID);
1024         uint256 _team = calcTeamEarnings(_pID, _rID);
1025         //already calculate team reward,ended round key and mask dont needed
1026         if(rIDRound[_rID].ended == true) {
1027             pIDPlayerRound[_pID][_rID].team1Keys = 0;
1028             pIDPlayerRound[_pID][_rID].team2Keys = 0;
1029             pIDPlayerRound[_pID][_rID].mask = 0;
1030         }
1031         pIDPlayer[_pID].tim = pIDPlayer[_pID].tim.add(_team);
1032     }
1033 
1034     function updateGenVault(uint256 _pID, uint256 _rID) private {
1035         uint256 _earnings = calcUnMaskedEarnings(_pID, _rID);
1036         //put invitation reward to gen
1037         if (_earnings > 0) {
1038             // put in gen vault
1039             pIDPlayer[_pID].gen = _earnings.add(pIDPlayer[_pID].gen);
1040             // zero out their earnings by updating mask
1041             pIDPlayerRound[_pID][_rID].mask = _earnings.add(pIDPlayerRound[_pID][_rID].mask);
1042         }
1043 
1044     }
1045 
1046     function updateInvVault(uint256 _pID, uint256 _rID) private {
1047         uint256 _inv = pIDPlayerRound[_pID][_rID].inv;
1048         uint256 _invMask = pIDPlayerRound[_pID][_rID].invMask;
1049         if (_inv > 0) {
1050             pIDPlayer[_pID].inv = pIDPlayer[_pID].inv.add(_inv).sub0(_invMask);
1051             pIDPlayerRound[_pID][_rID].invMask = pIDPlayerRound[_pID][_rID].invMask.add(_inv).sub0(_invMask);
1052         }
1053     }
1054 
1055     //calculate valut not update
1056     function calcUnMaskedEarnings(uint256 _pID, uint256 _rID) private view
1057     returns (uint256)
1058     {
1059         uint256 _all = pIDPlayerRound[_pID][_rID].team1Keys + pIDPlayerRound[_pID][_rID].team2Keys;
1060         return ((rIDRound[_rID].mask.mul(_all)) / (1000000000000000000)).sub(pIDPlayerRound[_pID][_rID].mask);
1061     }
1062 
1063     function calcTeamEarnings(uint256 _pID, uint256 _rID) private view
1064     returns (uint256)
1065     {
1066         uint256 _key1 = pIDPlayerRound[_pID][_rID].team1Keys;
1067         uint256 _key2 = pIDPlayerRound[_pID][_rID].team2Keys;
1068         if (rIDRound[_rID].ended == false)
1069             return 0;
1070         else {
1071             if (rIDRound[_rID].team == 0)
1072                 return rIDRound[_rID].teamPot.mul(_key1 / rIDRound[_rID].team1Keys);
1073             else
1074                 return rIDRound[_rID].teamPot.mul(_key2 / rIDRound[_rID].team2Keys);
1075         }
1076     }
1077     //tested
1078     function updateTimer(uint256 _keys, uint256 _rID) private {
1079         // grab time
1080         uint256 _now = now;
1081         // calculate new time
1082         uint256 _newTime;
1083         if (_now > rIDRound[_rID].end && rIDRound[_rID].leadPID == 0)
1084             _newTime = (((_keys) / (1000000000000000000)).mul(rndPerKey)).add(_now);
1085         else
1086             _newTime = (((_keys) / (1000000000000000000)).mul(rndPerKey)).add(rIDRound[_rID].end);
1087 
1088         // compare to max and set new end time
1089         if (_newTime < (rndMax).add(_now))
1090             rIDRound[_rID].end = _newTime;
1091         else
1092             rIDRound[_rID].end = rndMax.add(_now);
1093     }
1094 
1095 
1096 }
1097 
1098 library NTA3DKeysCalc {
1099     using SafeMath for *;
1100     uint256 constant private keyPriceTrigger = 50000 * 1e18;
1101     uint256 constant private keyPriceFirst = 0.0005 ether;
1102     uint256 constant private keyPriceAdd = 0.0001 ether;
1103     /**
1104      * @dev calculates number of keys received given X eth
1105      * _curEth current amount of eth in contract
1106      * _newEth eth being spent
1107      * @return amount of ticket purchased
1108      */
1109     function keysRec(uint256 _curKeys, uint256 _allEth)
1110         internal
1111         pure
1112         returns (uint256)
1113     {
1114         return(keys(_curKeys, _allEth));
1115     }
1116     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1117         internal
1118         pure
1119         returns (uint256)
1120     {
1121         return(eth(_sellKeys.add(_curKeys)).sub(eth(_curKeys)));
1122     }
1123     function keys(uint256 _keys, uint256 _eth)
1124         internal
1125         pure
1126         returns(uint256)
1127     {
1128         uint256 _times = _keys / keyPriceTrigger;
1129         uint i = 0;
1130         uint256 eth1;
1131         uint256 eth2;
1132         uint256 price;
1133         uint256 key2;
1134         for(i = _times;i < i + 200; i++) {
1135             if(eth(keyPriceTrigger * (i + 1)) >=  _eth) {
1136                 if(i == 0) eth1 = 0;
1137                 else eth1 = eth(keyPriceTrigger * i);
1138                 eth2 = _eth.sub(eth1);
1139                 price = i.mul(keyPriceAdd).add(keyPriceFirst);
1140                 key2 = (eth2 / price).mul(1e18);
1141                 return ((keyPriceTrigger * i + key2).sub0(_keys));
1142                 break;
1143             }
1144         }
1145         //too large
1146         require(false, "too large eth in");
1147 
1148     }
1149      //tested
1150     function eth(uint256 _keys)
1151         internal
1152         pure
1153         returns(uint256)
1154     {
1155         uint256 _times = _keys / keyPriceTrigger;//keyPriceTrigger;
1156         uint256 _remain = _keys % keyPriceTrigger;//keyPriceTrigger;
1157         uint256 _price = _times.mul(keyPriceAdd).add(keyPriceFirst);
1158         if (_times == 0) {
1159             return (keyPriceFirst.mul(_keys / 1e18));
1160         } else {
1161             uint256 _up = (_price.sub(keyPriceFirst)).mul(_remain / 1e18);
1162             uint256 _down = (_keys / 1e18).mul(keyPriceFirst);
1163             uint256 _add = (_times.mul(_times).sub(_times) / 2).mul(keyPriceAdd).mul(keyPriceTrigger / 1e18);
1164             return (_up + _down + _add);
1165         }
1166     }
1167 }
1168 
1169 library NTAdatasets {
1170 
1171     struct Player {
1172         address addr;   // player address
1173         bytes32 name;   // player name
1174         uint256 win;    // winnings vault
1175         uint256 gen;    // general vault
1176         uint256 inv;    // inviter vault
1177         uint256 tim;     //team pot
1178         uint256 crd;     //crd pot
1179         uint256 lrnd;   // last round played
1180         uint256 inviter1; // direct inviter
1181         uint256 inviter2; // second hand inviter
1182         uint256 vip; //0 no vip; 1 and 2
1183     }
1184 
1185     struct PlayerRound {
1186         uint256 eth;    // eth player has added to round (used for eth limiter)
1187         uint256 team1Keys;
1188         uint256 team2Keys;
1189         uint256 inv;
1190         uint256 mask;
1191         uint256 invMask;
1192         uint256 score;
1193     }
1194 
1195     struct Round {
1196         uint256 leadPID;   // pID of player in lead
1197         uint256 end;    // time ends/ended
1198         bool ended;     // has round end function been ran
1199         uint256 strt;   // time round started
1200         uint256 team1Keys;   // keys
1201         uint256 team2Keys;   // keys
1202         uint256 eth;    // total eth in
1203         uint256 pot;    // eth win pot
1204         uint256 team;
1205         uint256 teamPot;
1206         uint256 smallDrop;//50Eth airdrop
1207         uint256 bigDrop; //300000 eth airdrop
1208         uint256 playerPot;
1209         uint256 mask;
1210         uint256[3] invTop3;
1211         uint256[3] keyTop3;
1212     }
1213 
1214     struct Card {
1215         uint256 owner;  //pID of card owner
1216         address addr;
1217         uint256 buyTime; //validity time check
1218         uint256 earnings;
1219     }
1220 
1221     struct Deposit {
1222         uint256 allPlayer;  // all player this rounds by key
1223         uint256 pot;        // last winner pot
1224         uint256 devfunds;   // game development Pot
1225         uint256 teamFee;    // team fee
1226         uint256 cards;      // stock right cards
1227         uint256 inviter;
1228         uint256 bigDrop;
1229         uint256 smallDrop;
1230     }
1231 
1232     struct PotSplit {
1233         uint256 allPlayer;  // all player this rounds by key
1234         uint256 lastWinner; // final player
1235         uint256 inviter1st; // player who get 1st of invatation
1236         uint256 inviter2nd;
1237         uint256 inviter3rd;
1238         uint256 key1st;     // player who get 1st key amount
1239         uint256 key2nd;
1240         uint256 key3rd;
1241         uint256 next;        // next round
1242     }
1243 }
1244 
1245 library NameFilter {
1246     function nameFilter(string _input)
1247         internal
1248         pure
1249         returns(bytes32)
1250     {
1251         bytes memory _temp = bytes(_input);
1252         uint256 _length = _temp.length;
1253 
1254         //sorry limited to 32 characters
1255         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1256         // make sure it doesnt start with or end with space
1257         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1258         // make sure first two characters are not 0x
1259         if (_temp[0] == 0x30)
1260         {
1261             require(_temp[1] != 0x78, "string cannot start with 0x");
1262             require(_temp[1] != 0x58, "string cannot start with 0X");
1263         }
1264 
1265         // create a bool to track if we have a non number character
1266         bool _hasNonNumber;
1267 
1268         // convert & check
1269         for (uint256 i = 0; i < _length; i++)
1270         {
1271             // if its uppercase A-Z
1272             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1273             {
1274                 // convert to lower case a-z
1275                 _temp[i] = byte(uint(_temp[i]) + 32);
1276 
1277                 // we have a non number
1278                 if (_hasNonNumber == false)
1279                     _hasNonNumber = true;
1280             } else {
1281                 require
1282                 (
1283                     // require character is a space
1284                     _temp[i] == 0x20 ||
1285                     // OR lowercase a-z
1286                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1287                     // or 0-9
1288                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1289                     "string contains invalid characters"
1290                 );
1291                 // make sure theres not 2x spaces in a row
1292                 if (_temp[i] == 0x20)
1293                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1294 
1295                 // see if we have a character other than a number
1296                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1297                     _hasNonNumber = true;
1298             }
1299         }
1300 
1301         require(_hasNonNumber == true, "string cannot be only numbers");
1302 
1303         bytes32 _ret;
1304         assembly {
1305             _ret := mload(add(_temp, 32))
1306         }
1307         return (_ret);
1308     }
1309 }
1310 library SafeMath {
1311     function mul(uint256 a, uint256 b)
1312         internal
1313         pure
1314         returns (uint256 c)
1315     {
1316         if (a == 0) {
1317             return 0;
1318         }
1319         c = a * b;
1320         require(c / a == b, "SafeMath mul failed");
1321         return c;
1322     }
1323     function sub(uint256 a, uint256 b)
1324         internal
1325         pure
1326         returns (uint256)
1327     {
1328         require(b <= a, "SafeMath sub failed");
1329         return a - b;
1330     }
1331 
1332     /**
1333     * @dev Subtracts two numbers, no throw
1334     */
1335     function sub0(uint256 a, uint256 b)
1336         internal
1337         pure
1338         returns (uint256)
1339     {
1340         if (a < b) {
1341             return 0;
1342         } else {
1343             return a - b;
1344         }
1345     }
1346 
1347     /**
1348     * @dev Adds two numbers, throws on overflow.
1349     */
1350     function add(uint256 a, uint256 b)
1351         internal
1352         pure
1353         returns (uint256 c)
1354     {
1355         c = a + b;
1356         require(c >= a, "SafeMath add failed");
1357         return c;
1358     }
1359 
1360     /**
1361      * @dev gives square root of given x.
1362      */
1363     function sqrt(uint256 x)
1364         internal
1365         pure
1366         returns (uint256 y)
1367     {
1368         uint256 z = ((add(x,1)) / 2);
1369         y = x;
1370         while (z < y)
1371         {
1372             y = z;
1373             z = ((add((x / z),z)) / 2);
1374         }
1375     }
1376 
1377     /**
1378      * @dev gives square. multiplies x by x
1379      */
1380     function sq(uint256 x)
1381         internal
1382         pure
1383         returns (uint256)
1384     {
1385         return (mul(x,x));
1386     }
1387 
1388     /**
1389      * @dev x to the power of y
1390      */
1391     function pwr(uint256 x, uint256 y)
1392         internal
1393         pure
1394         returns (uint256)
1395     {
1396         if (x==0)
1397             return (0);
1398         else if (y==0)
1399             return (1);
1400         else
1401         {
1402             uint256 z = x;
1403             for (uint256 i=1; i < y; i++)
1404                 z = mul(z,x);
1405             return (z);
1406         }
1407     }
1408 }