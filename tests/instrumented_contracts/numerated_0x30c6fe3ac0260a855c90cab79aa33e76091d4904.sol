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
195 // File: contracts/badERC20Fix.sol
196 
197 /*
198 
199 badERC20 POC Fix by SECBIT Team
200 
201 USE WITH CAUTION & NO WARRANTY
202 
203 REFERENCE & RELATED READING
204 - https://github.com/ethereum/solidity/issues/4116
205 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
206 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
207 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
208 
209 */
210 
211 pragma solidity ^0.4.24;
212 
213 library ERC20AsmFn {
214 
215     function isContract(address addr) internal {
216         assembly {
217             if iszero(extcodesize(addr)) { revert(0, 0) }
218         }
219     }
220 
221     function handleReturnData() internal returns (bool result) {
222         assembly {
223             switch returndatasize()
224             case 0 { // not a std erc20
225                 result := 1
226             }
227             case 32 { // std erc20
228                 returndatacopy(0, 0, 32)
229                 result := mload(0)
230             }
231             default { // anything else, should revert for safety
232                 revert(0, 0)
233             }
234         }
235     }
236 
237     function asmTransfer(address _erc20Addr, address _to, uint256 _value) internal returns (bool result) {
238 
239         // Must be a contract addr first!
240         isContract(_erc20Addr);
241 
242         // call return false when something wrong
243         require(_erc20Addr.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
244 
245         // handle returndata
246         return handleReturnData();
247     }
248 
249     function asmTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal returns (bool result) {
250 
251         // Must be a contract addr first!
252         isContract(_erc20Addr);
253 
254         // call return false when something wrong
255         require(_erc20Addr.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
256 
257         // handle returndata
258         return handleReturnData();
259     }
260 
261     function asmApprove(address _erc20Addr, address _spender, uint256 _value) internal returns (bool result) {
262 
263         // Must be a contract addr first!
264         isContract(_erc20Addr);
265 
266         // call return false when something wrong
267         require(_erc20Addr.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
268 
269         // handle returndata
270         return handleReturnData();
271     }
272 }
273 
274 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
275 
276 /**
277  * @title ERC20Basic
278  * @dev Simpler version of ERC20 interface
279  * See https://github.com/ethereum/EIPs/issues/179
280  */
281 contract ERC20Basic {
282   function totalSupply() public view returns (uint256);
283   function balanceOf(address _who) public view returns (uint256);
284   function transfer(address _to, uint256 _value) public returns (bool);
285   event Transfer(address indexed from, address indexed to, uint256 value);
286 }
287 
288 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
289 
290 /**
291  * @title Basic token
292  * @dev Basic version of StandardToken, with no allowances.
293  */
294 contract BasicToken is ERC20Basic {
295   using SafeMath for uint256;
296 
297   mapping(address => uint256) internal balances;
298 
299   uint256 internal totalSupply_;
300 
301   /**
302   * @dev Total number of tokens in existence
303   */
304   function totalSupply() public view returns (uint256) {
305     return totalSupply_;
306   }
307 
308   /**
309   * @dev Transfer token for a specified address
310   * @param _to The address to transfer to.
311   * @param _value The amount to be transferred.
312   */
313   function transfer(address _to, uint256 _value) public returns (bool) {
314     require(_value <= balances[msg.sender]);
315     require(_to != address(0));
316 
317     balances[msg.sender] = balances[msg.sender].sub(_value);
318     balances[_to] = balances[_to].add(_value);
319     emit Transfer(msg.sender, _to, _value);
320     return true;
321   }
322 
323   /**
324   * @dev Gets the balance of the specified address.
325   * @param _owner The address to query the the balance of.
326   * @return An uint256 representing the amount owned by the passed address.
327   */
328   function balanceOf(address _owner) public view returns (uint256) {
329     return balances[_owner];
330   }
331 
332 }
333 
334 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
335 
336 /**
337  * @title Burnable Token
338  * @dev Token that can be irreversibly burned (destroyed).
339  */
340 contract BurnableToken is BasicToken {
341 
342   event Burn(address indexed burner, uint256 value);
343 
344   /**
345    * @dev Burns a specific amount of tokens.
346    * @param _value The amount of token to be burned.
347    */
348   function burn(uint256 _value) public {
349     _burn(msg.sender, _value);
350   }
351 
352   function _burn(address _who, uint256 _value) internal {
353     require(_value <= balances[_who]);
354     // no need to require value <= totalSupply, since that would imply the
355     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
356 
357     balances[_who] = balances[_who].sub(_value);
358     totalSupply_ = totalSupply_.sub(_value);
359     emit Burn(_who, _value);
360     emit Transfer(_who, address(0), _value);
361   }
362 }
363 
364 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
365 
366 /**
367  * @title ERC20 interface
368  * @dev see https://github.com/ethereum/EIPs/issues/20
369  */
370 contract ERC20 is ERC20Basic {
371   function allowance(address _owner, address _spender)
372     public view returns (uint256);
373 
374   function transferFrom(address _from, address _to, uint256 _value)
375     public returns (bool);
376 
377   function approve(address _spender, uint256 _value) public returns (bool);
378   event Approval(
379     address indexed owner,
380     address indexed spender,
381     uint256 value
382   );
383 }
384 
385 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
386 
387 /**
388  * @title Standard ERC20 token
389  *
390  * @dev Implementation of the basic standard token.
391  * https://github.com/ethereum/EIPs/issues/20
392  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
393  */
394 contract StandardToken is ERC20, BasicToken {
395 
396   mapping (address => mapping (address => uint256)) internal allowed;
397 
398 
399   /**
400    * @dev Transfer tokens from one address to another
401    * @param _from address The address which you want to send tokens from
402    * @param _to address The address which you want to transfer to
403    * @param _value uint256 the amount of tokens to be transferred
404    */
405   function transferFrom(
406     address _from,
407     address _to,
408     uint256 _value
409   )
410     public
411     returns (bool)
412   {
413     require(_value <= balances[_from]);
414     require(_value <= allowed[_from][msg.sender]);
415     require(_to != address(0));
416 
417     balances[_from] = balances[_from].sub(_value);
418     balances[_to] = balances[_to].add(_value);
419     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
420     emit Transfer(_from, _to, _value);
421     return true;
422   }
423 
424   /**
425    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
426    * Beware that changing an allowance with this method brings the risk that someone may use both the old
427    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
428    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
429    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
430    * @param _spender The address which will spend the funds.
431    * @param _value The amount of tokens to be spent.
432    */
433   function approve(address _spender, uint256 _value) public returns (bool) {
434     allowed[msg.sender][_spender] = _value;
435     emit Approval(msg.sender, _spender, _value);
436     return true;
437   }
438 
439   /**
440    * @dev Function to check the amount of tokens that an owner allowed to a spender.
441    * @param _owner address The address which owns the funds.
442    * @param _spender address The address which will spend the funds.
443    * @return A uint256 specifying the amount of tokens still available for the spender.
444    */
445   function allowance(
446     address _owner,
447     address _spender
448    )
449     public
450     view
451     returns (uint256)
452   {
453     return allowed[_owner][_spender];
454   }
455 
456   /**
457    * @dev Increase the amount of tokens that an owner allowed to a spender.
458    * approve should be called when allowed[_spender] == 0. To increment
459    * allowed value is better to use this function to avoid 2 calls (and wait until
460    * the first transaction is mined)
461    * From MonolithDAO Token.sol
462    * @param _spender The address which will spend the funds.
463    * @param _addedValue The amount of tokens to increase the allowance by.
464    */
465   function increaseApproval(
466     address _spender,
467     uint256 _addedValue
468   )
469     public
470     returns (bool)
471   {
472     allowed[msg.sender][_spender] = (
473       allowed[msg.sender][_spender].add(_addedValue));
474     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
475     return true;
476   }
477 
478   /**
479    * @dev Decrease the amount of tokens that an owner allowed to a spender.
480    * approve should be called when allowed[_spender] == 0. To decrement
481    * allowed value is better to use this function to avoid 2 calls (and wait until
482    * the first transaction is mined)
483    * From MonolithDAO Token.sol
484    * @param _spender The address which will spend the funds.
485    * @param _subtractedValue The amount of tokens to decrease the allowance by.
486    */
487   function decreaseApproval(
488     address _spender,
489     uint256 _subtractedValue
490   )
491     public
492     returns (bool)
493   {
494     uint256 oldValue = allowed[msg.sender][_spender];
495     if (_subtractedValue >= oldValue) {
496       allowed[msg.sender][_spender] = 0;
497     } else {
498       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
499     }
500     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
501     return true;
502   }
503 
504 }
505 
506 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
507 
508 /**
509  * @title Mintable token
510  * @dev Simple ERC20 Token example, with mintable token creation
511  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
512  */
513 contract MintableToken is StandardToken, Ownable {
514   event Mint(address indexed to, uint256 amount);
515   event MintFinished();
516 
517   bool public mintingFinished = false;
518 
519 
520   modifier canMint() {
521     require(!mintingFinished);
522     _;
523   }
524 
525   modifier hasMintPermission() {
526     require(msg.sender == owner);
527     _;
528   }
529 
530   /**
531    * @dev Function to mint tokens
532    * @param _to The address that will receive the minted tokens.
533    * @param _amount The amount of tokens to mint.
534    * @return A boolean that indicates if the operation was successful.
535    */
536   function mint(
537     address _to,
538     uint256 _amount
539   )
540     public
541     hasMintPermission
542     canMint
543     returns (bool)
544   {
545     totalSupply_ = totalSupply_.add(_amount);
546     balances[_to] = balances[_to].add(_amount);
547     emit Mint(_to, _amount);
548     emit Transfer(address(0), _to, _amount);
549     return true;
550   }
551 
552   /**
553    * @dev Function to stop minting new tokens.
554    * @return True if the operation was successful.
555    */
556   function finishMinting() public onlyOwner canMint returns (bool) {
557     mintingFinished = true;
558     emit MintFinished();
559     return true;
560   }
561 }
562 
563 // File: contracts/FUTB.sol
564 
565 contract FUTB1 is StandardToken, MintableToken, BurnableToken {
566   using SafeMath for uint256;
567   using ERC20AsmFn for ERC20;
568 
569   string public constant name = "Futereum BTC 1";
570   string public constant symbol = "FUTB1";
571   uint8 public constant decimals = 18;
572   uint public constant SWAP_CAP = 21000000 * (10 ** uint256(decimals));
573   uint public cycleMintSupply = 0;
574   FUTBTiers public tierContract = FUTBTiers(0x4DD013B9E784C459fe5f82aa926534506CE25EAF);
575 
576   event SwapStarted(uint256 endTime);
577   event MiningRestart(uint16 tier);
578   event MiningTokenAdded(address token, uint ratio);
579   event MiningTokenAdjusted(address token, uint ratio);
580 
581   uint public offset = 10**8;
582   uint public decimalOffset = 10 ** uint256(decimals);
583   uint public baseRate = 100;
584   mapping(address => uint) public exchangeRatios;
585   mapping(address => uint) public unPaidFees;
586   address[] public miningTokens;
587   address public admin;
588   address public tierAdmin;
589   address public FUTC = 0xf880d3C6DCDA42A7b2F6640703C5748557865B35;
590 
591   //initial state
592   uint16 public currentTier = 1;
593   uint public futbLeftInCurrent = 6.597 ether;
594   uint public miningTokenLeftInCurrent = 0.0369 ether;
595   uint public currentRate = futbLeftInCurrent.div(miningTokenLeftInCurrent.div(offset));
596   bool public isMiningOpen = false;
597   bool public miningActive = false;
598   uint16 public lastTier = 2856;
599 
600   constructor() public {
601     totalSupply_ = 0;
602     //only the contract itself can mint as the owner
603     owner = this;
604     admin = msg.sender;
605     tierAdmin = msg.sender;
606   }
607 
608   modifier canMine() {
609     require(isMiningOpen);
610     _;
611   }
612 
613   modifier onlyAdmin() {
614     require(msg.sender == admin);
615     _;
616   }
617 
618   modifier onlyTierAdmin() {
619     require(msg.sender == tierAdmin);
620     _;
621   }
622 
623   // first call Token(address).approve(futb address, amount) for FUTB to transfer on your behalf.
624   function mine(address token, uint amount) canMine external {
625     require(token != 0 && amount > 0);
626     require(exchangeRatios[token] > 0 && cycleMintSupply < SWAP_CAP);
627     require(ERC20(token).asmTransferFrom(msg.sender, this, amount));
628     _mine(token, amount);
629   }
630 
631   function _mine(address _token, uint256 _inAmount) private {
632     if (!miningActive) {
633       miningActive = true;
634     }
635     uint _tokens = 0;
636     uint miningPower = _inAmount.mul(exchangeRatios[_token]).div(baseRate);
637     uint fee = _inAmount.div(2);
638 
639     while (miningPower > 0) {
640       if (miningPower >= miningTokenLeftInCurrent) {
641         miningPower -= miningTokenLeftInCurrent;
642         _tokens += futbLeftInCurrent;
643         miningTokenLeftInCurrent = 0;
644         futbLeftInCurrent = 0;
645       } else {
646         uint calculatedFutb = currentRate.mul(miningPower).div(offset);
647         _tokens += calculatedFutb;
648         futbLeftInCurrent -= calculatedFutb;
649         miningTokenLeftInCurrent -= miningPower;
650         miningPower = 0;
651       }
652 
653       if (miningTokenLeftInCurrent == 0) {
654         if (currentTier == lastTier) {
655           _tokens = SWAP_CAP - cycleMintSupply;
656           if (miningPower > 0) {
657             uint refund = miningPower.mul(baseRate).div(exchangeRatios[_token]);
658             fee -= refund.div(2);
659             ERC20(_token).asmTransfer(msg.sender, refund);
660           }
661           // Open swap
662           _startSwap();
663           break;
664         }
665         currentTier++;
666         (futbLeftInCurrent, miningTokenLeftInCurrent, currentRate) = tierContract.getTier(currentTier);
667       }
668     }
669     cycleMintSupply += _tokens;
670     MintableToken(this).mint(msg.sender, _tokens);
671     ERC20(_token).asmTransfer(FUTC, fee);
672   }
673 
674   // swap data
675   bool public swapOpen = false;
676   uint public swapEndTime;
677   mapping(address => uint) public swapRates;
678 
679   function _startSwap() private {
680     swapEndTime = now + 30 days;
681     swapOpen = true;
682     isMiningOpen = false;
683     miningActive = false;
684 
685     //set swap rates
686     for (uint16 i = 0; i < miningTokens.length; i++) {
687       address _token = miningTokens[i];
688       uint swapAmt = ERC20(_token).balanceOf(this);
689       swapRates[_token] = swapAmt.div(SWAP_CAP.div(decimalOffset));
690     }
691     emit SwapStarted(swapEndTime);
692   }
693 
694   function swap(uint amt) public {
695     require(swapOpen && cycleMintSupply > 0);
696     if (amt > cycleMintSupply) {
697       amt = cycleMintSupply;
698     }
699     cycleMintSupply -= amt;
700     // burn verifies msg.sender has balance
701     burn(amt);
702     for (uint16 i = 0; i < miningTokens.length; i++) {
703       address _token = miningTokens[i];
704       ERC20(_token).asmTransfer(msg.sender, amt.mul(swapRates[_token]).div(decimalOffset));
705     }
706   }
707 
708   function restart() external {
709     require(swapOpen);
710     require(now > swapEndTime || cycleMintSupply == 0);
711     cycleMintSupply = 0;
712     swapOpen = false;
713     swapEndTime = 0;
714     isMiningOpen = true;
715 
716     // 20% penalty for unswapped tokens
717     for (uint16 i = 0; i < miningTokens.length; i++) {
718       address _token = miningTokens[i];
719       uint amtLeft = ERC20(_token).balanceOf(this);
720       ERC20(_token).asmTransfer(FUTC, amtLeft.div(5));
721     }
722 
723     currentTier = 1;
724     futbLeftInCurrent = 6.597 ether;
725     miningTokenLeftInCurrent = 0.0369 ether;
726     currentRate = futbLeftInCurrent.div(miningTokenLeftInCurrent.div(offset));
727     emit MiningRestart(currentTier);
728   }
729 
730   function setIsMiningOpen(bool isOpen) onlyTierAdmin external {
731     isMiningOpen = isOpen;
732   }
733 
734   // base rate is 100, so for 1 to 1 send in 100 as ratio
735   function addMiningToken(address tokenAddr, uint ratio) onlyAdmin external {
736     require(exchangeRatios[tokenAddr] == 0 && ratio > 0 && ratio < 10000);
737     exchangeRatios[tokenAddr] = ratio;
738 
739     bool found = false;
740     for (uint16 i = 0; i < miningTokens.length; i++) {
741       if (miningTokens[i] == tokenAddr) {
742         found = true;
743         break;
744       }
745     }
746     if (!found) {
747       miningTokens.push(tokenAddr);
748     }
749     emit MiningTokenAdded(tokenAddr, ratio);
750   }
751 
752   function adjustTokenRate(address tokenAddr, uint ratio, uint16 position) onlyAdmin external {
753     require(miningTokens[position] == tokenAddr && ratio < 10000);
754     exchangeRatios[tokenAddr] = ratio;
755     emit MiningTokenAdjusted(tokenAddr, ratio);
756   }
757 
758   // can only add/change tier contract in between mining cycles
759   function setFutbTiers(address _tiersAddr) onlyTierAdmin external {
760     require(!miningActive);
761     tierContract = FUTBTiers(_tiersAddr);
762   }
763 
764   // use this to lock the contract from further changes to mining tokens
765   function lockContract() onlyAdmin external {
766     require(miningActive);
767     admin = address(0);
768   }
769 
770   // this allows us to use a different set of tiers
771   // can only be changed in between mining cycles by admin
772   function setLastTier(uint16 _lastTier) onlyTierAdmin external {
773     require(swapOpen);
774     lastTier = _lastTier;
775   }
776 
777   function changeAdmin (address _receiver) onlyAdmin external {
778     admin = _receiver;
779   }
780 
781   function changeTierAdmin (address _receiver) onlyTierAdmin external {
782     tierAdmin = _receiver;
783   }
784 
785   /*
786    * Whoops. Added a bad token that breaks swap back.
787    *
788    * Removal is irreversible.
789    *
790    * @param _addr The address of the ERC token to remove
791    * @param _position The index of the _addr in the miningTokens array.
792    * Use web3 to cycle through and find the index position.
793    */
794   function removeToken(address _addr, uint16 _position) onlyTierAdmin external {
795     require(miningTokens[_position] == _addr);
796     exchangeRatios[_addr] = 0;
797 
798     miningTokens[_position] = miningTokens[miningTokens.length-1];
799     delete miningTokens[miningTokens.length-1];
800     miningTokens.length--;
801   }
802 }