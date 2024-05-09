1 pragma solidity 0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     if (a == 0) {
65       return 0;
66     }
67     c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     // uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return a / b;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 interface IERC20 {
105     function transfer(address to, uint256 value) external returns (bool);
106 
107     function approve(address spender, uint256 value) external returns (bool);
108 
109     function transferFrom(address from, address to, uint256 value) external returns (bool);
110 
111     function totalSupply() external view returns (uint256);
112 
113     function balanceOf(address who) external view returns (uint256);
114 
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 library SafeERC20 {
124     using SafeMath for uint256;
125 
126     function safeTransfer(IERC20 token, address to, uint256 value) internal {
127         require(token.transfer(to, value));
128     }
129 
130     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
131         require(token.transferFrom(from, to, value));
132     }
133 
134     function safeApprove(IERC20 token, address spender, uint256 value) internal {
135         // safeApprove should only be called when setting an initial allowance,
136         // or when resetting it to zero. To increase and decrease it, use
137         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
138         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
139         require(token.approve(spender, value));
140     }
141 
142     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
143         uint256 newAllowance = token.allowance(address(this), spender).add(value);
144         require(token.approve(spender, newAllowance));
145     }
146 
147     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
148         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
149         require(token.approve(spender, newAllowance));
150     }
151 }
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
158  * Originally based on code by FirstBlood:
159  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  *
161  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
162  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
163  * compliant implementations may not do it.
164  */
165 contract ERC20 is IERC20 {
166     using SafeMath for uint256;
167 
168     mapping (address => uint256) private _balances;
169 
170     mapping (address => mapping (address => uint256)) private _allowed;
171 
172     uint256 private _totalSupply;
173 
174     /**
175     * @dev Total number of tokens in existence
176     */
177     function totalSupply() public view returns (uint256) {
178         return _totalSupply;
179     }
180 
181     /**
182     * @dev Gets the balance of the specified address.
183     * @param owner The address to query the balance of.
184     * @return An uint256 representing the amount owned by the passed address.
185     */
186     function balanceOf(address owner) public view returns (uint256) {
187         return _balances[owner];
188     }
189 
190     /**
191      * @dev Function to check the amount of tokens that an owner allowed to a spender.
192      * @param owner address The address which owns the funds.
193      * @param spender address The address which will spend the funds.
194      * @return A uint256 specifying the amount of tokens still available for the spender.
195      */
196     function allowance(address owner, address spender) public view returns (uint256) {
197         return _allowed[owner][spender];
198     }
199 
200     /**
201     * @dev Transfer token for a specified address
202     * @param to The address to transfer to.
203     * @param value The amount to be transferred.
204     */
205     function transfer(address to, uint256 value) public returns (bool) {
206         _transfer(msg.sender, to, value);
207         return true;
208     }
209 
210     /**
211      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212      * Beware that changing an allowance with this method brings the risk that someone may use both the old
213      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216      * @param spender The address which will spend the funds.
217      * @param value The amount of tokens to be spent.
218      */
219     function approve(address spender, uint256 value) public returns (bool) {
220         require(spender != address(0));
221 
222         _allowed[msg.sender][spender] = value;
223         emit Approval(msg.sender, spender, value);
224         return true;
225     }
226 
227     /**
228      * @dev Transfer tokens from one address to another.
229      * Note that while this function emits an Approval event, this is not required as per the specification,
230      * and other compliant implementations may not emit the event.
231      * @param from address The address which you want to send tokens from
232      * @param to address The address which you want to transfer to
233      * @param value uint256 the amount of tokens to be transferred
234      */
235     function transferFrom(address from, address to, uint256 value) public returns (bool) {
236         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
237         _transfer(from, to, value);
238         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
239         return true;
240     }
241 
242     /**
243      * @dev Increase the amount of tokens that an owner allowed to a spender.
244      * approve should be called when allowed_[_spender] == 0. To increment
245      * allowed value is better to use this function to avoid 2 calls (and wait until
246      * the first transaction is mined)
247      * From MonolithDAO Token.sol
248      * Emits an Approval event.
249      * @param spender The address which will spend the funds.
250      * @param addedValue The amount of tokens to increase the allowance by.
251      */
252     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
253         require(spender != address(0));
254 
255         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
256         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
257         return true;
258     }
259 
260     /**
261      * @dev Decrease the amount of tokens that an owner allowed to a spender.
262      * approve should be called when allowed_[_spender] == 0. To decrement
263      * allowed value is better to use this function to avoid 2 calls (and wait until
264      * the first transaction is mined)
265      * From MonolithDAO Token.sol
266      * Emits an Approval event.
267      * @param spender The address which will spend the funds.
268      * @param subtractedValue The amount of tokens to decrease the allowance by.
269      */
270     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
271         require(spender != address(0));
272 
273         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
274         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
275         return true;
276     }
277 
278     /**
279     * @dev Transfer token for a specified addresses
280     * @param from The address to transfer from.
281     * @param to The address to transfer to.
282     * @param value The amount to be transferred.
283     */
284     function _transfer(address from, address to, uint256 value) internal {
285         require(to != address(0));
286 
287         _balances[from] = _balances[from].sub(value);
288         _balances[to] = _balances[to].add(value);
289         emit Transfer(from, to, value);
290     }
291 
292     /**
293      * @dev Internal function that mints an amount of the token and assigns it to
294      * an account. This encapsulates the modification of balances such that the
295      * proper events are emitted.
296      * @param account The account that will receive the created tokens.
297      * @param value The amount that will be created.
298      */
299     function _mint(address account, uint256 value) internal {
300         require(account != address(0));
301 
302         _totalSupply = _totalSupply.add(value);
303         _balances[account] = _balances[account].add(value);
304         emit Transfer(address(0), account, value);
305     }
306 
307     /**
308      * @dev Internal function that burns an amount of the token of a given
309      * account.
310      * @param account The account whose tokens will be burnt.
311      * @param value The amount that will be burnt.
312      */
313     function _burn(address account, uint256 value) internal {
314         require(account != address(0));
315 
316         _totalSupply = _totalSupply.sub(value);
317         _balances[account] = _balances[account].sub(value);
318         emit Transfer(account, address(0), value);
319     }
320 
321     /**
322      * @dev Internal function that burns an amount of the token of a given
323      * account, deducting from the sender's allowance for said account. Uses the
324      * internal burn function.
325      * Emits an Approval event (reflecting the reduced allowance).
326      * @param account The account whose tokens will be burnt.
327      * @param value The amount that will be burnt.
328      */
329     function _burnFrom(address account, uint256 value) internal {
330         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
331         _burn(account, value);
332         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
333     }
334 }
335 
336 contract Freeze is Ownable, ERC20 {
337   
338     using SafeMath for uint256;
339 
340     uint256 public endOfIco;
341     uint256 public unlockSchema = 12;
342 
343     struct Group {
344         address[] holders;
345         uint until;
346     }
347     
348     /**
349     * @dev number of groups
350     */
351     uint public groups;
352     
353     address[] public gofindAllowedAddresses; // ADD 0xO ADDRESS AT FIRST PLACE
354     
355     /**
356     * @dev link group ID ---> Group structure
357     */
358     mapping (uint => Group) public lockup;
359     
360     /**
361     * @dev Check if holder under lock up
362     */
363     modifier lockupEnded (address _holder, address _recipient, uint256 actionAmount) {
364         uint index = indexOf(_recipient, gofindAllowedAddresses);
365         if (index == 0) {
366             bool freezed;
367             uint groupId;
368             (freezed, groupId) = isFreezed(_holder);
369             
370             if (freezed) {
371                 if (lockup[groupId-1].until < block.timestamp)
372                     _;
373                     
374                 else if (getFullMonthAfterIco() != 0) {
375                     uint256 available = getAvailableAmount();
376                     if (actionAmount > available)
377                         revert("Your holdings are freezed and your trying to use amount more than available");
378                     else 
379                         _;
380                 }
381                 else 
382                     revert("Your holdings are freezed, wait until transfers become allowed");
383             }
384             else 
385                 _;
386         }
387         else
388         _;
389     }
390     
391     /**
392      * @dev in timestamp
393     */
394     function changeEndOfIco (uint256 _date) public onlyOwner returns (bool) {
395         endOfIco = _date;
396     }
397     
398     function addGofindAllowedAddress (address _newAddress) public onlyOwner returns (bool) {
399         require(indexOf(_newAddress, gofindAllowedAddresses) == 0, "that address already exists");
400         gofindAllowedAddresses.push(_newAddress);
401         return true;
402     }
403 	
404 	/**
405 	 * @param _holder address of token holder to check
406 	 * @return bool - status of freezing and group
407 	 */
408     function isFreezed (address _holder) public view returns(bool, uint) {
409         bool freezed = false;
410         uint i = 0;
411         while (i < groups) {
412             uint index  = indexOf(_holder, lockup[i].holders);
413 
414             if (index == 0) {
415                 if (checkZeroIndex(_holder, i)) {
416                     freezed = true;
417                     i++;
418                     continue;
419                 }  
420                 else {
421                     i++;
422                     continue;
423                 }
424             } 
425         
426             if (index != 0) {
427                 freezed = true;
428                 i++;
429                 continue;
430             }
431             i++;
432         }
433         if (!freezed) i = 0;
434         
435         return (freezed, i);
436     }
437   
438 	/**
439 	 * @dev internal usage to get index of holder in group
440 	 * @param element address of token holder to check
441 	 * @param at array of addresses that is group of holders
442 	 * @return index of holder at array
443 	 */
444     function indexOf (address element, address[] memory at) internal pure returns (uint) {
445         for (uint i=0; i < at.length; i++) {
446             if (at[i] == element) return i;
447         }
448         return 0;
449     }
450   
451 	/**
452 	 * @dev internal usage to check that 0 is 0 index or it means that address not exists
453 	 * @param _holder address of token holder to check
454 	 * @param lockGroup id of group to check address existance in it
455 	 * @return true if holder at zero index at group false if holder doesn't exists
456 	 */
457     function checkZeroIndex (address _holder, uint lockGroup) internal view returns (bool) {
458         if (lockup[lockGroup].holders[0] == _holder)
459             return true;
460             
461         else 
462             return false;
463     }
464 
465     /**
466      * @dev returns available tokens amount after linear release for msg.sender
467      */
468     function getAvailableAmount () internal view returns (uint256) {
469         uint256 monthes = getFullMonthAfterIco();
470         uint256 balance = balanceOf(msg.sender);
471         uint256 monthShare = balance.div(unlockSchema);
472         uint256 available = monthShare * monthes;
473         return available;
474     }
475     
476     /**
477      * @dev calculate how much month have gone after end of ICO
478      */
479     function getFullMonthAfterIco () internal view returns (uint256) {
480         uint256 currentTime = block.timestamp;
481         if (currentTime < endOfIco)
482             return 0;
483         else {
484             uint256 delta = currentTime - endOfIco;
485             uint256 step = 2592000;
486             if (delta > step) {
487                 uint256 times = delta.div(step);
488                 return times;
489             }
490             else {
491                 return 0;
492             }
493         }
494     }
495   
496 	/**
497 	 * @dev Will set group of addresses that will be under lock. When locked address can't
498 	  		  do some actions with token
499 	 * @param _holders array of addresses to lock
500 	 * @param _until   timestamp until that lock up will last
501 	 * @return bool result of operation
502 	 */
503     function setGroup (address[] memory _holders, uint _until) public onlyOwner returns (bool) {
504         lockup[groups].holders = _holders;
505         lockup[groups].until   = _until;
506         
507         groups++;
508         return true;
509     }
510 }
511 
512 /**
513  * @dev This contract needed for inheritance of StandardToken interface,
514         but with freezing modifiers. So, it have exactly same methods, but with 
515         lockupEnded(msg.sender) modifier.
516  * @notice Inherit from it at ERC20, to make freezing functionality works
517 */
518 contract PausableToken is Freeze {
519 
520     function transfer(address _to, uint256 _value) public lockupEnded(msg.sender, _to, _value) returns (bool) {
521         return super.transfer(_to, _value);
522     }
523 
524     function transferFrom(address _from, address _to, uint256 _value) public lockupEnded(msg.sender, _to, _value) returns (bool) {
525         return super.transferFrom(_from, _to, _value);
526     }
527 
528     function approve(address _spender, uint256 _value) public lockupEnded(msg.sender, _spender, _value) returns (bool) {
529         return super.approve(_spender, _value);
530     }
531 
532     function increaseAllowance(address _spender, uint256 _addedValue)
533         public lockupEnded(msg.sender, _spender, _addedValue) returns (bool success)
534     {
535         return super.increaseAllowance(_spender, _addedValue);
536     }
537 
538     function decreaseAllowance(address _spender, uint256 _subtractedValue)
539         public lockupEnded(msg.sender, _spender, _subtractedValue) returns (bool success)
540     {
541         return super.decreaseAllowance(_spender, _subtractedValue);
542     }
543 }
544 
545 
546 contract SingleToken is PausableToken {
547 
548     using SafeMath for uint256;
549     
550     event TokensBurned(address from, uint256 value);
551     event TokensMinted(address to, uint256 value);
552 
553     string  public constant name      = "Gofind XR"; 
554 
555     string  public constant symbol    = "XR";
556 
557     uint32  public constant decimals  = 8;
558 
559     uint256 public constant maxSupply = 13E16;
560     
561     constructor() public {
562         totalSupply().add(maxSupply);
563         super._mint(msg.sender, maxSupply);
564     }
565     
566     function burn (address account, uint256 value) public onlyOwner returns (bool) {
567         super._burn(account, value);
568         return true;
569     }
570     
571     function burnFrom (address account, uint256 value) public onlyOwner returns (bool) {
572         super._burnFrom(account, value);
573         return true;
574     }
575     
576     function mint (address account, uint256 value) public onlyOwner returns (bool) {
577         super._mint(account, value);
578         return true;
579     }
580   
581 }