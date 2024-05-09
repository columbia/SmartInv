1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42   
43 
44 }
45 
46 // File: zeppelin-solidity/contracts/math/SafeMath.sol
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers, truncating the quotient.
68   */
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   /**
77   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   /**
85   * @dev Adds two numbers, throws on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102   function totalSupply() public view returns (uint256);
103   function balanceOf(address who) public view returns (uint256);
104   function transfer(address to, uint256 value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances.
113  */
114 contract BasicToken is ERC20Basic {
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   uint256 totalSupply_;
120 
121   /**
122   * @dev total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[msg.sender]);
136 
137     // SafeMath.sub will throw if there is not enough balance.
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     emit Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public view returns (uint256 balance) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public view returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253     uint oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
266 
267 /**
268  * @title Mintable token
269  * @dev Simple ERC20 Token example, with mintable token creation
270  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
271  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
272  */
273 contract MintableToken is StandardToken, Ownable {
274   event Mint(address indexed to, uint256 amount);
275   event MintFinished();
276 
277   bool public mintingFinished = false;
278 
279 
280   modifier canMint() {
281     require(!mintingFinished);
282     _;
283   }
284 
285   /**
286    * @dev Function to mint tokens
287    * @param _to The address that will receive the minted tokens.
288    * @param _amount The amount of tokens to mint.
289    * @return A boolean that indicates if the operation was successful.
290    */
291   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
292     totalSupply_ = totalSupply_.add(_amount);
293     balances[_to] = balances[_to].add(_amount);
294     emit Mint(_to, _amount);
295     emit Transfer(address(0), _to, _amount);
296     return true;
297   }
298 
299   /**
300    * @dev Function to stop minting new tokens.
301    * @return True if the operation was successful.
302    */
303   function finishMinting() onlyOwner canMint public returns (bool) {
304     mintingFinished = true;
305     emit MintFinished();
306     return true;
307   }
308 }
309 
310 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
311 
312 /**
313  * @title Capped token
314  * @dev Mintable token with a token cap.
315  */
316 contract CappedToken is MintableToken {
317 
318   uint256 public cap;
319 
320   function CappedToken(uint256 _cap) public {
321     require(_cap > 0);
322     cap = _cap;
323   }
324 
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _amount The amount of tokens to mint.
329    * @return A boolean that indicates if the operation was successful.
330    */
331   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
332     require(totalSupply_.add(_amount) <= cap);
333 
334     return super.mint(_to, _amount);
335   }
336 
337 }
338 
339 // File: contracts/CitizenOneCoin.sol
340 
341 // import 'zeppelin-solidity/contracts/token/MintableToken.sol';
342 
343 contract CitizenOneCoin is CappedToken {
344   string public name = "CITIZEN COIN";
345   string public symbol = "XCO";
346   uint8 public decimals = 18;
347   uint256 public cap;
348   
349   address contributor1 = 0x276A50d31c3D0B38DFDE3422b8b9406858De4713; //mark
350   address contributor2 = 0xEc7f7071b567bB712EEE3c028c8fC1D926f5032D; // valentine
351   address contributor3 = 0x920139b051C6381648D69D816447f7e3bC8F3c0F; // yei
352   address contributor4 = 0x1Df3da5f535289e6da5E3ad3FA0293612b35765C; // faraday
353   address contributor5 = 0x93294f64bA8a7db37B554013a6c5D7519171C2Ce;  //david
354   address contributor6 = 0xFFf43D46810B0521Da0fEcfccF13440015e27B6E;  // mozart
355   address contributor7 = 0x8740BDEdf235af5093b2e6d4100671538c0266E1;  // code arc
356   address contributor8 = 0x297F01F821323C5e85Cd51e10A892d2373ce12c4;  // mikeydee
357   address contributor9 = 0xbfd638491453A933E1BF164ABFC3202fD564F4A7;  // jamie
358   address contributor10 = 0x97E6342702554A79ad0Bd70362eD61a831F1cC59; // jordan
359 //   address contributor11 = 0x7a5A48297583F7A4faA90e78FddED38795CcDC78; // test contributor1
360 //   address contributor12 = 0x70713af85FCdC1A01e2b50b8C7B6AEb79B897fe4; // test contributor2
361   
362 
363   function CitizenOneCoin(uint256 _cap)  CappedToken  (_cap) public {
364   	require(_cap > 0);
365     cap = _cap;
366     
367     mint(contributor1, 500000e18);
368     mint(contributor2, 500000e18);
369     mint(contributor3, 500000e18);
370     mint(contributor4, 500000e18);
371     mint(contributor5, 500000e18);
372     mint(contributor6, 500000e18);
373     mint(contributor7, 500000e18);
374     mint(contributor8, 500000e18);
375     mint(contributor9, 500000e18);
376     mint(contributor10, 500000e18);
377     
378   }
379   /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
386     require(totalSupply_.add(_amount) <= cap);
387 
388     return super.mint(_to, _amount);
389   }
390 
391   function pushCap(uint _newCap) onlyOwner  public {
392 	  cap = cap.add(_newCap);
393   }
394   
395 
396 }
397 
398 // File: contracts/Pausable.sol
399 
400 /**
401  * @title Pausable
402  * @dev Base contract which allows children to implement an emergency stop mechanism.
403  */
404 contract Pausable is Ownable {
405   event Pause();
406   event Unpause();
407 
408   bool public paused = false;
409   /**
410    * @dev modifier to allow actions only when the contract IS paused
411    */
412   modifier whenNotPaused() {
413     require(!paused);
414     _;
415   }
416 
417   /**
418    * @dev modifier to allow actions only when the contract IS NOT paused
419    */
420   modifier whenPaused {
421     require(paused);
422     _;
423   }
424 
425   /**
426    * @dev called by the owner to pause, triggers stopped state
427    */
428   function pause() onlyOwner whenNotPaused public returns (bool) {
429     paused = true;
430     emit Pause();
431     return true;
432   }
433 
434   /**
435    * @dev called by the owner to unpause, returns to normal state
436    */
437   function unpause() onlyOwner whenPaused public returns (bool) {
438     paused = false;
439     emit Unpause();
440     return true;
441   }
442 }
443 
444 // File: contracts/CitizenOne.sol
445 
446 contract CitizenOne is Pausable {
447 	using SafeMath for uint256;
448 	// list contributor addresses
449 // 	address [] public contributors;
450 	// the publicity address
451 	address public publicityAddress;
452 
453     CappedToken public token;
454 
455     address public wallet;
456 
457   // how many token units a buyer gets per wei
458     uint256 public rate;
459 
460     uint256 public cap;
461 
462     bool public isFinalized;
463 
464   // amount of raised money in wei
465     uint256 public weiRaised;
466 
467     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
468 
469     event Finalized();
470 
471 	function CitizenOne(uint256 _rate, address _wallet, uint256 _cap ) public payable {
472         require(_rate > 0);
473         require(_wallet != address(0));
474         require(_wallet != 0x0);
475         require(_cap > 0);
476         token = createTokenContract();
477         cap = _cap * (10**18);
478         rate = _rate;
479         wallet = _wallet;
480     //   	contributors = _contributors;
481       	publicityAddress    = _wallet;
482 
483       	token.mint(publicityAddress, 10000000e18);
484   }
485 
486   // creates the token to be sold.
487   // override this method to have crowdsale of a specific MintableToken token.
488   function createTokenContract() internal returns (CappedToken) {
489       return new CitizenOneCoin(500000000e18);
490   }
491 
492 //   function getContributors() public view returns (address []) {
493 //   	return contributors;
494 //   }
495 
496   /* @param beneficiary will recieve the tokens.
497    */
498    
499     function () public payable {
500         
501       buyTokens(msg.sender);
502     }
503   
504   function buyTokens(address beneficiary) public payable whenNotPaused {
505     require(beneficiary != 0x0);
506     require(validPurchase());
507 
508 
509     uint256 weiAmount = msg.value;
510     // update weiRaised
511     weiRaised = weiRaised.add(weiAmount);
512     // compute amount of tokens created
513     uint256 tokens = weiAmount.mul(rate);
514 
515     token.mint(beneficiary, tokens);
516     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
517     forwardFunds();
518   }
519 
520   // send ether to the fund collection wallet
521   function forwardFunds() internal {
522     wallet.transfer(msg.value);
523   }
524   
525   // change rate
526   function changeRate (uint256 _rate) onlyOwner public {
527       rate = _rate;
528   }
529 
530   function transferTokenOwnership(address _newOwner) onlyOwner public {
531 	  token.transferOwnership(_newOwner);
532   }
533 
534   // return true if the transaction can buy tokens
535   function validPurchase() internal constant returns (bool) {
536     uint256 weiAmount = weiRaised.add(msg.value);
537     bool withinCap = weiAmount.mul(rate) <= cap;
538 
539     return withinCap;
540   }
541 
542   //allow owner to finalize the presale once the presale is ended
543   function finalize() onlyOwner public {
544     require(!isFinalized);
545     require(hasEnded());
546 
547     token.finishMinting();
548     emit Finalized();
549 
550     isFinalized = true;
551   }
552 
553   //return true if crowdsale event has ended
554   function hasEnded() public constant returns (bool) {
555     bool capReached = (weiRaised.mul(rate) >= cap);
556     return capReached;
557   }
558 
559 }
560 
561 // 0xd3f1d2776eb63e1c7b141e0bb500a00121ce1db2