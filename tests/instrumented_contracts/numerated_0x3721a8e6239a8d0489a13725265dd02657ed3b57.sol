1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   function totalSupply() public constant returns (uint);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[msg.sender]);
77 
78     // SafeMath.sub will throw if there is not enough balance.
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 
179 contract UpgradedStandardToken is StandardToken {
180     // those methods are called by the legacy contract
181     // and they must ensure msg.sender to be the contract address
182     uint public _totalSupply;
183     function transferByLegacy(address from, address to, uint value) public returns (bool);
184     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
185     function approveByLegacy(address from, address spender, uint value) public returns (bool);
186     function increaseApprovalByLegacy(address from, address spender, uint addedValue) public returns (bool);
187     function decreaseApprovalByLegacy(address from, address spender, uint subtractedValue) public returns (bool);
188 }
189 
190 /**
191  * @title Ownable
192  * @dev The Ownable contract has an owner address, and provides basic authorization control
193  * functions, this simplifies the implementation of "user permissions".
194  */
195 contract Ownable {
196   address public owner;
197 
198 
199   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201 
202   /**
203    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
204    * account.
205    */
206   function Ownable() public {
207     owner = msg.sender;
208   }
209 
210 
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     require(msg.sender == owner);
216     _;
217   }
218 
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) public onlyOwner {
225     require(newOwner != address(0));
226     OwnershipTransferred(owner, newOwner);
227     owner = newOwner;
228   }
229 
230 }
231 
232 contract StandardTokenWithFees is StandardToken, Ownable {
233 
234   // Additional variables for use if transaction fees ever became necessary
235   uint256 public basisPointsRate = 0;
236   uint256 public maximumFee = 0;
237   uint256 constant MAX_SETTABLE_BASIS_POINTS = 20;
238   uint256 constant MAX_SETTABLE_FEE = 50;
239 
240   string public name;
241   string public symbol;
242   uint8 public decimals;
243   uint public _totalSupply;
244 
245   uint public constant MAX_UINT = 2**256 - 1;
246 
247   function calcFee(uint _value) public constant returns (uint) {
248     uint fee = (_value.mul(basisPointsRate)).div(10000);
249     if (fee > maximumFee) {
250         fee = maximumFee;
251     }
252     return fee;
253   }
254 
255   function transfer(address _to, uint _value) public returns (bool) {
256     uint fee = calcFee(_value);
257     uint sendAmount = _value.sub(fee);
258 
259     super.transfer(_to, sendAmount);
260     if (fee > 0) {
261       super.transfer(owner, fee);
262     }
263   }
264 
265   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
266     require(_to != address(0));
267     require(_value <= balances[_from]);
268     require(_value <= allowed[_from][msg.sender]);
269 
270     uint fee = calcFee(_value);
271     uint sendAmount = _value.sub(fee);
272 
273     balances[_from] = balances[_from].sub(_value);
274     balances[_to] = balances[_to].add(sendAmount);
275     if (allowed[_from][msg.sender] < MAX_UINT) {
276         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
277     }
278     Transfer(_from, _to, sendAmount);
279     if (fee > 0) {
280       balances[owner] = balances[owner].add(fee);
281       Transfer(_from, owner, fee);
282     }
283     return true;
284   }
285 
286   function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
287       // Ensure transparency by hardcoding limit beyond which fees can never be added
288       require(newBasisPoints < MAX_SETTABLE_BASIS_POINTS);
289       require(newMaxFee < MAX_SETTABLE_FEE);
290 
291       basisPointsRate = newBasisPoints;
292       maximumFee = newMaxFee.mul(uint(10)**decimals);
293 
294       Params(basisPointsRate, maximumFee);
295   }
296 
297   // Called if contract ever adds fees
298   event Params(uint feeBasisPoints, uint maxFee);
299 
300 }
301 
302 
303 /**
304  * @title Pausable
305  * @dev Base contract which allows children to implement an emergency stop mechanism.
306  */
307 contract Pausable is Ownable {
308   event Pause();
309   event Unpause();
310 
311   bool public paused = false;
312 
313 
314   /**
315    * @dev Modifier to make a function callable only when the contract is not paused.
316    */
317   modifier whenNotPaused() {
318     require(!paused);
319     _;
320   }
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is paused.
324    */
325   modifier whenPaused() {
326     require(paused);
327     _;
328   }
329 
330   /**
331    * @dev called by the owner to pause, triggers stopped state
332    */
333   function pause() onlyOwner whenNotPaused public {
334     paused = true;
335     Pause();
336   }
337 
338   /**
339    * @dev called by the owner to unpause, returns to normal state
340    */
341   function unpause() onlyOwner whenPaused public {
342     paused = false;
343     Unpause();
344   }
345 }
346 
347 
348 contract BlackList is Ownable {
349 
350     /////// Getter to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
351     function getBlackListStatus(address _maker) external constant returns (bool) {
352         return isBlackListed[_maker];
353     }
354 
355     mapping (address => bool) public isBlackListed;
356 
357     function addBlackList (address _evilUser) public onlyOwner {
358         isBlackListed[_evilUser] = true;
359         AddedBlackList(_evilUser);
360     }
361 
362     function removeBlackList (address _clearedUser) public onlyOwner {
363         isBlackListed[_clearedUser] = false;
364         RemovedBlackList(_clearedUser);
365     }
366 
367     event AddedBlackList(address indexed _user);
368 
369     event RemovedBlackList(address indexed _user);
370 
371 }
372 
373 contract TetherToken is Pausable, StandardTokenWithFees, BlackList {
374 
375     address public upgradedAddress;
376     bool public deprecated;
377     string public bitcoin_multisig_vault = '3GS8tqpyvCMAGT8hkwDKBdhWcYzL4GcA21';
378 
379     //  The contract can be initialized with a number of tokens
380     //  All the tokens are deposited to the owner address
381     //
382     // @param _balance Initial supply of the contract
383     // @param _name Token Name
384     // @param _symbol Token symbol
385     // @param _decimals Token decimals
386     function TetherToken(uint _initialSupply, string _name, string _symbol, uint8 _decimals) public {
387         _totalSupply = _initialSupply;
388         name = _name;
389         symbol = _symbol;
390         decimals = _decimals;
391         balances[owner] = _initialSupply;
392         deprecated = false;
393     }
394 
395     // Forward ERC20 methods to upgraded contract if this one is deprecated
396     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
397         require(!isBlackListed[msg.sender]);
398         if (deprecated) {
399             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
400         } else {
401             return super.transfer(_to, _value);
402         }
403     }
404 
405     // Forward ERC20 methods to upgraded contract if this one is deprecated
406     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
407         require(!isBlackListed[_from]);
408         if (deprecated) {
409             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
410         } else {
411             return super.transferFrom(_from, _to, _value);
412         }
413     }
414 
415     // Forward ERC20 methods to upgraded contract if this one is deprecated
416     function balanceOf(address who) public constant returns (uint) {
417         if (deprecated) {
418             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
419         } else {
420             return super.balanceOf(who);
421         }
422     }
423 
424     // Allow checks of balance at time of deprecation
425     function oldBalanceOf(address who) public constant returns (uint) {
426         if (deprecated) {
427             return super.balanceOf(who);
428         }
429     }
430 
431     // Forward ERC20 methods to upgraded contract if this one is deprecated
432     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
433         if (deprecated) {
434             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
435         } else {
436             return super.approve(_spender, _value);
437         }
438     }
439 
440     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
441         if (deprecated) {
442             return UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(msg.sender, _spender, _addedValue);
443         } else {
444             return super.increaseApproval(_spender, _addedValue);
445         }
446     }
447 
448     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
449         if (deprecated) {
450             return UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(msg.sender, _spender, _subtractedValue);
451         } else {
452             return super.decreaseApproval(_spender, _subtractedValue);
453         }
454     }
455 
456     // Forward ERC20 methods to upgraded contract if this one is deprecated
457     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
458         if (deprecated) {
459             return StandardToken(upgradedAddress).allowance(_owner, _spender);
460         } else {
461             return super.allowance(_owner, _spender);
462         }
463     }
464 
465     // deprecate current contract in favour of a new one
466     function deprecate(address _upgradedAddress) public onlyOwner {
467         require(_upgradedAddress != address(0));
468         deprecated = true;
469         upgradedAddress = _upgradedAddress;
470         Deprecate(_upgradedAddress);
471     }
472 
473     // deprecate current contract if favour of a new one
474     function totalSupply() public constant returns (uint) {
475         if (deprecated) {
476             return StandardToken(upgradedAddress).totalSupply();
477         } else {
478             return _totalSupply;
479         }
480     }
481 
482     // Issue a new amount of tokens
483     // these tokens are deposited into the owner address
484     //
485     // @param _amount Number of tokens to be issued
486     function issue(uint amount) public onlyOwner {
487         balances[owner] = balances[owner].add(amount);
488         _totalSupply = _totalSupply.add(amount);
489         Issue(amount);
490         Transfer(address(0), owner, amount);
491     }
492 
493     // Redeem tokens.
494     // These tokens are withdrawn from the owner address
495     // if the balance must be enough to cover the redeem
496     // or the call will fail.
497     // @param _amount Number of tokens to be issued
498     function redeem(uint amount) public onlyOwner {
499         _totalSupply = _totalSupply.sub(amount);
500         balances[owner] = balances[owner].sub(amount);
501         Redeem(amount);
502         Transfer(owner, address(0), amount);
503     }
504 
505     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
506         require(isBlackListed[_blackListedUser]);
507         uint dirtyFunds = balanceOf(_blackListedUser);
508         balances[_blackListedUser] = 0;
509         _totalSupply = _totalSupply.sub(dirtyFunds);
510         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
511     }
512 
513     event DestroyedBlackFunds(address indexed _blackListedUser, uint _balance);
514 
515     // Called when new token are issued
516     event Issue(uint amount);
517 
518     // Called when tokens are redeemed
519     event Redeem(uint amount);
520 
521     // Called when contract is deprecated
522     event Deprecate(address newAddress);
523 
524 }