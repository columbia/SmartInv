1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 
91 
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://eips.ethereum.org/EIPS/eip-20
99  * Originally based on code by FirstBlood:
100  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     mapping (address => uint256) private _balances;
110 
111     mapping (address => mapping (address => uint256)) private _allowed;
112 
113     uint256 private _totalSupply;
114 
115     /**
116      * @dev Total number of tokens in existence
117      */
118     function totalSupply() public view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123      * @dev Gets the balance of the specified address.
124      * @param owner The address to query the balance of.
125      * @return A uint256 representing the amount owned by the passed address.
126      */
127     function balanceOf(address owner) public view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Function to check the amount of tokens that an owner allowed to a spender.
133      * @param owner address The address which owns the funds.
134      * @param spender address The address which will spend the funds.
135      * @return A uint256 specifying the amount of tokens still available for the spender.
136      */
137     function allowance(address owner, address spender) public view returns (uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     /**
142      * @dev Transfer token to a specified address
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         _approve(msg.sender, spender, value);
162         return true;
163     }
164 
165     /**
166      * @dev Transfer tokens from one address to another.
167      * Note that while this function emits an Approval event, this is not required as per the specification,
168      * and other compliant implementations may not emit the event.
169      * @param from address The address which you want to send tokens from
170      * @param to address The address which you want to transfer to
171      * @param value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address from, address to, uint256 value) public returns (bool) {
174         _transfer(from, to, value);
175         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
191         return true;
192     }
193 
194     /**
195      * @dev Decrease the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param subtractedValue The amount of tokens to decrease the allowance by.
203      */
204     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
206         return true;
207     }
208 
209     /**
210      * @dev Transfer token for a specified addresses
211      * @param from The address to transfer from.
212      * @param to The address to transfer to.
213      * @param value The amount to be transferred.
214      */
215     function _transfer(address from, address to, uint256 value) internal {
216         require(to != address(0));
217 
218         _balances[from] = _balances[from].sub(value);
219         _balances[to] = _balances[to].add(value);
220         emit Transfer(from, to, value);
221     }
222 
223     /**
224      * @dev Internal function that mints an amount of the token and assigns it to
225      * an account. This encapsulates the modification of balances such that the
226      * proper events are emitted.
227      * @param account The account that will receive the created tokens.
228      * @param value The amount that will be created.
229      */
230     function _mint(address account, uint256 value) internal {
231         require(account != address(0));
232 
233         _totalSupply = _totalSupply.add(value);
234         _balances[account] = _balances[account].add(value);
235         emit Transfer(address(0), account, value);
236     }
237 
238     /**
239      * @dev Internal function that burns an amount of the token of a given
240      * account.
241      * @param account The account whose tokens will be burnt.
242      * @param value The amount that will be burnt.
243      */
244     function _burn(address account, uint256 value) internal {
245         require(account != address(0));
246 
247         _totalSupply = _totalSupply.sub(value);
248         _balances[account] = _balances[account].sub(value);
249         emit Transfer(account, address(0), value);
250     }
251 
252     /**
253      * @dev Approve an address to spend another addresses' tokens.
254      * @param owner The address that owns the tokens.
255      * @param spender The address that will spend the tokens.
256      * @param value The number of tokens that can be spent.
257      */
258     function _approve(address owner, address spender, uint256 value) internal {
259         require(spender != address(0));
260         require(owner != address(0));
261 
262         _allowed[owner][spender] = value;
263         emit Approval(owner, spender, value);
264     }
265 
266     /**
267      * @dev Internal function that burns an amount of the token of a given
268      * account, deducting from the sender's allowance for said account. Uses the
269      * internal burn function.
270      * Emits an Approval event (reflecting the reduced allowance).
271      * @param account The account whose tokens will be burnt.
272      * @param value The amount that will be burnt.
273      */
274     function _burnFrom(address account, uint256 value) internal {
275         _burn(account, value);
276         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
277     }
278 }
279 
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control
284  * functions, this simplifies the implementation of "user permissions".
285  */
286 contract Ownable {
287     address private _owner;
288 
289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291     /**
292      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
293      * account.
294      */
295     constructor () internal {
296         _owner = msg.sender;
297         emit OwnershipTransferred(address(0), _owner);
298     }
299 
300     /**
301      * @return the address of the owner.
302      */
303     function owner() public view returns (address) {
304         return _owner;
305     }
306 
307     /**
308      * @dev Throws if called by any account other than the owner.
309      */
310     modifier onlyOwner() {
311         require(isOwner());
312         _;
313     }
314 
315     /**
316      * @return true if `msg.sender` is the owner of the contract.
317      */
318     function isOwner() public view returns (bool) {
319         return msg.sender == _owner;
320     }
321 
322     /**
323      * @dev Allows the current owner to relinquish control of the contract.
324      * It will not be possible to call the functions with the `onlyOwner`
325      * modifier anymore.
326      * @notice Renouncing ownership will leave the contract without an owner,
327      * thereby removing any functionality that is only available to the owner.
328      */
329     function renounceOwnership() public onlyOwner {
330         emit OwnershipTransferred(_owner, address(0));
331         _owner = address(0);
332     }
333 
334     /**
335      * @dev Allows the current owner to transfer control of the contract to a newOwner.
336      * @param newOwner The address to transfer ownership to.
337      */
338     function transferOwnership(address newOwner) public onlyOwner {
339         _transferOwnership(newOwner);
340     }
341 
342     /**
343      * @dev Transfers control of the contract to a newOwner.
344      * @param newOwner The address to transfer ownership to.
345      */
346     function _transferOwnership(address newOwner) internal {
347         require(newOwner != address(0));
348         emit OwnershipTransferred(_owner, newOwner);
349         _owner = newOwner;
350     }
351 }
352 
353 
354 
355 
356 /**
357  * @title ERC20Detailed token
358  * @dev The decimals are only for visualization purposes.
359  * All the operations are done using the smallest and indivisible token unit,
360  * just as on Ethereum all the operations are done in wei.
361  */
362 contract ERC20Detailed is IERC20 {
363     string private _name;
364     string private _symbol;
365     uint8 private _decimals;
366 
367     constructor (string memory name, string memory symbol, uint8 decimals) public {
368         _name = name;
369         _symbol = symbol;
370         _decimals = decimals;
371     }
372 
373     /**
374      * @return the name of the token.
375      */
376     function name() public view returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @return the symbol of the token.
382      */
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     /**
388      * @return the number of decimals of the token.
389      */
390     function decimals() public view returns (uint8) {
391         return _decimals;
392     }
393 }
394 
395 
396 
397 
398 
399 
400 contract ClickGemToken is ERC20, Ownable, ERC20Detailed {
401 	uint public initialSupply = 55000000000;
402 	mapping (address => uint256) public freezeList;
403 	
404 
405 	mapping (address => LockItem[]) public lockList;
406 	
407     struct LockItem {
408 		uint256  time;
409 		uint256  amount;
410 	}
411 	
412 	constructor() public ERC20Detailed("ClickGem Token", "CGMT", 8) 
413 	{  
414 		_mint(msg.sender, initialSupply*100000000);
415 	}
416 
417 	function freeze(address freezeAddress) public onlyOwner returns (bool done)
418 	{
419 		freezeList[freezeAddress]=1;
420 		return isFreeze(freezeAddress);
421     	}
422 
423 	function unFreeze(address freezeAddress) public onlyOwner returns (bool done)
424 	{
425 		delete freezeList[freezeAddress];
426 		return !isFreeze(freezeAddress); 
427 	}
428 
429 	function isFreeze(address freezeAddress) public view returns (bool isFreezed) 
430 	{
431 		return freezeList[freezeAddress]==1;
432 	}
433 
434 
435 
436 	function isLocked(address lockedAddress) public view returns (bool isLockedAddress)
437 	{
438 		if(lockList[lockedAddress].length>0)
439 		{
440 		    for(uint i=0; i< lockList[lockedAddress].length; i++)
441 		    {
442 		        if(lockList[lockedAddress][i].time - now > 0)
443 		        return true;
444 		    }
445 		}
446 		return false;
447 	}
448 
449 	function transfer(address _receiver, uint256 _amount) public returns (bool success)
450 	{
451 		require(!isFreeze(msg.sender));
452 	    if(!isLocked(_receiver)){
453 		    uint256 remain = balanceOf(msg.sender).sub(_amount);
454 		    require(remain>=getLockedAmount(msg.sender));
455 		}
456         return ERC20.transfer(_receiver, _amount);
457 	}
458 
459 	function transferAndLock(address _receiver, uint256 _amount, uint256 time) public returns (bool success)
460 	{
461         transfer(_receiver, _amount);
462     	LockItem memory item = LockItem({amount:_amount, time:time+now});
463 		lockList[_receiver].push(item);
464         return true;
465 	}
466 	
467 	function getLockedListSize(address lockedAddress) public view returns(uint256 _lenght)
468 	{
469 	    return lockList[lockedAddress].length;
470 	}
471 	
472 	function getLockedAmountAt(address lockedAddress, uint8 index) public view returns(uint256 _amount)
473 	{
474 	    return lockList[lockedAddress][index].amount;
475 	}
476 	
477 	function getLockedTimeAt(address lockedAddress, uint8 index) public view returns(uint256 _time)
478 	{
479 	    return lockList[lockedAddress][index].time.sub(now);
480 	}
481 	
482 	function getLockedAmount(address lockedAddress) public view returns(uint256 _amount)
483 	{
484 	    uint256 lockedAmount =0;
485 	    if(isLocked(lockedAddress))
486 	    {
487 	       for(uint8 j=0;j<lockList[lockedAddress].length;j++)
488 	       {
489 	        if(getLockedTimeAt(lockedAddress, j) > now )
490 	        {
491 	            lockedAmount=lockedAmount.add(getLockedAmountAt(lockedAddress, j));
492 	        }
493 	       }
494 	    }
495 	    return lockedAmount;
496 	}
497 
498 
499 }