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
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     if (totalSupply.add(_amount) > 1000000000000000000000000000) {
273         return false;
274     }
275 
276     totalSupply = totalSupply.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     Mint(_to, _amount);
279     Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     MintFinished();
290     return true;
291   }
292 }
293 
294 // File: contracts/TGCToken.sol
295 
296 contract TGCToken is MintableToken {
297   string public constant name = "TokensGate Coin";
298   string public constant symbol = "TGC";
299   uint8 public constant decimals = 18;
300     
301   mapping(address => uint256) public whitelistAddresses;
302     
303   event Burn(address indexed burner, uint256 value);
304     
305   function setWhitelist(address _holder, uint256 _utDate) onlyOwner public {
306     require(_holder != address(0));
307       
308     whitelistAddresses[_holder] = _utDate;
309   }
310     
311   // overriding StandardToken#approve
312   function approve(address _spender, uint256 _value) public returns (bool) {
313     require(whitelistAddresses[msg.sender] > 0);
314     require(now >= whitelistAddresses[msg.sender]);
315     
316     allowed[msg.sender][_spender] = _value;
317     Approval(msg.sender, _spender, _value);
318     return true;
319   }
320     
321   // overriding BasicToken#transfer
322   function transfer(address _to, uint256 _value) public returns (bool) {
323     require(_to != address(0));
324     require(_value <= balances[msg.sender]);
325     require(whitelistAddresses[msg.sender] > 0);
326     require(now >= whitelistAddresses[msg.sender]);
327 
328     balances[msg.sender] = balances[msg.sender].sub(_value);
329     balances[_to] = balances[_to].add(_value);
330     Transfer(msg.sender, _to, _value);
331     return true;
332   }
333     
334   function burn(address _burner, uint256 _value) onlyOwner public {
335     require(_value <= balances[_burner]);
336 
337     balances[_burner] = balances[_burner].sub(_value);
338     totalSupply = totalSupply.sub(_value);
339     Burn(_burner, _value);
340     Transfer(_burner, address(0), _value);
341   }
342 }
343 
344 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
345 
346 /**
347  * @title Crowdsale
348  * @dev Crowdsale is a base contract for managing a token crowdsale.
349  * Crowdsales have a start and end timestamps, where investors can make
350  * token purchases and the crowdsale will assign them tokens based
351  * on a token per ETH rate. Funds collected are forwarded to a wallet
352  * as they arrive.
353  */
354 contract Crowdsale {
355   using SafeMath for uint256;
356 
357   // The token being sold
358   MintableToken public token;
359 
360   // start and end timestamps where investments are allowed (both inclusive)
361   uint256 public startTime;
362   uint256 public endTime;
363 
364   // address where funds are collected
365   address public wallet;
366 
367   // how many token units a buyer gets per wei
368   uint256 public rate;
369 
370   // amount of raised money in wei
371   uint256 public weiRaised;
372 
373   /**
374    * event for token purchase logging
375    * @param purchaser who paid for the tokens
376    * @param beneficiary who got the tokens
377    * @param value weis paid for purchase
378    * @param amount amount of tokens purchased
379    */
380   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
381 
382 
383   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
384     require(_startTime >= now);
385     require(_endTime >= _startTime);
386     require(_rate > 0);
387     require(_wallet != address(0));
388 
389     token = createTokenContract();
390     startTime = _startTime;
391     endTime = _endTime;
392     rate = _rate;
393     wallet = _wallet;
394   }
395 
396   // creates the token to be sold.
397   // override this method to have crowdsale of a specific mintable token.
398   function createTokenContract() internal returns (MintableToken) {
399     return new MintableToken();
400   }
401 
402 
403   // fallback function can be used to buy tokens
404   function () external payable {
405     buyTokens(msg.sender);
406   }
407 
408   // low level token purchase function
409   function buyTokens(address beneficiary) public payable {
410     require(beneficiary != address(0));
411     require(validPurchase());
412 
413     uint256 weiAmount = msg.value;
414 
415     // calculate token amount to be created
416     uint256 tokens = weiAmount.mul(rate);
417 
418     // update state
419     weiRaised = weiRaised.add(weiAmount);
420 
421     token.mint(beneficiary, tokens);
422     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
423 
424     forwardFunds();
425   }
426 
427   // send ether to the fund collection wallet
428   // override to create custom fund forwarding mechanisms
429   function forwardFunds() internal {
430     wallet.transfer(msg.value);
431   }
432 
433   // @return true if the transaction can buy tokens
434   function validPurchase() internal view returns (bool) {
435     bool withinPeriod = now >= startTime && now <= endTime;
436     bool nonZeroPurchase = msg.value != 0;
437     return withinPeriod && nonZeroPurchase;
438   }
439 
440   // @return true if crowdsale event has ended
441   function hasEnded() public view returns (bool) {
442     return now > endTime;
443   }
444 
445 
446 }
447 
448 // File: contracts/TokensGate.sol
449 
450 contract TokensGate is Crowdsale {
451 
452     mapping(address => bool) public icoAddresses;
453 
454     function TokensGate (
455         uint256 _startTime,
456         uint256 _endTime,
457         uint256 _rate,
458         address _wallet
459     ) public 
460         Crowdsale(_startTime, _endTime, _rate, _wallet)
461     {
462 
463     }
464 
465     function createTokenContract() internal returns (MintableToken) {
466         return new TGCToken();
467     }
468 
469     function () external payable {
470         
471     }
472 
473     function addIcoAddress(address _icoAddress) public {
474         require(msg.sender == wallet);
475 
476         icoAddresses[_icoAddress] = true;
477     }
478     
479     function setWhitelist(address holder, uint256 utDate) public {
480         require(msg.sender == wallet);
481         
482         TGCToken tgcToken = TGCToken(token);
483         tgcToken.setWhitelist(holder, utDate);
484     }
485     
486     function burnTokens(address tokenOwner, uint256 t) payable public {
487         require(msg.sender == wallet);
488         
489         TGCToken tgcToken = TGCToken(token);
490         tgcToken.burn(tokenOwner, t);
491     }
492     
493     function buyTokens(address beneficiary) public payable {
494         require(beneficiary == address(0));
495     }
496 
497     function mintTokens(address walletToMint, uint256 t) payable public {
498         require(walletToMint != address(0));
499         require(icoAddresses[walletToMint]);
500 
501         token.mint(walletToMint, t);
502     }
503     
504     function changeOwner(address newOwner) payable public {
505         require(msg.sender == wallet);
506         
507         wallet = newOwner;
508     }
509     
510     function tokenOwnership(address newOwner) payable public {
511         require(msg.sender == wallet);
512         
513         token.transferOwnership(newOwner);
514     }
515     
516     function setEndTime(uint256 newEndTime) payable public {
517         require(msg.sender == wallet);
518         
519         endTime = newEndTime;
520     }
521 
522 }