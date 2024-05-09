1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts/ZUR.sol
379 
380 /**
381  * Holders of ZUR can claim COE as it is mined using the claimTokens()
382  * function. This contract will be fed COE automatically by the COE ERC20
383  * contract.
384  */
385 contract ZUR is MintableToken {
386   using SafeMath for uint;
387 
388   string public constant name = "ZUR Cheque by Zurcoin Core";
389   string public constant symbol = "ZUR";
390   uint8 public constant decimals = 0;
391 
392   address public admin;
393   uint public cap = 35*10**13;
394   uint public totalEthReleased = 0;
395 
396   mapping(address => uint) public ethReleased;
397   address[] public trackedTokens;
398   mapping(address => bool) public isTokenTracked;
399   mapping(address => uint) public totalTokensReleased;
400   mapping(address => mapping(address => uint)) public tokensReleased;
401 
402   constructor() public {
403     owner = this;
404     admin = msg.sender;
405   }
406 
407   function () public payable {}
408 
409   modifier onlyAdmin() {
410     require(msg.sender == admin);
411     _;
412   }
413 
414   function changeAdmin(address _receiver) onlyAdmin public {
415     admin = _receiver;
416   }
417 
418   /**
419    * Claim your eth.
420    */
421   function claimEth() public {
422     claimEthFor(msg.sender);
423   }
424 
425   // Claim eth for address
426   function claimEthFor(address payee) public {
427     require(balances[payee] > 0);
428 
429     uint totalReceived = address(this).balance.add(totalEthReleased);
430     uint payment = totalReceived.mul(
431       balances[payee]).div(
432         cap).sub(
433           ethReleased[payee]
434     );
435 
436     require(payment != 0);
437     require(address(this).balance >= payment);
438 
439     ethReleased[payee] = ethReleased[payee].add(payment);
440     totalEthReleased = totalEthReleased.add(payment);
441 
442     payee.transfer(payment);
443   }
444 
445   // Claim your tokens
446   function claimMyTokens() public {
447     claimTokensFor(msg.sender);
448   }
449 
450   // Claim on behalf of payee address
451   function claimTokensFor(address payee) public {
452     require(balances[payee] > 0);
453 
454     for (uint16 i = 0; i < trackedTokens.length; i++) {
455       claimToken(trackedTokens[i], payee);
456     }
457   }
458 
459   /**
460    * Transfers the unclaimed token amount for the given token and address
461    * @param _tokenAddr The address of the ERC20 token
462    * @param _payee The address of the payee (ZUR holder)
463    */
464   function claimToken(address _tokenAddr, address _payee) public {
465     require(balances[_payee] > 0);
466     require(isTokenTracked[_tokenAddr]);
467 
468     uint payment = getUnclaimedTokenAmount(_tokenAddr, _payee);
469     if (payment == 0) {
470       return;
471     }
472 
473     ERC20 Token = ERC20(_tokenAddr);
474     require(Token.balanceOf(address(this)) >= payment);
475     tokensReleased[address(Token)][_payee] = tokensReleased[address(Token)][_payee].add(payment);
476     totalTokensReleased[address(Token)] = totalTokensReleased[address(Token)].add(payment);
477     Token.transfer(_payee, payment);
478   }
479 
480   /**
481    * Returns the amount of a token (tokenAddr) that payee can claim
482    * @param tokenAddr The address of the ERC20 token
483    * @param payee The address of the payee
484    */
485   function getUnclaimedTokenAmount(address tokenAddr, address payee) public view returns (uint) {
486     ERC20 Token = ERC20(tokenAddr);
487     uint totalReceived = Token.balanceOf(address(this)).add(totalTokensReleased[address(Token)]);
488     uint payment = totalReceived.mul(
489       balances[payee]).div(
490         cap).sub(
491           tokensReleased[address(Token)][payee]
492     );
493     return payment;
494   }
495 
496   function transfer(address _to, uint256 _value) public returns (bool) {
497     require(msg.sender != _to);
498     uint startingBalance = balances[msg.sender];
499     require(super.transfer(_to, _value));
500 
501     transferCheques(msg.sender, _to, _value, startingBalance);
502     return true;
503   }
504 
505   function transferCheques(address from, address to, uint cheques, uint startingBalance) internal {
506 
507     // proportional amount of eth released already
508     uint claimedEth = ethReleased[from].mul(
509       cheques).div(
510         startingBalance
511     );
512 
513     // increment to's released eth
514     ethReleased[to] = ethReleased[to].add(claimedEth);
515 
516     // decrement from's released eth
517     ethReleased[from] = ethReleased[from].sub(claimedEth);
518 
519     for (uint16 i = 0; i < trackedTokens.length; i++) {
520       address tokenAddr = trackedTokens[i];
521 
522       // proportional amount of token released already
523       uint claimed = tokensReleased[tokenAddr][from].mul(
524         cheques).div(
525           startingBalance
526       );
527 
528       // increment to's released token
529       tokensReleased[tokenAddr][to] = tokensReleased[tokenAddr][to].add(claimed);
530 
531       // decrement from's released token
532       tokensReleased[tokenAddr][from] = tokensReleased[tokenAddr][from].sub(claimed);
533     }
534   }
535 
536   /**
537    * @dev Add a new payee to the contract.
538    * @param _payees The addresses of the payees to add.
539    * @param _cheques The array of number of cheques owned by the payee.
540    */
541   function addPayees(address[] _payees, uint[] _cheques) onlyAdmin external {
542     require(_payees.length == _cheques.length);
543     require(_payees.length > 0);
544 
545     for (uint i = 0; i < _payees.length; i++) {
546       addPayee(_payees[i], _cheques[i]);
547     }
548 
549   }
550 
551   /**
552    * @dev Add a new payee to the contract.
553    * @param _payee The address of the payee to add.
554    * @param _cheques The number of _cheques owned by the payee.
555    */
556   function addPayee(address _payee, uint _cheques) onlyAdmin canMint public {
557     require(_payee != address(0));
558     require(_cheques > 0);
559     require(balances[_payee] == 0);
560 
561     MintableToken(this).mint(_payee, _cheques);
562   }
563 
564   // irreversibly close the adding of cheques
565   function finishedLoading() onlyAdmin canMint public {
566     MintableToken(this).finishMinting();
567   }
568 
569   function trackToken(address _addr) onlyAdmin public {
570     require(_addr != address(0));
571     require(!isTokenTracked[_addr]);
572     trackedTokens.push(_addr);
573     isTokenTracked[_addr] = true;
574   }
575 
576   /*
577    * However unlikely, it is possible that the number of tracked tokens
578    * reaches the point that would make the gas cost of transferring ZUR
579    * exceed the block gas limit. This function allows the admin to remove
580    * a token from the tracked token list thus reducing the number of loops
581    * required in transferCheques, lowering the gas cost of transfer. The
582    * remaining balance of this token is sent back to the token's contract.
583    *
584    * Removal is irreversible.
585    *
586    * @param _addr The address of the ERC token to untrack
587    * @param _position The index of the _addr in the trackedTokens array.
588    * Use web3 to cycle through and find the index position.
589    */
590   function unTrackToken(address _addr, uint16 _position) onlyAdmin public {
591     require(isTokenTracked[_addr]);
592     require(trackedTokens[_position] == _addr);
593 
594     ERC20(_addr).transfer(_addr, ERC20(_addr).balanceOf(address(this)));
595     trackedTokens[_position] = trackedTokens[trackedTokens.length-1];
596     delete trackedTokens[trackedTokens.length-1];
597     trackedTokens.length--;
598   }
599 }