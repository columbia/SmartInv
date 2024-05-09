1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     // SafeMath.sub will throw if there is not enough balance.
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 /**
116  * @title Ownable
117  * @dev The Ownable contract has an owner address, and provides basic authorization control
118  * functions, this simplifies the implementation of "user permissions".
119  */
120 contract Ownable {
121   address public owner;
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   function Ownable() public {
128     owner = msg.sender;
129   }
130 
131 
132   /**
133    * @dev Throws if called by any account other than the owner.
134    */
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address newOwner) onlyOwner public {
146     require(newOwner != address(0));
147     owner = newOwner;
148   }
149 
150 }
151 
152 /**
153  * @title Pausable
154  * @dev Base contract which allows children to implement an emergency stop mechanism.
155  */
156 contract Pausable is Ownable {
157   event Pause();
158   event Unpause();
159 
160   bool public paused = true;
161 
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is not paused.
165    */
166   modifier whenNotPaused() {
167     require(!paused);
168     _;
169   }
170 
171   /**
172    * @dev Modifier to make a function callable only when the contract is paused.
173    */
174   modifier whenPaused() {
175     require(paused);
176     _;
177   }
178 
179   /**
180    * @dev called by the owner to pause, triggers stopped state
181    */
182   function pause() onlyOwner whenNotPaused public {
183     paused = true;
184     Pause();
185   }
186 
187   /**
188    * @dev called by the owner to unpause, returns to normal state
189    */
190   function unpause() onlyOwner whenPaused public {
191     paused = false;
192     Unpause();
193   }
194 }
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * @dev https://github.com/ethereum/EIPs/issues/20
201  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(address _owner, address _spender) public view returns (uint256) {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
263     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To decrement
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _subtractedValue The amount of tokens to decrease the allowance by.
277    */
278   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
279     uint oldValue = allowed[msg.sender][_spender];
280     if (_subtractedValue > oldValue) {
281       allowed[msg.sender][_spender] = 0;
282     } else {
283       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284     }
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289 }
290 
291 /**
292    @title ERC827 interface, an extension of ERC20 token standard
293    Interface of a ERC827 token, following the ERC20 standard with extra
294    methods to transfer value and data and execute calls in transfers and
295    approvals.
296  */
297 contract ERC827 is ERC20 {
298 
299   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
300   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
301   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
302 
303 }
304 
305 /**
306    @title ERC827, an extension of ERC20 token standard
307    Implementation the ERC827, following the ERC20 standard with extra
308    methods to transfer value and data and execute calls in transfers and
309    approvals.
310    Uses OpenZeppelin StandardToken.
311  */
312 contract ERC827Token is ERC827, StandardToken {
313 
314   /**
315      @dev Addition to ERC20 token methods. It allows to
316      approve the transfer of value and execute a call with the sent data.
317      Beware that changing an allowance with this method brings the risk that
318      someone may use both the old and the new allowance by unfortunate
319      transaction ordering. One possible solution to mitigate this race condition
320      is to first reduce the spender's allowance to 0 and set the desired value
321      afterwards:
322      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323      @param _spender The address that will spend the funds.
324      @param _value The amount of tokens to be spent.
325      @param _data ABI-encoded contract call to call `_to` address.
326      @return true if the call function was executed successfully
327    */
328   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
329     require(_spender != address(this));
330 
331     super.approve(_spender, _value);
332 
333     require(_spender.call(_data));
334 
335     return true;
336   }
337 
338   /**
339      @dev Addition to ERC20 token methods. Transfer tokens to a specified
340      address and execute a call with the sent data on the same transaction
341      @param _to address The address which you want to transfer to
342      @param _value uint256 the amout of tokens to be transfered
343      @param _data ABI-encoded contract call to call `_to` address.
344      @return true if the call function was executed successfully
345    */
346   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
347     require(_to != address(this));
348 
349     super.transfer(_to, _value);
350 
351     require(_to.call(_data));
352     return true;
353   }
354 
355   /**
356      @dev Addition to ERC20 token methods. Transfer tokens from one address to
357      another and make a contract call on the same transaction
358      @param _from The address which you want to send tokens from
359      @param _to The address which you want to transfer to
360      @param _value The amout of tokens to be transferred
361      @param _data ABI-encoded contract call to call `_to` address.
362      @return true if the call function was executed successfully
363    */
364   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
365     require(_to != address(this));
366 
367     super.transferFrom(_from, _to, _value);
368 
369     require(_to.call(_data));
370     return true;
371   }
372 
373   /**
374    * @dev Addition to StandardToken methods. Increase the amount of tokens that
375    * an owner allowed to a spender and execute a call with the sent data.
376    *
377    * approve should be called when allowed[_spender] == 0. To increment
378    * allowed value is better to use this function to avoid 2 calls (and wait until
379    * the first transaction is mined)
380    * From MonolithDAO Token.sol
381    * @param _spender The address which will spend the funds.
382    * @param _addedValue The amount of tokens to increase the allowance by.
383    * @param _data ABI-encoded contract call to call `_spender` address.
384    */
385   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
386     require(_spender != address(this));
387 
388     super.increaseApproval(_spender, _addedValue);
389 
390     require(_spender.call(_data));
391 
392     return true;
393   }
394 
395   /**
396    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
397    * an owner allowed to a spender and execute a call with the sent data.
398    *
399    * approve should be called when allowed[_spender] == 0. To decrement
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    * @param _spender The address which will spend the funds.
404    * @param _subtractedValue The amount of tokens to decrease the allowance by.
405    * @param _data ABI-encoded contract call to call `_spender` address.
406    */
407   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
408     require(_spender != address(this));
409 
410     super.decreaseApproval(_spender, _subtractedValue);
411 
412     require(_spender.call(_data));
413 
414     return true;
415   }
416 
417 }
418 
419 /**
420  * @title Pausable token
421  * @dev ERC827Token modified with pausable transfers.
422  **/
423 contract PausableToken is ERC827Token, Pausable {
424 
425   // ERC20
426   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
427     return super.transfer(_to, _value);
428   }
429 
430   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
431     return super.transferFrom(_from, _to, _value);
432   }
433 
434   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
435     return super.approve(_spender, _value);
436   }
437 
438   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
439     return super.increaseApproval(_spender, _addedValue);
440   }
441 
442   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
443     return super.decreaseApproval(_spender, _subtractedValue);
444   }
445   
446   // ERC827
447   function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
448       return super.transfer(_to, _value, _data);
449   }
450   
451   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
452       return super.transferFrom(_from, _to, _value, _data);
453   }
454   
455   function approve(address _spender, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
456       return super.approve(_spender, _value, _data);
457   }
458   
459   function increaseApproval(address _spender, uint _addedValue, bytes _data) public whenNotPaused returns (bool) {
460       return super.increaseApproval(_spender, _addedValue, _data);
461   }
462   
463   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public whenNotPaused returns (bool) {
464       return super.decreaseApproval(_spender, _subtractedValue, _data);
465   }
466 }
467 
468 /**
469  * @title Mintable token
470  * @dev Simple ERC20 Token example, with mintable token creation
471  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
472  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
473  */
474 contract MintableToken is PausableToken {
475   event Mint(address indexed to, uint256 amount);
476   event MintFinished();
477 
478   bool public mintingFinished = false;
479 
480 
481   modifier canMint() {
482     require(!mintingFinished);
483     _;
484   }
485 
486   /**
487    * @dev Function to mint tokens
488    * @param _to The address that will receive the minted tokens.
489    * @param _amount The amount of tokens to mint.
490    * @return A boolean that indicates if the operation was successful.
491    */
492   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
493     totalSupply_ = totalSupply_.add(_amount);
494     balances[_to] = balances[_to].add(_amount);
495     Mint(_to, _amount);
496     Transfer(address(0), _to, _amount);
497     return true;
498   }
499 
500   /**
501    * @dev Function to stop minting new tokens.
502    * @return True if the operation was successful.
503    */
504   function finishMinting() onlyOwner canMint public returns (bool) {
505     mintingFinished = true;
506     MintFinished();
507     return true;
508   }
509 }
510 
511 /**
512  * @title Capped token
513  * @dev Mintable token with a token cap.
514  */
515 contract AirEX is MintableToken {
516   string public constant name = "AIRX";
517   string public constant symbol = "AIRX";
518   uint8 public constant decimals = 18;
519 
520   uint256 public hardCap;
521   uint256 public softCap;
522 
523   function AirEX(uint256 _cap) public {
524     require(_cap > 0);
525     hardCap = _cap;
526   }
527 
528   /**
529    * @dev Function to mint tokens
530    * @param _to The address that will receive the minted tokens.
531    * @param _amount The amount of tokens to mint.
532    * @return A boolean that indicates if the operation was successful.
533    */
534   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
535     require(totalSupply_.add(_amount) <= hardCap);
536     return super.mint(_to, _amount);
537   }
538   
539   function updateHardCap(uint256 _cap) onlyOwner public {
540     require(_cap > 0);
541     hardCap = _cap;
542   }
543   
544   function updateSoftCap(uint256 _cap) onlyOwner public {
545     require(_cap > 0);
546     softCap = _cap;  
547   }
548 
549 }
550 
551 contract SalesManagerUpgradable is Ownable {
552     using SafeMath for uint256;
553 
554 /* SZ: Change here to collection address before deploy */
555     address public ethOwner = 0xe8290a10565CB7aDeE9246661B34BB77CB6e4024;
556 /* SZ: price1..3 in AIRX per 1 ETH */
557     uint public price1 = 100;
558     uint public price2 = 110;
559     uint public price3 = 125;
560 
561 /* SZ: lev1..2 in ETH */
562     uint public lev1 = 2 ether;
563     uint public lev2 = 10 ether;
564     
565     uint public ethFundRaised;
566     
567     address public tokenAddress;
568 
569 /* SZ: AIRX constructor with HardCap in AIRX tokens */
570     function SalesManagerUpgradable () public {
571         tokenAddress = new AirEX(5550000 ether);
572     }
573 
574     function () payable public {
575         if(msg.value > 0) revert();
576     }
577 
578     function buyTokens(address _investor) public payable returns (bool){
579         if (msg.value <= lev1) {
580             uint tokens = msg.value.mul(price1);
581             if (!sendTokens(tokens, msg.value, _investor)) revert();
582             return true;
583         } else if (msg.value > lev1 && msg.value <= lev2) {
584             tokens = msg.value.mul(price2);
585             if (!sendTokens(tokens, msg.value, _investor)) revert();
586             return true;
587         } else if (msg.value > lev2) {
588             tokens = msg.value.mul(price3);
589             if (!sendTokens(tokens, msg.value, _investor)) revert();
590             return true;
591         }
592         return false;
593     }
594 
595     function sendTokens(uint _amount, uint _ethers, address _investor) private returns (bool) {
596         AirEX tokenHolder = AirEX(tokenAddress);
597         if (tokenHolder.mint(_investor, _amount)) {
598             ethFundRaised = ethFundRaised.add(_ethers);
599             ethOwner.transfer(_ethers);
600             return true;
601         }
602         return false;
603     }
604     
605     function generateTokensManually(uint _amount, address _to) public onlyOwner {
606         AirEX tokenHolder = AirEX(tokenAddress);
607         tokenHolder.mint(_to, _amount);
608     }
609     
610     function setColdAddress(address _newAddr) public onlyOwner {
611         ethOwner = _newAddr;
612     }
613     
614     function setPrice1 (uint _price) public onlyOwner {
615         price1 = _price;
616     }
617     
618     function setPrice2 (uint _price) public onlyOwner {
619         price2 = _price;
620     }
621     
622     function setPrice3 (uint _price) public onlyOwner {
623         price3 = _price;
624     }
625 
626 /* SZ: Functions setLev1, setLev2 to change levels of prices*/
627 /* SZ: lev1..2 send as for example "2000000000000000000" for 2 ETH */
628     function setLev1 (uint _price) public onlyOwner {
629         lev1 = _price;
630     }
631 
632     function setLev2 (uint _price) public onlyOwner {
633         lev2 = _price;
634     }
635     
636     function transferOwnershipToken(address newTokenOwnerAddress) public onlyOwner {
637         AirEX tokenContract = AirEX(tokenAddress);
638         tokenContract.transferOwnership(newTokenOwnerAddress);
639     }
640     
641     function updateHardCap(uint256 _cap) public onlyOwner {
642         AirEX tokenContract = AirEX(tokenAddress);
643         tokenContract.updateHardCap(_cap);
644     }
645     
646     function updateSoftCap(uint256 _cap) public onlyOwner {
647         AirEX tokenContract = AirEX(tokenAddress);
648         tokenContract.updateSoftCap(_cap);
649     }
650     
651     function unPauseContract() public onlyOwner {
652         AirEX tokenContract = AirEX(tokenAddress);
653         tokenContract.unpause();
654     }
655     
656     function pauseContract() public onlyOwner {
657         AirEX tokenContract = AirEX(tokenAddress);
658         tokenContract.pause();
659     }
660     
661     function finishMinting() public onlyOwner {
662         AirEX tokenContract = AirEX(tokenAddress);
663         tokenContract.finishMinting();
664     }
665     
666     function drop(address[] _destinations, uint256[] _amount) onlyOwner public
667     returns (uint) {
668         uint i = 0;
669         while (i < _destinations.length) {
670            AirEX(tokenAddress).mint(_destinations[i], _amount[i]);
671            i += 1;
672         }
673         return(i);
674     }
675     
676     function withdraw(address _to) public onlyOwner {
677         _to.transfer(this.balance);
678     }
679     
680     function destroySalesManager(address _recipient) public onlyOwner {
681         selfdestruct(_recipient);
682     }
683 }
684 
685 
686 contract DepositManager is Ownable {
687     address public actualSalesAddress;
688     
689     function DepositManager (address _actualAddres) public {
690         actualSalesAddress = _actualAddres;
691     }
692     
693     function () payable public {
694         SalesManagerUpgradable sm = SalesManagerUpgradable(actualSalesAddress);
695         if(!sm.buyTokens.value(msg.value)(msg.sender)) revert();
696     }
697     
698     function setNewSalesManager (address _newAddr) public onlyOwner {
699         actualSalesAddress = _newAddr;
700     }
701 
702 }