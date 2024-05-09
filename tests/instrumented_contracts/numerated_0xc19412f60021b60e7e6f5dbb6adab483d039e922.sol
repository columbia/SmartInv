1 pragma solidity ^ 0.4.24; 
2 
3 /***
4  *       ___     ___      _    
5  *      /   \   |_  )    / |   
6  *      | - |    / /     | |   
7  *      |_|_|   /___|   _|_|_  
8  *    _|"""""|_|"""""|_|"""""| 
9  *    "`-0-0-'"`-0-0-'"`-0-0-' 
10  * 
11  * https://a21.app
12  */
13  
14 contract IGame {
15      
16     address public owner; 
17     address public creator;
18     address public manager;
19 	uint256 public poolValue = 0;
20 	uint256 public round = 0;
21 	uint256 public totalBets = 0;
22 	uint256 public startTime = now;
23     bytes32 public name;
24     string public title;
25 	uint256 public price;
26 	uint256 public timespan;
27 	uint32 public gameType;
28 
29     /* profit divisions */
30 	uint256 public profitOfSociety = 5;  
31 	uint256 public profitOfManager = 1; 
32 	uint256 public profitOfFirstPlayer = 15;
33 	uint256 public profitOfWinner = 40;
34 	
35 	function getGame() view public returns(
36         address, uint256, address, uint256, 
37         uint256, uint256, uint256, 
38         uint256, uint256, uint256, uint256);
39 } 
40 /***
41  *       ___     ___      _    
42  *      /   \   |_  )    / |   
43  *      | - |    / /     | |   
44  *      |_|_|   /___|   _|_|_  
45  *    _|"""""|_|"""""|_|"""""| 
46  *    "`-0-0-'"`-0-0-'"`-0-0-' 
47  */
48 contract Owned {
49     modifier isActivated {
50         require(activated == true, "its not ready yet."); 
51         _;
52     }
53     
54     modifier isHuman {
55         address _addr = msg.sender;
56         uint256 _codeLength;
57         
58         assembly {_codeLength := extcodesize(_addr)}
59         require(_codeLength == 0, "sorry humans only");
60         _;
61     }
62  
63     modifier limits(uint256 _eth) {
64         require(_eth >= 1000000000, "pocket lint: not a valid currency");
65         require(_eth <= 100000000000000000000000, "no vitalik, no");
66         _;    
67     }
68  
69     modifier onlyOwner {
70         require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
71         _;
72     }
73 
74     address public owner;
75 	bool public activated = true;
76 
77     constructor() public{
78         owner = msg.sender;
79     }
80 
81 	function terminate() public onlyOwner {
82 		selfdestruct(owner);
83 	}
84 
85 	function setIsActivated(bool _activated) public onlyOwner {
86 		activated = _activated;
87 	}
88 } 
89 library List {
90   /** Removes the value at the given index in an array. */
91   function removeIndex(uint[] storage values, uint i) internal {      
92     if(i<values.length){ 
93         while (i<values.length-1) {
94             values[i] = values[i+1];
95             i++;
96         }
97         values.length--;
98     }
99   }
100 } 
101  
102  
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149  
150 /**
151  * @title NameFilter
152  * @dev filter string
153  */
154 library NameFilter {
155     /**
156      * @dev filters name strings
157      * -converts uppercase to lower case.  
158      * -makes sure it does not start/end with a space
159      * -makes sure it does not contain multiple spaces in a row
160      * -cannot be only numbers
161      * -cannot start with 0x 
162      * -restricts characters to A-Z, a-z, 0-9, and space.
163      * @return reprocessed string in bytes32 format
164      */
165     function nameFilter(string _input)
166         internal
167         pure
168         returns(bytes32)
169     {
170         bytes memory _temp = bytes(_input);
171         uint256 _length = _temp.length;
172         
173         //sorry limited to 32 characters
174         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
175         // make sure it doesnt start with or end with space
176         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
177         // make sure first two characters are not 0x
178         if (_temp[0] == 0x30)
179         {
180             require(_temp[1] != 0x78, "string cannot start with 0x");
181             require(_temp[1] != 0x58, "string cannot start with 0X");
182         }
183         
184         // create a bool to track if we have a non number character
185         bool _hasNonNumber;
186         
187         // convert & check
188         for (uint256 i = 0; i < _length; i++)
189         {
190             // if its uppercase A-Z
191             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
192             {
193                 // convert to lower case a-z
194                 _temp[i] = byte(uint(_temp[i]) + 32);
195                 
196                 // we have a non number
197                 if (_hasNonNumber == false)
198                     _hasNonNumber = true;
199             } else {
200                 require
201                 (
202                     // require character is a space
203                     _temp[i] == 0x20 || 
204                     // OR lowercase a-z
205                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
206                     // or 0-9
207                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
208                     "string contains invalid characters"
209                 );
210                 // make sure theres not 2x spaces in a row
211                 if (_temp[i] == 0x20)
212                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
213                 
214                 // see if we have a character other than a number
215                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
216                     _hasNonNumber = true;    
217             }
218         }
219         
220         require(_hasNonNumber == true, "string cannot be only numbers");
221         
222         bytes32 _ret;
223         assembly {
224             _ret := mload(add(_temp, 32))
225         }
226         return (_ret);
227     }
228 }
229 
230 /***
231  *       ___     ___      _    
232  *      /   \   |_  )    / |   
233  *      | - |    / /     | |   
234  *      |_|_|   /___|   _|_|_  
235  *    _|"""""|_|"""""|_|"""""| 
236  *    "`-0-0-'"`-0-0-'"`-0-0-' 
237  * 
238  * https://a21.app
239  */
240 
241 
242 contract A21 is IGame, Owned {
243   	using SafeMath for uint256;
244 	using List for uint[];
245     using NameFilter for string;
246   
247 	struct Bet {
248 		address addr;
249 		uint8 value;
250 		uint8 c1;
251 		uint8 c2;
252 		uint256 round;
253 		uint256 date;
254 		uint256 eth;
255 		uint256 award;
256 		uint8 awardType; 
257 	}
258 
259 	struct Player { 
260 		mapping(uint256 => Bet) bets;
261 		uint256 numberOfBets;
262 	}	
263 
264 	struct Result {
265 		uint256 round;
266 		address addr;
267 		uint256 award;
268 		uint8 awardType; 
269 		Bet bet;
270 	}
271 
272 	uint256 private constant MINIMUM_PRICE = 0.01 ether;
273 	uint256 private constant MAXIMUM_PRICE = 100 ether;
274 	uint8 private constant NUMBER_OF_CARDS_VALUE = 13;
275 	uint8 private constant NUMBER_OF_CARDS = NUMBER_OF_CARDS_VALUE * 4;
276 	uint8 private constant MAXIMUM_NUMBER_OF_BETS = 26;
277 	uint8 private constant BLACKJACK = 21;
278 	uint8 private constant ENDGAME = 128;
279 	uint256 private constant MINIMUM_TIMESPAN = 1 minutes;  
280 	uint256 private constant MAXIMUM_TIMESPAN = 24 hours;  
281 
282 	uint256[] private _cards;
283     mapping(uint8 => Bet) private _bets;
284 	mapping(address => Player) private _players;  
285 	Result[] private _results;
286 
287 	mapping(address => uint256) public balances;
288     address public creator;
289     address public manager;
290 	uint256 public poolValue = 0;
291 	uint256 public round = 0;
292 	uint256 public totalBets = 0;
293 	uint8 public numberOfBets = 0;
294 	uint256 public startTime = now;
295     bytes32 public name;
296     string public title;
297 	uint256 public price;
298 	uint256 public timespan;
299 	uint32 public gameType = BLACKJACK;
300 	uint8 public ace = 0;
301 
302     /* profit divisions */
303 	uint256 public profitOfSociety = 5;  
304 	uint256 public profitOfManager = 1; 
305 	uint256 public profitOfFirstPlayer = 15;
306 	uint256 public profitOfWinner = 40;
307 	
308 	/* events */
309 	event OnBuy(uint256 indexed round, address indexed playerAddress, uint256 price, uint8 cardValue, uint8 c1, uint8 c2, uint256 timestamp); 
310 	event OnWin(uint256 indexed round, address indexed playerAddress, uint256 award, uint8 cardValue, uint8 c1, uint8 c2, uint256 timestamp); 
311 	event OnReward(uint256 indexed round, address indexed playerAddress, uint256 award, uint8 cardValue, uint8 c1, uint8 c2, uint256 timestamp); 
312 	event OnWithdraw(address indexed sender, uint256 value, uint256 timestamp); 
313 	event OnNewRound(uint256 indexed round, uint256 timestamp); 
314 
315 	constructor(address _manager, string _name, string _title, uint256 _price, uint256 _timespan,
316 		uint256 _profitOfManager, uint256 _profitOfFirstPlayer, uint256 _profitOfWinner
317 		) public {
318 		require(address(_manager)!=0x0, "invaild address");
319 		require(_price >= MINIMUM_PRICE && _price <= MAXIMUM_PRICE, "price not in range (MINIMUM_PRICE, MAXIMUM_PRICE)");
320 		require(_timespan >= MINIMUM_TIMESPAN && _timespan <= MAXIMUM_TIMESPAN, "timespan not in range(MINIMUM_TIMESPAN, MAXIMUM_TIMESPAN)");
321 		name = _name.nameFilter(); 
322 		require(name[0] != 0, "invaild name"); 
323         require(_profitOfManager <=20, "[profitOfManager] don't take too much commission :)");
324         require(_profitOfFirstPlayer <=50, "[profitOfFirstPlayer] don't take too much commission :)");
325         require(_profitOfWinner <=100 && (_profitOfManager + _profitOfWinner + _profitOfFirstPlayer) <=100, "[profitOfWinner] don't take too much commission :)");
326         
327         creator = msg.sender;
328 		owner = 0x56C4ECf7fBB1B828319d8ba6033f8F3836772FA9; 
329 		manager = _manager;
330 		//name = _name.nameFilter(); 
331 		title = _title;
332 		price = _price;
333 		timespan = _timespan;
334 		profitOfManager = _profitOfManager;
335 		profitOfFirstPlayer = _profitOfFirstPlayer;
336 		profitOfWinner = _profitOfWinner;
337 
338 		newRound();  
339 	}
340 
341 	function() public payable isActivated isHuman limits(msg.value){
342 		// airdrop
343 		goodluck();
344 	}
345 
346 	function goodluck() public payable isActivated isHuman limits(msg.value) {
347 		require(msg.value >= price, "value < price");
348 		require(msg.value >= MINIMUM_PRICE && msg.value <= MAXIMUM_PRICE, "value not in range (MINIMUM_PRICE, MAXIMUM_PRICE)");
349 		
350 		if(getTimeLeft()<=0){
351 			// timeout, end.
352 			endRound();
353 		}
354 
355 		// contribution
356 		uint256 awardOfSociety = msg.value.mul(profitOfSociety).div(100);
357 		poolValue = poolValue.add(msg.value).sub(awardOfSociety);
358 		balances[owner] = balances[owner].add(awardOfSociety);
359 
360 		uint256 v = buyCore(); 
361 
362 		if(v == BLACKJACK || v == ENDGAME || _cards.length<=1){
363 			// someone wins or cards have been run out.
364 			endRound();
365 		}		
366 	}
367 
368 	function withdraw(uint256 amount) public isActivated isHuman returns(bool) {
369 		uint256 bal = balances[msg.sender];
370 		require(bal> 0);
371 		require(bal>= amount);
372 		require(address(this).balance>= amount);
373 		balances[msg.sender] = balances[msg.sender].sub(amount); 
374 		msg.sender.transfer(amount);
375 
376 		emit OnWithdraw(msg.sender, amount, now);
377 		return true;
378 	}
379     
380 	/* for the reason of promotion, manager can increase the award pool   */
381 	function addAward() public payable isActivated isHuman limits(msg.value) {
382 		require(msg.sender == manager, "only manager can add award into pool");  
383 		// thanks this smart manager 
384 		poolValue =  poolValue.add(msg.value);
385 	}
386 	
387 	function isPlayer(address addr) public view returns(bool){
388 	    return _players[addr].numberOfBets > 0 ;
389 	}
390 
391     function getTimeLeft() public view returns(uint256) { 
392         // grab time
393         uint256 _now = now;
394 		uint256 _endTime = startTime.add(timespan);
395         
396         if (_now >= _endTime){
397 			return 0;
398 		}
399          
400 		return (_endTime - _now);
401     }
402     
403 	function getBets() public view returns (address[], uint8[], uint8[], uint8[]){
404 		uint len = numberOfBets;
405 		address[] memory ps = new address[](len);
406 		uint8[] memory vs = new uint8[](len);
407 		uint8[] memory c1s = new uint8[](len);
408 		uint8[] memory c2s = new uint8[](len);
409 		uint8 i = 0; 
410 		while (i< len) {
411 			ps[i] = _bets[i].addr;
412 			vs[i] = _bets[i].value;
413 			c1s[i] = _bets[i].c1;
414 			c2s[i] = _bets[i].c2;
415 			i++;
416 		}
417 
418 		return (ps, vs, c1s, c2s);
419 	} 
420 
421 	function getBetHistory(address player, uint32 v) public view returns (uint256[], uint256[], uint8[], uint8[]){
422 		Player storage p = _players[player];
423 		uint256 len = v;
424 		if(len == 0 || len > p.numberOfBets){
425 		    len = p.numberOfBets;
426 		}
427 		
428 		uint256[] memory rounds = new uint256[](len);
429 		uint256[] memory awards = new uint256[](len);  
430 		uint8[] memory c1s = new uint8[](len);
431 		uint8[] memory c2s = new uint8[](len);
432 		if(len == 0 ){
433 			return (rounds, awards, c1s, c2s);
434 		}
435 			
436 		uint256 i = 0; 
437 		while (i< len) { 
438 			Bet memory r = p.bets[p.numberOfBets-1-i];
439 			rounds[i] = r.round;
440 			awards[i] = r.award; 
441 			c1s[i] = r.c1;
442 			c2s[i] = r.c2;
443 			i++;
444 		}
445 
446 		return (rounds, awards, c1s, c2s);
447 	}
448 	
449     function getBetHistory2(address player, uint32 v) public view returns (uint256[], uint256[], uint8[], uint8[]){
450 		Player storage p = _players[player];
451 		uint256 len = v;
452 		if(len == 0 || len > p.numberOfBets){
453 		    len = p.numberOfBets;
454 		}
455 		
456 		uint256[] memory rounds = new uint256[](len);
457 		uint256[] memory awards = new uint256[](len);  
458 		uint8[] memory c1s = new uint8[](len);
459 		uint8[] memory c2s = new uint8[](len);
460 		if(len == 0 ){
461 			return (rounds, awards, c1s, c2s);
462 		}
463 		
464 		uint256 i = 0; 
465 		while (i< len) { 
466 			Bet memory r = p.bets[i];
467 			rounds[i] = r.round;
468 			awards[i] = r.award; 
469 			c1s[i] = r.c1;
470 			c2s[i] = r.c2;
471 			i++;
472 		}
473 
474 		return (rounds, awards, c1s, c2s);
475 	}
476 	
477 	function getResults(uint32 v) public view returns (uint256[], address[], uint256[], uint8[], uint8[], uint8[]){
478 		uint256 len = v;
479 		if(len == 0 || len >_results.length){
480 		    len = _results.length;
481 		}
482 		
483 		uint256[] memory rounds = new uint256[](len);
484 		address[] memory addrs = new address[](len);
485 		uint256[] memory awards = new uint256[](len); 
486 		uint8[] memory awardTypes = new uint8[](len);
487 		uint8[] memory c1s = new uint8[](len);
488 		uint8[] memory c2s = new uint8[](len);
489 		
490 		if(len == 0 ){
491 			return (rounds, addrs, awards, awardTypes, c1s, c2s);
492 		}
493 		
494 		uint256 i = 0; 
495 		while (i<_results.length) { 
496 			Result storage r = _results[_results.length-1-i];
497 			rounds[i] = r.round;
498 			addrs[i] = r.addr;
499 			awards[i] = r.award;
500 			awardTypes[i] = r.awardType;
501 			c1s[i] = r.bet.c1;
502 			c2s[i] = r.bet.c2;
503 			i++;
504 		}
505 
506 		return (rounds, addrs, awards, awardTypes, c1s, c2s);
507 	}
508 	
509 	
510     function getGame() view public returns(
511         address, uint256, address, uint256, 
512         uint256, uint256, uint256, 
513         uint256, uint256, uint256, uint256) {
514         return (address(this), price, manager, timespan, 
515             profitOfManager, profitOfFirstPlayer, profitOfWinner, 
516             round, address(this).balance, poolValue, totalBets);
517     }
518 
519 /***
520  *    .------..------..------.
521  *    |A.--. ||2.--. ||1.--. |
522  *    | (\/) || (\/) || :/\: |
523  *    | :\/: || :\/: || (__) |
524  *    | '--'A|| '--'2|| '--'1|
525  *    `------'`------'`------'
526  *    === private functions ===
527  */
528 
529 	function buyCore() private returns (uint256){
530 		totalBets++;
531 		// draw 2 cards 
532 		(uint c1, uint c2) =  draw(); 
533 
534 		uint256 v = eval(c1, c2);
535 
536 		Bet storage bet =  _bets[numberOfBets++];
537 		bet.addr = msg.sender;
538 		bet.value =  uint8(v);
539 		bet.c1 = uint8(c1);
540 		bet.c2 = uint8(c2);		
541 		bet.round = round;
542 		bet.date = now;
543 		bet.eth = msg.value; 
544 		
545 		// push to hist
546 		Player storage player = _players[msg.sender];
547 		player.bets[player.numberOfBets++] = bet;
548 
549 		emit OnBuy(round, msg.sender, msg.value, bet.value, bet.c1, bet.c2, now);
550 
551 		if(c1%13==0){
552 		    ace++;
553 		}
554 		if(c2%13==0){
555 		    ace++;
556 		} 
557 		
558 		return ace>=4? ENDGAME: v;
559 	}
560 
561 	function newRound() private {
562 		numberOfBets = 0;
563 		ace = 0;
564 		for(uint8 i =0; i < MAXIMUM_NUMBER_OF_BETS; i++){
565 			Bet storage bet = _bets[i];
566 			bet.addr = address(0);
567 		}
568 
569 		_cards = new uint[](NUMBER_OF_CARDS);
570 		for(i=0; i< NUMBER_OF_CARDS; i++){
571 			_cards[i] = i;
572 		}
573 		_cards.length = NUMBER_OF_CARDS;
574 		round++; 
575 		startTime = now;
576 
577 		emit OnNewRound(round, now);
578 	}
579 
580 	function endRound() private {
581 		uint256 awardOfManager = poolValue.mul(profitOfManager).div(100);
582 		uint256 awardOfFirstPlayer = poolValue.mul(profitOfFirstPlayer).div(100);
583 		uint256 awardOfWinner = poolValue.mul(profitOfWinner).div(100);
584 
585 		if(numberOfBets>0 ){
586 			// check winner
587 			uint8 i = 0;
588 			int winner = -1;
589 			while (i< numberOfBets) {
590 				if(_bets[i].value == BLACKJACK){				
591 					winner = int(i);
592 					break;
593 				}
594 				i++;
595 			}
596 
597 			address firstPlayerAddr = _bets[0].addr;
598 			balances[firstPlayerAddr] = balances[firstPlayerAddr].add(awardOfFirstPlayer); 
599 			
600             _results.push(Result(round, firstPlayerAddr, awardOfFirstPlayer, 1, _bets[0])); //Bet(_bets[0].addr, _bets[0].value, _bets[0].c1, _bets[0].c2, _bets[0].round, _bets[0].date, _bets[0].eth)
601 
602             Player storage player = _players[firstPlayerAddr];
603 	        Bet storage _bet = player.bets[player.numberOfBets-1];
604 	        _bet.award = _bet.award.add(awardOfFirstPlayer);
605 	        _bet.awardType = 1;
606 		        
607 			emit OnReward(round, firstPlayerAddr, awardOfFirstPlayer, _bets[0].value, _bets[0].c1, _bets[0].c2, now);
608 			
609 			if(winner>=0){	
610 				Bet memory bet = _bets[uint8(winner)];			
611 				address winAddr = bet.addr; 
612 				balances[winAddr] = balances[winAddr].add(awardOfWinner); 
613                 _results.push(Result(round,winAddr, awardOfWinner, BLACKJACK, bet));
614                 
615                 player = _players[winAddr];
616 		        _bet = player.bets[player.numberOfBets-1];
617 		        _bet.award = _bet.award.add(awardOfWinner);
618 		        _bet.awardType = BLACKJACK;
619 		        
620 				emit OnWin(round, winAddr, awardOfWinner, bet.value, bet.c1, bet.c2, now);
621 			}else{
622 			    awardOfWinner = 0;
623 			}
624 
625 		}else{
626 		    // no bets (!o!)
627 			awardOfWinner = 0;
628 			awardOfFirstPlayer = 0;
629 			awardOfManager = 0;
630 		} 
631 
632 		balances[manager] = balances[manager].add(awardOfManager); 
633 		
634 		poolValue =  poolValue.sub(awardOfManager).sub(awardOfFirstPlayer).sub(awardOfWinner);
635 		
636 		releaseCommission();
637 
638 		newRound();
639 	}
640 
641 	function releaseCommission() private {
642 		// 🙄 in case too busy in developing dapps and have no time to collect team commission 
643 		// thanks everyone!
644 		uint256 commission = balances[owner];
645 		if(commission > 0){
646 			owner.transfer(commission);
647 			balances[owner] = 0;
648 		}
649 
650 		// For the main reason of gas fee, we don't release all players' awards, so please withdraw it by yourself. 
651 	}
652 
653 	function eval(uint256 c1, uint256 c2)  private pure returns (uint256){
654 		c1 = cut((c1 % 13) + 1);
655 		c2 = cut((c2 % 13) + 1);
656 		if ((c1 == 1 && c2 == 10) || ((c2 == 1 && c1 == 10))) {
657 			return BLACKJACK;
658 		}
659 
660 		if (c1 + c2 > BLACKJACK) {
661 			return 0;
662 		}
663  
664 		return c1 + c2;
665 	}
666 
667 	function cut(uint256 v) private pure returns (uint256){
668 		return (v > 10 ? 10 : v);
669 	}
670 
671 	function draw() private returns (uint, uint) {
672 	    uint256 max = _cards.length * (_cards.length - 1) /2;
673 		uint256 ind = rand(max);
674 		(uint256 i1, uint256 i2) = index2pair(ind);
675 		uint256 c1 = _cards[i1];
676 		_cards.removeIndex(i1); 
677 		uint256 c2 = _cards[i2];
678 		_cards.removeIndex(i2);
679 		return (c1, c2);
680 	}
681 
682 	function rand(uint256 max) private view returns (uint256){
683 		uint256 _seed = uint256(keccak256(abi.encodePacked(
684                 (block.timestamp) +
685                 (block.difficulty) +
686                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
687                 (block.gaslimit) +
688                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
689                 (block.number)
690         ))); 
691 		
692 		return _seed % max; 
693 	}
694 
695 	function index2pair(uint x) private pure returns (uint, uint) { 
696 		uint c1 = ((sqrt(8*x+1) - 1)/2 +1);
697 		uint c2 = (x - c1*(c1-1)/2);
698 		return (c1, c2);
699 	}
700 
701 	function sqrt(uint x) private pure returns (uint) {
702 		uint z = (x + 1) / 2;
703 		uint y = x;
704 		while (z < y) {
705 			y = z;
706 			z = (x / z + z) / 2;
707 		}
708 
709 		return y;
710 	}
711  
712 }
713 
714 contract A21Builder{
715     function buildGame (address _manager, string _name, string _title, uint256 _price, uint256 _timespan,
716         uint8 _profitOfManager, uint8 _profitOfFirstPlayer, uint8 _profitOfWinner) payable external returns(address){
717        
718         address game = new A21(_manager, _name, _title, _price, _timespan, _profitOfManager, _profitOfFirstPlayer, _profitOfWinner);
719         return game;   
720     }
721 }