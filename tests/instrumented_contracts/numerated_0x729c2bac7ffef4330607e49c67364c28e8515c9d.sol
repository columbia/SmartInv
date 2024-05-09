1 pragma solidity ^0.4.19;
2 
3 /*
4 100tokens.com Smart Contract Crowdsale
5 */
6 
7 // File: zeppelin-solidity/contracts/math/SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
43 
44 /**
45  * @title Ownable
46  * @dev The Ownable contract has an owner address, and provides basic authorization control
47  * functions, this simplifies the implementation of "user permissions".
48  */
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   uint256 public totalSupply;
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 // File: zeppelin-solidity/contracts/token/BasicToken.sol
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 // File: zeppelin-solidity/contracts/token/ERC20.sol
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 // File: zeppelin-solidity/contracts/token/StandardToken.sol
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 // File: zeppelin-solidity/contracts/token/MintableToken.sol
249 
250 /**
251  * @title Mintable token
252  * @dev Simple ERC20 Token example, with mintable token creation
253  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
254  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
255  */
256 
257 contract MintableToken is StandardToken, Ownable {
258   event Mint(address indexed to, uint256 amount);
259   event MintFinished();
260 
261   bool public mintingFinished = false;
262 
263 
264   modifier canMint() {
265     require(!mintingFinished);
266     _;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
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
294 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
295 
296 /**
297  * @title Crowdsale
298  * @dev Crowdsale is a base contract for managing a token crowdsale.
299  * Crowdsales have a start and end timestamps, where investors can make
300  * token purchases and the crowdsale will assign them tokens based
301  * on a token per ETH rate. Funds collected are forwarded to a wallet
302  * as they arrive.
303  */
304 contract Crowdsale {
305   using SafeMath for uint256;
306 
307   // The token being sold
308   MintableToken public token;
309 
310   // start and end timestamps where investments are allowed (both inclusive)
311   uint256 public startTime;
312   uint256 public endTime;
313 
314   // address where funds are collected
315   address public wallet;
316 
317   // how many token units a buyer gets per wei
318   uint256 public rate;
319 
320   // amount of raised money in wei
321   uint256 public weiRaised;
322 
323   /**
324    * event for token purchase logging
325    * @param purchaser who paid for the tokens
326    * @param beneficiary who got the tokens
327    * @param value weis paid for purchase
328    * @param amount amount of tokens purchased
329    */
330   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
331 
332 
333   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
334     require(_startTime >= now);
335     require(_endTime >= _startTime);
336     require(_rate > 0);
337     require(_wallet != address(0));
338 
339     token = createTokenContract();
340     startTime = _startTime;
341     endTime = _endTime;
342     rate = _rate;
343     wallet = _wallet;
344   }
345 
346   // creates the token to be sold.
347   // override this method to have crowdsale of a specific mintable token.
348   function createTokenContract() internal returns (MintableToken) {
349     return new MintableToken();
350   }
351 
352 
353   // fallback function can be used to buy tokens
354   function () external payable {
355     buyTokens(msg.sender);
356   }
357 
358   // low level token purchase function
359   function buyTokens(address beneficiary) public payable {
360     require(beneficiary != address(0));
361     require(validPurchase());
362 
363     uint256 weiAmount = msg.value;
364 
365     // calculate token amount to be created
366     uint256 tokens = weiAmount.mul(rate);
367 
368     // update state
369     weiRaised = weiRaised.add(weiAmount);
370 
371     token.mint(beneficiary, tokens);
372     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
373 
374     forwardFunds();
375   }
376 
377   // send ether to the fund collection wallet
378   // override to create custom fund forwarding mechanisms
379   function forwardFunds() internal {
380     wallet.transfer(msg.value);
381   }
382 
383   // @return true if the transaction can buy tokens
384   function validPurchase() internal view returns (bool) {
385     bool withinPeriod = now >= startTime && now <= endTime;
386     bool nonZeroPurchase = msg.value != 0;
387     return withinPeriod && nonZeroPurchase;
388   }
389 
390   // @return true if crowdsale event has ended
391   function hasEnded() public view returns (bool) {
392     return now > endTime;
393   }
394 
395 
396 }
397 
398 
399 contract OHC_CrowdsaleToken is MintableToken {
400   string public constant name = "One Hundred Coin";
401   string public constant symbol = "OHC";
402   uint8 public constant decimals = 18;
403 
404   // overriding BasicToken#transfer
405   function transfer(address _to, uint256 _value) public returns (bool) {
406     require(_to != address(0));
407     require(_value <= balances[msg.sender]);
408     require(now >= 1521795600);
409 
410     balances[msg.sender] = balances[msg.sender].sub(_value);
411     balances[_to] = balances[_to].add(_value);
412     Transfer(msg.sender, _to, _value);
413     return true;
414   }
415 
416   event Burn(address indexed burner, uint256 value);
417 
418   function burn(address _burner, uint256 _value) onlyOwner public {
419     require(_value <= balances[_burner]);
420 
421     balances[_burner] = balances[_burner].sub(_value);
422     totalSupply = totalSupply.sub(_value);
423     Burn(_burner, _value);
424     Transfer(_burner, address(0), _value);
425   }
426 
427 }
428 
429 contract OHC_Crowdsale is Crowdsale, Ownable {
430 
431   uint256 constant CAP =  1000000000000000000000000000;
432   uint256 constant CAP_PRE_SALE = 200000000000000000000000000;
433   uint256 constant CAP_ICO_SALE = 400000000000000000000000000;
434 
435   uint256 constant RATE1 = 70000;
436   uint256 constant RATE2 = 65000;
437   uint256 constant RATE3 = 60000;
438   uint256 constant RATE4 = 55000;
439   uint256 constant RATE5 = 35000;
440   uint256 constant RATE6 = 30000;
441   uint256 constant RATE7 = 25000;
442   uint256 constant RATE8 = 20000;
443 
444   uint256 public totalSupplyIco;
445 
446   function OHC_Crowdsale (
447     uint256 _startTime,
448     uint256 _endTime,
449     uint256 _rate,
450     address _wallet
451   ) public
452     Crowdsale(_startTime, _endTime, _rate, _wallet)
453   {
454 
455   }
456 
457   function createTokenContract() internal returns (MintableToken) {
458     return new OHC_CrowdsaleToken();
459   }
460 
461   // overriding Crowdsale#validPurchase
462   function validPurchase() internal constant returns (bool) {
463     if (msg.value < 20000000000000000) {
464       return false;
465     }
466 
467     if (token.totalSupply().add(msg.value.mul(getRate())) >= CAP) {
468       return false;
469     }
470 
471     if (now > 1525939200 && now < 1539158400) {
472       return false;
473     }
474 
475     if (1523347200 >= now && 1525939200 <= now) {
476       if (token.totalSupply().add(msg.value.mul(getRate())) >= CAP_PRE_SALE) {
477         return false;
478       }
479     }
480 
481     if (1539158400 >= now && 1541840400 <= now) {
482       if (totalSupplyIco.add(msg.value.mul(getRate())) >= CAP_ICO_SALE) {
483         return false;
484       }
485     }
486 
487     if (getRate() == 0) {
488       return false;
489     }
490 
491     return super.validPurchase();
492   }
493 
494   function buyTokens(address beneficiary) payable public {
495     require(beneficiary != address(0));
496     require(validPurchase());
497 
498     uint256 weiAmount = msg.value;
499     uint256 tokens = weiAmount.mul(getRate());
500     weiRaised = weiRaised.add(weiAmount);
501 
502     token.mint(beneficiary, tokens);
503     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
504 
505     forwardFunds();
506   }
507 
508   function getRate() public constant returns (uint256) {
509     if (1523347200 <= now && now <= 1523952000) {
510       return RATE1;
511     }
512 
513     if (1523952001 <= now && now <= 1524556800) {
514       return RATE2;
515     }
516 
517     if (1524556805 <= now && now <= 1525161600) {
518       return RATE3;
519     }
520 
521     if (1525161601 <= now && now <= 1525939200) {
522       return RATE4;
523     }
524 
525     if (1539158400 <= now && now <= 1539763200) {
526       return RATE5;
527     }
528 
529     if (1539763201 <= now && now <= 1540368000) {
530       return RATE6;
531     }
532 
533     if (1540368001 <= now && now <= 1540976400) {
534       return RATE7;
535     }
536 
537     if (1540976401 <= now && now <= 1541840400) {
538       return RATE8;
539     }
540 
541     return 0;
542   }
543 
544   function mintTokens(address walletToMint, uint256 t) onlyOwner payable public {
545     require(token.totalSupply().add(t) < CAP);
546 
547     token.mint(walletToMint, t);
548   }
549 
550   function tokenTransferOwnership(address newOwner) onlyOwner payable public {
551     token.transferOwnership(newOwner);
552   }
553 }