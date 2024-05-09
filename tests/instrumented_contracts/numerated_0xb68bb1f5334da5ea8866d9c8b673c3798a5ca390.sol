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
156      //require(msg.data.length < size + 4);
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
294   address public distAgent;
295 
296   uint public maxAirDrop = 1000*10**18;//need below 1000 TTG
297 
298   uint public havedAirDrop = 0;
299   uint public totalAirDrop = 0; //totalSupply * 5%
300 
301   bool public finishCrowdCoin = false;
302   uint public havedCrowdCoin = 0;
303   uint public totalCrowdCoin = 0; //totalSupply * 50%
304 
305   uint public havedDistDevCoin = 0;
306   uint public totalDevCoin = 0;  //totalSupply * 20%
307 
308   uint public havedDistFoundCoin = 0;
309   uint public totalFoundCoin = 0;  //totalSupply * 20%
310 
311   /**
312    * 0：1：100000；1：1：50000 2：1：25000  3：1：12500  4：1：12500
313    */
314   uint private crowState = 0;//
315   /**
316    * .
317    */
318   function setDistributeAgent(address addr) onlyOwner  public {
319      
320      require(addr != address(0));
321 
322     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
323     distAgent = addr;
324   }
325 
326 
327   /** The function can be called only by a whitelisted release agent. */
328   modifier onlyDistributeAgent() {
329     require(msg.sender == distAgent) ;
330     _;
331   }
332 
333   /* Withdraw */
334   /*
335     NOTICE: These functions withdraw the ETH which remained in the contract account when user call CrowdDistribute
336   */
337   function withdrawAll () onlyOwner() public {
338     owner.transfer(this.balance);
339   }
340 
341   function withdrawAmount (uint256 _amount) onlyOwner() public {
342     owner.transfer(_amount);
343   }
344 
345  /**发token给基金会*/
346  function distributeToFound(address receiver, uint amount) onlyOwner() public  returns (uint actual){ 
347   
348     require((amount+havedDistFoundCoin) < totalFoundCoin);
349   
350     balances[owner] = balances[owner].sub(amount);
351     balances[receiver] = balances[receiver].plus(amount);
352     havedDistFoundCoin = havedDistFoundCoin.plus(amount);
353 
354     addFound(receiver);
355 
356     // This will make the mint transaction apper in EtherScan.io
357     // We can remove this after there is a standardized minting event
358     emit Transfer(0, receiver, amount);
359    
360     return amount;
361  }
362 
363  /**发token给开发者*/
364  function  distributeToDev(address receiver, uint amount) onlyOwner()  public  returns (uint actual){
365 
366     require((amount+havedDistDevCoin) < totalDevCoin);
367 
368     balances[owner] = balances[owner].sub(amount);
369     balances[receiver] = balances[receiver].plus(amount);
370     havedDistDevCoin = havedDistDevCoin.plus(amount);
371 
372     addDeveloper(receiver);
373     // This will make the mint transaction apper in EtherScan.io
374     // We can remove this after there is a standardized minting event
375     emit Transfer(0, receiver, amount);
376 
377     return amount;
378  }
379 
380  /**空投总量及单次量由发行者来控制， agent不能修改，空投接口只能由授权的agent进行*/
381  function airDrop(address transmitter, address receiver, uint amount) public  returns (uint actual){
382 
383     require(receiver != address(0));
384     require(amount <= maxAirDrop);
385     require((amount+havedAirDrop) < totalAirDrop);
386     require(transmitter == distAgent);
387 
388     balances[owner] = balances[owner].sub(amount);
389     balances[receiver] = balances[receiver].plus(amount);
390     havedAirDrop = havedAirDrop.plus(amount);
391 
392     // This will make the mint transaction apper in EtherScan.io
393     // We can remove this after there is a standardized minting event
394     emit AirDrop(0, receiver, amount);
395 
396     return amount;
397   }
398 
399  /**用户ICO众筹，由用户发固定的ETH，回馈用户固定的TTG，并添加ICO账户，控制交易规则*/
400  function crowdDistribution() payable public  returns (uint actual) {
401       
402     require(msg.sender != address(0));
403     require(!isContract(msg.sender));
404     require(msg.value != 0);
405     require(totalCrowdCoin > havedCrowdCoin);
406     require(finishCrowdCoin == false);
407     
408     uint actualAmount = calculateCrowdAmount(msg.value);
409 
410     require(actualAmount != 0);
411 
412     havedCrowdCoin = havedCrowdCoin.plus(actualAmount);
413     balances[owner] = balances[owner].sub(actualAmount);
414     balances[msg.sender] = balances[msg.sender].plus(actualAmount);
415     
416     switchCrowdState();
417     
418     // This will make the mint transaction apper in EtherScan.io
419     // We can remove this after there is a standardized minting event
420     emit CrowdDistribute(0, msg.sender, actualAmount);
421 
422     return actualAmount;
423   }
424 
425  function  switchCrowdState () internal{
426 
427     if (havedCrowdCoin < totalCrowdCoin.mul(10).div(100) ){
428        crowState = 0;
429 
430     }else  if (havedCrowdCoin < totalCrowdCoin.mul(20).div(100) ){
431        crowState = 1;
432     
433     } else if (havedCrowdCoin < totalCrowdCoin.mul(30).div(100) ){
434        crowState = 2;
435 
436     } else if (havedCrowdCoin < totalCrowdCoin.mul(40).div(100) ){
437        crowState = 3;
438 
439     } else if (havedCrowdCoin < totalCrowdCoin.mul(50).div(100) ){
440        crowState = 4;
441     }
442       
443     if (havedCrowdCoin >= totalCrowdCoin) {
444        finishCrowdCoin = true;
445   }
446  }
447 
448 function calculateCrowdAmount (uint _price) internal view returns (uint _crow) {
449         
450     if (crowState == 0) {
451       return _price.mul(50000);
452     }
453     
454      else if (crowState == 1) {
455       return _price.mul(30000);
456     
457     } else if (crowState == 2) {
458       return  _price.mul(20000);
459 
460     } else if (crowState == 3) {
461      return  _price.mul(15000);
462 
463     } else if (crowState == 4) {
464      return  _price.mul(10000);
465     }
466 
467     return 0;
468   }
469 
470 }
471 
472 /**
473  * Define interface for releasing the token transfer after a successful crowdsale.
474  */
475 contract ReleasableToken is ERC20, Ownable {
476 
477   /* The finalizer contract that allows unlift the transfer limits on this token */
478   address public releaseAgent;
479 
480   /** A TTG contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
481   bool public released = false;
482 
483   uint private maxTransferForDev  = 40000000*10**18;
484   uint private maxTransferFoFounds= 20000000*10**18;
485   uint private maxTransfer = 0;//other user is not limited.
486 
487   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
488   mapping (address => bool) public transferAgents;
489 
490   /**
491    * Limit token transfer until the crowdsale is over.
492    *
493    */
494   modifier canTransfer(address _sender, uint _value) {
495 
496     //if owner can Transfer all the time
497     if(_sender != owner){
498       
499       if(isDeveloper()){
500         require(_value < maxTransferForDev);
501 
502       }else if(isFounder()){
503         require(_value < maxTransferFoFounds);
504 
505       }else if(maxTransfer != 0){
506         require(_value < maxTransfer);
507       }
508 
509       if(!released) {
510           require(transferAgents[_sender]);
511       }
512      }
513     _;
514   }
515 
516 
517  function setMaxTranferLimit(uint dev, uint found, uint other) onlyOwner  public {
518 
519       require(dev < totalSupply);
520       require(found < totalSupply);
521       require(other < totalSupply);
522 
523       maxTransferForDev = dev;
524       maxTransferFoFounds = found;
525       maxTransfer = other;
526   }
527 
528 
529   /**
530    * Set the contract that can call release and make the token transferable.
531    *
532    * Design choice. Allow reset the release agent to fix fat finger mistakes.
533    */
534   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
535 
536     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
537     releaseAgent = addr;
538   }
539 
540   /**
541    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
542    */
543   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
544     transferAgents[addr] = state;
545   }
546 
547   /**
548    * One way function to release the tokens to the wild.
549    *
550    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
551    */
552   function releaseTokenTransfer() public onlyReleaseAgent {
553     released = true;
554   }
555 
556   /** The function can be called only before or after the tokens have been releasesd */
557   modifier inReleaseState(bool releaseState) {
558     require(releaseState == released);
559     _;
560   }
561 
562   /** The function can be called only by a whitelisted release agent. */
563   modifier onlyReleaseAgent() {
564     require(msg.sender == releaseAgent);
565     _;
566   }
567 
568   function transfer(address _to, uint _value) public canTransfer(msg.sender,_value) returns (bool success)  {
569     // Call StandardToken.transfer()
570    return super.transfer(_to, _value);
571   }
572 
573   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from,_value) returns (bool success)  {
574     // Call StandardToken.transferForm()
575     return super.transferFrom(_from, _to, _value);
576   }
577 
578 }
579 
580 contract RecycleToken is StandardToken, Ownable {
581 
582   using SafeMathLib for uint;
583 
584   /**
585    * recycle user token to owner account
586    * 
587    */
588   function recycle(address from, uint amount) onlyAdmins public {
589   
590     require(from != address(0));
591     require(balances[from] >=  amount);
592 
593     balances[owner] = balances[owner].add(amount);
594     balances[from]  = balances[from].sub(amount);
595 
596     // This will make the mint transaction apper in EtherScan.io
597     // We can remove this after there is a standardized minting event
598     emit Transfer(from, owner, amount);
599   }
600 
601 }
602 
603 
604 /**
605  * A token that can increase its supply by another contract.
606  *
607  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
608  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
609  *
610  */
611 contract MintableToken is StandardToken, Ownable {
612 
613   using SafeMathLib for uint;
614 
615   bool public mintingFinished = false;
616 
617   /** List of agents that are allowed to create new tokens */
618   mapping (address => bool) public mintAgents;
619 
620   event MintingAgentChanged(address addr, bool state  );
621 
622   /**
623    * Create new tokens and allocate them to an address..
624    *
625    * Only callably by a crowdsale contract (mint agent). 
626    */
627   function mint(address receiver, uint amount) onlyMintAgent canMint public {
628 
629     //totalsupply is not changed, send amount TTG to receiver from owner account.
630     balances[owner] = balances[owner].sub(amount);
631     balances[receiver] = balances[receiver].plus(amount);
632     
633     // This will make the mint transaction apper in EtherScan.io
634     // We can remove this after there is a standardized minting event
635     emit Transfer(0, receiver, amount);
636   }
637 
638   /**
639    * Owner can allow a crowdsale contract to mint new tokens.
640    */
641   function setMintAgent(address addr, bool state) onlyOwner canMint public {
642     mintAgents[addr] = state;
643     emit MintingAgentChanged(addr, state);
644   }
645 
646   modifier onlyMintAgent() {
647     // Only crowdsale contracts are allowed to mint new tokens
648     require(mintAgents[msg.sender]);
649     _;
650   }
651 
652   function enableMint() onlyOwner public {
653     mintingFinished = false;
654   }
655 
656   /** Make sure we are not done yet. */
657   modifier canMint() {
658     require(!mintingFinished);
659     _;
660   }
661 }
662 
663 
664 
665 /**
666  * A crowdsaled token.
667  *
668  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
669  *
670  * - The token transfer() is disabled until the crowdsale is over
671  * - The token contract gives an opt-in upgrade path to a new contract
672  * - The same token can be part of several crowdsales through approve() mechanism
673  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
674  *
675  */
676 contract TTGCoin is ReleasableToken, MintableToken , DistributeToken, RecycleToken{
677 
678   /** Name and symbol were updated. */
679   event UpdatedTokenInformation(string newName, string newSymbol);
680 
681   string public name;
682 
683   string public symbol;
684 
685   uint public decimals;
686 
687   /**
688    * Construct the token.
689    *
690    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
691    *
692    */
693   function TTGCoin() public {
694     // Create any address, can be transferred
695     // to team multisig via changeOwner(),
696     owner = msg.sender;
697 
698     addAdmin(owner);
699 
700     name  = "TotalGame Coin";
701     symbol = "TGC";
702     totalSupply = 2000000000*10**18;
703     decimals = 18;
704 
705     // Create initially all balance on the team multisig
706     balances[msg.sender] = totalSupply;
707 
708     //Mint feature is not allow  now
709     mintingFinished = true;
710 
711     //Set the distribute totaltoken strategy
712     totalAirDrop = totalSupply.mul(10).div(100);
713     totalCrowdCoin = totalSupply.mul(50).div(100);
714     totalDevCoin = totalSupply.mul(20).div(100);
715     totalFoundCoin = totalSupply.mul(20).div(100);
716 
717     emit Minted(owner, totalSupply);
718   }
719 
720 
721   /**
722    * When token is released to be transferable, enforce no new tokens can be created.
723    */
724   function releaseTokenTransfer() public onlyReleaseAgent {
725     super.releaseTokenTransfer();
726   }
727 
728   /**
729    * Owner can update token information here.
730    *
731    * It is often useful to conceal the actual token association, until
732    * the token operations, like central issuance or reissuance have been completed.
733    *
734    * This function allows the token owner to rename the token after the operations
735    * have been completed and then point the audience to use the token contract.
736    */
737   function setTokenInformation(string _name, string _symbol) public onlyOwner {
738     name = _name;
739     symbol = _symbol;
740 
741     emit UpdatedTokenInformation(name, symbol);
742   }
743 
744   function getTotalSupply() public view returns (uint) {
745     return totalSupply;
746   }
747 
748   function tokenName() public view returns (string _name) {
749     return name;
750   }
751 }