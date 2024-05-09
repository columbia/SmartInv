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
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18       // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44   /**
45     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46     * account.
47     */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53     * @dev Throws if called by any account other than the owner.
54     */
55   modifier onlyOwner() {
56     require(
57       msg.sender == owner,
58       "msg.sender is not owner"
59     );
60     _;
61   }
62 
63   /**
64   * @dev Allows the current owner to transfer control of the contract to a newOwner.
65   * @param newOwner The address to transfer ownership to.
66   */
67   function transferOwnership(address newOwner)
68     public
69     onlyOwner
70     returns (bool)
71   {
72     if (newOwner != address(0) && newOwner != owner) {
73       owner = newOwner;
74       return true;
75     } else {
76       return false;
77     }
78   }
79 }
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20Basic {
87   uint public _totalSupply;
88   function totalSupply() public view returns (uint);
89   function balanceOf(address who) public view returns (uint);
90   function transfer(address to, uint value) public;
91   event Transfer(address indexed from, address indexed to, uint value);
92 }
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(
100     address owner,
101     address spender) public view returns (uint);
102   function transferFrom(address from, address to, uint value) public;
103   function approve(address spender, uint value) public;
104   event Approval(address indexed owner, address indexed spender, uint value);
105 }
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is Ownable, ERC20Basic {
112   using SafeMath for uint;
113 
114   mapping(address => uint) public balances;
115 
116   /**
117   * @dev additional variables for use if transaction fees ever became necessary
118   */
119   uint public basisPointsRate = 0;
120   uint public maximumFee = 0;
121 
122   /**
123   * @dev Fix for the ERC20 short address attack.
124   */
125   modifier onlyPayloadSize(uint size) {
126     require(
127       !(msg.data.length < size + 4),
128       "msg.data length is wrong"
129     );
130     _;
131   }
132 
133   /**
134   * @dev transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
139     uint fee = (_value.mul(basisPointsRate)).div(10000);
140     if (fee > maximumFee) {
141       fee = maximumFee;
142     }
143     uint sendAmount = _value.sub(fee);
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(sendAmount);
146     if (fee > 0) {
147       balances[owner] = balances[owner].add(fee);
148       emit Transfer(msg.sender, owner, fee);
149     }
150     emit Transfer(msg.sender, _to, sendAmount);
151   }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint representing the amount owned by the passed address.
157     */
158   function balanceOf(address _owner) public view returns (uint balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is BasicToken, ERC20 { 
172 
173   mapping (address => mapping (address => uint)) public allowed;
174 
175   uint public constant MAX_UINT = 2**256 - 1;
176 
177   /**
178   * @dev Transfer tokens from one address to another
179   * @param _from address The address which you want to send tokens from
180   * @param _to address The address which you want to transfer to
181   * @param _value uint the amount of tokens to be transferred
182   */
183   function transferFrom(
184     address _from,
185     address _to,
186     uint
187     _value
188   )
189     public
190     onlyPayloadSize(3 * 32)
191   {
192     uint _allowance = allowed[_from][msg.sender];
193 
194     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195     // if (_value > _allowance) throw;
196 
197     uint fee = (_value.mul(basisPointsRate)).div(10000);
198     if (fee > maximumFee) {
199       fee = maximumFee;
200     }
201     if (_allowance < MAX_UINT) {
202       allowed[_from][msg.sender] = _allowance.sub(_value);
203     }
204     uint sendAmount = _value.sub(fee);
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(sendAmount);
207     if (fee > 0) {
208       balances[owner] = balances[owner].add(fee);
209       emit Transfer(_from, owner, fee);
210     }
211     emit Transfer(_from, _to, sendAmount);
212   }
213 
214   /**
215   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216   * @param _spender The address which will spend the funds.
217   * @param _value The amount of tokens to be spent.
218   */
219   function approve(
220     address _spender,
221     uint _value
222   )
223     public
224     onlyPayloadSize(2 * 32)
225   {
226     // To change the approve amount you first have to reduce the addresses`
227     //  allowance to zero by calling `approve(_spender, 0)` if it is not
228     //  already 0 to mitigate the race condition described here:
229     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230     require(
231       !((_value != 0) && (allowed[msg.sender][_spender] != 0)),
232       "Canont approve 0 as amount"
233     );
234 
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237   }
238 
239   /**
240   * @dev Function to check the amount of tokens than an owner allowed to a spender.
241   * @param _owner address The address which owns the funds.
242   * @param _spender address The address which will spend the funds.
243   * @return A uint specifying the amount of tokens still available for the spender.
244   */
245   function allowance(address _owner, address _spender)
246     public
247     view
248     returns (uint remaining) 
249   {
250     return allowed[_owner][_spender];
251   }
252 }
253 
254 /**
255  * @title Pausable
256  *
257  * @dev Base contract which allows children to implement an emergency stop mechanism.
258  */
259 contract Pausable is Ownable {
260   event Pause();
261   event Unpause();
262 
263   bool public paused = false;
264 
265 
266   /**
267    * @dev Modifier to make a function callable only when the contract is not paused.
268    */
269   modifier whenNotPaused() {
270     require(!paused, "paused is true");
271     _;
272   }
273 
274   /**
275    * @dev Modifier to make a function callable only when the contract is paused.
276    */
277   modifier whenPaused() {
278     require(paused, "paused is false");
279     _;
280   }
281 
282   /**
283    * @dev Called by the owner to pause, triggers stopped state
284    * @return Operation succeeded.
285    */
286   function pause()
287     public
288     onlyOwner
289     whenNotPaused
290     returns (bool) 
291   {
292     paused = true;
293     emit Pause();
294     return true;
295   }
296 
297   /**
298    * @dev Called by the owner to unpause, returns to normal state
299    */
300   function unpause()
301     public
302     onlyOwner
303     whenPaused
304     returns (bool)
305   {
306     paused = false;
307     emit Unpause();
308     return true;
309   }
310 }
311 
312 /**
313  * @title BlackList
314  *
315  * @dev Base contract which allows the owner to blacklist a stakeholder and destroy its tokens.
316  */
317 contract BlackList is Ownable, BasicToken {
318 
319   mapping (address => bool) public isBlackListed;
320 
321   event DestroyedBlackFunds(address _blackListedUser, uint _balance, uint _destroyed);
322   event AddedBlackList(address _user);
323   event RemovedBlackList(address _user);
324 
325   /**
326    * @dev Add address to blacklist.
327    * @param _evilUser Address to be blacklisted.
328    * @return Operation succeeded.
329    */
330   function addBlackList (address _evilUser)
331     public
332     onlyOwner
333     returns (bool)
334   {
335     isBlackListed[_evilUser] = true;
336     emit AddedBlackList(_evilUser);
337     return true;
338   }
339 
340   /**
341    * @dev Remove address from blacklist.
342    * @param _clearedUser Address to removed from blacklist.
343    * @return Operation succeeded.
344    */
345   function removeBlackList (address _clearedUser)
346     public
347     onlyOwner
348     returns (bool)
349   {
350     isBlackListed[_clearedUser] = false;
351     emit RemovedBlackList(_clearedUser);
352     return true;
353   }
354 
355   /**
356    * @dev Destroy funds of the blacklisted user.
357    * @param _blackListedUser Address of whom to destroy the funds.
358    * @param _amount Amounts of funds to be destroyed.
359    * @return Operation succeeded.
360    */
361   function destroyBlackFunds (address _blackListedUser, uint _amount)
362     public
363     onlyOwner
364     returns (bool)
365   {
366     require(isBlackListed[_blackListedUser], "User is not blacklisted");
367     require(_amount != 0, "_amount == 0");
368     require(balanceOf(_blackListedUser) - _amount >= 0, "User balance not sufficient");
369     uint leftover = balanceOf(_blackListedUser) - _amount;
370     balances[_blackListedUser] = leftover;
371     _totalSupply -= _amount;
372     emit DestroyedBlackFunds(_blackListedUser, leftover, _amount);
373     return true;
374   }
375 }
376 
377 /**
378  * @title UpgradedStandardToken
379  *
380  * @dev Interface to submit calls from the current SC to a new one.
381  */
382 contract UpgradedStandardToken is StandardToken{
383   /**
384    * @dev Methods called by the legacy contract
385    * and they must ensure msg.sender to be the contract address.
386    */
387   function transferByLegacy(address from, address to, uint value) public;
388   function transferFromByLegacy(
389     address sender,
390     address from,
391     address spender,
392     uint value) public;
393 
394   function approveByLegacy(address from, address spender, uint value) public;
395 }
396 
397 /**
398  * @title BackedToken
399  *
400  * @dev ERC20 token backed by some asset periodically audited reserve.
401  */
402 contract BackedToken is Pausable, StandardToken, BlackList {
403 
404   string public name;
405   string public symbol;
406   uint public decimals;
407   address public upgradedAddress;
408   bool public deprecated;
409 
410   // Called when new token are issued
411   event Issue(uint amount);
412   // Called when tokens are redeemed
413   event Redeem(uint amount);
414   // Called when contract is deprecated
415   event Deprecate(address newAddress);
416   // Called if contract ever adds fees
417   event Params(uint feeBasisPoints, uint maxFee);
418 
419   /**
420    * @dev Constructor.
421    * @param _initialSupply Initial total supply.
422    * @param _name Token name.
423    * @param _symbol Token symbol.
424    * @param _decimals Token decimals.
425    */
426   constructor (
427     uint _initialSupply,
428     string _name,
429     string _symbol,
430     uint _decimals
431   ) public {
432     _totalSupply = _initialSupply;
433     name = _name;
434     symbol = _symbol;
435     decimals = _decimals;
436     balances[owner] = _initialSupply;
437     deprecated = false;
438   }
439 
440   /**
441    * @dev Revert whatever no named function is called.
442    */
443   function() public payable {
444     revert("No specific function has been called");
445   }
446 
447   /**
448    * @dev ERC20 overwritten functions.
449    */
450 
451   function transfer(address _to, uint _value) public whenNotPaused {
452     require(
453       !isBlackListed[msg.sender],
454       "Transaction recipient is blacklisted"
455     );
456     if (deprecated) {
457       return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
458     } else {
459       return super.transfer(_to, _value);
460     }
461   }
462 
463   function transferFrom(
464     address _from,
465     address _to,
466     uint _value
467   )
468     public
469     whenNotPaused
470   {
471     require(!isBlackListed[_from], "Tokens owner is blacklisted");
472     if (deprecated) {
473       return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(
474         msg.sender,
475         _from,
476         _to,
477         _value
478       );
479     } else {
480       return super.transferFrom(_from, _to, _value);
481     }
482   }
483 
484   function balanceOf(address who) public view returns (uint) {
485     if (deprecated) {
486       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
487     } else {
488       return super.balanceOf(who);
489     }
490   }
491 
492   function approve(
493     address _spender,
494     uint _value
495   ) 
496     public
497     onlyPayloadSize(2 * 32)
498   {
499     if (deprecated) {
500       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
501     } else {
502       return super.approve(_spender, _value);
503     }
504   }
505 
506   function allowance(
507     address _owner,
508     address _spender
509   )
510     public
511     view
512     returns (uint remaining) 
513   {
514     if (deprecated) {
515       return StandardToken(upgradedAddress).allowance(_owner, _spender);
516     } else {
517       return super.allowance(_owner, _spender);
518     }
519   }
520 
521   function totalSupply() public view returns (uint) {
522     if (deprecated) {
523       return StandardToken(upgradedAddress).totalSupply();
524     } else {
525       return _totalSupply;
526     }
527   }
528 
529   /**
530    * @dev Issue tokens. These tokens are added to the Owner address and to the _totalSupply.
531    * @param amount Amount of the token to be issued to the owner balance adding it to the _totalSupply.
532    * @return Operation succeeded.
533    */
534   function issue(uint amount)
535     public
536     onlyOwner
537     returns (bool)
538   {
539     require(
540       _totalSupply + amount > _totalSupply,
541       "Wrong amount to be issued referring to _totalSupply"
542     );
543 
544     require(
545       balances[owner] + amount > balances[owner],
546       "Wrong amount to be issued referring to owner balance"
547     );
548 
549     balances[owner] += amount;
550     _totalSupply += amount;
551     emit Issue(amount);
552     return true;
553   }
554 
555   /**
556    * @dev Redeem tokens. These tokens are withdrawn from the Owner address.
557    * The balance must be enough to cover the redeem or the call will fail.
558    * @param amount Amount of the token to be subtracted from the _totalSupply and the Owner balance.
559    * @return Operation succeeded.
560    */
561   function redeem(uint amount)
562     public
563     onlyOwner
564     returns (bool)
565   {
566     require(
567       _totalSupply >= amount,
568       "Wrong amount to be redeemed referring to _totalSupply"
569     );
570     require(
571       balances[owner] >= amount,
572       "Wrong amount to be redeemed referring to owner balance"
573     );
574     _totalSupply -= amount;
575     balances[owner] -= amount;
576     emit Redeem(amount);
577     return true;
578   }
579 
580   /**
581    * @dev Set the current SC as deprecated.
582    * @param _upgradedAddress The new SC address to be pointed from this SC.
583    * @return Operation succeeded.
584    */
585   function deprecate(address _upgradedAddress)
586     public
587     onlyOwner
588     returns (bool)
589   {
590     deprecated = true;
591     upgradedAddress = _upgradedAddress;
592     emit Deprecate(_upgradedAddress);
593     return true;
594   }
595 
596   /**
597    * @dev Set fee params. The params has an hardcoded limit.
598    * @param newBasisPoints The maker order object.
599    * @param newMaxFee The amount of tokens going to the taker.
600    * @return Operation succeeded.
601    */
602   function setParams(
603     uint newBasisPoints,
604     uint newMaxFee
605   ) 
606     public
607     onlyOwner 
608     returns (bool) 
609   {
610     // Ensure transparency by hardcoding limit beyond which fees can never be added
611     require(
612       newBasisPoints < 20,
613       "newBasisPoints amount bigger than hardcoded limit"
614     );
615     require(
616       newMaxFee < 50,
617       "newMaxFee amount bigger than hardcoded limit"
618     );
619     basisPointsRate = newBasisPoints;
620     maximumFee = newMaxFee.mul(10**decimals);
621     emit Params(basisPointsRate, maximumFee);
622     return true;
623   }
624 
625   /**
626    * @dev Selfdestruct the contract. Callable only from the owner.
627    */
628   function kill()
629     public
630     onlyOwner 
631   {
632     selfdestruct(owner);
633   }
634 }