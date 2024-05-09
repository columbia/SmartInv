1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    * @notice Renouncing to ownership will leave the contract without an owner.
35    * It will not be possible to call the functions with the `onlyOwner`
36    * modifier anymore.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract ERC20 {
63   function totalSupply() public view returns (uint256);
64 
65   function balanceOf(address _who) public view returns (uint256);
66 
67   function allowance(address _owner, address _spender)
68     public view returns (uint256);
69 
70   function transfer(address _to, uint256 _value) public returns (bool);
71 
72   function approve(address _spender, uint256 _value)
73     public returns (bool);
74 
75   function transferFrom(address _from, address _to, uint256 _value)
76     public returns (bool);
77 
78   function burn(uint256 _value)
79     public returns (bool);
80 
81   event Transfer(
82     address indexed from,
83     address indexed to,
84     uint256 value
85   );
86 
87   event Approval(
88     address indexed owner,
89     address indexed spender,
90     uint256 value
91   );
92 
93   event Burn(
94     address indexed burner,
95     uint256 value
96   );
97 
98 }
99 
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, reverts on overflow.
104   */
105   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
106     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107     // benefit is lost if 'b' is also tested.
108     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
109     if (_a == 0) {
110       return 0;
111     }
112 
113     uint256 c = _a * _b;
114     require(c / _a == _b);
115 
116     return c;
117   }
118 
119   /**
120   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
121   */
122   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     require(_b > 0); // Solidity only automatically asserts when dividing by 0
124     uint256 c = _a / _b;
125     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
126 
127     return c;
128   }
129 
130   /**
131   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
132   */
133   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
134     require(_b <= _a);
135     uint256 c = _a - _b;
136 
137     return c;
138   }
139 
140   /**
141   * @dev Adds two numbers, reverts on overflow.
142   */
143   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
144     uint256 c = _a + _b;
145     require(c >= _a);
146 
147     return c;
148   }
149 
150   /**
151   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
152   * reverts when dividing by zero.
153   */
154   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155     require(b != 0);
156     return a % b;
157   }
158 }
159 
160 contract LoligoToken is ERC20, Ownable {
161   using SafeMath for uint256;
162 
163   string public constant name = "Loligo Token";
164   string public constant symbol = "LLG";
165   uint8 public constant decimals = 18;
166   uint256 private totalSupply_ = 16000000 * (10 ** uint256(decimals));
167   bool public locked = true;
168   mapping (address => uint256) private balances;
169 
170   mapping (address => mapping (address => uint256)) private allowed;
171 
172   modifier onlyWhenUnlocked() {
173     require(!locked || msg.sender == owner);
174     _;
175   }
176 
177   constructor() public {
178       balances[msg.sender] = totalSupply_;
179   }
180   /**
181   * @dev Total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return totalSupply_;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param _owner The address to query the the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address _owner) public view returns (uint256) {
193     return balances[_owner];
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address _owner,
204     address _spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214   * @dev Transfer token for a specified address
215   * @param _to The address to transfer to.
216   * @param _value The amount to be transferred.
217   */
218   function transfer(address _to, uint256 _value) public onlyWhenUnlocked returns (bool) {
219     require(_value <= balances[msg.sender]);
220     require(_to != address(0));
221 
222     balances[msg.sender] = balances[msg.sender].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     emit Transfer(msg.sender, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(
250     address _from,
251     address _to,
252     uint256 _value
253   )
254     public
255     onlyWhenUnlocked
256     returns (bool)
257   {
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260     require(_to != address(0));
261 
262     balances[_from] = balances[_from].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265     emit Transfer(_from, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(
279     address _spender,
280     uint256 _addedValue
281   )
282     public
283     returns (bool)
284   {
285     allowed[msg.sender][_spender] = (
286       allowed[msg.sender][_spender].add(_addedValue));
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    * approve should be called when allowed[_spender] == 0. To decrement
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _subtractedValue The amount of tokens to decrease the allowance by.
299    */
300   function decreaseApproval(
301     address _spender,
302     uint256 _subtractedValue
303   )
304     public
305     returns (bool)
306   {
307     uint256 oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue >= oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317   function burn(uint256 _value) public returns (bool success){
318     require(_value > 0);
319     require(_value <= balances[msg.sender]);
320     address burner = msg.sender;
321     balances[burner] = balances[burner].sub(_value);
322     totalSupply_ = totalSupply_.sub(_value);
323     emit Burn(burner, _value);
324     return true;
325   }
326 
327   function unlock() public onlyOwner {
328     locked = false;
329   }
330 
331 }
332 
333 contract Pausable is Ownable {
334   event Pause();
335   event Unpause();
336 
337   bool public paused = false;
338 
339 
340   /**
341    * @dev Modifier to make a function callable only when the contract is not paused.
342    */
343   modifier whenNotPaused() {
344     require(!paused);
345     _;
346   }
347 
348   /**
349    * @dev Modifier to make a function callable only when the contract is paused.
350    */
351   modifier whenPaused() {
352     require(paused);
353     _;
354   }
355 
356   /**
357    * @dev called by the owner to pause, triggers stopped state
358    */
359   function pause() public onlyOwner whenNotPaused {
360     paused = true;
361     emit Pause();
362   }
363 
364   /**
365    * @dev called by the owner to unpause, returns to normal state
366    */
367   function unpause() public onlyOwner whenPaused {
368     paused = false;
369     emit Unpause();
370   }
371 }
372 
373 contract Whitelist is Ownable{
374 
375   // Whitelisted address
376   mapping(address => bool) public whitelist;
377   // evants
378   event LogAddedBeneficiary(address indexed _beneficiary);
379   event LogRemovedBeneficiary(address indexed _beneficiary);
380 
381   /**
382    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
383    * @param _beneficiaries Addresses to be added to the whitelist
384    */
385   function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {
386     for (uint256 i = 0; i < _beneficiaries.length; i++) {
387       whitelist[_beneficiaries[i]] = true;
388       emit LogAddedBeneficiary(_beneficiaries[i]);
389     }
390   }
391 
392   /**
393    * @dev Removes single address from whitelist.
394    * @param _beneficiary Address to be removed to the whitelist
395    */
396   function removeFromWhitelist(address _beneficiary) public onlyOwner {
397     whitelist[_beneficiary] = false;
398     emit LogRemovedBeneficiary(_beneficiary);
399   }
400 
401   function isWhitelisted(address _beneficiary) public view returns (bool) {
402     return (whitelist[_beneficiary]);
403   }
404 
405 }
406 
407 contract TokenBonus is Ownable {
408     using SafeMath for uint256;
409 
410     address public owner;
411     mapping (address => uint256) public bonusBalances;   // visible to the public or not ???
412     address[] public bonusList;
413     uint256 public savedBonusToken;
414 
415     constructor() public {
416         owner = msg.sender;
417     }
418 
419     function distributeBonusToken(address _token, uint256 _percent) public onlyOwner {
420         for (uint256 i = 0; i < bonusList.length; i++) {
421             require(LoligoToken(_token).balanceOf(address(this)) >= savedBonusToken);
422 
423             uint256 amountToTransfer = bonusBalances[bonusList[i]].mul(_percent).div(100);
424             bonusBalances[bonusList[i]] = bonusBalances[bonusList[i]].sub(amountToTransfer);
425             savedBonusToken = savedBonusToken.sub(amountToTransfer);
426             LoligoToken(_token).transfer(bonusList[i], amountToTransfer);
427         }
428     }
429 }
430 
431 contract Presale is Pausable, Whitelist, TokenBonus {
432     using SafeMath for uint256;
433 
434     // addresse for testing to change
435     address private wallet = 0xE2a5B96B6C1280cfd93b57bcd3fDeAf73691D3f3;     // ETH wallet
436 
437     // LLG token
438     LoligoToken public token;
439 
440     // Presale period
441     uint256 public presaleRate;                                          // Rate presale LLG token per ether
442     uint256 public totalTokensForPresale;                                // LLG tokens allocated for the Presale
443     bool public presale1;                                                // Presale first period
444     bool public presale2;                                                // Presale second period
445 
446     // presale params
447     uint256 public savedBalance;                                        // Total amount raised in ETH
448     uint256 public savedPresaleTokenBalance;                            // Total sold tokens for presale
449     mapping (address => uint256) balances;                              // Balances in incoming Ether
450 
451     // Events
452     event Contribution(address indexed _contributor, uint256 indexed _value, uint256 indexed _tokens);     // Event to record new contributions
453     event PayEther(address indexed _receiver, uint256 indexed _value, uint256 indexed _timestamp);         // Event to record each time Ether is paid out
454     event BurnTokens(uint256 indexed _value, uint256 indexed _timestamp);                                  // Event to record when tokens are burned.
455 
456 
457     // Initialization
458     constructor(address _token) public {
459         // add address of the specific contract
460         token = LoligoToken(_token);
461     }
462 
463 
464     // Fallbck function for contribution
465     function () external payable whenNotPaused {
466         _buyPresaleTokens(msg.sender);
467     }
468     
469     // Contribute Function, accepts incoming payments and tracks balances for each contributors
470     function _buyPresaleTokens(address _beneficiary) public payable  {
471         require(presale1 || presale2);
472         require(msg.value >= 0.25 ether);
473         require(isWhitelisted(_beneficiary));
474         require(savedPresaleTokenBalance.add(_getTokensAmount(msg.value)) <= totalTokensForPresale);
475 
476         if (msg.value >= 10 ether) {
477           _deliverBlockedTokens(_beneficiary);
478         }else {
479           _deliverTokens(_beneficiary);
480         }
481     }
482 
483     /***********************************
484     *       Public functions for the   *
485     *           Presale period         *
486     ************************************/
487 
488     // Function to set Rate & tokens to sell for presale (period1)
489     function startPresale(uint256 _rate, uint256 _totalTokensForPresale) public onlyOwner {
490         require(_rate != 0 && _totalTokensForPresale != 0);
491         presaleRate = _rate;
492         totalTokensForPresale = _totalTokensForPresale;
493         presale1 = true;
494         presale2 = false;
495     }
496 
497     // Function to move to the second period for presale (period2)
498     function updatePresale() public onlyOwner {
499         require(presale1);
500         presale1 = false;
501         presale2 = true;
502     }
503 
504     // Function to close the presale period2
505     function closePresale() public onlyOwner {
506         require(presale2 || presale1);
507         presale1 = false;
508         presale2 = false;
509     }
510 
511     // Function to transferOwnership of the LLG token
512     function transferTokenOwnership(address _newOwner) public onlyOwner {
513         token.transferOwnership(_newOwner);
514     }
515 
516     // Function to transfer the rest of tokens not sold
517     function transferToken(address _crowdsale) public onlyOwner {
518         require(!presale1 && !presale2);
519         require(token.balanceOf(address(this)) > savedBonusToken);
520         uint256 tokensToTransfer =  token.balanceOf(address(this)).sub(savedBonusToken);
521         token.transfer(_crowdsale, tokensToTransfer);
522     }
523     /***************************************
524     *          internal functions          *
525     ****************************************/
526 
527     function _deliverBlockedTokens(address _beneficiary) internal {
528         uint256 tokensAmount = msg.value.mul(presaleRate);
529         uint256 bonus = tokensAmount.mul(_checkPresaleBonus(msg.value)).div(100);
530 
531         savedPresaleTokenBalance = savedPresaleTokenBalance.add(tokensAmount.add(bonus));
532         token.transfer(_beneficiary, tokensAmount);
533         savedBonusToken = savedBonusToken.add(bonus);
534         bonusBalances[_beneficiary] = bonusBalances[_beneficiary].add(bonus);
535         bonusList.push(_beneficiary);
536         wallet.transfer(msg.value);
537         emit PayEther(wallet, msg.value, now);
538     }
539 
540     function _deliverTokens(address _beneficiary) internal {
541       uint256 tokensAmount = msg.value.mul(presaleRate);
542       uint256 tokensToTransfer = tokensAmount.add((tokensAmount.mul(_checkPresaleBonus(msg.value))).div(100));
543 
544       savedPresaleTokenBalance = savedPresaleTokenBalance.add(tokensToTransfer);
545       token.transfer(_beneficiary, tokensToTransfer);
546       wallet.transfer(msg.value);
547       emit PayEther(wallet, msg.value, now);
548     }
549 
550     function _checkPresaleBonus(uint256 _value) internal view returns (uint256){
551         if(presale1 && _value >= 0.25 ether){
552           return 40;
553         }else if(presale2 && _value >= 0.25 ether){
554           return 30;
555         }else{
556           return 0;
557         }
558     }
559 
560     function _getTokensAmount(uint256 _value) internal view returns (uint256){
561        uint256 tokensAmount = _value.mul(presaleRate);
562        uint256 tokensToTransfer = tokensAmount.add((tokensAmount.mul(_checkPresaleBonus(_value))).div(100));
563        return tokensToTransfer;
564     }
565 }