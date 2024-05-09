1 pragma solidity ^0.4.18;
2 
3 /**
4  * Followine Token (WINE). More info www.followine.io
5  */
6 
7  contract Ownable {
8    address public owner;
9  
10    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11  
12    /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16    constructor() internal {
17      owner = msg.sender;
18    }
19  
20    /**
21     * @dev Throws if called by any account other than the owner.
22     */
23    modifier onlyOwner() {
24      require(msg.sender == owner);
25      _;
26    }
27  
28    /**
29     * @dev Allows the current owner to transfer control of the contract to a newOwner.
30     * @param newOwner The address to transfer ownership to.
31     */
32    function transferOwnership(address newOwner) onlyOwner public {
33      require(newOwner != address(0));
34      emit OwnershipTransferred(owner, newOwner);
35      owner = newOwner;
36    }
37  }
38 
39  contract Authorizable is Ownable {
40    mapping(address => bool) public authorized;
41    mapping(address => bool) public blocked;
42 
43    event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
44 
45    /**
46     * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
47     * account.
48     */
49    constructor() public {
50  	authorized[msg.sender] = true;
51    }
52 
53    /**
54     * @dev Throws if called by any account other than the authorized.
55     */
56    modifier onlyAuthorized() {
57      require(authorized[msg.sender]);
58      _;
59    }
60 
61   /**
62     * @dev Allows the current owner to set an authorization.
63     * @param addressAuthorized The address to change authorization.
64     */
65    function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
66      emit AuthorizationSet(addressAuthorized, authorization);
67      authorized[addressAuthorized] = authorization;
68    }
69 
70    function setBlocked(address addressAuthorized, bool authorization) onlyOwner public {
71      blocked[addressAuthorized] = authorization;
72    }
73 
74  }
75 
76 contract Startable is Ownable, Authorizable {
77   event Start();
78   event StopV();
79 
80   bool public started = false;
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is started.
84    */
85   modifier whenStarted() {
86 	require( (started || authorized[msg.sender]) && !blocked[msg.sender] );
87     _;
88   }
89 
90   /**
91    * @dev called by the owner to start, go to normal state
92    */
93   function start() onlyOwner public {
94     started = true;
95     emit Start();
96   }
97 
98   function stop() onlyOwner public {
99     started = false;
100     emit StopV();
101   }
102 
103 }
104 contract ERC20Basic {
105   uint256 public totalSupply;
106   function balanceOf(address who) public constant returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public constant returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   /**
123   * @dev transfer token from an address to another specified address
124   * @param _sender The address to transfer from.
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
129     require(_to != address(0));
130     require(_to != address(this));
131     require(_value <= balances[_sender]);
132 
133     // SafeMath.sub will throw if there is not enough balance.
134     balances[_sender] = balances[_sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     emit Transfer(_sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev transfer token for a specified address (BasicToken transfer method)
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144 	return transferFunction(msg.sender, _to, _value);
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public constant returns (uint256 balance) {
153     return balances[_owner];
154   }
155 }
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_to != address(this));
170     require(_value <= balances[_from]);
171     require(_value <= allowed[_from][msg.sender]);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176     emit Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    */
212   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
213     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 contract StartToken is Startable, StandardToken {
232     struct Pay{
233         uint256 date;
234         uint256 value;
235         uint256 category;
236     }
237 
238     mapping( address => Pay[] ) log;
239 
240     mapping( address => uint256) transferredCoin;
241 
242 
243   function addLog(address id, uint256 _x, uint256 _y, uint256 _z) internal {
244         log[id].push(Pay(_x,_y,_z));
245   }
246 
247   function addTransferredCoin(address id, uint256 _x) private {
248         transferredCoin[id] = transferredCoin[id] + _x;
249   }
250 
251   function getFreeCoin(address field) private view returns (uint256){
252         uint arrayLength = log[field].length;
253         uint256 totalValue = 0;
254         for (uint i=0; i<arrayLength; i++) {
255             uint256 date = log[field][i].date;
256             uint256 value = log[field][i].value;
257             uint256 category = log[field][i].category;
258             // category = 1 acquisto private sale
259             // category = 2 acquisto pre-ico
260             // category = 3 acquisto ico
261             // category = 4 acquisto bounty
262             // category = 5 acquisto airdrop
263             // category = 6 acquisto team
264             // category = 7 acquisto advisor
265             // category = 8 fondi bloccati per le aziende
266             if( category == 1 || category == 2 ){
267                 if( (date + 750 days) <= now ){
268                     totalValue += value;
269                 }else if( (date + 510 days) <= now ){
270                     totalValue += value.mul(60).div(100);
271                 }else if( (date + 390 days) <= now ){
272                     totalValue += value.mul(30).div(100);
273                 }
274             }
275             if( category == 3 ){
276                 if( (date + 690 days) <= now ){
277                     totalValue += value;
278                 }else if( (date + 480 days) <= now ){
279                     totalValue += value.mul(60).div(100);
280                 }else if( (date + 300 days) <= now ){
281                     totalValue += value.mul(30).div(100);
282                 }
283             }
284             if( category == 4 || category == 5 ){
285                 if( (date + 720 days) <= now ){
286                     totalValue += value;
287                 }else if( (date + 540 days) <= now ){
288                     totalValue += value.mul(75).div(100);
289                 }else if( (date + 360 days) <= now ){
290                     totalValue += value.mul(50).div(100);
291                 }
292             }
293             if( category == 6 ){
294                 if( (date + 1020 days) <= now ){
295                     totalValue += value;
296                 }else if( (date + 810 days) <= now ){
297                     totalValue += value.mul(70).div(100);
298                 }else if( (date + 630 days) <= now ){
299                     totalValue += value.mul(40).div(100);
300                 }else if( (date + 450 days) <= now ){
301                     totalValue += value.mul(20).div(100);
302                 }
303             }
304             if( category == 7 ){
305                 if( (date + 810 days) <= now ){
306                     totalValue += value;
307                 }else if( (date + 600 days) <= now ){
308                     totalValue += value.mul(80).div(100);
309                 }else if( (date + 420 days) <= now ){
310                     totalValue += value.mul(40).div(100);
311                 }
312             }
313             if( category == 8 ){
314                 uint256 numOfMonths = now.sub(date).div(60).div(60).div(24).div(30).div(6);
315                 if( numOfMonths > 20 ){
316                     numOfMonths = 20;
317                 }
318                 uint256 perc = 5;
319                 totalValue += value.mul((perc.mul(numOfMonths))).div(100);
320             }
321             if( category == 0 ){
322                 totalValue += value;
323             }
324         }
325         totalValue = totalValue - transferredCoin[field];
326         return totalValue;
327   }
328 
329   function deleteCoin(address field,uint256 val) internal {
330         uint arrayLength = log[field].length;
331         for (uint i=0; i<arrayLength; i++) {
332             uint256 value = log[field][i].value;
333             if( value >= val ){
334                 log[field][i].value = value - val;
335                 break;
336             }else{
337                 val = val - value;
338                 log[field][i].value = 0;
339             }
340         }
341   }
342 
343   function getMyFreeCoin(address _addr) public constant returns(uint256) {
344       return getFreeCoin(_addr);
345   }
346 
347   function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
348         if( getFreeCoin(msg.sender) >= _value ){
349             if( super.transfer(_to, _value) ){
350                 addLog(_to,now,_value,0);
351                 addTransferredCoin(msg.sender,_value);
352                 return true;
353             }else{
354                 return false;
355             }
356         }
357   }
358 
359 
360   function transferCustom(address _to, uint256 _value, uint256 _cat) onlyOwner whenStarted public returns(bool success) {
361 	    addLog(_to,now,_value,_cat);
362 	    return super.transfer(_to, _value);
363   }
364 
365   function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
366         if( getFreeCoin(_from) >= _value ){
367             if( super.transferFrom(_from, _to, _value) ){
368                 addLog(_to,now,_value,0);
369                 addTransferredCoin(_from,_value);
370                 return true;
371             }else{
372                 return false;
373             }
374         }
375   }
376 
377   function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
378       if( getFreeCoin(msg.sender) >= _value ){
379           return super.approve(_spender, _value);
380       }else{
381           revert();
382       }
383   }
384 
385   function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
386       if( getFreeCoin(msg.sender) >= allowed[msg.sender][_spender].add(_addedValue) ){
387           return super.increaseApproval(_spender, _addedValue);
388       }
389   }
390 
391   function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
392     return super.decreaseApproval(_spender, _subtractedValue);
393   }
394 
395 }
396 
397 contract HumanStandardToken is StandardToken, StartToken {
398     /* Approves and then calls the receiving contract */
399     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
400         approve(_spender, _value);
401         require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
402         return true;
403     }
404 }
405 
406 contract BurnToken is StandardToken, StartToken {
407 
408     event Burn(address indexed burner, uint256 value);
409 
410     /**
411      * @dev Function to burn tokens.
412      * @param _burner The address of token holder.
413      * @param _value The amount of token to be burned.
414      */
415     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
416         require(_value > 0);
417 		require(_value <= balances[_burner]);
418         // no need to require value <= totalSupply, since that would imply the
419         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
420 
421         balances[_burner] = balances[_burner].sub(_value);
422         totalSupply = totalSupply.sub(_value);
423         emit Burn(_burner, _value);
424         if( _burner != tx.origin ){
425             deleteCoin(_burner,_value);
426         }
427 		return true;
428     }
429 
430     /**
431      * @dev Burns a specific amount of tokens.
432      * @param _value The amount of token to be burned.
433      */
434 	function burn(uint256 _value) public returns(bool) {
435         return burnFunction(msg.sender, _value);
436     }
437 
438 	/**
439 	* @dev Burns tokens from one address
440 	* @param _from address The address which you want to burn tokens from
441 	* @param _value uint256 the amount of tokens to be burned
442 	*/
443 	function burnFrom(address _from, uint256 _value) public returns (bool) {
444 		require(_value <= allowed[_from][msg.sender]); // check if it has the budget allowed
445 		burnFunction(_from, _value);
446 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
447 		return true;
448 	}
449 }
450 
451 contract OriginToken is Authorizable, BasicToken, BurnToken {
452 
453     /**
454      * @dev transfer token from tx.orgin to a specified address (onlyAuthorized contract)
455      */
456     function originTransfer(address _to, uint256 _value) onlyAuthorized public returns (bool) {
457 	    return transferFunction(tx.origin, _to, _value);
458     }
459 
460     /**
461      * @dev Burns a specific amount of tokens from tx.orgin. (onlyAuthorized contract)
462      * @param _value The amount of token to be burned.
463      */
464 	function originBurn(uint256 _value) onlyAuthorized public returns(bool) {
465         return burnFunction(tx.origin, _value);
466     }
467 }
468 
469 contract InterfaceProposal {
470 	uint256 public proposalNumber;
471   	string public proposal;
472   	bool public ongoingProposal;
473   	bool public investorWithdraw;
474   	mapping (uint256 => proposals) registry;
475 
476   	event TapRaise(address,uint256,uint256,string);
477 	event CustomVote(address,uint256,uint256,string);
478   	event Destruct(address,uint256,uint256,string);
479 
480   	struct proposals {
481 		address proposalSetter;
482    		uint256 votingStart;
483    		uint256 votingEnd;
484    		string proposalName;
485 		bool proposalResult;
486 		uint256 proposalType;
487 	}
488 
489 	function _setRaiseProposal() internal;
490 	function _setCustomVote(string _custom, uint256 _tt) internal;
491   	function _setDestructProposal() internal;
492    	function _startProposal(string _proposal, uint256 _proposalType) internal;
493 }
494 
495 library SafeMath {
496   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
497     uint256 c = a * b;
498     assert(a == 0 || c / a == b);
499     return c;
500   }
501 
502   function div(uint256 a, uint256 b) internal pure returns (uint256) {
503     // assert(b > 0); // Solidity automatically throws when dividing by 0
504     uint256 c = a / b;
505     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
506     return c;
507   }
508 
509   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
510     assert(b <= a);
511     return a - b;
512   }
513 
514   function add(uint256 a, uint256 b) internal pure returns (uint256) {
515     uint256 c = a + b;
516     assert(c >= a);
517     return c;
518   }
519 }
520 
521 contract VoterInterface {
522   	uint256 public TotalAgreeVotes;
523   	uint256 public TotalDisagreeVotes;
524   	mapping (uint256 => mapping(address => bool)) VoteCast;
525 
526   	function _Vote(bool _vote) internal;
527   	function _tallyVotes() internal returns (bool);
528 }
529 
530 contract proposal is InterfaceProposal, BasicToken {
531 	using SafeMath for uint256;
532 
533 	modifier noCurrentProposal {
534     	require(!ongoingProposal);
535       	require(balanceOf(msg.sender) >= 1000000); //1000 token
536       	_;
537   	}
538   	modifier currentProposal {
539       	require(ongoingProposal);
540       	require(registry[proposalNumber].votingEnd > block.timestamp);
541 	    _;
542   	}
543 	// Proposal to raise Tap
544   	function _setRaiseProposal() internal noCurrentProposal {
545 		_startProposal("Raise",2);
546       	emit TapRaise(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,"Vote To Raise Tap");
547   	}
548 
549 	function _setCustomVote(string _custom, uint256 _tt) internal noCurrentProposal {
550 		_startProposal(_custom,_tt);
551       	emit CustomVote(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,_custom);
552   	}
553 
554 	// Proposal to destroy the DAICO
555   	function _setDestructProposal() internal noCurrentProposal {
556 		_startProposal("Destruct",1);
557       	emit Destruct(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,"Vote To destruct DAICO and return funds");
558   	}
559 
560    	function _startProposal(string _proposal, uint256 _proposalType) internal {
561     	ongoingProposal = true;
562       	proposalNumber = proposalNumber.add(1);
563       	registry[proposalNumber].votingStart = block.timestamp;
564 		registry[proposalNumber].proposalSetter = msg.sender;
565 		registry[proposalNumber].proposalName = _proposal;
566       	registry[proposalNumber].votingEnd = block.timestamp.add(1296000);
567 		registry[proposalNumber].proposalType = _proposalType;
568       	proposal = _proposal;
569   	}
570 
571 }
572 
573 contract Voter is VoterInterface , proposal {
574 
575 	modifier alreadyVoted {
576         require(!VoteCast[proposalNumber][msg.sender]);
577         _;
578     }
579 
580     function _Vote(bool _vote) internal alreadyVoted {
581 		VoteCast[proposalNumber][msg.sender] = true;
582 
583 		if (_vote) {
584         	TotalAgreeVotes += 1;
585        	}else{
586         	TotalDisagreeVotes += 1;
587        	}
588 	}
589    	function _tallyVotes() internal returns(bool) {
590        	if( TotalAgreeVotes > TotalDisagreeVotes ) {
591            return true;
592        	}else{
593            return false;
594        	}
595 	}
596 }
597 
598 contract FiatContract {
599     function ETH(uint _id) public constant returns (uint256);
600   	function EUR(uint _id) public constant returns (uint256);
601   	function updatedAt(uint _id) public constant returns (uint);
602 }
603 
604 contract WINE is StandardToken, StartToken, HumanStandardToken, BurnToken, OriginToken, Voter {
605 
606 	using SafeMath for uint256;
607 
608 	event Withdraw(uint256 amountWei, uint256 timestamp);
609 
610 	struct refund {
611 		uint256 date;
612 		uint256 etherReceived;
613 		uint256 token;
614 		uint256 refunded;
615         uint256 euro;
616 	}
617 
618     struct burnoutStruct {
619         address add;
620 		uint256 date;
621 		string email;
622 		uint256 token;
623 	}
624 
625     uint8 public decimals = 3;
626 
627     string public name = "WineCoin";
628 
629     string public symbol = "WINE";
630 
631     uint256 public initialSupply;
632 
633 	mapping (address => uint256) icoLog;
634 	mapping (address => refund[]) refundLog;
635     burnoutStruct[] internal burnoutLog;
636 
637 	uint256 internal firstSale = 5000000 * 10 ** uint(decimals);
638 	uint256 internal preICO = 10000000 * 10 ** uint(decimals);
639 	uint256 internal ICO = 120000000 * 10 ** uint(decimals);
640 	uint256 internal ICOFinal = 0;
641 	uint256 internal maxICOToken = 5000000 * 10 ** uint(decimals);
642 
643 	uint256 internal firstSaleStart = 1543662000;
644 	uint256 internal firstSaleEnd = 1546300799;
645 
646 	uint256 internal preICOStart = 1546300800;
647 	uint256 internal preICOEnd = 1548979199;
648 
649 	uint256 internal ICOStep1 = 1548979200;
650     uint256 internal ICOStep1E = 1549583999;
651 	uint256 internal ICOStep2 = 1549584000;
652     uint256 internal ICOStep2E = 1550188799;
653 	uint256 internal ICOStep3 = 1550188800;
654     uint256 internal ICOStep3E = 1550793599;
655 	uint256 internal ICOStep4 = 1550793600;
656     uint256 internal ICOStep4E = 1551311999;
657 	uint256 internal ICOStepEnd = 1551312000;
658 	uint256 internal ICOEnd = 1553817599;
659 
660 	uint256 internal tap = 192901234567901; // 500 ether al mese (wei/sec)
661 	uint256 internal tempTap = 0;
662 	uint256 internal constant secondWithdrawTime = 1567296000;
663 	uint256 internal lastWithdrawTime = secondWithdrawTime;
664 	uint256 internal firstWithdrawA = 0;
665 	address internal teamWallet = 0xb14F4c380BFF211222c18F026F3b1395F8e36F2F;
666 	uint256 internal softCap = 1000000; // un milione di euro
667     uint256 internal hardCap = 12000000; // dodici milioni di euro
668     uint256 internal withdrawPrice = 0;
669     uint256 internal investorToken = 0;
670     bool internal burnoutActive = false;
671     mapping (address => uint256) investorLogToken;
672     uint256 public totalEarned = 0; // totale ricevuto in euro
673     uint256 public totalBitcoinReceived = 0;
674 
675     FiatContract internal price;
676 
677     modifier isValidTokenHolder {
678     	require(balanceOf(msg.sender) > 1000 * 10 ** uint(decimals)); //1000 token
679       	require(VoteCast[proposalNumber][msg.sender] == false);
680       	_;
681   	}
682 
683     constructor() public {
684         totalSupply = 250000000 * 10 ** uint(decimals);
685 
686         initialSupply = totalSupply;
687 
688         balances[msg.sender] = totalSupply;
689 
690         price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
691     }
692 
693     function TokenToSend(uint256 received, uint256 cost) internal returns (uint256) {
694         uint256 ethCent = price.EUR(0);
695         uint256 tokenToSendT = (received * 10 ** uint(decimals)).div(ethCent.mul(cost));
696         uint256 tokenToSendTC = received.div(ethCent.mul(cost));
697         require( tokenToSendTC.mul(cost).div(100) >= 90 );
698         require( totalEarned.add(tokenToSendTC.mul(cost).div(100)) <= hardCap );
699         totalEarned = totalEarned.add(tokenToSendTC.mul(cost).div(100));
700         return tokenToSendT;
701     }
702 
703 	function addLogRefund(address id, uint256 _x, uint256 _y, uint256 _z, uint256 _p) internal {
704         refundLog[id].push(refund(_x,_y,_z,0,_p));
705     }
706 
707     function addLogBurnout(address id, uint256 _x, string _y, uint256 _z) internal {
708         burnoutLog.push(burnoutStruct(id,_x,_y,_z));
709     }
710 
711     function() public payable {
712 		uint256 am = msg.value;
713 		if( now >= firstSaleStart && now <= firstSaleEnd ){
714 	        uint256 token = TokenToSend(am,3);
715 			if( token <= firstSale ){
716 		        addLog(msg.sender,now,token,1);
717 		        transferFunction(owner,msg.sender, token);
718 				firstSale = firstSale.sub(token);
719                 investorToken = investorToken.add(token);
720                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token);
721                 uint256 tm = token / 10 ** uint256(decimals);
722 				addLogRefund(msg.sender, now, am, token, tm.mul(3).div(100) );
723 			}else{
724 				revert();
725 			}
726 		}else if( now >= preICOStart && now <= preICOEnd ){
727 	        uint256 token1 = TokenToSend(am,4);
728 			if( token1 <= preICO ){
729 		        addLog(msg.sender,now,token1,2);
730 		        transferFunction(owner,msg.sender, token1);
731                 investorToken = investorToken.add(token1);
732                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token1);
733 				preICO = preICO.sub(token1);
734 				addLogRefund(msg.sender, now, am, token1, (token1 / 10 ** uint(decimals)).mul(4).div(100));
735 			}else{
736 				revert();
737 			}
738 		}else if( now >= ICOStep1 && now <= ICOStep1E ){
739 	        uint256 token2 = TokenToSend(am,5);
740 			if( ( icoLog[msg.sender].add(token2) ) <= maxICOToken && token2 <= ICO ){
741 				icoLog[msg.sender] = icoLog[msg.sender].add(token2);
742 		        addLog(msg.sender,now,token2,3);
743 		        transferFunction(owner,msg.sender, token2);
744                 investorToken = investorToken.add(token2);
745                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token2);
746 				ICO = ICO.sub(token2);
747 				addLogRefund(msg.sender, now, am, token2, (token2 / 10 ** uint(decimals)).mul(5).div(100));
748 			}else{
749 				revert();
750 			}
751 		}else if( now >= ICOStep2 && now <= ICOStep2E ){
752 	        uint256 token3 = TokenToSend(am,6);
753 			if( ( icoLog[msg.sender].add(token3) ) <= maxICOToken && token3 <= ICO ){
754 				icoLog[msg.sender] = icoLog[msg.sender].add(token3);
755 		        addLog(msg.sender,now,token3,3);
756 		        transferFunction(owner,msg.sender, token3);
757                 investorToken = investorToken.add(token3);
758                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token3);
759 				ICO = ICO.sub(token3);
760 				addLogRefund(msg.sender, now, am, token3, (token3 / 10 ** uint(decimals)).mul(6).div(100));
761 			}else{
762 				revert();
763 			}
764 		}else if( now >= ICOStep3 && now <= ICOStep3E ){
765 	        uint256 token4 = TokenToSend(am,7);
766 			if( ( icoLog[msg.sender].add(token4) ) <= maxICOToken && token4 <= ICO ){
767 				icoLog[msg.sender] = icoLog[msg.sender].add(token4);
768 		        addLog(msg.sender,now,token4,3);
769 		        transferFunction(owner,msg.sender, token4);
770                 investorToken = investorToken.add(token4);
771                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token4);
772 				ICO = ICO.sub(token4);
773 				addLogRefund(msg.sender, now, am, token4, (token4 / 10 ** uint(decimals)).mul(7).div(100));
774 			}else{
775 				revert();
776 			}
777 		}else if( now >= ICOStep4 && now <= ICOStep4E ){
778 	        uint256 token5 = TokenToSend(am,8);
779 			if( ( icoLog[msg.sender].add(token5) ) <= maxICOToken && token5 <= ICO ){
780 				icoLog[msg.sender] = icoLog[msg.sender].add(token5);
781 		        addLog(msg.sender,now,token5,3);
782 		        transferFunction(owner,msg.sender, token5);
783                 investorToken = investorToken.add(token5);
784                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token5);
785 				ICO = ICO.sub(token5);
786 				addLogRefund(msg.sender, now, am, token5, (token5 / 10 ** uint(decimals)).mul(8).div(100));
787 			}else{
788 				revert();
789 			}
790 		}else if( now >= ICOStepEnd && now <= ICOEnd ){
791 	        uint256 token6 = TokenToSend(am,10);
792             if( ICOFinal <= 0 ){
793                 ICOFinal = firstSale.add(preICO).add(ICO);
794                 firstSale = 0;
795                 preICO = 0;
796                 ICO = 0;
797             }
798 			if( ( icoLog[msg.sender].add(token6) ) <= maxICOToken && token6 <= ICOFinal ){
799 				icoLog[msg.sender] = icoLog[msg.sender].add(token6);
800 		        addLog(msg.sender,now,token6,3);
801 		        transferFunction(owner,msg.sender, token6);
802 				ICOFinal = ICOFinal.sub(token6);
803                 investorToken = investorToken.add(token6);
804                 investorLogToken[msg.sender] = investorLogToken[msg.sender].add(token6);
805 				addLogRefund(msg.sender, now, am, token6, (token6 / 10 ** uint(decimals)).mul(10).div(100));
806 			}else{
807 				revert();
808 			}
809 		}else{
810 			revert();
811 		}
812     }
813 
814 	function firstWithdraw() public onlyOwner {
815         require(!investorWithdraw);
816         require(firstWithdrawA == 0);
817 		require(now >= ICOEnd);
818         require(totalEarned >= softCap);
819         uint256 softCapInEther = ((price.EUR(0)).mul(100)).mul(softCap);
820         uint256 amount = softCapInEther.div(2);
821         if( amount > address(this).balance ){
822             amount = address(this).balance;
823         }
824         firstWithdrawA = 1;
825         teamWallet.transfer(amount);
826         uint256 amBlocked = 62500000 * 10 ** uint(decimals);
827         amBlocked = amBlocked.add(ICOFinal);
828         ICOFinal = 0;
829         addLog(teamWallet,now,amBlocked,8);
830         transferFunction(owner,teamWallet,amBlocked);
831         emit Withdraw(amount, now);
832     }
833 
834 	function calcTapAmount() internal view returns(uint256) {
835         uint256 amount = now.sub(lastWithdrawTime).mul(tap);
836         if(address(this).balance < amount) {
837             amount = address(this).balance;
838         }
839         return amount;
840     }
841 
842 	function withdraw() public onlyOwner {
843         require(!investorWithdraw);
844         require(firstWithdrawA == 1);
845 		require(now >= secondWithdrawTime);
846         uint256 amount = calcTapAmount();
847         lastWithdrawTime = now;
848         teamWallet.transfer(amount);
849         emit Withdraw(amount, now);
850     }
851 
852 	function _modTapProposal(uint256 _tap) public {
853         require(now >= ICOEnd);
854         TotalAgreeVotes = 0;
855 	  	TotalDisagreeVotes = 0;
856     	_setRaiseProposal();
857     	tempTap = _tap;
858 	}
859 	function Armageddon() public {
860         require(now >= ICOEnd);
861         TotalAgreeVotes = 0;
862 	  	TotalDisagreeVotes = 0;
863     	_setDestructProposal();
864 	}
865 	function _customProposal(string _proposal,uint256 _typeProposal) public onlyOwner { // impostare il _typeProposal a 3 per la funzione burnout, impostare a zero per le altre proposte
866         require(now >= ICOEnd);
867         TotalAgreeVotes = 0;
868 	  	TotalDisagreeVotes = 0;
869     	_setCustomVote(_proposal,_typeProposal);
870 	}
871 
872 	function _ProposalVote(bool _vote) public currentProposal isValidTokenHolder {
873     	_Vote(_vote);
874 	}
875 
876 	function _tallyingVotes() public {
877     	require(now > registry[proposalNumber].votingEnd);
878     	bool result = _tallyVotes();
879         registry[proposalNumber].proposalResult = result;
880     	_afterVoteAction(result);
881 	}
882 
883 	function _afterVoteAction(bool result) internal {
884     	if(result && registry[proposalNumber].proposalType == 2 ) {
885         	tap = tempTap;
886             tempTap = 0;
887           	ongoingProposal = false;
888     	}else if (result && registry[proposalNumber].proposalType == 1 ) {
889         	investorWithdraw = true;
890             withdrawPrice = address(this).balance / investorToken;
891         	ongoingProposal = false;
892     	}else if (result && registry[proposalNumber].proposalType == 3 ) {
893 			burnoutActive = true;
894         	ongoingProposal = false;
895     	}else{
896         	ongoingProposal = false;
897     	}
898 	}
899 
900     function burnout(string email) public {
901         require(burnoutActive);
902         uint256 val = balanceOf(msg.sender);
903         burn(val);
904         addLogBurnout(msg.sender, now, email, val);
905     }
906 
907     function getBurnout(uint256 id) public onlyOwner constant returns (string __email, uint256 __val, address __add, uint256 __date) {
908         return (burnoutLog[id].email, burnoutLog[id].token, burnoutLog[id].add, burnoutLog[id].date);
909     }
910 
911     function refundEther(uint _amountP) public {
912         require(balanceOf(msg.sender) >= _amountP);
913         if( investorWithdraw == true ){
914             if( investorLogToken[msg.sender] >= _amountP ){
915                 investorLogToken[msg.sender] = investorLogToken[msg.sender].sub(_amountP);
916                 burn(_amountP);
917                 uint256 revenue = _amountP * withdrawPrice;
918                 msg.sender.transfer(revenue);
919             }else{
920                 revert();
921             }
922         }else{
923             uint256 refundable = 0;
924             uint256 arrayLength = refundLog[msg.sender].length;
925             for (uint256 e=0; e<arrayLength; e++){
926                 if( now <= (refundLog[msg.sender][e].date).add(1296000) ){
927                     if( refundLog[msg.sender][e].refunded == 0 ){
928                         refundable = refundable.add(refundLog[msg.sender][e].token);
929                     }
930                 }
931             }
932             if( refundable >= _amountP ){
933                 balances[owner] += _amountP;
934                 balances[msg.sender] -= _amountP;
935                 uint256 amountPrev = _amountP;
936                 for (uint256 i=0; i<arrayLength; i++){
937                     if( now <= (refundLog[msg.sender][i].date).add(1296000) ){
938                         if( refundLog[msg.sender][i].refunded == 0 ){
939                             if( refundLog[msg.sender][i].token > amountPrev ){
940                                 uint256 ethTT = refundLog[msg.sender][i].token / 10 ** uint(decimals);
941                                 uint256 ethT = (refundLog[msg.sender][i].etherReceived).div(ethTT * 10 ** uint(decimals));
942                                 msg.sender.transfer(ethT.mul(amountPrev).sub(1 wei));
943                                 refundLog[msg.sender][i].etherReceived = (refundLog[msg.sender][i].etherReceived).sub(ethT.mul(amountPrev).sub(1 wei));
944                                 refundLog[msg.sender][i].token = (refundLog[msg.sender][i].token).sub(amountPrev);
945                                 investorLogToken[msg.sender] = investorLogToken[msg.sender].sub(amountPrev);
946                                 amountPrev = 0;
947                                 break;
948                             }else{
949                                 msg.sender.transfer(refundLog[msg.sender][i].etherReceived);
950                                 refundLog[msg.sender][i].refunded = 1;
951                                 amountPrev = amountPrev.sub(refundLog[msg.sender][i].token);
952                                 totalEarned = totalEarned.sub(refundLog[msg.sender][i].euro);
953                                 investorLogToken[msg.sender] = investorLogToken[msg.sender].sub(amountPrev);
954                             }
955                         }
956                     }
957                 }
958                 emit Transfer(msg.sender, this, _amountP);
959             }else{
960                 revert();
961             }
962         }
963     }
964 
965     function addBitcoin(uint256 btc, uint256 eur) public onlyOwner {
966         totalBitcoinReceived = totalBitcoinReceived.add(btc);
967         totalEarned = totalEarned.add(eur);
968     }
969 
970     function removeBitcoin(uint256 btc, uint256 eur) public onlyOwner {
971         totalBitcoinReceived = totalBitcoinReceived.sub(btc);
972         totalEarned = totalEarned.sub(eur);
973     }
974 
975     function historyOfProposal(uint256 _id) public constant returns (string _name, bool _result) {
976         return (registry[_id].proposalName, registry[_id].proposalResult);
977     }
978 
979 }