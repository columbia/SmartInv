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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
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
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: contracts/MNYTiers.sol
117 
118 contract MNYTiers is Ownable {
119   using SafeMath for uint256;
120 
121   uint public offset = 10**8;
122   struct Tier {
123     uint mny;
124     uint futrx;
125     uint rate;
126   }
127   mapping(uint16 => Tier) public tiers;
128 
129   constructor() public {
130   }
131 
132   function addTiers(uint16 _startingTier, uint[] _mny, uint[] _futrx) public {
133     require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
134     require(_mny.length == _futrx.length);
135     for (uint16 i = 0; i < _mny.length; i++) {
136       tiers[_startingTier + i] = Tier(_mny[i], _futrx[i], uint(_mny[i]).div(uint(_futrx[i]).div(offset)));
137     }
138   }
139 
140   function getTier(uint16 tier) public view returns (uint mny, uint futrx, uint rate) {
141     Tier t = tiers[tier];
142     return (t.mny, t.futrx, t.rate);
143   }
144 
145   address public dev = 0xa694a1fce7e6737209acb71bdec807c5aca26365;
146   function changeDev (address _receiver) public {
147     require(msg.sender == dev);
148     dev = _receiver;
149   }
150 
151   address public admin = 0x1e9b5a68023ef905e2440ea232c097a0f3ee3c87;
152   function changeAdmin (address _receiver) public {
153     require(msg.sender == admin);
154     admin = _receiver;
155   }
156 
157   function loadData() public {
158     require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
159     tiers[1] = Tier(6.597 ether, 0.0369 ether, uint(6.597 ether).div(uint(0.0369 ether).div(offset)));
160     tiers[2] = Tier(9.5117 ether, 0.0531 ether, uint(9.5117 ether).div(uint(0.0531 ether).div(offset)));
161     tiers[3] = Tier(5.8799 ether, 0.0292 ether, uint(5.8799 ether).div(uint(0.0292 ether).div(offset)));
162     tiers[4] = Tier(7.7979 ether, 0.0338 ether, uint(7.7979 ether).div(uint(0.0338 ether).div(offset)));
163     tiers[5] = Tier(7.6839 ether, 0.0385 ether, uint(7.6839 ether).div(uint(0.0385 ether).div(offset)));
164     tiers[6] = Tier(6.9612 ether, 0.0215 ether, uint(6.9612 ether).div(uint(0.0215 ether).div(offset)));
165     tiers[7] = Tier(7.1697 ether, 0.0269 ether, uint(7.1697 ether).div(uint(0.0269 ether).div(offset)));
166     tiers[8] = Tier(6.2356 ether, 0.0192 ether, uint(6.2356 ether).div(uint(0.0192 ether).div(offset)));
167     tiers[9] = Tier(5.6619 ether, 0.0177 ether, uint(5.6619 ether).div(uint(0.0177 ether).div(offset)));
168     tiers[10] = Tier(6.1805 ether, 0.0231 ether, uint(6.1805 ether).div(uint(0.0231 ether).div(offset)));
169     tiers[11] = Tier(6.915 ether, 0.0262 ether, uint(6.915 ether).div(uint(0.0262 ether).div(offset)));
170     tiers[12] = Tier(8.7151 ether, 0.0323 ether, uint(8.7151 ether).div(uint(0.0323 ether).div(offset)));
171     tiers[13] = Tier(23.8751 ether, 0.1038 ether, uint(23.8751 ether).div(uint(0.1038 ether).div(offset)));
172     tiers[14] = Tier(7.0588 ether, 0.0262 ether, uint(7.0588 ether).div(uint(0.0262 ether).div(offset)));
173     tiers[15] = Tier(13.441 ether, 0.0585 ether, uint(13.441 ether).div(uint(0.0585 ether).div(offset)));
174     tiers[16] = Tier(6.7596 ether, 0.0254 ether, uint(6.7596 ether).div(uint(0.0254 ether).div(offset)));
175     tiers[17] = Tier(9.3726 ether, 0.0346 ether, uint(9.3726 ether).div(uint(0.0346 ether).div(offset)));
176     tiers[18] = Tier(7.1789 ether, 0.0269 ether, uint(7.1789 ether).div(uint(0.0269 ether).div(offset)));
177     tiers[19] = Tier(5.8699 ether, 0.0215 ether, uint(5.8699 ether).div(uint(0.0215 ether).div(offset)));
178     tiers[20] = Tier(8.3413 ether, 0.0308 ether, uint(8.3413 ether).div(uint(0.0308 ether).div(offset)));
179     tiers[21] = Tier(6.8338 ether, 0.0254 ether, uint(6.8338 ether).div(uint(0.0254 ether).div(offset)));
180     tiers[22] = Tier(6.1386 ether, 0.0231 ether, uint(6.1386 ether).div(uint(0.0231 ether).div(offset)));
181     tiers[23] = Tier(6.7469 ether, 0.0254 ether, uint(6.7469 ether).div(uint(0.0254 ether).div(offset)));
182     tiers[24] = Tier(9.9626 ether, 0.0431 ether, uint(9.9626 ether).div(uint(0.0431 ether).div(offset)));
183     tiers[25] = Tier(18.046 ether, 0.0785 ether, uint(18.046 ether).div(uint(0.0785 ether).div(offset)));
184     tiers[26] = Tier(10.2918 ether, 0.0446 ether, uint(10.2918 ether).div(uint(0.0446 ether).div(offset)));
185     tiers[27] = Tier(56.3078 ether, 0.2454 ether, uint(56.3078 ether).div(uint(0.2454 ether).div(offset)));
186     tiers[28] = Tier(17.2519 ether, 0.0646 ether, uint(17.2519 ether).div(uint(0.0646 ether).div(offset)));
187     tiers[29] = Tier(12.1003 ether, 0.0531 ether, uint(12.1003 ether).div(uint(0.0531 ether).div(offset)));
188     tiers[30] = Tier(14.4506 ether, 0.0631 ether, uint(14.4506 ether).div(uint(0.0631 ether).div(offset)));
189   }
190 }
191 
192 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
193 
194 /**
195  * @title ERC20Basic
196  * @dev Simpler version of ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/179
198  */
199 contract ERC20Basic {
200   function totalSupply() public view returns (uint256);
201   function balanceOf(address who) public view returns (uint256);
202   function transfer(address to, uint256 value) public returns (bool);
203   event Transfer(address indexed from, address indexed to, uint256 value);
204 }
205 
206 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
207 
208 /**
209  * @title Basic token
210  * @dev Basic version of StandardToken, with no allowances.
211  */
212 contract BasicToken is ERC20Basic {
213   using SafeMath for uint256;
214 
215   mapping(address => uint256) balances;
216 
217   uint256 totalSupply_;
218 
219   /**
220   * @dev total number of tokens in existence
221   */
222   function totalSupply() public view returns (uint256) {
223     return totalSupply_;
224   }
225 
226   /**
227   * @dev transfer token for a specified address
228   * @param _to The address to transfer to.
229   * @param _value The amount to be transferred.
230   */
231   function transfer(address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[msg.sender]);
234 
235     balances[msg.sender] = balances[msg.sender].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     emit Transfer(msg.sender, _to, _value);
238     return true;
239   }
240 
241   /**
242   * @dev Gets the balance of the specified address.
243   * @param _owner The address to query the the balance of.
244   * @return An uint256 representing the amount owned by the passed address.
245   */
246   function balanceOf(address _owner) public view returns (uint256) {
247     return balances[_owner];
248   }
249 
250 }
251 
252 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
253 
254 /**
255  * @title Burnable Token
256  * @dev Token that can be irreversibly burned (destroyed).
257  */
258 contract BurnableToken is BasicToken {
259 
260   event Burn(address indexed burner, uint256 value);
261 
262   /**
263    * @dev Burns a specific amount of tokens.
264    * @param _value The amount of token to be burned.
265    */
266   function burn(uint256 _value) public {
267     _burn(msg.sender, _value);
268   }
269 
270   function _burn(address _who, uint256 _value) internal {
271     require(_value <= balances[_who]);
272     // no need to require value <= totalSupply, since that would imply the
273     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
274 
275     balances[_who] = balances[_who].sub(_value);
276     totalSupply_ = totalSupply_.sub(_value);
277     emit Burn(_who, _value);
278     emit Transfer(_who, address(0), _value);
279   }
280 }
281 
282 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
283 
284 /**
285  * @title ERC20 interface
286  * @dev see https://github.com/ethereum/EIPs/issues/20
287  */
288 contract ERC20 is ERC20Basic {
289   function allowance(address owner, address spender)
290     public view returns (uint256);
291 
292   function transferFrom(address from, address to, uint256 value)
293     public returns (bool);
294 
295   function approve(address spender, uint256 value) public returns (bool);
296   event Approval(
297     address indexed owner,
298     address indexed spender,
299     uint256 value
300   );
301 }
302 
303 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
304 
305 /**
306  * @title Standard ERC20 token
307  *
308  * @dev Implementation of the basic standard token.
309  * @dev https://github.com/ethereum/EIPs/issues/20
310  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
311  */
312 contract StandardToken is ERC20, BasicToken {
313 
314   mapping (address => mapping (address => uint256)) internal allowed;
315 
316 
317   /**
318    * @dev Transfer tokens from one address to another
319    * @param _from address The address which you want to send tokens from
320    * @param _to address The address which you want to transfer to
321    * @param _value uint256 the amount of tokens to be transferred
322    */
323   function transferFrom(
324     address _from,
325     address _to,
326     uint256 _value
327   )
328     public
329     returns (bool)
330   {
331     require(_to != address(0));
332     require(_value <= balances[_from]);
333     require(_value <= allowed[_from][msg.sender]);
334 
335     balances[_from] = balances[_from].sub(_value);
336     balances[_to] = balances[_to].add(_value);
337     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
338     emit Transfer(_from, _to, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
344    *
345    * Beware that changing an allowance with this method brings the risk that someone may use both the old
346    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
347    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
348    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349    * @param _spender The address which will spend the funds.
350    * @param _value The amount of tokens to be spent.
351    */
352   function approve(address _spender, uint256 _value) public returns (bool) {
353     allowed[msg.sender][_spender] = _value;
354     emit Approval(msg.sender, _spender, _value);
355     return true;
356   }
357 
358   /**
359    * @dev Function to check the amount of tokens that an owner allowed to a spender.
360    * @param _owner address The address which owns the funds.
361    * @param _spender address The address which will spend the funds.
362    * @return A uint256 specifying the amount of tokens still available for the spender.
363    */
364   function allowance(
365     address _owner,
366     address _spender
367    )
368     public
369     view
370     returns (uint256)
371   {
372     return allowed[_owner][_spender];
373   }
374 
375   /**
376    * @dev Increase the amount of tokens that an owner allowed to a spender.
377    *
378    * approve should be called when allowed[_spender] == 0. To increment
379    * allowed value is better to use this function to avoid 2 calls (and wait until
380    * the first transaction is mined)
381    * From MonolithDAO Token.sol
382    * @param _spender The address which will spend the funds.
383    * @param _addedValue The amount of tokens to increase the allowance by.
384    */
385   function increaseApproval(
386     address _spender,
387     uint _addedValue
388   )
389     public
390     returns (bool)
391   {
392     allowed[msg.sender][_spender] = (
393       allowed[msg.sender][_spender].add(_addedValue));
394     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
395     return true;
396   }
397 
398   /**
399    * @dev Decrease the amount of tokens that an owner allowed to a spender.
400    *
401    * approve should be called when allowed[_spender] == 0. To decrement
402    * allowed value is better to use this function to avoid 2 calls (and wait until
403    * the first transaction is mined)
404    * From MonolithDAO Token.sol
405    * @param _spender The address which will spend the funds.
406    * @param _subtractedValue The amount of tokens to decrease the allowance by.
407    */
408   function decreaseApproval(
409     address _spender,
410     uint _subtractedValue
411   )
412     public
413     returns (bool)
414   {
415     uint oldValue = allowed[msg.sender][_spender];
416     if (_subtractedValue > oldValue) {
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
432  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
433  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
434  */
435 contract MintableToken is StandardToken, Ownable {
436   event Mint(address indexed to, uint256 amount);
437   event MintFinished();
438 
439   bool public mintingFinished = false;
440 
441 
442   modifier canMint() {
443     require(!mintingFinished);
444     _;
445   }
446 
447   modifier hasMintPermission() {
448     require(msg.sender == owner);
449     _;
450   }
451 
452   /**
453    * @dev Function to mint tokens
454    * @param _to The address that will receive the minted tokens.
455    * @param _amount The amount of tokens to mint.
456    * @return A boolean that indicates if the operation was successful.
457    */
458   function mint(
459     address _to,
460     uint256 _amount
461   )
462     hasMintPermission
463     canMint
464     public
465     returns (bool)
466   {
467     totalSupply_ = totalSupply_.add(_amount);
468     balances[_to] = balances[_to].add(_amount);
469     emit Mint(_to, _amount);
470     emit Transfer(address(0), _to, _amount);
471     return true;
472   }
473 
474   /**
475    * @dev Function to stop minting new tokens.
476    * @return True if the operation was successful.
477    */
478   function finishMinting() onlyOwner canMint public returns (bool) {
479     mintingFinished = true;
480     emit MintFinished();
481     return true;
482   }
483 }
484 
485 // File: contracts/MNY.sol
486 
487 contract MNY is StandardToken, MintableToken, BurnableToken {
488   using SafeMath for uint256;
489 
490   string public constant name = "MNY by Monkey Capital";
491   string public constant symbol = "MNY";
492   uint8 public constant decimals = 18;
493   uint public constant SWAP_CAP = 21000000 * (10 ** uint256(decimals));
494   uint public cycleMintSupply = 0;
495   MNYTiers public tierContract;
496 
497   event SwapStarted(uint256 endTime);
498   event MiningRestart(uint16 tier);
499 
500   uint public offset = 10**8;
501   uint public decimalOffset = 10 ** uint256(decimals);
502   uint public baseRate = 1 ether;
503   mapping(address => uint) public exchangeRatios;
504   mapping(address => uint) public unPaidFees;
505   address[] public miningTokens;
506 
507   //initial state
508   uint16 public currentTier = 1;
509   uint public mnyLeftInCurrent = 6.597 ether;
510   uint public miningTokenLeftInCurrent = 0.0369 ether;
511   uint public currentRate = mnyLeftInCurrent.div(miningTokenLeftInCurrent.div(offset));
512   bool public isMiningOpen = false;
513   bool public miningActive = false;
514   uint16 public lastTier = 2856;
515 
516   constructor() public {
517     totalSupply_ = 0;
518     //only the contract itself can mint as the owner
519     owner = this;
520   }
521 
522   modifier canMine() {
523     require(isMiningOpen);
524     _;
525   }
526 
527   modifier onlyAdmin() {
528     require(msg.sender == creator || msg.sender == dev || msg.sender == origDev);
529     _;
530   }
531 
532   // first call Token(address).approve(mny address, amount) for MNY to transfer on your behalf.
533   function mine(address token, uint amount) canMine public {
534     require(token != 0 && amount > 0);
535     require(exchangeRatios[token] > 0 && cycleMintSupply < SWAP_CAP);
536     require(ERC20(token).transferFrom(msg.sender, this, amount));
537     _mine(token, amount);
538   }
539 
540   function _mine(address _token, uint256 _inAmount) private {
541     if (!miningActive) {
542       miningActive = true;
543     }
544     uint _tokens = 0;
545     uint miningPower = exchangeRatios[_token].div(baseRate).mul(_inAmount);
546     unPaidFees[_token] += _inAmount.div(2);
547 
548     while (miningPower > 0) {
549       if (miningPower >= miningTokenLeftInCurrent) {
550         miningPower -= miningTokenLeftInCurrent;
551         _tokens += mnyLeftInCurrent;
552         miningTokenLeftInCurrent = 0;
553         mnyLeftInCurrent = 0;
554       } else {
555         uint calculatedMny = currentRate.mul(miningPower).div(offset);
556         _tokens += calculatedMny;
557         mnyLeftInCurrent -= calculatedMny;
558         miningTokenLeftInCurrent -= miningPower;
559         miningPower = 0;
560       }
561 
562       if (miningTokenLeftInCurrent == 0) {
563         if (currentTier == lastTier) {
564           _tokens = SWAP_CAP - cycleMintSupply;
565           if (miningPower > 0) {
566             uint refund = miningPower.div(exchangeRatios[_token].div(baseRate));
567             unPaidFees[_token] -= refund.div(2);
568             ERC20(_token).transfer(msg.sender, refund);
569           }
570           // Open swap
571           _startSwap();
572           break;
573         }
574         currentTier++;
575         (mnyLeftInCurrent, miningTokenLeftInCurrent, currentRate) = tierContract.getTier(currentTier);
576       }
577     }
578     cycleMintSupply += _tokens;
579     MintableToken(this).mint(msg.sender, _tokens);
580   }
581 
582   // swap data
583   bool public swapOpen = false;
584   uint public swapEndTime;
585   uint[] public holdings;
586   mapping(address => uint) public swapRates;
587 
588   function _startSwap() private {
589     swapEndTime = now + 30 days;
590     swapOpen = true;
591     isMiningOpen = false;
592     miningActive = false;
593     delete holdings;
594 
595     //set swap rates
596     for (uint16 i = 0; i < miningTokens.length; i++) {
597       address _token = miningTokens[i];
598       uint swapAmt = ERC20(_token).balanceOf(this) - unPaidFees[_token];
599       holdings.push(swapAmt);
600     }
601     for (uint16 j = 0; j < miningTokens.length; j++) {
602       address token = miningTokens[j];
603       swapRates[token] = holdings[j].div(SWAP_CAP.div(decimalOffset));
604     }
605     emit SwapStarted(swapEndTime);
606   }
607 
608   function swap(uint amt) public {
609     require(swapOpen && cycleMintSupply > 0);
610     if (amt > cycleMintSupply) {
611       amt = cycleMintSupply;
612     }
613     cycleMintSupply -= amt;
614     // burn verifies msg.sender has balance
615     burn(amt);
616     for (uint16 i = 0; i < miningTokens.length; i++) {
617       address _token = miningTokens[i];
618       ERC20(_token).transfer(msg.sender, amt.mul(swapRates[_token]).div(decimalOffset));
619     }
620   }
621 
622   function restart() public {
623     require(swapOpen);
624     require(now > swapEndTime || cycleMintSupply == 0);
625     cycleMintSupply = 0;
626     swapOpen = false;
627     swapEndTime = 0;
628     isMiningOpen = true;
629 
630     // 20% penalty for unswapped tokens
631     for (uint16 i = 0; i < miningTokens.length; i++) {
632       address _token = miningTokens[i];
633       uint amtLeft = ERC20(_token).balanceOf(this) - unPaidFees[_token];
634       unPaidFees[_token] += amtLeft.div(5);
635     }
636 
637     currentTier = 1;
638     mnyLeftInCurrent = 6.597 ether;
639     miningTokenLeftInCurrent = 0.0369 ether;
640     currentRate = mnyLeftInCurrent.div(miningTokenLeftInCurrent.div(offset));
641     emit MiningRestart(currentTier);
642   }
643 
644   function setIsMiningOpen(bool isOpen) onlyAdmin public {
645     isMiningOpen = isOpen;
646   }
647 
648   // base rate is 1 ether, so for 1 to 1 send in 1 ether (toWei)
649   function addMiningToken(address tokenAddr, uint ratio) onlyAdmin public {
650     exchangeRatios[tokenAddr] = ratio;
651     miningTokens.push(tokenAddr);
652     unPaidFees[tokenAddr] = 0;
653   }
654 
655   // can only add/change tier contract in between mining cycles
656   function setMnyTiers(address _tiersAddr) onlyAdmin public {
657     require(!miningActive);
658     tierContract = MNYTiers(_tiersAddr);
659   }
660 
661   // this allows us to use a different set of tiers
662   // can only be changed in between mining cycles by admin
663   function setLastTier(uint16 _lastTier) onlyAdmin public {
664     require(swapOpen);
665     lastTier = _lastTier;
666   }
667 
668   // Addresses for fees.
669   address public foundation = 0xab78275600E01Da6Ab7b5a4db7917d987FdB1b6d;
670   address public creator = 0xab78275600E01Da6Ab7b5a4db7917d987FdB1b6d;
671   address public dev = 0xab78275600E01Da6Ab7b5a4db7917d987FdB1b6d;
672   address public origDev = 0xab78275600E01Da6Ab7b5a4db7917d987FdB1b6d;
673 
674   function payFees() public {
675     for (uint16 i = 0; i < miningTokens.length; i++) {
676       address _token = miningTokens[i];
677       uint fees = unPaidFees[_token];
678       ERC20(_token).transfer(foundation, fees.div(5).mul(2));
679       ERC20(_token).transfer(dev, fees.div(5));
680       ERC20(_token).transfer(origDev, fees.div(5));
681       ERC20(_token).transfer(creator, fees.div(5));
682       unPaidFees[_token] = 0;
683     }
684   }
685 
686   function changeFoundation (address _receiver) public {
687     require(msg.sender == foundation);
688     foundation = _receiver;
689   }
690 
691   function changeCreator (address _receiver) public {
692     require(msg.sender == creator);
693     creator = _receiver;
694   }
695 
696   function changeDev (address _receiver) public {
697     require(msg.sender == dev);
698     dev = _receiver;
699   }
700 
701   function changeOrigDev (address _receiver) public {
702     require(msg.sender == origDev);
703     origDev = _receiver;
704   }
705 }