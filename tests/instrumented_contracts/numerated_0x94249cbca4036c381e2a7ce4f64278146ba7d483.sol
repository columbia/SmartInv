1 pragma solidity ^0.4.2;
2 
3 //import "./SafeMathLib.sol";
4 /**
5  * Safe unsigned safe math.
6  *
7  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
8  *
9  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
10  *
11  * Maintained here until merged to mainline zeppelin-solidity.
12  *
13  */
14 library SafeMathLib {
15 
16   function times(uint a, uint b) internal pure returns (uint) {
17     uint c = a * b;
18     require(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function minus(uint a, uint b) internal pure returns (uint) {
23     require(b <= a);
24     return a - b;
25   }
26 
27   function plus(uint a, uint b) internal pure returns (uint) {
28     uint c = a + b;
29     require(c>=a);
30     return c;
31   }
32   function mul(uint a, uint b) internal pure returns (uint) {
33     uint c = a * b;
34     require(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint a, uint b) internal pure returns (uint) {
39     require(b > 0);
40     uint c = a / b;
41     require(a == b * c + a % b);
42     return c;
43   }
44 
45   function sub(uint a, uint b) internal pure returns (uint) {
46     require(b <= a);
47     return a - b;
48   }
49 
50   function add(uint a, uint b) internal pure returns (uint) {
51     uint c = a + b;
52     require(c>=a && c>=b);
53     return c;
54   }
55 
56 }
57 
58 /*
59  * ERC20 interface
60  * see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20 {
63   uint public totalSupply;
64   function balanceOf(address who) public constant returns (uint);
65   function allowance(address owner, address spender) public constant returns (uint);
66 
67   function transfer(address to, uint value) public  returns (bool ok);
68   function transferFrom(address from, address to, uint value) public returns (bool ok);
69   function approve(address spender, uint value) public returns (bool ok);
70    event Transfer(address indexed from, address indexed to, uint value);
71    event Approval(address indexed owner, address indexed spender, uint value);
72 }
73 
74 
75 
76 /**
77  * Math operations with safety checks
78  */
79 contract SafeMath {
80   function safeMul(uint a, uint b) internal pure returns (uint) {
81     uint c = a * b;
82     require(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function safeDiv(uint a, uint b) internal pure returns (uint) {
87     assert(b > 0);
88     uint c = a / b;
89     require(a == b * c + a % b);
90     return c;
91   }
92 
93   function safeSub(uint a, uint b) internal pure returns (uint) {
94     require(b <= a);
95     return a - b;
96   }
97 
98   function safeAdd(uint a, uint b) internal pure returns (uint) {
99     uint c = a + b;
100     require(c>=a && c>=b);
101     return c;
102   }
103 
104   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
105     return a >= b ? a : b;
106   }
107 
108   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
109     return a < b ? a : b;
110   }
111 
112   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
113     return a >= b ? a : b;
114   }
115 
116   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
117     return a < b ? a : b;
118   }
119 
120   //function assert(bool assertion) internal pure{
121   //  require (assertion);
122   //}
123 }
124 
125 
126 
127 /**
128  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
129  *
130  * Based on code by FirstBlood:
131  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, SafeMath {
134 
135   /* Token supply got increased and a new owner received these tokens */
136    event Minted(address receiver, uint amount);
137 
138   /* Actual balances of token holders */
139   mapping(address => uint) balances;
140 
141   /* approve() allowances */
142   mapping (address => mapping (address => uint)) allowed;
143 
144   /* Interface declaration */
145   function isToken() public pure returns (bool weAre) {
146     return true;
147   }
148 
149   /**
150    *
151    * Fix for the ERC20 short address attack
152    *
153    * http://vessenes.com/the-erc20-short-address-attack-explained/
154    */
155   modifier onlyPayloadSize(uint size) {
156      require(msg.data.length >= size + 4);
157      _;
158   }
159 
160   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
161     require(_value >= 0);
162     balances[msg.sender] = safeSub(balances[msg.sender], _value);
163     balances[_to] = safeAdd(balances[_to], _value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
169     uint _allowance = allowed[_from][msg.sender];
170 
171     //requre the alloced greater than _value
172     require(_allowance >= _value);
173     require(_value >= 0);
174 
175     balances[_to] = safeAdd(balances[_to], _value);
176     balances[_from] = safeSub(balances[_from], _value);
177     allowed[_from][msg.sender] = safeSub(_allowance, _value);
178     emit Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   function balanceOf(address _owner) public view returns (uint balance) {
183     return balances[_owner];
184   }
185 
186   function approve(address _spender, uint _value)public returns (bool success) {
187 
188     // To change the approve amount you first have to reduce the addresses`
189     //  allowance to zero by calling `approve(_spender, 0)` if it is not
190     //  already 0 to mitigate the race condition described here:
191     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192     //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
193     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
194 
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204   /* Util */
205   function isContract(address addr) internal view returns (bool) {
206     uint size;
207     assembly { size := extcodesize(addr) } // solium-disable-line
208     return size > 0;
209   }
210 }
211 
212 
213 
214 /*
215  * Ownable
216  *
217  * Base contract with an owner.
218  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
219  */
220 contract Ownable {
221   address public owner;
222   mapping (address => bool) private admins;
223   mapping (address => bool) private developers;
224   mapping (address => bool) private founds;
225 
226   function Ownable()  internal{
227     owner = msg.sender;
228   }
229 
230   modifier onlyAdmins(){
231     require(admins[msg.sender]);
232     _;
233   }
234 
235   modifier onlyOwner()  {
236     require (msg.sender == owner);
237     _;
238   }
239 
240  function getOwner() view public returns (address){
241      return owner;
242   }
243 
244  function isDeveloper () view internal returns (bool) {
245      return developers[msg.sender];
246   }
247 
248  function isFounder () view internal returns (bool){
249      return founds[msg.sender];
250   }
251 
252   function addDeveloper (address _dev) onlyOwner() public {
253     developers[_dev] = true;
254   }
255 
256   function removeDeveloper (address _dev) onlyOwner() public {
257     delete developers[_dev];
258   }
259 
260     function addFound (address _found) onlyOwner() public {
261     founds[_found] = true;
262   }
263 
264   function removeFound (address _found) onlyOwner() public {
265     delete founds[_found];
266   }
267 
268   function addAdmin (address _admin) onlyOwner() public {
269     admins[_admin] = true;
270   }
271 
272   function removeAdmin (address _admin) onlyOwner() public {
273     delete admins[_admin];
274   }
275   
276   function transferOwnership(address newOwner) onlyOwner public {
277     if (newOwner != address(0)) {
278       owner = newOwner;
279     }
280   }
281 }
282 
283 /**
284  * Define interface for distrible the token 
285  */
286 contract DistributeToken is StandardToken, Ownable{
287 
288   event AirDrop(address from, address to, uint amount);
289   event CrowdDistribute(address from, address to, uint amount);
290 
291   using SafeMathLib for uint;
292 
293   /* The finalizer contract that allows Distribute token */
294   // address public distAgent;
295   mapping (address => bool) private distAgents;
296 
297   uint private maxAirDrop = 1000*10**18;//need below 1000 TTG
298 
299   uint private havedAirDrop = 0;
300   uint public totalAirDrop = 0; //totalSupply * 5%
301 
302   bool public finishCrowdCoin = false;
303   uint private havedCrowdCoin = 0;
304   uint public totalCrowdCoin = 0; //totalSupply * 50%
305 
306   uint private havedDistDevCoin = 0;
307   uint public totalDevCoin = 0;  //totalSupply * 20%
308 
309   uint private havedDistFoundCoin = 0;
310   uint public totalFoundCoin = 0;  //totalSupply * 20%
311 
312   /**
313    * 0：1：100000；1：1：50000 2：1：25000  3：1：12500  4：1：12500
314    */
315   uint private crowState = 0;//
316   /**
317    * .
318    */
319   function setDistributeAgent(address addr, bool enabled) onlyOwner  public {
320      
321      require(addr != address(0));
322 
323     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
324     distAgents[addr] = enabled;
325   }
326 
327   function setTotalAirDrop(uint Amount) onlyOwner  public {
328      
329     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
330     totalAirDrop = Amount;
331   }
332 
333   /** The function can be called only by a whitelisted release agent. */
334   modifier onlyDistributeAgent() {
335     require(distAgents[msg.sender] == true) ;
336     _;
337   }
338 
339   /* Withdraw */
340   /*
341     NOTICE: These functions withdraw the ETH which remained in the contract account when user call CrowdDistribute
342   */
343   function withdrawAll () onlyOwner() public {
344     owner.transfer(this.balance);
345   }
346 
347   function withdrawAmount (uint256 _amount) onlyOwner() public {
348     owner.transfer(_amount);
349   }
350 
351  function distributeToFound(address receiver, uint amount) onlyOwner() public  returns (uint actual){ 
352   
353     require((amount+havedDistFoundCoin) < totalFoundCoin);
354   
355     balances[owner] = balances[owner].sub(amount);
356     balances[receiver] = balances[receiver].plus(amount);
357     havedDistFoundCoin = havedDistFoundCoin.plus(amount);
358 
359     addFound(receiver);
360 
361     // This will make the mint transaction apper in EtherScan.io
362     // We can remove this after there is a standardized minting event
363     emit Transfer(0, receiver, amount);
364    
365     return amount;
366  }
367 
368  
369  function  distributeToDev(address receiver, uint amount) onlyOwner()  public  returns (uint actual){
370 
371     require((amount+havedDistDevCoin) < totalDevCoin);
372 
373     balances[owner] = balances[owner].sub(amount);
374     balances[receiver] = balances[receiver].plus(amount);
375     havedDistDevCoin = havedDistDevCoin.plus(amount);
376 
377     addDeveloper(receiver);
378     // This will make the mint transaction apper in EtherScan.io
379     // We can remove this after there is a standardized minting event
380     emit Transfer(0, receiver, amount);
381 
382     return amount;
383  }
384 
385  
386  function airDrop(address transmitter, address receiver, uint amount) public  returns (uint actual){
387 
388     require(receiver != address(0));
389     require(amount <= maxAirDrop);
390     require((amount+havedAirDrop) < totalAirDrop);
391     require(distAgents[msg.sender] == true);
392 
393     balances[owner] = balances[owner].sub(amount);
394     balances[receiver] = balances[receiver].plus(amount);
395     havedAirDrop = havedAirDrop.plus(amount);
396 
397     // This will make the mint transaction apper in EtherScan.io
398     // We can remove this after there is a standardized minting event
399     emit AirDrop(0, receiver, amount);
400 
401     return amount;
402   }
403 
404  
405  function crowdDistribution() payable public  returns (uint actual) {
406       
407     require(msg.sender != address(0));
408     require(!isContract(msg.sender));
409     require(msg.value != 0);
410     require(totalCrowdCoin > havedCrowdCoin);
411     require(finishCrowdCoin == false);
412     
413     uint actualAmount = calculateCrowdAmount(msg.value);
414 
415     require(actualAmount != 0);
416 
417     havedCrowdCoin = havedCrowdCoin.plus(actualAmount);
418     balances[owner] = balances[owner].sub(actualAmount);
419     balances[msg.sender] = balances[msg.sender].plus(actualAmount);
420     
421     switchCrowdState();
422     
423     // This will make the mint transaction apper in EtherScan.io
424     // We can remove this after there is a standardized minting event
425     emit CrowdDistribute(0, msg.sender, actualAmount);
426 
427     return actualAmount;
428   }
429 
430  function  switchCrowdState () internal{
431 
432     if (havedCrowdCoin < totalCrowdCoin.mul(10).div(100) ){
433        crowState = 0;
434 
435     }else  if (havedCrowdCoin < totalCrowdCoin.mul(20).div(100) ){
436        crowState = 1;
437     
438     } else if (havedCrowdCoin < totalCrowdCoin.mul(30).div(100) ){
439        crowState = 2;
440 
441     } else if (havedCrowdCoin < totalCrowdCoin.mul(40).div(100) ){
442        crowState = 3;
443 
444     } else if (havedCrowdCoin < totalCrowdCoin.mul(50).div(100) ){
445        crowState = 4;
446     }
447       
448     if (havedCrowdCoin >= totalCrowdCoin) {
449        finishCrowdCoin = true;
450   }
451  }
452 
453 function calculateCrowdAmount (uint _price) internal view returns (uint _crow) {
454         
455     if (crowState == 0) {
456       return _price.mul(50000);
457     }
458     
459      else if (crowState == 1) {
460       return _price.mul(30000);
461     
462     } else if (crowState == 2) {
463       return  _price.mul(20000);
464 
465     } else if (crowState == 3) {
466      return  _price.mul(15000);
467 
468     } else if (crowState == 4) {
469      return  _price.mul(10000);
470     }
471 
472     return 0;
473   }
474 
475 }
476 
477 /**
478  * Define interface for releasing the token transfer after a successful crowdsale.
479  */
480 contract ReleasableToken is ERC20, Ownable {
481 
482   /* The finalizer contract that allows unlift the transfer limits on this token */
483   address public releaseAgent;
484 
485   /** A TTG contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
486   bool public released = false;
487 
488   uint private maxTransferForDev  = 40000000*10**18;
489   uint private maxTransferFoFounds= 20000000*10**18;
490   uint private maxTransfer = 0;//other user is not limited.
491 
492   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
493   mapping (address => bool) public transferAgents;
494 
495   /**
496    * Limit token transfer until the crowdsale is over.
497    *
498    */
499   modifier canTransfer(address _sender, uint _value) {
500 
501     //if owner can Transfer all the time
502     if(_sender != owner){
503       
504       if(isDeveloper()){
505         require(_value < maxTransferForDev);
506 
507       }else if(isFounder()){
508         require(_value < maxTransferFoFounds);
509 
510       }else if(maxTransfer != 0){
511         require(_value < maxTransfer);
512       }
513 
514       if(!released) {
515           require(transferAgents[_sender]);
516       }
517      }
518     _;
519   }
520 
521 
522  function setMaxTranferLimit(uint dev, uint found, uint other) onlyOwner  public {
523 
524       require(dev < totalSupply);
525       require(found < totalSupply);
526       require(other < totalSupply);
527 
528       maxTransferForDev = dev;
529       maxTransferFoFounds = found;
530       maxTransfer = other;
531   }
532 
533 
534   /**
535    * Set the contract that can call release and make the token transferable.
536    *
537    * Design choice. Allow reset the release agent to fix fat finger mistakes.
538    */
539   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
540 
541     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
542     releaseAgent = addr;
543   }
544 
545   /**
546    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
547    */
548   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
549     transferAgents[addr] = state;
550   }
551 
552   /**
553    * One way function to release the tokens to the wild.
554    *
555    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
556    */
557   function releaseTokenTransfer() public onlyReleaseAgent {
558     released = true;
559   }
560 
561   /** The function can be called only before or after the tokens have been releasesd */
562   modifier inReleaseState(bool releaseState) {
563     require(releaseState == released);
564     _;
565   }
566 
567   /** The function can be called only by a whitelisted release agent. */
568   modifier onlyReleaseAgent() {
569     require(msg.sender == releaseAgent);
570     _;
571   }
572 
573   function transfer(address _to, uint _value) public canTransfer(msg.sender,_value) returns (bool success)  {
574     // Call StandardToken.transfer()
575    return super.transfer(_to, _value);
576   }
577 
578   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from,_value) returns (bool success)  {
579     // Call StandardToken.transferForm()
580     return super.transferFrom(_from, _to, _value);
581   }
582 
583 }
584 
585 contract RecycleToken is StandardToken, Ownable {
586 
587   using SafeMathLib for uint;
588 
589   /**
590    * recycle user token to owner account
591    * 
592    */
593   function recycle(address from, uint amount) onlyAdmins public {
594   
595     require(from != address(0));
596     require(balances[from] >=  amount);
597 
598     balances[owner] = balances[owner].add(amount);
599     balances[from]  = balances[from].sub(amount);
600 
601     // This will make the mint transaction apper in EtherScan.io
602     // We can remove this after there is a standardized minting event
603     emit Transfer(from, owner, amount);
604   }
605 
606 }
607 
608 
609 /**
610  * A token that can increase its supply by another contract.
611  *
612  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
613  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
614  *
615  */
616 contract MintableToken is StandardToken, Ownable {
617 
618   using SafeMathLib for uint;
619 
620   bool public mintingFinished = false;
621 
622   /** List of agents that are allowed to create new tokens */
623   mapping (address => bool) public mintAgents;
624 
625   event MintingAgentChanged(address addr, bool state  );
626 
627   /**
628    * Create new tokens and allocate them to an address..
629    *
630    * Only callably by a crowdsale contract (mint agent). 
631    */
632   function mint(address receiver, uint amount) onlyMintAgent canMint public {
633 
634     //totalsupply is not changed, send amount TTG to receiver from owner account.
635     balances[owner] = balances[owner].sub(amount);
636     balances[receiver] = balances[receiver].plus(amount);
637     
638     // This will make the mint transaction apper in EtherScan.io
639     // We can remove this after there is a standardized minting event
640     emit Transfer(0, receiver, amount);
641   }
642 
643   /**
644    * Owner can allow a crowdsale contract to mint new tokens.
645    */
646   function setMintAgent(address addr, bool state) onlyOwner canMint public {
647     mintAgents[addr] = state;
648     emit MintingAgentChanged(addr, state);
649   }
650 
651   modifier onlyMintAgent() {
652     // Only crowdsale contracts are allowed to mint new tokens
653     require(mintAgents[msg.sender]);
654     _;
655   }
656 
657   function enableMint() onlyOwner public {
658     mintingFinished = false;
659   }
660 
661   /** Make sure we are not done yet. */
662   modifier canMint() {
663     require(!mintingFinished);
664     _;
665   }
666 }
667 
668 
669 
670 /**
671  * A crowdsaled token.
672  *
673  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
674  *
675  * - The token transfer() is disabled until the crowdsale is over
676  * - The token contract gives an opt-in upgrade path to a new contract
677  * - The same token can be part of several crowdsales through approve() mechanism
678  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
679  *
680  */
681 contract TTGCoin is ReleasableToken, MintableToken , DistributeToken, RecycleToken{
682 
683   /** Name and symbol were updated. */
684   event UpdatedTokenInformation(string newName, string newSymbol);
685 
686   string public name;
687 
688   string public symbol;
689 
690   uint public decimals;
691 
692   /**
693    * Construct the token.
694    *
695    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
696    *
697    */
698   function TTGCoin() public {
699     // Create any address, can be transferred
700     // to team multisig via changeOwner(),
701     owner = msg.sender;
702 
703     addAdmin(owner);
704 
705     name  = "TotalGame Coin";
706     symbol = "TTG";
707     totalSupply = 2000000000*10**18;
708     decimals = 18;
709 
710     // Create initially all balance on the team multisig
711     balances[msg.sender] = totalSupply;
712 
713     //Mint feature is not allow  now
714     mintingFinished = true;
715 
716     //Set the distribute totaltoken strategy
717     totalAirDrop = totalSupply.mul(10).div(100);
718     totalCrowdCoin = totalSupply.mul(50).div(100);
719     totalDevCoin = totalSupply.mul(20).div(100);
720     totalFoundCoin = totalSupply.mul(20).div(100);
721 
722     emit Minted(owner, totalSupply);
723   }
724 
725 
726   /**
727    * When token is released to be transferable, enforce no new tokens can be created.
728    */
729   function releaseTokenTransfer() public onlyReleaseAgent {
730     super.releaseTokenTransfer();
731   }
732 
733   /**
734    * Owner can update token information here.
735    *
736    * It is often useful to conceal the actual token association, until
737    * the token operations, like central issuance or reissuance have been completed.
738    *
739    * This function allows the token owner to rename the token after the operations
740    * have been completed and then point the audience to use the token contract.
741    */
742   function setTokenInformation(string _name, string _symbol) public onlyOwner {
743     name = _name;
744     symbol = _symbol;
745 
746     emit UpdatedTokenInformation(name, symbol);
747   }
748 
749   function getTotalSupply() public view returns (uint) {
750     return totalSupply;
751   }
752 
753   function tokenName() public view returns (string _name) {
754     return name;
755   }
756 }