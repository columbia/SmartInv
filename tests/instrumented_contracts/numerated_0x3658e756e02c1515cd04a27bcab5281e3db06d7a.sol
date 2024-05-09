1 pragma solidity ^0.4.21;
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
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: contracts/StableCurrency.sol
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is Ownable, ERC20Basic {
173     using SafeMath for uint;
174 
175     mapping(address => uint) public balances;
176 
177     uint256 _totalSupply;
178  
179     // additional variables for use if transaction fees ever became necessary
180     uint public basisPointsRate = 0;
181     uint public maximumFee = 0;
182 
183     /**
184     * @dev transfer token for a specified address
185     * @param _to The address to transfer to.
186     * @param _value The amount to be transferred.
187     */
188     function transfer(address _to, uint _value) public returns (bool) {
189         require(_to != address(0));
190         require(_value <= balances[msg.sender]);
191 
192         uint fee = (_value.mul(basisPointsRate)).div(10000);
193         if (fee > maximumFee) {
194             fee = maximumFee;
195         }
196         uint sendAmount = _value.sub(fee);
197         balances[msg.sender] = balances[msg.sender].sub(_value);
198         balances[_to] = balances[_to].add(sendAmount);
199         if (fee > 0) {
200             balances[owner] = balances[owner].add(fee);
201             emit Transfer(msg.sender, owner, fee);
202         }
203         emit Transfer(msg.sender, _to, sendAmount);
204         return true;
205     }
206 
207     /**
208     * @dev Gets the balance of the specified address.
209     * @param _owner The address to query the the balance of.
210     * @return An uint representing the amount owned by the passed address.
211     */
212     function balanceOf(address _owner) public constant returns (uint balance) {
213         return balances[_owner];
214     }
215 
216 }
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * @dev https://github.com/ethereum/EIPs/issues/20
223  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is BasicToken, ERC20 {
226 
227     mapping (address => mapping (address => uint)) public allowed;
228 
229     /**
230     * @dev Transfer tokens from one address to another
231     * @param _from address The address which you want to send tokens from
232     * @param _to address The address which you want to transfer to
233     * @param _value uint the amount of tokens to be transferred
234     */
235     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
236         require(_to != address(0));
237         require(_value <= balances[_from]);
238         require(_value <= allowed[_from][msg.sender]);
239 
240         uint _allowance = allowed[_from][msg.sender];
241 
242         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
243         // if (_value > _allowance) throw;
244 
245         uint fee = (_value.mul(basisPointsRate)).div(10000);
246         if (fee > maximumFee) {
247             fee = maximumFee;
248         }
249         allowed[_from][msg.sender] = _allowance.sub(_value);
250         uint sendAmount = _value.sub(fee);
251         balances[_from] = balances[_from].sub(_value);
252         balances[_to] = balances[_to].add(sendAmount);
253         if (fee > 0) {
254             balances[owner] = balances[owner].add(fee);
255             emit Transfer(_from, owner, fee);
256         }
257         emit Transfer(_from, _to, sendAmount);
258     }
259 
260     /**
261      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262      *
263      * Beware that changing an allowance with this method brings the risk that someone may use both the old
264      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      * @param _spender The address which will spend the funds.
268      * @param _value The amount of tokens to be spent.
269      */
270     function approve(address _spender, uint256 _value) public returns (bool) {
271         allowed[msg.sender][_spender] = _value;
272         emit Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     /**
277     * @dev Function to check the amount of tokens that an owner allowed to a spender.
278     * @param _owner address The address which owns the funds.
279     * @param _spender address The address which will spend the funds.
280     * @return A uint256 specifying the amount of tokens still available for the spender.
281     */
282     function allowance(address _owner, address _spender) public view returns (uint256) {
283         return allowed[_owner][_spender];
284     }
285 
286     /**
287     * @dev Increase the amount of tokens that an owner allowed to a spender.
288     *
289     * approve should be called when allowed[_spender] == 0. To increment
290     * allowed value is better to use this function to avoid 2 calls (and wait until
291     * the first transaction is mined)
292     * From MonolithDAO Token.sol
293     * @param _spender The address which will spend the funds.
294     * @param _addedValue The amount of tokens to increase the allowance by.
295     */
296     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
297         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
298         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299         return true;
300     }
301 
302     /**
303     * @dev Decrease the amount of tokens that an owner allowed to a spender.
304     *
305     * approve should be called when allowed[_spender] == 0. To decrement
306     * allowed value is better to use this function to avoid 2 calls (and wait until
307     * the first transaction is mined)
308     * From MonolithDAO Token.sol
309     * @param _spender The address which will spend the funds.
310     * @param _subtractedValue The amount of tokens to decrease the allowance by.
311     */
312     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
313         uint oldValue = allowed[msg.sender][_spender];
314         if (_subtractedValue > oldValue) {
315             allowed[msg.sender][_spender] = 0;
316         } else {
317             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318         }
319         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320         return true;
321     }
322 
323 }
324 
325 contract BlackList is Ownable, BasicToken {
326 
327     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
328     function getBlackListStatus(address _maker) external constant returns (bool) {
329         return isBlackListed[_maker];
330     }
331 
332     function getOwner() external constant returns (address) {
333         return owner;
334     }
335 
336     mapping (address => bool) public isBlackListed;
337     
338     function addBlackList (address _evilUser) public onlyOwner {
339         isBlackListed[_evilUser] = true;
340         emit AddedBlackList(_evilUser);
341     }
342 
343     function removeBlackList (address _clearedUser) public onlyOwner {
344         isBlackListed[_clearedUser] = false;
345         emit RemovedBlackList(_clearedUser);
346     }
347 
348     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
349         require(isBlackListed[_blackListedUser]);
350         uint dirtyFunds = balanceOf(_blackListedUser);
351         balances[_blackListedUser] = 0;
352         _totalSupply -= dirtyFunds;
353         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
354     }
355 
356     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
357 
358     event AddedBlackList(address _user);
359 
360     event RemovedBlackList(address _user);
361 
362 }
363 
364 contract UpgradedStandardToken is StandardToken{
365     // those methods are called by the legacy contract
366     // and they must ensure msg.sender to be the contract address
367     function transferByLegacy(address from, address to, uint value) public returns (bool);
368     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
369     function approveByLegacy(address from, address spender, uint value) public returns (bool);
370 }
371 
372 contract StableCurrencyToken is Pausable, StandardToken, BlackList {
373 
374     string public name;
375     string public symbol;
376     uint public decimals;
377     address public upgradedAddress;
378     bool public deprecated;
379 
380     //  The contract can be initialized with a number of tokens
381     //  All the tokens are deposited to the owner address
382     //
383     // @param _balance Initial supply of the contract
384     // @param _name Token Name
385     // @param _symbol Token symbol
386     // @param _decimals Token decimals
387     function StableCurrencyToken(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
388         _totalSupply = _initialSupply;
389         name = _name;
390         symbol = _symbol;
391         decimals = _decimals;
392         balances[owner] = _initialSupply;
393         deprecated = false;
394     }
395 
396     // Forward ERC20 methods to upgraded contract if this one is deprecated
397     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
398         require(!isBlackListed[msg.sender]);
399         if (deprecated) {
400             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
401         } else {
402             return super.transfer(_to, _value);
403         }
404     }
405 
406     // Forward ERC20 methods to upgraded contract if this one is deprecated
407     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
408         require(!isBlackListed[_from]);
409         if (deprecated) {
410             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
411         } else {
412             return super.transferFrom(_from, _to, _value);
413         }
414     }
415 
416     // Forward ERC20 methods to upgraded contract if this one is deprecated
417     function balanceOf(address who) public constant returns (uint) {
418         if (deprecated) {
419             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
420         } else {
421             return super.balanceOf(who);
422         }
423     }
424 
425     // Forward ERC20 methods to upgraded contract if this one is deprecated
426     function approve(address _spender, uint _value) public returns (bool) {
427         if (deprecated) {
428             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
429         } else {
430             return super.approve(_spender, _value);
431         }
432     }
433 
434     // Forward ERC20 methods to upgraded contract if this one is deprecated
435     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
436         if (deprecated) {
437             return StandardToken(upgradedAddress).allowance(_owner, _spender);
438         } else {
439             return super.allowance(_owner, _spender);
440         }
441     }
442 
443     // deprecate current contract in favour of a new one
444     function deprecate(address _upgradedAddress) public onlyOwner {
445         deprecated = true;
446         upgradedAddress = _upgradedAddress;
447         emit Deprecate(_upgradedAddress);
448     }
449 
450     // deprecate current contract if favour of a new one
451     function totalSupply() public constant returns (uint) {
452         if (deprecated) {
453             return StandardToken(upgradedAddress).totalSupply();
454         } else {
455             return _totalSupply;
456         }
457     }
458 
459     // Issue a new amount of tokens
460     // these tokens are deposited into the owner address
461     //
462     // @param _amount Number of tokens to be issued
463     function issue(uint amount) public onlyOwner {
464         require(_totalSupply + amount > _totalSupply);
465         require(balances[owner] + amount > balances[owner]);
466 
467         balances[owner] += amount;
468         _totalSupply += amount;
469         emit Issue(amount);
470     }
471 
472     // Redeem tokens.
473     // These tokens are withdrawn from the owner address
474     // if the balance must be enough to cover the redeem
475     // or the call will fail.
476     // @param _amount Number of tokens to be issued
477     function redeem(uint amount) public onlyOwner {
478         require(_totalSupply >= amount);
479         require(balances[owner] >= amount);
480 
481         _totalSupply -= amount;
482         balances[owner] -= amount;
483         emit Redeem(amount);
484     }
485 
486     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
487         // Ensure transparency by hardcoding limit beyond which fees can never be added
488         require(newBasisPoints < 20);
489         require(newMaxFee < 50);
490 
491         basisPointsRate = newBasisPoints;
492         maximumFee = newMaxFee.mul(10**decimals);
493 
494         emit Params(basisPointsRate, maximumFee);
495     }
496 
497     // Called when new token are issued
498     event Issue(uint amount);
499 
500     // Called when tokens are redeemed
501     event Redeem(uint amount);
502 
503     // Called when contract is deprecated
504     event Deprecate(address newAddress);
505 
506     // Called if contract ever adds fees
507     event Params(uint feeBasisPoints, uint maxFee);
508 }