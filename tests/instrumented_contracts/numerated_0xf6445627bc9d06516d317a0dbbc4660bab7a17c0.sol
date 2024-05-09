1 pragma solidity ^0.4.18;
2 
3 // Deployed will@ethfinex.com 31/12/17
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45   function totalSupply() public constant returns (uint);
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56   function allowance(address owner, address spender) public view returns (uint256);
57   function transferFrom(address from, address to, uint256 value) public returns (bool);
58   function approve(address spender, uint256 value) public returns (bool);
59   event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 
181 contract UpgradedStandardToken is StandardToken {
182     // those methods are called by the legacy contract
183     // and they must ensure msg.sender to be the contract address
184     uint public _totalSupply;
185     function transferByLegacy(address from, address to, uint value) public returns (bool);
186     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
187     function approveByLegacy(address from, address spender, uint value) public returns (bool);
188     function increaseApprovalByLegacy(address from, address spender, uint addedValue) public returns (bool);
189     function decreaseApprovalByLegacy(address from, address spender, uint subtractedValue) public returns (bool);
190 }
191 
192 /**
193  * @title Ownable
194  * @dev The Ownable contract has an owner address, and provides basic authorization control
195  * functions, this simplifies the implementation of "user permissions".
196  */
197 contract Ownable {
198   address public owner;
199 
200 
201   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() public {
209     owner = msg.sender;
210   }
211 
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) public onlyOwner {
227     require(newOwner != address(0));
228     OwnershipTransferred(owner, newOwner);
229     owner = newOwner;
230   }
231 
232 }
233 
234 contract StandardTokenWithFees is StandardToken, Ownable {
235 
236   // Additional variables for use if transaction fees ever became necessary
237   uint256 public basisPointsRate = 0;
238   uint256 public maximumFee = 0;
239   uint256 constant MAX_SETTABLE_BASIS_POINTS = 20;
240   uint256 constant MAX_SETTABLE_FEE = 50;
241 
242   string public name;
243   string public symbol;
244   uint8 public decimals;
245   uint public _totalSupply;
246 
247   uint public constant MAX_UINT = 2**256 - 1;
248 
249   function calcFee(uint _value) public constant returns (uint) {
250     uint fee = (_value.mul(basisPointsRate)).div(10000);
251     if (fee > maximumFee) {
252         fee = maximumFee;
253     }
254     return fee;
255   }
256 
257   function transfer(address _to, uint _value) public returns (bool) {
258     uint fee = calcFee(_value);
259     uint sendAmount = _value.sub(fee);
260 
261     super.transfer(_to, sendAmount);
262     if (fee > 0) {
263       super.transfer(owner, fee);
264     }
265   }
266 
267   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
268     require(_to != address(0));
269     require(_value <= balances[_from]);
270     require(_value <= allowed[_from][msg.sender]);
271 
272     uint fee = calcFee(_value);
273     uint sendAmount = _value.sub(fee);
274 
275     balances[_from] = balances[_from].sub(_value);
276     balances[_to] = balances[_to].add(sendAmount);
277     if (allowed[_from][msg.sender] < MAX_UINT) {
278         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     }
280     Transfer(_from, _to, sendAmount);
281     if (fee > 0) {
282       balances[owner] = balances[owner].add(fee);
283       Transfer(_from, owner, fee);
284     }
285     return true;
286   }
287 
288   function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
289       // Ensure transparency by hardcoding limit beyond which fees can never be added
290       require(newBasisPoints < MAX_SETTABLE_BASIS_POINTS);
291       require(newMaxFee < MAX_SETTABLE_FEE);
292 
293       basisPointsRate = newBasisPoints;
294       maximumFee = newMaxFee.mul(uint(10)**decimals);
295 
296       Params(basisPointsRate, maximumFee);
297   }
298 
299   // Called if contract ever adds fees
300   event Params(uint feeBasisPoints, uint maxFee);
301 
302 }
303 
304 
305 /**
306  * @title Pausable
307  * @dev Base contract which allows children to implement an emergency stop mechanism.
308  */
309 contract Pausable is Ownable {
310   event Pause();
311   event Unpause();
312 
313   bool public paused = false;
314 
315 
316   /**
317    * @dev Modifier to make a function callable only when the contract is not paused.
318    */
319   modifier whenNotPaused() {
320     require(!paused);
321     _;
322   }
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is paused.
326    */
327   modifier whenPaused() {
328     require(paused);
329     _;
330   }
331 
332   /**
333    * @dev called by the owner to pause, triggers stopped state
334    */
335   function pause() onlyOwner whenNotPaused public {
336     paused = true;
337     Pause();
338   }
339 
340   /**
341    * @dev called by the owner to unpause, returns to normal state
342    */
343   function unpause() onlyOwner whenPaused public {
344     paused = false;
345     Unpause();
346   }
347 }
348 
349 /// @title Whitelist contract - Only addresses which are registered as part of the market maker loyalty scheme can be whitelisted to earn and own Nectar tokens
350 contract Whitelist is Ownable {
351 
352   bool public listActive = true;
353 
354   // Only users who are on the whitelist
355   function isRegistered(address _user) public constant returns (bool) {
356     if (!listActive) {
357       return true;
358     } else {
359       return isOnList[_user];
360     }
361   }
362 
363   // Only authorised sources/contracts can contribute fees on behalf of makers to earn tokens
364   modifier authorised () {
365     require(isAuthorisedMaker[msg.sender]);
366     _;
367   }
368 
369   // This is the whitelist of users who are registered to be able to own the tokens
370   mapping (address => bool) public isOnList;
371 
372   // This is a more select list of a few contracts or addresses which can contribute fees on behalf of makers, to generate tokens
373   mapping (address => bool) public isAuthorisedMaker;
374 
375 
376   /// @dev register
377   /// @param newUsers - Array of users to add to the whitelist
378   function register(address[] newUsers) public onlyOwner {
379     for (uint i = 0; i < newUsers.length; i++) {
380       isOnList[newUsers[i]] = true;
381     }
382   }
383 
384   /// @dev deregister
385   /// @param bannedUsers - Array of users to remove from the whitelist
386   function deregister(address[] bannedUsers) public onlyOwner {
387     for (uint i = 0; i < bannedUsers.length; i++) {
388       isOnList[bannedUsers[i]] = false;
389     }
390   }
391 
392   /// @dev authoriseMaker
393   /// @param maker - Source to add to authorised contributors
394   function authoriseMaker(address maker) public onlyOwner {
395       isAuthorisedMaker[maker] = true;
396       // Also add any authorised Maker to the whitelist
397       address[] memory makers = new address[](1);
398       makers[0] = maker;
399       register(makers);
400   }
401 
402   /// @dev deauthoriseMaker
403   /// @param maker - Source to remove from authorised contributors
404   function deauthoriseMaker(address maker) public onlyOwner {
405       isAuthorisedMaker[maker] = false;
406   }
407 
408   function activateWhitelist(bool newSetting) public onlyOwner {
409       listActive = newSetting;
410   }
411 
412   /////// Getters to allow the same whitelist to be used also by other contracts (including upgraded Controllers) ///////
413 
414   function getRegistrationStatus(address _user) constant external returns (bool) {
415     return isOnList[_user];
416   }
417 
418   function getAuthorisationStatus(address _maker) constant external returns (bool) {
419     return isAuthorisedMaker[_maker];
420   }
421 
422   function getOwner() external constant returns (address) {
423     return owner;
424   }
425 
426 
427 }
428 
429 contract TetherToken is Pausable, StandardTokenWithFees, Whitelist {
430 
431     address public upgradedAddress;
432     bool public deprecated;
433 
434     //  The contract can be initialized with a number of tokens
435     //  All the tokens are deposited to the owner address
436     //
437     // @param _balance Initial supply of the contract
438     // @param _name Token Name
439     // @param _symbol Token symbol
440     // @param _decimals Token decimals
441     function TetherToken(uint _initialSupply, string _name, string _symbol, uint8 _decimals) public {
442         _totalSupply = _initialSupply;
443         name = _name;
444         symbol = _symbol;
445         decimals = _decimals;
446         balances[owner] = _initialSupply;
447         deprecated = false;
448     }
449 
450     // Forward ERC20 methods to upgraded contract if this one is deprecated
451     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
452         require(isRegistered(msg.sender));
453         if (deprecated) {
454             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
455         } else {
456             return super.transfer(_to, _value);
457         }
458     }
459 
460     // Forward ERC20 methods to upgraded contract if this one is deprecated
461     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
462         require(isRegistered(_from));
463         if (deprecated) {
464             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
465         } else {
466             return super.transferFrom(_from, _to, _value);
467         }
468     }
469 
470     // Forward ERC20 methods to upgraded contract if this one is deprecated
471     function balanceOf(address who) public constant returns (uint) {
472         if (deprecated) {
473             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
474         } else {
475             return super.balanceOf(who);
476         }
477     }
478 
479     // Allow checks of balance at time of deprecation
480     function oldBalanceOf(address who) public constant returns (uint) {
481         if (deprecated) {
482             return super.balanceOf(who);
483         }
484     }
485 
486     // Forward ERC20 methods to upgraded contract if this one is deprecated
487     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
488         if (deprecated) {
489             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
490         } else {
491             return super.approve(_spender, _value);
492         }
493     }
494 
495     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
496         if (deprecated) {
497             return UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(msg.sender, _spender, _addedValue);
498         } else {
499             return super.increaseApproval(_spender, _addedValue);
500         }
501     }
502 
503     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
504         if (deprecated) {
505             return UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(msg.sender, _spender, _subtractedValue);
506         } else {
507             return super.decreaseApproval(_spender, _subtractedValue);
508         }
509     }
510 
511     // Forward ERC20 methods to upgraded contract if this one is deprecated
512     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
513         if (deprecated) {
514             return StandardToken(upgradedAddress).allowance(_owner, _spender);
515         } else {
516             return super.allowance(_owner, _spender);
517         }
518     }
519 
520     // deprecate current contract in favour of a new one
521     function deprecate(address _upgradedAddress) public onlyOwner {
522         require(_upgradedAddress != address(0));
523         deprecated = true;
524         upgradedAddress = _upgradedAddress;
525         Deprecate(_upgradedAddress);
526     }
527 
528     // deprecate current contract if favour of a new one
529     function totalSupply() public constant returns (uint) {
530         if (deprecated) {
531             return StandardToken(upgradedAddress).totalSupply();
532         } else {
533             return _totalSupply;
534         }
535     }
536 
537     // Issue a new amount of tokens
538     // these tokens are deposited into the owner address
539     //
540     // @param _amount Number of tokens to be issued
541     function issue(uint amount) public onlyOwner {
542         balances[owner] = balances[owner].add(amount);
543         _totalSupply = _totalSupply.add(amount);
544         Issue(amount);
545         Transfer(address(0), owner, amount);
546     }
547 
548     // Redeem tokens.
549     // These tokens are withdrawn from the owner address
550     // if the balance must be enough to cover the redeem
551     // or the call will fail.
552     // @param _amount Number of tokens to be issued
553     function redeem(uint amount) public onlyOwner {
554         _totalSupply = _totalSupply.sub(amount);
555         balances[owner] = balances[owner].sub(amount);
556         Redeem(amount);
557         Transfer(owner, address(0), amount);
558     }
559 
560     // Called when new token are issued
561     event Issue(uint amount);
562 
563     // Called when tokens are redeemed
564     event Redeem(uint amount);
565 
566     // Called when contract is deprecated
567     event Deprecate(address newAddress);
568 
569 }