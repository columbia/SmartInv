1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title ERC20Basic
33  * @dev Simpler version of ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/179
35  */
36 contract ERC20Basic {
37   uint256 public totalSupply;
38   function balanceOf(address who) public constant returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 /**
44  * @title Basic token
45  * @dev Basic version of StandardToken, with no allowances
46  */
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   /**
53   * @dev Transfer token for a specified address
54   * @param _to The address to transfer to
55   * @param _value The amount to be transferred
56   */
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59 
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address
68   * @param _owner The address to query the the balance of
69   * @return An uint256 representing the amount owned by the passed address
70   */
71   function balanceOf(address _owner) public constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 }
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public constant returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 /**
88  * @title Standard ERC20 token
89  * @dev Implementation of the basic standard token
90  * @dev https://github.com/ethereum/EIPs/issues/20
91  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
92  */
93 contract StandardToken is ERC20, BasicToken {
94   mapping (address => mapping (address => uint256)) allowed;
95 
96   /**
97    * @dev Transfer tokens from one address to another
98    * @param _from address The address which you want to send tokens from
99    * @param _to address The address which you want to transfer to
100    * @param _value uint256 The amount of tokens to be transferred
101    */
102   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104 
105     uint256 _allowance = allowed[_from][msg.sender];
106 
107     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
108     // require (_value <= _allowance);
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = _allowance.sub(_value);
113     Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    *
120    * Beware that changing an allowance with this method brings the risk that someone may use both the old
121    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    */
149   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154 
155   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 }
166 
167 /**
168  * @title Ownable
169  * @dev The Ownable contract has an owner address, and provides basic authorization control
170  * functions, this simplifies the implementation of "user permissions".
171  */
172 contract Ownable {
173   address public owner;
174 
175   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177   /**
178    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
179    */
180   function Ownable() public {
181     owner = msg.sender;
182   }
183 
184   /**
185    * @dev Throws if called by any account other than the owner.
186    */
187   modifier onlyOwner() {
188     require(msg.sender == owner);
189     _;
190   }
191 
192   /**
193    * @dev Allows the current owner to transfer control of the contract to a newOwner.
194    * @param newOwner The address to transfer ownership to.
195    */
196   function transferOwnership(address newOwner) onlyOwner public {
197     require(newOwner != address(0));
198     OwnershipTransferred(owner, newOwner);
199     owner = newOwner;
200   }
201 }
202 
203 /**
204  * @title Mintable token
205  * @dev Simple ERC20 Token example, with mintable token creation
206  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
207  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
208  */
209 
210 contract MintableToken is StandardToken, Ownable {
211   event Mint(address indexed to, uint256 amount);
212   event MintFinished();
213 
214   bool public mintingFinished = false;
215 
216   modifier canMint() {
217     require(!mintingFinished);
218     _;
219   }
220 
221   /**
222    * @dev Function to mint tokens
223    * @param _to The address that will receive the minted tokens.
224    * @param _amount The amount of tokens to mint.
225    * @return A boolean that indicates if the operation was successful.
226    */
227   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
228     totalSupply = totalSupply.add(_amount);
229     balances[_to] = balances[_to].add(_amount);
230     Mint(_to, _amount);
231     Transfer(0x0, _to, _amount);
232     return true;
233   }
234 
235   /**
236    * @dev Function to stop minting new tokens.
237    * @return True if the operation was successful.
238    */
239   function finishMinting() onlyOwner public returns (bool) {
240     mintingFinished = true;
241     MintFinished();
242     return true;
243   }
244 }
245 
246 /**
247  * @title Pausable
248  * @dev Base contract which allows children to implement an emergency stop mechanism.
249  */
250 contract Pausable is Ownable {
251   event Pause();
252   event Unpause();
253 
254   bool public paused = false;
255 
256   /**
257    * @dev Modifier to make a function callable only when the contract is not paused.
258    */
259   modifier whenNotPaused() {
260     require(!paused);
261     _;
262   }
263 
264   /**
265    * @dev Modifier to make a function callable only when the contract is paused.
266    */
267   modifier whenPaused() {
268     require(paused);
269     _;
270   }
271 
272   /**
273    * @dev called by the owner to pause, triggers stopped state
274    */
275   function pause() onlyOwner whenNotPaused public {
276     paused = true;
277     Pause();
278   }
279 
280   /**
281    * @dev called by the owner to unpause, returns to normal state
282    */
283   function unpause() onlyOwner whenPaused public {
284     paused = false;
285     Unpause();
286   }
287 }
288 
289 /**
290  * @title Cryder token contract
291  * @dev The minting functionality is reimplemented, as opposed to inherited
292  * from MintableToken, to allow for giving right to mint to arbitery account.
293  */
294 contract CryderToken is StandardToken, Ownable, Pausable {
295   // Disable transfer unless explicitly enabled
296   function CryderToken() public { paused = true; }
297 
298   // The address of the contract or user that is allowed to mint tokens.
299   address public minter;
300   
301   /**
302    * @dev Variables
303    *
304    * @public FREEZE_TIME uint the time when team tokens can be transfered
305    * @public bounty the address of bounty manager 
306   */
307   uint public FREEZE_TIME = 1550682000;
308   address public bounty = 0xa258Eb1817aA122acBa4Af66A7A064AE6E10552A;
309 
310   /**
311    * @dev Set the address of the minter
312    * @param _minter address to be set as minter.
313    *
314    * Note: We also need to implement "mint" method.
315    */
316   function setMinter(address _minter) public onlyOwner {
317       minter = _minter;
318   }
319 
320   /**
321    * @dev Function to mint tokens
322    * @param _to The address that will receive the minted tokens.
323    * @param _amount The amount of tokens to mint.
324    * @return A boolean that indicates if the operation was successful.
325    */
326   function mint(address _to, uint256 _amount) public returns (bool) {
327     require(msg.sender == minter);
328 
329     totalSupply = totalSupply.add(_amount);
330     balances[_to] = balances[_to].add(_amount);
331 
332     Transfer(0x0, _to, _amount);
333     return true;
334   }
335 
336   /**
337    * @dev account for paused/unpaused-state.
338    */
339   function transfer(address _to, uint256 _value) public returns (bool) {
340     // Check for paused with an exception of bounty manager and freeze team tokens for 1 year
341     require(msg.sender == bounty || (!paused && msg.sender != owner) || (!paused && msg.sender == owner && now > FREEZE_TIME));
342     return super.transfer(_to, _value);
343   }
344 
345   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
346     // Check for paused with an exception of bounty manager and freeze team tokens for 1 year with an additional _from check
347     require((msg.sender == bounty && _from == bounty) || (!paused && msg.sender != owner && _from != owner) || (!paused && msg.sender == owner && now > FREEZE_TIME));
348     return super.transferFrom(_from, _to, _value);
349   }
350 
351   /**
352    * @dev Token meta-information
353    * @param name of the token as it's shown to user
354    * @param symbol of the token
355    * @param decimals number
356    * Number of indivisible tokens that make up 1 CRYDER = 10^{decimals}
357    */
358   string public constant name = "Cryder Token";
359   string public constant symbol = "CRYDER";
360   uint8  public constant decimals = 18;
361 }
362 
363 /**
364  * @title Cryder crowdsale contract
365  * @dev Govern the sale:
366  *   1) Taking place in a specific limited period of time.
367  *   2) Having HARDCAP value set --- a number of sold tokens to end the sale
368  *
369  * Owner can change time parameters at any time --- just in case of emergency
370  * Owner can change minter at any time --- just in case of emergency
371  *
372  * !!! There is no way to change the address of the wallet or bounty manager !!!
373  */
374 contract CryderCrowdsale is Ownable {
375     // Use SafeMath library to provide methods for uint256-type vars.
376     using SafeMath for uint256;
377 
378     // The hardcoded address of wallet
379     address public wallet;
380 
381     // The address of presale token
382     CryderToken public presaleToken;
383     
384     // The address of sale token
385     CryderToken public token;
386     
387     // Bounty must be allocated only once
388     bool public isBountyAllocated = false;
389     
390     // Requested tokens array
391     mapping(address => bool) tokenRequests;
392 
393     /**
394      * @dev Variables
395      *
396      * @public START_TIME uint the time of the start of the sale
397      * @public CLOSE_TIME uint the time of the end of the sale
398      * @public HARDCAP uint256 if @HARDCAP is reached, sale stops
399      * @public exchangeRate the amount of indivisible quantities (=10^18 CRYDER) given for 1 wei
400      * @public bounty the address of bounty manager 
401      */
402     uint public START_TIME = 1516467600;
403     uint public CLOSE_TIME = 1519146000;
404     uint256 public HARDCAP = 400000000000000000000000000;
405     uint256 public exchangeRate = 3000;
406     address public bounty = 0xa258Eb1817aA122acBa4Af66A7A064AE6E10552A;
407 
408     /**
409      * Fallback function
410      * @dev The contracts are prevented from using fallback function.
411      * That prevents loosing control of tokens that will eventually get attributed to the contract, not the user.
412      * To buy tokens from the wallet (that is a contract) user has to specify beneficiary of tokens using buyTokens method.
413      */
414     function () payable public {
415       require(msg.sender == tx.origin);
416       buyTokens(msg.sender);
417     }
418 
419     /**
420      * @dev A function to withdraw all funds.
421      * Normally, contract should not have ether at all.
422      */
423     function withdraw() onlyOwner public {
424       wallet.transfer(this.balance);
425     }
426 
427     /**
428      * @dev The constructor sets the tokens address
429      * @param _token address
430      */
431     function CryderCrowdsale(address _presaleToken, address _token, address _wallet) public {
432       presaleToken = CryderToken(_presaleToken);
433       token  = CryderToken(_token);
434       wallet = _wallet;
435     }
436 
437     /**
438      * event for token purchase logging
439      * @param purchaser who paid for the tokens
440      * @param beneficiary who got the tokens
441      * @param value weis paid for purchase
442      * @param amount amount of tokens purchased
443      */
444     event TokenPurchase(
445       address indexed purchaser,
446       address indexed beneficiary,
447       uint256 value,
448       uint256 amount
449     );
450 
451     /**
452      * @dev Sets the start and end of the sale.
453      * @param _start uint256 start of the sale.
454      * @param _close uint256 end of the sale.
455      */
456     function setTime(uint _start, uint _close) public onlyOwner {
457       require( _start < _close );
458       START_TIME = _start;
459       CLOSE_TIME = _close;
460     }
461 
462     /**
463      * @dev Sets exhange rate, ie amount of tokens (10^18 CRYDER) for 1 wei.
464      * @param _exchangeRate uint256 new exhange rate.
465      */
466     function setExchangeRate(uint256 _exchangeRate) public onlyOwner  {
467       require(now < START_TIME);
468       exchangeRate = _exchangeRate;
469     }
470 
471     /**
472      * @dev Buy tokens for all sent ether. Tokens will be added to beneficiary's account
473      * @param beneficiary address the owner of bought tokens.
474      */
475     function buyTokens(address beneficiary) payable public {
476       uint256 total = token.totalSupply();
477       uint256 amount = msg.value;
478       require(amount > 0);
479 
480       // Check that hardcap not reached, and sale-time.
481       require(total < HARDCAP);
482       require(now >= START_TIME);
483       require(now < CLOSE_TIME);
484 
485       // Override exchange rate for daily bonuses
486       if (now < START_TIME + 3600 * 24 * 1) {
487           exchangeRate = 3900;
488       } else if (now < START_TIME + 3600 * 24 * 3) {
489           exchangeRate = 3750;
490       } else if (now < START_TIME + 3600 * 24 * 5) {
491           exchangeRate = 3600;
492       } else {
493           exchangeRate = 3000;
494       }
495 
496       // Mint tokens bought for all sent ether to beneficiary
497       uint256 tokens = amount.mul(exchangeRate);
498 
499       token.mint(beneficiary, tokens);
500       TokenPurchase(msg.sender, beneficiary, amount, tokens);
501 
502       // Mint 8% tokens to wallet as a team part
503       uint256 teamTokens = tokens / 100 * 8;
504       token.mint(wallet, teamTokens);
505 
506       // Finally, sent all the money to wallet
507       wallet.transfer(amount);
508     }
509     
510     /**
511      * @dev One time command to allocate 5kk bounty tokens
512      */
513      
514      function allocateBounty() public returns (bool) {
515          // Check for bounty manager and allocation state
516          require(msg.sender == bounty && isBountyAllocated == false);
517          // Mint bounty tokens to bounty managers address
518          token.mint(bounty, 5000000000000000000000000);
519          isBountyAllocated = true;
520          return true;
521      }
522      
523      function requestTokens() public returns (bool) {
524          require(presaleToken.balanceOf(msg.sender) > 0 && tokenRequests[msg.sender] == false);
525          token.mint(msg.sender, presaleToken.balanceOf(msg.sender));
526          tokenRequests[msg.sender] = true;
527          return true;
528      }
529 }