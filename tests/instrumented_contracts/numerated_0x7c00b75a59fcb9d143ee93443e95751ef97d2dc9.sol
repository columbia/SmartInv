1 pragma solidity ^0.4.23;
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
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
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
113 /**
114  * @title Pausable
115  * @dev Base contract which allows children to implement an emergency stop mechanism.
116  */
117 contract Pausable is Ownable {
118   event Pause();
119   event Unpause();
120 
121   bool public paused = false;
122 
123 
124   /**
125    * @dev Modifier to make a function callable only when the contract is not paused.
126    */
127   modifier whenNotPaused() {
128     require(!paused);
129     _;
130   }
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is paused.
134    */
135   modifier whenPaused() {
136     require(paused);
137     _;
138   }
139 
140   /**
141    * @dev called by the owner to pause, triggers stopped state
142    */
143   function pause() onlyOwner whenNotPaused public {
144     paused = true;
145     emit Pause();
146   }
147 
148   /**
149    * @dev called by the owner to unpauseunpause, returns to normal state
150    */
151   function unpause() onlyOwner whenPaused public {
152     paused = false;
153     emit Unpause();
154   }
155 }
156 
157 /**
158  * @title ERC20Basic
159  * @dev Simpler version of ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/179
161  */
162 contract ERC20Basic {
163   function totalSupply() public view returns (uint256);
164   function balanceOf(address who) public view returns (uint256);
165   function transfer(address to, uint256 value) public returns (bool);
166   event Transfer(address indexed from, address indexed to, uint256 value);
167 }
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender)
175     public view returns (uint256);
176 
177   function transferFrom(address from, address to, uint256 value)
178     public returns (bool);
179 
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(
182     address indexed owner,
183     address indexed spender,
184     uint256 value
185   );
186 }
187 
188 /**
189  * @title Basic token
190  * @dev Basic version of StandardToken, with no allowances.
191  */
192 contract BasicToken is ERC20Basic {
193   using SafeMath for uint256;
194 
195   mapping(address => uint256) balances;
196 
197   uint256 totalSupply_;
198 
199   /**
200   * @dev total number of tokens in existence
201   */
202   function totalSupply() public view returns (uint256) {
203     return totalSupply_;
204   }
205 
206   /**
207   * @dev transfer token for a specified address
208   * @param _to The address to transfer to.
209   * @param _value The amount to be transferred.
210   */
211   function transfer(address _to, uint256 _value) public returns (bool) {
212     require(_to != address(0));
213     require(_value <= balances[msg.sender]);
214 
215     balances[msg.sender] = balances[msg.sender].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     emit Transfer(msg.sender, _to, _value);
218     return true;
219   }
220 
221   /**
222   * @dev Gets the balance of the specified address.
223   * @param _owner The address to query the the balance of.
224   * @return An uint256 representing the amount owned by the passed address.
225   */
226   function balanceOf(address _owner) public view returns (uint256) {
227     return balances[_owner];
228   }
229 
230 }
231 
232 
233 /**
234  * @title Standard ERC20 token
235  *
236  * @dev Implementation of the basic standard token.
237  * @dev https://github.com/ethereum/EIPs/issues/20
238  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
239  */
240 contract StandardToken is ERC20, BasicToken {
241 
242   mapping (address => mapping (address => uint256)) internal allowed;
243 
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(
252     address _from,
253     address _to,
254     uint256 _value
255   )
256     public
257     returns (bool)
258   {
259     require(_to != address(0));
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     emit Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(
293     address _owner,
294     address _spender
295    )
296     public
297     view
298     returns (uint256)
299   {
300     return allowed[_owner][_spender];
301   }
302 
303   /**
304    * @dev Increase the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To increment
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _addedValue The amount of tokens to increase the allowance by.
312    */
313   function increaseApproval(
314     address _spender,
315     uint _addedValue
316   )
317     public
318     returns (bool)
319   {
320     allowed[msg.sender][_spender] = (
321       allowed[msg.sender][_spender].add(_addedValue));
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326   /**
327    * @dev Decrease the amount of tokens that an owner allowed to a spender.
328    *
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(
337     address _spender,
338     uint _subtractedValue
339   )
340     public
341     returns (bool)
342   {
343     uint oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 
356 /**
357  * @title Pausable token
358  * @dev StandardToken modified with pausable transfers.
359  **/
360 contract PausableToken is StandardToken, Pausable {
361 
362   function transfer(
363     address _to,
364     uint256 _value
365   )
366     public
367     whenNotPaused
368     returns (bool)
369   {
370     return super.transfer(_to, _value);
371   }
372 
373   function transferFrom(
374     address _from,
375     address _to,
376     uint256 _value
377   )
378     public
379     whenNotPaused
380     returns (bool)
381   {
382     return super.transferFrom(_from, _to, _value);
383   }
384 
385   function approve(
386     address _spender,
387     uint256 _value
388   )
389     public
390     whenNotPaused
391     returns (bool)
392   {
393     return super.approve(_spender, _value);
394   }
395 
396   function increaseApproval(
397     address _spender,
398     uint _addedValue
399   )
400     public
401     whenNotPaused
402     returns (bool success)
403   {
404     return super.increaseApproval(_spender, _addedValue);
405   }
406 
407   function decreaseApproval(
408     address _spender,
409     uint _subtractedValue
410   )
411     public
412     whenNotPaused
413     returns (bool success)
414   {
415     return super.decreaseApproval(_spender, _subtractedValue);
416   }
417 }
418 
419 /**
420  * @title Mintable token
421  * @dev Simple ERC20 Token example, with mintable token creation
422  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
423  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
424  */
425 contract MintableToken is StandardToken, Ownable {
426   event Mint(address indexed to, uint256 amount);
427   event MintFinished();
428 
429   bool public mintingFinished = false;
430 
431 
432   modifier canMint() {
433     require(!mintingFinished);
434     _;
435   }
436 
437   modifier hasMintPermission() {
438     require(msg.sender == owner);
439     _;
440   }
441 
442   /**
443    * @dev Function to mint tokens
444    * @param _to The address that will receive the minted tokens.
445    * @param _amount The amount of tokens to mint.
446    * @return A boolean that indicates if the operation was successful.
447    */
448   function mint(
449     address _to,
450     uint256 _amount
451   )
452     hasMintPermission
453     canMint
454     public
455     returns (bool)
456   {
457     totalSupply_ = totalSupply_.add(_amount);
458     balances[_to] = balances[_to].add(_amount);
459     emit Mint(_to, _amount);
460     emit Transfer(address(0), _to, _amount);
461     return true;
462   }
463 
464   /**
465    * @dev Function to stop minting new tokens.
466    * @return True if the operation was successful.
467    */
468   function finishMinting() onlyOwner canMint public returns (bool) {
469     mintingFinished = true;
470     emit MintFinished();
471     return true;
472   }
473 }
474 
475 
476 /**
477  * @title Burnable Token
478  * @dev Token that can be irreversibly burned (destroyed).
479  */
480 contract BurnableToken is BasicToken {
481 
482   event Burn(address indexed burner, uint256 value);
483 
484   /**
485    * @dev Burns a specific amount of tokens.
486    * @param _value The amount of token to be burned.
487    */
488   function burn(uint256 _value) public 
489   {
490     _burn(msg.sender, _value);
491   }
492 
493   function _burn(address _who, uint256 _value) internal 
494   {
495     require(_value <= balances[_who]);
496     // no need to require value <= totalSupply, since that would imply the
497     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
498 
499     balances[_who] = balances[_who].sub(_value);
500     totalSupply_ = totalSupply_.sub(_value);
501     emit Burn(_who, _value);
502     emit Transfer(_who, address(0), _value);
503   }
504 }
505 
506 
507 /**
508  * @title VnbigToken Token
509  * @dev Global digital painting asset platform token.
510  */
511 contract VnbigToken is PausableToken, MintableToken, BurnableToken {
512     using SafeMath for uint256;
513 
514     string public name = "VNBIG Token";
515     string public symbol = "VNBT";
516     uint256 public decimals = 18;
517     uint256 INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
518 
519     event UpdatedTokenInformation(string name, string symbol);
520 
521     mapping (address => bool) public frozenAccount;
522     event FrozenFunds(address indexed to, bool frozen);
523 
524     constructor() public {
525         totalSupply_ = INITIAL_SUPPLY;
526         balances[msg.sender] = totalSupply_;
527         emit Transfer(address(0), msg.sender, totalSupply_);
528     }
529 
530     function() public payable {
531       revert(); //if ether is sent to this address, send it back.
532     }  
533 
534     function transfer(address _to, uint256 _value) public returns (bool)
535     {
536         require(!frozenAccount[msg.sender]);
537         return super.transfer(_to, _value);
538     }
539 
540 
541     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
542     {
543         require(!frozenAccount[msg.sender]);
544         return super.transferFrom(_from, _to, _value);
545     }
546 
547     function freezeAccount(address _to, bool freeze) public onlyOwner {
548         frozenAccount[_to] = freeze;
549         emit FrozenFunds(_to, freeze);
550     }     
551     
552     /**
553      * @dev Update the symbol.
554      * @param _tokenSymbol The symbol name.
555      */
556     function setTokenInformation(string _tokenName, string _tokenSymbol) public onlyOwner {
557         name = _tokenName;
558         symbol = _tokenSymbol;
559         emit UpdatedTokenInformation(name, symbol);
560     } 
561 
562 }