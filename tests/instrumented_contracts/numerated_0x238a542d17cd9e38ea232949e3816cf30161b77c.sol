1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) returns (bool);
20   function approve(address spender, uint256 value) returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 /**
24  * @title Basic token
25  * @dev Basic version of StandardToken, with no allowances. 
26  */
27 contract BasicToken is ERC20Basic {
28   using SafeMath for uint256;
29 
30   mapping(address => uint256) balances;
31 
32   /**
33   * @dev transfer token for a specified address
34   * @param _to The address to transfer to.
35   * @param _value The amount to be transferred.
36   */
37   function transfer(address _to, uint256 _value) returns (bool) {
38     require(_to != address(0));
39 
40     // SafeMath.sub will throw if there is not enough balance.
41     balances[msg.sender] = balances[msg.sender].sub(_value);
42     balances[_to] = balances[_to].add(_value);
43     Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 
47   /**
48   * @dev Gets the balance of the specified address.
49   * @param _owner The address to query the the balance of. 
50   * @return An uint256 representing the amount owned by the passed address.
51   */
52   function balanceOf(address _owner) constant returns (uint256 balance) {
53     return balances[_owner];
54   }
55 
56 }
57 /**
58  * @title Standard ERC20 token
59  *
60  * @dev Implementation of the basic standard token.
61  * @dev https://github.com/ethereum/EIPs/issues/20
62  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
63  */
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68 
69   /**
70    * @dev Transfer tokens from one address to another
71    * @param _from address The address which you want to send tokens from
72    * @param _to address The address which you want to transfer to
73    * @param _value uint256 the amount of tokens to be transferred
74    */
75   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76     require(_to != address(0));
77 
78     var _allowance = allowed[_from][msg.sender];
79 
80     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
81     // require (_value <= _allowance);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = _allowance.sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   /**
91    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
92    * @param _spender The address which will spend the funds.
93    * @param _value The amount of tokens to be spent.
94    */
95   function approve(address _spender, uint256 _value) returns (bool) {
96 
97     // To change the approve amount you first have to reduce the addresses`
98     //  allowance to zero by calling `approve(_spender, 0)` if it is not
99     //  already 0 to mitigate the race condition described here:
100     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
102 
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   /**
109    * @dev Function to check the amount of tokens that an owner allowed to a spender.
110    * @param _owner address The address which owns the funds.
111    * @param _spender address The address which will spend the funds.
112    * @return A uint256 specifying the amount of tokens still available for the spender.
113    */
114   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115     return allowed[_owner][_spender];
116   }
117   
118   /**
119    * approve should be called when allowed[_spender] == 0. To increment
120    * allowed value is better to use this function to avoid 2 calls (and wait until 
121    * the first transaction is mined)
122    * From MonolithDAO Token.sol
123    */
124   function increaseApproval (address _spender, uint _addedValue) 
125     returns (bool success) {
126     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval (address _spender, uint _subtractedValue) 
132     returns (bool success) {
133     uint oldValue = allowed[msg.sender][_spender];
134     if (_subtractedValue > oldValue) {
135       allowed[msg.sender][_spender] = 0;
136     } else {
137       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
138     }
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143 }
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() {
161     owner = msg.sender;
162   }
163 
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner {
179     require(newOwner != address(0));      
180     OwnershipTransferred(owner, newOwner);
181     owner = newOwner;
182   }
183 
184 }
185 /**
186  * @title Mintable token
187  * @dev Simple ERC20 Token example, with mintable token creation
188  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
189  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
190  */
191 contract MintableToken is StandardToken, Ownable {
192   event Mint(address indexed to, uint256 amount);
193   event MintFinished();
194 
195   bool public mintingFinished = false;
196 
197 
198   modifier canMint() {
199     require(!mintingFinished);
200     _;
201   }
202 
203   /**
204    * @dev Function to mint tokens
205    * @param _to The address that will receive the minted tokens.
206    * @param _amount The amount of tokens to mint.
207    * @return A boolean that indicates if the operation was successful.
208    */
209   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
210     totalSupply = totalSupply.add(_amount);
211     balances[_to] = balances[_to].add(_amount);
212     Mint(_to, _amount);
213     Transfer(0x0, _to, _amount);
214     return true;
215   }
216 
217   /**
218    * @dev Function to stop minting new tokens.
219    * @return True if the operation was successful.
220    */
221   function finishMinting() onlyOwner returns (bool) {
222     mintingFinished = true;
223     MintFinished();
224     return true;
225   }
226 }
227 /**
228  * @title SafeMath
229  * @dev Math operations with safety checks that throw on error
230  */
231 library SafeMath {
232   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
233     uint256 c = a * b;
234     assert(a == 0 || c / a == b);
235     return c;
236   }
237 
238   function div(uint256 a, uint256 b) internal constant returns (uint256) {
239     // assert(b > 0); // Solidity automatically throws when dividing by 0
240     uint256 c = a / b;
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242     return c;
243   }
244 
245   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
246     assert(b <= a);
247     return a - b;
248   }
249 
250   function add(uint256 a, uint256 b) internal constant returns (uint256) {
251     uint256 c = a + b;
252     assert(c >= a);
253     return c;
254   }
255 }
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261   event Pause();
262   event Unpause();
263 
264   bool public paused = true;
265 
266 
267   /**
268    * @dev Modifier to make a function callable only when the contract is not paused.
269    */
270   modifier whenNotPaused() {
271     require(!paused);
272     _;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is paused.
277    */
278   modifier whenPaused() {
279     require(paused);
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() onlyOwner whenNotPaused public {
287     paused = true;
288     Pause();
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() onlyOwner whenPaused public {
295     paused = false;
296     Unpause();
297   }
298 }
299 /**
300  * @title Pausable token
301  *
302  * @dev StandardToken modified with pausable transfers.
303  **/
304 contract PausableToken is StandardToken, Pausable {
305 
306   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
307     return super.transfer(_to, _value);
308   }
309 
310   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
311     return super.transferFrom(_from, _to, _value);
312   }
313 
314   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
315     return super.approve(_spender, _value);
316   }
317 
318   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
319     return super.increaseApproval(_spender, _addedValue);
320   }
321 
322   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
323     return super.decreaseApproval(_spender, _subtractedValue);
324   }
325 }
326 /**
327  * contract CryptoTradeCoin
328  **/
329 contract CryptoTradeCoin is PausableToken, MintableToken {
330 
331   string public constant name = "CryptoTradeCoin";
332   string public constant symbol = "CTC";
333   uint8 public constant decimals = 18;
334 }
335 /**
336  * contract CryptoTradeCrowdsale
337  **/
338 contract CryptoTradeCrowdsale is Ownable {
339 
340 using SafeMath for uint;
341 
342 address public multisigWallet;
343 address public founderTokenWallet;
344 address public bountyTokenWallet;
345 uint public founderPercent;
346 uint public bountyPercent;
347 uint public startRound;
348 uint public periodRound;
349 uint public capitalization;
350 uint public altCapitalization;
351 uint public totalCapitalization;
352 uint public price;
353 uint public discountTime;
354 bool public isDiscountValue;
355 uint public targetDiscountValue1;
356 uint public targetDiscountValue2;
357 uint public targetDiscountValue3;
358 uint public targetDiscountValue4;
359 uint public targetDiscountValue5;
360 uint public targetDiscountValue6;
361 uint public targetDiscountValue7;
362 uint public targetDiscountValue8;
363 uint public targetDiscountValue9;
364 uint public targetDiscountValue10;
365 
366 CryptoTradeCoin public token = new CryptoTradeCoin ();
367 
368 function CryptoTradeCrowdsale () public {
369 	multisigWallet = 0xdee04DfdC6C93D51468ba5cd90457Ac0B88055FD;
370 	founderTokenWallet = 0x874297a0eDaB173CFdDeD1e890842A5564191D36;
371 	bountyTokenWallet = 0x77C99A76B3dF279a73396fE9ae0A072B428b63Fe;
372 	founderPercent = 10;
373 	bountyPercent = 5;
374 	startRound = 1509584400;
375 	periodRound = 90;
376 	capitalization = 3300 ether;
377 	altCapitalization = 0;
378 	totalCapitalization = 200000 ether;
379 	price = 1000000000000000000000000; 
380 	discountTime = 50;
381 	isDiscountValue = false;
382 	targetDiscountValue1 = 2    ether;
383 	targetDiscountValue2 = 4    ether;
384 	targetDiscountValue3 = 8    ether;
385 	targetDiscountValue4 = 16   ether;
386 	targetDiscountValue5 = 32   ether;
387 	targetDiscountValue6 = 64   ether;
388 	targetDiscountValue7 = 128  ether;
389 	targetDiscountValue8 = 256  ether;
390 	targetDiscountValue9 = 512  ether;
391 	targetDiscountValue10= 1024 ether;
392 	}
393 
394 modifier CrowdsaleIsOn() {
395 	require(now >= startRound && now <= startRound + periodRound * 1 days);
396 	_;
397 	}
398 modifier TotalCapitalization() {
399 	require(multisigWallet.balance + altCapitalization <= totalCapitalization);
400 	_;
401 	}
402 modifier RoundCapitalization() {
403 	require(multisigWallet.balance + altCapitalization <= capitalization);
404 	_;
405 	}
406 
407 function setMultisigWallet (address newMultisigWallet) public onlyOwner {
408 	require(newMultisigWallet != 0X0);
409 	multisigWallet = newMultisigWallet;
410 	}
411 function setFounderTokenWallet (address newFounderTokenWallet) public onlyOwner {
412 	require(newFounderTokenWallet != 0X0);
413 	founderTokenWallet = newFounderTokenWallet;
414 	}
415 function setBountyTokenWallet (address newBountyTokenWallet) public onlyOwner {
416 	require(newBountyTokenWallet != 0X0);
417 	bountyTokenWallet = newBountyTokenWallet;
418 	}
419 	
420 function setFounderPercent (uint newFounderPercent) public onlyOwner {
421 	founderPercent = newFounderPercent;
422 	}
423 function setBountyPercent (uint newBountyPercent) public onlyOwner {
424 	bountyPercent = newBountyPercent;
425 	}
426 	
427 function setStartRound (uint newStartRound) public onlyOwner {
428 	startRound = newStartRound;
429 	}
430 function setPeriodRound (uint newPeriodRound) public onlyOwner {
431 	periodRound = newPeriodRound;
432 	} 
433 	
434 function setCapitalization (uint newCapitalization) public onlyOwner {
435 	capitalization = newCapitalization;
436 	}
437 function setAltCapitalization (uint newAltCapitalization) public onlyOwner {
438 	altCapitalization = newAltCapitalization;
439 	}
440 function setTotalCapitalization (uint newTotalCapitalization) public onlyOwner {
441 	totalCapitalization = newTotalCapitalization;
442 	}
443 	
444 function setPrice (uint newPrice) public onlyOwner {
445 	price = newPrice;
446 	}
447 function setDiscountTime (uint newDiscountTime) public onlyOwner {
448 	discountTime = newDiscountTime;
449 	}
450 	
451 function setDiscountValueOn () public onlyOwner {
452 	require(!isDiscountValue);
453 	isDiscountValue = true;
454 	}
455 function setDiscountValueOff () public onlyOwner {
456 	require(isDiscountValue);
457 	isDiscountValue = false;
458 	}
459 	
460 function setTargetDiscountValue1  (uint newTargetDiscountValue1)  public onlyOwner {
461 	require(newTargetDiscountValue1 > 0);
462 	targetDiscountValue1 = newTargetDiscountValue1;
463 	}
464 function setTargetDiscountValue2  (uint newTargetDiscountValue2)  public onlyOwner {
465 	require(newTargetDiscountValue2 > 0);
466 	targetDiscountValue2 = newTargetDiscountValue2;
467 	}
468 function setTargetDiscountValue3  (uint newTargetDiscountValue3)  public onlyOwner {
469 	require(newTargetDiscountValue3 > 0);
470 	targetDiscountValue3 = newTargetDiscountValue3;
471 	}
472 function setTargetDiscountValue4  (uint newTargetDiscountValue4)  public onlyOwner {
473 	require(newTargetDiscountValue4 > 0);
474 	targetDiscountValue4 = newTargetDiscountValue4;
475 	}
476 function setTargetDiscountValue5  (uint newTargetDiscountValue5)  public onlyOwner {
477 	require(newTargetDiscountValue5 > 0);
478 	targetDiscountValue5 = newTargetDiscountValue5;
479 	}
480 function setTargetDiscountValue6  (uint newTargetDiscountValue6)  public onlyOwner {
481 	require(newTargetDiscountValue6 > 0);
482 	targetDiscountValue6 = newTargetDiscountValue6;
483 	}
484 function setTargetDiscountValue7  (uint newTargetDiscountValue7)  public onlyOwner {
485 	require(newTargetDiscountValue7 > 0);
486 	targetDiscountValue7 = newTargetDiscountValue7;
487 	}
488 function setTargetDiscountValue8  (uint newTargetDiscountValue8)  public onlyOwner {
489 	require(newTargetDiscountValue8 > 0);
490 	targetDiscountValue8 = newTargetDiscountValue8;
491 	}
492 function setTargetDiscountValue9  (uint newTargetDiscountValue9)  public onlyOwner {
493 	require(newTargetDiscountValue9 > 0);
494 	targetDiscountValue9 = newTargetDiscountValue9;
495 	}
496 function setTargetDiscountValue10 (uint newTargetDiscountValue10) public onlyOwner {
497 	require(newTargetDiscountValue10 > 0);
498 	targetDiscountValue10 = newTargetDiscountValue10;
499 	}
500 	
501 function () external payable {
502 	createTokens (msg.sender, msg.value);
503 	}
504 
505 function createTokens (address recipient, uint etherDonat) internal CrowdsaleIsOn RoundCapitalization TotalCapitalization {
506 	require(etherDonat > 0); // etherDonat in wei
507 	require(recipient != 0X0);
508 	require(price > 0);
509 	multisigWallet.transfer(etherDonat);
510 	uint discountValue = discountValueSolution (etherDonat);
511 	uint bonusDiscountValue = (etherDonat.mul(price).div(1 ether)).mul(discountValue).div(100);
512 	uint bonusDiscountTime  = (etherDonat.mul(price).div(1 ether)).mul(discountTime).div(100);
513     uint tokens = (etherDonat.mul(price).div(1 ether)).add(bonusDiscountTime).add(bonusDiscountValue);
514 	token.mint(recipient, tokens);
515 	}
516 
517 function customCreateTokens(address recipient, uint etherDonat) public CrowdsaleIsOn RoundCapitalization TotalCapitalization onlyOwner {
518 	require(etherDonat > 0); // etherDonat in wei
519 	require(recipient != 0X0);
520 	require(price > 0);
521 	uint discountValue = discountValueSolution (etherDonat);
522 	uint bonusDiscountValue = (etherDonat.mul(price).div(1 ether)).mul(discountValue).div(100);
523 	uint bonusDiscountTime  = (etherDonat.mul(price).div(1 ether)).mul(discountTime).div(100);
524     uint tokens = (etherDonat.mul(price).div(1 ether)).add(bonusDiscountTime).add(bonusDiscountValue);
525 	token.mint(recipient, tokens);
526 	altCapitalization += etherDonat;
527 	}
528 
529 function retrieveTokens (address addressToken, address wallet) public onlyOwner {
530 	ERC20 alientToken = ERC20 (addressToken);
531 	alientToken.transfer(wallet, alientToken.balanceOf(this));
532 	}
533 
534 function finishMinting () public onlyOwner {
535 	uint issuedTokenSupply = token.totalSupply(); 
536 	uint tokensFounders = issuedTokenSupply.mul(founderPercent).div(100);
537 	uint tokensBounty = issuedTokenSupply.mul(bountyPercent).div(100);
538 	token.mint(founderTokenWallet, tokensFounders);
539 	token.mint(bountyTokenWallet, tokensBounty);
540 	token.finishMinting();
541 	}
542 
543 function setOwnerToken (address newOwnerToken) public onlyOwner {
544 	require(newOwnerToken != 0X0);
545 	token.transferOwnership(newOwnerToken); 
546 	}
547 
548 function coefficientSolution (uint _donat) internal constant returns (uint) {  
549 	require(isDiscountValue);
550  	uint _discountValue;
551 	if (_donat < targetDiscountValue1) { 
552 		return _discountValue = 0;
553 	} else if (_donat >= targetDiscountValue1 && _donat < targetDiscountValue2) { 
554 		return _discountValue = 2;
555 	} else if (_donat >= targetDiscountValue2 && _donat < targetDiscountValue3) { 
556 		return _discountValue = 4;
557 	} else if (_donat >= targetDiscountValue3 && _donat < targetDiscountValue4) { 
558 		return _discountValue = 6;
559 	} else if (_donat >= targetDiscountValue4 && _donat < targetDiscountValue5) { 
560 		return _discountValue = 8;
561 	} else if (_donat >= targetDiscountValue5 && _donat < targetDiscountValue6) { 
562 		return _discountValue = 10;
563 	} else if (_donat >= targetDiscountValue6 && _donat < targetDiscountValue7) { 
564 		return _discountValue = 12;
565 	} else if (_donat >= targetDiscountValue7 && _donat < targetDiscountValue8) { 
566 		return _discountValue = 14;
567 	} else if (_donat >= targetDiscountValue8 && _donat < targetDiscountValue9) { 
568 		return _discountValue = 16;
569 	} else if (_donat >= targetDiscountValue9 && _donat < targetDiscountValue10){ 
570 		return _discountValue = 18;
571 	} else {   
572 		return _discountValue = 20;
573 	}
574    }
575 
576 function discountValueSolution (uint Donat) internal constant returns (uint) {
577 	uint DiscountValue;
578 	if (!isDiscountValue) {
579 		DiscountValue = 0;
580 		return DiscountValue;
581 	} else {
582 		DiscountValue = coefficientSolution (Donat);
583 		return DiscountValue;
584 	}
585    }
586 
587 }