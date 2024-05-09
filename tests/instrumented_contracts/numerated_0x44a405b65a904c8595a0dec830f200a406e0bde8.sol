1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return a / b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender)
118     public view returns (uint256);
119 
120   function transferFrom(address from, address to, uint256 value)
121     public returns (bool);
122 
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(
125     address indexed owner,
126     address indexed spender,
127     uint256 value
128   );
129 }
130 
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(
151     address _from,
152     address _to,
153     uint256 _value
154   )
155     public
156     returns (bool)
157   {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(
192     address _owner,
193     address _spender
194    )
195     public
196     view
197     returns (uint256)
198   {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(
213     address _spender,
214     uint _addedValue
215   )
216     public
217     returns (bool)
218   {
219     allowed[msg.sender][_spender] = (
220       allowed[msg.sender][_spender].add(_addedValue));
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address public owner;
262 
263 
264   event OwnershipRenounced(address indexed previousOwner);
265   event OwnershipTransferred(
266     address indexed previousOwner,
267     address indexed newOwner
268   );
269 
270 
271   /**
272    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
273    * account.
274    */
275   constructor() public {
276     owner = msg.sender;
277   }
278 
279   /**
280    * @dev Throws if called by any account other than the owner.
281    */
282   modifier onlyOwner() {
283     require(msg.sender == owner);
284     _;
285   }
286 
287   /**
288    * @dev Allows the current owner to relinquish control of the contract.
289    */
290   function renounceOwnership() public onlyOwner {
291     emit OwnershipRenounced(owner);
292     owner = address(0);
293   }
294 
295   /**
296    * @dev Allows the current owner to transfer control of the contract to a newOwner.
297    * @param _newOwner The address to transfer ownership to.
298    */
299   function transferOwnership(address _newOwner) public onlyOwner {
300     _transferOwnership(_newOwner);
301   }
302 
303   /**
304    * @dev Transfers control of the contract to a newOwner.
305    * @param _newOwner The address to transfer ownership to.
306    */
307   function _transferOwnership(address _newOwner) internal {
308     require(_newOwner != address(0));
309     emit OwnershipTransferred(owner, _newOwner);
310     owner = _newOwner;
311   }
312 }
313 
314 
315 
316 /**
317  * @title Mintable token
318  * @dev Simple ERC20 Token example, with mintable token creation
319  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
320  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
321  */
322 contract MintableToken is StandardToken, Ownable {
323   event Mint(address indexed to, uint256 amount);
324   event MintFinished();
325 
326   bool public mintingFinished = false;
327 
328 
329   modifier canMint() {
330     require(!mintingFinished);
331     _;
332   }
333 
334   modifier hasMintPermission() {
335     require(msg.sender == owner);
336     _;
337   }
338 
339   /**
340    * @dev Function to mint tokens
341    * @param _to The address that will receive the minted tokens.
342    * @param _amount The amount of tokens to mint.
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function mint(
346     address _to,
347     uint256 _amount
348   )
349     hasMintPermission
350     canMint
351     public
352     returns (bool)
353   {
354     totalSupply_ = totalSupply_.add(_amount);
355     balances[_to] = balances[_to].add(_amount);
356     emit Mint(_to, _amount);
357     emit Transfer(address(0), _to, _amount);
358     return true;
359   }
360 
361   /**
362    * @dev Function to stop minting new tokens.
363    * @return True if the operation was successful.
364    */
365   function finishMinting() onlyOwner canMint public returns (bool) {
366     mintingFinished = true;
367     emit MintFinished();
368     return true;
369   }
370 }
371 
372 
373 /**
374  * @title DetailedERC20 token
375  * @dev The decimals are only for visualization purposes.
376  * All the operations are done using the smallest and indivisible token unit,
377  * just as on Ethereum all the operations are done in wei.
378  */
379 contract DetailedERC20 is ERC20 {
380   string public name;
381   string public symbol;
382   uint8 public decimals;
383 
384   constructor(string _name, string _symbol, uint8 _decimals) public {
385     name = _name;
386     symbol = _symbol;
387     decimals = _decimals;
388   }
389 }
390 
391 /**
392  * @title Capped token
393  * @dev Mintable token with a token cap.
394  */
395 contract CappedToken is MintableToken {
396 
397   uint256 public cap;
398 
399   constructor(uint256 _cap) public {
400     require(_cap > 0);
401     cap = _cap;
402   }
403 
404   /**
405    * @dev Function to mint tokens
406    * @param _to The address that will receive the minted tokens.
407    * @param _amount The amount of tokens to mint.
408    * @return A boolean that indicates if the operation was successful.
409    */
410   function mint(
411     address _to,
412     uint256 _amount
413   )
414     // onlyOwner
415     canMint
416     public
417     returns (bool)
418   {
419     require(totalSupply_.add(_amount) <= cap);
420 
421     return super.mint(_to, _amount);
422   }
423 
424 }
425 
426 
427 
428 contract ATTRToken is CappedToken, DetailedERC20 {
429 
430   using SafeMath for uint256;
431 
432   uint256 public constant TOTAL_SUPPLY       = uint256(1000000000);
433   uint256 public constant TOTAL_SUPPLY_ACES  = uint256(1000000000000000000000000000);
434   uint256 public constant CROWDSALE_MAX_ACES = uint256(500000000000000000000000000);
435 
436   address public crowdsaleContract;
437   uint256 public crowdsaleMinted = uint256(0);
438 
439   uint256 public releaseTime = uint256(1536278399); // '2018-09-06T23:59:59Z'.unix()
440   bool    public fundingLowcapReached = false;
441   bool    public isReleased = false;
442 
443   mapping (address => bool) public agents;
444 
445   mapping (address => bool) public transferWhitelist;
446 
447   constructor() public 
448     CappedToken(TOTAL_SUPPLY_ACES) 
449     DetailedERC20("Attrace", "ATTR", uint8(18)) {
450     transferWhitelist[msg.sender] = true;
451     agents[msg.sender] = true;
452   }
453   
454   // **********
455   // VALIDATION
456   // **********
457   modifier isInitialized() {
458     require(crowdsaleContract != address(0));
459     require(releaseTime > 0);
460     _;
461   }
462 
463   // ********
464   // CONTROLS
465   // ********
466   function setAgent(address _address, bool _status) public onlyOwner {
467     require(_address != address(0));
468     agents[_address] = _status;
469   }
470 
471   modifier onlyAgents() {
472     require(agents[msg.sender] == true);
473     _;
474   }
475 
476   function setCrowdsaleContract(address _crowdsaleContract) public onlyAgents {
477     require(_crowdsaleContract != address(0));
478     crowdsaleContract = _crowdsaleContract;
479   }
480 
481   function setTransferWhitelist(address _address, bool _canTransfer) public onlyAgents {
482     require(_address != address(0));
483     transferWhitelist[_address] = _canTransfer;
484   }
485 
486   function setReleaseTime(uint256 _time) public onlyAgents {
487     require(_time > block.timestamp);
488     require(isReleased == false);
489     releaseTime = _time;
490   }
491 
492   function setFundingLowcapReached(uint256 _verification) public onlyAgents {
493     require(_verification == uint256(20234983249), "wrong verification code");
494     fundingLowcapReached = true;
495   }
496 
497   function markReleased() public {
498     if (isReleased == false && _now() > releaseTime) {
499       isReleased = true;
500     }
501   }
502 
503   // *******
504   // MINTING
505   // *******
506   modifier hasMintPermission() {
507     require(msg.sender == crowdsaleContract || agents[msg.sender] == true);
508     _;
509   }
510 
511   function mint(address _to, uint256 _aces) public canMint hasMintPermission returns (bool) {
512     if (msg.sender == crowdsaleContract) {
513       require(crowdsaleMinted.add(_aces) <= CROWDSALE_MAX_ACES);
514       crowdsaleMinted = crowdsaleMinted.add(_aces);
515     }
516     return super.mint(_to, _aces);
517   }
518 
519   // ********
520   // TRANSFER
521   // ********
522   modifier canTransfer(address _from) {
523     if (transferWhitelist[_from] == false) {
524       require(block.timestamp >= releaseTime);
525       require(fundingLowcapReached == true);
526     }
527     _;
528   }
529 
530   function transfer(address _to, uint256 _aces) 
531     public
532     isInitialized
533     canTransfer(msg.sender) 
534     tokensAreUnlocked(msg.sender, _aces)
535     returns (bool) {
536       markReleased();
537       return super.transfer(_to, _aces);
538     }
539 
540   function transferFrom(address _from, address _to, uint256 _aces) 
541     public
542     isInitialized
543     canTransfer(_from) 
544     tokensAreUnlocked(_from, _aces)
545     returns (bool) {
546       markReleased();
547       return super.transferFrom(_from, _to, _aces);
548     }
549 
550   // *******
551   // VESTING
552   // *******
553   struct VestingRule {
554     uint256 aces;
555     uint256 unlockTime;
556     bool    processed;
557   }
558 
559   // Controls the amount of locked tokens
560   mapping (address => uint256) public lockedAces;
561 
562   modifier tokensAreUnlocked(address _from, uint256 _aces) {
563     if (lockedAces[_from] > uint256(0)) {
564       require(balanceOf(_from).sub(lockedAces[_from]) >= _aces);
565     }
566     _;
567   }
568 
569   // Dynamic vesting rules
570   mapping (address => VestingRule[]) public vestingRules;
571 
572   function processVestingRules(address _address) public onlyAgents {
573     _processVestingRules(_address);
574   }
575 
576   function processMyVestingRules() public {
577     _processVestingRules(msg.sender);
578   }
579 
580   function addVestingRule(address _address, uint256 _aces, uint256 _unlockTime) public {
581     require(_aces > 0);
582     require(_address != address(0));
583     require(_unlockTime > _now());
584     if (_now() < releaseTime) {
585       require(msg.sender == owner);
586     } else {
587       require(msg.sender == crowdsaleContract || msg.sender == owner);
588       require(_now() < releaseTime.add(uint256(2592000)));
589     }
590     vestingRules[_address].push(VestingRule({ 
591       aces: _aces,
592       unlockTime: _unlockTime,
593       processed: false
594     }));
595     lockedAces[_address] = lockedAces[_address].add(_aces);
596   }
597 
598   // Loop over vesting rules, bail if date not yet passed.
599   // If date passed, unlock aces and disable rule
600   function _processVestingRules(address _address) internal {
601     for (uint256 i = uint256(0); i < vestingRules[_address].length; i++) {
602       if (vestingRules[_address][i].processed == false && vestingRules[_address][i].unlockTime < _now()) {
603         lockedAces[_address] = lockedAces[_address].sub(vestingRules[_address][i].aces);
604         vestingRules[_address][i].processed = true;
605       }
606     }
607   }
608 
609   // *******
610   // TESTING 
611   // *******
612   function _now() internal view returns (uint256) {
613     return block.timestamp;
614   }
615 }