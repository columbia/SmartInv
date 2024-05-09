1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12 
13     uint256 c = a * b;
14     require(c / a == b);
15 
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b > 0);
21     uint256 c = a / b;
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b <= a);
27     uint256 c = a - b;
28     return c;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     require(c >= a);
34     return c;
35   }
36 
37   /**
38   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
39   * reverts when dividing by zero.
40   */
41   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b != 0);
43     return a % b;
44   }
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53   address public owner;
54 
55   /**
56     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57     * account.
58     */
59   constructor() public {
60     owner = msg.sender;
61   }
62 
63   /**
64     * @dev Throws if called by any account other than the owner.
65     */
66   modifier onlyOwner() {
67     require(
68       msg.sender == owner,
69       "msg.sender is not owner"
70     );
71     _;
72   }
73 
74   /**
75   * @dev Allows the current owner to transfer control of the contract to a newOwner.
76   * @param newOwner The address to transfer ownership to.
77   */
78   function transferOwnership(address newOwner)
79     public
80     onlyOwner
81     returns (bool)
82   {
83     if (newOwner != address(0) && newOwner != owner) {
84       owner = newOwner;
85       return true;
86     } else {
87       return false;
88     }
89   }
90 }
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20Basic {
98   uint public _totalSupply;
99   function totalSupply() public view returns (uint);
100   function balanceOf(address who) public view returns (uint);
101   function transfer(address to, uint value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint value);
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(
111     address owner,
112     address spender) public view returns (uint);
113   function transferFrom(
114     address from,
115     address to,
116     uint value
117   )
118     public returns (bool);
119   function approve(address spender, uint value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint value);
121 }
122 
123 /**
124  * @title WhiteList
125  * @dev All the addresses whitelisted will not pay the fee for transfer and transferFrom.
126  */
127 
128 contract WhiteList is Ownable {
129   mapping(address => bool) public whitelist;
130 
131   function addToWhitelist (address _address) public onlyOwner returns (bool) {
132     whitelist[_address] = true;
133     return true;
134   }
135 
136   function removeFromWhitelist (address _address)
137     public onlyOwner returns (bool) 
138   {
139     whitelist[_address] = false;
140     return true;
141   }
142 }
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is WhiteList, ERC20Basic {
149   using SafeMath for uint;
150 
151   mapping(address => uint) public balances;
152 
153   /**
154   * @dev additional variables for use if transaction fees ever became necessary
155   */
156   uint public basisPointsRate = 0;
157   uint public maximumFee = 0;
158 
159   /**
160   * @dev Fix for the ERC20 short address attack.
161   */
162   modifier onlyPayloadSize(uint size) {
163     require(
164       !(msg.data.length < size + 4),
165       "msg.data length is wrong"
166     );
167     _;
168   }
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint _value)
176     public
177     onlyPayloadSize(2 * 32)
178     returns (bool)
179   {
180     uint fee = whitelist[msg.sender]
181       ? 0
182       : (_value.mul(basisPointsRate)).div(10000);
183 
184     if (fee > maximumFee) {
185       fee = maximumFee;
186     }
187     uint sendAmount = _value.sub(fee);
188     balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(sendAmount);
190     if (fee > 0) {
191       balances[owner] = balances[owner].add(fee);
192       emit Transfer(msg.sender, owner, fee);
193       return true;
194     }
195     emit Transfer(msg.sender, _to, sendAmount);
196     return true;
197   }
198 
199     /**
200     * @dev Gets the balance of the specified address.
201     * @param _owner The address to query the the balance of.
202     * @return An uint representing the amount owned by the passed address.
203     */
204   function balanceOf(address _owner) public view returns (uint balance) {
205     return balances[_owner];
206   }
207 
208 }
209 
210 /**
211  * @title Standard ERC20 token
212  *
213  * @dev Implementation of the basic standard token.
214  * @dev https://github.com/ethereum/EIPs/issues/20
215  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
216  */
217 contract StandardToken is BasicToken, ERC20 { 
218 
219   mapping (address => mapping (address => uint)) public allowed;
220 
221   uint public constant MAX_UINT = 2**256 - 1;
222 
223   /**
224   * @dev Transfer tokens from one address to another
225   * @param _from address The address which you want to send tokens from
226   * @param _to address The address which you want to transfer to
227   * @param _value uint the amount of tokens to be transferred
228   */
229   function transferFrom(
230     address _from,
231     address _to,
232     uint
233     _value
234   )
235     public
236     onlyPayloadSize(3 * 32)
237     returns (bool)
238   {
239     uint _allowance = allowed[_from][msg.sender];
240 
241     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
242     // if (_value > _allowance) throw;
243 
244     uint fee = whitelist[msg.sender]
245       ? 0
246       : (_value.mul(basisPointsRate)).div(10000);
247     if (fee > maximumFee) {
248       fee = maximumFee;
249     }
250     if (_allowance < MAX_UINT) {
251       allowed[_from][msg.sender] = _allowance.sub(_value);
252     }
253     uint sendAmount = _value.sub(fee);
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(sendAmount);
256     if (fee > 0) {
257       balances[owner] = balances[owner].add(fee);
258       emit Transfer(_from, owner, fee);
259       return true;
260     }
261     emit Transfer(_from, _to, sendAmount);
262     return true;
263   }
264 
265   /**
266   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
267   * @param _spender The address which will spend the funds.
268   * @param _value The amount of tokens to be spent.
269   */
270   function approve(
271     address _spender,
272     uint _value
273   )
274     public
275     onlyPayloadSize(2 * 32)
276     returns (bool)
277   {
278     // To change the approve amount you first have to reduce the addresses`
279     //  allowance to zero by calling `approve(_spender, 0)` if it is not
280     //  already 0 to mitigate the race condition described here:
281     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282     require(
283       !((_value != 0) && (allowed[msg.sender][_spender] != 0)),
284       "Canont approve 0 as amount"
285     );
286 
287     allowed[msg.sender][_spender] = _value;
288     emit Approval(msg.sender, _spender, _value);
289     return true;
290   }
291 
292   /**
293   * @dev Function to check the amount of tokens than an owner allowed to a spender.
294   * @param _owner address The address which owns the funds.
295   * @param _spender address The address which will spend the funds.
296   * @return A uint specifying the amount of tokens still available for the spender.
297   */
298   function allowance(address _owner, address _spender)
299     public
300     view
301     returns (uint remaining) 
302   {
303     return allowed[_owner][_spender];
304   }
305 }
306 
307 /**
308  * @title Pausable
309  *
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Ownable {
313   event Pause();
314   event Unpause();
315 
316   bool public paused = false;
317 
318 
319   /**
320    * @dev Modifier to make a function callable only when the contract is not paused.
321    */
322   modifier whenNotPaused() {
323     require(!paused, "paused is true");
324     _;
325   }
326 
327   /**
328    * @dev Modifier to make a function callable only when the contract is paused.
329    */
330   modifier whenPaused() {
331     require(paused, "paused is false");
332     _;
333   }
334 
335   /**
336    * @dev Called by the owner to pause, triggers stopped state
337    * @return Operation succeeded.
338    */
339   function pause()
340     public
341     onlyOwner
342     whenNotPaused
343     returns (bool) 
344   {
345     paused = true;
346     emit Pause();
347     return true;
348   }
349 
350   /**
351    * @dev Called by the owner to unpause, returns to normal state
352    */
353   function unpause()
354     public
355     onlyOwner
356     whenPaused
357     returns (bool)
358   {
359     paused = false;
360     emit Unpause();
361     return true;
362   }
363 }
364 
365 /**
366  * @title BlackList
367  *
368  * @dev Base contract which allows the owner to blacklist a stakeholder and destroy its tokens.
369  */
370 contract BlackList is Ownable, BasicToken {
371 
372   mapping (address => bool) public isBlackListed;
373 
374   event DestroyedBlackFunds(address _blackListedUser, uint _balance);
375   event AddedBlackList(address _user);
376   event RemovedBlackList(address _user);
377 
378   /**
379    * @dev Add address to blacklist.
380    * @param _evilUser Address to be blacklisted.
381    * @return Operation succeeded.
382    */
383   function addBlackList (address _evilUser)
384     public
385     onlyOwner
386     returns (bool)
387   {
388     isBlackListed[_evilUser] = true;
389     emit AddedBlackList(_evilUser);
390     return true;
391   }
392 
393   /**
394    * @dev Remove address from blacklist.
395    * @param _clearedUser Address to removed from blacklist.
396    * @return Operation succeeded.
397    */
398   function removeBlackList (address _clearedUser)
399     public
400     onlyOwner
401     returns (bool)
402   {
403     isBlackListed[_clearedUser] = false;
404     emit RemovedBlackList(_clearedUser);
405     return true;
406   }
407 
408   /**
409    * @dev Destroy funds of the blacklisted user.
410    * @param _blackListedUser Address of whom to destroy the funds.
411    * @return Operation succeeded.
412    */
413   function destroyBlackFunds (address _blackListedUser)
414     public
415     onlyOwner
416     returns (bool)
417   {
418     require(isBlackListed[_blackListedUser], "User is not blacklisted");
419     uint dirtyFunds = balanceOf(_blackListedUser);
420     balances[_blackListedUser] = 0;
421     _totalSupply -= dirtyFunds;
422     emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
423     return true;
424   }
425 }
426 
427 /**
428  * @title UpgradedStandardToken
429  *
430  * @dev Interface to submit calls from the current SC to a new one.
431  */
432 contract UpgradedStandardToken is StandardToken{
433   /**
434    * @dev Methods called by the legacy contract
435    * and they must ensure msg.sender to be the contract address.
436    */
437   function transferByLegacy(
438     address from,
439     address to,
440     uint value) public returns (bool);
441   function transferFromByLegacy(
442     address sender,
443     address from,
444     address spender,
445     uint value) public returns (bool);
446 
447   function approveByLegacy(
448     address from,
449     address spender,
450     uint value) public returns (bool);
451 }
452 
453 /**
454  * @title BackedToken
455  *
456  * @dev ERC20 token backed by some asset periodically audited reserve.
457  */
458 contract BackedToken is Pausable, StandardToken, BlackList {
459 
460   string public name;
461   string public symbol;
462   uint public decimals;
463   address public upgradedAddress;
464   bool public deprecated;
465 
466   // Called when new token are issued
467   event Issue(uint amount);
468   // Called when tokens are redeemed
469   event Redeem(uint amount);
470   // Called when contract is deprecated
471   event Deprecate(address newAddress);
472   // Called if contract ever adds fees
473   event Params(uint feeBasisPoints, uint maxFee);
474 
475   /**
476    * @dev Constructor.
477    * @param _initialSupply Initial total supply.
478    * @param _name Token name.
479    * @param _symbol Token symbol.
480    * @param _decimals Token decimals.
481    */
482   constructor (
483     uint _initialSupply,
484     string _name,
485     string _symbol,
486     uint _decimals
487   ) public {
488     _totalSupply = _initialSupply;
489     name = _name;
490     symbol = _symbol;
491     decimals = _decimals;
492     balances[owner] = _initialSupply;
493     deprecated = false;
494   }
495 
496   /**
497    * @dev Revert whatever no named function is called.
498    */
499   function() public payable {
500     revert("No specific function has been called");
501   }
502 
503   /**
504    * @dev ERC20 overwritten functions.
505    */
506 
507   function transfer(address _to, uint _value)
508     public whenNotPaused returns (bool) 
509   {
510     require(
511       !isBlackListed[msg.sender],
512       "Transaction recipient is blacklisted"
513     );
514     if (deprecated) {
515       return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
516     } else {
517       return super.transfer(_to, _value);
518     }
519   }
520 
521   function transferFrom(
522     address _from,
523     address _to,
524     uint _value
525   )
526     public
527     whenNotPaused
528     returns (bool)
529   {
530     require(!isBlackListed[_from], "Tokens owner is blacklisted");
531     if (deprecated) {
532       return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(
533         msg.sender,
534         _from,
535         _to,
536         _value
537       );
538     } else {
539       return super.transferFrom(_from, _to, _value);
540     }
541   }
542 
543   function balanceOf(address who) public view returns (uint) {
544     if (deprecated) {
545       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
546     } else {
547       return super.balanceOf(who);
548     }
549   }
550 
551   function approve(
552     address _spender,
553     uint _value
554   ) 
555     public
556     onlyPayloadSize(2 * 32)
557     returns (bool)
558   {
559     if (deprecated) {
560       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
561     } else {
562       return super.approve(_spender, _value);
563     }
564   }
565 
566   function allowance(
567     address _owner,
568     address _spender
569   )
570     public
571     view
572     returns (uint remaining) 
573   {
574     if (deprecated) {
575       return StandardToken(upgradedAddress).allowance(_owner, _spender);
576     } else {
577       return super.allowance(_owner, _spender);
578     }
579   }
580 
581   function totalSupply() public view returns (uint) {
582     if (deprecated) {
583       return StandardToken(upgradedAddress).totalSupply();
584     } else {
585       return _totalSupply;
586     }
587   }
588 
589   /**
590    * @dev Issue tokens. These tokens are added to the Owner address and to the _totalSupply.
591    * @param amount Amount of the token to be issued to the owner balance adding it to the _totalSupply.
592    * @return Operation succeeded.
593    */
594   function issue(uint amount)
595     public
596     onlyOwner
597     returns (bool)
598   {
599     require(
600       _totalSupply + amount > _totalSupply,
601       "Wrong amount to be issued referring to _totalSupply"
602     );
603 
604     require(
605       balances[owner] + amount > balances[owner],
606       "Wrong amount to be issued referring to owner balance"
607     );
608 
609     balances[owner] += amount;
610     _totalSupply += amount;
611     emit Issue(amount);
612     return true;
613   }
614 
615   /**
616    * @dev Redeem tokens. These tokens are withdrawn from the Owner address.
617    * The balance must be enough to cover the redeem or the call will fail.
618    * @param amount Amount of the token to be subtracted from the _totalSupply and the Owner balance.
619    * @return Operation succeeded.
620    */
621   function redeem(uint amount)
622     public
623     onlyOwner
624     returns (bool)
625   {
626     require(
627       _totalSupply >= amount,
628       "Wrong amount to be redeemed referring to _totalSupply"
629     );
630     require(
631       balances[owner] >= amount,
632       "Wrong amount to be redeemed referring to owner balance"
633     );
634     _totalSupply -= amount;
635     balances[owner] -= amount;
636     emit Redeem(amount);
637     return true;
638   }
639 
640   /**
641    * @dev Set the current SC as deprecated.
642    * @param _upgradedAddress The new SC address to be pointed from this SC.
643    * @return Operation succeeded.
644    */
645   function deprecate(address _upgradedAddress)
646     public
647     onlyOwner
648     returns (bool)
649   {
650     deprecated = true;
651     upgradedAddress = _upgradedAddress;
652     emit Deprecate(_upgradedAddress);
653     return true;
654   }
655 
656   /**
657    * @dev Set fee params. The params has an hardcoded limit.
658    * @param newBasisPoints The maker order object.
659    * @param newMaxFee The amount of tokens going to the taker.
660    * @return Operation succeeded.
661    */
662   function setParams(
663     uint newBasisPoints,
664     uint newMaxFee
665   ) 
666     public
667     onlyOwner 
668     returns (bool) 
669   {
670     // Ensure transparency by hardcoding limit beyond which fees can never be added
671     require(
672       newBasisPoints < 20,
673       "newBasisPoints amount bigger than hardcoded limit"
674     );
675     require(
676       newMaxFee < 50,
677       "newMaxFee amount bigger than hardcoded limit"
678     );
679     basisPointsRate = newBasisPoints;
680     maximumFee = newMaxFee.mul(10**decimals);
681     emit Params(basisPointsRate, maximumFee);
682     return true;
683   }
684 
685   /**
686    * @dev Selfdestruct the contract. Callable only from the owner.
687    */
688   function kill()
689     public
690     onlyOwner 
691   {
692     selfdestruct(owner);
693   }
694 }