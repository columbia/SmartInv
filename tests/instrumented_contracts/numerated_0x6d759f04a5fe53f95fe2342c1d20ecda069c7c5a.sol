1 pragma solidity ^0.4.23;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48  
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60  
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71  
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115  
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public view returns (uint256) {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * @dev Increase the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _addedValue The amount of tokens to increase the allowance by.
180    */
181   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   /**
188    * @dev Decrease the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To decrement
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _subtractedValue The amount of tokens to decrease the allowance by.
196    */
197   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
198     uint oldValue = allowed[msg.sender][_spender];
199     if (_subtractedValue > oldValue) {
200       allowed[msg.sender][_spender] = 0;
201     } else {
202       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203     }
204     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208 }
209  
210 /**
211  * @title Ownable
212  * @dev The Ownable contract has an owner address, and provides basic authorization control
213  * functions, this simplifies the implementation of "user permissions".
214  */
215 contract Ownable {
216   address internal owner;
217 
218   event OwnershipRenounced(address indexed previousOwner);
219   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
220 
221   /**
222    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
223    * account.
224    */
225   constructor() public {
226     owner = msg.sender;
227   }
228 
229   /**
230    * @dev Throws if called by any account other than the owner.
231    */
232   modifier onlyOwner() {
233     require(msg.sender == owner);
234     _;
235   }
236 
237   /**
238    * @dev Allows the current owner to transfer control of the contract to a newOwner.
239    * @param newOwner The address to transfer ownership to.
240    */
241   function transferOwnership(address newOwner) public onlyOwner {
242     require(newOwner != address(0));
243     emit OwnershipTransferred(owner, newOwner);
244     owner = newOwner;
245   }
246 
247   /**
248    * @dev Allows the current owner to relinquish control of the contract.
249    */
250   function renounceOwnership() public onlyOwner {
251     emit OwnershipRenounced(owner);
252     owner = address(0);
253   }
254   
255 }
256  
257 /**
258  * @title Mintable token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263  
264 contract MintableToken is StandardToken, Ownable {
265     
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268   event MintStarted();
269  
270   bool public mintingFinished = false;
271  
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276  
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will recieve the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
284     totalSupply_ = totalSupply_.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     emit Mint(_to, _amount);
287     emit Transfer(address(0), _to, _amount);
288     return true;
289   }
290  
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() public onlyOwner returns (bool) {
296     mintingFinished = true;
297     emit MintFinished();
298     return true;
299   }
300   
301   /**
302    * @dev Function to start minting new tokens.
303    * @return True if the operation was successful.
304    */
305   function startMinting() public onlyOwner returns (bool) {
306     mintingFinished = false;
307     emit MintStarted();
308     return true;
309   }
310   
311 }
312 
313 contract KassotBasicToken is MintableToken {
314     
315   string public constant name = "Kassot Token";  
316   string public constant symbol = "KATOK";  
317   uint8 public constant decimals = 18;
318   
319   uint public constant decimalMultiply = 1000000000000000000;  
320   
321 }
322  
323 /*
324  * @title KassotToken
325  * @dev Kassot token crowdsale contract
326  * @dev Author: Alexander Kazorin <akazorin@gmail.com>
327  */ 
328 contract KassotToken is ERC20, Ownable {
329   
330   using SafeMath for uint;
331   
332   bool public saleFinished = false;
333   address internal multisig;
334   address internal restricted;
335   uint public restrictedPercent;
336   uint public hardcap;
337   uint public softcap;
338   uint public firstBonusPercent;
339   uint public secondBonusPercent;
340   uint public thirdBonusPercent;
341   uint public rate;                       // Price (%rate% KST = 1 ETH)
342   uint public currentRound;
343   bool public allowRefund = false;        // Set to true if under softcap
344   KassotBasicToken internal token = new KassotBasicToken();
345   mapping (uint => mapping (address => uint)) public balances;
346   mapping(uint => uint) internal bonuses;
347   mapping(uint => uint) internal amounts;
348 
349   constructor(address _multisig, address _restricted) public {
350     multisig = _multisig;
351     restricted = _restricted;
352     
353     // Settings for first round
354     restrictedPercent = 10;
355     hardcap = 900 * 1 ether;
356     softcap = 30 * 1 ether;
357     rate = 112600 * token.decimalMultiply();
358     currentRound = 1;
359     firstBonusPercent = 50;
360     secondBonusPercent = 25;
361     thirdBonusPercent = 10;
362   }
363 
364   modifier saleIsOn() {
365     require(!saleFinished);
366     _;
367   }
368 
369   modifier isUnderHardCap() {
370     require(address(this).balance <= hardcap);
371     _;
372   }
373   
374   // ERC20 Inteface methods
375   function name() public view returns (string) {
376     return token.name();
377   }
378   
379   function symbol() public view returns (string) {
380     return token.symbol();
381   }
382   
383   function decimals() public view returns (uint8) {
384     return token.decimals();
385   }
386   
387   function totalSupply() public view returns (uint256) {
388     return token.totalSupply();
389   }
390 
391   function transfer(address _to, uint256 _value) public returns (bool) {
392     return token.transfer(_to, _value);
393   }
394 
395   function balanceOf(address _owner) public view returns (uint256) {
396     return token.balanceOf(_owner);
397   }
398 
399   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
400     return token.transferFrom(_from, _to, _value);
401   }
402 
403   function approve(address _spender, uint256 _value) public returns (bool) {
404     return token.approve(_spender, _value);
405   }
406 
407   function allowance(address _owner, address _spender) public view returns (uint256) {
408     return token.allowance(_owner, _spender);
409   }
410   // End of ERC20 Inteface methods
411 
412   function setMultisig(address _multisig) public onlyOwner returns (bool) {
413     multisig = _multisig;
414     return true;
415   }
416   
417   function setRestricted(address _restricted) public onlyOwner returns (bool) {
418     restricted = _restricted;
419     return true;
420   }
421   
422   function setRestrictedPercent(uint _restrictedPercent) public onlyOwner returns (bool) {
423     restrictedPercent = _restrictedPercent;
424     return true;
425   }
426   
427   function setHardcap(uint _hardcap) public onlyOwner returns (bool) {
428     hardcap = _hardcap;
429     return true;
430   }
431   
432   function setSoftcap(uint _softcap) public onlyOwner returns (bool) {
433     softcap = _softcap;
434     return true;
435   }
436   
437   function setRate(uint _rate) public onlyOwner returns (bool) {
438     rate = _rate;
439     return true;
440   }
441   
442   function setCurrentRound(uint _currentRound) public onlyOwner returns (bool) {
443     currentRound = _currentRound;
444     return true;
445   }
446   
447   function setFirstBonusPercent(uint _firstBonusPercent) public onlyOwner returns (bool) {
448     firstBonusPercent = _firstBonusPercent;
449     return true;
450   }
451   
452   function setSecondBonusPercent(uint _secondBonusPercent) public onlyOwner returns (bool) {
453     secondBonusPercent = _secondBonusPercent;
454     return true;
455   }
456   
457   function setThirdBonusPercent(uint _thirdBonusPercent) public onlyOwner returns (bool) {
458     thirdBonusPercent = _thirdBonusPercent;
459     return true;
460   }
461   
462   function getMultisig() public view onlyOwner returns (address) {
463     // only owner can show address for safety reasons
464     return multisig;
465   }
466   
467   function getRestricted() public view onlyOwner returns (address) {
468     // only owner can show address for safety reasons
469     return restricted;
470   }
471 
472   function refund() public {
473     require(allowRefund);
474     uint value = balances[currentRound][msg.sender]; 
475     balances[currentRound][msg.sender] = 0; 
476     msg.sender.transfer(value); 
477   }
478 
479   function finishSale() public onlyOwner {
480     if (address(this).balance > softcap) {
481       multisig.transfer(address(this).balance);
482       uint issuedTokenSupply = token.totalSupply();
483       uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100);
484       token.mint(restricted, restrictedTokens);
485     } else {
486       allowRefund = true;
487     }
488     token.finishMinting();
489     saleFinished = true;
490   }
491   
492   function startSale() public onlyOwner {
493     token.startMinting();
494     allowRefund = false;
495     saleFinished = false;
496   }
497 
498   function calculateTokens(uint _amount, uint _stage, uint _stageAmount) public returns (uint) {
499     bonuses[1] = firstBonusPercent;
500     bonuses[2] = secondBonusPercent;
501     bonuses[3] = thirdBonusPercent;
502     bonuses[4] = 0;
503     
504     amounts[1] = 0;
505     amounts[2] = 0;
506     amounts[3] = 0;
507     amounts[4] = 0;
508     
509     int amount = int(_amount);
510     
511     uint i = _stage;
512     while (amount > 0) {
513       if (i > 3) {
514         amounts[i] = uint(amount);
515         break;
516       }
517       if (amount - int(_stageAmount) > 0) {
518         amounts[i] = _stageAmount;
519         amount -= int(_stageAmount);
520         i++;
521       } else {
522         amounts[i] = uint(amount);
523         break;
524       }
525     }
526     
527     uint tokens = 0;
528     uint bonusTokens = 0;
529     uint _tokens = 0;
530     for (i = _stage; i <= 4; i++) {
531       if (amounts[i] == 0) {
532         break;
533       }
534       _tokens = rate.mul(amounts[i]).div(1 ether);
535       bonusTokens = _tokens * bonuses[i] / 100;
536       tokens += _tokens + bonusTokens;
537     }
538     
539     return tokens;
540   }
541   
542   function createTokens() public isUnderHardCap saleIsOn payable {
543     uint amount = msg.value;
544     uint tokens = 0;    
545     uint stageAmount = hardcap.div(4);
546     
547     if (address(this).balance <= stageAmount) {
548       tokens = calculateTokens(amount, 1, stageAmount);
549     } else if (address(this).balance <= stageAmount * 2) {
550       tokens = calculateTokens(amount, 2, stageAmount);
551     } else if (address(this).balance <= stageAmount * 3) {
552       tokens = calculateTokens(amount, 3, stageAmount);
553     } else {
554       tokens = calculateTokens(amount, 4, stageAmount);
555     }
556     
557     token.mint(msg.sender, tokens);
558     balances[currentRound][msg.sender] = balances[currentRound][msg.sender].add(amount);
559   }
560 
561   function() external payable {
562     createTokens();
563   }
564   
565 }