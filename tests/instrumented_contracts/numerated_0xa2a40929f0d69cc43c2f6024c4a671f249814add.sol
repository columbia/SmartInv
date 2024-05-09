1 pragma solidity 0.5.1;
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
49 contract ReentrancyGuard {
50 
51   /**
52    * @dev We use a single lock for the whole contract.
53    */
54   bool private reentrancyLock = false;
55 
56   /**
57    * @dev Prevents a contract from calling itself, directly or indirectly.
58    * @notice If you mark a function `nonReentrant`, you should also
59    * mark it `external`. Calling one nonReentrant function from
60    * another is not supported. Instead, you can implement a
61    * `private` function doing the actual work, and a `external`
62    * wrapper marked as `nonReentrant`.
63    */
64   modifier nonReentrant() {
65     require(!reentrancyLock);
66     reentrancyLock = true;
67     _;
68     reentrancyLock = false;
69   }
70 }
71 
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipRenounced(address indexed previousOwner);
83   event OwnershipTransferred(
84     address indexed previousOwner,
85     address indexed newOwner
86   );
87 
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   constructor() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     emit OwnershipTransferred(owner, newOwner);
112     owner = newOwner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipRenounced(owner);
120     owner = address(0);
121   }
122 }
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   function totalSupply() public view returns (uint256);
131   function balanceOf(address who) public view returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender)
142     public view returns (uint256);
143 
144   function transferFrom(address from, address to, uint256 value)
145     public returns (bool);
146 
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(
149     address indexed owner,
150     address indexed spender,
151     uint256 value
152   );
153 }
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic, ReentrancyGuard {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) public balances;
163 
164   uint256 public totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public nonReentrant returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     nonReentrant
224     returns (bool)
225   {
226     require(_to != address(0));
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232 
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    *
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public nonReentrant returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(
262     address _owner,
263     address _spender
264    )
265     public
266     view
267     returns (uint256)
268   {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(
283     address _spender,
284     uint256 _addedValue
285   )
286     public
287     nonReentrant
288     returns (bool)
289   {
290     allowed[msg.sender][_spender] = (
291       allowed[msg.sender][_spender].add(_addedValue));
292     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296   /**
297    * @dev Decrease the amount of tokens that an owner allowed to a spender.
298    *
299    * approve should be called when allowed[_spender] == 0. To decrement
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _subtractedValue The amount of tokens to decrease the allowance by.
305    */
306   function decreaseApproval(
307     address _spender,
308     uint256 _subtractedValue
309   )
310     public
311     nonReentrant
312     returns (bool)
313   {
314     uint256 oldValue = allowed[msg.sender][_spender];
315     if (_subtractedValue > oldValue) {
316       allowed[msg.sender][_spender] = 0;
317     } else {
318       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319     }
320     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321     return true;
322   }
323 
324 }
325 
326 contract Freeze is Ownable, ReentrancyGuard {
327   
328   using SafeMath for uint256;
329 
330   struct Group {
331     address[] holders;
332     uint until;
333   }
334   
335 	/**
336 	 * @dev number of groups
337 	 */
338   uint public groups;
339   
340 	/**
341 	 * @dev link group ID ---> Group structure
342 	 */
343   mapping (uint => Group) public lockup;
344   
345 	/**
346 	 * @dev Check if holder under lock up
347 	 */
348   modifier lockupEnded (address _holder) {
349     bool freezed;
350     uint groupId;
351     (freezed, groupId) = isFreezed(_holder);
352     
353     if (freezed) {
354       if (lockup[groupId-1].until < block.timestamp)
355         _;
356       else 
357         revert("Your holdings are freezed, wait until transfers become allowed");
358     }
359     else 
360       _;
361   }
362   
363 	/**
364 	 * @param _holder address of token holder to check
365 	 * @return bool - status of freezing and group
366 	 */
367   function isFreezed (address _holder) public view returns(bool, uint) {
368     bool freezed = false;
369     uint i = 0;
370     while (i < groups) {
371       uint index  = indexOf(_holder, lockup[i].holders);
372 
373       if (index == 0) {
374         if (checkZeroIndex(_holder, i)) {
375           freezed = true;
376           i++;
377           continue;
378         }  
379         else {
380           i++;
381           continue;
382         }
383       }
384       
385       if (index != 0) {
386         freezed = true;
387         i++;
388         continue;
389       }
390       i++;
391     }
392     if (!freezed) i = 0;
393     
394     return (freezed, i);
395   }
396   
397 	/**
398 	 * @dev internal usage to get index of holder in group
399 	 * @param element address of token holder to check
400 	 * @param at array of addresses that is group of holders
401 	 * @return index of holder at array
402 	 */
403   function indexOf (address element, address[] memory at) internal pure returns (uint) {
404     for (uint i=0; i < at.length; i++) {
405       if (at[i] == element) return i;
406     }
407     return 0;
408   }
409   
410 	/**
411 	 * @dev internal usage to check that 0 is 0 index or it means that address not exists
412 	 * @param _holder address of token holder to check
413 	 * @param lockGroup id of group to check address existance in it
414 	 * @return true if holder at zero index at group false if holder doesn't exists
415 	 */
416   function checkZeroIndex (address _holder, uint lockGroup) internal view returns (bool) {
417     if (lockup[lockGroup].holders[0] == _holder)
418       return true;
419         
420     else 
421       return false;
422   }
423   
424 	/**
425 	 * @dev Will set group of addresses that will be under lock. When locked address can't
426 	  		  do some actions with token
427 	 * @param _holders array of addresses to lock
428 	 * @param _until   timestamp until that lock up will last
429 	 * @return bool result of operation
430 	 */
431   function setGroup (address[] memory _holders, uint _until) public onlyOwner returns (bool) {
432     lockup[groups].holders = _holders;
433     lockup[groups].until   = _until;
434     
435     groups++;
436     return true;
437   }
438 }
439 
440 /**
441  * @dev This contract needed for inheritance of StandardToken interface,
442         but with freezing modifiers. So, it have exactly same methods, but with 
443         lockupEnded(msg.sender) modifier.
444  * @notice Inherit from it at SingleToken, to make freezing functionality works
445 */
446 contract PausableToken is StandardToken, Freeze {
447 
448   function transfer(
449     address _to,
450     uint256 _value
451   )
452     public
453     lockupEnded(msg.sender)
454     returns (bool)
455   {
456     return super.transfer(_to, _value);
457   }
458 
459   function transferFrom(
460     address _from,
461     address _to,
462     uint256 _value
463   )
464     public
465     lockupEnded(msg.sender)
466     returns (bool)
467   {
468     return super.transferFrom(_from, _to, _value);
469   }
470 
471   function approve(
472     address _spender,
473     uint256 _value
474   )
475     public
476     lockupEnded(msg.sender)
477     returns (bool)
478   {
479     return super.approve(_spender, _value);
480   }
481 
482   function increaseApproval(
483     address _spender,
484     uint256 _addedValue
485   )
486     public
487     lockupEnded(msg.sender)
488     returns (bool success)
489   {
490     return super.increaseApproval(_spender, _addedValue);
491   }
492 
493   function decreaseApproval(
494     address _spender,
495     uint256 _subtractedValue
496   )
497     public
498     lockupEnded(msg.sender)
499     returns (bool success)
500   {
501     return super.decreaseApproval(_spender, _subtractedValue);
502   }
503 }
504 
505 
506 contract SingleToken is PausableToken {
507 
508   string  public constant name      = "Gofind XR"; 
509 
510   string  public constant symbol    = "XR";
511 
512   uint32  public constant decimals  = 8;
513 
514   uint256 public constant maxSupply = 13E16;
515   
516   constructor() public {
517     totalSupply_ = totalSupply_.add(maxSupply);
518     balances[msg.sender] = balances[msg.sender].add(maxSupply);
519   }
520 }