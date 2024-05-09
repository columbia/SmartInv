1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 
113 
114 /**
115  * @title ERC20Basic
116  * @dev Simpler version of ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/179
118  */
119 contract ERC20Basic {
120   function totalSupply() public view returns (uint256);
121   function balanceOf(address who) public view returns (uint256);
122   function transfer(address to, uint256 value) public returns (bool);
123   event Transfer(address indexed from, address indexed to, uint256 value);
124 }
125 
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender)
133     public view returns (uint256);
134 
135   function transferFrom(address from, address to, uint256 value)
136     public returns (bool);
137 
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 }
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   uint256 totalSupply_;
156 
157   /**
158   * @dev total number of tokens in existence
159   */
160   function totalSupply() public view returns (uint256) {
161     return totalSupply_;
162   }
163 
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/ethereum/EIPs/issues/20
196  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(
210     address _from,
211     address _to,
212     uint256 _value
213   )
214     public
215     returns (bool)
216   {
217     require(_to != address(0));
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    *
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address _owner,
252     address _spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(
272     address _spender,
273     uint _addedValue
274   )
275     public
276     returns (bool)
277   {
278     allowed[msg.sender][_spender] = (
279       allowed[msg.sender][_spender].add(_addedValue));
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseApproval(
295     address _spender,
296     uint _subtractedValue
297   )
298     public
299     returns (bool)
300   {
301     uint oldValue = allowed[msg.sender][_spender];
302     if (_subtractedValue > oldValue) {
303       allowed[msg.sender][_spender] = 0;
304     } else {
305       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306     }
307     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311 }
312 
313 /**
314  * @title Contactable token
315  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
316  * contact information.
317  */
318 contract Contactable is Ownable {
319 
320   string public contactInformation;
321 
322   /**
323     * @dev Allows the owner to set a string with their contact information.
324     * @param info The contact information to attach to the contract.
325     */
326   function setContactInformation(string info) onlyOwner public {
327     contactInformation = info;
328   }
329 }
330 
331 
332 /**
333  * @title Mintable token
334  * @dev Simple ERC20 Token example, with mintable token creation
335  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
336  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
337  */
338 contract MintableToken is StandardToken, Ownable {
339   event Mint(address indexed to, uint256 amount);
340   event MintFinished();
341 
342   bool public mintingFinished = false;
343 
344 
345   modifier canMint() {
346     require(!mintingFinished);
347     _;
348   }
349 
350   modifier hasMintPermission() {
351     require(msg.sender == owner);
352     _;
353   }
354 
355   /**
356    * @dev Function to mint tokens
357    * @param _to The address that will receive the minted tokens.
358    * @param _amount The amount of tokens to mint.
359    * @return A boolean that indicates if the operation was successful.
360    */
361   function mint(
362     address _to,
363     uint256 _amount
364   )
365     hasMintPermission
366     canMint
367     public
368     returns (bool)
369   {
370     totalSupply_ = totalSupply_.add(_amount);
371     balances[_to] = balances[_to].add(_amount);
372     emit Mint(_to, _amount);
373     emit Transfer(address(0), _to, _amount);
374     return true;
375   }
376 
377   /**
378    * @dev Function to stop minting new tokens.
379    * @return True if the operation was successful.
380    */
381   function finishMinting() onlyOwner canMint public returns (bool) {
382     mintingFinished = true;
383     emit MintFinished();
384     return true;
385   }
386 }
387 
388 
389 /**
390  * @title Capped token
391  * @dev Mintable token with a token cap.
392  */
393 contract CappedToken is MintableToken {
394 
395   uint256 public cap;
396 
397   constructor(uint256 _cap) public {
398     require(_cap > 0);
399     cap = _cap;
400   }
401 
402   /**
403    * @dev Function to mint tokens
404    * @param _to The address that will receive the minted tokens.
405    * @param _amount The amount of tokens to mint.
406    * @return A boolean that indicates if the operation was successful.
407    */
408   function mint(
409     address _to,
410     uint256 _amount
411   )
412     onlyOwner
413     canMint
414     public
415     returns (bool)
416   {
417     require(totalSupply_.add(_amount) <= cap);
418 
419     return super.mint(_to, _amount);
420   }
421 
422 }
423 
424 
425 
426 
427 
428 
429 /**
430  * @title Pausable
431  * @dev Base contract which allows children to implement an emergency stop mechanism.
432  */
433 contract Pausable is Ownable {
434   event Pause();
435   event Unpause();
436 
437   bool public paused = false;
438 
439 
440   /**
441    * @dev Modifier to make a function callable only when the contract is not paused.
442    */
443   modifier whenNotPaused() {
444     require(!paused);
445     _;
446   }
447 
448   /**
449    * @dev Modifier to make a function callable only when the contract is paused.
450    */
451   modifier whenPaused() {
452     require(paused);
453     _;
454   }
455 
456   /**
457    * @dev called by the owner to pause, triggers stopped state
458    */
459   function pause() onlyOwner whenNotPaused public {
460     paused = true;
461     emit Pause();
462   }
463 
464   /**
465    * @dev called by the owner to unpause, returns to normal state
466    */
467   function unpause() onlyOwner whenPaused public {
468     paused = false;
469     emit Unpause();
470   }
471 }
472 
473 
474 /**
475  * @title Pausable token
476  * @dev StandardToken modified with pausable transfers.
477  **/
478 contract PausableToken is StandardToken, Pausable {
479 
480   function transfer(
481     address _to,
482     uint256 _value
483   )
484     public
485     whenNotPaused
486     returns (bool)
487   {
488     return super.transfer(_to, _value);
489   }
490 
491   function transferFrom(
492     address _from,
493     address _to,
494     uint256 _value
495   )
496     public
497     whenNotPaused
498     returns (bool)
499   {
500     return super.transferFrom(_from, _to, _value);
501   }
502 
503   function approve(
504     address _spender,
505     uint256 _value
506   )
507     public
508     whenNotPaused
509     returns (bool)
510   {
511     return super.approve(_spender, _value);
512   }
513 
514   function increaseApproval(
515     address _spender,
516     uint _addedValue
517   )
518     public
519     whenNotPaused
520     returns (bool success)
521   {
522     return super.increaseApproval(_spender, _addedValue);
523   }
524 
525   function decreaseApproval(
526     address _spender,
527     uint _subtractedValue
528   )
529     public
530     whenNotPaused
531     returns (bool success)
532   {
533     return super.decreaseApproval(_spender, _subtractedValue);
534   }
535 }
536 
537 contract FrameworkToken is CappedToken, PausableToken, Contactable {
538   string public name = "Framework";
539   string public symbol = "FRWK";
540   uint8 public decimals = 18;
541   uint256 public cappedTokenSupply = 100000000 * (10 ** uint256(decimals)); // There will be total 100 million FRWK Tokens
542   mapping(address => bool) public owners;
543 
544   function FrameworkToken() CappedToken(cappedTokenSupply) public {
545   
546   }
547    
548    modifier onlyOwner() {
549     require(isAnOwner(msg.sender));
550     _;
551   }
552 
553   function addNewOwner(address _owner) public onlyOwner{
554     require(_owner != address(0));
555     owners[_owner]= true;
556   }
557 
558   function removeOwner(address _owner) public onlyOwner{
559     require(_owner != address(0));
560     require(_owner != msg.sender);
561     owners[_owner]= false;
562   }
563 
564   function isAnOwner(address _owner) public constant returns(bool) {
565      if (_owner == owner){
566        return true;
567      }
568 
569      return owners[_owner];
570   }
571   modifier hasMintPermission() {
572     require(isAnOwner(msg.sender));
573     _;
574   }
575 
576 }