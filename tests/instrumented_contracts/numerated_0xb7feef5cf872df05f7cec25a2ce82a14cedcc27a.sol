1 pragma solidity ^0.4.18;
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
290  * @title PreSale CDT token
291  * @dev The minting functionality is reimplemented, as opposed to inherited
292  * from MintableToken, to allow for giving right to mint to arbitery account.
293  */
294 contract PreSaleCDT is StandardToken, Ownable, Pausable {
295   // Disable transfer unless explicitly enabled
296   function PreSaleCDT() public { paused = true; }
297 
298   // The address of the contract or user that is allowed to mint tokens.
299   address public minter;
300 
301   /**
302    * @dev Set the address of the minter
303    * @param _minter address to be set as minter.
304    *
305    * Note: We also need to implement "mint" method.
306    */
307   function setMinter(address _minter) public onlyOwner {
308       minter = _minter;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) public returns (bool) {
318     require(msg.sender == minter);
319 
320     totalSupply = totalSupply.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322 
323     Transfer(0x0, _to, _amount);
324     return true;
325   }
326 
327   /**
328    * @dev account for paused/unpaused-state.
329    */
330   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
331     return super.transfer(_to, _value);
332   }
333 
334   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
335     return super.transferFrom(_from, _to, _value);
336   }
337 
338   /**
339    * @dev Token meta-information
340    * @param name of the token as it's shown to user
341    * @param symbol of the token
342    * @param decimals number
343    * Number of indivisible tokens that make up 1 CDT = 10^{decimals}
344    */
345   string public constant name = "Presale CDT Token";
346   string public constant symbol = "CDT";
347   uint8  public constant decimals = 18;
348 }
349 
350 /**
351  * @title Cryder Crowdsale contract
352  * @dev Govern the presale:
353  *   1) Taking place in a specific limited period of time.
354  *   2) Having HARDCAP value set --- a number of sold tokens to end the pre-sale
355  *
356  * Owner can change time parameters at any time --- just in case of emergency
357  * Owner can change minter at any time --- just in case of emergency
358  *
359  * !!! There is no way to change the address of the wallet !!!
360  */
361 contract PreSaleCrowd is Ownable {
362     // Use SafeMath library to provide methods for uint256-type vars.
363     using SafeMath for uint256;
364 
365     // The hardcoded address of wallet
366     address public wallet;
367 
368     // The address of presale token
369     PreSaleCDT public token;
370 
371     /**
372      * @dev Variables
373      *
374      * @public START_TIME uint the time of the start of the sale
375      * @public CLOSE_TIME uint the time of the end of the sale
376      * @public HARDCAP uint256 if @HARDCAP is reached, presale stops
377      * @public the amount of indivisible quantities (=10^18 CDT) given for 1 wei
378      */
379     uint public START_TIME = 1508544000;
380     uint public CLOSE_TIME = 1509728400;
381     uint256 public HARDCAP = 50000000000000000000000000;
382     uint256 public exchangeRate = 9000;
383 
384     /**
385      * Fallback function
386      * @dev The contracts are prevented from using fallback function.
387      * That prevents loosing control of tokens that will eventually get attributed to the contract, not the user.
388      * To buy tokens from the wallet (that is a contract) user has to specify beneficiary of tokens using buyTokens method.
389      */
390     function () payable public {
391       require(msg.sender == tx.origin);
392       buyTokens(msg.sender);
393     }
394 
395     /**
396      * @dev A function to withdraw all funds.
397      * Normally, contract should not have ether at all.
398      */
399     function withdraw() onlyOwner public {
400       wallet.transfer(this.balance);
401     }
402 
403     /**
404      * @dev The constructor sets the tokens address
405      * @param _token address
406      */
407     function PreSaleCrowd(address _token, address _wallet) public {
408       token  = PreSaleCDT(_token);
409       wallet = _wallet;
410     }
411 
412     /**
413      * event for token purchase logging
414      * @param purchaser who paid for the tokens
415      * @param beneficiary who got the tokens
416      * @param value weis paid for purchase
417      * @param amount amount of tokens purchased
418      */
419     event TokenPurchase(
420       address indexed purchaser,
421       address indexed beneficiary,
422       uint256 value,
423       uint256 amount
424     );
425 
426     /**
427      * @dev Sets the start and end of the sale.
428      * @param _start uint256 start of the sale.
429      * @param _close uint256 end of the sale.
430      */
431     function setTime(uint _start, uint _close) public onlyOwner {
432       require( _start < _close );
433       START_TIME = _start;
434       CLOSE_TIME = _close;
435     }
436 
437     /**
438      * @dev Sets exhange rate, ie amount of tokens (10^18 CDT) for 1 wei.
439      * @param _exchangeRate uint256 new exhange rate.
440      */
441     function setExchangeRate(uint256 _exchangeRate) public onlyOwner  {
442       require(now < START_TIME);
443       exchangeRate = _exchangeRate;
444     }
445 
446     /**
447      * @dev Buy tokens for all sent ether. Tokens will be added to beneficiary's account
448      * @param beneficiary address the owner of bought tokens.
449      */
450     function buyTokens(address beneficiary) payable public {
451       uint256 total = token.totalSupply();
452       uint256 amount = msg.value;
453       require(amount > 0);
454 
455       // Check that hardcap not reached, and sale-time.
456       require(total < HARDCAP);
457       require(now >= START_TIME);
458       require(now < CLOSE_TIME);
459 
460       // Override exchange rate for daily bonuses
461       if (now < START_TIME + 3600 * 24 * 1) {
462           exchangeRate = 10800;
463       } else if (now < START_TIME + 3600 * 24 * 2) {
464           exchangeRate = 10350;
465       } else if (now < START_TIME + 3600 * 24 * 3) {
466           exchangeRate = 9900;
467       }
468 
469       // Mint tokens bought for all sent ether to beneficiary
470       uint256 tokens = amount.mul(exchangeRate);
471 
472       token.mint(beneficiary, tokens);
473       TokenPurchase(msg.sender, beneficiary, amount, tokens);
474 
475       // Mint 8% tokens to wallet as a team part
476       uint256 teamTokens = tokens / 100 * 8;
477       token.mint(wallet, teamTokens);
478 
479       // Finally, sent all the money to wallet
480       wallet.transfer(amount);
481     }
482 }