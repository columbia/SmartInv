1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 public totalSupply_;
128   
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143 
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     emit Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) public allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 /**
258  * @title CoinnupCrowdsaleToken
259  * @dev ERC20-compliant Token that can be minted.
260  */
261 contract CoinnupToken is StandardToken, Ownable {
262   using SafeMath for uint256;
263 
264   string public constant name = "Coinnup Coin"; // solium-disable-line uppercase
265   string public constant symbol = "PMZ"; // solium-disable-line uppercase
266   uint8 public constant decimals = 18; // solium-disable-line uppercase
267 
268   /// @dev store how much in eth users invested to give them a refund in case refund happens
269   mapping ( address => uint256 ) public investments;
270   /// @dev to have how much one user bought tokens
271   mapping ( address => uint256 ) public tokensBought;
272 
273   /// @dev event when someone bought tokens by ETH
274   event investmentReceived(
275     address sender,
276     uint weis,
277     uint total
278   );
279 
280   uint256 public maxSupply = 298500000000000000000000000;
281   uint256 public allowedToBeSold = 118056750000000000000000000;
282   address public founder = address( 0x3abb86C7C1a533Eb0464E9BD870FD1b501C7A8A8 );
283   uint256 public rate = 2800;
284   uint256 public bonus = 30;
285   uint256 public softCap = 1850000000000000000000;
286 
287   uint256 public _sold; //eth sold via payable function
288   /// @dev in this var we store eth when someone bought tokens
289   /// not sending it to smart contract but buying it privately
290   uint256 public _soldOutside; //wei sold not via SC
291   uint256 public _soldOutsidePMZ; //PMZ tokens sold not via SC
292 
293   bool public isPaused;
294 
295   struct Round {
296     uint256 openingTime;
297     uint256 closingTime;
298     uint256 allocatedCoins;
299     uint256 minPurchase;
300     uint256 maxPurchase;
301     uint256 soldCoins;
302   }
303 
304   Round[] public rounds;
305 
306   /** @dev Token cunstructor
307     */
308   constructor () public {
309     require(maxSupply > 0);
310     require(founder != address(0));
311     require(rate > 0);
312     require(bonus >= 0 && bonus <= 100); // in percentage
313     require(allowedToBeSold > 0 && allowedToBeSold < maxSupply);
314 
315     require(softCap > 0);
316 
317     for (uint8 i = 0; i < 6; i++) {
318       rounds.push( Round(0, 0, 0, 0, 0, 0) );
319     }
320 
321     // mint tokens which initially belongs to founder
322     uint256 _forFounder = maxSupply.sub(allowedToBeSold);
323     mint(founder, _forFounder);
324 
325     // waiting for admin to set round dates
326     // and to unpause by admin
327     triggerICOState(true);
328   }
329 
330   /// @dev in payable we shold keep only forwarding call
331   function () public onlyWhileOpen isNotPaused payable {
332     require(_buyTokens(msg.sender, msg.value));
333   }
334 
335   /**
336    * @dev gets `_sender` and `_value` as input and sells tokens with bonus
337    * throws if not enough tokens after calculation
338    * @return isSold bool whether tokens bought
339    */
340   function _buyTokens(address _sender, uint256 _value) internal isNotPaused returns (bool) {
341     uint256 amount = _getTokenAmount(_value, bonus);
342     uint256 amount_without_bonus = _getTokenAmount(_value, 0);
343     uint8 _currentRound = _getCurrentRound(now);
344 
345     require(rounds[_currentRound].allocatedCoins >= amount.add(rounds[_currentRound].soldCoins));
346     require(totalSupply_.add(amount) <= maxSupply); // if we have enough tokens to be minted
347 
348     require(
349       rounds[_currentRound].minPurchase <= amount_without_bonus &&
350       rounds[_currentRound].maxPurchase >= amount_without_bonus
351     );
352 
353     _sold = _sold.add(_value); // in wei
354     investments[_sender] = investments[_sender].add(_value); // in wei
355 
356     // minting tokens for investores
357     // after we recorded how much he sent ether and other params
358     mint(_sender, amount);
359     rounds[_currentRound].soldCoins = rounds[_currentRound].soldCoins.add(amount);
360     tokensBought[_sender] = tokensBought[_sender].add(amount);
361 
362     emit investmentReceived(
363       _sender,
364       _value,
365       amount_without_bonus
366     );
367 
368     return true;
369   }
370 
371   /// @dev system can mint tokens for users if they sent funds to BTC, LTC, etc wallets we allow
372   function mintForInvestor(address _to, uint256 _tokens, uint256 _tokens_bonus) public onlyOwner onlyWhileOpen {
373     uint8 _round = _getCurrentRound(now);
374     uint256 _tokens_with_bonuses = _tokens.add(_tokens_bonus);
375 
376     require(_round >= 0 && _round <= 5);
377     require(_to != address(0)); // handling incorrect values from system in addresses
378     require(_tokens >= 0); // handling incorrect values from system in tokens calculation
379     require(rounds[_round].allocatedCoins >= _tokens_with_bonuses.add(rounds[_round].soldCoins));
380     require(maxSupply >= _tokens_with_bonuses.add(totalSupply_));
381     require(_tokens > _tokens_bonus);
382     
383     require(
384       rounds[_round].minPurchase <= _tokens && // Min Max purchases without bonuses
385       rounds[_round].maxPurchase >= _tokens
386     );
387 
388     // minting tokens for investors
389     mint(_to, _tokens_with_bonuses); // _tokens in wei
390     rounds[_round].soldCoins = rounds[_round].soldCoins.add(_tokens_with_bonuses); 
391     tokensBought[_to] = tokensBought[_to].add(_tokens_with_bonuses); // tokens in wei
392 
393     uint256 _soldInETH = _tokens.div( rate ); // Calc without bonuses
394     
395     _sold = _sold.add(_soldInETH); // in wei
396     _soldOutside = _soldOutside.add(_soldInETH); // eth
397     _soldOutsidePMZ = _soldOutsidePMZ.add(_tokens_with_bonuses); // in PMZ
398   }
399 
400   /**
401    * @dev Function to mint tokens
402    * @param _to The address that will receive the minted tokens.
403    * @param _amount The amount of tokens to mint.
404    * @return A boolean that indicates if the operation was successful.
405    */
406   function mint(address _to, uint256 _amount) internal {
407     totalSupply_ = totalSupply_.add(_amount);
408     balances[_to] = balances[_to].add(_amount);
409     emit Transfer(address(this), _to, _amount);
410   }
411 
412     /**
413    * @dev The way in which ether is converted to tokens.
414    * @param _weiAmount Value in wei to be converted into tokens
415    * @param _bonus Bonus in percents
416    * @return Number of tokens that can be purchased with the specified _weiAmount
417    */
418   function _getTokenAmount(uint256 _weiAmount, uint _bonus) internal view returns (uint256) {
419     uint256 _coins_in_wei = rate.mul(_weiAmount);
420     uint256 _bonus_value_in_wei = 0;
421     uint256 bonusValue = 0;
422 
423     _bonus_value_in_wei = (_coins_in_wei.mul(_bonus)).div(100);
424     bonusValue = _bonus_value_in_wei;
425 
426     uint256 coins = _coins_in_wei;
427     uint256 total = coins.add(bonusValue);
428 
429     return total;
430   }
431 
432   /**
433    * @dev sets a rate for ico rounds
434    * @param _rate Rate for token
435    */
436   function setRate(uint256 _rate) public {
437     require(msg.sender == owner);
438     require(_rate > 0);
439 
440     rate = _rate;
441   }
442 
443   /// @dev get total coins sold per current round
444   function soldPerCurrentRound() public view returns (uint256) {
445     return rounds[_getCurrentRound(now)].soldCoins;
446   }
447 
448   /// @dev pause and unpause an ICO, only sender allowed to
449   function triggerICOState(bool state) public onlyOwner {
450     isPaused = state;
451   }
452 
453   /**
454    * @dev changes current bonus rate
455    * @param _bonus Bonus to change
456    * @return bool - Changed or not
457    */
458   function setBonus(uint256 _bonus) onlyOwner public {
459     require(_bonus >= 0 && _bonus <= 100); //%
460     bonus = _bonus;
461   }
462 
463   /// @dev gets number of current round
464   function _getCurrentRound(uint256 _time) public view returns (uint8) {
465     for (uint8 i = 0; i < 6; i++) {
466       if (rounds[i].openingTime < _time && rounds[i].closingTime > _time) {
467         return i;
468       }
469     }
470 
471     return 100; // if using 6 in 5 length array it will throw
472   }
473 
474   function setRoundParams(
475     uint8 _round,
476     uint256 _openingTime,
477     uint256 _closingTime,
478     uint256 _maxPurchase,
479     uint256 _minPurchase,
480     uint256 _allocatedCoins
481   ) public onlyOwner {
482     rounds[_round].openingTime = _openingTime;
483     rounds[_round].closingTime = _closingTime;
484     rounds[_round].maxPurchase = _maxPurchase;
485     rounds[_round].minPurchase = _minPurchase;
486     rounds[_round].allocatedCoins = _allocatedCoins;
487   }
488 
489   /**
490    * @dev withdrawing funds to founder's wallet
491    * @return bool Whether success or not
492    */
493   function withdraw() public {
494     // only founder is able to withdraw funds
495     require(msg.sender == founder);
496     founder.transfer(address(this).balance);
497   }
498 
499   /**
500    * @dev Claims for refund if ICO finished and soft cap not reached
501    */
502   function refund() public whenICOFinished capNotReached {
503     require(investments[msg.sender] > 0);
504     msg.sender.transfer(investments[msg.sender]);
505     investments[msg.sender] = 0;
506   }
507 
508   modifier onlyWhileOpen {
509     uint8 _round = _getCurrentRound(now);
510     require(_round >= 0 && _round <= 5); // we have 6 rounds, other values are invalid
511     _;
512   }
513 
514   /// @dev when ico finishes we can perform other actions
515   modifier whenICOFinished {
516     uint8 _round = _getCurrentRound(now);
517     require(_round < 0 || _round > 5); // if we do not get current valid round number ICO finished
518     _;
519   }
520 
521   /// @dev _sold in weis, softCap in weis
522   modifier capNotReached {
523     require(softCap > _sold);
524     _;
525   }
526 
527   /// @dev if isPaused true then investments cannot be accepted
528   modifier isNotPaused {
529     require(!isPaused);
530     _;
531   }
532 
533 }