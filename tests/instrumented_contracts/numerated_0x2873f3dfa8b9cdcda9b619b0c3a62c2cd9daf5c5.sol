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
114 contract Lottery {
115     using SafeMath for *;
116 
117     address public owner_;
118 
119     uint256 public investmentBalance_;
120     uint256 public developerBalance_;
121     uint256 public topBonus500Balance_;
122 
123     uint256 public jackpotSplit = 50;                // % of buy in thats add to jackpot this round
124     uint256 public nextJackpotSplit = 15;            // % of buy in thats add to jackpot next round
125     uint256 public bonus500Split = 5;               // % of buy in thats paid to first 500 players
126     uint256 public investorDividendSplit = 10;       // % of buy in thats paid to investors
127     uint256 public developerDividendSplit = 10;      // % of buy in thats paid to developers
128     uint256 public referrerDividendSplit = 10;       // % of buy in thats paid to referrer
129     uint256[6] public jpSplit_ = [0, 50, 25, 12, 8, 5]; // % of jackpot in thats paid to each class prize
130 
131     uint256 public rID_;
132 
133     uint256 public jackpotBalance_;
134     uint256 public jackpotNextBalance_;
135     uint256 public jackpotLeftBalance_;
136 
137     uint256 public kID_;
138     struct Key {
139         uint key;
140         uint tID;    // team id
141         uint pID;    // player id
142     }
143 
144     mapping(uint256 => Key) public keys_;   // (kID_ => data) key data
145 
146     uint256[500] public topPlayers_;    // first 500 players each round
147     uint256 public tpID_;
148 
149     struct WonNum {
150         uint256 blockNum;
151         uint256 last6Num;
152     }
153     mapping(uint256 => WonNum) wonNums_;    // (rID_ => wonNum)
154 
155     bool public roundEnded_;
156 
157     uint256 public pID_;
158     mapping (address => uint256) public pIDxAddr_;      // (addr => pID) returns player id by address
159     mapping (uint256 => Player ) public plyr_;          // (pID => data) player data
160 
161     struct Player {
162         address addr;
163         uint256 referrerID;
164         uint256 playedNum;
165         uint256 referralsNum;
166         uint256 teamBonus;
167         uint256 referralsBonus;
168         uint256 winPrize;
169         uint256 accountBalance;
170     }
171 
172     mapping (uint256 => mapping(uint256 => uint256[])) public histories_;      // (pID => rID => keys)
173 
174     uint[4] public teamNums_;
175 
176     uint public keyPrice_ = 10000000000000000;
177 
178     event Transfer(address indexed from, address indexed to, uint value);
179     event BuyAKey(address indexed from, uint key, uint teamID);
180     event WithdrawBalance(address indexed to, uint amount);
181     event AddReferrerBalance(address indexed to, uint amount);
182     event AddTeamBonusBalance(address indexed to, uint amount);
183     event AddPrizeBalance(address indexed to, uint amount);
184 
185     constructor()
186         public
187     {
188         owner_ = msg.sender;
189 
190         rID_ = 0;
191 
192         investmentBalance_ = 0;
193 
194         developerBalance_ = 0;
195 
196         pID_ = 1;
197         teamNums_ = [0, 0, 0, 0];
198     }
199 
200     modifier onlyOwner
201     {
202         require(msg.sender == owner_, "msg sender is not contract owner");
203         _;
204     }
205 
206     /* administrative functions */
207 
208     function roundStart ()
209         public
210         onlyOwner()
211     {
212         tpID_ = 0;
213 
214         kID_ = 1;
215 
216         rID_++;
217 
218         // init jackpot of new round
219         jackpotBalance_ = (jackpotNextBalance_).add(jackpotLeftBalance_);
220         jackpotNextBalance_ = 0;
221 
222         if (jackpotBalance_ > 10000000000000000000000) {
223             jackpotBalance_ = (jackpotBalance_).sub(3000000000000000000000);
224             investmentBalance_ = (investmentBalance_).add(3000000000000000000000);
225         }
226 
227         delete teamNums_;
228 
229         // reset top 500 players
230         tpID_ = 0;
231 
232         roundEnded_ = false;
233     }
234 
235     function roundEnd ()
236         public
237         onlyOwner()
238     {
239         roundEnded_ = true;
240     }
241 
242     function pay(address _to, uint _amount) private {
243         _to.transfer(_amount);
244         emit Transfer(owner_, _to, _amount);
245     }
246 
247     function changeIncomesSplits (uint _jkpt, uint _nxtjkpt, uint bns500, uint invst, uint dev, uint ref)
248         public
249         onlyOwner()
250     {
251         require(_jkpt > 0 && _nxtjkpt > 0 && bns500 > 0 && invst > 0 && dev > 0 && ref > 0, "split must more than 0");
252         require((_jkpt + _nxtjkpt + bns500 + invst + dev + ref) <= 100, "sum splits must lte 100 ");
253 
254         jackpotSplit = _jkpt;
255         nextJackpotSplit = _nxtjkpt;
256         bonus500Split = bns500;
257         investorDividendSplit = invst;
258         developerDividendSplit = dev;
259         referrerDividendSplit = ref;
260     }
261 
262     function changePrizeSplits (uint c1, uint c2, uint c3, uint c4, uint c5)
263         public
264         onlyOwner()
265     {
266         require(c1 > 0 && c2 > 0 && c3 > 0 && c4 > 0 && c5 > 0, "split must more than 0");
267         require((c1 + c2 + c3 + c4 + c5) <= 100, "sum splits must lte 100 ");
268         jpSplit_ = [c1, c2, c3, c4, c5];
269     }
270 
271     function createPlayer(address _addr, address _referrer)
272         private
273         returns (uint)
274     {
275         plyr_[pID_].addr = _addr;
276         plyr_[pID_].playedNum = 0;
277         plyr_[pID_].referralsNum = 0;
278         plyr_[pID_].winPrize = 0;
279         pIDxAddr_[_addr] = pID_;
280 
281         uint256 referrerID = getPlayerID(_referrer);
282         if (referrerID != 0) {
283             if (getPlayerPlayedTimes(referrerID) > 0) {
284                 plyr_[pID_].referrerID = referrerID;
285                 plyr_[referrerID].referralsNum ++;
286             }
287         }
288         uint pID = pID_;
289         pID_ ++;
290         return pID;
291     }
292 
293     function updatePlayedNum(address _addr, address _referrer, uint256 _key)
294         private
295         returns (uint)
296     {
297         uint plyrID = getPlayerID(_addr);
298         if (plyrID == 0) {
299             plyrID = createPlayer(_addr, _referrer);
300         }
301 
302         plyr_[plyrID].playedNum += 1;
303         histories_[plyrID][rID_].push(_key);
304         return (plyrID);
305     }
306 
307     function addRefBalance(address _addr, uint256 _val)
308         private
309         returns (uint256)
310     {
311         uint plyrID = getPlayerID(_addr);
312 
313         require(plyrID > 0, "Player should have played before");
314 
315         plyr_[plyrID].referralsBonus = (plyr_[plyrID].referralsBonus).add(_val);
316         plyr_[plyrID].accountBalance = (plyr_[plyrID].accountBalance).add(_val);
317         emit AddReferrerBalance(plyr_[plyrID].addr, _val);
318 
319         return (plyr_[plyrID].accountBalance);
320     }
321 
322     function addBalance(uint _pID, uint256 _prizeVal, uint256 _teamVal)
323         public
324         onlyOwner()
325         returns(uint256)
326     {
327 
328         require(_pID > 0, "Player should have played before");
329 
330         uint256 refPlayedNum = getPlayerPlayedTimes(plyr_[_pID].referrerID);
331 
332         if (refPlayedNum > 0) {
333             plyr_[plyr_[_pID].referrerID].referralsBonus = (plyr_[plyr_[_pID].referrerID].referralsBonus).add(_prizeVal / 10);
334             plyr_[plyr_[_pID].referrerID].accountBalance = (plyr_[plyr_[_pID].referrerID].accountBalance).add(_prizeVal / 10);
335 
336             plyr_[_pID].winPrize = (plyr_[_pID].winPrize).add((_prizeVal).mul(9) / 10);
337             plyr_[_pID].accountBalance = (plyr_[_pID].accountBalance).add((_prizeVal).mul(9) / 10);
338         } else {
339             plyr_[_pID].winPrize = (plyr_[_pID].winPrize).add(_prizeVal);
340             plyr_[_pID].accountBalance = (plyr_[_pID].accountBalance).add(_prizeVal);
341         }
342         emit AddPrizeBalance(plyr_[_pID].addr, _prizeVal);
343 
344         plyr_[_pID].teamBonus = (plyr_[_pID].teamBonus).add(_teamVal);
345         plyr_[_pID].accountBalance = (plyr_[_pID].accountBalance).add(_teamVal);
346         emit AddTeamBonusBalance(plyr_[_pID].addr, _teamVal);
347 
348         return (plyr_[_pID].accountBalance);
349     }
350 
351     function subAccountBalance(address _addr, uint256 _val)
352         private
353         returns(uint256)
354     {
355         uint plyrID = getPlayerID(_addr);
356         require(plyr_[plyrID].accountBalance >= _val, "Account should have enough value");
357 
358         plyr_[plyrID].accountBalance = (plyr_[plyrID].accountBalance).sub(_val);
359         return (plyr_[plyrID].accountBalance);
360     }
361 
362     function withdrawBalance()
363         public
364         returns(uint256)
365     {
366         uint plyrID = getPlayerID(msg.sender);
367         require(plyr_[plyrID].accountBalance >= 10000000000000000, "Account should have more than 0.01 eth");
368 
369         uint256 transferAmount = plyr_[plyrID].accountBalance;
370         pay(msg.sender, transferAmount);
371         plyr_[plyrID].accountBalance = 0;
372         emit WithdrawBalance(msg.sender, transferAmount);
373         return (plyr_[plyrID].accountBalance);
374     }
375 
376 
377     function changeOwner (address _to)
378         public
379         onlyOwner()
380     {
381         owner_ = _to;
382     }
383 
384     function gameDestroy()
385         public
386         onlyOwner()
387     {
388         uint prize = jackpotBalance_ / pID_;
389         for (uint i = 0; i < pID_; i ++) {
390             pay(plyr_[i].addr, prize);
391         }
392     }
393 
394     function updateWonNums (uint256 _blockNum, uint256 _last6Num)
395         public
396         onlyOwner()
397     {
398         wonNums_[rID_].blockNum = _blockNum;
399         wonNums_[rID_].last6Num = _last6Num;
400     }
401 
402     function updateJackpotLeft (uint256 _jackpotLeft)
403         public
404         onlyOwner()
405     {
406         jackpotLeftBalance_ = _jackpotLeft;
407     }
408 
409     function transferDividendBalance (address _to, uint _val)
410         public
411         onlyOwner()
412     {
413         require((_val >= 10000000000000000) && (investmentBalance_ >= _val), "Value must more than 0.01 eth");
414         pay(_to, _val);
415         investmentBalance_ = (investmentBalance_).sub(_val);
416     }
417 
418     function transferDevBalance (address _to, uint _val)
419         public
420         onlyOwner()
421     {
422         require((_val >= 10000000000000000) && (developerBalance_ >= _val), "Value must more than 0.01 eth");
423         pay(_to, _val);
424         developerBalance_ = (developerBalance_).sub(_val);
425     }
426 
427     function updateKeyPrice (uint _val)
428         public
429         onlyOwner()
430     {
431         require(_val > 0, "Value must more than 0 eth");
432         keyPrice_ = _val;
433     }
434 
435     /* public functions */
436 
437     function buyAKeyWithDeposit(uint256 _key, address _referrer, uint256 _teamID)
438         external
439         payable
440         returns (bool)
441     {
442         require(msg.value >= keyPrice_, "Value must more than 0.01 eth");
443 
444         if (roundEnded_) {
445             pay(msg.sender, msg.value);
446             return(false);
447         }
448 
449         jackpotBalance_ = (jackpotBalance_).add((msg.value).mul(jackpotSplit) / 100);
450         jackpotNextBalance_ = (jackpotNextBalance_).add((msg.value).mul(nextJackpotSplit) / 100);
451         investmentBalance_ = (investmentBalance_).add((msg.value).mul(investorDividendSplit) / 100);
452         developerBalance_ = (developerBalance_).add((msg.value).mul(developerDividendSplit) / 100);
453         topBonus500Balance_ = (topBonus500Balance_).add((msg.value).mul(bonus500Split) / 100);
454 
455         if (determinReferrer(_referrer)) {
456             addRefBalance(_referrer, (msg.value).mul(referrerDividendSplit) / 100);
457         } else {
458             developerBalance_ = (developerBalance_).add((msg.value).mul(referrerDividendSplit) / 100);
459         }
460 
461         uint pID = updatePlayedNum(msg.sender, _referrer, _key);
462 
463         keys_[kID_].key = _key;
464         keys_[kID_].tID = _teamID;
465         keys_[kID_].pID = pID;
466 
467         teamNums_[_teamID] ++;
468         kID_ ++;
469 
470         if (tpID_ < 500) {
471             topPlayers_[tpID_] = pID;
472             tpID_ ++;
473         }
474         emit BuyAKey(msg.sender, _key, _teamID);
475         return (true);
476     }
477 
478     function buyAKeyWithAmount(uint256 _key, address _referrer, uint256 _teamID)
479         external
480         payable
481         returns (bool)
482     {
483         uint accBalance = getPlayerAccountBalance(msg.sender);
484         if (roundEnded_) {
485             return(false);
486         }
487 
488         require(accBalance >= keyPrice_, "Account left balance should more than 0.01 eth");
489 
490         subAccountBalance(msg.sender, keyPrice_);
491 
492         jackpotBalance_ = (jackpotBalance_).add((keyPrice_).mul(jackpotSplit) / 100);
493         jackpotNextBalance_ = (jackpotNextBalance_).add((keyPrice_).mul(nextJackpotSplit) / 100);
494         investmentBalance_ = (investmentBalance_).add((keyPrice_).mul(investorDividendSplit) / 100);
495         developerBalance_ = (developerBalance_).add((keyPrice_).mul(developerDividendSplit) / 100);
496         topBonus500Balance_ = (topBonus500Balance_).add((keyPrice_).mul(bonus500Split) / 100);
497 
498         if (determinReferrer(_referrer)) {
499             addRefBalance(_referrer, (keyPrice_).mul(referrerDividendSplit) / 100);
500         } else {
501             developerBalance_ = (developerBalance_).add((keyPrice_).mul(referrerDividendSplit) / 100);
502         }
503 
504         uint pID = updatePlayedNum(msg.sender, _referrer, _key);
505 
506         keys_[kID_].key = _key;
507         keys_[kID_].tID = _teamID;
508         keys_[kID_].pID = pID;
509 
510         teamNums_[_teamID] ++;
511         kID_ ++;
512 
513         if (tpID_ < 500) {
514             topPlayers_[tpID_] = pID;
515             tpID_ ++;
516         }
517         emit BuyAKey(msg.sender, _key, _teamID);
518         return (true);
519     }
520 
521     function showRoundNum () public view returns(uint256) { return rID_;}
522     function showJackpotThisRd () public view returns(uint256) { return jackpotBalance_;}
523     function showJackpotNextRd () public view returns(uint256) { return jackpotNextBalance_;}
524     function showInvestBalance () public view returns(uint256) { return investmentBalance_;}
525     function showDevBalance () public view returns(uint256) { return developerBalance_;}
526     function showTopBonusBalance () public view returns(uint256) { return topBonus500Balance_;}
527     function showTopsPlayer () external view returns(uint256[500]) { return topPlayers_; }
528     function getTeamPlayersNum () public view returns (uint[4]) { return teamNums_; }
529     function getPlayerID(address _addr)  public  view returns(uint256) { return (pIDxAddr_[_addr]); }
530     function getPlayerPlayedTimes(uint256 _plyrID) public view returns (uint256) { return (plyr_[_plyrID].playedNum); }
531     function getPlayerReferrerID(uint256 _plyrID) public view returns (uint256) { return (plyr_[_plyrID].referrerID); }
532     function showKeys(uint _index) public view returns(uint256, uint256, uint256, uint256) {
533         return (kID_, keys_[_index].key, keys_[_index].pID, keys_[_index].tID);
534     }
535     function showRdWonNum (uint256 _rID) public view returns(uint256[2]) {
536         uint256[2] memory res;
537         res[0] = wonNums_[_rID].blockNum;
538         res[1] = wonNums_[_rID].last6Num;
539         return (res);
540     }
541     function determinReferrer(address _addr) public view returns (bool)
542     {
543         if (_addr == msg.sender) {
544             return false;
545         }
546         uint256 pID = getPlayerID(_addr);
547         uint256 playedNum = getPlayerPlayedTimes(pID);
548         return (playedNum > 0);
549     }
550     function getReferrerAddr (address _addr) public view returns (address)
551     {
552         uint pID = getPlayerID(_addr);
553         uint refID = plyr_[pID].referrerID;
554         if (determinReferrer(plyr_[refID].addr)) {
555             return plyr_[refID].addr;
556         } else {
557             return (0x0);
558         }
559     }
560     function getPlayerAccountBalance (address _addr)  public view returns (uint)
561     {
562         uint plyrID = getPlayerID(_addr);
563         return (plyr_[plyrID].accountBalance);
564     }
565     function getPlayerHistories (address _addr, uint256 _rID) public  view returns (uint256[])
566     {
567         uint plyrID = getPlayerID(_addr);
568 
569         return (histories_[plyrID][_rID]);
570     }
571 }