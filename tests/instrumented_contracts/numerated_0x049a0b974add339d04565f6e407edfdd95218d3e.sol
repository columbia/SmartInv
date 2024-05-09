1 pragma solidity ^0.4.24;
2 
3 /*
4 * 
5 * FishvsFish Game
6 * A competitive Fish game on Ethereum platform
7 * 
8 */
9 
10 contract vsgame {
11 	using SafeMath for uint256;
12 
13 	/*------------------------------
14                 CONFIGURABLES
15      ------------------------------*/
16     string public name = "FishvsFish Game";
17     string public symbol = "FvF";
18     
19     uint256 public minFee;
20     uint256 public maxFee;
21     uint256 public jackpotDistribution;
22     uint256 public refComm;
23     uint256 public durationRound;
24     uint256 public devFeeRef;
25     uint256 public devFee;
26 
27 
28     bool public activated = false;
29     
30     address public developerAddr;
31     
32     /*------------------------------
33                 DATASETS
34      ------------------------------*/
35     uint256 public rId;
36 
37     mapping (address => Indatasets.Player) public player;
38     mapping (uint256 => Indatasets.Round) public round;
39     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerAmountDeposit;
40 	mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerAmountDepositReal;
41 	mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public playerRoundAmount;
42 
43 
44     /*------------------------------
45                 PUBLIC FUNCTIONS
46     ------------------------------*/
47 
48     constructor()
49         public
50     {
51         developerAddr = msg.sender;
52     }
53 
54     /*------------------------------
55                 MODIFIERS
56      ------------------------------*/
57 
58     modifier senderVerify() {
59         require (msg.sender == tx.origin);
60         _;
61     }
62 
63     modifier amountVerify() {
64         if(msg.value < 10000000000000000){
65             developerAddr.transfer(msg.value);
66         }else{
67             require(msg.value >= 10000000000000000);
68             _;
69         }
70     }
71 
72     modifier playerVerify() {
73         require(player[msg.sender].active == true, "Player isn't active.");
74         _;
75     }
76 
77     modifier isActivated() {
78         require(activated == true, "Contract hasn't been activated yet."); 
79         _;
80     }
81 
82 
83     /**
84      * Activation of contract with settings
85      */
86     function activate()
87         public
88     {
89         require(msg.sender == developerAddr);
90         require(activated == false, "Contract already activated");
91         
92 		minFee = 5;
93 		maxFee = 50;
94 		jackpotDistribution = 70;
95 		refComm = 25;
96 		durationRound = 43200;
97 		rId = 1;
98 		activated = true;
99         devFeeRef = 100;
100         devFeeRef = devFeeRef.sub(jackpotDistribution).sub(refComm);
101         devFee = 100;
102         devFee = devFee.sub(jackpotDistribution);
103     
104 		// Initialise first round
105 
106         round[rId].start = now;
107         round[rId].end = now.add(172800);
108         round[rId].ended = false;
109         round[rId].winner = 0;
110     }
111 
112 
113     /**
114      * Invest into red or green fish
115      */
116 
117     function invest(uint256 _side)
118     	isActivated()
119         amountVerify()
120         senderVerify()
121     	public
122         payable
123     {
124     	uint256 _feeUser = 0;
125     	if(_side == 1 || _side == 2){
126     		if(now < round[rId].end){
127     			_feeUser = buyFish(_side);
128 
129                 round[rId].devFee = round[rId].devFee.add((_feeUser.mul(devFee)).div(100));
130     		} else if(now >= round[rId].end){
131     			startRound();
132     			_feeUser = buyFish(_side);
133 
134                 round[rId].devFee = round[rId].devFee.add((_feeUser.mul(devFee)).div(100));
135     		}
136     	} else {
137     		msg.sender.transfer(msg.value);
138     	}
139     }
140 
141     /**
142      * Invest into red or green fish
143      */
144 
145     function invest(uint256 _side, address _refer)
146         isActivated()
147         amountVerify()
148         senderVerify()
149         public
150         payable
151     {
152         uint256 _feeUser = 0;
153         if(_side == 1 || _side == 2){
154             if(now < round[rId].end){
155                 _feeUser = buyFish(_side);
156                 processRef(_feeUser, _refer);
157             } else if(now >= round[rId].end){
158                 startRound();
159                 _feeUser = buyFish(_side);
160                 processRef(_feeUser, _refer);
161             }
162         } else {
163             msg.sender.transfer(msg.value);
164         }
165     }
166 
167     /**
168      * Buy into Fish
169      */
170 
171     function buyFish(uint256 _side)
172     	private
173         returns (uint256)
174     {
175     	uint256 _rId = rId;
176     	uint256 _amount = msg.value;
177 
178         if(player[msg.sender].active == false){
179             player[msg.sender].active = true;
180             player[msg.sender].withdrawRid = _rId;
181         }
182 
183         uint256 _feeUser = (_amount.mul(getRoundFee())).div(1000000);
184         uint256 _depositUser = _amount.sub(_feeUser);
185 
186     	playerAmountDeposit[_rId][_side][msg.sender] = playerAmountDeposit[_rId][_side][msg.sender].add(_depositUser);
187     	playerAmountDepositReal[_rId][_side][msg.sender] = playerAmountDepositReal[_rId][_side][msg.sender].add(_amount);
188 
189     	if(_side == 1){
190     		round[_rId].amount1 = round[_rId].amount1.add(_depositUser);
191     		if(playerRoundAmount[_rId][1][msg.sender] == 0){
192     			playerRoundAmount[_rId][1][msg.sender]++;
193     			round[_rId].players1++;
194     		}
195     	} else if(_side == 2){
196     		round[_rId].amount2 = round[_rId].amount2.add(_depositUser);
197     		if(playerRoundAmount[_rId][2][msg.sender] == 0){
198     			playerRoundAmount[_rId][2][msg.sender]++;
199     			round[_rId].players2++;
200     		}
201     	}
202 
203     	// jackpot distribution
204     	round[_rId+1].jackpotAmount = round[_rId+1].jackpotAmount.add((_feeUser.mul(jackpotDistribution)).div(100));
205         return _feeUser;
206    	}
207 
208     /**
209      * Referral Fee and Dev Fee Process
210      */
211 
212     function processRef(uint256 _feeUser, address _refer)
213         private
214     {
215         if(_refer != 0x0000000000000000000000000000000000000000 && _refer != msg.sender && player[_refer].active == true){ // referral
216             player[_refer].refBalance = player[_refer].refBalance.add((_feeUser.mul(refComm)).div(100));
217             round[rId].devFee = round[rId].devFee.add((_feeUser.mul(devFeeRef)).div(100));
218         } else {
219             round[rId].devFee = round[rId].devFee.add((_feeUser.mul(devFee)).div(100));
220         }
221     }
222 
223    	/**
224    	 * End current round and start a new one
225    	 */
226 
227    	function startRound()
228    		private
229    	{
230    		if(round[rId].amount1 > round[rId].amount2){
231    			round[rId].winner = 1;
232    		} else if(round[rId].amount1 < round[rId].amount2){
233    			round[rId].winner = 2;
234    		} else if(round[rId].amount1 == round[rId].amount2){
235    			round[rId].winner = 3;
236    		}
237 
238    		developerAddr.transfer(round[rId].devFee);
239    		round[rId].ended = true;
240 
241    		rId++;
242 
243    		round[rId].start = now;
244    		round[rId].end = now.add(durationRound);
245    		round[rId].ended = false;
246    		round[rId].winner = 0;
247    	}
248 
249     /**
250      * Get player's balance
251      */
252 
253 
254    	function getPlayerBalance(address _player)
255    		public
256    		view
257    		returns(uint256)
258    	{
259    		uint256 userWithdrawRId = player[_player].withdrawRid;
260    		uint256 potAmount = 0;
261    		uint256 userSharePercent = 0;
262    		uint256 userSharePot = 0;
263    		uint256 userDeposit = 0;
264 
265    		uint256 userBalance = 0;
266 
267    		for(uint256 i = userWithdrawRId; i < rId; i++){
268    			if(round[i].ended == true){
269                 potAmount = round[i].amount1.add(round[i].amount2).add(round[i].jackpotAmount);
270    				if(round[i].winner == 1 && playerAmountDeposit[i][1][_player] > 0){
271    					userSharePercent = playerAmountDeposit[i][1][_player].mul(1000000).div(round[i].amount1);
272    				} else if(round[i].winner == 2 && playerAmountDeposit[i][2][_player] > 0){
273    					userSharePercent = playerAmountDeposit[i][2][_player].mul(1000000).div(round[i].amount2);
274                 } else if(round[i].winner == 3){
275    					if(playerAmountDeposit[i][1][_player] > 0 || playerAmountDeposit[i][2][_player] > 0){
276    						userDeposit = playerAmountDeposit[i][1][_player].add(playerAmountDeposit[i][2][_player]);
277    						userBalance = userBalance.add(userDeposit);
278    					}
279    				}
280                 if(round[i].winner == 1 || round[i].winner == 2){
281                     userSharePot = potAmount.mul(userSharePercent).div(1000000);
282                     userBalance = userBalance.add(userSharePot);
283                     userSharePercent = 0;
284                 }
285    			}
286    		}
287    		return userBalance;
288    	}
289 
290    	/*
291    	 * Return the ref. balance
292    	 */
293 
294    	function getRefBalance(address _player)
295    		public
296    		view
297    		returns (uint256)
298    	{
299    		return player[_player].refBalance;
300    	}
301 
302    	/*
303    	 * Allows the user to withdraw the funds from the unclaimed rounds and the referral commission.
304    	 */
305 
306    	function withdraw()
307         senderVerify()
308         playerVerify()
309         public
310     {
311         require(getRefBalance(msg.sender) > 0 || getPlayerBalance(msg.sender) > 0);
312 
313     	address playerAddress = msg.sender;
314     	uint256 withdrawAmount = 0;
315     	if(getRefBalance(playerAddress) > 0){
316     		withdrawAmount = withdrawAmount.add(getRefBalance(playerAddress));
317     		player[playerAddress].refBalance = 0;
318     	}
319 
320     	if(getPlayerBalance(playerAddress) > 0){
321     		withdrawAmount = withdrawAmount.add(getPlayerBalance(playerAddress));
322     		player[playerAddress].withdrawRid = rId;
323     	}
324     	playerAddress.transfer(withdrawAmount);
325     }
326 
327     /*
328      * Returns the following datas of the user: active, balance, refBalance, withdrawRId
329      */
330 
331     function getPlayerInfo(address _player)
332     	public
333     	view
334     	returns (bool, uint256, uint256, uint256)
335     {
336     	return (player[_player].active, getPlayerBalance(_player), player[_player].refBalance, player[_player].withdrawRid);
337     }
338 
339     /*
340      * Get Round Info
341      */
342 
343     function getRoundInfo(uint256 _rId)
344     	public
345     	view
346     	returns (uint256, uint256, bool, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
347     {
348     	uint256 roundNum = _rId; 
349     	return (round[roundNum].start, round[roundNum].end, round[roundNum].ended, round[roundNum].amount1, round[roundNum].amount2, round[roundNum].players1, round[roundNum].players2, round[roundNum].jackpotAmount, round[roundNum].devFee, round[roundNum].winner);
350     }
351 
352     /*
353      * get users deposit with deducted fees of a specific round a team
354      */ 
355 
356     function getUserDeposit(uint256 _rId, uint256 _side, address _player)
357     	public
358     	view
359     	returns (uint256)
360     {
361     	return playerAmountDeposit[_rId][_side][_player];
362     }
363 
364 
365     /*
366      * get users deposit without deducted fees of a specific round a team
367      */ 
368 
369     function getUserDepositReal(uint256 _rId, uint256 _side, address _player)
370     	public
371     	view
372     	returns (uint256)
373     {
374     	return playerAmountDepositReal[_rId][_side][_player];
375     }
376 
377     /**
378      * Get current round fee
379      */
380 
381 
382     function getRoundFee()
383         public
384         view
385         returns (uint256)
386     {
387         uint256 roundStart = round[rId].start;
388         uint256 _durationRound = 0;
389 
390         if(rId == 1){
391         	_durationRound = 172800;
392         } else {
393         	_durationRound = durationRound;
394         }
395 
396         uint256 remainingTimeInv = now - roundStart;
397         uint256 percentTime = (remainingTimeInv * 10000) / _durationRound;
398         uint256 feeRound = ((maxFee - minFee) * percentTime) + (minFee * 10000);
399 
400         return feeRound;
401     }
402 }
403 
404 library Indatasets {
405 
406 	struct Player {
407 		bool active;			// has user already interacted 
408 		uint256 refBalance; 	// balance of ref. commission
409 		uint256 withdrawRid;	// time of the prev. withdraw
410 	}
411     
412     struct Round {
413         uint256 start;          // time round started
414         uint256 end;            // time round ends/ended
415         bool ended;             // has round end function been ran
416         uint256 amount1;        // Eth received for current round for dog
417         uint256 amount2;        // Eth received for current round for cat
418         uint256 players1;		// total players for dog
419         uint256 players2;		// total players for cat
420         uint256 jackpotAmount;  // total jackpot for current round
421         uint256 devFee;			// collected fees for the dev
422         uint256 winner; 		// winner of the round
423     }
424 }
425 
426 /**
427  * @title SafeMath v0.1.9
428  * @dev Math operations with safety checks that throw on error
429  */
430 library SafeMath {
431     
432     /**
433     * @dev Adds two numbers, throws on overflow.
434     */
435     function add(uint256 a, uint256 b) 
436         internal 
437         pure 
438         returns (uint256) 
439     {
440         uint256 c = a + b;
441         assert(c >= a);
442         return c;
443     }
444     
445     /**
446     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
447     */
448     function sub(uint256 a, uint256 b) 
449         internal 
450         pure 
451         returns (uint256) 
452     {
453         assert(b <= a);
454         return a - b;
455     }
456 
457     /**
458     * @dev Multiplies two numbers, throws on overflow.
459     */
460     function mul(uint256 a, uint256 b) 
461         internal 
462         pure 
463         returns (uint256) 
464     {
465         if (a == 0) {
466             return 0;
467         }
468         uint256 c = a * b;
469         assert(c / a == b);
470         return c;
471     }
472     
473     /**
474     * @dev Integer division of two numbers, truncating the quotient.
475     */
476     function div(uint256 a, uint256 b) 
477         internal 
478         pure 
479         returns (uint256) 
480     {
481         assert(b > 0); // Solidity automatically throws when dividing by 0
482         uint256 c = a / b;
483         assert(a == b * c + a % b); // There is no case in which this doesn't hold
484         return c;
485     }
486     
487     /**
488      * @dev gives square root of given x.
489      */
490     function sqrt(uint256 x)
491         internal
492         pure
493         returns (uint256 y) 
494     {
495         uint256 z = ((add(x,1)) / 2);
496         y = x;
497         while (z < y) 
498         {
499             y = z;
500             z = ((add((x / z),z)) / 2);
501         }
502     }
503     
504     /**
505      * @dev gives square. multiplies x by x
506      */
507     function sq(uint256 x)
508         internal
509         pure
510         returns (uint256)
511     {
512         return (mul(x,x));
513     }
514     
515     /**
516      * @dev x to the power of y 
517      */
518     function pwr(uint256 x, uint256 y)
519         internal 
520         pure 
521         returns (uint256)
522     {
523         if (x==0)
524             return (0);
525         else if (y==0)
526             return (1);
527         else 
528         {
529             uint256 z = x;
530             for (uint256 i=1; i < y; i++)
531                 z = mul(z,x);
532             return (z);
533         }
534     }
535 }