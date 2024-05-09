1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address private _owner;
75 
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() internal {
86     _owner = msg.sender;
87     emit OwnershipTransferred(address(0), _owner);
88   }
89 
90   /**
91    * @return the address of the owner.
92    */
93   function owner() public view returns(address) {
94     return _owner;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(isOwner());
102     _;
103   }
104 
105   /**
106    * @return true if `msg.sender` is the owner of the contract.
107    */
108   function isOwner() public view returns(bool) {
109     return msg.sender == _owner;
110   }
111 
112   /**
113    * @dev Allows the current owner to relinquish control of the contract.
114    * @notice Renouncing to ownership will leave the contract without an owner.
115    * It will not be possible to call the functions with the `onlyOwner`
116    * modifier anymore.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipTransferred(_owner, address(0));
120     _owner = address(0);
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) public onlyOwner {
128     _transferOwnership(newOwner);
129   }
130 
131   /**
132    * @dev Transfers control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function _transferOwnership(address newOwner) internal {
136     require(newOwner != address(0));
137     emit OwnershipTransferred(_owner, newOwner);
138     _owner = newOwner;
139   }
140 }
141 
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 interface IERC20 {
148   function totalSupply() external view returns (uint256);
149 
150   function balanceOf(address who) external view returns (uint256);
151 
152   function allowance(address owner, address spender)
153     external view returns (uint256);
154 
155   function transfer(address to, uint256 value) external returns (bool);
156 
157   function approve(address spender, uint256 value)
158     external returns (bool);
159 
160   function transferFrom(address from, address to, uint256 value)
161     external returns (bool);
162 
163   event Transfer(
164     address indexed from,
165     address indexed to,
166     uint256 value
167   );
168 
169   event Approval(
170     address indexed owner,
171     address indexed spender,
172     uint256 value
173   );
174 }
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
182  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract ERC20 is IERC20 {
185   using SafeMath for uint256;
186 
187   mapping (address => uint256) private _balances;
188 
189   mapping (address => mapping (address => uint256)) private _allowed;
190 
191   uint256 private _totalSupply;
192 
193   /**
194   * @dev Total number of tokens in existence
195   */
196   function totalSupply() public view returns (uint256) {
197     return _totalSupply;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param owner The address to query the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address owner) public view returns (uint256) {
206     return _balances[owner];
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param owner address The address which owns the funds.
212    * @param spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(
216     address owner,
217     address spender
218    )
219     public
220     view
221     returns (uint256)
222   {
223     return _allowed[owner][spender];
224   }
225 
226   /**
227   * @dev Transfer token for a specified address
228   * @param to The address to transfer to.
229   * @param value The amount to be transferred.
230   */
231   function transfer(address to, uint256 value) public returns (bool) {
232     _transfer(msg.sender, to, value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param spender The address which will spend the funds.
243    * @param value The amount of tokens to be spent.
244    */
245   function approve(address spender, uint256 value) public returns (bool) {
246     require(spender != address(0));
247 
248     _allowed[msg.sender][spender] = value;
249     emit Approval(msg.sender, spender, value);
250     return true;
251   }
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param from address The address which you want to send tokens from
256    * @param to address The address which you want to transfer to
257    * @param value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address from,
261     address to,
262     uint256 value
263   )
264     public
265     returns (bool)
266   {
267     require(value <= _allowed[from][msg.sender]);
268 
269     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
270     _transfer(from, to, value);
271     return true;
272   }
273 
274   /**
275    * @dev Increase the amount of tokens that an owner allowed to a spender.
276    * approve should be called when allowed_[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param spender The address which will spend the funds.
281    * @param addedValue The amount of tokens to increase the allowance by.
282    */
283   function increaseAllowance(
284     address spender,
285     uint256 addedValue
286   )
287     public
288     returns (bool)
289   {
290     require(spender != address(0));
291 
292     _allowed[msg.sender][spender] = (
293       _allowed[msg.sender][spender].add(addedValue));
294     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
295     return true;
296   }
297 
298   /**
299    * @dev Decrease the amount of tokens that an owner allowed to a spender.
300    * approve should be called when allowed_[_spender] == 0. To decrement
301    * allowed value is better to use this function to avoid 2 calls (and wait until
302    * the first transaction is mined)
303    * From MonolithDAO Token.sol
304    * @param spender The address which will spend the funds.
305    * @param subtractedValue The amount of tokens to decrease the allowance by.
306    */
307   function decreaseAllowance(
308     address spender,
309     uint256 subtractedValue
310   )
311     public
312     returns (bool)
313   {
314     require(spender != address(0));
315 
316     _allowed[msg.sender][spender] = (
317       _allowed[msg.sender][spender].sub(subtractedValue));
318     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
319     return true;
320   }
321 
322   /**
323   * @dev Transfer token for a specified addresses
324   * @param from The address to transfer from.
325   * @param to The address to transfer to.
326   * @param value The amount to be transferred.
327   */
328   function _transfer(address from, address to, uint256 value) internal {
329     require(value <= _balances[from]);
330     require(to != address(0));
331 
332     _balances[from] = _balances[from].sub(value);
333     _balances[to] = _balances[to].add(value);
334     emit Transfer(from, to, value);
335   }
336 
337   /**
338    * @dev Internal function that mints an amount of the token and assigns it to
339    * an account. This encapsulates the modification of balances such that the
340    * proper events are emitted.
341    * @param account The account that will receive the created tokens.
342    * @param value The amount that will be created.
343    */
344   function _mint(address account, uint256 value) internal {
345     require(account != 0);
346     _totalSupply = _totalSupply.add(value);
347     _balances[account] = _balances[account].add(value);
348     emit Transfer(address(0), account, value);
349   }
350 
351   /**
352    * @dev Internal function that burns an amount of the token of a given
353    * account.
354    * @param account The account whose tokens will be burnt.
355    * @param value The amount that will be burnt.
356    */
357   function _burn(address account, uint256 value) internal {
358     require(account != 0);
359     require(value <= _balances[account]);
360 
361     _totalSupply = _totalSupply.sub(value);
362     _balances[account] = _balances[account].sub(value);
363     emit Transfer(account, address(0), value);
364   }
365 
366   /**
367    * @dev Internal function that burns an amount of the token of a given
368    * account, deducting from the sender's allowance for said account. Uses the
369    * internal burn function.
370    * @param account The account whose tokens will be burnt.
371    * @param value The amount that will be burnt.
372    */
373   function _burnFrom(address account, uint256 value) internal {
374     require(value <= _allowed[account][msg.sender]);
375 
376     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
377     // this function needs to emit an event with the updated approval.
378     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
379       value);
380     _burn(account, value);
381   }
382 }
383 
384 
385 interface IJoySale  {
386     function getEndDate() external view returns (uint256);
387 }
388 
389 
390 contract JoyToken is ERC20, Ownable {
391    
392     string public symbol;
393     string public  name;
394     uint256 public decimals;
395 
396     uint256 private _cap;
397 
398     address public saleAddress;
399     IJoySale public sale;
400 
401     bool public unlocked = false;
402 
403     bool public sendedToSale;
404     bool public sendedToTeam;
405     bool public sendedToTeamLock;
406     bool public sendedToAdvisors;
407     bool public sendedToAdvisorsLock;
408     bool public sendedToService;
409 
410     uint256 public salePart;
411     uint256 public teamPart;
412     uint256 public teamPartLock;
413     uint256 public advisorsPart;
414     uint256 public advisorsPartLock;
415     uint256 public servicePart;
416 
417     uint256 constant LOCK_TIME = 365 days;
418     
419 
420     modifier whenUnlocked()  {
421         if (msg.sender != saleAddress) {
422             require(unlocked);
423         }
424         _;
425     }
426 
427     modifier onlySale() {
428 	    require(msg.sender == saleAddress);
429 	    _;
430 	}
431 
432 
433     function cap() public view returns(uint256) {
434         return _cap;
435     }
436 
437     function _mint(address account, uint256 value) internal {
438         require(totalSupply().add(value) <= _cap);
439         super._mint(account, value);
440     }
441 
442 
443 	function transfer(address _to, uint256 _value) public whenUnlocked() returns (bool) {
444         return super.transfer(_to, _value);
445     }
446 
447     function transferFrom(address _from, address _to, uint256 _value) public whenUnlocked() returns (bool) {
448         return super.transferFrom(_from, _to, _value);
449     }
450 
451     function approve(address _spender, uint256 _value) public whenUnlocked() returns (bool) {
452         return super.approve(_spender, _value);
453 	}
454 
455 
456     constructor() public {
457         symbol = "JOY";
458         name = "Joy coin";
459         decimals = 8;
460 
461         _cap             =  2400000000 * 10 ** decimals; 
462 
463         salePart         =  1625400000 * 10 ** decimals; // 67,725%
464                       
465         advisorsPart     =    42000000 * 10 ** decimals; // 25% from 7%
466         advisorsPartLock =   126000000 * 10 ** decimals; // 75% from 7%
467 
468         teamPart         =    31650000 * 10 ** decimals;  // 25% from 5,275%
469         teamPartLock     =    94950000 * 10 ** decimals; // 75% from 5,275%
470 
471         servicePart      =   480000000 * 10 ** decimals; // 20%
472 
473         require (_cap == salePart + advisorsPart + advisorsPartLock + teamPart + teamPartLock + servicePart);
474     }
475 
476 
477     function setSaleAddress(address _address) public onlyOwner returns (bool) {
478         require(saleAddress == address(0));
479         require (!sendedToSale);
480         saleAddress = _address;
481         sale = IJoySale(saleAddress);
482         return true;
483 	}
484 
485 	function unlockTokens() public onlyOwner returns (bool)	{
486 		unlocked = true;
487 		return true;
488 	}
489 
490 	function burnUnsold() public onlySale returns (bool) {
491     	_burn(saleAddress, balanceOf(saleAddress));
492         return true;
493   	}
494 
495     function sendTokensToSale() public onlyOwner returns (bool) {
496         require (saleAddress != address(0x0));
497         require (!sendedToSale);
498         sendedToSale = true;
499         _mint(saleAddress, salePart);
500         return true;
501     }
502 
503     function sendTokensToTeamLock(address _teamAddress) public onlyOwner returns (bool) {
504         require (_teamAddress != address(0x0));
505         require (!sendedToTeamLock);
506         require (sale.getEndDate() > 0 && now > (sale.getEndDate() + LOCK_TIME) );
507         sendedToTeamLock = true;
508         _mint(_teamAddress, teamPartLock);
509         return true;
510     }
511 
512     function sendTokensToTeam(address _teamAddress) public onlyOwner returns (bool) {
513         require (_teamAddress != address(0x0));
514         require (!sendedToTeam);
515         require ( sale.getEndDate() > 0 && now > sale.getEndDate() );
516         sendedToTeam = true;
517         _mint(_teamAddress, teamPart);
518         return true;
519     }
520 
521     function sendTokensToAdvisors(address _advisorsAddress) public onlyOwner returns (bool) {
522         require (_advisorsAddress != address(0x0));
523         require (!sendedToAdvisors);
524         require (sale.getEndDate() > 0 && now > sale.getEndDate());
525         sendedToAdvisors = true;
526         _mint(_advisorsAddress, advisorsPart);
527         return true;
528     }
529 
530     function sendTokensToAdvisorsLock(address _advisorsAddress) public onlyOwner returns (bool) {
531         require (_advisorsAddress != address(0x0));
532         require (!sendedToAdvisorsLock);
533         require (sale.getEndDate() > 0 && now > (sale.getEndDate() + LOCK_TIME) );
534         sendedToAdvisorsLock = true;
535         _mint(_advisorsAddress, advisorsPartLock);
536         return true;
537     }
538 
539     function sendTokensToService(address _serviceAddress) public onlyOwner returns (bool) {
540         require (_serviceAddress != address(0x0));
541         require (!sendedToService);
542         sendedToService = true;
543         _mint(_serviceAddress, servicePart);
544         return true;
545     }
546 }