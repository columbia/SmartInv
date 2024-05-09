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
321   event DestroyedBlackFunds(address _blackListedUser, uint _balance);
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
358    * @return Operation succeeded.
359    */
360   function destroyBlackFunds (address _blackListedUser)
361     public
362     onlyOwner
363     returns (bool)
364   {
365     require(isBlackListed[_blackListedUser], "User is not blacklisted");
366     uint dirtyFunds = balanceOf(_blackListedUser);
367     balances[_blackListedUser] = 0;
368     _totalSupply -= dirtyFunds;
369     emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
370     return true;
371   }
372 }
373 
374 /**
375  * @title UpgradedStandardToken
376  *
377  * @dev Interface to submit calls from the current SC to a new one.
378  */
379 contract UpgradedStandardToken is StandardToken{
380   /**
381    * @dev Methods called by the legacy contract
382    * and they must ensure msg.sender to be the contract address.
383    */
384   function transferByLegacy(address from, address to, uint value) public;
385   function transferFromByLegacy(
386     address sender,
387     address from,
388     address spender,
389     uint value) public;
390 
391   function approveByLegacy(address from, address spender, uint value) public;
392 }
393 
394 /**
395  * @title BackedToken
396  *
397  * @dev ERC20 token backed by some asset periodically audited reserve.
398  */
399 contract BackedToken is Pausable, StandardToken, BlackList {
400 
401   string public name;
402   string public symbol;
403   uint public decimals;
404   address public upgradedAddress;
405   bool public deprecated;
406 
407   // Called when new token are issued
408   event Issue(uint amount);
409   // Called when tokens are redeemed
410   event Redeem(uint amount);
411   // Called when contract is deprecated
412   event Deprecate(address newAddress);
413   // Called if contract ever adds fees
414   event Params(uint feeBasisPoints, uint maxFee);
415 
416   /**
417    * @dev Constructor.
418    * @param _initialSupply Initial total supply.
419    * @param _name Token name.
420    * @param _symbol Token symbol.
421    * @param _decimals Token decimals.
422    */
423   constructor (
424     uint _initialSupply,
425     string _name,
426     string _symbol,
427     uint _decimals
428   ) public {
429     _totalSupply = _initialSupply;
430     name = _name;
431     symbol = _symbol;
432     decimals = _decimals;
433     balances[owner] = _initialSupply;
434     deprecated = false;
435   }
436 
437   /**
438    * @dev Revert whatever no named function is called.
439    */
440   function() public payable {
441     revert("No specific function has been called");
442   }
443 
444   /**
445    * @dev ERC20 overwritten functions.
446    */
447 
448   function transfer(address _to, uint _value) public whenNotPaused {
449     require(
450       !isBlackListed[msg.sender],
451       "Transaction recipient is blacklisted"
452     );
453     if (deprecated) {
454       return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
455     } else {
456       return super.transfer(_to, _value);
457     }
458   }
459 
460   function transferFrom(
461     address _from,
462     address _to,
463     uint _value
464   )
465     public
466     whenNotPaused
467   {
468     require(!isBlackListed[_from], "Tokens owner is blacklisted");
469     if (deprecated) {
470       return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(
471         msg.sender,
472         _from,
473         _to,
474         _value
475       );
476     } else {
477       return super.transferFrom(_from, _to, _value);
478     }
479   }
480 
481   function balanceOf(address who) public view returns (uint) {
482     if (deprecated) {
483       return UpgradedStandardToken(upgradedAddress).balanceOf(who);
484     } else {
485       return super.balanceOf(who);
486     }
487   }
488 
489   function approve(
490     address _spender,
491     uint _value
492   ) 
493     public
494     onlyPayloadSize(2 * 32)
495   {
496     if (deprecated) {
497       return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
498     } else {
499       return super.approve(_spender, _value);
500     }
501   }
502 
503   function allowance(
504     address _owner,
505     address _spender
506   )
507     public
508     view
509     returns (uint remaining) 
510   {
511     if (deprecated) {
512       return StandardToken(upgradedAddress).allowance(_owner, _spender);
513     } else {
514       return super.allowance(_owner, _spender);
515     }
516   }
517 
518   function totalSupply() public view returns (uint) {
519     if (deprecated) {
520       return StandardToken(upgradedAddress).totalSupply();
521     } else {
522       return _totalSupply;
523     }
524   }
525 
526   /**
527    * @dev Issue tokens. These tokens are added to the Owner address and to the _totalSupply.
528    * @param amount Amount of the token to be issued to the owner balance adding it to the _totalSupply.
529    * @return Operation succeeded.
530    */
531   function issue(uint amount)
532     public
533     onlyOwner
534     returns (bool)
535   {
536     require(
537       _totalSupply + amount > _totalSupply,
538       "Wrong amount to be issued referring to _totalSupply"
539     );
540 
541     require(
542       balances[owner] + amount > balances[owner],
543       "Wrong amount to be issued referring to owner balance"
544     );
545 
546     balances[owner] += amount;
547     _totalSupply += amount;
548     emit Issue(amount);
549     return true;
550   }
551 
552   /**
553    * @dev Redeem tokens. These tokens are withdrawn from the Owner address.
554    * The balance must be enough to cover the redeem or the call will fail.
555    * @param amount Amount of the token to be subtracted from the _totalSupply and the Owner balance.
556    * @return Operation succeeded.
557    */
558   function redeem(uint amount)
559     public
560     onlyOwner
561     returns (bool)
562   {
563     require(
564       _totalSupply >= amount,
565       "Wrong amount to be redeemed referring to _totalSupply"
566     );
567     require(
568       balances[owner] >= amount,
569       "Wrong amount to be redeemed referring to owner balance"
570     );
571     _totalSupply -= amount;
572     balances[owner] -= amount;
573     emit Redeem(amount);
574     return true;
575   }
576 
577   /**
578    * @dev Set the current SC as deprecated.
579    * @param _upgradedAddress The new SC address to be pointed from this SC.
580    * @return Operation succeeded.
581    */
582   function deprecate(address _upgradedAddress)
583     public
584     onlyOwner
585     returns (bool)
586   {
587     deprecated = true;
588     upgradedAddress = _upgradedAddress;
589     emit Deprecate(_upgradedAddress);
590     return true;
591   }
592 
593   /**
594    * @dev Set fee params. The params has an hardcoded limit.
595    * @param newBasisPoints The maker order object.
596    * @param newMaxFee The amount of tokens going to the taker.
597    * @return Operation succeeded.
598    */
599   function setParams(
600     uint newBasisPoints,
601     uint newMaxFee
602   ) 
603     public
604     onlyOwner 
605     returns (bool) 
606   {
607     // Ensure transparency by hardcoding limit beyond which fees can never be added
608     require(
609       newBasisPoints < 20,
610       "newBasisPoints amount bigger than hardcoded limit"
611     );
612     require(
613       newMaxFee < 50,
614       "newMaxFee amount bigger than hardcoded limit"
615     );
616     basisPointsRate = newBasisPoints;
617     maximumFee = newMaxFee.mul(10**decimals);
618     emit Params(basisPointsRate, maximumFee);
619     return true;
620   }
621 
622   /**
623    * @dev Selfdestruct the contract. Callable only from the owner.
624    */
625   function kill()
626     public
627     onlyOwner 
628   {
629     selfdestruct(owner);
630   }
631 }