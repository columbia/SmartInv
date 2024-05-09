1 pragma solidity ^0.4.19;
2 
3 /*
4 Created by Cogenero Blockchain Solutions Limited
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
294 contract CogeneroToken is MintableToken {
295   function allowTransfer(address _from, address _to) public view returns (bool);
296   function allowManager() public view returns (bool);
297   function setManager(address _manager, bool _status) onlyOwner public;
298   function setAllowTransferGlobal(bool _status) public;
299   function setAllowTransferLocal(bool _status) public;
300   function setAllowTransferExternal(bool _status) public;
301   function setWhitelist(address _address, uint256 _date) public;
302   function setLockupList(address _address, uint256 _date) public;
303   function setWildcardList(address _address, bool _status) public;
304   function burn(address _burner, uint256 _value) onlyOwner public;
305 }
306 
307 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
308 
309 /**
310  * @title Crowdsale
311  * @dev Crowdsale is a base contract for managing a token crowdsale.
312  * Crowdsales have a start and end timestamps, where investors can make
313  * token purchases and the crowdsale will assign them tokens based
314  * on a token per ETH rate. Funds collected are forwarded to a wallet
315  * as they arrive.
316  */
317 contract Crowdsale {
318   using SafeMath for uint256;
319 
320   // The token being sold
321   CogeneroToken public token;
322 
323   // start and end timestamps where investments are allowed (both inclusive)
324   uint256 public startTime;
325   uint256 public endTime;
326 
327   // address where funds are collected
328   address public wallet;
329 
330   // how many token units a buyer gets per wei
331   uint256 public rate;
332 
333   // amount of raised money in wei
334   uint256 public weiRaised;
335 
336   /**
337    * event for token purchase logging
338    * @param purchaser who paid for the tokens
339    * @param beneficiary who got the tokens
340    * @param value weis paid for purchase
341    * @param amount amount of tokens purchased
342    */
343   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
344 
345 
346   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
347     require(_startTime >= now);
348     require(_endTime >= _startTime);
349     require(_rate > 0);
350     require(_wallet != address(0));
351 
352     token = createTokenContract();
353     startTime = _startTime;
354     endTime = _endTime;
355     rate = _rate;
356     wallet = _wallet;
357   }
358 
359   // creates the token to be sold.
360   // override this method to have crowdsale of a specific mintable token.
361   function createTokenContract() internal returns (CogeneroToken);
362 
363 
364   // fallback function can be used to buy tokens
365   function () external payable {
366     buyTokens(msg.sender);
367   }
368 
369   // low level token purchase function
370   function buyTokens(address beneficiary) public payable {
371     require(beneficiary != address(0));
372     require(validPurchase());
373 
374     uint256 weiAmount = msg.value;
375 
376     // calculate token amount to be created
377     uint256 tokens = weiAmount.mul(rate);
378 
379     // update state
380     weiRaised = weiRaised.add(weiAmount);
381 
382     token.mint(beneficiary, tokens);
383     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
384 
385     forwardFunds();
386   }
387 
388   // send ether to the fund collection wallet
389   // override to create custom fund forwarding mechanisms
390   function forwardFunds() internal {
391     wallet.transfer(msg.value);
392   }
393 
394   // @return true if the transaction can buy tokens
395   function validPurchase() internal view returns (bool) {
396     bool withinPeriod = now >= startTime && now <= endTime;
397     bool nonZeroPurchase = msg.value != 0;
398     return withinPeriod && nonZeroPurchase;
399   }
400 
401   // @return true if crowdsale event has ended
402   function hasEnded() public view returns (bool) {
403     return now > endTime;
404   }
405 }
406 
407 contract Cogenero is Crowdsale, Ownable {
408 
409   uint256 constant CAP =  1000000000000000000000000000;
410   uint256 constant CAP_PRE_SALE = 180000000000000000000000000;
411   uint256 constant CAP_ICO_SALE = 320000000000000000000000000;
412 
413   uint256 public rate8_end_at = 1556524800;
414 
415   uint256 public totalSupplyIco;
416 
417   function Cogenero (
418     uint256 _startTime,
419     uint256 _endTime,
420     uint256 _rate,
421     address _wallet
422   ) public
423     Crowdsale(_startTime, _endTime, _rate, _wallet)
424   {
425   }
426 
427   function createTokenContract() internal returns (CogeneroToken) {
428     return CogeneroToken(0x88218eb0756bCa01a9f6be0c6EfF641e9b4d8101);
429   }
430 
431   // overriding Crowdsale#validPurchase
432   function validPurchase() internal constant returns (bool) {
433     if (msg.value < 20000000000000000) {
434       return false;
435     }
436 
437     if (token.totalSupply().add(msg.value.mul(getRate())) >= CAP) {
438       return false;
439     }
440 
441     if (now > 1538208000 && now < 1554105600) {
442       return false;
443     }
444 
445     if (1535788800 >= now && 1538208000 <= now) {
446       if (token.totalSupply().add(msg.value.mul(getRate())) >= CAP_PRE_SALE) {
447         return false;
448       }
449     }
450 
451     if (1554105600 >= now && 1556524800 <= now) {
452       if (totalSupplyIco.add(msg.value.mul(getRate())) >= CAP_ICO_SALE) {
453         return false;
454       }
455     }
456 
457     if (getRate() == 0) {
458       return false;
459     }
460 
461     return super.validPurchase();
462   }
463 
464   function buyTokens(address beneficiary) payable public {
465     require(beneficiary != address(0));
466     require(validPurchase());
467 
468     uint256 weiAmount = msg.value;
469     uint256 tokens = weiAmount.mul(getRate());
470     weiRaised = weiRaised.add(weiAmount);
471 
472     token.mint(beneficiary, tokens);
473     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
474 
475     forwardFunds();
476   }
477 
478   function getRate() public constant returns (uint256) {
479     if (1535788800 <= now && now <= 1536393599) {
480       return 30000;
481     }
482 
483     if (1536393600 <= now && now <= 1536998399) {
484       return 25500;
485     }
486 
487     if (1536998400 <= now && now <= 1537603199) {
488       return 22500;
489     }
490 
491     if (1537603200 <= now && now <= 1538208000) {
492       return 20000;
493     }
494 
495     if (1554105600 <= now && now <= 1554710399) {
496       return 8000;
497     }
498 
499     if (1554710400 <= now && now <= 1555315199) {
500       return 7000;
501     }
502 
503     if (1555315200 <= now && now <= 1555919999) {
504       return 6000;
505     }
506 
507     if (1555920000 <= now && now <= rate8_end_at) {
508       return 5000;
509     }
510 
511     return 0;
512   }
513 
514   function mintTokens(address walletToMint, uint256 t) onlyOwner payable public {
515     require(token.totalSupply().add(t) < CAP);
516 
517     token.mint(walletToMint, t);
518   }
519 
520   function tokenTransferOwnership(address newOwner) onlyOwner payable public {
521     token.transferOwnership(newOwner);
522   }
523 
524   function setAllowTransferGlobal(bool _status) public {
525     token.setAllowTransferGlobal(_status);
526   }
527 
528   function setAllowTransferLocal(bool _status) public {
529     token.setAllowTransferLocal(_status);
530   }
531 
532   function setAllowTransferExternal(bool _status) public {
533     token.setAllowTransferExternal(_status);
534   }
535 
536   function setManager(address _manager, bool _status) public {
537     token.setManager(_manager, _status);
538   }
539 
540   function setWhitelist(address _address, uint256 _date) public {
541     token.setWhitelist(_address, _date);
542   }
543 
544   function setLockupList(address _address, uint256 _date) public {
545     token.setLockupList(_address, _date);
546   }
547 
548   function setWildcardList(address _address, bool _status) public {
549     token.setWildcardList(_address, _status);
550   }
551 
552   function changeEnd(uint256 _end) onlyOwner public {
553     endTime = _end;
554     rate8_end_at = _end;
555   }
556 
557   function burn(address _burner, uint256 _value) onlyOwner public {
558     token.burn(_burner, _value);
559   }
560 
561 }