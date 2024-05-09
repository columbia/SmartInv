1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * Based on SafeMath.sol from https://github.com/OpenZeppelin/zeppelin-solidity/tree/master
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 pragma solidity ^0.4.18;
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  * Based on Ownable.sol from https://github.com/OpenZeppelin/zeppelin-solidity/tree/master
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner returns (bool) {
69     require(newOwner != address(0));
70     owner = newOwner;
71     OwnershipTransferred(owner, newOwner);
72     return true;
73   }
74 
75 }
76 
77 
78 pragma solidity ^0.4.18;
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 pragma solidity ^0.4.18;
94 
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender) public view returns (uint256);
102   function transferFrom(address from, address to, uint256 value) public returns (bool);
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 pragma solidity ^0.4.18;
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115   
116   // mapping of addresses with according balances
117   mapping(address => uint256) balances;
118 
119   uint256 public totalSupply;
120 
121   /**
122   * @dev Gets the totalSupply.
123   * @return An uint256 representing the total supply of tokens.
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply;
127   } 
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 pragma solidity ^0.4.18;
141 
142 
143 /**
144  * @title Custom ERC20 token
145  *
146  * @dev Implementation and upgraded version of the basic standard token.
147  */
148 contract CustomToken is ERC20, BasicToken, Ownable {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152   // boolean if transfers can be done
153   bool public enableTransfer = true;
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not paused.
157    */
158   modifier whenTransferEnabled() {
159     require(enableTransfer);
160     _;
161   }
162 
163   event Burn(address indexed burner, uint256 value);
164   event EnableTransfer(address indexed owner, uint256 timestamp);
165   event DisableTransfer(address indexed owner, uint256 timestamp);
166 
167   
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) whenTransferEnabled public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     // SafeMath.sub will throw if there is not enough balance.
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param _from address The address which you want to send tokens from
187    * @param _to address The address which you want to transfer to
188    * @param _value uint256 the amount of tokens to be transferred
189    * The owner can transfer tokens at will. This to implement a reward pool contract in a later phase 
190    * that will transfer tokens for rewarding.
191    */
192   function transferFrom(address _from, address _to, uint256 _value) whenTransferEnabled public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195 
196 
197     if (msg.sender!=owner) {
198       require(_value <= allowed[_from][msg.sender]);
199       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200       balances[_from] = balances[_from].sub(_value);
201       balances[_to] = balances[_to].add(_value);
202     }  else {
203       balances[_from] = balances[_from].sub(_value);
204       balances[_to] = balances[_to].add(_value);
205     }
206 
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) whenTransferEnabled public returns (bool) {
218     // To change the approve amount you first have to reduce the addresses`
219     //  allowance to zero by calling `approve(_spender,0)` if it is not
220     //  already 0 to mitigate the race condition described here:
221     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223     
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /* Approves and then calls the receiving contract */
230   function approveAndCallAsContract(address _spender, uint256 _value, bytes _extraData) onlyOwner public returns (bool success) {
231     // check if the _spender already has some amount approved else use increase approval.
232     // maybe not for exchanges
233     //require((_value == 0) || (allowed[this][_spender] == 0));
234 
235     allowed[this][_spender] = _value;
236     Approval(this, _spender, _value);
237 
238     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
239     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
240     //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
241     require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), this, _value, this, _extraData));
242     return true;
243   }
244 
245   /* 
246    * Approves and then calls the receiving contract 
247    */
248   function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenTransferEnabled public returns (bool success) {
249     // check if the _spender already has some amount approved else use increase approval.
250     // maybe not for exchanges
251     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
252 
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255 
256     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
257     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
258     //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
259     require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
260     return true;
261   }
262 
263   /**
264    * @dev Function to check the amount of tokens that an owner allowed to a spender.
265    * @param _owner address The address which owns the funds.
266    * @param _spender address The address which will spend the funds.
267    * @return A uint256 specifying the amount of tokens still available for the spender.
268    */
269   function allowance(address _owner, address _spender) public view returns (uint256) {
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(address _spender, uint _addedValue) whenTransferEnabled public returns (bool) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) whenTransferEnabled public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 
309   /**
310    * @dev Burns a specific amount of tokens.
311    * @param _value The amount of token to be burned.
312    */
313   function burn(address _burner, uint256 _value) onlyOwner public returns (bool) {
314     require(_value <= balances[_burner]);
315     // no need to require value <= totalSupply, since that would imply the
316     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
317 
318     balances[_burner] = balances[_burner].sub(_value);
319     totalSupply = totalSupply.sub(_value);
320     Burn(_burner, _value);
321     return true;
322   }
323    /**
324    * @dev called by the owner to enable transfers
325    */
326   function enableTransfer() onlyOwner public returns (bool) {
327     enableTransfer = true;
328     EnableTransfer(owner, now);
329     return true;
330   }
331 
332   /**
333    * @dev called by the owner to disable tranfers
334    */
335   function disableTransfer() onlyOwner whenTransferEnabled public returns (bool) {
336     enableTransfer = false;
337     DisableTransfer(owner, now);
338     return true;
339   }
340 }
341 
342 pragma solidity ^0.4.18;
343 
344 
345 /**
346  * @title Identify token
347  * @dev ERC20 compliant token, where all tokens are pre-assigned to the token contract.
348  * Note they can later distribute these tokens as they wish using `transfer` and other
349  * `StandardToken` functions.
350  */
351 contract Identify is CustomToken {
352 
353   string public constant name = "IDENTIFY";
354   string public constant symbol = "IDF"; 
355   uint8 public constant decimals = 6;
356 
357   uint256 public constant INITIAL_SUPPLY = 49253333333 * (10 ** uint256(decimals));
358 
359   /**
360    * @dev Constructor that gives the token contract all of initial tokens.
361    */
362   function Identify() public {
363     totalSupply = INITIAL_SUPPLY;
364     balances[this] = INITIAL_SUPPLY;
365     Transfer(0x0, this, INITIAL_SUPPLY);
366   }
367 
368 }
369 
370 
371 pragma solidity ^0.4.18;
372 
373 
374 /**
375  * @title Whitelist contract
376  * @dev Participants for the presale and public sale must be 
377  * registered in the whitelist. Admins can add and remove 
378  * participants and other admins.
379  */
380 contract Whitelist is Ownable {
381     using SafeMath for uint256;
382 
383     // a boolean to check if the presale is paused
384     bool public paused = false;
385 
386     // the amount of participants in the whitelist
387     uint256 public participantAmount;
388 
389     // mapping of participants
390     mapping (address => bool) public isParticipant;
391     
392     // mapping of admins
393     mapping (address => bool) public isAdmin;
394 
395     event AddParticipant(address _participant);
396     event AddAdmin(address _admin, uint256 _timestamp);
397     event RemoveParticipant(address _participant);
398     event Paused(address _owner, uint256 _timestamp);
399     event Resumed(address _owner, uint256 _timestamp);
400   
401     /**
402     * event for claimed tokens logging
403     * @param owner where tokens are sent to
404     * @param claimtoken is the address of the ERC20 compliant token
405     * @param amount amount of tokens sent back
406     */
407     event ClaimedTokens(address indexed owner, address claimtoken, uint amount);
408   
409     /**
410      * modifier to check if the whitelist is not paused
411      */
412     modifier notPaused() {
413         require(!paused);
414         _;
415     }
416 
417     /**
418      * modifier to check the admin or owner runs this function
419      */
420     modifier onlyAdmin() {
421         require(isAdmin[msg.sender] || msg.sender == owner);
422         _;
423     }
424 
425     /**
426      * fallback function to send the eth back to the sender
427      */
428     function () payable public {
429         // give ETH back
430         msg.sender.transfer(msg.value);
431     }
432 
433     /**
434      * constructor which adds the owner in the admin list
435      */
436     function Whitelist() public {
437         require(addAdmin(msg.sender));
438     }
439 
440     /**
441      * @param _participant address of participant
442      * @return true if the _participant is in the list
443      */
444     function isParticipant(address _participant) public view returns (bool) {
445         require(address(_participant) != 0);
446         return isParticipant[_participant];
447     }
448 
449     /**
450      * @param _participant address of participant
451      * @return true if _participant is added successful
452      */
453     function addParticipant(address _participant) public notPaused onlyAdmin returns (bool) {
454         require(address(_participant) != 0);
455         require(isParticipant[_participant] == false);
456 
457         isParticipant[_participant] = true;
458         participantAmount++;
459         AddParticipant(_participant);
460         return true;
461     }
462 
463     /**
464      * @param _participant address of participant
465      * @return true if _participant is removed successful
466      */
467     function removeParticipant(address _participant) public onlyAdmin returns (bool) {
468         require(address(_participant) != 0);
469         require(isParticipant[_participant]);
470         require(msg.sender != _participant);
471 
472         delete isParticipant[_participant];
473         participantAmount--;
474         RemoveParticipant(_participant);
475         return true;
476     }
477 
478     /**
479      * @param _admin address of admin
480      * @return true if _admin is added successful
481      */
482     function addAdmin(address _admin) public onlyAdmin returns (bool) {
483         require(address(_admin) != 0);
484         require(!isAdmin[_admin]);
485 
486         isAdmin[_admin] = true;
487         AddAdmin(_admin, now);
488         return true;
489     }
490 
491     /**
492      * @param _admin address of admin
493      * @return true if _admin is removed successful
494      */
495     function removeAdmin(address _admin) public onlyAdmin returns (bool) {
496         require(address(_admin) != 0);
497         require(isAdmin[_admin]);
498         require(msg.sender != _admin);
499 
500         delete isAdmin[_admin];
501         return true;
502     }
503 
504     /**
505      * @notice Pauses the whitelist if there is any issue
506      */
507     function pauseWhitelist() public onlyAdmin returns (bool) {
508         paused = true;
509         Paused(msg.sender,now);
510         return true;
511     }
512 
513     /**
514      * @notice resumes the whitelist if there is any issue
515      */    
516     function resumeWhitelist() public onlyAdmin returns (bool) {
517         paused = false;
518         Resumed(msg.sender,now);
519         return true;
520     }
521 
522 
523     /**
524      * @notice used to save gas
525      */ 
526     function addMultipleParticipants(address[] _participants ) public onlyAdmin returns (bool) {
527         
528         for ( uint i = 0; i < _participants.length; i++ ) {
529             require(addParticipant(_participants[i]));
530         }
531 
532         return true;
533     }
534 
535     /**
536      * @notice used to save gas. Backup function.
537      */ 
538     function addFiveParticipants(address participant1, address participant2, address participant3, address participant4, address participant5) public onlyAdmin returns (bool) {
539         require(addParticipant(participant1));
540         require(addParticipant(participant2));
541         require(addParticipant(participant3));
542         require(addParticipant(participant4));
543         require(addParticipant(participant5));
544         return true;
545     }
546 
547     /**
548      * @notice used to save gas. Backup function.
549      */ 
550     function addTenParticipants(address participant1, address participant2, address participant3, address participant4, address participant5,
551      address participant6, address participant7, address participant8, address participant9, address participant10) public onlyAdmin returns (bool) 
552      {
553         require(addParticipant(participant1));
554         require(addParticipant(participant2));
555         require(addParticipant(participant3));
556         require(addParticipant(participant4));
557         require(addParticipant(participant5));
558         require(addParticipant(participant6));
559         require(addParticipant(participant7));
560         require(addParticipant(participant8));
561         require(addParticipant(participant9));
562         require(addParticipant(participant10));
563         return true;
564     }
565 
566     /**
567     * @notice This method can be used by the owner to extract mistakenly sent tokens to this contract.
568     * @param _claimtoken The address of the token contract that you want to recover
569     * set to 0 in case you want to extract ether.
570     */
571     function claimTokens(address _claimtoken) onlyAdmin public returns (bool) {
572         if (_claimtoken == 0x0) {
573             owner.transfer(this.balance);
574             return true;
575         }
576 
577         ERC20 claimtoken = ERC20(_claimtoken);
578         uint balance = claimtoken.balanceOf(this);
579         claimtoken.transfer(owner, balance);
580         ClaimedTokens(_claimtoken, owner, balance);
581         return true;
582     }
583 
584 }
585 
586 pragma solidity ^0.4.18;
587 
588 /**
589  * @title Presale
590  * @dev Presale is a base contract for managing a token presale.
591  * Presales have a start and end timestamps, where investors can make
592  * token purchases and the presale will assign them tokens based
593  * on a token per ETH rate. Funds collected are forwarded to a wallet
594  * as they arrive. Note that the presale contract
595  * must be owner of the token in order to be able to mint it.
596  */
597 contract Presale is Ownable {
598   using SafeMath for uint256;
599 
600   // token being sold
601   Identify public token;
602   // address of the token being sold
603   address public tokenAddress;
604 
605   // start and end timestamps where investments are allowed (both inclusive)
606   uint256 public startTime;
607   uint256 public endTime;
608 
609   // address where funds are forwarded
610   address public wallet;
611 
612   // whitelist contract
613   Whitelist public whitelist;
614 
615   // how many token units a buyer gets per ETH
616   uint256 public rate = 4200000;
617 
618   // amount of raised money in wei
619   uint256 public weiRaised;  
620   
621   // amount of tokens raised
622   uint256 public tokenRaised;
623 
624   // parameters for the presale:
625   // maximum of wei the presale wants to raise
626   uint256 public capWEI;
627   // maximum of tokens the presale wants to raise
628   uint256 public capTokens;
629   // bonus investors get in the presale - 25%
630   uint256 public bonusPercentage = 125;
631   // minimum amount of wei an investor needs to send in order to get tokens
632   uint256 public minimumWEI;
633   // maximum amount of wei an investor can send in order to get tokens
634   uint256 public maximumWEI;
635   // a boolean to check if the presale is paused
636   bool public paused = false;
637   // a boolean to check if the presale is finalized
638   bool public isFinalized = false;
639 
640   /**
641    * event for token purchase logging
642    * @param purchaser who paid for the tokens
643    * @param beneficiary who got the tokens
644    * @param value WEIs paid for purchase
645    * @param amount amount of tokens purchased
646    */
647   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
648   
649   /**
650    * event for claimed tokens logging
651    * @param owner where tokens are sent to
652    * @param claimtoken is the address of the ERC20 compliant token
653    * @param amount amount of tokens sent back
654    */
655   event ClaimedTokens(address indexed owner, address claimtoken, uint amount);
656   
657   /**
658    * event for pause logging
659    * @param owner who invoked the pause function
660    * @param timestamp when the pause function is invoked
661    */
662   event Paused(address indexed owner, uint256 timestamp);
663   
664   /**
665    * event for resume logging
666    * @param owner who invoked the resume function
667    * @param timestamp when the resume function is invoked
668    */
669   event Resumed(address indexed owner, uint256 timestamp);
670 
671   /**
672    * modifier to check if a participant is in the whitelist
673    */
674   modifier isInWhitelist(address beneficiary) {
675     // first check if sender is in whitelist
676     require(whitelist.isParticipant(beneficiary));
677     _;
678   }
679 
680   /**
681    * modifier to check if the presale is not paused
682    */
683   modifier whenNotPaused() {
684     require(!paused);
685     _;
686   }
687   /**
688    * modifier to check if the presale is not finalized
689    */
690   modifier whenNotFinalized() {
691     require(!isFinalized);
692     _;
693   }
694   /**
695    * modifier to check only multisigwallet can do this operation
696    */
697   modifier onlyMultisigWallet() {
698     require(msg.sender == wallet);
699     _;
700   }
701 
702 
703   /**
704    * constructor for Presale
705    * @param _startTime start timestamps where investments are allowed (inclusive)
706    * @param _wallet address where funds are forwarded
707    * @param _token address of the token being sold
708    * @param _whitelist whitelist contract address
709    * @param _capETH maximum of ETH the presale wants to raise
710    * @param _capTokens maximum amount of tokens the presale wants to raise
711    * @param _minimumETH minimum amount of ETH an investor needs to send in order to get tokens
712    * @param _maximumETH maximum amount of ETH an investor can send in order to get tokens
713    */
714   function Presale(uint256 _startTime, address _wallet, address _token, address _whitelist, uint256 _capETH, uint256 _capTokens, uint256 _minimumETH, uint256 _maximumETH) public {
715   
716     require(_startTime >= now);
717     require(_wallet != address(0));
718     require(_token != address(0));
719     require(_whitelist != address(0));
720     require(_capETH > 0);
721     require(_capTokens > 0);
722     require(_minimumETH > 0);
723     require(_maximumETH > 0);
724 
725     startTime = _startTime;
726     endTime = _startTime.add(19 weeks);
727     wallet = _wallet;
728     tokenAddress = _token;
729     token = Identify(_token);
730     whitelist = Whitelist(_whitelist);
731     capWEI = _capETH * (10 ** uint256(18));
732     capTokens = _capTokens * (10 ** uint256(6));
733     minimumWEI = _minimumETH * (10 ** uint256(18));
734     maximumWEI = _maximumETH * (10 ** uint256(18));
735   }
736 
737   /**
738    * fallback function can be used to buy tokens
739    */
740   function () external payable {
741     buyTokens(msg.sender);
742   }
743 
744   // low level token purchase function
745   function buyTokens(address beneficiary) isInWhitelist(beneficiary) whenNotPaused whenNotFinalized public payable returns (bool) {
746     require(beneficiary != address(0));
747     require(validPurchase());
748     require(!hasEnded());
749     require(!isContract(msg.sender));
750 
751     uint256 weiAmount = msg.value;
752 
753     // calculate token amount to be created
754     uint256 tokens = getTokenAmount(weiAmount);
755     require(tokenRaised.add(tokens) <= capTokens);
756     // update state
757     weiRaised = weiRaised.add(weiAmount);
758     tokenRaised = tokenRaised.add(tokens);
759 
760     require(token.transferFrom(tokenAddress, beneficiary, tokens));
761     
762     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
763 
764     forwardFunds();
765     return true;
766   }
767 
768   /**
769    * @return true if crowdsale event has ended
770    */
771   function hasEnded() public view returns (bool) {
772     bool capReached = weiRaised >= capWEI;
773     bool capTokensReached = tokenRaised >= capTokens;
774     bool ended = now > endTime;
775     return (capReached || capTokensReached) || ended;
776   }
777 
778 
779 
780   /**
781    * calculate the amount of tokens a participant gets for a specific weiAmount
782    * @return the token amount
783    */
784   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
785     // wei has 18 decimals, our token has 6 decimals -> so need for convertion
786     uint256 bonusIntegrated = weiAmount.div(10000000000000).mul(rate).mul(bonusPercentage).div(100);
787     return bonusIntegrated;
788   }
789 
790   /**
791    * send ether to the fund collection wallet
792    * @return true if successful
793    */
794   function forwardFunds() internal returns (bool) {
795     wallet.transfer(msg.value);
796     return true;
797   }
798 
799 
800   /**
801    * @return true if the transaction can buy tokens
802    */
803   function validPurchase() internal view returns (bool) {
804     bool withinPeriod = now >= startTime && now <= endTime;
805     bool nonZeroPurchase = msg.value != 0;
806     bool underMaximumWEI = msg.value <= maximumWEI;
807     bool withinCap = weiRaised.add(msg.value) <= capWEI;
808     bool minimumWEIReached;
809     // check to fill in last gap
810     if ( capWEI.sub(weiRaised) < minimumWEI) {
811       minimumWEIReached = true;
812     } else {
813       minimumWEIReached = msg.value >= minimumWEI;
814     }
815     return (withinPeriod && nonZeroPurchase) && (withinCap && (minimumWEIReached && underMaximumWEI));
816   }
817 
818   /**
819    * @dev Allows the multisigwallet to transfer control of the Identify Token to a newOwner.
820    * @param newOwner The address to transfer ownership to.
821    */
822   function transferOwnershipToken(address newOwner) onlyMultisigWallet public returns (bool) {
823     require(token.transferOwnership(newOwner));
824     return true;
825   }
826 
827    /**
828    * Overwrite method of Ownable
829    * @dev Allows the multisigwallet to transfer control of the contract to a newOwner.
830    * @param newOwner The address to transfer ownership to.
831    */
832   function transferOwnership(address newOwner) onlyMultisigWallet public returns (bool) {
833     require(newOwner != address(0));
834     owner = newOwner;
835     OwnershipTransferred(owner, newOwner);
836     return true;
837   }
838 
839    /**
840    * @dev Finalize the presale.
841    */  
842    function finalize() onlyMultisigWallet whenNotFinalized public returns (bool) {
843     require(hasEnded());
844 
845     // check if cap is reached
846     if (!(capWEI == weiRaised)) {
847       // calculate remaining tokens
848       uint256 remainingTokens = capTokens.sub(tokenRaised);
849       // burn remaining tokens
850       require(token.burn(tokenAddress, remainingTokens));    
851     }
852     require(token.transferOwnership(wallet));
853     isFinalized = true;
854     return true;
855   }
856 
857   ////////////////////////
858   /// SAFETY FUNCTIONS ///
859   ////////////////////////
860 
861   /**
862    * @dev Internal function to determine if an address is a contract
863    * @param _addr The address being queried
864    * @return True if `_addr` is a contract
865    */
866   function isContract(address _addr) constant internal returns (bool) {
867     if (_addr == 0) { 
868       return false; 
869     }
870     uint256 size;
871     assembly {
872         size := extcodesize(_addr)
873      }
874     return (size > 0);
875   }
876 
877 
878   /**
879    * @notice This method can be used by the owner to extract mistakenly sent tokens to this contract.
880    * @param _claimtoken The address of the token contract that you want to recover
881    * set to 0 in case you want to extract ether.
882    */
883   function claimTokens(address _claimtoken) onlyOwner public returns (bool) {
884     if (_claimtoken == 0x0) {
885       owner.transfer(this.balance);
886       return true;
887     }
888 
889     ERC20 claimtoken = ERC20(_claimtoken);
890     uint balance = claimtoken.balanceOf(this);
891     claimtoken.transfer(owner, balance);
892     ClaimedTokens(_claimtoken, owner, balance);
893     return true;
894   }
895 
896   /**
897    * @notice Pauses the presale if there is an issue
898    */
899   function pausePresale() onlyOwner public returns (bool) {
900     paused = true;
901     Paused(owner, now);
902     return true;
903   }
904 
905   /**
906    * @notice Resumes the presale
907    */  
908   function resumePresale() onlyOwner public returns (bool) {
909     paused = false;
910     Resumed(owner, now);
911     return true;
912   }
913 
914 
915 }