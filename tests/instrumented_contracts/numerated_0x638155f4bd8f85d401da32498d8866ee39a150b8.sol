1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8   /**
9    * @dev Multiplies two unsigned integers, reverts on overflow.
10    */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   /**
26    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27    */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // Solidity only automatically asserts when dividing by 0
30     require(b > 0);
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39    */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48    * @dev Adds two unsigned integers, reverts on overflow.
49    */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59    * reverts when dividing by zero.
60    */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address private _owner;
74 
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() internal {
85     _owner = msg.sender;
86     emit OwnershipTransferred(address(0), _owner);
87   }
88 
89   /**
90    * @return the address of the owner.
91    */
92   function owner() public view returns (address) {
93     return _owner;
94   }
95 
96   /**
97    * @dev Throws if called by any account other than the owner.
98    */
99   modifier onlyOwner() {
100     require(isOwner());
101     _;
102   }
103 
104   /**
105    * @return true if `msg.sender` is the owner of the contract.
106    */
107   function isOwner() public view returns (bool) {
108     return msg.sender == _owner;
109   }
110 
111   /**
112    * @dev Allows the current owner to relinquish control of the contract.
113    * @notice Renouncing to ownership will leave the contract without an owner.
114    * It will not be possible to call the functions with the `onlyOwner`
115    * modifier anymore.
116    */
117   function renounceOwnership() public onlyOwner {
118     emit OwnershipTransferred(_owner, address(0));
119     _owner = address(0);
120   }
121 
122   /**
123    * @dev Allows the current owner to transfer control of the contract to a newOwner.
124    * @param newOwner The address to transfer ownership to.
125    */
126   function transferOwnership(address newOwner) public onlyOwner {
127     _transferOwnership(newOwner);
128   }
129 
130   /**
131    * @dev Transfers control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function _transferOwnership(address newOwner) internal {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(_owner, newOwner);
137     _owner = newOwner;
138   }
139 }
140 
141 /**
142  * @title Pausable
143  * @dev Base contract which allows children to implement an emergency stop mechanism.
144  */
145 contract Pausable is Ownable {
146   event Paused(address account);
147   event Unpaused(address account);
148 
149   bool private _paused;
150 
151   constructor() internal {
152     _paused = false;
153   }
154 
155   /**
156    * @return true if the contract is paused, false otherwise.
157    */
158   function paused() public view returns (bool) {
159     return _paused;
160   }
161 
162   /**
163    * @dev Modifier to make a function callable only when the contract is not paused.
164    */
165   modifier whenNotPaused() {
166     require(!_paused);
167     _;
168   }
169 
170   /**
171    * @dev Modifier to make a function callable only when the contract is paused.
172    */
173   modifier whenPaused() {
174     require(_paused);
175     _;
176   }
177 
178   /**
179    * @dev called by the owner to pause, triggers stopped state
180    */
181   function pause() public onlyOwner whenNotPaused {
182     _paused = true;
183     emit Paused(msg.sender);
184   }
185 
186   /**
187    * @dev called by the owner to unpause, returns to normal state
188    */
189   function unpause() public onlyOwner whenPaused {
190     _paused = false;
191     emit Unpaused(msg.sender);
192   }
193 }
194 
195 /**
196  * @title ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/20
198  */
199 interface IERC20 {
200   function totalSupply() external view returns (uint256);
201 
202   function balanceOf(address who) external view returns (uint256);
203 
204   function allowance(address owner, address spender)
205     external view returns (uint256);
206 
207   function transfer(address to, uint256 value) external returns (bool);
208 
209   function approve(address spender, uint256 value)
210     external returns (bool);
211 
212   function transferFrom(address from, address to, uint256 value)
213     external returns (bool);
214 
215   event Transfer(
216     address indexed from,
217     address indexed to,
218     uint256 value
219   );
220 
221   event Approval(
222     address indexed owner,
223     address indexed spender,
224     uint256 value
225   );
226 }
227 
228 /**
229  * @title Standard ERC20 token
230  *
231  * @dev Implementation of the basic standard token.
232  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
233  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
234  *
235  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
236  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
237  * compliant implementations may not do it.
238  */
239 contract ERC20 is IERC20 {
240   using SafeMath for uint256;
241 
242   mapping (address => uint256) private _balances;
243 
244   mapping (address => mapping (address => uint256)) private _allowed;
245 
246   uint256 private _totalSupply;
247 
248   /**
249    * @dev Total number of tokens in existence
250    */
251   function totalSupply() public view returns (uint256) {
252     return _totalSupply;
253   }
254 
255   /**
256    * @dev Gets the balance of the specified address.
257    * @param owner The address to query the balance of.
258    * @return An uint256 representing the amount owned by the passed address.
259    */
260   function balanceOf(address owner) public view returns (uint256) {
261     return _balances[owner];
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param owner address The address which owns the funds.
267    * @param spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(
271     address owner,
272     address spender
273   )
274     public
275     view
276     returns (uint256)
277   {
278     return _allowed[owner][spender];
279   }
280 
281   /**
282    * @dev Transfer token for a specified address
283    * @param to The address to transfer to.
284    * @param value The amount to be transferred.
285    */
286   function transfer(address to, uint256 value) public returns (bool) {
287     _transfer(msg.sender, to, value);
288     return true;
289   }
290 
291   /**
292    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
293    * Beware that changing an allowance with this method brings the risk that someone may use both the old
294    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297    * @param spender The address which will spend the funds.
298    * @param value The amount of tokens to be spent.
299    */
300   function approve(address spender, uint256 value) public returns (bool) {
301     _approve(msg.sender, spender, value);
302     return true;
303   }
304 
305   /**
306    * @dev Transfer tokens from one address to another.
307    * Note that while this function emits an Approval event, this is not required as per the specification,
308    * and other compliant implementations may not emit the event.
309    * @param from address The address which you want to send tokens from
310    * @param to address The address which you want to transfer to
311    * @param value uint256 the amount of tokens to be transferred
312    */
313   function transferFrom(
314     address from,
315     address to,
316     uint256 value
317   )
318     public
319     returns (bool)
320   {
321     _transfer(from, to, value);
322     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
323     return true;
324   }
325 
326   /**
327    * @dev Increase the amount of tokens that an owner allowed to a spender.
328    * approve should be called when allowed_[_spender] == 0. To increment
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)
331    * From MonolithDAO Token.sol
332    * Emits an Approval event.
333    * @param spender The address which will spend the funds.
334    * @param addedValue The amount of tokens to increase the allowance by.
335    */
336   function increaseAllowance(
337     address spender,
338     uint256 addedValue
339   )
340     public
341     returns (bool)
342   {
343     _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
344     return true;
345   }
346 
347   /**
348    * @dev Decrease the amount of tokens that an owner allowed to a spender.
349    * approve should be called when allowed_[_spender] == 0. To decrement
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol
353    * Emits an Approval event.
354    * @param spender The address which will spend the funds.
355    * @param subtractedValue The amount of tokens to decrease the allowance by.
356    */
357   function decreaseAllowance(
358     address spender,
359     uint256 subtractedValue
360   )
361     public
362     returns (bool)
363   {
364     _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
365     return true;
366   }
367 
368   /**
369    * @dev Transfer token for a specified addresses
370    * @param from The address to transfer from.
371    * @param to The address to transfer to.
372    * @param value The amount to be transferred.
373    */
374   function _transfer(address from, address to, uint256 value) internal {
375     require(to != address(0));
376 
377     _balances[from] = _balances[from].sub(value);
378     _balances[to] = _balances[to].add(value);
379     emit Transfer(from, to, value);
380   }
381 
382   /**
383    * @dev Internal function that mints an amount of the token and assigns it to
384    * an account. This encapsulates the modification of balances such that the
385    * proper events are emitted.
386    * @param account The account that will receive the created tokens.
387    * @param value The amount that will be created.
388    */
389   function _mint(address account, uint256 value) internal {
390     require(account != address(0));
391 
392     _totalSupply = _totalSupply.add(value);
393     _balances[account] = _balances[account].add(value);
394     emit Transfer(address(0), account, value);
395   }
396 
397   /**
398    * @dev Internal function that burns an amount of the token of a given
399    * account.
400    * @param account The account whose tokens will be burnt.
401    * @param value The amount that will be burnt.
402    */
403   function _burn(address account, uint256 value) internal {
404     require(account != address(0));
405 
406     _totalSupply = _totalSupply.sub(value);
407     _balances[account] = _balances[account].sub(value);
408     emit Transfer(account, address(0), value);
409   }
410 
411   /**
412    * @dev Approve an address to spend another addresses' tokens.
413    * @param owner The address that owns the tokens.
414    * @param spender The address that will spend the tokens.
415    * @param value The number of tokens that can be spent.
416    */
417   function _approve(address owner, address spender, uint256 value) internal {
418     require(spender != address(0));
419     require(owner != address(0));
420 
421     _allowed[owner][spender] = value;
422     emit Approval(owner, spender, value);
423   }
424 
425   /**
426    * @dev Internal function that burns an amount of the token of a given
427    * account, deducting from the sender's allowance for said account. Uses the
428    * internal burn function.
429    * Emits an Approval event (reflecting the reduced allowance).
430    * @param account The account whose tokens will be burnt.
431    * @param value The amount that will be burnt.
432    */
433   function _burnFrom(address account, uint256 value) internal {
434     _burn(account, value);
435     _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
436   }
437 }
438 
439 /**
440  * @title Burnable Token
441  * @dev Token that can be irreversibly burned (destroyed).
442  */
443 contract ERC20Burnable is ERC20 {
444   /**
445    * @dev Burns a specific amount of tokens.
446    * @param value The amount of token to be burned.
447    */
448   function burn(uint256 value) public {
449     _burn(msg.sender, value);
450   }
451 
452   /**
453    * @dev Burns a specific amount of tokens from the target address and decrements allowance
454    * @param from address The account whose tokens will be burned.
455    * @param value uint256 The amount of token to be burned.
456    */
457   function burnFrom(address from, uint256 value) public {
458     _burnFrom(from, value);
459   }
460 }
461 
462 /**
463  * @title ERC20Mintable
464  * @dev ERC20 minting logic
465  */
466 contract ERC20Mintable is ERC20, Ownable {
467   /**
468    * @dev Function to mint tokens
469    * @param to The address that will receive the minted tokens.
470    * @param value The amount of tokens to mint.
471    * @return A boolean that indicates if the operation was successful.
472    */
473   function mint(
474     address to,
475     uint256 value
476   )
477     public
478     onlyOwner
479     returns (bool)
480   {
481     _mint(to, value);
482     return true;
483   }
484 }
485 
486 /**
487  * @title Pausable token
488  * @dev ERC20 modified with pausable transfers.
489  */
490 contract ERC20Pausable is ERC20, Pausable {
491   function transfer(
492     address to,
493     uint256 value
494   )
495     public
496     whenNotPaused
497     returns (bool)
498   {
499     return super.transfer(to, value);
500   }
501 
502   function transferFrom(
503     address from,
504     address to,
505     uint256 value
506   )
507     public
508     whenNotPaused
509     returns (bool)
510   {
511     return super.transferFrom(from, to, value);
512   }
513 
514   function approve(
515     address spender,
516     uint256 value
517   )
518     public
519     whenNotPaused
520     returns (bool)
521   {
522     return super.approve(spender, value);
523   }
524 
525   function increaseAllowance(
526     address spender,
527     uint addedValue
528   )
529     public
530     whenNotPaused
531     returns (bool success)
532   {
533     return super.increaseAllowance(spender, addedValue);
534   }
535 
536   function decreaseAllowance(
537     address spender,
538     uint subtractedValue
539   )
540     public
541     whenNotPaused
542     returns (bool success)
543   {
544     return super.decreaseAllowance(spender, subtractedValue);
545   }
546 }
547 
548 contract Jurasaur is ERC20Burnable, ERC20Mintable, ERC20Pausable {
549   string public name = "Jurasaur";
550   string public symbol = "JREX";
551   uint public decimals = 8;
552   uint256 public initialSupply = 10 * (10 ** 9);
553 
554   constructor() public {
555     mint(msg.sender, initialSupply * (10 ** uint256(decimals)));
556   }
557 }