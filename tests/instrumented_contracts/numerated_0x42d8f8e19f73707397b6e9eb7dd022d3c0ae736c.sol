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
119 // File: contracts/FUTBTiers.sol
120 
121 contract FUTBTiers is Ownable {
122   using SafeMath for uint256;
123 
124   uint public offset = 10**8;
125   struct Tier {
126     uint futb;
127     uint futrx;
128     uint rate;
129   }
130   mapping(uint16 => Tier) public tiers;
131 
132   constructor() public {
133   }
134 
135   function addTiers(uint16 _startingTier, uint[] _futb, uint[] _futrx) external {
136     require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
137     require(_futb.length == _futrx.length);
138     for (uint16 i = 0; i < _futb.length; i++) {
139       tiers[_startingTier + i] = Tier(_futb[i], _futrx[i], uint(_futb[i]).div(uint(_futrx[i]).div(offset)));
140     }
141   }
142 
143   function getTier(uint16 tier) public view returns (uint futb, uint futrx, uint rate) {
144     Tier t = tiers[tier];
145     return (t.futb, t.futrx, t.rate);
146   }
147 
148   address public dev = 0x89ec1273a56f232d96cd17c08e9f129e15cf16f1;
149   function changeDev (address _receiver) external {
150     require(msg.sender == dev);
151     dev = _receiver;
152   }
153 
154   address public admin = 0x89ec1273a56f232d96cd17c08e9f129e15cf16f1;
155   function changeAdmin (address _receiver) external {
156     require(msg.sender == admin);
157     admin = _receiver;
158   }
159 
160   function loadData() external {
161     require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
162     tiers[1] = Tier(6.597 ether, 0.0369 ether, uint(6.597 ether).div(uint(0.0369 ether).div(offset)));
163     tiers[2] = Tier(9.5117 ether, 0.0531 ether, uint(9.5117 ether).div(uint(0.0531 ether).div(offset)));
164     tiers[3] = Tier(5.8799 ether, 0.0292 ether, uint(5.8799 ether).div(uint(0.0292 ether).div(offset)));
165     tiers[4] = Tier(7.7979 ether, 0.0338 ether, uint(7.7979 ether).div(uint(0.0338 ether).div(offset)));
166     tiers[5] = Tier(7.6839 ether, 0.0385 ether, uint(7.6839 ether).div(uint(0.0385 ether).div(offset)));
167     tiers[6] = Tier(6.9612 ether, 0.0215 ether, uint(6.9612 ether).div(uint(0.0215 ether).div(offset)));
168     tiers[7] = Tier(7.1697 ether, 0.0269 ether, uint(7.1697 ether).div(uint(0.0269 ether).div(offset)));
169     tiers[8] = Tier(6.2356 ether, 0.0192 ether, uint(6.2356 ether).div(uint(0.0192 ether).div(offset)));
170     tiers[9] = Tier(5.6619 ether, 0.0177 ether, uint(5.6619 ether).div(uint(0.0177 ether).div(offset)));
171     tiers[10] = Tier(6.1805 ether, 0.0231 ether, uint(6.1805 ether).div(uint(0.0231 ether).div(offset)));
172     tiers[11] = Tier(6.915 ether, 0.0262 ether, uint(6.915 ether).div(uint(0.0262 ether).div(offset)));
173     tiers[12] = Tier(8.7151 ether, 0.0323 ether, uint(8.7151 ether).div(uint(0.0323 ether).div(offset)));
174     tiers[13] = Tier(23.8751 ether, 0.1038 ether, uint(23.8751 ether).div(uint(0.1038 ether).div(offset)));
175     tiers[14] = Tier(7.0588 ether, 0.0262 ether, uint(7.0588 ether).div(uint(0.0262 ether).div(offset)));
176     tiers[15] = Tier(13.441 ether, 0.0585 ether, uint(13.441 ether).div(uint(0.0585 ether).div(offset)));
177     tiers[16] = Tier(6.7596 ether, 0.0254 ether, uint(6.7596 ether).div(uint(0.0254 ether).div(offset)));
178     tiers[17] = Tier(9.3726 ether, 0.0346 ether, uint(9.3726 ether).div(uint(0.0346 ether).div(offset)));
179     tiers[18] = Tier(7.1789 ether, 0.0269 ether, uint(7.1789 ether).div(uint(0.0269 ether).div(offset)));
180     tiers[19] = Tier(5.8699 ether, 0.0215 ether, uint(5.8699 ether).div(uint(0.0215 ether).div(offset)));
181     tiers[20] = Tier(8.3413 ether, 0.0308 ether, uint(8.3413 ether).div(uint(0.0308 ether).div(offset)));
182     tiers[21] = Tier(6.8338 ether, 0.0254 ether, uint(6.8338 ether).div(uint(0.0254 ether).div(offset)));
183     tiers[22] = Tier(6.1386 ether, 0.0231 ether, uint(6.1386 ether).div(uint(0.0231 ether).div(offset)));
184     tiers[23] = Tier(6.7469 ether, 0.0254 ether, uint(6.7469 ether).div(uint(0.0254 ether).div(offset)));
185     tiers[24] = Tier(9.9626 ether, 0.0431 ether, uint(9.9626 ether).div(uint(0.0431 ether).div(offset)));
186     tiers[25] = Tier(18.046 ether, 0.0785 ether, uint(18.046 ether).div(uint(0.0785 ether).div(offset)));
187     tiers[26] = Tier(10.2918 ether, 0.0446 ether, uint(10.2918 ether).div(uint(0.0446 ether).div(offset)));
188     tiers[27] = Tier(56.3078 ether, 0.2454 ether, uint(56.3078 ether).div(uint(0.2454 ether).div(offset)));
189     tiers[28] = Tier(17.2519 ether, 0.0646 ether, uint(17.2519 ether).div(uint(0.0646 ether).div(offset)));
190     tiers[29] = Tier(12.1003 ether, 0.0531 ether, uint(12.1003 ether).div(uint(0.0531 ether).div(offset)));
191     tiers[30] = Tier(14.4506 ether, 0.0631 ether, uint(14.4506 ether).div(uint(0.0631 ether).div(offset)));
192   }
193 }
194 
195 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
196 
197 /**
198  * @title ERC20Basic
199  * @dev Simpler version of ERC20 interface
200  * See https://github.com/ethereum/EIPs/issues/179
201  */
202 contract ERC20Basic {
203   function totalSupply() public view returns (uint256);
204   function balanceOf(address _who) public view returns (uint256);
205   function transfer(address _to, uint256 _value) public returns (bool);
206   event Transfer(address indexed from, address indexed to, uint256 value);
207 }
208 
209 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
210 
211 /**
212  * @title Basic token
213  * @dev Basic version of StandardToken, with no allowances.
214  */
215 contract BasicToken is ERC20Basic {
216   using SafeMath for uint256;
217 
218   mapping(address => uint256) internal balances;
219 
220   uint256 internal totalSupply_;
221 
222   /**
223   * @dev Total number of tokens in existence
224   */
225   function totalSupply() public view returns (uint256) {
226     return totalSupply_;
227   }
228 
229   /**
230   * @dev Transfer token for a specified address
231   * @param _to The address to transfer to.
232   * @param _value The amount to be transferred.
233   */
234   function transfer(address _to, uint256 _value) public returns (bool) {
235     require(_value <= balances[msg.sender]);
236     require(_to != address(0));
237 
238     balances[msg.sender] = balances[msg.sender].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     emit Transfer(msg.sender, _to, _value);
241     return true;
242   }
243 
244   /**
245   * @dev Gets the balance of the specified address.
246   * @param _owner The address to query the the balance of.
247   * @return An uint256 representing the amount owned by the passed address.
248   */
249   function balanceOf(address _owner) public view returns (uint256) {
250     return balances[_owner];
251   }
252 
253 }
254 
255 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
256 
257 /**
258  * @title Burnable Token
259  * @dev Token that can be irreversibly burned (destroyed).
260  */
261 contract BurnableToken is BasicToken {
262 
263   event Burn(address indexed burner, uint256 value);
264 
265   /**
266    * @dev Burns a specific amount of tokens.
267    * @param _value The amount of token to be burned.
268    */
269   function burn(uint256 _value) public {
270     _burn(msg.sender, _value);
271   }
272 
273   function _burn(address _who, uint256 _value) internal {
274     require(_value <= balances[_who]);
275     // no need to require value <= totalSupply, since that would imply the
276     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
277 
278     balances[_who] = balances[_who].sub(_value);
279     totalSupply_ = totalSupply_.sub(_value);
280     emit Burn(_who, _value);
281     emit Transfer(_who, address(0), _value);
282   }
283 }
284 
285 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
286 
287 /**
288  * @title ERC20 interface
289  * @dev see https://github.com/ethereum/EIPs/issues/20
290  */
291 contract ERC20 is ERC20Basic {
292   function allowance(address _owner, address _spender)
293     public view returns (uint256);
294 
295   function transferFrom(address _from, address _to, uint256 _value)
296     public returns (bool);
297 
298   function approve(address _spender, uint256 _value) public returns (bool);
299   event Approval(
300     address indexed owner,
301     address indexed spender,
302     uint256 value
303   );
304 }
305 
306 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
307 
308 /**
309  * @title Standard ERC20 token
310  *
311  * @dev Implementation of the basic standard token.
312  * https://github.com/ethereum/EIPs/issues/20
313  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
314  */
315 contract StandardToken is ERC20, BasicToken {
316 
317   mapping (address => mapping (address => uint256)) internal allowed;
318 
319 
320   /**
321    * @dev Transfer tokens from one address to another
322    * @param _from address The address which you want to send tokens from
323    * @param _to address The address which you want to transfer to
324    * @param _value uint256 the amount of tokens to be transferred
325    */
326   function transferFrom(
327     address _from,
328     address _to,
329     uint256 _value
330   )
331     public
332     returns (bool)
333   {
334     require(_value <= balances[_from]);
335     require(_value <= allowed[_from][msg.sender]);
336     require(_to != address(0));
337 
338     balances[_from] = balances[_from].sub(_value);
339     balances[_to] = balances[_to].add(_value);
340     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
341     emit Transfer(_from, _to, _value);
342     return true;
343   }
344 
345   /**
346    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
347    * Beware that changing an allowance with this method brings the risk that someone may use both the old
348    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
349    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
350    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351    * @param _spender The address which will spend the funds.
352    * @param _value The amount of tokens to be spent.
353    */
354   function approve(address _spender, uint256 _value) public returns (bool) {
355     allowed[msg.sender][_spender] = _value;
356     emit Approval(msg.sender, _spender, _value);
357     return true;
358   }
359 
360   /**
361    * @dev Function to check the amount of tokens that an owner allowed to a spender.
362    * @param _owner address The address which owns the funds.
363    * @param _spender address The address which will spend the funds.
364    * @return A uint256 specifying the amount of tokens still available for the spender.
365    */
366   function allowance(
367     address _owner,
368     address _spender
369    )
370     public
371     view
372     returns (uint256)
373   {
374     return allowed[_owner][_spender];
375   }
376 
377   /**
378    * @dev Increase the amount of tokens that an owner allowed to a spender.
379    * approve should be called when allowed[_spender] == 0. To increment
380    * allowed value is better to use this function to avoid 2 calls (and wait until
381    * the first transaction is mined)
382    * From MonolithDAO Token.sol
383    * @param _spender The address which will spend the funds.
384    * @param _addedValue The amount of tokens to increase the allowance by.
385    */
386   function increaseApproval(
387     address _spender,
388     uint256 _addedValue
389   )
390     public
391     returns (bool)
392   {
393     allowed[msg.sender][_spender] = (
394       allowed[msg.sender][_spender].add(_addedValue));
395     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
396     return true;
397   }
398 
399   /**
400    * @dev Decrease the amount of tokens that an owner allowed to a spender.
401    * approve should be called when allowed[_spender] == 0. To decrement
402    * allowed value is better to use this function to avoid 2 calls (and wait until
403    * the first transaction is mined)
404    * From MonolithDAO Token.sol
405    * @param _spender The address which will spend the funds.
406    * @param _subtractedValue The amount of tokens to decrease the allowance by.
407    */
408   function decreaseApproval(
409     address _spender,
410     uint256 _subtractedValue
411   )
412     public
413     returns (bool)
414   {
415     uint256 oldValue = allowed[msg.sender][_spender];
416     if (_subtractedValue >= oldValue) {
417       allowed[msg.sender][_spender] = 0;
418     } else {
419       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
420     }
421     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
422     return true;
423   }
424 
425 }
426 
427 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
428 
429 /**
430  * @title Mintable token
431  * @dev Simple ERC20 Token example, with mintable token creation
432  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
433  */
434 contract MintableToken is StandardToken, Ownable {
435   event Mint(address indexed to, uint256 amount);
436   event MintFinished();
437 
438   bool public mintingFinished = false;
439 
440 
441   modifier canMint() {
442     require(!mintingFinished);
443     _;
444   }
445 
446   modifier hasMintPermission() {
447     require(msg.sender == owner);
448     _;
449   }
450 
451   /**
452    * @dev Function to mint tokens
453    * @param _to The address that will receive the minted tokens.
454    * @param _amount The amount of tokens to mint.
455    * @return A boolean that indicates if the operation was successful.
456    */
457   function mint(
458     address _to,
459     uint256 _amount
460   )
461     public
462     hasMintPermission
463     canMint
464     returns (bool)
465   {
466     totalSupply_ = totalSupply_.add(_amount);
467     balances[_to] = balances[_to].add(_amount);
468     emit Mint(_to, _amount);
469     emit Transfer(address(0), _to, _amount);
470     return true;
471   }
472 
473   /**
474    * @dev Function to stop minting new tokens.
475    * @return True if the operation was successful.
476    */
477   function finishMinting() public onlyOwner canMint returns (bool) {
478     mintingFinished = true;
479     emit MintFinished();
480     return true;
481   }
482 }
483 
484 // File: contracts/FUTB.sol
485 
486 contract FUTB is StandardToken, MintableToken, BurnableToken {
487   using SafeMath for uint256;
488 
489   string public constant name = "Futereum BTC";
490   string public constant symbol = "FUTB";
491   uint8 public constant decimals = 18;
492   uint public constant SWAP_CAP = 21000000 * (10 ** uint256(decimals));
493   uint public cycleMintSupply = 0;
494   FUTBTiers public tierContract = FUTBTiers(0x4dd013b9e784c459fe5f82aa926534506ce25eaf);
495 
496   event SwapStarted(uint256 endTime);
497   event MiningRestart(uint16 tier);
498   event MiningTokenAdded(address token, uint ratio);
499   event MiningTokenAdjusted(address token, uint ratio);
500 
501   uint public offset = 10**8;
502   uint public decimalOffset = 10 ** uint256(decimals);
503   uint public baseRate = 100;
504   mapping(address => uint) public exchangeRatios;
505   mapping(address => uint) public unPaidFees;
506   address[] public miningTokens;
507   address public admin;
508   address public tierAdmin;
509   address public FUTC = 0xdaa6CD28E6aA9d656930cE4BB4FA93eEC96ee791;
510 
511   //initial state
512   uint16 public currentTier = 1;
513   uint public futbLeftInCurrent = 6.597 ether;
514   uint public miningTokenLeftInCurrent = 0.0369 ether;
515   uint public currentRate = futbLeftInCurrent.div(miningTokenLeftInCurrent.div(offset));
516   bool public isMiningOpen = false;
517   bool public miningActive = false;
518   uint16 public lastTier = 2856;
519 
520   constructor() public {
521     totalSupply_ = 0;
522     //only the contract itself can mint as the owner
523     owner = this;
524     admin = msg.sender;
525     tierAdmin = msg.sender;
526   }
527 
528   modifier canMine() {
529     require(isMiningOpen);
530     _;
531   }
532 
533   modifier onlyAdmin() {
534     require(msg.sender == admin);
535     _;
536   }
537 
538   modifier onlyTierAdmin() {
539     require(msg.sender == tierAdmin);
540     _;
541   }
542 
543   // first call Token(address).approve(futb address, amount) for FUTB to transfer on your behalf.
544   function mine(address token, uint amount) canMine external {
545     require(token != 0 && amount > 0);
546     require(exchangeRatios[token] > 0 && cycleMintSupply < SWAP_CAP);
547     require(ERC20(token).transferFrom(msg.sender, this, amount));
548     _mine(token, amount);
549   }
550 
551   function _mine(address _token, uint256 _inAmount) private {
552     if (!miningActive) {
553       miningActive = true;
554     }
555     uint _tokens = 0;
556     uint miningPower = _inAmount.mul(exchangeRatios[_token]).div(baseRate);
557     uint fee = _inAmount.div(2);
558 
559     while (miningPower > 0) {
560       if (miningPower >= miningTokenLeftInCurrent) {
561         miningPower -= miningTokenLeftInCurrent;
562         _tokens += futbLeftInCurrent;
563         miningTokenLeftInCurrent = 0;
564         futbLeftInCurrent = 0;
565       } else {
566         uint calculatedFutb = currentRate.mul(miningPower).div(offset);
567         _tokens += calculatedFutb;
568         futbLeftInCurrent -= calculatedFutb;
569         miningTokenLeftInCurrent -= miningPower;
570         miningPower = 0;
571       }
572 
573       if (miningTokenLeftInCurrent == 0) {
574         if (currentTier == lastTier) {
575           _tokens = SWAP_CAP - cycleMintSupply;
576           if (miningPower > 0) {
577             uint refund = miningPower.mul(baseRate).div(exchangeRatios[_token]);
578             fee -= refund.div(2);
579             ERC20(_token).transfer(msg.sender, refund);
580           }
581           // Open swap
582           _startSwap();
583           break;
584         }
585         currentTier++;
586         (futbLeftInCurrent, miningTokenLeftInCurrent, currentRate) = tierContract.getTier(currentTier);
587       }
588     }
589     cycleMintSupply += _tokens;
590     MintableToken(this).mint(msg.sender, _tokens);
591     ERC20(_token).transfer(FUTC, fee);
592   }
593 
594   // swap data
595   bool public swapOpen = false;
596   uint public swapEndTime;
597   mapping(address => uint) public swapRates;
598 
599   function _startSwap() private {
600     swapEndTime = now + 30 days;
601     swapOpen = true;
602     isMiningOpen = false;
603     miningActive = false;
604 
605     //set swap rates
606     for (uint16 i = 0; i < miningTokens.length; i++) {
607       address _token = miningTokens[i];
608       uint swapAmt = ERC20(_token).balanceOf(this);
609       swapRates[_token] = swapAmt.div(SWAP_CAP.div(decimalOffset));
610     }
611     emit SwapStarted(swapEndTime);
612   }
613 
614   function swap(uint amt) public {
615     require(swapOpen && cycleMintSupply > 0);
616     if (amt > cycleMintSupply) {
617       amt = cycleMintSupply;
618     }
619     cycleMintSupply -= amt;
620     // burn verifies msg.sender has balance
621     burn(amt);
622     for (uint16 i = 0; i < miningTokens.length; i++) {
623       address _token = miningTokens[i];
624       ERC20(_token).transfer(msg.sender, amt.mul(swapRates[_token]).div(decimalOffset));
625     }
626   }
627 
628   function restart() external {
629     require(swapOpen);
630     require(now > swapEndTime || cycleMintSupply == 0);
631     cycleMintSupply = 0;
632     swapOpen = false;
633     swapEndTime = 0;
634     isMiningOpen = true;
635 
636     // 20% penalty for unswapped tokens
637     for (uint16 i = 0; i < miningTokens.length; i++) {
638       address _token = miningTokens[i];
639       uint amtLeft = ERC20(_token).balanceOf(this);
640       ERC20(_token).transfer(FUTC, amtLeft.div(5));
641     }
642 
643     currentTier = 1;
644     futbLeftInCurrent = 6.597 ether;
645     miningTokenLeftInCurrent = 0.0369 ether;
646     currentRate = futbLeftInCurrent.div(miningTokenLeftInCurrent.div(offset));
647     emit MiningRestart(currentTier);
648   }
649 
650   function setIsMiningOpen(bool isOpen) onlyTierAdmin external {
651     isMiningOpen = isOpen;
652   }
653 
654   // base rate is 100, so for 1 to 1 send in 100 as ratio
655   function addMiningToken(address tokenAddr, uint ratio) onlyAdmin external {
656     require(exchangeRatios[tokenAddr] == 0 && ratio > 0 && ratio < 10000);
657     exchangeRatios[tokenAddr] = ratio;
658 
659     bool found = false;
660     for (uint16 i = 0; i < miningTokens.length; i++) {
661       if (miningTokens[i] == tokenAddr) {
662         found = true;
663         break;
664       }
665     }
666     if (!found) {
667       miningTokens.push(tokenAddr);
668     }
669     emit MiningTokenAdded(tokenAddr, ratio);
670   }
671 
672   function adjustTokenRate(address tokenAddr, uint ratio, uint16 position) onlyAdmin external {
673     require(miningTokens[position] == tokenAddr && ratio < 10000);
674     exchangeRatios[tokenAddr] = ratio;
675     emit MiningTokenAdjusted(tokenAddr, ratio);
676   }
677 
678   // can only add/change tier contract in between mining cycles
679   function setFutbTiers(address _tiersAddr) onlyTierAdmin external {
680     require(!miningActive);
681     tierContract = FUTBTiers(_tiersAddr);
682   }
683 
684   // use this to lock the contract from further changes to mining tokens
685   function lockContract() onlyAdmin external {
686     require(miningActive);
687     admin = address(0);
688   }
689 
690   // this allows us to use a different set of tiers
691   // can only be changed in between mining cycles by admin
692   function setLastTier(uint16 _lastTier) onlyAdmin external {
693     require(swapOpen);
694     lastTier = _lastTier;
695   }
696 
697   function changeAdmin (address _receiver) onlyAdmin external {
698     admin = _receiver;
699   }
700 
701   function changeTierAdmin (address _receiver) onlyTierAdmin external {
702     tierAdmin = _receiver;
703   }
704 }