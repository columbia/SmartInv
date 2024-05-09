1 /* FOOToken                             */
2 /* Released on 11.11.2018 v.1.0         */
3 /* To celebrate 100 years of Polish     */
4 /* INDEPENDENCE                         */   
5 /* ==================================== */
6 /* National Independence Day  is a      */
7 /* national day in Poland celebrated on */ 
8 /* 11 November to commemorate the       */
9 /* anniversary of the restoration of    */
10 /* Poland's sovereignty as the          */
11 /* Second Polish Republic in 1918 from  */
12 /* German, Austrian and Russian Empires */
13 /* Following the partitions in the late */
14 /* 18th century, Poland ceased to exist */
15 /* for 123 years until the end of       */
16 /* World War I, when the destruction of */
17 /* the neighbouring powers allowed the  */
18 /* country to reemerge.                 */
19 
20 pragma solidity ^0.4.25;
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that revert on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, reverts on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     uint256 c = a * b;
40     require(c / a == b);
41 
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b > 0); // Solidity only automatically asserts when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53     return c;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   /**
67   * @dev Adds two numbers, reverts on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     require(c >= a);
72 
73     return c;
74   }
75 
76   /**
77   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
78   * reverts when dividing by zero.
79   */
80   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b != 0);
82     return a % b;
83   }
84 }
85 
86 contract ERC223Interface {
87     function balanceOf(address who) public constant returns (uint);
88     function transfer(address to, uint value)  public ;
89     function transfer(address to, uint value, bytes data)  public ;
90     event Transfer(address indexed from, address indexed to, uint value, bytes data);
91 }
92 
93 /**
94  * @title Contract that will work with ERC223 tokens.
95  */
96  
97 contract ERC223ReceivingContract { 
98 /**
99  * @dev Standard ERC223 function that will handle incoming token transfers.
100  *
101  * @param _from  Token sender address.
102  * @param _value Amount of tokens.
103  * @param _data  Transaction metadata.
104  */
105     function tokenFallback(address _from, uint _value, bytes _data) public;
106 }
107 
108 /**
109  * @title Ownable
110  * @dev The Ownable contract has an owner address, and provides basic authorization control
111  * functions, this simplifies the implementation of "user permissions".
112  */
113 contract Ownable {
114   address private _owner;
115 
116   event OwnershipTransferred(
117     address indexed previousOwner,
118     address indexed newOwner
119   );
120 
121   /**
122    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
123    * account.
124    */
125   constructor() internal {
126     _owner = msg.sender;
127     emit OwnershipTransferred(address(0), _owner);
128   }
129 
130   /**
131    * @return the address of the owner.
132    */
133   function owner() public view returns(address) {
134     return _owner;
135   }
136 
137   /**
138    * @dev Throws if called by any account other than the owner.
139    */
140   modifier onlyOwner() {
141     require(isOwner());
142     _;
143   }
144 
145   /**
146    * @return true if `msg.sender` is the owner of the contract.
147    */
148   function isOwner() public view returns(bool) {
149     return msg.sender == _owner;
150   }
151 
152   /**
153    * @dev Allows the current owner to relinquish control of the contract.
154    * @notice Renouncing to ownership will leave the contract without an owner.
155    * It will not be possible to call the functions with the `onlyOwner`
156    * modifier anymore.
157    */
158   function renounceOwnership() public onlyOwner {
159     emit OwnershipTransferred(_owner, address(0));
160     _owner = address(0);
161   }
162 
163   /**
164    * @dev Allows the current owner to transfer control of the contract to a newOwner.
165    * @param newOwner The address to transfer ownership to.
166    */
167   function transferOwnership(address newOwner) public onlyOwner {
168     _transferOwnership(newOwner);
169   }
170 
171   /**
172    * @dev Transfers control of the contract to a newOwner.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function _transferOwnership(address newOwner) internal {
176     require(newOwner != address(0));
177     emit OwnershipTransferred(_owner, newOwner);
178     _owner = newOwner;
179   }
180 }
181 
182 /**
183  * @title Pausable
184  * @dev Base contract which allows children to implement an emergency stop mechanism.
185  */
186 contract Pausable is Ownable {
187   event Paused(address account);
188   event Unpaused(address account);
189 
190   bool private _paused;
191 
192   constructor() internal {
193     _paused = false;
194   }
195 
196   /**
197    * @return true if the contract is paused, false otherwise.
198    */
199   function paused() public view returns(bool) {
200     return _paused;
201   }
202 
203   /**
204    * @dev Modifier to make a function callable only when the contract is not paused.
205    */
206   modifier whenNotPaused() {
207     require(!_paused);
208     _;
209   }
210 
211   /**
212    * @dev Modifier to make a function callable only when the contract is paused.
213    */
214   modifier whenPaused() {
215     require(_paused);
216     _;
217   }
218 
219   /**
220    * @dev called by the owner to pause, triggers stopped state
221    */
222   function pause() public onlyOwner whenNotPaused {
223     _paused = true;
224     emit Paused(msg.sender);
225   }
226 
227   /**
228    * @dev called by the owner to unpause, returns to normal state
229    */
230   function unpause() public onlyOwner whenPaused {
231     _paused = false;
232     emit Unpaused(msg.sender);
233   }
234 }
235 
236 
237 /**
238  * @title ERC20 interface
239  * @dev see https://github.com/ethereum/EIPs/issues/20
240  */
241 interface IERC20 {
242   function totalSupply() external view returns (uint256);
243 
244   function balanceOf(address who) external view returns (uint256);
245 
246   function allowance(address owner, address spender)
247     external view returns (uint256);
248 
249   function transfer(address to, uint256 value) external returns (bool);
250 
251   function approve(address spender, uint256 value)
252     external returns (bool);
253 
254   function transferFrom(address from, address to, uint256 value)
255     external returns (bool);
256 
257   event Transfer(
258     address indexed from,
259     address indexed to,
260     uint256 value
261   );
262 
263   event Approval(
264     address indexed owner,
265     address indexed spender,
266     uint256 value
267   );
268 }
269 
270 /**
271  * @title Reference implementation of the ERC223 standard token.
272  */
273 contract FOOToken is IERC20, ERC223Interface, Ownable, Pausable {
274     using SafeMath for uint;
275     
276     mapping(address => uint) balances; // List of user balances.
277     
278     mapping (address => mapping (address => uint256)) private _allowed;
279     
280     modifier validDestination( address to ) {
281       require(to != address(0x0));
282       _;
283     }
284     
285     string private _name;
286     string private _symbol;
287     uint8 private _decimals;
288     uint256 private _totalSupply;
289     
290  constructor() public {
291       _name = "FOOToken";
292       _symbol = "FOOT";
293       _decimals = 18;
294       _mint(msg.sender, 100000000 * (10 ** 18));
295     }
296 
297     /**
298   * @dev Total number of tokens in existence
299   */
300   function totalSupply() public view returns (uint256) {
301     return _totalSupply;
302   }
303 
304   /**
305    * @return the name of the token.
306    */
307     function name() public view returns(string) {
308       return _name;
309     }
310 
311   /**
312    * @return the symbol of the token.
313    */
314     function symbol() public view returns(string) {
315       return _symbol;
316     }
317 
318   /**
319    * @return the number of decimals of the token.
320    */
321     function decimals() public view returns(uint8) {
322       return _decimals;
323     }
324     
325     function allowance(
326     address owner,
327     address spender
328    )
329     public
330     view
331     returns (uint256)
332   {
333     return _allowed[owner][spender];
334   }
335   
336   /**
337    * @dev Increase the amount of tokens that an owner allowed to a spender.
338    * approve should be called when allowed[_spender] == 0. To increment
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param spender The address which will spend the funds.
343    * @param addedValue The amount of tokens to increase the allowance by.
344    */
345    function increaseAllowance(
346     address spender,
347     uint256 addedValue
348   )
349     public
350     whenNotPaused
351     returns (bool)
352   {
353     require(spender != address(0));
354 
355     _allowed[msg.sender][spender] = (
356       _allowed[msg.sender][spender].add(addedValue));
357     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
358     return true;
359   }
360 
361   /**
362    * @dev Decrease the amount of tokens that an owner allowed to a spender.
363    * approve should be called when allowed_[_spender] == 0. To decrement
364    * allowed value is better to use this function to avoid 2 calls (and wait until
365    * the first transaction is mined)
366    * From MonolithDAO Token.sol
367    * @param spender The address which will spend the funds.
368    * @param subtractedValue The amount of tokens to decrease the allowance by.
369    */
370   function decreaseAllowance(
371     address spender,
372     uint256 subtractedValue
373   )
374     public
375     whenNotPaused
376     returns (bool)
377   {
378     require(spender != address(0));
379 
380     _allowed[msg.sender][spender] = (
381       _allowed[msg.sender][spender].sub(subtractedValue));
382     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
383     return true;
384   }
385 
386   
387    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
388     require(spender != address(0));
389 
390     _allowed[msg.sender][spender] = value;
391     emit Approval(msg.sender, spender, value);
392     return true;
393   }
394   
395   
396   /**
397    * @dev Transfer tokens from one address to another
398    * @param _from address The address which you want to send tokens from
399    * @param _to address The address which you want to transfer to
400    * @param _value uint256 the amount of tokens to be transferred
401    */
402   function transferFrom(
403     address _from,
404     address _to,
405     uint256 _value
406   )
407     validDestination(_to) 
408     public
409     whenNotPaused
410     returns (bool)
411   {
412     require(_value <= balances[_from]);
413     require(_value <= _allowed[_from][msg.sender]);
414     require(_to != address(0));
415 
416     balances[_from] = balances[_from].sub(_value);
417     balances[_to] = balances[_to].add(_value);
418     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
419     emit Transfer(_from, _to, _value);
420 
421     
422     uint codeLength;
423     bytes memory empty;
424     assembly {
425       // Retrieve the size of the code on target address, this needs assembly .
426       codeLength := extcodesize(_to)
427     }
428     if(codeLength>0) {
429       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
430       receiver.tokenFallback(_from, _value, empty);
431     }
432     
433 
434     return true;
435   }
436 
437   
438     /**
439      * @dev Transfer the specified amount of tokens to the specified address.
440      *      Invokes the `tokenFallback` function if the recipient is a contract.
441      *      The token transfer fails if the recipient is a contract
442      *      but does not implement the `tokenFallback` function
443      *      or the fallback function to receive funds.
444      *
445      * @param _to    Receiver address.
446      * @param _value Amount of tokens that will be transferred.
447      * @param _data  Transaction metadata.
448      */
449     function transfer(address _to, uint _value, bytes _data)  whenNotPaused validDestination(_to) public {
450         // Standard function transfer similar to ERC20 transfer with no _data .
451         // Added due to backwards compatibility reasons .
452         uint codeLength;
453 
454         assembly {
455             // Retrieve the size of the code on target address, this needs assembly .
456             codeLength := extcodesize(_to)
457         }
458 
459         balances[msg.sender] = balances[msg.sender].sub(_value);
460         balances[_to] = balances[_to].add(_value);
461         if(codeLength>0) {
462             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
463             receiver.tokenFallback(msg.sender, _value, _data);
464         }
465         emit Transfer(msg.sender, _to, _value, _data);
466     }
467     
468     
469     
470     /**
471    * @dev Internal function that mints an amount of the token and assigns it to
472    * an account. This encapsulates the modification of balances such that the
473    * proper events are emitted.
474    * @param _account The account that will receive the created tokens.
475    * @param _amount The amount that will be created.
476    */
477   function _mint(address _account, uint256 _amount) internal {
478     require(_account != 0);
479     _totalSupply = _totalSupply.add(_amount);
480     balances[_account] = balances[_account].add(_amount);
481     emit Transfer(address(0), _account, _amount);
482 
483     
484     uint codeLength;
485     bytes memory empty;
486     assembly {
487       // Retrieve the size of the code on target address, this needs assembly .
488       codeLength := extcodesize(_account)
489     }
490     if(codeLength>0) {
491       ERC223ReceivingContract receiver = ERC223ReceivingContract(_account);
492       receiver.tokenFallback(address(0), _amount, empty);
493     }
494     
495   }
496 
497   
498     /**
499      * @dev Transfer the specified amount of tokens to the specified address.
500      *      This function works the same with the previous one
501      *      but doesn't contain `_data` param.
502      *      Added due to backwards compatibility reasons.
503      *
504      * @param _to    Receiver address.
505      * @param _value Amount of tokens that will be transferred.
506      */
507     function transfer(address _to, uint _value) whenNotPaused validDestination(_to) public {
508         uint codeLength;
509         bytes memory empty;
510 
511         assembly {
512             // Retrieve the size of the code on target address, this needs assembly .
513             codeLength := extcodesize(_to)
514         }
515 
516         balances[msg.sender] = balances[msg.sender].sub(_value);
517         balances[_to] = balances[_to].add(_value);
518         if(codeLength>0) {
519             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
520             receiver.tokenFallback(msg.sender, _value, empty);
521         }
522         emit Transfer(msg.sender, _to, _value, empty);
523     }
524 
525     
526     /**
527      * @dev Returns balance of the `_owner`.
528      *
529      * @param _owner   The address whose balance will be returned.
530      * @return balance Balance of the `_owner`.
531      */
532     function balanceOf(address _owner) public view returns (uint balance) {
533         return balances[_owner];
534     }
535     // Don't accept direct payments
536   
537   function() public payable {
538     revert();
539   }
540   
541   struct TKN {
542         address sender;
543         uint value;
544         bytes data;
545         bytes4 sig;
546     }
547 
548     function tokenFallback(address _from, uint _value, bytes _data) pure public {
549       TKN memory tkn;
550       tkn.sender = _from;
551       tkn.value = _value;
552       tkn.data = _data;
553       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
554       tkn.sig = bytes4(u);
555 
556       /* tkn variable is analogue of msg variable of Ether transaction
557       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
558       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
559       *  tkn.data is data of token transaction   (analogue of msg.data)
560       *  tkn.sig is 4 bytes signature of function
561       *  if data of token transaction is a function execution
562       */
563     }
564     
565 }