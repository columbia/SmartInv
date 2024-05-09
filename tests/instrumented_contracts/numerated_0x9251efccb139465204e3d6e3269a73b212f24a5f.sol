1 pragma solidity ^0.4.24;
2 
3 contract Pob{
4 
5    using SafeMath for *;
6 
7 //==============================================================================	
8 //Structs
9 //==============================================================================	
10                                                                  	
11 	struct BetItem{
12 		uint256 id;
13 		uint256 betCount;
14 	}
15 	struct Player {
16         address addr;   // player address
17         uint256 aff;    // affiliate vault
18 		uint256 withdraw;
19 		uint256[] purchases;
20 		uint256 totalPosition; // each player cannot have more than 3000 positions
21 		uint256 affId;
22     }
23 	struct Purchase{
24 		uint256 id;
25 		address fromAddress;
26 		uint256 amount;
27 		uint256 positionCount;
28 		uint256 betItemId;
29 	}
30 	
31 //==============================================================================	
32 //Events
33 //==============================================================================	
34 	event EndTx(address buyer, uint256 _eth, uint256 _positionCount);
35 	
36 //==============================================================================	
37 //Constants
38 //==============================================================================	
39 	uint256 constant private MIN_BET = 0.1 ether;  
40 	uint256 constant private VOTE_AMOUNT = 0.05 ether;  
41 	uint256 constant private ITEM_COUNT = 16;  
42 	uint256 constant private MAX_POSITION_PER_PLAYER = 3000;  
43     uint256 constant private PRIZE_WAIT_TIME = 48 hours;     // the prize waiting time after stop receiving bets,
44 															 // used to vote on real result
45 	address constant private DEV_ADDRESS = 0x6472B7931CB311907Df9229BcB3b3f3E2F413c9C;  
46 
47 	address private owner;
48 	uint256 private BET_END_TIME = 1538870400;  
49 	uint256 private PRIZE_END_TIME;
50 
51 	uint256 private lastSumary;
52 
53 	uint256 private purchase_id; // = new position number
54 	uint256 private aff_id = 100;
55 	uint256 public winner_pool_amount;
56 	uint256 public buyer_profit_pool_amount;
57 	uint256 public vote_reward_pool_amount; 
58 	uint256 private result_vote_count;
59 	
60     mapping (uint256 => BetItem) public betItems;     // betItems ( betId)
61     mapping (uint256 => Purchase) public purchases;     // purchases record, id aligns to purchase (id=id+positionCount)
62     mapping (address => Player) public players;     //every buyers info 
63 	mapping (uint256 => address) public aff_to_players; //use to find player
64 	
65     mapping (uint256 => uint256) public keyNumberToValue;     // store previous buyers divids, 
66 															  // keep sum(1/n) based on per position
67     mapping (address => uint256) public resultVotes;     //every address can only vote a ticket (address=>betItemId)
68     mapping (uint256 => uint256) public resultVoteCounts;     //every address can only vote a ticket (betItemId=>count)
69 
70 
71 	constructor() 
72 		public
73 	{
74 		//init items, item start from 1
75 		setPrizeEndTime();
76 		for(uint i=1;i<=ITEM_COUNT;i++){
77 			betItems[i].id=i;
78 		}
79 		owner = msg.sender;
80 	}
81 	function setPrizeEndTime()
82 		private
83 	{
84 		PRIZE_END_TIME = BET_END_TIME + PRIZE_WAIT_TIME;
85 	}
86 	
87 	function buyPosition(uint256 _aff_id,uint256 betItemId)
88 		isNotFinished()
89         isHuman()
90         isWithinLimits(msg.value)
91 		isValidItem(betItemId)
92 		public
93         payable
94 	{
95 		
96 		uint positionCount = uint(msg.value/MIN_BET);	
97 		
98 		require(positionCount>0);
99 		
100 		uint256 _totalPositionCount = players[msg.sender].totalPosition+positionCount;
101 		require(_totalPositionCount<=MAX_POSITION_PER_PLAYER);
102 		
103 		purchase_id = purchase_id.add(positionCount);
104 
105 		
106 		uint256 eth = positionCount.mul(MIN_BET);
107 		
108 		purchases[purchase_id].id = purchase_id;
109 		purchases[purchase_id].fromAddress = msg.sender;
110 		purchases[purchase_id].amount = eth;
111 		purchases[purchase_id].betItemId = betItemId;
112 		purchases[purchase_id].positionCount=positionCount;
113 		
114 		betItems[betItemId].betCount = betItems[betItemId].betCount.add(positionCount);
115 		
116 		players[msg.sender].purchases.push(purchase_id);
117 		players[msg.sender].totalPosition = _totalPositionCount;
118 		if(players[msg.sender].affId==0){
119 			//create aff_id for player
120 			players[msg.sender].affId = aff_id;
121 			aff_to_players[players[msg.sender].affId] = msg.sender;
122 			aff_id = aff_id+1;
123 		}
124 		
125 		// 10% goes to affiliate
126 		uint256 affAmount = eth/10;
127 		addToAffiliate(_aff_id,affAmount);
128 		
129 		//2% goes to dev
130 		players[DEV_ADDRESS].aff = players[DEV_ADDRESS].aff.add(eth/50);
131 		
132 		//50% goes to final POOL
133 		winner_pool_amount=winner_pool_amount.add(eth/2);
134 		
135 		//33% goes to previous buyers
136 		buyer_profit_pool_amount = buyer_profit_pool_amount.add(eth.mul(33)/100);
137 		updateProfit(positionCount);
138 		
139 		//5% goes to reward pool
140 		vote_reward_pool_amount = vote_reward_pool_amount.add(eth/20);		
141 			
142 		emit EndTx(msg.sender,msg.value,positionCount);
143 	}
144 	
145 	function updateProfit(uint _positionCount) 
146 		private
147 	{
148 		require(purchase_id>0);
149 		uint _lastSumary = lastSumary;
150 		for(uint i=0;i<_positionCount;i++){
151 			uint256 _purchase_id = purchase_id.sub(i);
152 			if(_purchase_id!=0){
153 				_lastSumary = _lastSumary.add(calculatePositionProfit(_purchase_id));
154 			}
155 		}
156 		lastSumary = _lastSumary;
157 		keyNumberToValue[purchase_id] = lastSumary;		
158 	}
159 	
160 	function calculatePositionProfit(uint256 currentPurchasedId) 
161 		public 
162 		pure 
163 		returns (uint256)
164 	{
165 		if(currentPurchasedId==0)return 0;
166 		return MIN_BET.mul(33)/100/(currentPurchasedId);
167 	}
168 	
169 	function addToAffiliate(uint256 _aff_id,uint256 affAmount) private{
170 		address _aff_address = aff_to_players[_aff_id];
171 		if(_aff_address!= address(0) && _aff_address!=msg.sender){
172 			players[_aff_address].aff = players[_aff_address].aff.add(affAmount);
173 		}else{
174 			winner_pool_amount=winner_pool_amount.add(affAmount);
175 		}
176 	}
177 	
178 	function getPlayerProfit(address _player)
179 		public 
180 		view 
181 		returns (uint256,uint256,uint256,uint256)
182 	{
183 		uint256 _profit = 0;
184 		for(uint256 i = 0 ;i<players[_player].purchases.length;i++){
185 			_profit = _profit.add(getProfit(players[_player].purchases[i]));
186 		}
187 		
188 		uint256 _winning_number = getWinningNumber();
189 
190 		uint256 _player_winning = getPlayerWinning(_player,_winning_number);
191 		uint256 _player_vote_rewards = getPlayerVoteRewards(_player,_winning_number);
192 		
193 		return (_profit,players[_player].aff,_player_winning,_player_vote_rewards);
194 	}
195 	
196 	function getPlayerEarning(address _player)
197 		public 
198 		view 
199 		returns (uint256)
200 	{
201 		(uint256 _profit, uint256 _aff, uint256 _winning, uint256 _vote_rewards) = getPlayerProfit(_player);
202 		return _profit.add(_aff).add(_winning).add(_vote_rewards);
203 	}
204 	
205 	
206 	function getPlayerWinning(address _player,uint256 _winning_number) 
207 		public 
208 		view 
209 		returns (uint256)
210 	{
211 		uint256 _winning = 0;
212 		if(_winning_number==0){
213 			return 0;
214 		}
215 		uint256 _winningCount=0;
216 		for(uint256 i = 0 ;i<players[_player].purchases.length;i++){
217 			if(purchases[players[_player].purchases[i]].betItemId==_winning_number){
218 				_winningCount=_winningCount.add(purchases[players[_player].purchases[i]].positionCount);
219 			}
220 		}
221 		if(_winningCount>0){
222 			_winning= _winningCount.mul(winner_pool_amount)/(betItems[_winning_number].betCount);
223 		}
224 		
225 		return _winning;
226 	}
227 	
228 	function getPlayerVoteRewards(address _player,uint256 _winning_number) 
229 		public 
230 		view 
231 		returns (uint256)
232 	{
233 		if(_winning_number==0){
234 			return 0;
235 		}
236 		if(resultVotes[_player]==0){
237 			return 0;
238 		}
239 		//wrong result
240 		if(resultVotes[_player]!=_winning_number){
241 			return 0;
242 		}
243 		
244 		uint256 _correct_vote_count = resultVoteCounts[_winning_number];
245 		require(_correct_vote_count>0);
246 		
247 		return vote_reward_pool_amount/_correct_vote_count;
248 	}
249 	
250 	function getProfit(uint256 currentpurchase_id)
251 		public 
252 		view 
253 		returns (uint256)
254 	{
255 		uint256 _positionCount= purchases[currentpurchase_id].positionCount;
256 		if(_positionCount==0) return 0;
257 		uint256 _currentPositionProfit=calculatePositionProfit(currentpurchase_id);
258 		uint256 currentPositionSum = keyNumberToValue[currentpurchase_id];
259 		uint256 _profit = _currentPositionProfit.add(keyNumberToValue[purchase_id].sub(currentPositionSum));
260 		for(uint256 i=1;i<_positionCount;i++){
261 			currentPositionSum  = currentPositionSum.sub(_currentPositionProfit);
262 			_currentPositionProfit = calculatePositionProfit(currentpurchase_id.sub(i));
263 			_profit = _profit.add(keyNumberToValue[purchase_id].sub(currentPositionSum)).add(_currentPositionProfit);
264 		}
265 		return _profit;
266 	}
267 	
268 	function getSystemInfo() 
269 		public 
270 		view 
271 		returns(uint256, uint256, uint256, uint256,uint256)
272 	{
273 		return (winner_pool_amount,buyer_profit_pool_amount,vote_reward_pool_amount,BET_END_TIME
274 		,purchase_id);
275 	}
276 	
277 	function getSingleBetItemCount(uint256 _betItemId)
278 		public 
279 		view
280 		returns (uint256)
281 	{
282 		return betItems[_betItemId].betCount;
283 	}
284 	
285 	function getBetItemCount() 
286 		public 
287 		view 
288 		returns (uint256[ITEM_COUNT])
289 	{
290 		uint256[ITEM_COUNT] memory itemCounts;
291 		for(uint i=0;i<ITEM_COUNT;i++){
292 			itemCounts[i]=(betItems[i+1].betCount);
293 		}
294 		return itemCounts;
295 	}
296 	
297 	function getPlayerInfo(address player) 
298 		public 
299 		view 
300 		returns (uint256,uint256,uint256[],uint256,uint256)
301 	{
302 		return (players[player].aff,players[player].withdraw,players[player].purchases,players[player].totalPosition,players[player].affId);
303 	}
304 	
305 	function withdraw()        
306 		isHuman()
307         public
308 	{
309 		address _player = msg.sender;
310 		uint256 _earning = getPlayerEarning(_player);
311 		
312 		uint256 _leftEarning = _earning.sub(players[_player].withdraw);
313 		//still money to withdraw
314 		require(_leftEarning>0);
315 		
316 		if(_leftEarning>0){
317 			players[_player].withdraw = players[_player].withdraw.add(_leftEarning);
318 			_player.transfer(_leftEarning);
319 		}
320 	}
321 	
322 	//only owner can change this, just in case, the game change the final date. 
323 	//this won't change anything else beside the game end date
324 	function setBetEndTime(uint256 _newBetEndTime) 
325 		isOwner()
326 		public
327 	{
328 		BET_END_TIME = _newBetEndTime;
329 		setPrizeEndTime();
330 	}
331 	
332 	function voteToResult(uint256 betItemId)
333 		isNotEnded()
334         isHuman()
335 		isValidItem(betItemId)
336 		public
337         payable
338 	{
339 		
340 		require(msg.value == VOTE_AMOUNT);
341 		
342 		require(resultVotes[msg.sender]==0, "only allow vote once");
343 		
344 		vote_reward_pool_amount = vote_reward_pool_amount.add(VOTE_AMOUNT);
345 		result_vote_count = result_vote_count.add(1);
346 		resultVotes[msg.sender] = betItemId;
347 		resultVoteCounts[betItemId] = resultVoteCounts[betItemId].add(1);
348 	}
349 	
350 	function getWinningNumber() 
351 		public 
352 		view 
353 		returns (uint256)
354 	{
355 		//don't show it until the vote finish
356 		if(now < PRIZE_END_TIME){
357 			return 0;
358 		}
359 		uint256 _winningNumber = 0;
360 		uint256 _max_vote_count=0;
361 		for(uint256 i=1;i< ITEM_COUNT ; i++){
362 			if(_max_vote_count<resultVoteCounts[i]){
363 				_winningNumber = i;
364 				_max_vote_count = resultVoteCounts[i];
365 			}
366 		}
367 		return _winningNumber;
368 	}
369 	
370     modifier isNotFinished() {
371         require(now < BET_END_TIME, "The voting has finished."); 
372         _;
373     }
374 	
375 	modifier isValidItem(uint256 _itemId) {
376         require(_itemId > 0, "Invalid item id"); 
377 		require(_itemId <= ITEM_COUNT, "Invalid item id"); 
378         _;
379     }
380 	
381     modifier isNotEnded() {
382         require(now < PRIZE_END_TIME, "The contract has finished."); 
383         _;
384     }
385     modifier isHuman() {
386         address _addr = msg.sender;
387         uint256 _codeLength;
388         
389         assembly {_codeLength := extcodesize(_addr)}
390         require(_codeLength == 0, "human only");
391         _;
392     }
393 
394     /**
395      * @dev sets boundaries for incoming tx 
396      */
397     modifier isWithinLimits(uint256 _eth) {
398         require(_eth >= MIN_BET, "has to be greater than min bet");
399         require(_eth <= 100000000000000000000000, "too much");
400         _;
401     }
402 	
403 	modifier isOwner() {
404 		require(msg.sender == owner) ;
405 		_;
406 	}
407 }
408 /**
409  * @title SafeMath v0.1.9
410  * @dev Math operations with safety checks that throw on error
411  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
412  * - added sqrt
413  * - added sq
414  * - added pwr 
415  * - changed asserts to requires with error log outputs
416  * - removed div, its useless
417  */
418 library SafeMath {
419     
420     /**
421     * @dev Multiplies two numbers, throws on overflow.
422     */
423     function mul(uint256 a, uint256 b) 
424         internal 
425         pure 
426         returns (uint256 c) 
427     {
428         if (a == 0) {
429             return 0;
430         }
431         c = a * b;
432         require(c / a == b, "SafeMath mul failed");
433         return c;
434     }
435 
436     /**
437     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
438     */
439     function sub(uint256 a, uint256 b)
440         internal
441         pure
442         returns (uint256) 
443     {
444         require(b <= a, "SafeMath sub failed");
445         return a - b;
446     }
447 
448     /**
449     * @dev Adds two numbers, throws on overflow.
450     */
451     function add(uint256 a, uint256 b)
452         internal
453         pure
454         returns (uint256 c) 
455     {
456         c = a + b;
457         require(c >= a, "SafeMath add failed");
458         return c;
459     }
460     
461     /**
462      * @dev gives square root of given x.
463      */
464     function sqrt(uint256 x)
465         internal
466         pure
467         returns (uint256 y) 
468     {
469         uint256 z = ((add(x,1)) / 2);
470         y = x;
471         while (z < y) 
472         {
473             y = z;
474             z = ((add((x / z),z)) / 2);
475         }
476     }
477     
478     /**
479      * @dev gives square. multiplies x by x
480      */
481     function sq(uint256 x)
482         internal
483         pure
484         returns (uint256)
485     {
486         return (mul(x,x));
487     }
488     
489     /**
490      * @dev x to the power of y 
491      */
492     function pwr(uint256 x, uint256 y)
493         internal 
494         pure 
495         returns (uint256)
496     {
497         if (x==0)
498             return (0);
499         else if (y==0)
500             return (1);
501         else 
502         {
503             uint256 z = x;
504             for (uint256 i=1; i < y; i++)
505                 z = mul(z,x);
506             return (z);
507         }
508     }
509 }