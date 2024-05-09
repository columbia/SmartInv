1 pragma solidity ^0.4.15;
2 
3 
4 
5 
6 
7 contract ContractReceiver {   
8     function tokenFallback(address _from, uint _value, bytes _data){
9     }
10 }
11 
12  /* New ERC23 contract interface */
13 
14 contract ERC223 {
15   uint public totalSupply;
16   function balanceOf(address who) constant returns (uint);
17   
18   function name() constant returns (string _name);
19   function symbol() constant returns (string _symbol);
20   function decimals() constant returns (uint8 _decimals);
21   function totalSupply() constant returns (uint256 _supply);
22 
23   function transfer(address to, uint value) returns (bool ok);
24   function transfer(address to, uint value, bytes data) returns (bool ok);
25   function transfer(address to, uint value, bytes data, string custom_fallback) returns (bool ok);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
28 }
29 
30 // The GXVC token ERC223
31 
32 contract GXVCToken {
33 
34     // Token public variables
35     string public name;
36     string public symbol;
37     uint8 public decimals; 
38     string public version = 'v0.2';
39     uint256 public totalSupply;
40     bool locked;
41 
42     address rootAddress;
43     address Owner;
44     uint multiplier = 10000000000; // For 10 decimals
45     address swapperAddress; // Can bypass a lock
46 
47     mapping(address => uint256) balances;
48     mapping(address => mapping(address => uint256)) allowed;
49     mapping(address => bool) freezed; 
50 
51 
52   	event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 
55     // Modifiers
56 
57     modifier onlyOwner() {
58         if ( msg.sender != rootAddress && msg.sender != Owner ) revert();
59         _;
60     }
61 
62     modifier onlyRoot() {
63         if ( msg.sender != rootAddress ) revert();
64         _;
65     }
66 
67     modifier isUnlocked() {
68     	if ( locked && msg.sender != rootAddress && msg.sender != Owner ) revert();
69 		_;    	
70     }
71 
72     modifier isUnfreezed(address _to) {
73     	if ( freezed[msg.sender] || freezed[_to] ) revert();
74     	_;
75     }
76 
77 
78     // Safe math
79     function safeAdd(uint x, uint y) internal returns (uint z) {
80         require((z = x + y) >= x);
81     }
82     function safeSub(uint x, uint y) internal returns (uint z) {
83         require((z = x - y) <= x);
84     }
85 
86 
87     // GXC Token constructor
88     function GXVCToken() {        
89         locked = true;
90         totalSupply = 160000000 * multiplier; // 160,000,000 tokens * 10 decimals
91         name = 'Genevieve VC'; 
92         symbol = 'GXVC'; 
93         decimals = 10; 
94         rootAddress = msg.sender;        
95         Owner = msg.sender;       
96         balances[rootAddress] = totalSupply; 
97         allowed[rootAddress][swapperAddress] = totalSupply;
98     }
99 
100 
101 	// ERC223 Access functions
102 
103 	function name() constant returns (string _name) {
104 	      return name;
105 	  }
106 	function symbol() constant returns (string _symbol) {
107 	      return symbol;
108 	  }
109 	function decimals() constant returns (uint8 _decimals) {
110 	      return decimals;
111 	  }
112 	function totalSupply() constant returns (uint256 _totalSupply) {
113 	      return totalSupply;
114 	  }
115 
116 
117     // Only root function
118 
119     function changeRoot(address _newrootAddress) onlyRoot returns(bool){
120     		allowed[rootAddress][swapperAddress] = 0; // Removes allowance to old rootAddress
121             rootAddress = _newrootAddress;
122             allowed[_newrootAddress][swapperAddress] = totalSupply; // Gives allowance to new rootAddress
123             return true;
124     }
125 
126 
127     // Only owner functions
128 
129     function changeOwner(address _newOwner) onlyOwner returns(bool){
130             Owner = _newOwner;
131             return true;
132     }
133 
134     function changeSwapperAdd(address _newSwapper) onlyOwner returns(bool){
135     		allowed[rootAddress][swapperAddress] = 0; // Removes allowance to old rootAddress
136             swapperAddress = _newSwapper;
137             allowed[rootAddress][_newSwapper] = totalSupply; // Gives allowance to new rootAddress
138             return true;
139     }
140        
141     function unlock() onlyOwner returns(bool) {
142         locked = false;
143         return true;
144     }
145 
146     function lock() onlyOwner returns(bool) {
147         locked = true;
148         return true;
149     }
150 
151     function freeze(address _address) onlyOwner returns(bool) {
152         freezed[_address] = true;
153         return true;
154     }
155 
156     function unfreeze(address _address) onlyOwner returns(bool) {
157         freezed[_address] = false;
158         return true;
159     }
160 
161     function burn(uint256 _value) onlyOwner returns(bool) {
162     	bytes memory empty;
163         if ( balances[msg.sender] < _value ) revert();
164         balances[msg.sender] = safeSub( balances[msg.sender] , _value );
165         totalSupply = safeSub( totalSupply,  _value );
166         Transfer(msg.sender, 0x0, _value , empty);
167         return true;
168     }
169 
170 
171     // Public getters
172     function isFreezed(address _address) constant returns(bool) {
173         return freezed[_address];
174     }
175 
176     function isLocked() constant returns(bool) {
177         return locked;
178     }
179 
180   // Public functions (from https://github.com/Dexaran/ERC223-token-standard/tree/Recommended)
181 
182   // Function that is called when a user or another contract wants to transfer funds to an address that has a non-standard fallback function
183   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) isUnlocked isUnfreezed(_to) returns (bool success) {
184       
185     if(isContract(_to)) {
186         if (balances[msg.sender] < _value) return false;
187         balances[msg.sender] = safeSub( balances[msg.sender] , _value );
188         balances[_to] = safeAdd( balances[_to] , _value );
189         ContractReceiver receiver = ContractReceiver(_to);
190         receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
191         Transfer(msg.sender, _to, _value, _data);
192         return true;
193     }
194     else {
195         return transferToAddress(_to, _value, _data);
196     }
197 }
198 
199   // Function that is called when a user or another contract wants to transfer funds to an address with tokenFallback function
200   function transfer(address _to, uint _value, bytes _data) isUnlocked isUnfreezed(_to) returns (bool success) {
201       
202     if(isContract(_to)) {
203         return transferToContract(_to, _value, _data);
204     }
205     else {
206         return transferToAddress(_to, _value, _data);
207     }
208 }
209 
210 
211   // Standard function transfer similar to ERC20 transfer with no _data.
212   // Added due to backwards compatibility reasons.
213   function transfer(address _to, uint _value) isUnlocked isUnfreezed(_to) returns (bool success) {
214 
215     bytes memory empty;
216     if(isContract(_to)) {
217         return transferToContract(_to, _value, empty);
218     }
219     else {
220         return transferToAddress(_to, _value, empty);
221     }
222 }
223 
224 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
225   function isContract(address _addr) private returns (bool is_contract) {
226       uint length;
227       assembly {
228             //retrieve the size of the code on target address, this needs assembly
229             length := extcodesize(_addr)
230       }
231       return (length>0);
232     }
233 
234   //function that is called when transaction target is an address
235   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
236     if (balances[msg.sender] < _value) return false;
237     balances[msg.sender] = safeSub(balances[msg.sender], _value);
238     balances[_to] = safeAdd(balances[_to], _value);
239     Transfer(msg.sender, _to, _value, _data);
240     return true;
241   }
242   
243   //function that is called when transaction target is a contract
244   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
245     if (balances[msg.sender] < _value) return false;
246     balances[msg.sender] = safeSub(balances[msg.sender] , _value);
247     balances[_to] = safeAdd(balances[_to] , _value);
248     ContractReceiver receiver = ContractReceiver(_to);
249     receiver.tokenFallback(msg.sender, _value, _data);
250     Transfer(msg.sender, _to, _value, _data);
251     return true;
252 }
253 
254 
255     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
256 
257         if ( locked && msg.sender != swapperAddress ) return false; 
258         if ( freezed[_from] || freezed[_to] ) return false; // Check if destination address is freezed
259         if ( balances[_from] < _value ) return false; // Check if the sender has enough
260 		if ( _value > allowed[_from][msg.sender] ) return false; // Check allowance
261 
262         balances[_from] = safeSub(balances[_from] , _value); // Subtract from the sender
263         balances[_to] = safeAdd(balances[_to] , _value); // Add the same to the recipient
264 
265         allowed[_from][msg.sender] = safeSub( allowed[_from][msg.sender] , _value );
266 
267         bytes memory empty;
268 
269         if ( isContract(_to) ) {
270 	        ContractReceiver receiver = ContractReceiver(_to);
271 	    	receiver.tokenFallback(_from, _value, empty);
272 		}
273 
274         Transfer(_from, _to, _value , empty);
275         return true;
276     }
277 
278 
279     function balanceOf(address _owner) constant returns(uint256 balance) {
280         return balances[_owner];
281     }
282 
283 
284     function approve(address _spender, uint _value) returns(bool) {
285         allowed[msg.sender][_spender] = _value;
286         Approval(msg.sender, _spender, _value);
287         return true;
288     }
289 
290 
291     function allowance(address _owner, address _spender) constant returns(uint256) {
292         return allowed[_owner][_spender];
293     }
294 }
295 /**
296  * @title Math
297  * @dev Assorted math operations
298  */
299 
300 library Math {
301   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
302     return a >= b ? a : b;
303   }
304 
305   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
306     return a < b ? a : b;
307   }
308 
309   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
310     return a >= b ? a : b;
311   }
312 
313   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
314     return a < b ? a : b;
315   }
316 }
317 
318 /**
319  * @title SafeMath
320  * @dev Math operations with safety checks that throw on error
321  */
322 library SafeMath {
323   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324     if (a == 0) {
325       return 0;
326     }
327     uint256 c = a * b;
328     assert(c / a == b);
329     return c;
330   }
331 
332   function div(uint256 a, uint256 b) internal pure returns (uint256) {
333     // assert(b > 0); // Solidity automatically throws when dividing by 0
334     uint256 c = a / b;
335     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
336     return c;
337   }
338 
339   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340     assert(b <= a);
341     return a - b;
342   }
343 
344   function add(uint256 a, uint256 b) internal pure returns (uint256) {
345     uint256 c = a + b;
346     assert(c >= a);
347     return c;
348   }
349 }
350 
351 
352 /**
353  * @title Ownable
354  * @dev The Ownable contract has an owner address, and provides basic authorization control
355  * functions, this simplifies the implementation of "user permissions".
356  */
357 contract Ownable {
358   address public owner;
359 
360 
361   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363 
364   /**
365    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
366    * account.
367    */
368   function Ownable() public {
369     owner = msg.sender;
370   }
371 
372 
373   /**
374    * @dev Throws if called by any account other than the owner.
375    */
376   modifier onlyOwner() {
377     require(msg.sender == owner);
378     _;
379   }
380 
381 
382   /**
383    * @dev Allows the current owner to transfer control of the contract to a newOwner.
384    * @param newOwner The address to transfer ownership to.
385    */
386   function transferOwnership(address newOwner) public onlyOwner {
387     require(newOwner != address(0));
388     OwnershipTransferred(owner, newOwner);
389     owner = newOwner;
390   }
391 
392 }
393 
394 
395 /**
396  * @title Pausable
397  * @dev Base contract which allows children to implement an emergency stop mechanism.
398  */
399 contract Pausable is Ownable {
400   event Pause();
401   event Unpause();
402 
403   bool public paused = false;
404 
405 
406   /**
407    * @dev Modifier to make a function callable only when the contract is not paused.
408    */
409   modifier whenNotPaused() {
410     require(!paused);
411     _;
412   }
413 
414   /**
415    * @dev Modifier to make a function callable only when the contract is paused.
416    */
417   modifier whenPaused() {
418     require(paused);
419     _;
420   }
421 
422   /**
423    * @dev called by the owner to pause, triggers stopped state
424    */
425   function pause() onlyOwner whenNotPaused public {
426     paused = true;
427     Pause();
428   }
429 
430   /**
431    * @dev called by the owner to unpause, returns to normal state
432    */
433   function unpause() onlyOwner whenPaused public {
434     paused = false;
435     Unpause();
436   }
437 }
438 
439 contract Dec {
440     function decimals() public view returns (uint8);
441 }
442 
443 contract ERC20 {
444     function transfer(address,uint256);
445 }
446 
447 contract KeeToken {
448     // Stub
449 
450     function icoBalanceOf(address from, address ico) external view returns (uint) ;
451 
452 
453 }
454 
455 contract KeeHole {
456     using SafeMath for uint256;
457     
458     KeeToken  token;
459 
460     uint256   pos;
461     uint256[] slots;
462     uint256[] bonuses;
463 
464     uint256 threshold;
465     uint256 maxTokensInTier;
466     uint256 rate;
467     uint256 tokenDiv;
468 
469     function KeeHole() public {
470         token = KeeToken(0x72D32ac1c5E66BfC5b08806271f8eEF915545164);
471         slots.push(100);
472         slots.push(200);
473         slots.push(500);
474         slots.push(1200);
475         bonuses.push(5);
476         bonuses.push(3);
477         bonuses.push(2);
478         bonuses.push(1);
479         threshold = 5;
480         rate = 10000;
481         tokenDiv = 100000000; // 10^18 / 10^10
482         maxTokensInTier = 25000 * (10 ** 10);
483     }
484 
485     mapping (address => bool) hasParticipated;
486 
487     // getBonusAmount - calculates any bonus due.
488     // only one bonus per account
489     function getBonusAmount(uint256 amount) public returns (uint256 bonus) {
490         if (hasParticipated[msg.sender])
491             return 0;
492         if ( token.icoBalanceOf(msg.sender,this) < threshold )
493             return 0;
494         if (pos>=slots.length)
495             return 0;
496         bonus = (amount.mul(bonuses[pos])).div(100);
497         slots[pos]--;
498         if (slots[pos] == 0) 
499             pos++;
500         bonus = Math.min256(maxTokensInTier,bonus);
501         hasParticipated[msg.sender] = true;
502         return;
503     }
504 
505     // this function is not const because it writes hasParticipated
506     function getTokenAmount(uint256 ethDeposit) public returns (uint256 numTokens) {
507         numTokens = (ethDeposit.mul(rate)).div(tokenDiv);
508         numTokens = numTokens.add(getBonusAmount(numTokens));
509     }
510 
511 
512 }
513 
514 contract GenevieveCrowdsale is Ownable, Pausable, KeeHole {
515   using SafeMath for uint256;
516 
517   // The token being sold
518   GXVCToken public token;
519   KeeHole public keeCrytoken;
520 
521   // owner of GXVC tokens
522   address public tokenSpender;
523 
524   // start and end times
525   uint256 public startTimestamp;
526   uint256 public endTimestamp;
527 
528   // address where funds are collected
529   address public hardwareWallet;
530 
531   mapping (address => uint256) public deposits;
532   uint256 public numberOfPurchasers;
533 
534   // how many token units a buyer gets per wei comes from keeUser
535   
536  // uint256 public rate;
537 
538   // amount of raised money in wei
539   uint256 public weiRaised;
540   uint256 public weiToRaise;
541   uint256 public tokensSold;
542 
543   uint256 public minContribution = 1 finney;
544 
545 
546   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
547   event MainSaleClosed();
548 
549   uint256 public weiRaisedInPresale  = 0 ether;
550   uint256 public tokensSoldInPresale = 0 * 10 ** 18;
551 
552 // REGISTRY FUNCTIONS 
553 
554   mapping (address => bool) public registered;
555   address public registrar;
556   function setReg(address _newReg) external onlyOwner {
557     registrar = _newReg;
558   }
559 
560   function register(address participant) external {
561     require(msg.sender == registrar);
562     registered[participant] = true;
563   }
564 
565 // END OF REGISTRY FUNCTIONS
566 
567   function setCoin(GXVCToken _coin) external onlyOwner {
568     token = _coin;
569   }
570 
571   function setWallet(address _wallet) external onlyOwner {
572     hardwareWallet = _wallet;
573   }
574 
575   function GenevieveCrowdsale() public {
576     token = GXVCToken(0x22F0AF8D78851b72EE799e05F54A77001586B18A);
577     startTimestamp = 1516453200;
578     endTimestamp = 1519563600;
579     hardwareWallet = 0x6Bc63d12D5AAEBe4dc86785053d7E4f09077b89E;
580     tokensSoldInPresale = 0; // 187500
581     weiToRaise = 10000 * (10 ** 18);
582     tokenSpender = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f; // Bal = 104605839.665805634 GXVC
583 
584     minContribution = 1 finney;
585     require(startTimestamp >= now);
586     require(endTimestamp >= startTimestamp);
587   }
588 
589   // check if valid purchase
590   modifier validPurchase {
591     // REGISTRY REQUIREMENT
592     require(registered[msg.sender]);
593     // END OF REGISTRY REQUIREMENT
594     require(now >= startTimestamp);
595     require(now < endTimestamp);
596     require(msg.value >= minContribution);
597     require(weiRaised.add(msg.value) <= weiToRaise);
598     _;
599   }
600 
601   // @return true if crowdsale event has ended
602   function hasEnded() public constant returns (bool) {
603     if (now > endTimestamp) 
604         return true;
605     if (weiRaised >= weiToRaise.sub(minContribution))
606       return true;
607     return false;
608   }
609 
610   // low level token purchase function
611   function buyTokens(address beneficiary, uint256 weiAmount) 
612     internal 
613     validPurchase 
614     whenNotPaused
615   {
616 
617     require(beneficiary != 0x0);
618 
619     if (deposits[beneficiary] == 0) {
620         numberOfPurchasers++;
621     }
622     deposits[beneficiary] = weiAmount.add(deposits[beneficiary]);
623     
624     // calculate token amount to be created
625     uint256 tokens = getTokenAmount(weiAmount);
626 
627     // update state
628     weiRaised = weiRaised.add(weiAmount);
629     tokensSold = tokensSold.add(tokens);
630 
631     require(token.transferFrom(tokenSpender, beneficiary, tokens));
632     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
633     hardwareWallet.transfer(this.balance);
634   }
635 
636   // fallback function can be used to buy tokens
637   function () public payable {
638     buyTokens(msg.sender,msg.value);
639   }
640 
641     function emergencyERC20Drain( ERC20 theToken, uint amount ) {
642         theToken.transfer(owner, amount);
643     }
644 
645 
646 }