1 pragma solidity ^0.4.24;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal pure returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract owned {
29     address public owner;
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         require (msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         owner = newOwner;
42     }
43 }
44 
45 
46 contract PowerBall is owned {
47     using Strings for string;
48     using SafeMath for uint256;
49      
50     struct Ticket {
51         address player;
52         uint32 drawDate;
53 		uint64 price;
54         uint8 ball1;
55         uint8 ball2;
56         uint8 ball3;
57         uint8 ball4;
58         uint8 redBall;
59     }
60     struct Draws{
61         uint32 count;
62         uint32[500000] tickets;
63     }
64     
65 	struct CurrentPrizes{
66 		address special;
67 		address first;
68 		address second;
69 		address third;
70 	}
71 	struct Prize{
72 	    address[] winners;
73 	    uint amout;
74 	}
75 	struct LotteryResults{
76 		Prize special;
77 		Prize first;
78 		Prize second;
79 		Prize third;
80 		uint8[5] result;
81 		bool hadDraws;
82 		bool hadAward;
83 	}
84 	
85 	struct TicketInfo{
86 		uint64 priceTicket;
87 		uint8 specialPrize;
88 		uint8 firstPrize;
89 		uint8 secondPrize;
90 		uint8 thirdPrize;
91 		uint8 commission;
92 		uint8 sales;
93 	}
94     TicketInfo public ticketInfo;
95 	CurrentPrizes public prizes;
96 	address SystemSale;
97     mapping(address => uint256) private balances;
98     mapping (uint => Ticket) private tickets;
99     mapping (uint32 => Draws)  _draws;
100 	mapping (uint32 => LotteryResults)  _results;
101 	
102     
103 	uint32 idTicket;
104     
105     event logBuyTicketSumary(
106         address user,
107         uint32[] ticketId,
108 		uint drawDate
109     );
110     
111     event logGetPrize(
112         string prize,
113 		uint drawDate,
114 		uint amout,
115 		address[] winners,
116 		uint8[5] result
117 		
118     );
119     
120     event logAward(
121         string prize,
122         uint drawDate,
123 		uint amout,
124 		address[] winners,
125 		uint8[5] result
126     );
127     
128     event logWithdraw(
129         address account,
130 		uint amout
131     );
132     
133 	constructor() public{
134 		ticketInfo.priceTicket  = 10000; 		//10 GM
135 		ticketInfo.specialPrize = 30; 			//30 percent
136 		ticketInfo.firstPrize = 2; 				//2 percent
137 		ticketInfo.secondPrize = 5; 			//5 percent
138 		ticketInfo.thirdPrize = 8; 				//8 percent
139 		ticketInfo.commission = 10; 			//10 percent
140 		ticketInfo.sales = 45; 				    //45 percent
141 		
142 		
143 		prizes.special = 0x374cC1ed754A448276380872786659ab532CD7fC; //account 3
144 		prizes.first = 0xF73823D62f8006E8cBF39Ba630479EFDA59419C9; //account 4
145 		prizes.second = 0x0b744af1F0E55AFBeAb8212B00bBf2586F0EBB8F; //account 5
146 		prizes.third = 0x6dD465891AcB3570F122f5E7E52eeAA406992Dcf; //account 6
147 		
148 	
149 		SystemSale = 0xbD6E06b04c2582c4373741ef6EDf39AB37Eb964C; //account 8
150 		
151 		
152 	}
153 	
154 	
155 	function setTicketInfo(
156 	    uint64 _priceTicket,
157 		uint8 _specialPrize,
158 		uint8 _firstPrize,
159 		uint8 _secondPrize,
160 		uint8 _thirdPrize,
161 		uint8 _commission,
162 		uint8 _sales
163 	    ) 
164 	public
165 	onlyOwner
166 	{
167 	    ticketInfo.priceTicket  = _priceTicket;    
168 	    ticketInfo.specialPrize = _specialPrize;
169 		ticketInfo.firstPrize = _firstPrize;
170 		ticketInfo.secondPrize = _secondPrize;
171 		ticketInfo.thirdPrize = _thirdPrize;
172 		ticketInfo.commission = _commission;
173 		ticketInfo.sales = _sales;
174 	}
175 	
176 	function cumulativeAward(uint _special, uint _first, uint _second, uint _third)
177 	public
178 	onlyOwner
179 	{
180 	    setBalance(prizes.special,_special);
181 	    setBalance(prizes.first,_first);
182 	    setBalance(prizes.second,_second);
183 	    setBalance(prizes.third,_third);
184 	}
185 	
186 	/**
187     * @dev giveTickets buy ticket and give it to another player
188     * @param _user The address of the player that will receive the ticket.
189     * @param _drawDate The draw date of tickets.
190     * @param _balls The ball numbers of the tickets.
191     */
192 	function giveTickets(address _user,uint32 _drawDate, uint8[] _balls) 
193 	onlyOwner
194 	public
195 	{
196 	    require(!_results[_drawDate].hadDraws);
197 	    uint32[] memory _idTickets = new uint32[](_balls.length/5);
198 	    uint32 id = idTicket;
199 		
200 	    for(uint8 i = 0; i< _balls.length; i+=5){
201 	        require(checkRedBall(_balls[i+4]));
202 	        require(checkBall(_balls[i]));
203 	        require(checkBall(_balls[i+1]));
204 	        require(checkBall(_balls[i+2]));
205 	        require(checkBall(_balls[i+3]));
206 	        id++;
207     	    tickets[id].player = _user;
208     	    tickets[id].drawDate = _drawDate;
209     	    tickets[id].price = ticketInfo.priceTicket;
210     	    tickets[id].redBall = _balls[i+4];
211     	    tickets[id].ball1 = _balls[i];
212     	    tickets[id].ball2 = _balls[i + 1];
213     	    tickets[id].ball3 = _balls[i +2];
214     	    tickets[id].ball4 = _balls[i + 3];
215 		    _draws[_drawDate].tickets[_draws[_drawDate].count] = id;
216     	    _draws[_drawDate].count ++;
217     	    _idTickets[i/5] = id;
218 	    }
219 	    idTicket = id;
220 	    emit logBuyTicketSumary(_user,_idTickets,_drawDate);
221 	}
222 	
223 	/**
224     * @dev addTickets allow admin add ticket to player for buy ticket fail
225     * @param _user The address of the player that will receive the ticket.
226     * @param _drawDate The draw date of tickets.
227     * @param _balls The ball numbers of the tickets.
228     * @param _price The price of the tickets.
229     */
230 	function addTickets(address _user,uint32 _drawDate, uint64 _price, uint8[] _balls) 
231 	onlyOwner
232 	public
233 	{
234 	    require(!_results[_drawDate].hadDraws);
235 	    uint32[] memory _idTickets = new uint32[](_balls.length/5);
236 	    uint32 id = idTicket;
237 		
238 	    for(uint8 i = 0; i< _balls.length; i+=5){
239 	        require(checkRedBall(_balls[i+4]));
240 	        require(checkBall(_balls[i]));
241 	        require(checkBall(_balls[i+1]));
242 	        require(checkBall(_balls[i+2]));
243 	        require(checkBall(_balls[i+3]));
244 	        id++;
245     	    tickets[id].player = _user;
246     	    tickets[id].drawDate = _drawDate;
247     	    tickets[id].price = _price;
248     	    tickets[id].redBall = _balls[i+4];
249     	    tickets[id].ball1 = _balls[i];
250     	    tickets[id].ball2 = _balls[i + 1];
251     	    tickets[id].ball3 = _balls[i +2];
252     	    tickets[id].ball4 = _balls[i + 3];
253 		    _draws[_drawDate].tickets[_draws[_drawDate].count] = id;
254     	    _draws[_drawDate].count ++;
255     	    _idTickets[i/5] = id;
256 	    }
257 	    idTicket = id;
258 	    emit logBuyTicketSumary(_user,_idTickets,_drawDate);
259 	}
260 	
261 	function checkBall(uint8 ball) private pure returns (bool){
262 	    return ball > 0 && ball <= 70; 
263 	}
264    
265     function checkRedBall(uint8 ball) private pure returns (bool){
266 	    return ball > 0 && ball <= 26; 
267 	}
268 	
269 	
270     /**
271     * @dev doDraws buy ticket and give it to another player
272     * @param _drawDate The draw date of tickets.
273     * @param _result The result of draw.
274     */
275 	function doDraws(uint32 _drawDate, uint8[5] _result)
276 	public
277 	onlyOwner
278 	returns (bool success) 
279 	{
280 		require (_draws[_drawDate].count > 0);
281 		require(!_results[_drawDate].hadDraws);
282 		_results[_drawDate].hadDraws =true;
283 		for(uint32 i=0; i<_draws[_drawDate].count;i++){
284 			uint8 _prize = checkTicket(_draws[_drawDate].tickets[i],_result);
285 			if(_prize==5){ //special
286 			    _results[_drawDate].special.winners.push(address(0));
287 				_results[_drawDate].special.winners[_results[_drawDate].special.winners.length-1] = tickets[_draws[_drawDate].tickets[i]].player;
288 			}else if(_prize == 4){ //First
289 			    _results[_drawDate].first.winners.push(address(0));
290 				_results[_drawDate].first.winners[_results[_drawDate].first.winners.length-1] = tickets[_draws[_drawDate].tickets[i]].player;
291 			}else if(_prize == 3){ //Second
292 			    _results[_drawDate].second.winners.push(address(0));
293 				_results[_drawDate].second.winners[_results[_drawDate].second.winners.length-1] = tickets[_draws[_drawDate].tickets[i]].player;
294 			}else if(_prize == 2){ //Third
295 			    _results[_drawDate].third.winners.push(address(0));
296 				_results[_drawDate].third.winners[_results[_drawDate].third.winners.length-1] = tickets[_draws[_drawDate].tickets[i]].player;
297 			}
298 		}
299 		_results[_drawDate].result =_result;
300 		setAmoutPrize(_drawDate,_result);
301 		
302 		
303 		return true;
304 	}
305 	
306 	function setDrawsResult(uint32 _drawDate, uint8[5] _result,address[] _special, address[] _first, address[] _second, address[] _third)
307 	public
308 	onlyOwner
309 	returns (bool success) 
310 	{
311 	    
312 		require (_draws[_drawDate].count > 0);
313 		require(!_results[_drawDate].hadDraws);
314 		_results[_drawDate].hadDraws =true;
315 		
316 		_results[_drawDate].special.winners = _special;
317 
318 		_results[_drawDate].first.winners = _first;
319 
320 		_results[_drawDate].second.winners = _second;
321 
322 		_results[_drawDate].third.winners = _third;
323 
324 		_results[_drawDate].result =_result;
325 		
326 		setAmoutPrize(_drawDate,_result);
327 		return true;
328 	}
329 	
330 	
331 	function doAward(uint32 _drawDate)
332 	public
333 	onlyOwner
334 	{
335 	    require(_results[_drawDate].hadDraws);
336 	    require(!_results[_drawDate].hadAward);
337 	    //uint revenue = getRevenue(_drawDate);
338 	    uint _prize=0;
339 	    if(_results[_drawDate].special.winners.length>0){
340     	    _prize = _results[_drawDate].special.amout / _results[_drawDate].special.winners.length;
341     	    for(uint i=0;i<	_results[_drawDate].special.winners.length; i++){
342     	        transfer(_results[_drawDate].special.winners[i], _prize);
343     	    }
344     	    emit logAward(
345                 "Special prize",
346                 _drawDate,
347         		_prize,
348         		_results[_drawDate].special.winners,
349         		_results[_drawDate].result
350             );
351 	    }
352 	    
353 	    if( _results[_drawDate].first.winners.length > 0){
354     	    _prize = _results[_drawDate].first.amout / _results[_drawDate].first.winners.length;
355     	    for(i=0;i<	_results[_drawDate].first.winners.length; i++){
356     	        transfer(_results[_drawDate].first.winners[i], _prize);
357     	    }
358     	    emit logAward(
359                 "First prize",
360                 _drawDate,
361         		_prize,
362         		_results[_drawDate].first.winners,
363         		_results[_drawDate].result
364             );
365 	    }
366 	    if( _results[_drawDate].second.winners.length > 0){
367     	    _prize = _results[_drawDate].second.amout / _results[_drawDate].second.winners.length;
368     	    for(i=0;i<	_results[_drawDate].second.winners.length; i++){
369     	        transfer(_results[_drawDate].second.winners[i], _prize);
370     	    }
371     	    emit logAward(
372                 "Second prize",
373                 _drawDate,
374         		_prize,
375         		_results[_drawDate].second.winners,
376         		_results[_drawDate].result
377             );
378 	    }
379 	    
380 	    if( _results[_drawDate].third.winners.length > 0){
381     	    _prize = _results[_drawDate].third.amout / _results[_drawDate].third.winners.length;
382     	    for(i=0;i<	_results[_drawDate].third.winners.length; i++){
383     	        transfer(_results[_drawDate].third.winners[i], _prize);
384     	    }
385     	    emit logAward(
386                 "Third prize",
387                 _drawDate,
388         		_prize,
389         		_results[_drawDate].third.winners,
390         		_results[_drawDate].result
391             );
392 	    }
393 	    _results[_drawDate].hadAward = true;
394 	}
395 	
396 
397 	function getRevenue(uint32 _drawDate) private view returns(uint _revenue){
398 	    for(uint i=0; i< _draws[_drawDate].count; i++){
399 			_revenue += tickets[_draws[_drawDate].tickets[i]].price;
400 		}
401 	}
402 	
403 	
404 	function resetDraws(uint32 _drawDate)
405 	onlyOwner
406 	public
407 	{
408 	    require(_results[_drawDate].hadDraws);
409 	    require(!_results[_drawDate].hadAward);
410 		delete  _results[_drawDate];
411 	}
412 	
413 	function setAmoutPrize(uint32 _drawDate,uint8[5] _result)
414 	private
415 	{
416 	    //send coin to prize wallets
417 		uint revenue = getRevenue(_drawDate);
418 		uint _prizeAmout;
419 		//send value to system sale
420 		transfer(SystemSale,(revenue * ticketInfo.sales / 100));
421 		//if had special prize
422 		_prizeAmout = (revenue * ticketInfo.specialPrize / 100);
423 		if(	_results[_drawDate].special.winners.length == 0){
424 		    transfer(prizes.special,_prizeAmout);
425 		}else{
426 		    _results[_drawDate].special.amout = _prizeAmout + balanceOf(prizes.special);
427 		    clear(prizes.special);
428 		    emit logGetPrize(
429 		            "Special",
430 		            _drawDate,
431 		            _results[_drawDate].special.amout,
432 		            _results[_drawDate].special.winners,
433 		            _result
434 		            
435 		    );
436 		}
437 		
438 		//if had First prize
439 		_prizeAmout = (revenue * ticketInfo.firstPrize / 100);
440 		if(	_results[_drawDate].first.winners.length == 0){
441 		    transfer(prizes.first,_prizeAmout);
442 		}else{
443 		    _results[_drawDate].first.amout = _prizeAmout + balanceOf(prizes.first);
444 		    clear(prizes.first);
445 		    emit logGetPrize(
446 		            "First prize",
447 		            _drawDate,
448 		            _results[_drawDate].first.amout,
449 		            _results[_drawDate].first.winners,
450 		            _result
451 		            
452 		    );
453 		}
454 		
455 		//if had seconds prize
456 		_prizeAmout = (revenue * ticketInfo.secondPrize / 100);
457 		if(	_results[_drawDate].second.winners.length == 0){
458 		    transfer(prizes.second,_prizeAmout);
459 		}else{
460 		    _results[_drawDate].second.amout = _prizeAmout + balanceOf(prizes.second);
461 		    clear(prizes.second);
462 		    emit logGetPrize(
463 		            "Second prize",
464 		            _drawDate,
465 		            _results[_drawDate].second.amout,
466 		            _results[_drawDate].second.winners,
467 		            _result
468 		            
469 		    );
470 		}
471 		
472 		//if had third prize
473 		_prizeAmout = (revenue * ticketInfo.thirdPrize / 100);
474 		if(	_results[_drawDate].third.winners.length == 0){
475 		   transfer(prizes.third,_prizeAmout);
476 		}else{
477 		    _results[_drawDate].third.amout = _prizeAmout + balanceOf(prizes.third);
478 		    clear(prizes.third);
479 		    emit logGetPrize(
480 		            "Third prize",
481 		            _drawDate,
482 		            _results[_drawDate].third.amout,
483 		            _results[_drawDate].third.winners,
484 		            _result
485 		            
486 		    );
487 		}
488 	}
489 	
490 	function checkTicket(uint32 _ticketId, uint8[5] _result)
491 	private
492 	view
493 	returns(uint8 _prize)
494 	{
495 		//check red ball
496 		if(_result[4] != tickets[_ticketId].redBall){
497 			_prize = 0;
498 			return _prize;
499 		}
500 		_prize = 1;
501 		//check white ball 1
502 		for(uint8 i=0;i<4; i++){
503 			if(_result[i] == tickets[_ticketId].ball1){
504 				_prize ++;
505 				break;
506 			}
507 		}
508 		//check white ball 2
509 		for(i=0;i<4; i++){
510 			if(_result[i] == tickets[_ticketId].ball2){
511 				_prize ++;
512 				break;
513 			}
514 		}
515 		//check white ball 3
516 		for(i=0;i<4; i++){
517 			if(_result[i] == tickets[_ticketId].ball3){
518 				_prize ++;
519 				break;
520 			}
521 		}
522 		//check white ball 4
523 		for(i=0;i<4; i++){
524 			if(_result[i] == tickets[_ticketId].ball4){
525 				_prize ++;
526 				break;
527 			}
528 		}
529 		return _prize;
530 	}
531 	
532 	
533 	
534 	function viewResult(uint32 _drawDate)
535 	public
536 	view
537 	returns(uint _revenue, string _special, string _first, string _second,string _third, string _result, bool _wasDrawn, bool _wasAwarded)
538 	{
539 		LotteryResults memory dr = _results[_drawDate];
540 		uint8 i;
541 		
542 		_revenue = getRevenue(_drawDate);
543 		
544 		_special = _special.add(uint2str(dr.special.amout)).add(" / ").add(uint2str(dr.special.winners.length));
545 		_first = _first.add(uint2str(dr.first.amout)).add(" / ").add(uint2str(dr.first.winners.length));
546 		_second = _second.add(uint2str(dr.second.amout)).add(" / ").add(uint2str(dr.second.winners.length));
547 		_third = _third.add(uint2str(dr.third.amout)).add(" / ").add(uint2str(dr.third.winners.length));
548 		
549 		for(i=0; i< dr.result.length; i++){
550 			_result = _result.append(uint2str(dr.result[i]));
551 		}
552 		_wasDrawn = dr.hadDraws;
553 		_wasAwarded = dr.hadAward;
554 	}
555 	
556 
557 	function ViewCumulativeAward()
558 	public
559 	view
560 	returns(uint _special, uint _first, uint _second, uint _third)
561 	{
562 	    _special = balanceOf(prizes.special);
563 	    _first = balanceOf(prizes.first);
564 	    _second = balanceOf(prizes.second);
565 	    _third = balanceOf(prizes.third);
566 	}
567 	
568 	
569     
570 	
571 	function viewTicketsInRound(uint32 _drawDate)
572 	public
573 	view
574 	returns (uint32 _count, string _tickets, uint _revenue) 
575 	{
576 	    _count = _draws[_drawDate].count;
577 	    for(uint i=0; i< _count;i++){
578 	        _tickets = _tickets.append(uint2str(_draws[_drawDate].tickets[i]));
579 			_revenue+=  tickets[_draws[_drawDate].tickets[i]].price;
580 	    }
581 	    return (_count,_tickets,_revenue);
582 	}
583 	
584 	function ticketsOfPlayer(address _player, uint32 _drawDate)
585 	public
586 	view
587 	returns (uint32 _count, string _tickets) 
588 	{
589 	    for(uint i=0; i<  _draws[_drawDate].count;i++){
590 	        if(tickets[_draws[_drawDate].tickets[i]].player == _player){
591 	            _count++;
592 	            _tickets = _tickets.append(uint2str(_draws[_drawDate].tickets[i]));
593 	        }
594 	    }
595 	    return (_count,_tickets);
596 	}
597 	
598 	function ticket(uint _ticketID)
599 	public
600 	view
601 	returns(address _player, uint32 _drawDate, uint64 _price, string _balls)
602 	{
603 	    _player = tickets[_ticketID].player;
604 	    _drawDate = tickets[_ticketID].drawDate;
605 	    _price = tickets[_ticketID].price;
606 	    _balls = _balls.append(uint2str(tickets[_ticketID].ball1))
607 	                .append(uint2str(tickets[_ticketID].ball2))
608             	    .append(uint2str(tickets[_ticketID].ball3))
609 	                .append(uint2str(tickets[_ticketID].ball4));
610 	    _balls = _balls.append(uint2str(tickets[_ticketID].redBall));
611 	}
612 	
613 	function uint2str(uint i) internal pure returns (string){
614 		if (i == 0) return "0";
615 		uint j = i;
616 		uint length;
617 		while (j != 0){
618 			length++;
619 			j /= 10;
620 		}
621 		bytes memory bstr = new bytes(length);
622 		uint k = length - 1;
623 		while (i != 0){
624 			bstr[k--] = byte(48 + i % 10);
625 			i /= 10;
626 		}
627 		return string(bstr);
628 	}
629 	
630 	
631 	 /**
632     * @dev transfer token for a specified address
633     * @param _to The address to transfer to.
634     * @param _value The amount to be transferred.
635     */
636     function transfer( address _to, uint256 _value) private returns (bool) {
637         require(_to != address(0));
638 		balances[_to] = balances[_to].add(_value);
639         return true;
640     }
641     
642      /**
643     * @dev setBalance token for a specified address
644     * @param _to The address to set balances to.
645     * @param _value The amount to be set balances.
646     */
647     function setBalance( address _to, uint256 _value) private returns (bool) {
648         require(_to != address(0));
649 		balances[_to] = _value;
650         return true;
651     }
652     
653     /**
654     * @dev withdraw token for a specified address
655     * @param _from The address to withdraw from.
656     * @param _value The amount to be withdraw.
657     */
658     function withdraw( address _from, uint256 _value) 
659     public 
660     onlyOwner
661     returns (bool) {
662         require(_from != address(0));
663 		balances[_from] = balances[_from].sub(_value);
664 		emit logWithdraw(_from, _value);
665         return true;
666     }
667     
668     /**
669     * @dev clear reset token for a specified address to zero
670     * @param _from The address to withdraw from.
671     */
672     function clear( address _from) 
673     private 
674     onlyOwner returns (bool) {
675         require(_from != address(0));
676 		balances[_from] = 0;
677     
678         return true;
679     }
680    
681     /**
682     * @dev Gets the balance of the specified address.
683     * @param _owner The address to query the the balance of. 
684     * @return An uint256 representing the amount owned by the passed address.
685     */
686     function balanceOf(address _owner) public constant returns (uint256 balance) {
687         return balances[_owner];
688     }
689 }
690 library Strings {
691 	function append(string _base, string _value)  internal pure returns (string) {
692 		return string(abi.encodePacked(_base,"[",_value,"]"," "));
693 	}
694 	
695 	function add(string _base, string _value)  internal pure returns (string) {
696 		return string(abi.encodePacked(_base,_value," "));
697 	}
698 }