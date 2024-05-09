1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     // SafeMath.sub will throw if there is not enough balance.
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public view returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public view returns (uint256) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * @dev Increase the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _addedValue The amount of tokens to increase the allowance by.
188    */
189   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
190     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To decrement
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _subtractedValue The amount of tokens to decrease the allowance by.
204    */
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 
219 /**
220  * @title Ownable
221  * @dev The Ownable contract has an owner address, and provides basic authorization control
222  * functions, this simplifies the implementation of "user permissions".
223  */
224 contract Ownable {
225   address public owner;
226 
227 
228   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230 
231   /**
232    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
233    * account.
234    */
235   function Ownable() public {
236     owner = msg.sender;
237   }
238 
239   /**
240    * @dev Throws if called by any account other than the owner.
241    */
242   modifier onlyOwner() {
243     require(msg.sender == owner);
244     _;
245   }
246 
247   /**
248    * @dev Allows the current owner to transfer control of the contract to a newOwner.
249    * @param newOwner The address to transfer ownership to.
250    */
251   function transferOwnership(address newOwner) public onlyOwner {
252     require(newOwner != address(0));
253     OwnershipTransferred(owner, newOwner);
254     owner = newOwner;
255   }
256 
257 }
258 
259 contract VKTToken is StandardToken, Ownable {
260 
261   string public name = 'VKTToken';
262   string public symbol = 'VKT';
263   uint8 public decimals = 18;
264 
265 
266 
267   // address where funds are collected
268   address public wallet;
269 
270   // how many token units a buyer gets per ether
271   uint256 public rate;
272 
273   // amount of raised money in wei
274   uint256 public weiRaised;
275 
276   // locked token balance each address
277   mapping(address => uint256) lockedBalances;
278 
279   // address is locked:true, can't transfer token
280   mapping (address => bool) public lockedAccounts;
281 
282   // token cap
283   uint256 public tokenCap = 1 * 10 ** 27;
284 
285     /**
286    * event for token purchase logging
287    * @param purchaser who paid for the tokens
288    * @param beneficiary who got the tokens
289    * @param value weis paid for purchase
290    * @param amount amount of tokens purchased
291    */
292   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
293   
294 
295   /**
296    * event for rate update logging
297    * @param preRate previouse rate per ether
298    * @param newRate new rate per ether
299    */
300   event RateUpdated(uint256 preRate, uint256 newRate);
301 
302 
303   /**
304    * event for wallet update logging
305    * @param preWallet previouse wallet that collect fund
306    * @param newWallet new wallet collect fund
307    */
308   event WalletUpdated(address indexed preWallet, address indexed newWallet);
309 
310 
311   /**
312    * event for lock account logging
313    * @param target affected account
314    * @param lock true:account is locked. false: unlocked
315    */
316   event LockAccount(address indexed target, bool lock);
317 
318   event Mint(address indexed to, uint256 amount);
319 
320   event MintWithLocked(address indexed to, uint256 amount, uint256 lockedAmount);
321 
322   event ReleaseLockedBalance(address indexed to, uint256 amount);
323 
324 
325   function VKTToken(uint256 _rate, address _wallet) public {
326     require(_rate > 0);
327     require(_wallet != address(0));
328 
329     rate = _rate;
330     wallet = _wallet;
331   }
332 
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
341     require(_to != address(0));
342     require(totalSupply_.add(_amount) <= tokenCap);
343 
344     totalSupply_ = totalSupply_.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     Mint(_to, _amount);
347     return true;
348   }
349 
350 
351   /**
352    * @dev Function to mint tokens with some locked
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @param _lockedAmount The amount of tokens locked.
356    * @return A boolean that indicates if the operation was successful.
357    */
358   function mintWithLocked(address _to, uint256 _amount, uint256 _lockedAmount) onlyOwner public returns (bool) {
359     require(_to != address(0));
360     require(totalSupply_.add(_amount) <= tokenCap);
361     require(_amount >= _lockedAmount);
362 
363     totalSupply_ = totalSupply_.add(_amount);
364     balances[_to] = balances[_to].add(_amount);
365     lockedBalances[_to] = lockedBalances[_to].add(_lockedAmount);
366     MintWithLocked(_to, _amount, _lockedAmount);
367     return true;
368   }
369 
370   /**
371    * @dev Function to release some locked tokens
372    * @param _to The address that tokens will be released.
373    * @param _amount The amount of tokens to release.
374    * @return A boolean that indicates if the operation was successful.
375    */
376   function releaseLockedBalance(address _to, uint256 _amount) onlyOwner public returns (bool) {
377     require(_to != address(0));
378     require(_amount <= lockedBalances[_to]);
379 
380     lockedBalances[_to] = lockedBalances[_to].sub(_amount);
381     ReleaseLockedBalance(_to, _amount);
382     return true;
383   }
384 
385     /**
386   * @dev Gets the balance of locked the specified address.
387   * @param _owner The address to query the the balance of locked.
388   * @return An uint256 representing the amount owned by the passed address.
389   */
390   function balanceOfLocked(address _owner) public view returns (uint256 balance) {
391     return balances[_owner];
392   }
393 
394 
395     /**
396   * @dev transfer token for a specified address
397   * @param _to The address to transfer to.
398   * @param _value The amount to be transferred.
399   */
400   function transfer(address _to, uint256 _value) public returns (bool) {
401     require(!lockedAccounts[msg.sender]);
402     require(_value <= balances[msg.sender].sub(lockedBalances[msg.sender]));
403     return super.transfer(_to, _value);
404   }
405 
406 
407     /**
408    * @dev Transfer tokens from one address to another
409    * @param _from address The address which you want to send tokens from
410    * @param _to address The address which you want to transfer to
411    * @param _value uint256 the amount of tokens to be transferred
412    */
413   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
414     require(!lockedAccounts[_from]);
415     require(_value <= balances[_from].sub(lockedBalances[_from]));
416     return super.transferFrom(_from, _to, _value);
417   }
418 
419     /**
420    * @dev lock or unlock for one address to transfer tokens
421    * @param target affected address
422    * @param lock true: set target locked, fasle:unlock
423 
424    */
425   function lockAccount(address target, bool lock) onlyOwner public returns (bool) {
426     require(target != address(0));
427     lockedAccounts[target] = lock;
428     LockAccount(target, lock);
429     return true;
430   }
431 
432     // fallback function can be used to buy tokens
433   function () external payable {
434     buyTokens(msg.sender);
435   }
436 
437   // low level token purchase function
438   function buyTokens(address beneficiary) public payable {
439     require(beneficiary != address(0));
440     require(msg.value != 0);
441 
442     uint256 weiAmount = msg.value;
443 
444     // calculate token amount to be created
445     uint256 tokens = getTokenAmount(weiAmount);
446 
447     if (msg.value >= 50 * 10 ** 18 && msg.value < 100 * 10 ** 18) {
448       tokens = tokens.mul(100).div(95);
449     }
450 
451     if (msg.value >= 100 * 10 ** 18) {
452       tokens = tokens.mul(10).div(9);
453     }
454 
455 
456     require(totalSupply_.add(tokens) <= tokenCap);
457 
458     // update state
459     weiRaised = weiRaised.add(weiAmount);
460     totalSupply_ = totalSupply_.add(tokens);
461     balances[beneficiary] = balances[beneficiary].add(tokens);
462     Mint(beneficiary, tokens);
463     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
464 
465     forwardFunds();
466   }
467 
468   // Override this method to have a way to add business logic to your crowdsale when buying
469   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
470     return weiAmount.mul(rate);
471   }
472 
473   // send ether to the fund collection wallet
474   // override to create custom fund forwarding mechanisms
475   function forwardFunds() internal {
476     wallet.transfer(msg.value);
477   }
478 
479 
480     /**
481    * @dev update token mint rate per eth
482    * @param _rate token rate per eth
483    */
484   function updateRate(uint256 _rate) onlyOwner public returns (bool) {
485     require(_rate != 0);
486 
487     RateUpdated(rate, _rate);
488     rate = _rate;
489     return true;
490   }
491 
492 
493     /**
494    * @dev update wallet
495    * @param _wallet wallet that collect fund
496    */
497   function updateWallet(address _wallet) onlyOwner public returns (bool) {
498     require(_wallet != address(0));
499     
500     WalletUpdated(wallet, _wallet);
501     wallet = _wallet;
502     return true;
503   }
504 }