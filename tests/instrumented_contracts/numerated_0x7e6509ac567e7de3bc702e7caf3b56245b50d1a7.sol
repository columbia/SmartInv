1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract Pausable is Ownable {
104   event Pause();
105   event Unpause();
106 
107   bool public paused = false;
108 
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is not paused.
112    */
113   modifier whenNotPaused() {
114     require(!paused);
115     _;
116   }
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is paused.
120    */
121   modifier whenPaused() {
122     require(paused);
123     _;
124   }
125 
126   /**
127    * @dev called by the owner to pause, triggers stopped state
128    */
129   function pause() onlyOwner whenNotPaused public {
130     paused = true;
131     emit Pause();
132   }
133 
134   /**
135    * @dev called by the owner to unpause, returns to normal state
136    */
137   function unpause() onlyOwner whenPaused public {
138     paused = false;
139     emit Unpause();
140   }
141 }
142 
143 contract CanReclaimToken is Ownable {
144   using SafeERC20 for ERC20Basic;
145 
146   /**
147    * @dev Reclaim all ERC20Basic compatible tokens
148    * @param token ERC20Basic The address of the token contract
149    */
150   function reclaimToken(ERC20Basic token) external onlyOwner {
151     uint256 balance = token.balanceOf(this);
152     token.safeTransfer(owner, balance);
153   }
154 
155 }
156 
157 contract HasNoEther is Ownable {
158 
159   /**
160   * @dev Constructor that rejects incoming Ether
161   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
162   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
163   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
164   * we could use assembly to access msg.value.
165   */
166   constructor() public payable {
167     require(msg.value == 0);
168   }
169 
170   /**
171    * @dev Disallows direct send by settings a default function without the `payable` flag.
172    */
173   function() external {
174   }
175 
176   /**
177    * @dev Transfer all Ether held by the contract to the owner.
178    */
179   function reclaimEther() external onlyOwner {
180     owner.transfer(address(this).balance);
181   }
182 }
183 
184 contract HasNoTokens is CanReclaimToken {
185 
186  /**
187   * @dev Reject all ERC223 compatible tokens
188   * @param from_ address The address that is transferring the tokens
189   * @param value_ uint256 the amount of the specified token
190   * @param data_ Bytes The data passed from the caller.
191   */
192   function tokenFallback(address from_, uint256 value_, bytes data_) external {
193     from_;
194     value_;
195     data_;
196     revert();
197   }
198 
199 }
200 
201 contract ERC20Basic {
202   function totalSupply() public view returns (uint256);
203   function balanceOf(address who) public view returns (uint256);
204   function transfer(address to, uint256 value) public returns (bool);
205   event Transfer(address indexed from, address indexed to, uint256 value);
206 }
207 
208 contract BasicToken is ERC20Basic {
209   using SafeMath for uint256;
210 
211   mapping(address => uint256) balances;
212 
213   uint256 totalSupply_;
214 
215   /**
216   * @dev total number of tokens in existence
217   */
218   function totalSupply() public view returns (uint256) {
219     return totalSupply_;
220   }
221 
222   /**
223   * @dev transfer token for a specified address
224   * @param _to The address to transfer to.
225   * @param _value The amount to be transferred.
226   */
227   function transfer(address _to, uint256 _value) public returns (bool) {
228     require(_to != address(0));
229     require(_value <= balances[msg.sender]);
230 
231     balances[msg.sender] = balances[msg.sender].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     emit Transfer(msg.sender, _to, _value);
234     return true;
235   }
236 
237   /**
238   * @dev Gets the balance of the specified address.
239   * @param _owner The address to query the the balance of.
240   * @return An uint256 representing the amount owned by the passed address.
241   */
242   function balanceOf(address _owner) public view returns (uint256) {
243     return balances[_owner];
244   }
245 
246 }
247 
248 contract ERC20 is ERC20Basic {
249   function allowance(address owner, address spender)
250     public view returns (uint256);
251 
252   function transferFrom(address from, address to, uint256 value)
253     public returns (bool);
254 
255   function approve(address spender, uint256 value) public returns (bool);
256   event Approval(
257     address indexed owner,
258     address indexed spender,
259     uint256 value
260   );
261 }
262 
263 contract DetailedERC20 is ERC20 {
264   string public name;
265   string public symbol;
266   uint8 public decimals;
267 
268   constructor(string _name, string _symbol, uint8 _decimals) public {
269     name = _name;
270     symbol = _symbol;
271     decimals = _decimals;
272   }
273 }
274 
275 library SafeERC20 {
276   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
277     require(token.transfer(to, value));
278   }
279 
280   function safeTransferFrom(
281     ERC20 token,
282     address from,
283     address to,
284     uint256 value
285   )
286     internal
287   {
288     require(token.transferFrom(from, to, value));
289   }
290 
291   function safeApprove(ERC20 token, address spender, uint256 value) internal {
292     require(token.approve(spender, value));
293   }
294 }
295 
296 contract StandardToken is ERC20, BasicToken {
297 
298   mapping (address => mapping (address => uint256)) internal allowed;
299 
300 
301   /**
302    * @dev Transfer tokens from one address to another
303    * @param _from address The address which you want to send tokens from
304    * @param _to address The address which you want to transfer to
305    * @param _value uint256 the amount of tokens to be transferred
306    */
307   function transferFrom(
308     address _from,
309     address _to,
310     uint256 _value
311   )
312     public
313     returns (bool)
314   {
315     require(_to != address(0));
316     require(_value <= balances[_from]);
317     require(_value <= allowed[_from][msg.sender]);
318 
319     balances[_from] = balances[_from].sub(_value);
320     balances[_to] = balances[_to].add(_value);
321     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
322     emit Transfer(_from, _to, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328    *
329    * Beware that changing an allowance with this method brings the risk that someone may use both the old
330    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     allowed[msg.sender][_spender] = _value;
338     emit Approval(msg.sender, _spender, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Function to check the amount of tokens that an owner allowed to a spender.
344    * @param _owner address The address which owns the funds.
345    * @param _spender address The address which will spend the funds.
346    * @return A uint256 specifying the amount of tokens still available for the spender.
347    */
348   function allowance(
349     address _owner,
350     address _spender
351    )
352     public
353     view
354     returns (uint256)
355   {
356     return allowed[_owner][_spender];
357   }
358 
359   /**
360    * @dev Increase the amount of tokens that an owner allowed to a spender.
361    *
362    * approve should be called when allowed[_spender] == 0. To increment
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    * @param _spender The address which will spend the funds.
367    * @param _addedValue The amount of tokens to increase the allowance by.
368    */
369   function increaseApproval(
370     address _spender,
371     uint _addedValue
372   )
373     public
374     returns (bool)
375   {
376     allowed[msg.sender][_spender] = (
377       allowed[msg.sender][_spender].add(_addedValue));
378     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379     return true;
380   }
381 
382   /**
383    * @dev Decrease the amount of tokens that an owner allowed to a spender.
384    *
385    * approve should be called when allowed[_spender] == 0. To decrement
386    * allowed value is better to use this function to avoid 2 calls (and wait until
387    * the first transaction is mined)
388    * From MonolithDAO Token.sol
389    * @param _spender The address which will spend the funds.
390    * @param _subtractedValue The amount of tokens to decrease the allowance by.
391    */
392   function decreaseApproval(
393     address _spender,
394     uint _subtractedValue
395   )
396     public
397     returns (bool)
398   {
399     uint oldValue = allowed[msg.sender][_spender];
400     if (_subtractedValue > oldValue) {
401       allowed[msg.sender][_spender] = 0;
402     } else {
403       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
404     }
405     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
406     return true;
407   }
408 
409 }
410 
411 contract MintableToken is StandardToken, Ownable {
412   event Mint(address indexed to, uint256 amount);
413   event MintFinished();
414 
415   bool public mintingFinished = false;
416 
417 
418   modifier canMint() {
419     require(!mintingFinished);
420     _;
421   }
422 
423   modifier hasMintPermission() {
424     require(msg.sender == owner);
425     _;
426   }
427 
428   /**
429    * @dev Function to mint tokens
430    * @param _to The address that will receive the minted tokens.
431    * @param _amount The amount of tokens to mint.
432    * @return A boolean that indicates if the operation was successful.
433    */
434   function mint(
435     address _to,
436     uint256 _amount
437   )
438     hasMintPermission
439     canMint
440     public
441     returns (bool)
442   {
443     totalSupply_ = totalSupply_.add(_amount);
444     balances[_to] = balances[_to].add(_amount);
445     emit Mint(_to, _amount);
446     emit Transfer(address(0), _to, _amount);
447     return true;
448   }
449 
450   /**
451    * @dev Function to stop minting new tokens.
452    * @return True if the operation was successful.
453    */
454   function finishMinting() onlyOwner canMint public returns (bool) {
455     mintingFinished = true;
456     emit MintFinished();
457     return true;
458   }
459 }
460 
461 contract CappedToken is MintableToken {
462 
463   uint256 public cap;
464 
465   constructor(uint256 _cap) public {
466     require(_cap > 0);
467     cap = _cap;
468   }
469 
470   /**
471    * @dev Function to mint tokens
472    * @param _to The address that will receive the minted tokens.
473    * @param _amount The amount of tokens to mint.
474    * @return A boolean that indicates if the operation was successful.
475    */
476   function mint(
477     address _to,
478     uint256 _amount
479   )
480     onlyOwner
481     canMint
482     public
483     returns (bool)
484   {
485     require(totalSupply_.add(_amount) <= cap);
486 
487     return super.mint(_to, _amount);
488   }
489 
490 }
491 
492 contract PausableToken is StandardToken, Pausable {
493 
494   function transfer(
495     address _to,
496     uint256 _value
497   )
498     public
499     whenNotPaused
500     returns (bool)
501   {
502     return super.transfer(_to, _value);
503   }
504 
505   function transferFrom(
506     address _from,
507     address _to,
508     uint256 _value
509   )
510     public
511     whenNotPaused
512     returns (bool)
513   {
514     return super.transferFrom(_from, _to, _value);
515   }
516 
517   function approve(
518     address _spender,
519     uint256 _value
520   )
521     public
522     whenNotPaused
523     returns (bool)
524   {
525     return super.approve(_spender, _value);
526   }
527 
528   function increaseApproval(
529     address _spender,
530     uint _addedValue
531   )
532     public
533     whenNotPaused
534     returns (bool success)
535   {
536     return super.increaseApproval(_spender, _addedValue);
537   }
538 
539   function decreaseApproval(
540     address _spender,
541     uint _subtractedValue
542   )
543     public
544     whenNotPaused
545     returns (bool success)
546   {
547     return super.decreaseApproval(_spender, _subtractedValue);
548   }
549 }
550 
551 contract SwaceToken is
552   DetailedERC20,
553   PausableToken,
554   CappedToken,
555   HasNoTokens,
556   HasNoEther
557 {
558   event Finalize(uint256 value);
559   event ChangeVestingAgent(address indexed oldVestingAgent, address indexed newVestingAgent);
560 
561   uint256 private constant TOKEN_UNIT = 10 ** uint256(18);
562   uint256 public constant TOTAL_SUPPLY = 2700e6 * TOKEN_UNIT;
563 
564   uint256 public constant COMMUNITY_SUPPLY = 621e6 * TOKEN_UNIT;
565   uint256 public constant TEAM_SUPPLY = 324e6 * TOKEN_UNIT;
566   uint256 public constant ADV_BTY_SUPPLY = 270e6 * TOKEN_UNIT;
567 
568   address public advBtyWallet;
569   address public communityWallet;
570   address public vestingAgent;
571 
572   bool public finalized = false;
573 
574   modifier onlyVestingAgent() {
575     require(msg.sender == vestingAgent);
576     _;
577   }
578 
579   modifier whenNotFinalized() {
580     require(!finalized);
581     _;
582   }
583 
584   constructor(
585     address _communityWallet,
586     address _teamWallet,
587     address _advBtyWallet
588   )
589     public
590     DetailedERC20("Swace", "SWA", 18)
591     CappedToken(TOTAL_SUPPLY)
592   {
593     // solium-disable-next-line security/no-block-members
594     require(_communityWallet != address(0));
595     require(_teamWallet != address(0));
596     require(_advBtyWallet != address(0));
597 
598     communityWallet = _communityWallet;
599     advBtyWallet = _advBtyWallet;
600     //Team wallet is actually vesting agent contract
601     changeVestingAgent(_teamWallet);
602 
603     //Mint tokens to defined wallets
604     mint(_communityWallet, COMMUNITY_SUPPLY);
605     mint(_teamWallet, TEAM_SUPPLY);
606     mint(_advBtyWallet, ADV_BTY_SUPPLY);
607 
608     //Mint owner with the rest of tokens
609     mint(owner, TOTAL_SUPPLY.sub(totalSupply_));
610 
611     //Finish minting because we minted everything already
612     finishMinting();
613   }
614 
615   /**
616    * @dev Original ERC20 approve with additional security mesure.
617    * @param _spender The address which will spend the funds.
618    * @param _value The amount of tokens to be spent.
619    * @return A boolean that indicates if the operation was successful.
620    */
621   function approve(address _spender, uint256 _value)
622     public
623     returns (bool)
624   {
625     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
626     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
627     return super.approve(_spender, _value);
628   }
629 
630   /**
631    * @dev Do finalization.
632    * @return A boolean that indicates if the operation was successful.
633    */
634   function finalize()
635     public
636     onlyOwner
637     whenNotFinalized
638     returns (bool)
639   {
640     uint256 ownerBalance = balanceOf(owner);
641     //Transfer what is left in owner to community wallet
642     if (ownerBalance > 0) {
643       transfer(communityWallet, ownerBalance);
644     }
645 
646     uint256 advBtyBalance = balanceOf(advBtyWallet);
647     //Transfer what is left in advisor & bounty wallet to community wallet
648     //TODO: does not work probably because there is no approval
649     if (advBtyBalance > 0) {
650       transferFrom(advBtyWallet, communityWallet, advBtyBalance);
651     }
652 
653     finalized = true;
654     emit Finalize(ownerBalance.add(advBtyBalance));
655 
656     return true;
657   }
658 
659   /**
660    * TODO: add check if _vestingAgent is contract address
661    * @dev Allow to change vesting agent.
662    * @param _vestingAgent The address of new vesting agent.
663    */
664   function changeVestingAgent(address _vestingAgent)
665     public
666     onlyOwner
667   {
668     address oldVestingAgent = vestingAgent;
669     vestingAgent = _vestingAgent;
670 
671     emit ChangeVestingAgent(oldVestingAgent, _vestingAgent);
672   }
673 }