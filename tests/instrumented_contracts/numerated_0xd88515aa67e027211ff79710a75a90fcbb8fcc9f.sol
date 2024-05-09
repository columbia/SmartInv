1 pragma solidity ^0.4.24;
2 
3 // openzeppelin-solidity@1.12.0 from NPM
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 contract TokenWhitelist is Ownable {
68 
69     mapping(address => bool) private whitelist;
70 
71     event Whitelisted(address indexed wallet);
72     event Dewhitelisted(address indexed wallet);
73 
74     function enableWallet(address _wallet) public onlyOwner {
75         require(_wallet != address(0), "Invalid wallet");
76         whitelist[_wallet] = true;
77         emit Whitelisted(_wallet);
78     }
79 
80     function disableWallet(address _wallet) public onlyOwner {
81         whitelist[_wallet] = false;
82         emit Dewhitelisted (_wallet);
83     }
84     
85     function checkWhitelisted(address _wallet) public view returns (bool){
86         return whitelist[_wallet];
87     }
88     
89 }
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is Ownable {
96   event Pause();
97   event Unpause();
98 
99   bool public paused = false;
100 
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is not paused.
104    */
105   modifier whenNotPaused() {
106     require(!paused);
107     _;
108   }
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is paused.
112    */
113   modifier whenPaused() {
114     require(paused);
115     _;
116   }
117 
118   /**
119    * @dev called by the owner to pause, triggers stopped state
120    */
121   function pause() public onlyOwner whenNotPaused {
122     paused = true;
123     emit Pause();
124   }
125 
126   /**
127    * @dev called by the owner to unpause, returns to normal state
128    */
129   function unpause() public onlyOwner whenPaused {
130     paused = false;
131     emit Unpause();
132   }
133 }
134 
135 /**
136  * @title SafeMath
137  * @dev Math operations with safety checks that throw on error
138  */
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, throws on overflow.
143   */
144   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
145     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
146     // benefit is lost if 'b' is also tested.
147     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
148     if (_a == 0) {
149       return 0;
150     }
151 
152     c = _a * _b;
153     assert(c / _a == _b);
154     return c;
155   }
156 
157   /**
158   * @dev Integer division of two numbers, truncating the quotient.
159   */
160   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
161     // assert(_b > 0); // Solidity automatically throws when dividing by 0
162     // uint256 c = _a / _b;
163     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
164     return _a / _b;
165   }
166 
167   /**
168   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
169   */
170   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
171     assert(_b <= _a);
172     return _a - _b;
173   }
174 
175   /**
176   * @dev Adds two numbers, throws on overflow.
177   */
178   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
179     c = _a + _b;
180     assert(c >= _a);
181     return c;
182   }
183 }
184 
185 /**
186  * @title ERC20Basic
187  * @dev Simpler version of ERC20 interface
188  * See https://github.com/ethereum/EIPs/issues/179
189  */
190 contract ERC20Basic {
191   function totalSupply() public view returns (uint256);
192   function balanceOf(address _who) public view returns (uint256);
193   function transfer(address _to, uint256 _value) public returns (bool);
194   event Transfer(address indexed from, address indexed to, uint256 value);
195 }
196 
197 /**
198  * @title Basic token
199  * @dev Basic version of StandardToken, with no allowances.
200  */
201 contract BasicToken is ERC20Basic {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) internal balances;
205 
206   uint256 internal totalSupply_;
207 
208   /**
209   * @dev Total number of tokens in existence
210   */
211   function totalSupply() public view returns (uint256) {
212     return totalSupply_;
213   }
214 
215   /**
216   * @dev Transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_value <= balances[msg.sender]);
222     require(_to != address(0));
223 
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     emit Transfer(msg.sender, _to, _value);
227     return true;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public view returns (uint256) {
236     return balances[_owner];
237   }
238 
239 }
240 
241 /**
242  * @title Burnable Token
243  * @dev Token that can be irreversibly burned (destroyed).
244  */
245 contract BurnableToken is BasicToken {
246 
247   event Burn(address indexed burner, uint256 value);
248 
249   /**
250    * @dev Burns a specific amount of tokens.
251    * @param _value The amount of token to be burned.
252    */
253   function burn(uint256 _value) public {
254     _burn(msg.sender, _value);
255   }
256 
257   function _burn(address _who, uint256 _value) internal {
258     require(_value <= balances[_who]);
259     // no need to require value <= totalSupply, since that would imply the
260     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
261 
262     balances[_who] = balances[_who].sub(_value);
263     totalSupply_ = totalSupply_.sub(_value);
264     emit Burn(_who, _value);
265     emit Transfer(_who, address(0), _value);
266   }
267 }
268 
269 /**
270  * @title ERC20 interface
271  * @dev see https://github.com/ethereum/EIPs/issues/20
272  */
273 contract ERC20 is ERC20Basic {
274   function allowance(address _owner, address _spender)
275     public view returns (uint256);
276 
277   function transferFrom(address _from, address _to, uint256 _value)
278     public returns (bool);
279 
280   function approve(address _spender, uint256 _value) public returns (bool);
281   event Approval(
282     address indexed owner,
283     address indexed spender,
284     uint256 value
285   );
286 }
287 
288 /**
289  * @title Standard ERC20 token
290  *
291  * @dev Implementation of the basic standard token.
292  * https://github.com/ethereum/EIPs/issues/20
293  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
294  */
295 contract StandardToken is ERC20, BasicToken {
296 
297   mapping (address => mapping (address => uint256)) internal allowed;
298 
299 
300   /**
301    * @dev Transfer tokens from one address to another
302    * @param _from address The address which you want to send tokens from
303    * @param _to address The address which you want to transfer to
304    * @param _value uint256 the amount of tokens to be transferred
305    */
306   function transferFrom(
307     address _from,
308     address _to,
309     uint256 _value
310   )
311     public
312     returns (bool)
313   {
314     require(_value <= balances[_from]);
315     require(_value <= allowed[_from][msg.sender]);
316     require(_to != address(0));
317 
318     balances[_from] = balances[_from].sub(_value);
319     balances[_to] = balances[_to].add(_value);
320     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
321     emit Transfer(_from, _to, _value);
322     return true;
323   }
324 
325   /**
326    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
327    * Beware that changing an allowance with this method brings the risk that someone may use both the old
328    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
329    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
330    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331    * @param _spender The address which will spend the funds.
332    * @param _value The amount of tokens to be spent.
333    */
334   function approve(address _spender, uint256 _value) public returns (bool) {
335     allowed[msg.sender][_spender] = _value;
336     emit Approval(msg.sender, _spender, _value);
337     return true;
338   }
339 
340   /**
341    * @dev Function to check the amount of tokens that an owner allowed to a spender.
342    * @param _owner address The address which owns the funds.
343    * @param _spender address The address which will spend the funds.
344    * @return A uint256 specifying the amount of tokens still available for the spender.
345    */
346   function allowance(
347     address _owner,
348     address _spender
349    )
350     public
351     view
352     returns (uint256)
353   {
354     return allowed[_owner][_spender];
355   }
356 
357   /**
358    * @dev Increase the amount of tokens that an owner allowed to a spender.
359    * approve should be called when allowed[_spender] == 0. To increment
360    * allowed value is better to use this function to avoid 2 calls (and wait until
361    * the first transaction is mined)
362    * From MonolithDAO Token.sol
363    * @param _spender The address which will spend the funds.
364    * @param _addedValue The amount of tokens to increase the allowance by.
365    */
366   function increaseApproval(
367     address _spender,
368     uint256 _addedValue
369   )
370     public
371     returns (bool)
372   {
373     allowed[msg.sender][_spender] = (
374       allowed[msg.sender][_spender].add(_addedValue));
375     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
376     return true;
377   }
378 
379   /**
380    * @dev Decrease the amount of tokens that an owner allowed to a spender.
381    * approve should be called when allowed[_spender] == 0. To decrement
382    * allowed value is better to use this function to avoid 2 calls (and wait until
383    * the first transaction is mined)
384    * From MonolithDAO Token.sol
385    * @param _spender The address which will spend the funds.
386    * @param _subtractedValue The amount of tokens to decrease the allowance by.
387    */
388   function decreaseApproval(
389     address _spender,
390     uint256 _subtractedValue
391   )
392     public
393     returns (bool)
394   {
395     uint256 oldValue = allowed[msg.sender][_spender];
396     if (_subtractedValue >= oldValue) {
397       allowed[msg.sender][_spender] = 0;
398     } else {
399       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
400     }
401     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
402     return true;
403   }
404 
405 }
406 
407 /**
408  * @title Mintable token
409  * @dev Simple ERC20 Token example, with mintable token creation
410  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
411  */
412 contract MintableToken is StandardToken, Ownable {
413   event Mint(address indexed to, uint256 amount);
414   event MintFinished();
415 
416   bool public mintingFinished = false;
417 
418 
419   modifier canMint() {
420     require(!mintingFinished);
421     _;
422   }
423 
424   modifier hasMintPermission() {
425     require(msg.sender == owner);
426     _;
427   }
428 
429   /**
430    * @dev Function to mint tokens
431    * @param _to The address that will receive the minted tokens.
432    * @param _amount The amount of tokens to mint.
433    * @return A boolean that indicates if the operation was successful.
434    */
435   function mint(
436     address _to,
437     uint256 _amount
438   )
439     public
440     hasMintPermission
441     canMint
442     returns (bool)
443   {
444     totalSupply_ = totalSupply_.add(_amount);
445     balances[_to] = balances[_to].add(_amount);
446     emit Mint(_to, _amount);
447     emit Transfer(address(0), _to, _amount);
448     return true;
449   }
450 
451   /**
452    * @dev Function to stop minting new tokens.
453    * @return True if the operation was successful.
454    */
455   function finishMinting() public onlyOwner canMint returns (bool) {
456     mintingFinished = true;
457     emit MintFinished();
458     return true;
459   }
460 }
461 
462 /**
463  * @title Capped token
464  * @dev Mintable token with a token cap.
465  */
466 contract CappedToken is MintableToken {
467 
468   uint256 public cap;
469 
470   constructor(uint256 _cap) public {
471     require(_cap > 0);
472     cap = _cap;
473   }
474 
475   /**
476    * @dev Function to mint tokens
477    * @param _to The address that will receive the minted tokens.
478    * @param _amount The amount of tokens to mint.
479    * @return A boolean that indicates if the operation was successful.
480    */
481   function mint(
482     address _to,
483     uint256 _amount
484   )
485     public
486     returns (bool)
487   {
488     require(totalSupply_.add(_amount) <= cap);
489 
490     return super.mint(_to, _amount);
491   }
492 
493 }
494 
495 /**
496  * @title Pausable token
497  * @dev StandardToken modified with pausable transfers.
498  **/
499 contract PausableToken is StandardToken, Pausable {
500 
501   function transfer(
502     address _to,
503     uint256 _value
504   )
505     public
506     whenNotPaused
507     returns (bool)
508   {
509     return super.transfer(_to, _value);
510   }
511 
512   function transferFrom(
513     address _from,
514     address _to,
515     uint256 _value
516   )
517     public
518     whenNotPaused
519     returns (bool)
520   {
521     return super.transferFrom(_from, _to, _value);
522   }
523 
524   function approve(
525     address _spender,
526     uint256 _value
527   )
528     public
529     whenNotPaused
530     returns (bool)
531   {
532     return super.approve(_spender, _value);
533   }
534 
535   function increaseApproval(
536     address _spender,
537     uint _addedValue
538   )
539     public
540     whenNotPaused
541     returns (bool success)
542   {
543     return super.increaseApproval(_spender, _addedValue);
544   }
545 
546   function decreaseApproval(
547     address _spender,
548     uint _subtractedValue
549   )
550     public
551     whenNotPaused
552     returns (bool success)
553   {
554     return super.decreaseApproval(_spender, _subtractedValue);
555   }
556 }
557 
558 /**
559  * @title DetailedERC20 token
560  * @dev The decimals are only for visualization purposes.
561  * All the operations are done using the smallest and indivisible token unit,
562  * just as on Ethereum all the operations are done in wei.
563  */
564 contract DetailedERC20 is ERC20 {
565   string public name;
566   string public symbol;
567   uint8 public decimals;
568 
569   constructor(string _name, string _symbol, uint8 _decimals) public {
570     name = _name;
571     symbol = _symbol;
572     decimals = _decimals;
573   }
574 }
575 
576 contract SecurityToken is DetailedERC20, CappedToken, PausableToken {
577 
578     TokenWhitelist public whitelist;
579     event Burn(address indexed burner, uint256 value);
580 
581     constructor(uint256 _cap, string _name, string _symbol, uint8 _decimals, address _whitelist) public
582         DetailedERC20(_name, _symbol, _decimals)
583         CappedToken(_cap) {
584             setupWhitelist(_whitelist);
585     }
586 
587     /**
588     * @dev Sets up the centralized whitelist contract
589     * @param _whitelist the address of whitelist contract.
590     * @return A boolean that indicates if the operation was successful.
591     */
592     function setupWhitelist(address _whitelist) public onlyOwner returns (bool) {
593         require(_whitelist != address(0), "Invalid whitelist address");
594         whitelist = TokenWhitelist(_whitelist);
595         return true;
596     }
597 
598     /**
599     * @dev Overrides MintableToken mint() adding the whitelist validation
600     * @param _to The address that will receive the minted tokens.
601     * @param _amount The amount of tokens to mint.
602     * @return A boolean that indicates if the operation was successful.
603     */
604     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
605         require(whitelist.checkWhitelisted(_to), "User not authorized");
606         return super.mint(_to, _amount);
607     }
608 
609     /**
610     * @dev Overrides BasicToken transfer() adding the whitelist validation
611     * @param _to The address to transfer to.
612     * @param _value The amount to be transferred.
613     * @return A boolean that indicates if the operation was successful.
614     */
615     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
616         require(
617             whitelist.checkWhitelisted(msg.sender) &&
618             whitelist.checkWhitelisted(_to),
619             "User not authorized");
620         return super.transfer(_to, _value);
621     }
622 
623     /**
624      * @dev Overrides StandardToken transferFrom() adding the whitelist validation
625      * @param _from address The address which you want to send tokens from
626      * @param _to address The address which you want to transfer to
627      * @param _value uint256 the amount of tokens to be transferred
628      */
629     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
630         require(
631             whitelist.checkWhitelisted(msg.sender) &&
632             whitelist.checkWhitelisted(_from) &&
633             whitelist.checkWhitelisted(_to),
634             "User not authorized");
635         return super.transferFrom(_from, _to, _value);
636     }
637 
638     /**
639      * @dev Overrides StandardToken approve() adding the whitelist validation
640      * @param _spender The address which will spend the funds.
641      * @param _value The amount of tokens to be spent.
642      * @return A boolean that indicates if the operation was successful.
643      */
644     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
645         require(
646             whitelist.checkWhitelisted(msg.sender) &&
647             whitelist.checkWhitelisted(_spender),
648             "User not authorized");
649         return super.approve(_spender, _value);
650     }
651 
652     /**
653      * @dev Overrides StandardToken increaseApproval() adding the whitelist validation
654      * @param _spender The address which will spend the funds.
655      * @param _addedValue The amount of tokens to increase the allowance by.
656      * @return A boolean that indicates if the operation was successful.
657      */
658     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
659         require(
660             whitelist.checkWhitelisted(msg.sender) &&
661             whitelist.checkWhitelisted(_spender),
662             "User not authorized");
663         return super.increaseApproval(_spender, _addedValue);
664     }
665 
666     /**
667      * @dev Overrides StandardToken decreaseApproval() adding the whitelist validation
668      * @param _spender The address which will spend the funds.
669      * @param _subtractedValue The amount of tokens to decrease the allowance by.
670      * @return A boolean that indicates if the operation was successful.
671      */
672     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
673         require(
674             whitelist.checkWhitelisted(msg.sender) &&
675             whitelist.checkWhitelisted(_spender),
676             "User not authorized");
677         return super.decreaseApproval(_spender, _subtractedValue);
678     }
679     
680     /**
681      * @dev new function to burn tokens from a centralized owner
682      * @param _who The address which will be burned.
683      * @param _value The amount of tokens to burn.
684      * @return A boolean that indicates if the operation was successful.
685      */
686     function burnFor(address _who, uint _value) public onlyOwner returns (bool) {
687         require(_value <= balances[_who], "Insufficient funds");
688         balances[_who] = balances[_who].sub(_value);
689         totalSupply_ = totalSupply_.sub(_value);
690         emit Burn(_who, _value);
691         emit Transfer(_who, address(0), _value);
692         return true;
693     }
694 
695 }