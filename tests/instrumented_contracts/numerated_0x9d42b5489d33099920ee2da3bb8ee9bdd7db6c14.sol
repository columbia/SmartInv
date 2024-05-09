1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
4   event Winner(address winner, uint256 pool, address revealer);
5   event Buy(address buyer, uint256 keys, uint256 cost);
6   event Sell(address from, uint256 price, uint256 count);
7   event Bought(address buyer, address from, uint256 amount, uint256 price);
8 }
9 
10 contract F3d is F3Devents {
11   using SafeMath for *;
12 
13   
14   uint256 public a;    // key price parameter                    15825000
15   uint256 public b;    // key price parameter                    749999139625000
16 
17   uint256 public ta;   // percentage goes to pool                37.5
18   uint256 public tb;   // percentage goes to split               38.5
19   uint256 public tc;   // percentage goes to ref1                15
20   uint256 public td;   // percentage goes to ref2                5
21   uint256 public te;   // percentage goes to owner               4
22 
23   uint256 public wa;   // percentage of pool goes to winner      50
24   uint256 public wb;   // percentage of pool goes to next pool   16.6
25   uint256 public wc;   // percentage of pool goes to finalizer   0.5
26   uint256 public wd;   // percentage of pool goes to owner       2.6
27   uint256 public we;   // percentage of pool goes to split       30.3
28 
29   uint256 public maxTimeRemain;                     //           4 * 60 * 60
30   uint256 public timeGap;                           //           5 * 60
31   
32   uint256 public soldKeys;                          //           0
33 
34   uint256 public decimals = 1000000;
35   
36   bool public pause;
37   address public owner;
38   address public admin;
39 
40   PlayerStatus[] public players;
41   mapping(address => uint256) public playerIds;
42   mapping(uint256 => Round) public rounds;
43   mapping(uint256 => mapping (uint256 => PlayerRound)) public playerRoundData;
44   uint256 public currentRound;
45   
46   struct PlayerStatus {
47     address addr;          //player addr
48     uint256 wallet;        //get from spread
49     uint256 affiliate;     //get from reference
50     uint256 win;           //get from winning
51     uint256 lrnd;          //last round played
52     uint256 referer;       //who introduced this player
53   }
54   
55   struct PlayerRound {
56       uint256 eth;         //eth player added to this round
57       uint256 keys;        //keys player bought in this round
58       uint256 mask;        //player mask in this round
59   }
60   
61   struct Round {
62       uint256 eth;         //eth to this round
63       uint256 keys;        //keys sold in this round
64       uint256 mask;        //mask of this round
65       address winner;      //winner of this round
66       uint256 pool;        //the amount of pool when ends
67       uint256 endTime;     //the end time
68   }
69   
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   modifier whenNotPaused() {
76     require(!pause);
77     _;
78   }
79 
80   modifier onlyAdmin() {
81       require(msg.sender == admin);
82       _;
83   }
84   
85   function setPause(bool _pause) onlyAdmin public {
86     pause = _pause;
87   }
88 
89   constructor(uint256 _a, uint256 _b, 
90   uint256 _ta, uint256 _tb, uint256 _tc, uint256 _td, uint256 _te,
91   uint256 _wa, uint256 _wb, uint256 _wc, uint256 _wd, uint256 _we,
92   uint256 _maxTimeRemain, uint256 _gap, address _owner) public {
93     a = _a;
94     b = _b;
95 
96     ta = _ta;
97     tb = _tb;
98     tc = _tc;
99     td = _td;
100     te = _te;
101     
102     wa = _wa;
103     wb = _wb;
104     wc = _wc;
105     wd = _wd;
106     we = _we;
107     
108     // split less than 100%
109     require(ta.add(tb).add(tc).add(td).add(te) == 1000);
110     require(wa.add(wb).add(wc).add(wd).add(we) == 1000);
111 
112     owner = _owner;
113 
114     // start from first round
115     currentRound = 1;
116     rounds[currentRound] = Round(0, 0, 0, owner, 0, block.timestamp.add(_maxTimeRemain));
117     maxTimeRemain = _maxTimeRemain;
118     timeGap = _gap;
119     
120     admin = msg.sender;
121     // the first player is the owner
122     players.push(PlayerStatus(
123         owner,
124         0,
125         0,
126         0,
127         0,
128         0));
129   }
130 
131   // return the price for nth key  n = keys / decimals
132   function Price(uint256 n) public view returns (uint256) {
133     return n.mul(a).add(b);
134   }
135 
136   function updatePlayer(uint256 _pID) private {
137       if(players[_pID].lrnd != 0) {
138           updateWallet(_pID, players[_pID].lrnd);
139       }
140       players[_pID].lrnd = currentRound;
141   }
142   
143   function updateWallet(uint256 _pID, uint256 _round) private {
144       uint256 earnings = calculateMasked(_pID, _round);
145       if (earnings > 0) {
146           players[_pID].wallet = earnings.add(players[_pID].wallet);
147           playerRoundData[_pID][_round].mask = earnings.add(playerRoundData[_pID][_round].mask);
148       }
149   }
150   
151   function profit() public view returns (uint256) {
152       uint256 id = playerIds[msg.sender];
153       if (id == 0 && msg.sender != owner) {
154           return 0;
155       }
156       PlayerStatus memory player = players[id];
157       
158       return player.wallet.add(player.affiliate).add(player.win).add(calculateMasked(id, player.lrnd));
159   }
160   
161   function calculateMasked(uint256 _pID, uint256 _round) private view returns (uint256) {
162       PlayerRound memory roundData = playerRoundData[_pID][_round];
163       return rounds[_round].mask.mul(roundData.keys).sub(roundData.mask);
164   }
165   
166   function registerUserIfNeeded(uint256 ref) public {
167       if (msg.sender != owner) {
168           if (playerIds[msg.sender] == 0) {
169               playerIds[msg.sender] = players.length;
170               if (ref >= players.length) {
171                   ref = 0;
172               }
173               
174               players.push(PlayerStatus(
175                   msg.sender,
176                   0,
177                   0,
178                   0,
179                   0,
180                   ref));
181           }
182       }
183   }
184   
185   // anyone can finalize a round
186   function finalize(uint256 ref) public {
187       Round storage lastOne = rounds[currentRound];
188       // round must be finished
189       require(block.timestamp > lastOne.endTime);
190       
191       // register the user if necessary
192       registerUserIfNeeded(ref);
193 
194       // new round has started
195       currentRound = currentRound.add(1);
196       Round storage _round = rounds[currentRound];
197       _round.endTime = block.timestamp.add(maxTimeRemain);
198       _round.winner = owner;            
199       // save the round data
200       uint256 money = lastOne.pool;
201       
202       if (money == 0) {
203           // nothing happend in last round
204           return;
205       }
206       // to pool
207       _round.pool = money.mul(wb) / 1000;
208 
209       // to winner
210       uint256 toWinner = money.mul(wa) / 1000;
211       players[playerIds[lastOne.winner]].win = toWinner.add(players[playerIds[lastOne.winner]].win);
212       
213       // to revealer
214       uint256 toRevealer = money.mul(wc) / 1000;
215       uint256 revealId = playerIds[msg.sender];
216       
217       // self reveal, no awards
218       if (msg.sender == lastOne.winner) {
219           revealId = 0;
220       }
221       
222       players[revealId].win = players[revealId].win.add(toRevealer);
223       
224       uint256 toOwner = money.mul(wd) / 1000;
225       players[0].win = players[0].win.add(toOwner);
226       
227       uint256 split = money.sub(_round.pool).sub(toWinner).sub(toRevealer).sub(toOwner);
228       
229       if (lastOne.keys != 0) {
230           lastOne.mask = lastOne.mask.add(split / lastOne.keys);
231           // gather the dust
232           players[0].wallet = players[0].wallet.add(split.sub((split/lastOne.keys) * lastOne.keys));
233       } else {
234           // last round no one bought any keys, sad
235           // put the split into next round
236           _round.pool = split.add(_round.pool);
237       }
238   }
239   
240   function price(uint256 key) public view returns (uint256) {
241       return a.mul(key).add(b);
242   }
243   
244   function ethForKey(uint256 _keys) public view returns (uint256) {
245       Round memory current = rounds[currentRound];
246       uint256 c_key = (current.keys / decimals);
247       
248       // in (a, a + 1], we use price(a + 1)
249       if (c_key.mul(decimals) != current.keys) {
250           c_key = c_key.add(1);
251       }
252       
253       uint256 _price = price(c_key);
254       uint256 remainKeys = c_key.mul(decimals).sub(current.keys);
255 
256       if (remainKeys >= _keys) {
257           return _price.mul(_keys) / decimals;
258       } 
259       
260       uint256 costEth = _price.mul(_keys) / decimals;
261       _keys = _keys.sub(remainKeys);
262       
263       while(_keys >= decimals) {
264           c_key = c_key.add(1);
265           _price = price(c_key);
266           costEth = costEth.add(_price);
267           _keys = _keys.sub(decimals);
268       }
269     
270       c_key = c_key.add(1);
271       _price = price(c_key);
272 
273       costEth = costEth.add(_price.mul(_keys) / decimals);
274       return costEth;
275   }
276 
277   // the keys that one could buy at a stage using _eth
278   function keys(uint256 _eth) public view returns (uint256) {
279       Round memory current = rounds[currentRound];
280       
281       uint256 c_key = (current.keys / decimals).add(1);
282       uint256 _price = price(c_key);
283       uint256 remainKeys = c_key.mul(decimals).sub(current.keys);
284       uint256 remain =remainKeys.mul(_price) / decimals;
285       
286       if (remain >= _eth) {
287           return _eth.mul(decimals) / _price;
288       }
289       uint256 boughtKeys = remainKeys;
290       _eth = _eth.sub(remain);
291       while(true) {
292           c_key = c_key.add(1);
293           _price = price(c_key);
294           if (_price <= _eth) {
295               // buy a whole unit
296               boughtKeys = boughtKeys.add(decimals);
297               _eth = _eth.sub(_price);
298           } else {
299               boughtKeys = boughtKeys.add(_eth.mul(decimals) / _price);
300               break;
301           }
302       }
303       return boughtKeys;
304   }
305   
306   // _pID spent _eth to buy keys in _round
307   function core(uint256 _round, uint256 _pID, uint256 _eth) internal {
308       Round memory current = rounds[currentRound];
309 
310       // new to this round
311       if (playerRoundData[_pID][_round].keys == 0) {
312           updatePlayer(_pID);
313       }
314       
315       if (block.timestamp > current.endTime) {
316           //we need to do finalzing
317           finalize(players[_pID].referer);
318           
319           //new round generated, we need to update the user status to the new round 
320           updatePlayer(_pID);
321       }
322       
323       // retrive the current round obj again, in case it changed
324       Round storage current_now = rounds[currentRound];
325       
326       // calculate the keys that he could buy
327       uint256 _keys = keys(_eth);
328       
329       if (_keys <= 0) {
330           // put the eth to the sender
331           // sorry, you're bumped
332           players[_pID].wallet = _eth.add(players[_pID].wallet);
333           return;
334       }
335 
336       if (_keys >= decimals) {
337           // buy at least one key to be the winner 
338           current_now.winner = players[_pID].addr;
339           current_now.endTime = current_now.endTime.add(timeGap);
340           if (current_now.endTime.sub(block.timestamp) > maxTimeRemain) {
341               current_now.endTime = block.timestamp.add(maxTimeRemain);
342           }
343       }
344       
345       //now we do the money distribute
346       uint256 toOwner = _eth.sub(_eth.mul(ta) / 1000);
347       toOwner = toOwner.sub(_eth.mul(tb) / 1000);
348       toOwner = toOwner.sub(_eth.mul(tc) / 1000);
349       toOwner = toOwner.sub(_eth.mul(td) / 1000);
350       
351       // to pool
352       current_now.pool = (_eth.mul(ta) / 1000).add(current_now.pool);
353       
354       if (current_now.keys == 0) {
355           // current no keys to split, send to owner
356           toOwner = toOwner.add((_eth.mul(tb) / 1000));
357           players[0].wallet = toOwner.add(players[0].wallet);
358       } else {
359           current_now.mask = current_now.mask.add((_eth.mul(tb) / 1000) / current_now.keys);
360           // dust to owner;
361           // since the _eth will > 0, so the division is ok
362           uint256 dust = (_eth.mul(tb) / 1000).sub( _eth.mul(tb) / 1000 / current_now.keys * current_now.keys );
363           players[0].wallet = toOwner.add(dust).add(players[0].wallet);
364       }
365       // the split doesnt include keys that the user just bought
366       playerRoundData[_pID][currentRound].keys = _keys.add(playerRoundData[_pID][currentRound].keys);
367       current_now.keys = _keys.add(current_now.keys);
368       current_now.eth = _eth.add(current_now.eth);
369 
370       // for the new keys, remove the user's free earnings
371       playerRoundData[_pID][currentRound].mask = current_now.mask.mul(_keys).add(playerRoundData[_pID][currentRound].mask);
372       
373       // to ref 1, 2
374       uint256 referer1 = players[_pID].referer;
375       uint256 referer2 = players[referer1].referer;
376       players[referer1].affiliate = (_eth.mul(tc) / 1000).add(players[referer1].affiliate);
377       players[referer2].affiliate = (_eth.mul(td) / 1000).add(players[referer2].affiliate);
378   }
379   
380   // calculate the keys that the user can buy with specified amount of eth
381   // return the eth left
382   function BuyKeys(uint256 ref) payable whenNotPaused public {
383       registerUserIfNeeded(ref);
384       core(currentRound, playerIds[msg.sender], msg.value);
385   }
386 
387   function ReloadKeys(uint256 value, uint256 ref) whenNotPaused public {
388       registerUserIfNeeded(ref);
389       players[playerIds[msg.sender]].wallet = retrieveEarnings().sub(value);
390       core(currentRound, playerIds[msg.sender], value);
391   }
392   
393   function retrieveEarnings() internal returns (uint256) {
394       uint256 id = playerIds[msg.sender];
395       updatePlayer(id);
396       PlayerStatus storage player = players[id];
397       
398       uint256 earnings = player.wallet.add(player.affiliate).add(player.win);
399       
400       if (earnings == 0) {
401           return;
402       }
403       
404       player.wallet = 0;
405       player.affiliate = 0;
406       player.win = 0;
407       return earnings;
408   }
409   
410   // withdrawal all the earning of the game
411   function withdrawal(uint256 ref) whenNotPaused public {
412       registerUserIfNeeded(ref);
413       
414       uint256 earnings = retrieveEarnings();
415       if (earnings == 0) {
416           return;
417       }
418       msg.sender.transfer(earnings);
419   }
420 
421   function playerCount() public view returns (uint256) {
422       return players.length;
423   }
424   
425   function register(uint256 ref) public whenNotPaused {
426     registerUserIfNeeded(ref);
427   }
428   
429   function remainTime() public view returns (uint256) {
430       if (rounds[currentRound].endTime <= block.timestamp) {
431           return 0;
432       } else {
433           return rounds[currentRound].endTime - block.timestamp;
434       }
435   }
436 }
437 
438 
439 /**
440  * @title SafeMath v0.1.9
441  * @dev Math operations with safety checks that throw on error
442  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
443  * - added sqrt
444  * - added sq
445  * - added pwr 
446  * - changed asserts to requires with error log outputs
447  * - removed div, its useless
448  */
449 library SafeMath {
450     
451     /**
452     * @dev Multiplies two numbers, throws on overflow.
453     */
454     function mul(uint256 a, uint256 b) 
455         internal 
456         pure 
457         returns (uint256 c) 
458     {
459         if (a == 0) {
460             return 0;
461         }
462         c = a * b;
463         require(c / a == b, "SafeMath mul failed");
464         return c;
465     }
466 
467     /**
468     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
469     */
470     function sub(uint256 a, uint256 b)
471         internal
472         pure
473         returns (uint256) 
474     {
475         require(b <= a, "SafeMath sub failed");
476         return a - b;
477     }
478 
479     /**
480     * @dev Adds two numbers, throws on overflow.
481     */
482     function add(uint256 a, uint256 b)
483         internal
484         pure
485         returns (uint256 c) 
486     {
487         c = a + b;
488         require(c >= a, "SafeMath add failed");
489         return c;
490     }
491 }