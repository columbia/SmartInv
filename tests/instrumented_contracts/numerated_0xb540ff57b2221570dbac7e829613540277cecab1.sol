1 pragma solidity ^0.4.24;
2 
3 // File: contracts/library/SafeMath.sol
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b)
15         internal
16         pure
17         returns (uint256 c)
18     {
19         if (a == 0) {
20             return 0;
21         }
22         c = a * b;
23         require(c / a == b, "SafeMath mul failed");
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b)
41         internal
42         pure
43         returns (uint256)
44     {
45         require(b <= a, "SafeMath sub failed");
46         return a - b;
47     }
48 
49     /**
50     * @dev Adds two numbers, throws on overflow.
51     */
52     function add(uint256 a, uint256 b)
53         internal
54         pure
55         returns (uint256 c)
56     {
57         c = a + b;
58         require(c >= a, "SafeMath add failed");
59         return c;
60     }
61 
62     /**
63      * @dev gives square root of given x.
64      */
65     function sqrt(uint256 x)
66         internal
67         pure
68         returns (uint256 y)
69     {
70         uint256 z = ((add(x,1)) / 2);
71         y = x;
72         while (z < y)
73         {
74             y = z;
75             z = ((add((x / z),z)) / 2);
76         }
77     }
78 
79     /**
80      * @dev gives square. multiplies x by x
81      */
82     function sq(uint256 x)
83         internal
84         pure
85         returns (uint256)
86     {
87         return (mul(x,x));
88     }
89 
90     /**
91      * @dev x to the power of y
92      */
93     function pwr(uint256 x, uint256 y)
94         internal
95         pure
96         returns (uint256)
97     {
98         if (x==0)
99             return (0);
100         else if (y==0)
101             return (1);
102         else
103         {
104             uint256 z = x;
105             for (uint256 i = 1; i < y; i++)
106                 z = mul(z,x);
107             return (z);
108         }
109     }
110 }
111 
112 // File: contracts/Lottery.sol
113 
114 // import "./interface/QMGCoinInterface.sol";
115 
116 contract Lottery {
117     using SafeMath for *;
118 
119     // QMGCoinInterface constant private QMECoin = QMGCoinInterface(0x32140ee94f2a1C3232C91BE55f26ee89B8693546);
120 
121     address public owner_;
122 
123     uint256 public investmentBalance_;
124     uint256 public developerBalance_;
125     uint256 public topBonus500Balance_;
126 
127     uint256 public jackpotSplit = 50;                // % of buy in thats add to jackpot this round
128     uint256 public nextJackpotSplit = 15;            // % of buy in thats add to jackpot next round
129     uint256 public bonus500Split = 5;               // % of buy in thats paid to first 500 players
130     uint256 public investorDividendSplit = 10;       // % of buy in thats paid to investors
131     uint256 public developerDividendSplit = 10;      // % of buy in thats paid to developers
132     uint256 public referrerDividendSplit = 10;       // % of buy in thats paid to referrer
133     uint256[6] public jpSplit_ = [0, 50, 25, 12, 8, 5]; // % of jackpot in thats paid to each class prize
134 
135     uint256 public rID_;
136 
137     uint256 public jackpotBalance_;
138     uint256 public jackpotNextBalance_;
139     uint256 public jackpotLeftBalance_;
140 
141     uint256 public kID_;
142     struct Key {
143         uint key;
144         uint tID;    // team id
145         uint pID;    // player id
146     }
147 
148     mapping(uint256 => Key) public keys_;   // (kID_ => data) key data
149 
150     uint256[500] public topPlayers_;    // first 500 players each round
151     uint256 public tpID_;
152 
153     struct WonNum {
154         uint256 blockNum;
155         uint256 last6Num;
156     }
157     mapping(uint256 => WonNum) wonNums_;    // (rID_ => wonNum)
158 
159     bool public roundEnded_;
160 
161     uint256 public pID_;
162     mapping (address => uint256) public pIDxAddr_;      // (addr => pID) returns player id by address
163     mapping (uint256 => Player ) public plyr_;          // (pID => data) player data
164 
165     struct Player {
166         address addr;
167         uint256 referrerID;
168         uint256 playedNum;
169         uint256 referralsNum;
170         uint256 teamBonus;
171         uint256 referralsBonus;
172         uint256 winPrize;
173         uint256 accountBalance;
174     }
175 
176     mapping (uint256 => mapping(uint256 => uint256[])) public histories_;      // (pID => rID => keys)
177 
178     uint[4] public teamNums_;
179 
180     event Transfer(address indexed from, address indexed to, uint value);
181     event RoundEnd(address indexed from, address indexed to, uint value);
182     event BuyAKeyWithEth(address indexed from, uint key, uint teamID);
183     event BuyAKeyWithBalance(address indexed from, uint key, uint teamID);
184     event WithdrawBalance(address indexed to, uint amount);
185     event AddToInvestmentBalance(uint amount);
186     event AddReferrerBalance(address indexed to, uint amount);
187     event AddTeamBonusBalance(address indexed to, uint amount);
188     event AddPrizeBalance(address indexed to, uint amount);
189 
190     constructor()
191         public
192     {
193         owner_ = msg.sender;
194 
195         rID_ = 0;
196 
197         investmentBalance_ = 0;
198 
199         developerBalance_ = 0;
200 
201         plyr_[0].addr = 0x1F8ADEA9E727d334d34BD757E59b8B9B466E7251;
202         plyr_[0].referrerID = 0;
203         plyr_[0].playedNum = 0;
204         plyr_[0].referralsNum = 0;
205         plyr_[0].teamBonus = 0;
206         plyr_[0].referralsBonus = 0;
207         plyr_[0].winPrize = 0;
208         plyr_[0].accountBalance = 0;
209 
210         pID_ = 1;
211         teamNums_ = [0, 0, 0, 0];
212     }
213 
214     modifier onlyOwner
215     {
216         require(msg.sender == owner_, "msg sender is not contract owner");
217         _;
218     }
219 
220     /* administrative functions */
221 
222     function roundStart ()
223         public
224         onlyOwner()
225     {
226         tpID_ = 0;
227 
228         kID_ = 1;
229 
230         rID_++;
231 
232         // init jackpot of new round
233         jackpotBalance_ = (jackpotNextBalance_).add(jackpotLeftBalance_);
234         jackpotNextBalance_ = 0;
235 
236         if (jackpotBalance_ > 10000000000000000000000) {
237             jackpotBalance_ = (jackpotBalance_).sub(3000000000000000000000);
238             investmentBalance_ = (investmentBalance_).add(3000000000000000000000);
239             emit AddToInvestmentBalance(3000000000000000000000);
240         }
241 
242         delete teamNums_;
243 
244         // reset top 500 players
245         tpID_ = 0;
246 
247         roundEnded_ = false;
248     }
249 
250     function roundEnd ()
251         public
252         onlyOwner()
253     {
254         roundEnded_ = true;
255     }
256 
257     function pay(address _to, uint _amount) private {
258         _to.transfer(_amount);
259         emit Transfer(owner_, _to, _amount);
260     }
261 
262     function changeIncomesSplits (uint _jkpt, uint _nxtjkpt, uint bns500, uint invst, uint dev, uint ref)
263         public
264         onlyOwner()
265     {
266         require(_jkpt > 0 && _nxtjkpt > 0 && bns500 > 0 && invst > 0 && dev > 0 && ref > 0, "split must more than 0");
267         require((_jkpt + _nxtjkpt + bns500 + invst + dev + ref) <= 100, "sum splits must lte 100 ");
268 
269         jackpotSplit = _jkpt;
270         nextJackpotSplit = _nxtjkpt;
271         bonus500Split = bns500;
272         investorDividendSplit = invst;
273         developerDividendSplit = dev;
274         referrerDividendSplit = ref;
275     }
276 
277     function changePrizeSplits (uint c1, uint c2, uint c3, uint c4, uint c5)
278         public
279         onlyOwner()
280     {
281         require(c1 > 0 && c2 > 0 && c3 > 0 && c4 > 0 && c5 > 0, "split must more than 0");
282         require((c1 + c2 + c3 + c4 + c5) <= 100, "sum splits must lte 100 ");
283         jpSplit_ = [c1, c2, c3, c4, c5];
284     }
285 
286     function createPlayer(address _addr, address _referrer)
287         private
288         returns (uint)
289     {
290         plyr_[pID_].addr = _addr;
291         plyr_[pID_].playedNum = 0;
292         plyr_[pID_].referralsNum = 0;
293         plyr_[pID_].winPrize = 0;
294         pIDxAddr_[_addr] = pID_;
295 
296         uint256 referrerID = getPlayerID(_referrer);
297         if (referrerID != 0) {
298             if (getPlayerPlayedTimes(referrerID) > 0) {
299                 plyr_[pID_].referrerID = referrerID;
300                 plyr_[referrerID].referralsNum ++;
301             }
302         }
303         uint pID = pID_;
304         pID_ ++;
305         return pID;
306     }
307 
308     function updatePlayedNum(address _addr, address _referrer, uint256 _key)
309         private
310         returns (uint)
311     {
312         uint plyrID = getPlayerID(_addr);
313         if (plyrID == 0) {
314             plyrID = createPlayer(_addr, _referrer);
315         }
316 
317         plyr_[plyrID].playedNum += 1;
318         histories_[plyrID][rID_].push(_key);
319         return (plyrID);
320     }
321 
322     function addRefBalance(address _addr, uint256 _val)
323         private
324         returns (uint256)
325     {
326         uint plyrID = getPlayerID(_addr);
327 
328         require(plyrID > 0, "Player should have played before");
329 
330         plyr_[plyrID].referralsBonus = (plyr_[plyrID].referralsBonus).add(_val);
331         plyr_[plyrID].accountBalance = (plyr_[plyrID].accountBalance).add(_val);
332         emit AddReferrerBalance(plyr_[plyrID].addr, _val);
333 
334         return (plyr_[plyrID].accountBalance);
335     }
336 
337     function addBalance(uint _pID, uint256 _prizeVal, uint256 _teamVal)
338         public
339         onlyOwner()
340         returns(uint256)
341     {
342 
343         require(_pID > 0, "Player should have played before");
344 
345         uint256 refPlayedNum = getPlayerPlayedTimes(plyr_[_pID].referrerID);
346 
347         if (refPlayedNum > 0) {
348             plyr_[plyr_[_pID].referrerID].referralsBonus = (plyr_[plyr_[_pID].referrerID].referralsBonus).add(_prizeVal / 10);
349             plyr_[plyr_[_pID].referrerID].accountBalance = (plyr_[plyr_[_pID].referrerID].accountBalance).add(_prizeVal / 10);
350 
351             plyr_[_pID].winPrize = (plyr_[_pID].winPrize).add((_prizeVal).mul(9) / 10);
352             plyr_[_pID].accountBalance = (plyr_[_pID].accountBalance).add((_prizeVal).mul(9) / 10);
353         } else {
354             plyr_[_pID].winPrize = (plyr_[_pID].winPrize).add(_prizeVal);
355             plyr_[_pID].accountBalance = (plyr_[_pID].accountBalance).add(_prizeVal);
356         }
357         emit AddPrizeBalance(plyr_[_pID].addr, _prizeVal);
358 
359         plyr_[_pID].teamBonus = (plyr_[_pID].teamBonus).add(_teamVal);
360         plyr_[_pID].accountBalance = (plyr_[_pID].accountBalance).add(_teamVal);
361         emit AddTeamBonusBalance(plyr_[_pID].addr, _teamVal);
362 
363         return (plyr_[_pID].accountBalance);
364     }
365 
366     function subAccountBalance(address _addr, uint256 _val)
367         private
368         returns(uint256)
369     {
370         uint plyrID = getPlayerID(_addr);
371         require(plyr_[plyrID].accountBalance >= _val, "Account should have enough value");
372 
373         plyr_[plyrID].accountBalance = (plyr_[plyrID].accountBalance).sub(_val);
374         return (plyr_[plyrID].accountBalance);
375     }
376 
377     function withdrawBalance()
378         public
379         returns(uint256)
380     {
381         uint plyrID = getPlayerID(msg.sender);
382         require(plyr_[plyrID].accountBalance >= 10000000000000000, "Account should have more than 0.01 eth");
383 
384         uint256 transferAmount = plyr_[plyrID].accountBalance;
385         pay(msg.sender, transferAmount);
386         plyr_[plyrID].accountBalance = 0;
387         emit WithdrawBalance(msg.sender, transferAmount);
388         return (plyr_[plyrID].accountBalance);
389     }
390 
391 
392     function changeOwner (address _to)
393         public
394         onlyOwner()
395     {
396         owner_ = _to;
397     }
398 
399     function gameDestroy()
400         public
401         onlyOwner()
402     {
403         uint prize = jackpotBalance_ / pID_;
404         for (uint i = 0; i < pID_; i ++) {
405             pay(plyr_[i].addr, prize);
406         }
407     }
408 
409     function updateWonNums (uint256 _blockNum, uint256 _last6Num)
410         public
411         onlyOwner()
412     {
413         wonNums_[rID_].blockNum = _blockNum;
414         wonNums_[rID_].last6Num = _last6Num;
415     }
416 
417     function updateJackpotLeft (uint256 _jackpotLeft)
418         public
419         onlyOwner()
420     {
421         jackpotLeftBalance_ = _jackpotLeft;
422     }
423 
424     function transferDividendBalance (address _to, uint _val)
425         public
426         onlyOwner()
427     {
428         require(_val > 10000000000000000, "Value must more than 0.01 eth");
429         require(investmentBalance_ >= _val, "No more balance left");
430         pay(_to, _val);
431         investmentBalance_ = (investmentBalance_).sub(_val);
432     }
433 
434     function transferDevBalance (address _to, uint _val)
435         public
436         onlyOwner()
437     {
438         require(_val > 10000000000000000, "Value must more than 0.01 eth");
439         require(developerBalance_ >= _val, "No more balance left");
440         pay(_to, _val);
441         developerBalance_ = (developerBalance_).sub(_val);
442     }
443 
444     /* public functions */
445 
446     function buyAKeyWithDeposit(uint256 _key, address _referrer, uint256 _teamID)
447         public
448         payable
449         returns (bool)
450     {
451         require(msg.value > 10000000000000000, "Value must more than 0.01 eth");
452 
453         if (roundEnded_) {
454             pay(msg.sender, msg.value);
455             emit RoundEnd(address(this), msg.sender, msg.value);
456             return(false);
457         }
458 
459         jackpotBalance_ = (jackpotBalance_).add((msg.value).mul(jackpotSplit) / 100);
460         jackpotNextBalance_ = (jackpotNextBalance_).add((msg.value).mul(nextJackpotSplit) / 100);
461         investmentBalance_ = (investmentBalance_).add((msg.value).mul(investorDividendSplit) / 100);
462         developerBalance_ = (developerBalance_).add((msg.value).mul(developerDividendSplit) / 100);
463         topBonus500Balance_ = (topBonus500Balance_).add((msg.value).mul(bonus500Split) / 100);
464 
465         if (determinReferrer(_referrer)) {
466             addRefBalance(_referrer, (msg.value).mul(referrerDividendSplit) / 100);
467         } else {
468             developerBalance_ = (developerBalance_).add((msg.value).mul(referrerDividendSplit) / 100);
469         }
470 
471         uint pID = updatePlayedNum(msg.sender, _referrer, _key);
472 
473         keys_[kID_].key = _key;
474         keys_[kID_].tID = _teamID;
475         keys_[kID_].pID = pID;
476 
477         teamNums_[_teamID] ++;
478         kID_ ++;
479 
480         if (tpID_ < 500) {
481             topPlayers_[tpID_] = pID;
482             tpID_ ++;
483         }
484         emit BuyAKeyWithEth(msg.sender, _key, _teamID);
485         return (true);
486     }
487 
488     function buyAKeyWithAmount(uint256 _key, address _referrer, uint256 _teamID)
489         public
490         payable
491         returns (bool)
492     {
493         uint accBalance = getPlayerAccountBalance(msg.sender);
494         if (roundEnded_) {
495             emit RoundEnd(address(this), msg.sender, msg.value);
496             return(false);
497         }
498 
499         uint keyPrice = 10000000000000000;
500 
501         require(accBalance > keyPrice, "Account left balance should more than 0.01 eth");
502 
503         subAccountBalance(msg.sender, keyPrice);
504 
505         jackpotBalance_ = (jackpotBalance_).add((keyPrice).mul(jackpotSplit) / 100);
506         jackpotNextBalance_ = (jackpotNextBalance_).add((keyPrice).mul(nextJackpotSplit) / 100);
507         investmentBalance_ = (investmentBalance_).add((keyPrice).mul(investorDividendSplit) / 100);
508         developerBalance_ = (developerBalance_).add((keyPrice).mul(developerDividendSplit) / 100);
509         topBonus500Balance_ = (topBonus500Balance_).add((keyPrice).mul(bonus500Split) / 100);
510 
511         if (determinReferrer(_referrer)) {
512             addRefBalance(_referrer, (keyPrice).mul(referrerDividendSplit) / 100);
513         } else {
514             developerBalance_ = (developerBalance_).add((keyPrice).mul(referrerDividendSplit) / 100);
515         }
516 
517         uint pID = updatePlayedNum(msg.sender, _referrer, _key);
518 
519         keys_[kID_].key = _key;
520         keys_[kID_].tID = _teamID;
521         keys_[kID_].pID = pID;
522 
523         teamNums_[_teamID] ++;
524         kID_ ++;
525 
526         if (tpID_ < 500) {
527             topPlayers_[tpID_] = pID;
528             tpID_ ++;
529         }
530         emit BuyAKeyWithBalance(msg.sender, _key, _teamID);
531         return (true);
532     }
533 
534     function showRoundNum () public view returns(uint256) { return rID_;}
535     function showJackpotThisRd () public view returns(uint256) { return jackpotBalance_;}
536     function showJackpotNextRd () public view returns(uint256) { return jackpotNextBalance_;}
537     function showInvestBalance () public view returns(uint256) { return investmentBalance_;}
538     function showDevBalance () public view returns(uint256) { return developerBalance_;}
539     function showTopBonusBalance () public view returns(uint256) { return topBonus500Balance_;}
540     function showTopsPlayer () external view returns(uint256[500]) { return topPlayers_; }
541     function getTeamPlayersNum () public view returns (uint[4]) { return teamNums_; }
542     function getPlayerID(address _addr)  public  view returns(uint256) { return (pIDxAddr_[_addr]); }
543     function getPlayerPlayedTimes(uint256 _plyrID) public view returns (uint256) { return (plyr_[_plyrID].playedNum); }
544     function getPlayerReferrerID(uint256 _plyrID) public view returns (uint256) { return (plyr_[_plyrID].referrerID); }
545     function showKeys(uint _index) public view returns(uint256, uint256, uint256, uint256) {
546         return (kID_, keys_[_index].key, keys_[_index].pID, keys_[_index].tID);
547     }
548     function showRdWonNum (uint256 _rID) public view returns(uint256[2]) {
549         uint256[2] memory res;
550         res[0] = wonNums_[_rID].blockNum;
551         res[1] = wonNums_[_rID].last6Num;
552         return (res);
553     }
554     function determinReferrer(address _addr) public view returns (bool)
555     {
556         uint256 pID = getPlayerID(_addr);
557         uint256 playedNum = getPlayerPlayedTimes(pID);
558         return (playedNum > 0);
559     }
560     function getReferrerAddr (address _addr) public view returns (address)
561     {
562         uint pID = getPlayerID(_addr);
563         uint refID = plyr_[pID].referrerID;
564         if (determinReferrer(plyr_[refID].addr)) {
565             return plyr_[refID].addr;
566         } else {
567             return (0x0);
568         }
569     }
570     function getPlayerAccountBalance (address _addr)  public view returns (uint)
571     {
572         uint plyrID = getPlayerID(_addr);
573         return (plyr_[plyrID].accountBalance);
574     }
575     function getPlayerHistories (address _addr, uint256 _rID) public  view returns (uint256[])
576     {
577         uint plyrID = getPlayerID(_addr);
578 
579         return (histories_[plyrID][_rID]);
580     }
581 }