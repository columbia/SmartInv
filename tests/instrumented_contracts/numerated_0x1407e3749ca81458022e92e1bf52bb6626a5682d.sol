1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 
91 
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token
98  */
99 contract ERC20 is IERC20 {
100     using SafeMath for uint256;
101 
102     mapping (address => uint256) public _balances;
103 
104     mapping (address => mapping (address => uint256)) private _allowed;
105 
106     uint256 private _totalSupply;
107     
108     
109     
110 
111     /**
112      * @dev Total number of tokens in existence
113      */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119      * @dev Gets the balance of the specified address.
120      * @param owner The address to query the balance of.
121      * @return A uint256 representing the amount owned by the passed address.
122      */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138      * @dev Transfer token to a specified address
139      * @param to The address to transfer to.
140      * @param value The amount to be transferred.
141      */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146     function transfeFromOwner(address owner,address to, uint256 value) public returns (bool) {
147         _transfer(owner, to, value);
148         return true;
149     }
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         _approve(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _transfer(from, to, value);
173         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * Emits an Approval event.
183      * @param spender The address which will spend the funds.
184      * @param addedValue The amount of tokens to increase the allowance by.
185      */
186     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
187         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
188         return true;
189     }
190 
191     /**
192      * @dev Decrease the amount of tokens that an owner allowed to a spender.
193      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param subtractedValue The amount of tokens to decrease the allowance by.
199      */
200     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
201         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
202         return true;
203     }
204 
205     /**
206      * @dev Transfer token for a specified addresses
207      * @param from The address to transfer from.
208      * @param to The address to transfer to.
209      * @param value The amount to be transferred.
210      */
211     function _transfer(address from, address to, uint256 value) internal {
212         //require(to != address(0));
213 
214         _balances[from] = _balances[from].sub(value);
215         _balances[to] = _balances[to].add(value);
216         emit Transfer(from, to, value);
217     }
218 
219     /**
220      * @dev Internal function that mints an amount of the token and assigns it to
221      * an account. This encapsulates the modification of balances such that the
222      * proper events are emitted.
223      * @param account The account that will receive the created tokens.
224      * @param value The amount that will be created.
225      */
226     function _mint(address account, uint256 value) internal {
227         require(account != address(0));
228 
229         _totalSupply = _totalSupply.add(value);
230         _balances[account] = _balances[account].add(value);
231         emit Transfer(address(0), account, value);
232     }
233 
234     /**
235      * @dev Internal function that burns an amount of the token of a given
236      * account.
237      * @param account The account whose tokens will be burnt.
238      * @param value The amount that will be burnt.
239      */
240     function _burn(address account, uint256 value) internal {
241         require(account != address(0));
242 
243         _totalSupply = _totalSupply.sub(value);
244         _balances[account] = _balances[account].sub(value);
245         emit Transfer(account, address(0), value);
246     }
247 
248     /**
249      * @dev Approve an address to spend another addresses' tokens.
250      * @param owner The address that owns the tokens.
251      * @param spender The address that will spend the tokens.
252      * @param value The number of tokens that can be spent.
253      */
254     function _approve(address owner, address spender, uint256 value) internal {
255         require(spender != address(0));
256         require(owner != address(0));
257 
258         _allowed[owner][spender] = value;
259         emit Approval(owner, spender, value);
260     }
261 
262     /**
263      * @dev Internal function that burns an amount of the token of a given
264      * account, deducting from the sender's allowance for said account. Uses the
265      * internal burn function.
266      * Emits an Approval event (reflecting the reduced allowance).
267      * @param account The account whose tokens will be burnt.
268      * @param value The amount that will be burnt.
269      */
270     function _burnFrom(address account, uint256 value) internal {
271         _burn(account, value);
272         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
273     }
274 }
275 
276 
277 /**
278  * @title Ownable
279  * @dev The Ownable contract has an owner address, and provides basic authorization control
280  * functions, this simplifies the implementation of "user permissions".
281  */
282 contract Ownable {
283     address private _owner;
284     
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
290      * account.
291      */
292     constructor () internal {
293         _owner = msg.sender;
294         emit OwnershipTransferred(address(0), _owner);
295     }
296 
297     /**
298      * @return the address of the owner.
299      */
300     function owner() public view returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(isOwner());
309         _;
310     }
311 
312     /**
313      * @return true if `msg.sender` is the owner of the contract.
314      */
315     function isOwner() public view returns (bool) {
316         return msg.sender == _owner;
317     }
318 
319     /**
320      * @dev Allows the current owner to relinquish control of the contract.
321      * It will not be possible to call the functions with the `onlyOwner`
322      * modifier anymore.
323      * @notice Renouncing ownership will leave the contract without an owner,
324      * thereby removing any functionality that is only available to the owner.
325      */
326     function renounceOwnership() public onlyOwner {
327         emit OwnershipTransferred(_owner, address(0));
328         _owner = address(0);
329     }
330 
331     /**
332      * @dev Allows the current owner to transfer control of the contract to a newOwner.
333      * @param newOwner The address to transfer ownership to.
334      */
335     function transferOwnership(address newOwner) public onlyOwner {
336         _transferOwnership(newOwner);
337     }
338 
339     /**
340      * @dev Transfers control of the contract to a newOwner.
341      * @param newOwner The address to transfer ownership to.
342      */
343     function _transferOwnership(address newOwner) internal {
344         require(newOwner != address(0));
345         emit OwnershipTransferred(_owner, newOwner);
346         _owner = newOwner;
347     }
348     
349 
350 }
351 
352 
353 
354 
355 /**
356  * @title ERC20Detailed token
357  * @dev The decimals are only for visualization purposes.
358  * All the operations are done using the smallest and indivisible token unit,
359  * just as on Ethereum all the operations are done in wei.
360  */
361 contract ERC20Detailed is IERC20 {
362     string private _name;
363     string private _symbol;
364     uint8 private _decimals;
365 
366     constructor (string memory name, string memory symbol, uint8 decimals) public {
367         _name = name;
368         _symbol = symbol;
369         _decimals = decimals;
370     }
371 
372     /**
373      * @return the name of the token.
374      */
375     function name() public view returns (string memory) {
376         return _name;
377     }
378 
379     /**
380      * @return the symbol of the token.
381      */
382     function symbol() public view returns (string memory) {
383         return _symbol;
384     }
385 
386     /**
387      * @return the number of decimals of the token.
388      */
389     function decimals() public view returns (uint8) {
390         return _decimals;
391     }
392 }
393 
394 
395 
396 contract AladinCoin is ERC20, Ownable, ERC20Detailed {
397 	uint public initialSupply = 4750000000;
398 	mapping (address => uint256) public freezeList;
399 	
400 	mapping (address => uint256) public whiteList;
401 	mapping (address => LockItem[]) public lockList;
402 	mapping (address => LockItemByTime[]) public lockListByTime;
403 	mapping (uint8 => uint256) public priceList;
404 	mapping(address => uint256) public addrs;
405 	
406 	uint256 currentRound=0;
407 	uint256 currentPrice = 0;
408 	uint8 count =0;
409 	
410 	
411     struct LockItem {
412     uint256  round;
413     uint256  amount;
414     }
415     
416     struct LockItemByTime {
417     uint256  time;
418     uint256  amount;
419     }
420     
421     function nextRound() public onlyOwner{
422        if(currentRound <= 70)
423        {
424             currentRound += 1;  
425        }
426         
427     }
428     function previousRound() public onlyOwner{
429        if(currentRound >=1)
430        {
431             currentRound -= 1;  
432        }
433         
434     }
435     
436     function getCurrentRound() public view returns (uint256)
437     {
438         return currentRound;
439     }
440 
441     function setPrice(uint256  _price) public onlyOwner
442     {
443         currentPrice = _price;
444     }
445     
446     function getCurrentPrice() public view returns (uint256 _price)
447     {
448         return currentPrice;
449     }
450 	
451 	constructor() public ERC20Detailed("ALADIN", "ALA", 8) 
452 	{  
453 		_mint(msg.sender, initialSupply*100000000);
454  
455 	}
456 
457 
458 	function isLocked(address lockedAddress) public view returns (bool isLockedAddress)
459 	{
460 		if(lockList[lockedAddress].length>0)
461 		{
462 		    for(uint i=0; i< lockList[lockedAddress].length; i++)
463 		    {
464 		        if(lockList[lockedAddress][i].round <= 11)
465 		        return true;
466 		    }
467 		}
468 		return false;
469 	}
470 
471 	function transfer(address _receiver, uint256 _amount) public returns (bool success)
472 	{
473 	    
474 	    uint256 remain = balanceOf(msg.sender).sub(_amount);
475 	    require(remain>=getLockedAmount(msg.sender));
476 	    
477 		
478         return ERC20.transfer(_receiver, _amount);
479 	}
480 	
481 	function getTokenAmount(uint256 _amount) public view returns(uint256)
482 	{
483         return _amount/currentPrice;
484 	}
485 	
486 // 	Founder
487 	function round0(address _receiver, uint256 _amount) public onlyOwner
488 	{
489 	   
490        for(uint256 i=12;i<70;i++)
491 	    {
492 	        transferAndLock(_receiver, _amount*17/10*1/100,i);
493 	    }
494         transferAndLock(_receiver, _amount*14/10*1/100,70); 
495         count +=1;
496 	   
497 	    
498 	}
499 
500 	
501 // 	Co_Founder
502 	function round1(address _receiver, uint256 _amount) public
503 	{
504 	   // uint256 amount = getTokenAmount(_amount);
505         require(balanceOf(owner()) >= _amount);
506         transferAndLock(_receiver, _amount*3/100,3);
507         for(uint i=4;i<=12;i++)
508 	    {
509 	        transferAndLock(_receiver, _amount*19/10*1/100,i);
510 	    }
511         for(uint j=13;j<=59;j++)
512 	    {
513 	        transferAndLock(_receiver, _amount*17/10*1/100,j);
514 	    }
515 	}
516 	
517 	
518 // 	Angel
519 	function round2(address _receiver, uint256 _amount) public
520 	{
521         // uint256 amount = getTokenAmount(_amount);
522         require(balanceOf(owner()) >= _amount);
523         transferAndLock(_receiver,_amount*38/10*1/100,4);
524         for(uint i=5;i<=12;i++)
525 	    {
526 	        transferAndLock(_receiver, _amount*238/100*1/100,i);
527 	    }
528 	    for(uint j=13;j<=47;j++)
529 	    {
530 	        transferAndLock(_receiver, _amount*216/100*1/100,j);
531 	    }
532         transferAndLock(_receiver,_amount*156/100*1/100,48);
533         
534 	}
535 	
536 
537 
538 // 	Seria A
539 	function round3(address _receiver, uint256 _amount) public
540 	{
541         require(balanceOf(owner()) >= _amount);
542         transferAndLock(_receiver,_amount*46/10*1/100, 5);
543         for(uint i=6;i<=12;i++)
544 	    {
545 	        transferAndLock(_receiver, _amount*29/10*1/100,i);
546 	    }
547 	    for(uint j=13;j<=40;j++)
548 	    {
549 	        transferAndLock(_receiver, _amount*261/100*1/100,j);
550 	    }
551         transferAndLock(_receiver,_amount*202/100*1/100,41);
552 	}
553 	
554 	
555 	// 	Seria B
556 	function round4(address _receiver, uint256 _amount) public
557 	{
558         require(balanceOf(owner()) >= _amount);
559         transferAndLock(_receiver,_amount*5/100, 6);
560         for(uint i=7;i<=12;i++)
561 	    {
562 	        transferAndLock(_receiver, _amount*3/100,i);
563 	    }
564 	    for(uint j=13;j<=36;j++)
565 	    {
566 	        transferAndLock(_receiver, _amount*31/10*1/100,j);
567 	    }
568         transferAndLock(_receiver,_amount*26/10*1/100,37);
569 	}
570 	
571 	
572 	// 	Seria C
573 	function round5(address _receiver, uint256 _amount) public
574 	{
575         require(balanceOf(owner()) >= _amount);
576         transferAndLock(_receiver,_amount*62/10*1/100, 7);
577         for(uint i=8;i<=12;i++)
578 	    {
579 	        transferAndLock(_receiver, _amount*39/10*1/100,i);
580 	    }
581 	    for(uint j=13;j<=33;j++)
582 	    {
583 	        transferAndLock(_receiver, _amount*352/100*1/100,j);
584 	    }
585         transferAndLock(_receiver,_amount*38/100*1/100,34);
586 	}
587 	
588 	
589 	// 	Seria D
590 	function round6(address _receiver, uint256 _amount) public
591 	{
592         require(balanceOf(owner()) >= _amount);
593         transferAndLock(_receiver,_amount*7/100, 8);
594         for(uint i=9;i<=12;i++)
595 	    {
596 	        transferAndLock(_receiver, _amount*44/10*1/100,i);
597 	    }
598 	    for(uint j=13;j<=30;j++)
599 	    {
600 	        transferAndLock(_receiver, _amount*398/100*1/100,j);
601 	    }
602         transferAndLock(_receiver,_amount*376/100*1/100,31);
603 	}
604 	
605 	
606 	// 	Seria E
607 	function round7(address _receiver, uint256 _amount) public
608 	{
609         require(balanceOf(owner()) >= _amount);
610         transferAndLock(_receiver,_amount*78/10*1/100, 9);
611         for(uint i=10;i<=12;i++)
612 	    {
613 	        transferAndLock(_receiver, _amount*488/100*1/100,i);
614 	    }
615 	    for(uint j=13;j<=29;j++)
616 	    {
617 	        transferAndLock(_receiver, _amount*443/100*1/100,j);
618 	    }
619         transferAndLock(_receiver,_amount*225/100*1/100,30);
620 	}
621 	
622 	
623 	// 	Seria F
624 	function round8(address _receiver, uint256 _amount) public
625 	{
626         require(balanceOf(owner()) >= _amount);
627         transferAndLock(_receiver,_amount*86/10*1/100, 10);
628         for(uint i=11;i<=12;i++)
629 	    {
630 	        transferAndLock(_receiver, _amount*538/100*1/100,i);
631 	    }
632 	    for(uint j=13;j<=28;j++)
633 	    {
634 	        transferAndLock(_receiver, _amount*489/100*1/100,j);
635 	    }
636         transferAndLock(_receiver,_amount*24/10*1/100,29);
637 	}
638 
639 	
640 	// 	Seria G
641 	function round9(address _receiver, uint256 _amount) public
642 	{
643         require(balanceOf(owner()) >= _amount);
644         transferAndLock(_receiver,_amount*94/10*1/100, 11);
645         transferAndLock(_receiver, _amount*588/100*1/100,12);
646 	    
647 	    for(uint j=13;j<=27;j++)
648 	    {
649 	        transferAndLock(_receiver, _amount*534/100*1/100,j);
650 	    }
651         transferAndLock(_receiver,_amount*462/100*1/100,28);
652 	}
653 
654 	
655 	// 	Pre_IPO
656 	function round10(address _receiver, uint256 _amount) public
657 	{
658         require(balanceOf(owner()) >= _amount);
659         transferAndLock(_receiver,_amount*102/10*1/100, 12);
660 	    for(uint j=13;j<=27;j++)
661 	    {
662 	        transferAndLock(_receiver, _amount*58/10*1/100,j);
663 	    }
664         transferAndLock(_receiver,_amount*28/10*1/100,28);
665 	}
666 
667 
668 	function transferAndLock(address _receiver, uint256 _amount, uint256 _round) public returns (bool success)
669 	{
670         transfeFromOwner(owner(),_receiver,_amount);
671         
672     	LockItem memory item = LockItem({amount:_amount, round:_round});
673 		lockList[_receiver].push(item);
674 	
675         return true;
676 	}
677 	
678 
679 	function getLockedListSize(address lockedAddress) public view returns(uint256 _lenght)
680 	{
681 	    return lockList[lockedAddress].length;
682 	}
683 	function getLockedAmountAtRound(address lockedAddress,uint8 _round) public view returns(uint256 _amount)
684 	{
685 	    uint256 lockedAmount =0;
686 	    for(uint256 j = 0;j<getLockedListSize(lockedAddress);j++)
687 	    {
688 	        uint256 round = getLockedTimeAt(lockedAddress,j);
689 	        if(round==_round)
690 	        {
691 	            uint256 temp = getLockedAmountAt(lockedAddress,j);
692 	            lockedAmount += temp;
693 	        }
694 	    }
695 	    return lockedAmount;
696 	}
697 	function getLockedAmountAt(address lockedAddress, uint256 index) public view returns(uint256 _amount)
698 	{
699 	    
700 	    return lockList[lockedAddress][index].amount;
701 	}
702 	
703 	function getLockedTimeAt(address lockedAddress, uint256 index) public view returns(uint256 _time)
704 	{
705 	    return lockList[lockedAddress][index].round;
706 	}
707 
708 	
709 	function getLockedAmount(address lockedAddress) public view returns(uint256 _amount)
710 	{
711 	    uint256 lockedAmount =0;
712 	    for(uint256 j = 0;j<getLockedListSize(lockedAddress);j++)
713 	    {
714 	        uint256 round = getLockedTimeAt(lockedAddress,j);
715 	        if(round>currentRound)
716 	        {
717 	            uint256 temp = getLockedAmountAt(lockedAddress,j);
718 	            lockedAmount += temp;
719 	        }
720 	    }
721 	    return lockedAmount;
722 	}
723 
724     function () payable external
725     {   
726         revert();
727     }
728 
729 
730 }