1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 contract CanReclaimToken is Ownable {
121   using SafeERC20 for ERC20Basic;
122 
123   /**
124    * @dev Reclaim all ERC20Basic compatible tokens
125    * @param token ERC20Basic The address of the token contract
126    */
127   function reclaimToken(ERC20Basic token) external onlyOwner {
128     uint256 balance = token.balanceOf(this);
129     token.safeTransfer(owner, balance);
130   }
131 
132 }
133 
134 contract Claimable is Ownable {
135   address public pendingOwner;
136 
137   /**
138    * @dev Modifier throws if called by any account other than the pendingOwner.
139    */
140   modifier onlyPendingOwner() {
141     require(msg.sender == pendingOwner);
142     _;
143   }
144 
145   /**
146    * @dev Allows the current owner to set the pendingOwner address.
147    * @param newOwner The address to transfer ownership to.
148    */
149   function transferOwnership(address newOwner) onlyOwner public {
150     pendingOwner = newOwner;
151   }
152 
153   /**
154    * @dev Allows the pendingOwner address to finalize the transfer.
155    */
156   function claimOwnership() onlyPendingOwner public {
157     OwnershipTransferred(owner, pendingOwner);
158     owner = pendingOwner;
159     pendingOwner = address(0);
160   }
161 }
162 
163 contract AddressList is Claimable {
164     string public name;
165     mapping (address => bool) public onList;
166 
167     function AddressList(string _name, bool nullValue) public {
168         name = _name;
169         onList[0x0] = nullValue;
170     }
171     event ChangeWhiteList(address indexed to, bool onList);
172 
173     // Set whether _to is on the list or not. Whether 0x0 is on the list
174     // or not cannot be set here - it is set once and for all by the constructor.
175     function changeList(address _to, bool _onList) onlyOwner public {
176         require(_to != 0x0);
177         if (onList[_to] != _onList) {
178             onList[_to] = _onList;
179             ChangeWhiteList(_to, _onList);
180         }
181     }
182 }
183 
184 contract HasNoContracts is Ownable {
185 
186   /**
187    * @dev Reclaim ownership of Ownable contracts
188    * @param contractAddr The address of the Ownable to be reclaimed.
189    */
190   function reclaimContract(address contractAddr) external onlyOwner {
191     Ownable contractInst = Ownable(contractAddr);
192     contractInst.transferOwnership(owner);
193   }
194 }
195 
196 contract HasNoEther is Ownable {
197 
198   /**
199   * @dev Constructor that rejects incoming Ether
200   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
201   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
202   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
203   * we could use assembly to access msg.value.
204   */
205   function HasNoEther() public payable {
206     require(msg.value == 0);
207   }
208 
209   /**
210    * @dev Disallows direct send by settings a default function without the `payable` flag.
211    */
212   function() external {
213   }
214 
215   /**
216    * @dev Transfer all Ether held by the contract to the owner.
217    */
218   function reclaimEther() external onlyOwner {
219     assert(owner.send(this.balance));
220   }
221 }
222 
223 contract HasNoTokens is CanReclaimToken {
224 
225  /**
226   * @dev Reject all ERC223 compatible tokens
227   * @param from_ address The address that is transferring the tokens
228   * @param value_ uint256 the amount of the specified token
229   * @param data_ Bytes The data passed from the caller.
230   */
231   function tokenFallback(address from_, uint256 value_, bytes data_) external {
232     from_;
233     value_;
234     data_;
235     revert();
236   }
237 
238 }
239 
240 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
241 }
242 
243 contract ERC20Basic {
244   function totalSupply() public view returns (uint256);
245   function balanceOf(address who) public view returns (uint256);
246   function transfer(address to, uint256 value) public returns (bool);
247   event Transfer(address indexed from, address indexed to, uint256 value);
248 }
249 
250 contract BasicToken is ERC20Basic {
251   using SafeMath for uint256;
252 
253   mapping(address => uint256) balances;
254 
255   uint256 totalSupply_;
256 
257   /**
258   * @dev total number of tokens in existence
259   */
260   function totalSupply() public view returns (uint256) {
261     return totalSupply_;
262   }
263 
264   /**
265   * @dev transfer token for a specified address
266   * @param _to The address to transfer to.
267   * @param _value The amount to be transferred.
268   */
269   function transfer(address _to, uint256 _value) public returns (bool) {
270     require(_to != address(0));
271     require(_value <= balances[msg.sender]);
272 
273     // SafeMath.sub will throw if there is not enough balance.
274     balances[msg.sender] = balances[msg.sender].sub(_value);
275     balances[_to] = balances[_to].add(_value);
276     Transfer(msg.sender, _to, _value);
277     return true;
278   }
279 
280   /**
281   * @dev Gets the balance of the specified address.
282   * @param _owner The address to query the the balance of.
283   * @return An uint256 representing the amount owned by the passed address.
284   */
285   function balanceOf(address _owner) public view returns (uint256 balance) {
286     return balances[_owner];
287   }
288 
289 }
290 
291 contract BurnableToken is BasicToken {
292 
293   event Burn(address indexed burner, uint256 value);
294 
295   /**
296    * @dev Burns a specific amount of tokens.
297    * @param _value The amount of token to be burned.
298    */
299   function burn(uint256 _value) public {
300     require(_value <= balances[msg.sender]);
301     // no need to require value <= totalSupply, since that would imply the
302     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
303 
304     address burner = msg.sender;
305     balances[burner] = balances[burner].sub(_value);
306     totalSupply_ = totalSupply_.sub(_value);
307     Burn(burner, _value);
308   }
309 }
310 
311 contract ERC20 is ERC20Basic {
312   function allowance(address owner, address spender) public view returns (uint256);
313   function transferFrom(address from, address to, uint256 value) public returns (bool);
314   function approve(address spender, uint256 value) public returns (bool);
315   event Approval(address indexed owner, address indexed spender, uint256 value);
316 }
317 
318 library SafeERC20 {
319   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
320     assert(token.transfer(to, value));
321   }
322 
323   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
324     assert(token.transferFrom(from, to, value));
325   }
326 
327   function safeApprove(ERC20 token, address spender, uint256 value) internal {
328     assert(token.approve(spender, value));
329   }
330 }
331 
332 contract StandardToken is ERC20, BasicToken {
333 
334   mapping (address => mapping (address => uint256)) internal allowed;
335 
336 
337   /**
338    * @dev Transfer tokens from one address to another
339    * @param _from address The address which you want to send tokens from
340    * @param _to address The address which you want to transfer to
341    * @param _value uint256 the amount of tokens to be transferred
342    */
343   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
344     require(_to != address(0));
345     require(_value <= balances[_from]);
346     require(_value <= allowed[_from][msg.sender]);
347 
348     balances[_from] = balances[_from].sub(_value);
349     balances[_to] = balances[_to].add(_value);
350     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
351     Transfer(_from, _to, _value);
352     return true;
353   }
354 
355   /**
356    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
357    *
358    * Beware that changing an allowance with this method brings the risk that someone may use both the old
359    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
360    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
361    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362    * @param _spender The address which will spend the funds.
363    * @param _value The amount of tokens to be spent.
364    */
365   function approve(address _spender, uint256 _value) public returns (bool) {
366     allowed[msg.sender][_spender] = _value;
367     Approval(msg.sender, _spender, _value);
368     return true;
369   }
370 
371   /**
372    * @dev Function to check the amount of tokens that an owner allowed to a spender.
373    * @param _owner address The address which owns the funds.
374    * @param _spender address The address which will spend the funds.
375    * @return A uint256 specifying the amount of tokens still available for the spender.
376    */
377   function allowance(address _owner, address _spender) public view returns (uint256) {
378     return allowed[_owner][_spender];
379   }
380 
381   /**
382    * @dev Increase the amount of tokens that an owner allowed to a spender.
383    *
384    * approve should be called when allowed[_spender] == 0. To increment
385    * allowed value is better to use this function to avoid 2 calls (and wait until
386    * the first transaction is mined)
387    * From MonolithDAO Token.sol
388    * @param _spender The address which will spend the funds.
389    * @param _addedValue The amount of tokens to increase the allowance by.
390    */
391   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
392     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
393     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
394     return true;
395   }
396 
397   /**
398    * @dev Decrease the amount of tokens that an owner allowed to a spender.
399    *
400    * approve should be called when allowed[_spender] == 0. To decrement
401    * allowed value is better to use this function to avoid 2 calls (and wait until
402    * the first transaction is mined)
403    * From MonolithDAO Token.sol
404    * @param _spender The address which will spend the funds.
405    * @param _subtractedValue The amount of tokens to decrease the allowance by.
406    */
407   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
408     uint oldValue = allowed[msg.sender][_spender];
409     if (_subtractedValue > oldValue) {
410       allowed[msg.sender][_spender] = 0;
411     } else {
412       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
413     }
414     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418 }
419 
420 contract PausableToken is StandardToken, Pausable {
421 
422   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
423     return super.transfer(_to, _value);
424   }
425 
426   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
427     return super.transferFrom(_from, _to, _value);
428   }
429 
430   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
431     return super.approve(_spender, _value);
432   }
433 
434   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
435     return super.increaseApproval(_spender, _addedValue);
436   }
437 
438   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
439     return super.decreaseApproval(_spender, _subtractedValue);
440   }
441 }
442 
443 contract TrueUSD is PausableToken, BurnableToken, NoOwner, Claimable {
444     string public constant name = "TrueUSD";
445     string public constant symbol = "TUSD";
446     uint8 public constant decimals = 18;
447 
448     AddressList public canReceiveMintWhitelist;
449     AddressList public canBurnWhiteList;
450     AddressList public blackList;
451     uint256 public burnMin = 10000 * 10**uint256(decimals);
452     uint256 public burnMax = 20000000 * 10**uint256(decimals);
453 
454     uint80 public transferFeeNumerator = 7;
455     uint80 public transferFeeDenominator = 10000;
456     uint80 public mintFeeNumerator = 0;
457     uint80 public mintFeeDenominator = 10000;
458     uint256 public mintFeeFlat = 0;
459     uint80 public burnFeeNumerator = 0;
460     uint80 public burnFeeDenominator = 10000;
461     uint256 public burnFeeFlat = 0;
462     address public insurer;
463 
464     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
465     event Mint(address indexed to, uint256 amount);
466 
467     function TrueUSD(address _canMintWhiteList, address _canBurnWhiteList, address _blackList) public {
468         totalSupply_ = 0;
469         canReceiveMintWhitelist = AddressList(_canMintWhiteList);
470         canBurnWhiteList = AddressList(_canBurnWhiteList);
471         blackList = AddressList(_blackList);
472         insurer = msg.sender;
473     }
474 
475     //Burning functions as withdrawing money from the system. The platform will keep track of who burns coins,
476     //and will send them back the equivalent amount of money (rounded down to the nearest cent).
477     function burn(uint256 _value) public {
478         require(canBurnWhiteList.onList(msg.sender));
479         require(_value >= burnMin);
480         require(_value <= burnMax);
481         uint256 fee = payInsuranceFee(msg.sender, _value, burnFeeNumerator, burnFeeDenominator, burnFeeFlat);
482         uint256 remaining = _value.sub(fee);
483         super.burn(remaining);
484     }
485 
486     //Create _amount new tokens and transfer them to _to.
487     //Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/MintableToken.sol
488     function mint(address _to, uint256 _amount) onlyOwner public {
489         require(canReceiveMintWhitelist.onList(_to));
490         totalSupply_ = totalSupply_.add(_amount);
491         balances[_to] = balances[_to].add(_amount);
492         Mint(_to, _amount);
493         Transfer(address(0), _to, _amount);
494         payInsuranceFee(_to, _amount, mintFeeNumerator, mintFeeDenominator, mintFeeFlat);
495     }
496 
497     //Change the minimum and maximum amount that can be burned at once. Burning
498     //may be disabled by setting both to 0 (this will not be done under normal
499     //operation, but we can't add checks to disallow it without losing a lot of
500     //flexibility since burning could also be as good as disabled
501     //by setting the minimum extremely high, and we don't want to lock
502     //in any particular cap for the minimum)
503     function changeBurnBounds(uint newMin, uint newMax) onlyOwner public {
504         require(newMin <= newMax);
505         burnMin = newMin;
506         burnMax = newMax;
507         ChangeBurnBoundsEvent(newMin, newMax);
508     }
509 
510     function transfer(address to, uint256 value) public returns (bool) {
511         require(!blackList.onList(msg.sender));
512         require(!blackList.onList(to));
513         bool result = super.transfer(to, value);
514         payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
515         return result;
516     }
517 
518     function transferFrom(address from, address to, uint256 value) public returns (bool) {
519         require(!blackList.onList(from));
520         require(!blackList.onList(to));
521         bool result = super.transferFrom(from, to, value);
522         payInsuranceFee(to, value, transferFeeNumerator, transferFeeDenominator, 0);
523         return result;
524     }
525 
526     function payInsuranceFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate) private returns (uint256) {
527         uint256 insuranceFee = value.mul(numerator).div(denominator).add(flatRate);
528         if (insuranceFee > 0) {
529             transferFromWithoutAllowance(payer, insurer, insuranceFee);
530         }
531         return insuranceFee;
532     }
533 
534     // based on 'transfer' in https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
535     function transferFromWithoutAllowance(address from, address _to, uint256 _value) private {
536         assert(_to != address(0));
537         assert(_value <= balances[from]);
538         balances[from] = balances[from].sub(_value);
539         balances[_to] = balances[_to].add(_value);
540         Transfer(from, _to, _value);
541     }
542 
543     function changeInsuranceFees(uint80 _transferFeeNumerator,
544                                  uint80 _transferFeeDenominator,
545                                  uint80 _mintFeeNumerator,
546                                  uint80 _mintFeeDenominator,
547                                  uint256 _mintFeeFlat,
548                                  uint80 _burnFeeNumerator,
549                                  uint80 _burnFeeDenominator,
550                                  uint256 _burnFeeFlat) public onlyOwner {
551         require(_transferFeeDenominator != 0);
552         require(_mintFeeDenominator != 0);
553         require(_burnFeeDenominator != 0);
554         transferFeeNumerator = _transferFeeNumerator;
555         transferFeeDenominator = _transferFeeDenominator;
556         mintFeeNumerator = _mintFeeNumerator;
557         mintFeeDenominator = _mintFeeDenominator;
558         mintFeeFlat = _mintFeeFlat;
559         burnFeeNumerator = _burnFeeNumerator;
560         burnFeeDenominator = _burnFeeDenominator;
561         burnFeeFlat = _burnFeeFlat;
562     }
563 
564     function changeInsurer(address newInsurer) public onlyOwner {
565         require(newInsurer != address(0));
566         insurer = newInsurer;
567     }
568 }