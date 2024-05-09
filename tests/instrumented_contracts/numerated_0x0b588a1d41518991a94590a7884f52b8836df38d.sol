1 pragma solidity ^0.4.24;
2 
3 contract FlyToTheMoonEvents {
4 
5     // buy keys during first stage
6     event onFirStage
7     (
8         address indexed player,
9         uint256 indexed rndNo,
10         uint256 keys,
11         uint256 eth,
12         uint256 timeStamp  
13     );
14 
15     // become leader during second stage
16     event onSecStage
17     (
18         address indexed player,
19         uint256 indexed rndNo,
20         uint256 eth,
21         uint256 timeStamp  
22     );
23 
24     // player withdraw
25     event onWithdraw
26     (
27         address indexed player,
28         uint256 indexed rndNo,
29         uint256 eth,
30         uint256 timeStamp
31     );
32 
33     // award
34     event onAward
35     (
36         address indexed player,
37         uint256 indexed rndNo,
38         uint256 eth,
39         uint256 timeStamp
40     );
41 }
42 
43 contract FlyToTheMoon is FlyToTheMoonEvents {
44     using SafeMath for *;
45     using KeysCalc for uint256;
46 
47     struct Round {
48         uint256 eth;        // total eth
49         uint256 keys;       // total keys
50         uint256 startTime;  // end time
51         uint256 endTime;    // end time
52         address leader;     // leader
53         uint256 lastPrice;  // The latest price for the second stage
54         bool award;         // has been accept
55     }
56 
57     struct PlayerRound {
58         uint256 eth;        // eth player has added to round
59         uint256 keys;       // keys
60         uint256 withdraw;   // how many eth has been withdraw
61     }
62 
63     uint256 public rndNo = 1;                                   // current round number
64     uint256 public totalEth = 0;                                // total eth in all round
65 
66     uint256 constant private rndFirStage_ = 12 hours;           // round timer at first stage
67     uint256 constant private rndSecStage_ = 12 hours;           // round timer at second stage
68 
69     mapping (uint256 => Round) public round_m;                  // (rndNo => Round)
70     mapping (uint256 => mapping (address => PlayerRound)) public playerRound_m;   // (rndNo => addr => PlayerRound)
71 
72     address public owner;               // owner address
73     uint256 public ownerWithdraw = 0;   // how many eth has been withdraw by owner
74 
75     constructor()
76         public
77     {
78         round_m[1].startTime = now;
79         round_m[1].endTime = now + rndFirStage_;
80 
81         owner = msg.sender;
82     }
83 
84     /**
85      * @dev prevents contracts from interacting
86      */
87     modifier onlyHuman() 
88     {
89         address _addr = msg.sender;
90         uint256 _codeLength;
91         
92         assembly {_codeLength := extcodesize(_addr)}
93         require(_codeLength == 0, "sorry humans only");
94         _;
95     }
96     
97     /**
98      * @dev sets boundaries for incoming tx 
99      */
100     modifier isWithinLimits(uint256 _eth) 
101     {
102         require(_eth >= 1000000000, "pocket lint: not a valid currency");
103         require(_eth <= 100000000000000000000000, "no vitalik, no");
104         _;    
105     }
106 
107     /**
108      * @dev only owner
109      */
110     modifier onlyOwner() 
111     {
112         require(owner == msg.sender, "only owner can do it");
113         _;    
114     }
115 
116     /**
117      * @dev play
118      */
119     function()
120         onlyHuman()
121         isWithinLimits(msg.value)
122         public
123         payable
124     {
125         uint256 _eth = msg.value;
126         uint256 _now = now;
127         uint256 _rndNo = rndNo;
128         uint256 _ethUse = msg.value;
129 
130         // start next round?
131         if (_now > round_m[_rndNo].endTime)
132         {
133             _rndNo = _rndNo.add(1);
134             rndNo = _rndNo;
135             round_m[_rndNo].startTime = _now;
136             round_m[_rndNo].endTime = _now + rndFirStage_;
137         }
138 
139         // first or second stage
140         if (round_m[_rndNo].keys < 10000000000000000000000000)
141         {
142             // first stage
143             uint256 _keys = (round_m[_rndNo].eth).keysRec(_eth);
144             // keys number 10,000,000, enter the second stage
145             if (_keys.add(round_m[_rndNo].keys) >= 10000000000000000000000000)
146             {
147                 _keys = (10000000000000000000000000).sub(round_m[_rndNo].keys);
148 
149                 if (round_m[_rndNo].eth >= 8562500000000000000000)
150                 {
151                     _ethUse = 0;
152                 } else {
153                     _ethUse = (8562500000000000000000).sub(round_m[_rndNo].eth);
154                 }
155 
156                 if (_eth > _ethUse)
157                 {
158                     // refund
159                     msg.sender.transfer(_eth.sub(_ethUse));
160                 } else {
161                     // fix
162                     _ethUse = _eth;
163                 }
164             }
165 
166             // if they bought at least 1 whole key
167             if (_keys >= 1000000000000000000)
168             {
169                 round_m[_rndNo].endTime = _now + rndFirStage_;
170                 round_m[_rndNo].leader = msg.sender;
171             }
172 
173             // update playerRound
174             playerRound_m[_rndNo][msg.sender].keys = _keys.add(playerRound_m[_rndNo][msg.sender].keys);
175             playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
176 
177             // update round
178             round_m[_rndNo].keys = _keys.add(round_m[_rndNo].keys);
179             round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
180 
181             // update global variable
182             totalEth = _ethUse.add(totalEth);
183 
184             // event
185             emit FlyToTheMoonEvents.onFirStage
186             (
187                 msg.sender,
188                 _rndNo,
189                 _keys,
190                 _ethUse,
191                 _now
192             );
193         } else {
194             // second stage
195             // no more keys
196             // lastPrice + 0.1Ether <= newPrice <= lastPrice + 10Ether
197             uint256 _lastPrice = round_m[_rndNo].lastPrice;
198             uint256 _maxPrice = (10000000000000000000).add(_lastPrice);
199             // less than (lastPrice + 0.1Ether) ?
200             require(_eth >= (100000000000000000).add(_lastPrice), "Need more Ether");
201             // more than (lastPrice + 10Ether) ?
202             if (_eth > _maxPrice)
203             {
204                 _ethUse = _maxPrice;
205                 // refund
206                 msg.sender.transfer(_eth.sub(_ethUse));
207             }
208 
209             round_m[_rndNo].endTime = _now + rndSecStage_;
210             round_m[_rndNo].leader = msg.sender;
211             round_m[_rndNo].lastPrice = _ethUse;
212 
213             // update playerRound
214             playerRound_m[_rndNo][msg.sender].eth = _ethUse.add(playerRound_m[_rndNo][msg.sender].eth);
215 
216             // update round
217             round_m[_rndNo].eth = _ethUse.add(round_m[_rndNo].eth);
218 
219             // update global variable
220             totalEth = _ethUse.add(totalEth);
221 
222             // event
223             emit FlyToTheMoonEvents.onSecStage
224             (
225                 msg.sender,
226                 _rndNo,
227                 _ethUse,
228                 _now
229             );
230         }
231     }
232 
233     /**
234      * @dev withdraws earnings by rndNo.
235      * 0x528ce7de
236      * 0x528ce7de0000000000000000000000000000000000000000000000000000000000000001
237      */
238     function withdrawByRndNo(uint256 _rndNo)
239         onlyHuman()
240         public
241     {
242         require(_rndNo <= rndNo, "You're running too fast");
243         uint256 _total = (((round_m[_rndNo].eth).mul(playerRound_m[_rndNo][msg.sender].keys)).mul(60) / ((round_m[_rndNo].keys).mul(100)));
244         uint256 _withdrawed = playerRound_m[_rndNo][msg.sender].withdraw;
245         require(_total > _withdrawed, "No need to withdraw");
246         uint256 _ethOut = _total.sub(_withdrawed);
247         playerRound_m[_rndNo][msg.sender].withdraw = _total;
248         msg.sender.transfer(_ethOut);
249 
250         // event
251         emit FlyToTheMoonEvents.onWithdraw
252         (
253             msg.sender,
254             _rndNo,
255             _ethOut,
256             now
257         );
258     }
259 
260     /**
261      * @dev Award by rndNo.
262      * 0x80ec35ff
263      * 0x80ec35ff0000000000000000000000000000000000000000000000000000000000000001
264      */
265     function awardByRndNo(uint256 _rndNo)
266         onlyHuman()
267         public
268     {
269         require(_rndNo <= rndNo, "You're running too fast");
270         require(now > round_m[_rndNo].endTime, "Wait patiently");
271         require(round_m[_rndNo].leader == msg.sender, "The prize is not yours");
272         require(round_m[_rndNo].award == false, "Can't get prizes repeatedly");
273 
274         uint256 _ethOut = ((round_m[_rndNo].eth).mul(35) / (100));
275         round_m[_rndNo].award = true;
276         msg.sender.transfer(_ethOut);
277 
278         // event
279         emit FlyToTheMoonEvents.onAward
280         (
281             msg.sender,
282             _rndNo,
283             _ethOut,
284             now
285         );
286     }
287 
288     /**
289      * @dev fee withdraw to owner, everyone can do it.
290      * 0x6561e6ba
291      */
292     function feeWithdraw()
293         onlyHuman()
294         public
295     {
296         uint256 _total = (totalEth.mul(5) / (100));
297         uint256 _withdrawed = ownerWithdraw;
298         require(_total > _withdrawed, "No need to withdraw");
299         ownerWithdraw = _total;
300         owner.transfer(_total.sub(_withdrawed));
301     }
302 
303     /**
304      * @dev change owner.
305      */
306     function changeOwner(address newOwner)
307         onlyOwner()
308         public
309     {
310         owner = newOwner;
311     }
312 
313     /**
314      * @dev returns all current round info needed for front end
315      * 0x747dff42
316      * @return round id 
317      * @return total eth for round
318      * @return total keys for round 
319      * @return time round started
320      * @return time round ends
321      * @return current leader
322      * @return lastest price
323      * @return current key price
324      */
325     function getCurrentRoundInfo()
326         public 
327         view 
328         returns(uint256, uint256, uint256, uint256, uint256, address, uint256, uint256)
329     {
330 
331         uint256 _rndNo = rndNo;
332         
333         return (
334             _rndNo,
335             round_m[_rndNo].eth,
336             round_m[_rndNo].keys,
337             round_m[_rndNo].startTime,
338             round_m[_rndNo].endTime,
339             round_m[_rndNo].leader,
340             round_m[_rndNo].lastPrice,
341             getBuyPrice()
342         );
343     }
344     
345     /**
346      * @dev return the price buyer will pay for next 1 individual key during first stage.
347      * 0x018a25e8
348      * @return price for next key bought (in wei format)
349      */
350     function getBuyPrice()
351         public 
352         view 
353         returns(uint256)
354     {
355         uint256 _rndNo = rndNo;
356         uint256 _now = now;
357         
358         // start next round?
359         if (_now > round_m[_rndNo].endTime)
360         {
361             return (75000000000000);
362         }
363         if (round_m[_rndNo].keys < 10000000000000000000000000)
364         {
365             return ((round_m[_rndNo].keys.add(1000000000000000000)).ethRec(1000000000000000000));
366         }
367         //second stage
368         return (0);
369     }
370 }
371 
372 library KeysCalc {
373     using SafeMath for *;
374     /**
375      * @dev calculates number of keys received given X eth 
376      * @param _curEth current amount of eth in contract 
377      * @param _newEth eth being spent
378      * @return amount of ticket purchased
379      */
380     function keysRec(uint256 _curEth, uint256 _newEth)
381         internal
382         pure
383         returns (uint256)
384     {
385         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
386     }
387     
388     /**
389      * @dev calculates amount of eth received if you sold X keys 
390      * @param _curKeys current amount of keys that exist 
391      * @param _sellKeys amount of keys you wish to sell
392      * @return amount of eth received
393      */
394     function ethRec(uint256 _curKeys, uint256 _sellKeys)
395         internal
396         pure
397         returns (uint256)
398     {
399         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
400     }
401 
402     /**
403      * @dev calculates how many keys would exist with given an amount of eth
404      * @param _eth eth "in contract"
405      * @return number of keys that would exist
406      */
407     function keys(uint256 _eth) 
408         internal
409         pure
410         returns(uint256)
411     {
412         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
413     }
414     
415     /**
416      * @dev calculates how much eth would be in contract given a number of keys
417      * @param _keys number of keys "in contract" 
418      * @return eth that would exists
419      */
420     function eth(uint256 _keys) 
421         internal
422         pure
423         returns(uint256)  
424     {
425         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
426     }
427 }
428 
429 /**
430  * @title SafeMath
431  * @dev Math operations with safety checks that throw on error
432  * - added sqrt
433  * - added sq
434  * - added pwr 
435  * - changed asserts to requires with error log outputs
436  * - removed div, its useless
437  */
438 library SafeMath {
439     
440     /**
441     * @dev Multiplies two numbers, throws on overflow.
442     */
443     function mul(uint256 a, uint256 b) 
444         internal 
445         pure 
446         returns (uint256 c) 
447     {
448         if (a == 0) {
449             return 0;
450         }
451         c = a * b;
452         require(c / a == b, "SafeMath mul failed");
453         return c;
454     }
455 
456     /**
457     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
458     */
459     function sub(uint256 a, uint256 b)
460         internal
461         pure
462         returns (uint256) 
463     {
464         require(b <= a, "SafeMath sub failed");
465         return a - b;
466     }
467 
468     /**
469     * @dev Adds two numbers, throws on overflow.
470     */
471     function add(uint256 a, uint256 b)
472         internal
473         pure
474         returns (uint256 c) 
475     {
476         c = a + b;
477         require(c >= a, "SafeMath add failed");
478         return c;
479     }
480     
481     /**
482      * @dev gives square root of given x.
483      */
484     function sqrt(uint256 x)
485         internal
486         pure
487         returns (uint256 y) 
488     {
489         uint256 z = ((add(x,1)) / 2);
490         y = x;
491         while (z < y) 
492         {
493             y = z;
494             z = ((add((x / z),z)) / 2);
495         }
496     }
497     
498     /**
499      * @dev gives square. multiplies x by x
500      */
501     function sq(uint256 x)
502         internal
503         pure
504         returns (uint256)
505     {
506         return (mul(x,x));
507     }
508     
509     /**
510      * @dev x to the power of y 
511      */
512     function pwr(uint256 x, uint256 y)
513         internal 
514         pure 
515         returns (uint256)
516     {
517         if (x==0)
518             return (0);
519         else if (y==0)
520             return (1);
521         else 
522         {
523             uint256 z = x;
524             for (uint256 i=1; i < y; i++)
525                 z = mul(z,x);
526             return (z);
527         }
528     }
529 }