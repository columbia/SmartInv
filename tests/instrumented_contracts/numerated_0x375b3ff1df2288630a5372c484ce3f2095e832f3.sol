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
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: zeppelin-solidity/contracts/token/CappedToken.sol
277 
278 /**
279  * @title Capped token
280  * @dev Mintable token with a token cap.
281  */
282 
283 contract CappedToken is MintableToken {
284 
285   uint256 public cap;
286 
287   function CappedToken(uint256 _cap) public {
288     require(_cap > 0);
289     cap = _cap;
290   }
291 
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will receive the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
299     require(totalSupply.add(_amount) <= cap);
300 
301     return super.mint(_to, _amount);
302   }
303 
304 }
305 
306 // File: contracts/FKX.sol
307 
308 /**
309  * @title FKX
310  */
311 contract FKX is CappedToken(FKX.TOKEN_SUPPLY) {
312 
313   using SafeMath for uint256;
314 
315   string public constant name = "Knoxstertoken";
316   string public constant symbol = "FKX";
317   uint8 public constant decimals = 18;
318   string public constant version = "1.0";
319   uint256 public constant TOKEN_SUPPLY  = 150000000 * (10 ** uint256(decimals)); // 150 Million FKX
320 
321 }
322 
323 // File: contracts/FKXTokenTimeLock.sol
324 
325 /**
326  * @title FKXTokenTimeLock
327  * @dev FKXTokenTimeLock is a token holder contract that will allow multiple
328  * beneficiaries to extract the tokens after a given release time. It is a modification of the  
329  * OpenZeppenlin TokenTimeLock to allow for one token lock smart contract for many beneficiaries. 
330  */
331 contract FKXTokenTimeLock is Ownable {
332 
333   /*
334    * Array with beneficiary lock indexes. 
335    */
336   address[] public lockIndexes;
337 
338   /**
339    * Encapsulates information abount a beneficiary's token time lock.
340    */
341   struct TokenTimeLockVault {
342       /**
343        * Amount of locked tokens.
344        */
345       uint256 amount;
346 
347       /**
348        * Timestamp when token release is enabled.
349        */
350       uint256 releaseTime;
351 
352       /**
353        * Lock array index.
354        */
355       uint256 arrayIndex;
356   }
357 
358   // ERC20 basic token contract being held.
359   FKX public token;
360 
361   // All beneficiaries' token time locks.
362   mapping(address => TokenTimeLockVault) public tokenLocks;
363 
364   function FKXTokenTimeLock(FKX _token) public {
365     token = _token;
366   }
367 
368   function lockTokens(address _beneficiary, uint256 _releaseTime, uint256 _tokens) external onlyOwner  {
369     require(_releaseTime > now);
370     require(_tokens > 0);
371 
372     TokenTimeLockVault storage lock = tokenLocks[_beneficiary];
373     lock.amount = _tokens;
374     lock.releaseTime = _releaseTime;
375     lock.arrayIndex = lockIndexes.length;
376     lockIndexes.push(_beneficiary);
377 
378     LockEvent(_beneficiary, _tokens, _releaseTime);
379   }
380 
381   function exists(address _beneficiary) external onlyOwner view returns (bool) {
382     TokenTimeLockVault memory lock = tokenLocks[_beneficiary];
383     return lock.amount > 0;
384   }
385 
386   /**
387    * @notice Transfers tokens held by timelock to beneficiary.
388    */
389   function release() public {
390     TokenTimeLockVault memory lock = tokenLocks[msg.sender];
391 
392     require(now >= lock.releaseTime);
393 
394     require(lock.amount > 0);
395 
396     delete tokenLocks[msg.sender];
397 
398     lockIndexes[lock.arrayIndex] = 0x0;
399 
400     UnlockEvent(msg.sender);
401 
402     assert(token.transfer(msg.sender, lock.amount));   
403   }
404 
405   /**
406    * @notice Transfers tokens held by timelock to all beneficiaries.
407    * @param from the start lock index
408    * @param to the end lock index
409    */
410   function releaseAll(uint from, uint to) external onlyOwner returns (bool) {
411     require(from >= 0);
412     require(to <= lockIndexes.length);
413     for (uint i = from; i < to; i++) {
414       address beneficiary = lockIndexes[i];
415       if (beneficiary == 0x0) { //Skip any previously removed locks
416         continue;
417       }
418       
419       TokenTimeLockVault memory lock = tokenLocks[beneficiary];
420       
421       if (!(now >= lock.releaseTime && lock.amount > 0)) { // Skip any locks that are not due to be release
422         continue;
423       }
424 
425       delete tokenLocks[beneficiary];
426 
427       lockIndexes[lock.arrayIndex] = 0x0;
428       
429       UnlockEvent(beneficiary);
430 
431       assert(token.transfer(beneficiary, lock.amount));
432     }
433     return true;
434   }
435 
436   /**
437    * Logged when tokens were time locked.
438    *
439    * @param beneficiary beneficiary to receive tokens once they are unlocked
440    * @param amount amount of locked tokens
441    * @param releaseTime unlock time
442    */
443   event LockEvent(address indexed beneficiary, uint256 amount, uint256 releaseTime);
444 
445   /**
446    * Logged when tokens were unlocked and sent to beneficiary.
447    *
448    * @param beneficiary beneficiary to receive tokens once they are unlocked
449    */
450   event UnlockEvent(address indexed beneficiary);
451   
452 }
453 
454 // File: contracts/FKXSale.sol
455 
456 /**
457  * @title FKXSale
458  * @dev FKXSale smart contracat used to mint and distrubute FKX tokens and lock up FKX tokens in the FKXTokenTimeLock smart contract.
459  * Inheritance:
460  * Ownable - lets FKXSale be ownable
461  *
462  */
463 contract FKXSale is Ownable {
464 
465   FKX public token;
466 
467   FKXTokenTimeLock public tokenLock;
468 
469   function FKXSale() public {
470 
471     token =  new FKX();
472 
473     tokenLock = new FKXTokenTimeLock(token);
474 
475   }
476 
477   /**
478   * @dev Finalizes the sale and  token minting
479   */
480   function finalize() public onlyOwner {
481     // Disable minting of FKX
482     token.finishMinting();
483   }
484 
485   /**
486   * @dev Allocates tokens and bonus tokens to early-bird contributors.
487   * @param beneficiary wallet
488   * @param baseTokens amount of tokens to be received by beneficiary
489   * @param bonusTokens amount of tokens to be locked up to beneficiary
490   * @param releaseTime when to unlock bonus tokens
491   */
492   function mintBaseLockedTokens(address beneficiary, uint256 baseTokens, uint256 bonusTokens, uint256 releaseTime) public onlyOwner {
493     require(beneficiary != 0x0);
494     require(baseTokens > 0);
495     require(bonusTokens > 0);
496     require(releaseTime > now);
497     require(!tokenLock.exists(beneficiary));
498     
499     // Mint base tokens to beneficiary
500     token.mint(beneficiary, baseTokens);
501 
502     // Mint beneficiary's bonus tokens to the token time lock
503     token.mint(tokenLock, bonusTokens);
504 
505     // Time lock the tokens
506     tokenLock.lockTokens(beneficiary, releaseTime, bonusTokens);
507   }
508 
509   /**
510   * @dev Allocates bonus tokens to advisors, founders and company.
511   * @param beneficiary wallet
512   * @param tokens amount of tokens to be locked up to beneficiary
513   * @param releaseTime when to unlock bonus tokens
514   */
515   function mintLockedTokens(address beneficiary, uint256 tokens, uint256 releaseTime) public onlyOwner {
516     require(beneficiary != 0x0);
517     require(tokens > 0);
518     require(releaseTime > now);
519     require(!tokenLock.exists(beneficiary));
520 
521     // Mint beneficiary's bonus tokens to the token time lock
522     token.mint(tokenLock, tokens);
523 
524     // Time lock the tokens
525     tokenLock.lockTokens(beneficiary, releaseTime, tokens);
526   }
527 
528   /**
529   * @dev Allocates tokens to beneficiary.
530   * @param beneficiary wallet
531   * @param tokens amount of tokens to be received by beneficiary
532   */
533   function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
534     require(beneficiary != 0x0);
535     require(tokens > 0);
536     
537     // Mint tokens to beneficiary
538     token.mint(beneficiary, tokens);
539   }
540 
541   /**
542   * @dev Release locked tokens to all beneficiaries if they are due.
543   * @param from the start lock index
544   * @param to the end lock index
545   */
546   function releaseAll(uint from, uint to) public onlyOwner returns (bool) {
547     tokenLock.releaseAll(from, to);
548 
549     return true;
550   }
551 
552 
553 }