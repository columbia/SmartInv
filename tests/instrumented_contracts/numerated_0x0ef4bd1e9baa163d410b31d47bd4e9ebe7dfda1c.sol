1 // mock class using ERC20
2 pragma solidity ^0.4.24;
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param spender The address which will spend the funds.
166    * @param value The amount of tokens to be spent.
167    */
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170 
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param from address The address which you want to send tokens from
179    * @param to address The address which you want to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(
183     address from,
184     address to,
185     uint256 value
186   )
187     public
188     returns (bool)
189   {
190     require(value <= _allowed[from][msg.sender]);
191 
192     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
193     _transfer(from, to, value);
194     return true;
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed_[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param spender The address which will spend the funds.
204    * @param addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseAllowance(
207     address spender,
208     uint256 addedValue
209   )
210     public
211     returns (bool)
212   {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = (
216       _allowed[msg.sender][spender].add(addedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseAllowance(
231     address spender,
232     uint256 subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].sub(subtractedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246   * @dev Transfer token for a specified addresses
247   * @param from The address to transfer from.
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   */
251   function _transfer(address from, address to, uint256 value) internal {
252     require(value <= _balances[from]);
253     require(to != address(0));
254 
255     _balances[from] = _balances[from].sub(value);
256     _balances[to] = _balances[to].add(value);
257     emit Transfer(from, to, value);
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param value The amount that will be created.
266    */
267   function _mint(address account, uint256 value) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(value);
270     _balances[account] = _balances[account].add(value);
271     emit Transfer(address(0), account, value);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param value The amount that will be burnt.
279    */
280   function _burn(address account, uint256 value) internal {
281     require(account != 0);
282     require(value <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(value);
285     _balances[account] = _balances[account].sub(value);
286     emit Transfer(account, address(0), value);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param value The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 value) internal {
297     require(value <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       value);
303     _burn(account, value);
304   }
305 }
306 
307 /**
308  * @title Standard ERC20 token
309  *
310  * @dev Implementation of the basic standard token.
311  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
312  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
313  */
314 contract EdxToken is ERC20 {
315   using SafeMath for uint256;
316 	string public name = "Enterprise Decentralized Token";
317 	string public symbol = "EDX";
318 	uint8 public decimals = 18;
319 
320 	struct VestInfo { // Struct
321 			uint256 vested;
322 			uint256 remain;
323 	}
324 	struct CoinInfo {
325 		uint256 bsRemain;
326 		uint256 tmRemain;
327 		uint256 peRemain;
328 		uint256 remains;
329 	}
330 	struct GrantInfo {
331 		address holder;
332 		uint256 remain;
333 	}
334   mapping (address => uint256) private _balances;		 //balance of transferrable
335   mapping (address => VestInfo) private _bs_balance; //info of vested
336   mapping (address => VestInfo) private _pe_balance;
337   mapping (address => VestInfo) private _tm_balance;
338   mapping (address => mapping (address => uint256)) private _allowed;
339 
340   uint    _releaseTime;
341   bool    mainnet;
342   uint256 private _totalSupply;
343   address _owner;
344 	GrantInfo _bsholder;
345 	GrantInfo _peholder;
346 	GrantInfo _tmholder;
347   CoinInfo supplies;
348 
349   event Transfer(address indexed from, address indexed to, uint256 value);
350   event Mint(uint8 mtype,uint256 value);
351   event Burn(uint8 mtype,uint256 value);
352 	event Invest( address indexed account, uint indexed mtype, uint256 vested);
353   event Migrate(address indexed account,uint8 indexed mtype,uint256 vested,uint256 remain);
354 
355   constructor() public {
356 		// 450 million , other 1.05 billion will be minted
357 		_totalSupply = 450*(10**6)*(10**18);
358 		_owner = msg.sender;
359 
360 		supplies.bsRemain = 80*1000000*(10**18);
361 		supplies.peRemain = 200*1000000*(10**18);
362 		supplies.tmRemain = 75*1000000*(10**18);
363 		supplies.remains =  95*1000000*(10**18);
364 		//_balances[_owner] = supplies.remains;
365 		mainnet = false;
366 	}
367   /**
368   * @dev Total number of tokens in existence
369   */
370   function totalSupply() public view returns (uint256) {
371     return _totalSupply;
372   }
373 	function getSupplies() public view returns (uint256,uint256,uint256,uint256) {
374 	    require(msg.sender == _owner);
375 
376 	    return (supplies.remains,supplies.bsRemain,supplies.peRemain,supplies.tmRemain);
377 
378 	}
379   /**
380   * @dev Gets the balance of the specified address.
381   * @param owner The address to query the balance of.
382   * @return An uint256 representing the amount owned by the passed address.
383   */
384   function balanceOf(address owner) public view returns (uint256) {
385 		uint256 result = 0;
386 		result = result.add(_balances[owner]).add(_bs_balance[owner].remain).add(_pe_balance[owner].remain).add(_tm_balance[owner].remain);
387 
388     return result;
389   }
390     function  detailedBalance(address account, uint dtype) public view returns(uint256,uint256) {
391 
392         if (dtype == 0 || dtype == 1) {
393 					  uint256 result = balanceOf(account);
394 						uint256 locked = getBSBalance(account).add(getPEBalance(account)).add(getTMBalance(account));
395 						if(dtype == 0){
396 						   return (result,locked);
397 						}else{
398 							 return (result,result.sub(locked));
399 						}
400 
401         } else if( dtype ==  2 ) {
402             return  (_bs_balance[account].vested,getBSBalance(account));
403         }else if (dtype ==  3){
404 					  return (_pe_balance[account].vested,getPEBalance(account));
405 		}else if (dtype ==  4){
406 					  return (_tm_balance[account].vested,getTMBalance(account));
407 		}else {
408 		    return (0,0);
409 		 }
410 
411     }
412 	//set rol for account
413 	function grantRole(address account,uint8 mtype,uint256 amount) public{
414 		require(msg.sender == _owner);
415 
416 			if(_bsholder.holder == account) {
417 				_bsholder.holder = address(0);
418 			}
419 			if(_peholder.holder == account){
420 				_peholder.holder = address(0);
421 			}
422 			if(_tmholder.holder == account){
423 					_tmholder.holder = address(0);
424 			}
425 		 if(mtype == 2) {
426 			 require(supplies.bsRemain >= amount);
427 			 _bsholder.holder = account;
428 			 _bsholder.remain = amount;
429 
430 		}else if(mtype == 3){
431 			require(supplies.peRemain >= amount);
432 			_peholder.holder = account;
433 			_peholder.remain = amount;
434 		}else if(mtype == 4){
435 			require(supplies.tmRemain >= amount);
436 			_tmholder.holder = account;
437 			_tmholder.remain = amount;
438 		}
439 	}
440 	function roleInfo(uint8 mtype)  public view returns(address,uint256) {
441 		if(mtype == 2) {
442 			return (_bsholder.holder,_bsholder.remain);
443 		} else if(mtype == 3) {
444 			return (_peholder.holder,_peholder.remain);
445 		}else if(mtype == 4) {
446 			return (_tmholder.holder,_tmholder.remain);
447 		}else {
448 			return (address(0),0);
449 		}
450 	}
451 	function  transferBasestone(address account, uint256 value) public {
452 		require(msg.sender == _owner);
453 		_transferBasestone(account,value);
454 
455 	}
456 	function  _transferBasestone(address account, uint256 value) internal {
457 
458 		require(supplies.bsRemain > value);
459 		supplies.bsRemain = supplies.bsRemain.sub(value);
460 		_bs_balance[account].vested = _bs_balance[account].vested.add(value);
461 		_bs_balance[account].remain = _bs_balance[account].remain.add(value);
462 
463 	}
464 	function  transferPE(address account, uint256 value) public {
465 		require(msg.sender == _owner);
466 		_transferPE(account,value);
467 	}
468 	function  _transferPE(address account, uint256 value) internal {
469 		require(supplies.peRemain > value);
470 		supplies.peRemain = supplies.peRemain.sub(value);
471 		_pe_balance[account].vested = _pe_balance[account].vested.add(value);
472 		_pe_balance[account].remain = _pe_balance[account].remain.add(value);
473 	}
474 	function  transferTM(address account, uint256 value) public {
475 		require(msg.sender == _owner);
476 		_transferTM(account,value);
477 	}
478 	function  _transferTM(address account, uint256 value) internal {
479 		require(supplies.tmRemain > value);
480 		supplies.tmRemain = supplies.tmRemain.sub(value);
481 		_tm_balance[account].vested = _tm_balance[account].vested.add(value);
482 		_tm_balance[account].remain = _tm_balance[account].remain.add(value);
483 	}
484 
485 
486   /**
487    * @dev Function to check the amount of tokens that an owner allowed to a spender.
488    * @param owner address The address which owns the funds.
489    * @param spender address The address which will spend the funds.
490    * @return A uint256 specifying the amount of tokens still available for the spender.
491    */
492   function allowance(
493     address owner,
494     address spender
495    )
496     public
497     view
498     returns (uint256)
499   {
500     return _allowed[owner][spender];
501   }
502 
503   /**
504   * @dev Transfer token for a specified address
505   * @param to The address to transfer to.
506   * @param value The amount to be transferred.
507   */
508   function transfer(address to, uint256 value) public returns (bool) {
509 		if(msg.sender == _owner){
510 			require(supplies.remains >= value);
511 			require(to != address(0));
512 			supplies.remains = supplies.remains.sub(value);
513 			_balances[to] = _balances[to].add(value);
514 			emit Transfer(address(0), to, value);
515 		}else if(msg.sender == _bsholder.holder ){
516 			require(_bsholder.remain >= value);
517 			_bsholder.remain = _bsholder.remain.sub(value);
518 			_transferBasestone(to,value);
519 
520 		}else if(msg.sender == _peholder.holder) {
521 			require(_peholder.remain >= value);
522 			_peholder.remain = _peholder.remain.sub(value);
523 			_transferPE(to,value);
524 
525 		}else if(msg.sender == _tmholder.holder){
526 			require(_tmholder.remain >= value);
527 			_tmholder.remain = _tmholder.remain.sub(value);
528 			_transferTM(to,value);
529 
530 		}else{
531     	_transfer(msg.sender, to, value);
532 		}
533 
534     return true;
535   }
536 
537   /**
538    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
539    * Beware that changing an allowance with this method brings the risk that someone may use both the old
540    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
541    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
542    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
543    * @param spender The address which will spend the funds.
544    * @param value The amount of tokens to be spent.
545    */
546   function approve(address spender, uint256 value) public returns (bool) {
547     require(spender != address(0));
548 
549     _allowed[msg.sender][spender] = value;
550     emit Approval(msg.sender, spender, value);
551     return true;
552   }
553 
554   /**
555    * @dev Transfer tokens from one address to another
556    * @param from address The address which you want to send tokens from
557    * @param to address The address which you want to transfer to
558    * @param value uint256 the amount of tokens to be transferred
559    */
560   function transferFrom(
561     address from,
562     address to,
563     uint256 value
564   )
565     public
566     returns (bool)
567   {
568     require(value <= _allowed[from][msg.sender]);
569 
570     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
571     _transfer(from, to, value);
572     return true;
573   }
574 
575   /**
576    * @dev Increase the amount of tokens that an owner allowed to a spender.
577    * approve should be called when allowed_[_spender] == 0. To increment
578    * allowed value is better to use this function to avoid 2 calls (and wait until
579    * the first transaction is mined)
580    * From MonolithDAO Token.sol
581    * @param spender The address which will spend the funds.
582    * @param addedValue The amount of tokens to increase the allowance by.
583    */
584   function increaseAllowance(
585     address spender,
586     uint256 addedValue
587   )
588     public
589     returns (bool)
590   {
591     require(spender != address(0));
592 
593     _allowed[msg.sender][spender] = (
594     _allowed[msg.sender][spender].add(addedValue));
595     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
596     return true;
597   }
598 
599   /**
600    * @dev Decrease the amount of tokens that an owner allowed to a spender.
601    * approve should be called when allowed_[_spender] == 0. To decrement
602    * allowed value is better to use this function to avoid 2 calls (and wait until
603    * the first transaction is mined)
604    * From MonolithDAO Token.sol
605    * @param spender The address which will spend the funds.
606    * @param subtractedValue The amount of tokens to decrease the allowance by.
607    */
608   function decreaseAllowance(
609     address spender,
610     uint256 subtractedValue
611   )
612     public
613     returns (bool)
614   {
615     require(spender != address(0));
616 
617     _allowed[msg.sender][spender] = (
618     _allowed[msg.sender][spender].sub(subtractedValue));
619     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
620     return true;
621   }
622 
623   /**
624   * @dev Transfer token for a specified addresses
625   * @param from The address to transfer from.
626   * @param to The address to transfer to.
627   * @param value The amount to be transferred.
628   */
629   function _transfer(address from, address to, uint256 value) internal {
630 
631 		_moveBSBalance(from);
632 		_movePEBalance(from);
633 		_moveTMBalance(from);
634     require(value <= _balances[from]);
635     require(to != address(0));
636 
637     _balances[from] = _balances[from].sub(value);
638     _balances[to] = _balances[to].add(value);
639     emit Transfer(from, to, value);
640   }
641 
642 
643 
644 //上所，开始分发
645 	function release() public {
646 		require(msg.sender == _owner);
647 		if(_releaseTime == 0) {
648 			_releaseTime = now;
649 		}
650 	}
651 	function getBSBalance(address account) public view returns(uint256){
652 		uint  elasped = now - _releaseTime;
653 		uint256 shouldRemain = _bs_balance[account].remain;
654 		if( _releaseTime !=  0 && now > _releaseTime && _bs_balance[account].remain > 0){
655 
656 			if(elasped < 180 days) { //
657 				shouldRemain = _bs_balance[account].vested.mul(9).div(10);
658 			} else if(elasped < 420 days) {
659 					shouldRemain = _bs_balance[account].vested .mul(6).div(10);
660 			} else if( elasped < 720 days) {
661 					shouldRemain = _bs_balance[account].vested .mul(3).div(10);
662 			}else {
663 				shouldRemain = 0;
664 			}
665 
666 		}
667 		return shouldRemain;
668 	}
669 	//基石代币释放
670 	function _moveBSBalance(address account) internal {
671 		uint256 shouldRemain = getBSBalance(account);
672 		if(_bs_balance[account].remain > shouldRemain) {
673 			uint256 toMove = _bs_balance[account].remain.sub(shouldRemain);
674 			_bs_balance[account].remain = shouldRemain;
675 			_balances[account] = _balances[account].add(toMove);
676 		}
677 	}
678 	function getPEBalance(address account) public view returns(uint256) {
679 		uint  elasped = now - _releaseTime;
680 		uint256 shouldRemain = _pe_balance[account].remain;
681 		if( _releaseTime !=  0 && _pe_balance[account].remain > 0){
682 
683 
684 			if(elasped < 150 days) { //首先释放10%
685 				shouldRemain = _pe_balance[account].vested.mul(9).div(10);
686 
687 			} else if(elasped < 330 days) {//5-11个月
688 					shouldRemain = _pe_balance[account].vested .mul(6).div(10);
689 			} else if( elasped < 540 days) {//11-18个月
690 					shouldRemain = _pe_balance[account].vested .mul(3).div(10);
691 			} else {
692 					shouldRemain = 0;
693 			}
694 
695 		}
696 		return shouldRemain;
697 	}
698 	//私募代币释放
699 	function _movePEBalance(address account) internal {
700 		uint256 shouldRemain = getPEBalance(account);
701 		if(_pe_balance[account].remain > shouldRemain) {
702 			uint256 toMove = _pe_balance[account].remain.sub(shouldRemain);
703 			_pe_balance[account].remain = shouldRemain;
704 			_balances[account] = _balances[account].add(toMove);
705 		}
706 	}
707 	function getTMBalance(address account ) public view returns(uint256){
708 		uint  elasped = now - _releaseTime;
709 		uint256 shouldRemain = _tm_balance[account].remain;
710 		if( _releaseTime !=  0 && _tm_balance[account].remain > 0){
711 			//三个月起，每天释放千分之一，
712 			if(elasped < 90 days) { //release 10%
713 				shouldRemain = _tm_balance[account].vested;
714 			} else {
715 					//release other 90% linearly
716 					elasped = elasped / 1 days;
717 					if(elasped <= 1090){
718 							shouldRemain = _tm_balance[account].vested.mul(1090-elasped).div(1000);
719 					}else {
720 							shouldRemain = 0;
721 					}
722 			}
723 		}
724 		return shouldRemain;
725 	}
726 	function _moveTMBalance(address account ) internal {
727 		uint256 shouldRemain = getTMBalance(account);
728 		if(_tm_balance[account].remain > shouldRemain) {
729 			uint256 toMove = _tm_balance[account].remain.sub(shouldRemain);
730 			_tm_balance[account].remain = shouldRemain;
731 			_balances[account] = _balances[account].add(toMove);
732 		}
733 	}
734 	//增发
735  function _mint(uint256 value) public {
736 	 require(msg.sender == _owner);
737 	 require(mainnet == false); //主网上线后冻结代币
738 	 _totalSupply = _totalSupply.add(value);
739 	 //增发的部分总是可以自由转移的
740 	 supplies.remains = supplies.remains.add(value);
741 	 		emit Mint(1,value);
742  }
743  //增发
744  function _mintBS(uint256 value) public {
745 	require(msg.sender == _owner);
746 		require(mainnet == false); //主网上线后冻结代币
747 	_totalSupply = _totalSupply.add(value);
748 	//增发的部分总是可以自由转移的
749 	supplies.bsRemain = supplies.bsRemain.add(value);
750 			emit Mint(2,value);
751  }
752  //增发
753  function _mintPE(uint256 value) public {
754 	require(msg.sender == _owner);
755 		require(mainnet == false); //主网上线后冻结代币
756 	_totalSupply = _totalSupply.add(value);
757 	//增发的部分总是可以自由转移的
758 	supplies.peRemain = supplies.peRemain.add(value);
759 		emit Mint(3,value);
760  }
761  //销毁
762  function _burn(uint256 value) public {
763 	require(msg.sender == _owner);
764 	require(mainnet == false); //主网上线后冻结代币
765 	require(supplies.remains >= value);
766 	_totalSupply = _totalSupply.sub(value);
767 	supplies.remains = supplies.remains.sub(value);
768 	emit Burn(0,value);
769  }
770   //销毁团队的
771  function _burnTM(uint256 value) public {
772 	require(msg.sender == _owner);
773 	require(mainnet == false); //主网上线后冻结代币
774 	require(supplies.remains >= value);
775 	_totalSupply = _totalSupply.sub(value);
776 	supplies.tmRemain = supplies.tmRemain.sub(value);
777   emit Burn(3,value);
778  }
779  //主网上线，允许迁移代币
780  function startupMainnet() public {
781      require(msg.sender == _owner);
782 
783      mainnet = true;
784  }
785  //migrate to mainnet, erc20 will be destoryed, and coin will be created at same address on mainnet
786  function migrate() public {
787      //only runnable after mainnet started up
788      require(mainnet == true);
789      require(msg.sender != _owner);
790      uint256 value;
791      if( _balances[msg.sender] > 0) {
792          value = _balances[msg.sender];
793          _balances[msg.sender] = 0;
794          emit Migrate(msg.sender,0,value,value);
795      }
796      if( _bs_balance[msg.sender].remain > 0) {
797          value = _bs_balance[msg.sender].remain;
798          _bs_balance[msg.sender].remain = 0;
799          emit Migrate(msg.sender,1,_bs_balance[msg.sender].vested,value);
800      }
801      if( _pe_balance[msg.sender].remain > 0) {
802          value = _pe_balance[msg.sender].remain;
803          _pe_balance[msg.sender].remain = 0;
804          emit Migrate(msg.sender,2,_pe_balance[msg.sender].vested,value);
805      }
806      if( _tm_balance[msg.sender].remain > 0){
807           value = _tm_balance[msg.sender].remain;
808          _tm_balance[msg.sender].remain = 0;
809          emit Migrate(msg.sender,3,_pe_balance[msg.sender].vested,value);
810      }
811 
812  }
813  //团队的奖励，分批逐步发送，可以撤回未发放的
814 	function revokeTMBalance(address account) public {
815 	        require(msg.sender == _owner);
816 			if(_tm_balance[account].remain > 0  && _tm_balance[account].vested >= _tm_balance[account].remain ){
817 				_tm_balance[account].vested = _tm_balance[account].vested.sub(_tm_balance[account].remain);
818 				_tm_balance[account].remain = 0;
819 				supplies.tmRemain = supplies.tmRemain.add(_tm_balance[account].remain);
820 			}
821 	}
822 }