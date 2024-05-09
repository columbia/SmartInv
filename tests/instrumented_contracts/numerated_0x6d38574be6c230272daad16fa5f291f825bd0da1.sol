1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(
62     address indexed previousOwner,
63     address indexed newOwner
64   );
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to relinquish control of the contract.
85    */
86   function renounceOwnership() public onlyOwner {
87     emit OwnershipRenounced(owner);
88     owner = address(0);
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address _newOwner) public onlyOwner {
96     _transferOwnership(_newOwner);
97   }
98 
99   /**
100    * @dev Transfers control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function _transferOwnership(address _newOwner) internal {
104     require(_newOwner != address(0));
105     emit OwnershipTransferred(owner, _newOwner);
106     owner = _newOwner;
107   }
108 }
109 
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 totalSupply_;
116 
117   /**
118   * @dev total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256) {
145     return balances[_owner];
146   }
147 
148 }
149 
150 contract Lockable is Ownable {
151     event Lock();
152     event Unlock();
153 
154     bool public locked = true;
155 
156     constructor() public {
157     }
158 
159     /**
160      * @notice Unlock the contract
161      */
162     function unlock() external onlyOwner {
163         require(locked);
164         locked = false;
165         emit Unlock();
166     }
167 
168     /**
169      * @dev Check if the address is unlocked.
170      */
171     function isUnlocked() public view returns (bool) {
172         return !locked;
173     }
174 }
175 
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender)
178     public view returns (uint256);
179 
180   function transferFrom(address from, address to, uint256 value)
181     public returns (bool);
182 
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(
185     address indexed owner,
186     address indexed spender,
187     uint256 value
188   );
189 }
190 
191 contract Pausable is Ownable {
192   event Pause();
193   event Unpause();
194 
195   bool public paused = false;
196 
197 
198   /**
199    * @dev Modifier to make a function callable only when the contract is not paused.
200    */
201   modifier whenNotPaused() {
202     require(!paused);
203     _;
204   }
205 
206   /**
207    * @dev Modifier to make a function callable only when the contract is paused.
208    */
209   modifier whenPaused() {
210     require(paused);
211     _;
212   }
213 
214   /**
215    * @dev called by the owner to pause, triggers stopped state
216    */
217   function pause() onlyOwner whenNotPaused public {
218     paused = true;
219     emit Pause();
220   }
221 
222   /**
223    * @dev called by the owner to unpause, returns to normal state
224    */
225   function unpause() onlyOwner whenPaused public {
226     paused = false;
227     emit Unpause();
228   }
229 }
230 
231 contract Whitelist is Ownable {
232     event AddedToWhitelist(address indexed user);
233     event RemovedFromWhitelist(address indexed user);
234 
235     mapping (address => bool) public whitelist;
236 
237     modifier whenWhitelisted(address _user) {
238         require(whitelist[_user]);
239         _;
240     }
241 
242     modifier whenNotWhitelisted(address _user) {
243         require(whitelist[_user] != true);
244         _;
245     }
246 
247     /**
248      * @dev Add the Given address to the whitelist
249      * @param _user The address to be added
250      */
251     function addToWhitelist(address _user) public onlyOwner whenNotWhitelisted(_user) {
252         require(_user != address(0));
253         whitelist[_user] = true;
254         emit AddedToWhitelist(_user);
255     }
256 
257     /**
258      * @dev Add the Given addresses to the whitelist
259      * @param _users The addresses to be added
260      */
261     function addManyToWhitelist(address[] _users) public onlyOwner {
262         for (uint256 i = 0; i < _users.length; i++) {
263             addToWhitelist(_users[i]);
264         }
265     }
266 
267     /**
268      * @dev Assign the given address as not whitelisted
269      * @param _user The address to be assigned
270      */
271     function removeFromWhitelist(address _user) public onlyOwner whenWhitelisted(_user) {
272         whitelist[_user] = false;
273         emit RemovedFromWhitelist(_user);
274     }
275 }
276 
277 contract StandardToken is ERC20, BasicToken {
278 
279   mapping (address => mapping (address => uint256)) internal allowed;
280 
281 
282   /**
283    * @dev Transfer tokens from one address to another
284    * @param _from address The address which you want to send tokens from
285    * @param _to address The address which you want to transfer to
286    * @param _value uint256 the amount of tokens to be transferred
287    */
288   function transferFrom(
289     address _from,
290     address _to,
291     uint256 _value
292   )
293     public
294     returns (bool)
295   {
296     require(_to != address(0));
297     require(_value <= balances[_from]);
298     require(_value <= allowed[_from][msg.sender]);
299 
300     balances[_from] = balances[_from].sub(_value);
301     balances[_to] = balances[_to].add(_value);
302     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
303     emit Transfer(_from, _to, _value);
304     return true;
305   }
306 
307   /**
308    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
309    *
310    * Beware that changing an allowance with this method brings the risk that someone may use both the old
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
313    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint256 _value) public returns (bool) {
318     allowed[msg.sender][_spender] = _value;
319     emit Approval(msg.sender, _spender, _value);
320     return true;
321   }
322 
323   /**
324    * @dev Function to check the amount of tokens that an owner allowed to a spender.
325    * @param _owner address The address which owns the funds.
326    * @param _spender address The address which will spend the funds.
327    * @return A uint256 specifying the amount of tokens still available for the spender.
328    */
329   function allowance(
330     address _owner,
331     address _spender
332    )
333     public
334     view
335     returns (uint256)
336   {
337     return allowed[_owner][_spender];
338   }
339 
340   /**
341    * @dev Increase the amount of tokens that an owner allowed to a spender.
342    *
343    * approve should be called when allowed[_spender] == 0. To increment
344    * allowed value is better to use this function to avoid 2 calls (and wait until
345    * the first transaction is mined)
346    * From MonolithDAO Token.sol
347    * @param _spender The address which will spend the funds.
348    * @param _addedValue The amount of tokens to increase the allowance by.
349    */
350   function increaseApproval(
351     address _spender,
352     uint _addedValue
353   )
354     public
355     returns (bool)
356   {
357     allowed[msg.sender][_spender] = (
358       allowed[msg.sender][_spender].add(_addedValue));
359     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363   /**
364    * @dev Decrease the amount of tokens that an owner allowed to a spender.
365    *
366    * approve should be called when allowed[_spender] == 0. To decrement
367    * allowed value is better to use this function to avoid 2 calls (and wait until
368    * the first transaction is mined)
369    * From MonolithDAO Token.sol
370    * @param _spender The address which will spend the funds.
371    * @param _subtractedValue The amount of tokens to decrease the allowance by.
372    */
373   function decreaseApproval(
374     address _spender,
375     uint _subtractedValue
376   )
377     public
378     returns (bool)
379   {
380     uint oldValue = allowed[msg.sender][_spender];
381     if (_subtractedValue > oldValue) {
382       allowed[msg.sender][_spender] = 0;
383     } else {
384       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
385     }
386     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
387     return true;
388   }
389 
390 }
391 
392 contract LockableToken is StandardToken, Lockable, Whitelist {
393 
394     constructor(address _address) public {
395         require(_address != address(0));
396         addToWhitelist(_address);
397     }
398 
399     /**
400      * @dev Check if the sender is unlocked if the address is not whitelisted
401      */
402     modifier whenTransferrable() {
403         if (whitelist[msg.sender] != true)
404             require(isUnlocked());
405         _;
406     }
407 
408     function transfer(address _to, uint256 _value) public whenTransferrable returns (bool) {
409         return super.transfer(_to, _value);
410     }
411 
412     function transferFrom(address _from, address _to, uint256 _value) public whenTransferrable returns (bool) {
413         return super.transferFrom(_from, _to, _value);
414     }
415 
416     function approve(address _spender, uint256 _value) public whenTransferrable returns (bool) {
417         return super.approve(_spender, _value);
418     }
419 
420     function increaseApproval(address _spender, uint _addedValue) public whenTransferrable returns (bool) {
421         return super.increaseApproval(_spender, _addedValue);
422     }
423 
424     function decreaseApproval(address _spender, uint _subtractedValue) public whenTransferrable returns (bool) {
425         return super.decreaseApproval(_spender, _subtractedValue);
426     }
427 }
428 
429 contract PausableToken is StandardToken, Pausable {
430 
431   function transfer(
432     address _to,
433     uint256 _value
434   )
435     public
436     whenNotPaused
437     returns (bool)
438   {
439     return super.transfer(_to, _value);
440   }
441 
442   function transferFrom(
443     address _from,
444     address _to,
445     uint256 _value
446   )
447     public
448     whenNotPaused
449     returns (bool)
450   {
451     return super.transferFrom(_from, _to, _value);
452   }
453 
454   function approve(
455     address _spender,
456     uint256 _value
457   )
458     public
459     whenNotPaused
460     returns (bool)
461   {
462     return super.approve(_spender, _value);
463   }
464 
465   function increaseApproval(
466     address _spender,
467     uint _addedValue
468   )
469     public
470     whenNotPaused
471     returns (bool success)
472   {
473     return super.increaseApproval(_spender, _addedValue);
474   }
475 
476   function decreaseApproval(
477     address _spender,
478     uint _subtractedValue
479   )
480     public
481     whenNotPaused
482     returns (bool success)
483   {
484     return super.decreaseApproval(_spender, _subtractedValue);
485   }
486 }
487 
488 contract DinngoToken is LockableToken, PausableToken {
489     string constant public name = "Dinngo";
490     string constant public symbol = "DGO";
491     uint8 constant public decimals = 18;
492     string constant public version = "1.0";
493 
494     constructor(address customWallet) public
495         LockableToken(customWallet)
496     {
497         require(customWallet != address(0));
498         totalSupply_ = 2 * 10 ** (8 + uint256(decimals));
499         balances[customWallet] = totalSupply_;
500         emit Transfer(address(0), customWallet, totalSupply_);
501     }
502 
503     function () public payable {
504         revert();
505     }
506 }