1 pragma solidity 0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
261 
262 /**
263  * @title Ownable
264  * @dev The Ownable contract has an owner address, and provides basic authorization control
265  * functions, this simplifies the implementation of "user permissions".
266  */
267 contract Ownable {
268   address public owner;
269 
270 
271   event OwnershipRenounced(address indexed previousOwner);
272   event OwnershipTransferred(
273     address indexed previousOwner,
274     address indexed newOwner
275   );
276 
277 
278   /**
279    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
280    * account.
281    */
282   constructor() public {
283     owner = msg.sender;
284   }
285 
286   /**
287    * @dev Throws if called by any account other than the owner.
288    */
289   modifier onlyOwner() {
290     require(msg.sender == owner);
291     _;
292   }
293 
294   /**
295    * @dev Allows the current owner to relinquish control of the contract.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() onlyOwner whenNotPaused public {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() onlyOwner whenPaused public {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 // File: contracts/ShopinToken.sol
368 
369 contract ShopinToken is StandardToken, Ownable, Pausable {
370     using SafeMath for uint256;
371 
372     string public constant name = "Shopin Token"; // solium-disable-line uppercase
373     string public constant symbol = "SHOPIN"; // solium-disable-line uppercase
374     uint8 public constant decimals = 18; // solium-disable-line uppercase
375 
376     mapping (address => bool) whitelist;
377     mapping (address => bool) blacklist;
378 
379     uint private unlockTime;
380 
381     event AddedToWhitelist(address indexed _addr);
382     event RemovedFromWhitelist(address indexed _addr);
383     event AddedToBlacklist(address indexed _addr);
384     event RemovedFromBlacklist(address indexed _addr);
385     event SetNewUnlockTime(uint newUnlockTime);
386 
387     constructor(
388         uint256 _totalSupply,
389         uint256 _unlockTime
390     )
391         Ownable()
392         public
393     {
394         require(_totalSupply > 0);
395         require(_unlockTime > 0 && _unlockTime > now);
396 
397         totalSupply_ = _totalSupply;
398         unlockTime = _unlockTime;
399         balances[msg.sender] = totalSupply_;
400         emit Transfer(0x0, msg.sender, totalSupply_);
401     }
402 
403     modifier whenNotPausedOrInWhitelist() {
404         require(
405             !paused || isWhitelisted(msg.sender) || msg.sender == owner,
406             "contract paused and sender is not in whitelist"
407         );
408         _;
409     }
410 
411     /**
412      * @dev Transfer a token to a specified address
413      * transfer
414      *
415      * transfer conditions:
416      *  - the msg.sender address must be valid
417      *  - the msg.sender _cannot_ be on the blacklist
418      *  - one of the three conditions can be met:
419      *      - the token contract is unlocked entirely
420      *      - the msg.sender is whitelisted
421      *      - the msg.sender is the owner of the contract
422      *
423      * @param _to address to transfer to
424      * @param _value amount to transfer
425      */
426     function transfer(
427         address _to,
428         uint _value
429     )
430         public
431         whenNotPausedOrInWhitelist()
432         returns (bool)
433     {
434         require(_to != address(0));
435         require(msg.sender != address(0));
436 
437         require(!isBlacklisted(msg.sender));
438         require(isUnlocked() ||
439                 isWhitelisted(msg.sender) ||
440                 msg.sender == owner);
441 
442         return super.transfer(_to, _value);
443 
444     }
445 
446     /**
447      * @dev addToBlacklist
448      * @param _addr the address to add the blacklist
449      */
450     function addToBlacklist(
451         address _addr
452     ) onlyOwner public returns (bool) {
453         require(_addr != address(0));
454         require(!isBlacklisted(_addr));
455 
456         blacklist[_addr] = true;
457         emit AddedToBlacklist(_addr);
458         return true;
459     }
460 
461     /**
462      * @dev remove from blacklist
463      * @param _addr the address to remove from the blacklist
464      */
465     function removeFromBlacklist(
466         address _addr
467     ) onlyOwner public returns (bool) {
468         require(_addr != address(0));
469         require(isBlacklisted(_addr));
470 
471         blacklist[_addr] = false;
472         emit RemovedFromBlacklist(_addr);
473         return true;
474     }
475 
476     /**
477      * @dev addToWhitelist
478      * @param _addr the address to add to the whitelist
479      */
480     function addToWhitelist(
481         address _addr
482     ) onlyOwner public returns (bool) {
483         require(_addr != address(0));
484         require(!isWhitelisted(_addr));
485 
486         whitelist[_addr] = true;
487         emit AddedToWhitelist(_addr);
488         return true;
489     }
490 
491     /**
492      * @dev remove an address from the whitelist
493      * @param _addr address to remove from whitelist
494      */
495     function removeFromWhitelist(
496         address _addr
497     ) onlyOwner public returns (bool) {
498         require(_addr != address(0));
499         require(isWhitelisted(_addr));
500 
501         whitelist[_addr] = false;
502         emit RemovedFromWhitelist(_addr);
503         return true;
504     }
505 
506     function isBlacklisted(address _addr)
507         internal
508         view
509         returns (bool)
510     {
511         require(_addr != address(0));
512         return blacklist[_addr];
513     }
514 
515     /**
516      * @dev isWhitelisted check if an address is on whitelist
517      * @param _addr address to check if on whitelist
518      */
519     function isWhitelisted(address _addr)
520         internal
521         view
522         returns (bool)
523     {
524         require(_addr != address(0));
525         return whitelist[_addr];
526     }
527 
528     /**
529      * @dev get the unlock time
530      */
531     function getUnlockTime() public view returns (uint) {
532         return unlockTime;
533     }
534 
535     /**
536      * @dev set a new unlock time
537      */
538     function setUnlockTime(uint newUnlockTime) onlyOwner public returns (bool)
539     {
540         unlockTime = newUnlockTime;
541         emit SetNewUnlockTime(unlockTime);
542     }
543 
544     /**
545      * @dev is the contract unlocked or not
546      */
547     function isUnlocked() public view returns (bool) {
548         return (getUnlockTime() >= now);
549     }
550 }