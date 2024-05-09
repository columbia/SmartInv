1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender)
153     public view returns (uint256);
154 
155   function transferFrom(address from, address to, uint256 value)
156     public returns (bool);
157 
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192     returns (bool)
193   {
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(
228     address _owner,
229     address _spender
230    )
231     public
232     view
233     returns (uint256)
234   {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(
249     address _spender,
250     uint _addedValue
251   )
252     public
253     returns (bool)
254   {
255     allowed[msg.sender][_spender] = (
256       allowed[msg.sender][_spender].add(_addedValue));
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(
272     address _spender,
273     uint _subtractedValue
274   )
275     public
276     returns (bool)
277   {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
291 
292 /**
293  * @title Standard Burnable Token
294  * @dev Adds burnFrom method to ERC20 implementations
295  */
296 contract StandardBurnableToken is BurnableToken, StandardToken {
297 
298   /**
299    * @dev Burns a specific amount of tokens from the target address and decrements allowance
300    * @param _from address The address which you want to send tokens from
301    * @param _value uint256 The amount of token to be burned
302    */
303   function burnFrom(address _from, uint256 _value) public {
304     require(_value <= allowed[_from][msg.sender]);
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     _burn(_from, _value);
309   }
310 }
311 
312 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
313 
314 /**
315  * @title Ownable
316  * @dev The Ownable contract has an owner address, and provides basic authorization control
317  * functions, this simplifies the implementation of "user permissions".
318  */
319 contract Ownable {
320   address public owner;
321 
322 
323   event OwnershipRenounced(address indexed previousOwner);
324   event OwnershipTransferred(
325     address indexed previousOwner,
326     address indexed newOwner
327   );
328 
329 
330   /**
331    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
332    * account.
333    */
334   constructor() public {
335     owner = msg.sender;
336   }
337 
338   /**
339    * @dev Throws if called by any account other than the owner.
340    */
341   modifier onlyOwner() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Allows the current owner to relinquish control of the contract.
348    */
349   function renounceOwnership() public onlyOwner {
350     emit OwnershipRenounced(owner);
351     owner = address(0);
352   }
353 
354   /**
355    * @dev Allows the current owner to transfer control of the contract to a newOwner.
356    * @param _newOwner The address to transfer ownership to.
357    */
358   function transferOwnership(address _newOwner) public onlyOwner {
359     _transferOwnership(_newOwner);
360   }
361 
362   /**
363    * @dev Transfers control of the contract to a newOwner.
364    * @param _newOwner The address to transfer ownership to.
365    */
366   function _transferOwnership(address _newOwner) internal {
367     require(_newOwner != address(0));
368     emit OwnershipTransferred(owner, _newOwner);
369     owner = _newOwner;
370   }
371 }
372 
373 // File: @pigzbe/erc20-contract/contracts/WLO.sol
374 
375 contract WLO is StandardBurnableToken, Ownable {
376 
377   string public name = "Wollo";
378   string public symbol = "WLO";
379 
380   uint8 public decimals = 18;
381   uint public INITIAL_SUPPLY = 13500000 * uint(10**uint(decimals));
382 
383   constructor () public {
384     totalSupply_ = INITIAL_SUPPLY;
385     balances[msg.sender] = INITIAL_SUPPLY;
386   }
387 }
388 
389 // File: contracts/ICOEngineInterface.sol
390 
391 contract ICOEngineInterface {
392 
393   // false if the ico is not started, true if the ico is started and running, true if the ico is completed
394   function started() public view returns(bool);
395 
396   // false if the ico is not started, false if the ico is started and running, true if the ico is completed
397   function ended() public view returns(bool);
398 
399   // time stamp of the starting time of the ico, must return 0 if it depends on the block number
400   function startTime() public view returns(uint);
401 
402   // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
403   function endTime() public view returns(uint);
404 
405   // Optional function, can be implemented in place of startTime
406   // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
407   // function startBlock() public view returns(uint);
408 
409   // Optional function, can be implemented in place of endTime
410   // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
411   // function endBlock() public view returns(uint);
412 
413   // returns the total number of the tokens available for the sale, must not change when the ico is started
414   function totalTokens() public view returns(uint);
415 
416   // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
417   // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
418   function remainingTokens() public view returns(uint);
419 
420   // return the price as number of tokens released for each ether
421   function price() public view returns(uint);
422 }
423 
424 // File: contracts/KYCBase.sol
425 
426 // Abstract base contract
427 contract KYCBase {
428   using SafeMath for uint256;
429 
430   mapping (address => bool) public isKycSigner;
431   mapping (uint64 => uint256) public alreadyPayed;
432 
433   event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
434 
435   constructor(address[] kycSigners) internal {
436     for (uint i = 0; i < kycSigners.length; i++) {
437       isKycSigner[kycSigners[i]] = true;
438     }
439   }
440 
441   // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
442   function releaseTokensTo(address buyer) internal returns(bool);
443 
444   // This method can be overridden to enable some sender to buy token for a different address
445   function senderAllowedFor(address buyer) internal view returns(bool) {
446     return buyer == msg.sender;
447   }
448 
449   function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s) public payable returns (bool) {
450     require(senderAllowedFor(buyerAddress));
451     return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
452   }
453 
454   function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s) public payable returns (bool) {
455     return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
456   }
457 
458   function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s) private returns (bool) {
459     // check the signature
460     bytes32 hash = sha256(abi.encodePacked("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount));
461     address signer = ecrecover(hash, v, r, s);
462     if (!isKycSigner[signer]) {
463       revert();
464     } else {
465       uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
466       require(totalPayed <= maxAmount);
467       alreadyPayed[buyerId] = totalPayed;
468       emit KycVerified(signer, buyerAddress, buyerId, maxAmount);
469       return releaseTokensTo(buyerAddress);
470     }
471   }
472 
473   // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
474   function () public {
475     revert();
476   }
477 }
478 
479 // File: contracts/WolloCrowdsale.sol
480 
481 /* solium-disable security/no-block-members */
482 pragma solidity ^0.4.24;
483 
484 
485 
486 
487 
488 contract WolloCrowdsale is ICOEngineInterface, KYCBase {
489   using SafeMath for uint;
490 
491   WLO public token;
492   address public wallet;
493   uint public price;
494   uint public startTime;
495   uint public endTime;
496   uint public cap;
497   uint public remainingTokens;
498   uint public totalTokens;
499 
500   /**
501   * event for token purchase logging
502   * @param purchaser who paid for the tokens
503   * @param beneficiary who got the tokens
504   * @param value weis paid for purchase
505   * @param amount amount of tokens purchased
506   */
507   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
508 
509   /**
510   * event for when weis are sent back to buyer
511   * @param purchaser who paid for the tokens and is getting back some ether
512   * @param amount of weis sent back
513   */
514   event SentBack(address indexed purchaser, uint256 amount);
515 
516   // LOGS
517   event Log(string name, uint number);
518   event LogBool(string name, bool log);
519   event LogS(string name, string log);
520   event LogA(string name, address log);
521 
522   /**
523   *  Constructor
524   */
525   constructor (
526     address[] kycSigner,
527     address _token,
528     address _wallet,
529     uint _startTime,
530     uint _endTime,
531     uint _price,
532     uint _cap
533   ) public KYCBase(kycSigner) {
534 
535     require(_token != address(0));
536     require(_wallet != address(0));
537     /* require(_startTime >= now); */
538     require(_endTime > _startTime);
539     require(_price > 0);
540     require(_cap > 0);
541 
542     token = WLO(_token);
543 
544     wallet = _wallet;
545     startTime = _startTime;
546     endTime = _endTime;
547     price = _price;
548     cap = _cap;
549 
550     totalTokens = cap;
551     remainingTokens = cap;
552   }
553 
554   // function that is called from KYCBase
555   function releaseTokensTo(address buyer) internal returns(bool) {
556 
557     emit LogBool("started", started());
558     emit LogBool("ended", ended());
559 
560     require(started() && !ended());
561 
562     emit Log("wei", msg.value);
563     emit LogA("buyer", buyer);
564 
565     uint weiAmount = msg.value;
566     uint weiBack = 0;
567     uint tokens = weiAmount.mul(price);
568     uint tokenRaised = totalTokens - remainingTokens;
569 
570     if (tokenRaised.add(tokens) > cap) {
571       tokens = cap.sub(tokenRaised);
572       weiAmount = tokens.div(price);
573       weiBack = msg.value - weiAmount;
574     }
575 
576     emit Log("tokens", tokens);
577 
578     remainingTokens = remainingTokens.sub(tokens);
579 
580     require(token.transferFrom(wallet, buyer, tokens));
581     wallet.transfer(weiAmount);
582 
583     if (weiBack > 0) {
584       msg.sender.transfer(weiBack);
585       emit SentBack(msg.sender, weiBack);
586     }
587 
588     emit TokenPurchase(msg.sender, buyer, weiAmount, tokens);
589     return true;
590   }
591 
592   function started() public view returns(bool) {
593     return now >= startTime;
594   }
595 
596   function ended() public view returns(bool) {
597     return now >= endTime || remainingTokens == 0;
598   }
599 
600   function startTime() public view returns(uint) {
601     return(startTime);
602   }
603 
604   function endTime() public view returns(uint){
605     return(endTime);
606   }
607 
608   function totalTokens() public view returns(uint){
609     return(totalTokens);
610   }
611 
612   function remainingTokens() public view returns(uint){
613     return(remainingTokens);
614   }
615 
616   function price() public view returns(uint){
617     return price;
618   }
619 }