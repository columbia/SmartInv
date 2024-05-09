1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) pure internal returns (uint256) {
15     assert(b != 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) pure internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   
32   function mulByFraction(uint256 number, uint256 numerator, uint256 denominator) pure internal returns (uint256) {
33       return div(mul(number, numerator), denominator);
34   }
35 }
36 
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public view returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * @dev Increase the amount of tokens that an owner allowed to a spender.
162    *
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    * @param _spender The address which will spend the funds.
168    * @param _addedValue The amount of tokens to increase the allowance by.
169    */
170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   /**
177    * @dev Decrease the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To decrement
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _subtractedValue The amount of tokens to decrease the allowance by.
185    */
186   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
187     uint oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197 }
198 
199 
200 
201 /**
202  * @title Ownable
203  * @dev The Ownable contract has an owner address, and provides basic authorization control
204  * functions, this simplifies the implementation of "user permissions".
205  */
206 contract Ownable {
207   address public owner;
208 
209 
210   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212 
213   /**
214    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
215    * account.
216    */
217   function Ownable() public {
218     owner = msg.sender;
219   }
220 
221 
222   /**
223    * @dev Throws if called by any account other than the owner.
224    */
225   modifier onlyOwner() {
226     require(msg.sender == owner);
227     _;
228   }
229 
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address newOwner) public onlyOwner {
236     require(newOwner != address(0));
237     OwnershipTransferred(owner, newOwner);
238     owner = newOwner;
239   }
240 
241 }
242 
243 
244 
245 /**
246  * @title Pausable
247  * @dev Base contract which allows children to implement an emergency stop mechanism.
248  */
249 contract Pausable is Ownable {
250 
251   // timestamps until all tokens transfers are blocked
252   uint256 public blockedTimeForBountyTokens = 0;
253   uint256 public blockedTimeForInvestedTokens = 0;
254 
255   // minimum timestamp that tokens will be blocked for transfers
256   uint256 constant MIN_blockedTimeForBountyTokens = 1524949200; //29.04.2018, 0:00:00
257   uint256 constant MIN_blockedTimeForInvestedTokens = 1521061200; //15.03.2018, 0:00:00
258 
259   //Addresses pre-ico investors
260   mapping(address => bool) preIcoAccounts;
261 
262   //Addresses bounty campaign
263   mapping(address => bool) bountyAccounts;
264 
265   //Addresses with founders tokens and flag is it blocking transfers from this address
266   mapping(address => uint) founderAccounts; // 1 - block transfers, 2 - do not block transfers
267 
268   function Pausable() public {
269     blockedTimeForBountyTokens = MIN_blockedTimeForBountyTokens;
270     blockedTimeForInvestedTokens = MIN_blockedTimeForInvestedTokens;
271   }
272 
273   /**
274   * @dev called by owner for changing blockedTimeForBountyTokens
275   */
276   function changeBlockedTimeForBountyTokens(uint256 _blockedTime) onlyOwner external {
277     require(_blockedTime < MIN_blockedTimeForBountyTokens);
278     blockedTimeForBountyTokens = _blockedTime;
279   }
280 
281   /**
282 * @dev called by owner for changing blockedTimeForInvestedTokens
283 */
284   function changeBlockedTimeForInvestedTokens(uint256 _blockedTime) onlyOwner external {
285     require(_blockedTime < MIN_blockedTimeForInvestedTokens);
286     blockedTimeForInvestedTokens = _blockedTime;
287   }
288 
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is not paused.
292    */
293   modifier whenNotPaused() {
294     require(!getPaused());
295     _;
296   }
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is paused.
300    */
301   modifier whenPaused() {
302     require(getPaused());
303     _;
304   }
305 
306   function getPaused() internal returns (bool) {
307     if (now > blockedTimeForBountyTokens && now > blockedTimeForInvestedTokens) {
308       return false;
309     } else {
310       uint256 blockedTime = checkTimeForTransfer(msg.sender);
311       return now < blockedTime;
312     }
313   }
314 
315 
316   /**
317   * @dev called by owner, add preIcoAccount
318   */
319   function addPreIcoAccounts(address _addr) onlyOwner internal {
320     require(_addr != 0x0);
321     preIcoAccounts[_addr] = true;
322   }
323 
324   /**
325   * @dev called by owner, add addBountyAccount
326   */
327   function addBountyAccounts(address _addr) onlyOwner internal {
328     require(_addr != 0x0);
329     preIcoAccounts[_addr] = true;
330   }
331 
332   /**
333   * @dev called by owner, add founderAccount
334   */
335   function addFounderAccounts(address _addr, uint _flag) onlyOwner external {
336     require(_addr != 0x0);
337     founderAccounts[_addr] = _flag;
338   }
339 
340   /**
341    * @dev called by external contract (ImmlaToken) for checking rights for transfers, depends on who owner of this address
342    */
343   function checkTimeForTransfer(address _account) internal returns (uint256) {
344     if (founderAccounts[_account] == 1) {
345       return blockedTimeForInvestedTokens;
346     } else if(founderAccounts[_account] == 2) {
347       return 1; //do not block transfers
348     } else if (preIcoAccounts[_account]) {
349       return blockedTimeForInvestedTokens;
350     } else if (bountyAccounts[_account]) {
351       return blockedTimeForBountyTokens;
352     } else {
353       return blockedTimeForInvestedTokens;
354     }
355   }
356 }
357 
358 
359 
360 /**
361  * @title Pausable token
362  *
363  * @dev StandardToken modified with pausable transfers.
364  **/
365 
366 contract PausableToken is StandardToken, Pausable {
367 
368   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
369     return super.transfer(_to, _value);
370   }
371 
372   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
373     return super.transferFrom(_from, _to, _value);
374   }
375 
376   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
377     return super.approve(_spender, _value);
378   }
379 
380   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
381     return super.increaseApproval(_spender, _addedValue);
382   }
383 
384   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
385     return super.decreaseApproval(_spender, _subtractedValue);
386   }
387 }
388 
389 
390 
391 
392 /**
393  * @title Mintable token
394  * @dev Simple ERC20 Token example, with mintable token creation
395  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
396  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
397  */
398 
399 contract MintableToken is PausableToken {
400   event Mint(address indexed to, uint256 amount);
401   event MintFinished();
402 
403   bool public mintingFinished = false;
404 
405 
406   modifier canMint() {
407     require(!mintingFinished);
408     _;
409   }
410 
411   /**
412    * @dev Function to mint tokens
413    * @param _to The address that will receive the minted tokens.
414    * @param _amount The amount of tokens to mint.
415    * @return A boolean that indicates if the operation was successful.
416    */
417   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
418     totalSupply = totalSupply.add(_amount);
419     balances[_to] = balances[_to].add(_amount);
420     Mint(_to, _amount);
421     Transfer(address(0), _to, _amount);
422     return true;
423   }
424 
425   /**
426    * @dev called by the owner to mint tokens for pre-ico
427    */
428   function multiMintPreico(address[] _dests, uint256[] _values) onlyOwner canMint public returns (uint256) {
429     uint256 i = 0;
430     uint256 count = _dests.length;
431     while (i < count) {
432       totalSupply = totalSupply.add(_values[i]);
433       balances[_dests[i]] = balances[_dests[i]].add(_values[i]);
434       addPreIcoAccounts(_dests[i]);
435       Mint(_dests[i], _values[i]);
436       Transfer(address(0), _dests[i], _values[i]);
437       i += 1;
438     }
439     return(i);
440   }
441 
442   /**
443    * @dev called by the owner to mint tokens for pre-ico
444    */
445   function multiMintBounty(address[] _dests, uint256[] _values) onlyOwner canMint public returns (uint256) {
446     uint256 i = 0;
447     uint256 count = _dests.length;
448     while (i < count) {
449       totalSupply = totalSupply.add(_values[i]);
450       balances[_dests[i]] = balances[_dests[i]].add(_values[i]);
451       addBountyAccounts(_dests[i]);
452       Mint(_dests[i], _values[i]);
453       Transfer(address(0), _dests[i], _values[i]);
454       i += 1;
455     }
456     return(i);
457   }
458 
459   /**
460    * @dev Function to stop minting new tokens.
461    * @return True if the operation was successful.
462    */
463   function finishMinting() onlyOwner canMint public returns (bool) {
464     mintingFinished = true;
465     MintFinished();
466     return true;
467   }
468 }
469 
470 
471 
472 /**
473  * @title ERC20 token that transferable by owner
474  */
475 contract TransferableByOwner is StandardToken, Ownable {
476 
477   // timestamp until owner could transfer all tokens
478   uint256 constant public OWNER_TRANSFER_TOKENS = now + 1 years;
479 
480   /**
481    * @dev Transfer tokens from one address to another by owner
482    * @param _from address The address which you want to send tokens from
483    * @param _to address The address which you want to transfer to
484    * @param _value uint256 the amount of tokens to be transferred
485    */
486   function transferByOwner(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
487     require(now < OWNER_TRANSFER_TOKENS);
488     require(_to != address(0));
489     require(_value <= balances[_from]);
490 
491     balances[_from] = balances[_from].sub(_value);
492     balances[_to] = balances[_to].add(_value);
493     Transfer(_from, _to, _value);
494     return true;
495   }
496 }
497 
498 
499 
500 contract ImmlaToken is MintableToken, TransferableByOwner {
501     using SafeMath for uint256;
502 
503     /*
504      * Token meta data
505      */
506     string public constant name = "IMMLA";
507     string public constant symbol = "IML";
508     uint8 public constant decimals = 18;
509 }
510 
511 
512 
513 contract ImmlaDistribution is Ownable {
514     using SafeMath for uint256;
515 
516     // minimum amount of tokens a buyer gets per 1 ether
517     uint256 constant RATE_MIN = 3640;
518 
519     // timestamp until owner could transfer all tokens
520     uint256 constant public OWNER_TRANSFER_TOKENS = now + 1 years;
521 
522     // The token being sold
523     ImmlaToken public token;
524 
525     //maximum tokens for mint in additional emission
526     uint256 public constant emissionLimit = 418124235 * 1 ether;
527 
528     // amount of tokens that already minted in additional emission
529     uint256 public additionalEmission = 0;
530 
531     // amount of token that currently available for buying
532     uint256 public availableEmission = 0;
533 
534     bool public mintingPreIcoFinish = false;
535     bool public mintingBountyFinish = false;
536     bool public mintingFoundersFinish = false;
537 
538     // address where funds are collected (by default t_Slava address)
539     address public wallet;
540 
541     // how many token units a buyer gets per 1 ether
542     uint256 public rate;
543 
544     address constant public t_ImmlaTokenDepository = 0x64075EEf64d9E105A61227CcCd5fA9F6b54DB278;
545     address constant public t_ImmlaTokenDepository2 = 0x2Faaf371Af6392fdd3016E111fB4b3B551Ee46aB;
546     address constant public t_ImmlaBountyTokenDepository = 0x5AB08C5Dfd53b8f6f6C3e3bbFDb521170C3863B0;
547     address constant public t_Andrey = 0x027810A9C17cb0E739a33769A9E794AAF40D2338;
548     address constant public t_Michail = 0x00af06cF0Ae6BD83fC36b6Ae092bb4F669B6dbF0;
549     address constant public t_Slava = 0x00c11E5B0b5db0234DfF9a357F56077c9a7A83D0;
550     address constant public t_Andrey2 = 0xC7e788FeaE61503136021cC48a0c95bB66d0B9f2;
551     address constant public t_Michail2 = 0xb6f4ED2CE19A08c164790419D5d87D3074D4Bd92;
552     address constant public t_Slava2 = 0x00ded30026135fBC460c2A9bf7beC06c7F31101a;
553 
554     /**
555      * @dev Proposals for mint tokens to some address
556      */
557     mapping(address => Proposal) public proposals;
558 
559     struct Proposal {
560         address wallet;
561         uint256 amount;
562         uint256 numberOfVotes;
563         mapping(address => bool) voted;
564     }
565 
566     /**
567      * @dev Members of congress
568      */
569     mapping(address => bool) public congress;
570 
571     /**
572      * @dev Minimal quorum value
573      */
574     uint256 public minimumQuorum = 1;
575 
576     /**
577    * event for token purchase logging
578    * @param purchaser who paid for the tokens
579    * @param value weis paid for purchase
580    * @param amount amount of tokens purchased
581    */
582     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
583 
584     /**
585      * @dev On proposal added
586      * @param congressman Congressman address
587      * @param wallet Wallet
588      * @param amount Amount of wei to transfer
589      */
590     event ProposalAdded(address indexed congressman, address indexed wallet, uint256 indexed amount);
591 
592     /**
593      * @dev On proposal passed
594      * @param congressman Congressman address
595      * @param wallet Wallet
596      * @param amount Amount of wei to transfer
597      */
598     event ProposalPassed(address indexed congressman, address indexed wallet, uint256 indexed amount);
599 
600     /**
601    * @dev Modifier to make a function callable only when the minting for pre-ico is not paused.
602    */
603     modifier whenNotPreIcoFinish() {
604         require(!mintingPreIcoFinish);
605         _;
606     }
607 
608     /**
609    * @dev Modifier to make a function callable only when the minting for bounty is not paused.
610    */
611     modifier whenNotBountyFinish() {
612         require(!mintingBountyFinish);
613         _;
614     }
615 
616     /**
617    * @dev Modifier to make a function callable only when the minting for bounty is not paused.
618    */
619     modifier whenNotMintingFounders() {
620         require(!mintingFoundersFinish);
621         _;
622     }
623 
624     /**
625      * @dev Modifier that allows only congress to vote and create new proposals
626      */
627     modifier onlyCongress {
628         require (congress[msg.sender]);
629         _;
630     }
631 
632     /*
633      * ImmlaDistribution constructor
634      */
635     function ImmlaDistribution(address _token) public payable { // gas 6297067
636         token = ImmlaToken(_token);
637 
638         //@TODO - change this to t_Slava (0x00c11E5B0b5db0234DfF9a357F56077c9a7A83D0) address or deploy contract from this address
639         owner = 0x00c11E5B0b5db0234DfF9a357F56077c9a7A83D0;
640 
641         wallet = owner;
642         rate = RATE_MIN;
643 
644         congress[t_Andrey] = true;
645         congress[t_Michail] = true;
646         congress[t_Slava] = true;
647         minimumQuorum = 3;
648     }
649 
650     /**
651    * @dev called by the owner to mint tokens to founders
652    */
653     function mintToFounders() onlyOwner whenNotMintingFounders public returns (bool) {
654         mintToFounders(t_ImmlaTokenDepository, 52000 * 1 ether, 2);
655         mintToFounders(t_ImmlaTokenDepository2, 0, 2);
656         mintToFounders(t_ImmlaBountyTokenDepository, 0, 2);
657         mintToFounders(t_Andrey,   525510849836086000000000, 1);
658         mintToFounders(t_Michail,  394133137377065000000000, 1);
659         mintToFounders(t_Slava,    394133137377065000000000, 1);
660         mintToFounders(t_Andrey2,  284139016853060000000000, 2);
661         mintToFounders(t_Michail2, 213104262639795000000000, 2);
662         mintToFounders(t_Slava2,   213104262639795000000000, 2);
663         mintingFoundersFinish = true;
664 
665         return true;
666     }
667 
668     // fallback function can be used to buy tokens
669     function () external payable {
670         buyTokens();
671     }
672 
673     // low level token purchase function
674     function buyTokens() public payable {
675         require(availableEmission > 0);
676         require(msg.value != 0);
677 
678         address investor = msg.sender;
679         uint256 weiAmount = msg.value;
680 
681         uint256 tokensAmount = weiAmount.mul(rate);
682 
683         //calculate change
684         uint256 tokensChange = 0;
685         if (tokensAmount > availableEmission) {
686             tokensChange = tokensAmount - availableEmission;
687             tokensAmount = availableEmission;
688         }
689 
690         //make change
691         uint256 weiChange = 0;
692         if (tokensChange > 0) {
693             weiChange = tokensChange.div(rate);
694             investor.transfer(weiChange);
695         }
696 
697         uint256 weiRaised = weiAmount - weiChange;
698 
699         // update raised amount and additional emission
700         additionalEmission = additionalEmission.add(tokensAmount);
701         availableEmission = availableEmission.sub(tokensAmount);
702 
703         //send tokens to investor
704         token.mint(investor, tokensAmount);
705         TokenPurchase(investor, weiRaised, tokensAmount);
706         mintBonusToFounders(tokensAmount);
707 
708         //send ether to owner wallet
709         wallet.transfer(weiRaised);
710     }
711 
712     /**
713    * @dev called by the owner to make additional emission
714    */
715     function updateAdditionalEmission(uint256 _amount, uint256 _rate) onlyOwner public { // gas 48191
716         require(_amount > 0);
717         require(_amount < (emissionLimit - additionalEmission));
718 
719         availableEmission = _amount;
720         if (_rate > RATE_MIN) {
721             rate = RATE_MIN;
722         } else {
723             rate = _rate;
724         }
725     }
726 
727     /**
728    * @dev called by the owner to stop minting
729    */
730     function stopPreIcoMint() onlyOwner whenNotPreIcoFinish public {
731         mintingPreIcoFinish = true;
732     }
733 
734     /**
735    * @dev called by the owner to stop minting
736    */
737     function stopBountyMint() onlyOwner whenNotBountyFinish public {
738         mintingBountyFinish = true;
739     }
740 
741     /**
742    * @dev called by the owner to mint tokens for pre-ico
743    */
744     function multiMintPreIco(address[] _dests, uint256[] _values) onlyOwner whenNotPreIcoFinish public returns (bool) {
745         token.multiMintPreico(_dests, _values);
746         return true;
747     }
748 
749     /**
750    * @dev called by the owner to mint tokens for bounty
751    */
752     function multiMintBounty(address[] _dests, uint256[] _values) onlyOwner whenNotBountyFinish public returns (bool) {
753         token.multiMintBounty(_dests, _values);
754         return true;
755     }
756 
757     /**
758    * @dev called to mint tokens to founders
759    */
760     function mintToFounders(address _dest, uint256 _value, uint _flag) internal {
761         token.mint(_dest, _value);
762         token.addFounderAccounts(_dest, _flag);
763     }
764 
765     /**
766    * @dev called to mint bonus tokens to founders
767    */
768     function mintBonusToFounders(uint256 _value) internal {
769 
770         uint256 valueWithCoefficient = (_value * 1000) / 813;
771         uint256 valueWithMultiplier1 = valueWithCoefficient / 10;
772         uint256 valueWithMultiplier2 = (valueWithCoefficient * 7) / 100;
773 
774         token.mint(t_Andrey, (valueWithMultiplier1 * 4) / 10);
775         token.mint(t_Michail, (valueWithMultiplier1 * 3) / 10);
776         token.mint(t_Slava, (valueWithMultiplier1 * 3) / 10);
777         token.mint(t_Andrey2, (valueWithMultiplier2 * 4) / 10);
778         token.mint(t_Michail2, (valueWithMultiplier2 * 3) / 10);
779         token.mint(t_Slava2, (valueWithMultiplier2 * 3) / 10);
780         token.mint(t_ImmlaBountyTokenDepository, (valueWithCoefficient * 15) / 1000);
781     }
782 
783     /**
784   * @dev called by owner for changing blockedTimeForBountyTokens
785   */
786     function changeBlockedTimeForBountyTokens(uint256 _blockedTime) onlyOwner public {
787         token.changeBlockedTimeForBountyTokens(_blockedTime);
788     }
789 
790     /**
791   * @dev called by owner for changing blockedTimeForInvestedTokens
792   */
793     function changeBlockedTimeForInvestedTokens(uint256 _blockedTime) onlyOwner public {
794         token.changeBlockedTimeForInvestedTokens(_blockedTime);
795     }
796 
797     /**
798      * @dev Create a new proposal
799      * @param _wallet Beneficiary account address
800      * @param _amount Amount of tokens
801      */
802     function proposal(address _wallet, uint256 _amount) onlyCongress public {
803         require(availableEmission > 0);
804         require(_amount > 0);
805         require(_wallet != 0x0);
806         
807         if (proposals[_wallet].amount > 0) {
808             require(proposals[_wallet].voted[msg.sender] != true); // If has already voted, cancel
809             require(proposals[_wallet].amount == _amount); // If amounts is equal
810 
811             proposals[_wallet].voted[msg.sender] = true; // Set this voter as having voted
812             proposals[_wallet].numberOfVotes++; // Increase the number of votes
813 
814             //proposal passed
815             if (proposals[_wallet].numberOfVotes >= minimumQuorum) {
816                 if (_amount > availableEmission) {
817                     _amount = availableEmission;
818                 }
819 
820                 // update raised amount and additional emission
821                 additionalEmission = additionalEmission.add(_amount);
822                 availableEmission = availableEmission.sub(_amount);
823 
824                 token.mint(_wallet, _amount);
825                 TokenPurchase(_wallet, 0, _amount);
826                 ProposalPassed(msg.sender, _wallet, _amount);
827 
828                 mintBonusToFounders(_amount);
829                 delete proposals[_wallet];
830             }
831 
832         } else {
833             Proposal storage p = proposals[_wallet];
834 
835             p.wallet           = _wallet;
836             p.amount           = _amount;
837             p.numberOfVotes    = 1;
838             p.voted[msg.sender] = true;
839 
840             ProposalAdded(msg.sender, _wallet, _amount);
841         }
842     }
843 
844     /**
845   * @dev called by owner for transfer tokens
846   */
847     function transferTokens(address _from, address _to, uint256 _amount) onlyOwner public {
848         require(_amount > 0);
849 
850         //can't transfer after OWNER_TRANSFER_TOKENS date (after 1 year)
851         require(now < OWNER_TRANSFER_TOKENS);
852 
853         //can't transfer from and to congressman addresses
854         require(!congress[_from]);
855         require(!congress[_to]);
856 
857         token.transferByOwner(_from, _to, _amount);
858     }
859 }