1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20 {
12   function totalSupply() public view returns (uint256);
13 
14   function balanceOf(address _who) public view returns (uint256);
15 
16   function allowance(address _owner, address _spender)
17     public view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) public returns (bool);
20 
21   function approve(address _spender, uint256 _value)
22     public returns (bool);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     public returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that revert on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, reverts on overflow.
50   */
51   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (_a == 0) {
56       return 0;
57     }
58 
59     uint256 c = _a * _b;
60     require(c / _a == _b);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
67   */
68   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
69     require(_b > 0); // Solidity only automatically asserts when dividing by 0
70     uint256 c = _a / _b;
71     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
72 
73     return c;
74   }
75 
76   /**
77   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
80     require(_b <= _a);
81     uint256 c = _a - _b;
82 
83     return c;
84   }
85 
86   /**
87   * @dev Adds two numbers, reverts on overflow.
88   */
89   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
90     uint256 c = _a + _b;
91     require(c >= _a);
92 
93     return c;
94   }
95 
96   /**
97   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
98   * reverts when dividing by zero.
99   */
100   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b != 0);
102     return a % b;
103   }
104 }
105 
106 
107 
108 
109 /**
110  * @title Ownable
111  * @dev The Ownable contract has an owner address, and provides basic authorization control
112  * functions, this simplifies the implementation of "user permissions".
113  */
114 contract Ownable {
115   address public owner;
116 
117 
118   event OwnershipRenounced(address indexed previousOwner);
119   event OwnershipTransferred(
120     address indexed previousOwner,
121     address indexed newOwner
122   );
123 
124 
125   /**
126    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
127    * account.
128    */
129   constructor() public {
130     owner = msg.sender;
131   }
132 
133   /**
134    * @dev Throws if called by any account other than the owner.
135    */
136   modifier onlyOwner() {
137     require(msg.sender == owner);
138     _;
139   }
140 
141   /**
142    * @dev Allows the current owner to relinquish control of the contract.
143    * @notice Renouncing to ownership will leave the contract without an owner.
144    * It will not be possible to call the functions with the `onlyOwner`
145    * modifier anymore.
146    */
147   function renounceOwnership() public onlyOwner {
148     emit OwnershipRenounced(owner);
149     owner = address(0);
150   }
151 
152   /**
153    * @dev Allows the current owner to transfer control of the contract to a newOwner.
154    * @param _newOwner The address to transfer ownership to.
155    */
156   function transferOwnership(address _newOwner) public onlyOwner {
157     _transferOwnership(_newOwner);
158   }
159 
160   /**
161    * @dev Transfers control of the contract to a newOwner.
162    * @param _newOwner The address to transfer ownership to.
163    */
164   function _transferOwnership(address _newOwner) internal {
165     require(_newOwner != address(0));
166     emit OwnershipTransferred(owner, _newOwner);
167     owner = _newOwner;
168   }
169 }
170 
171 
172 contract Pausable is Ownable {
173 
174     event Paused();
175     event Unpaused();
176 
177     bool public paused = false;
178 
179 
180     /**
181      * @dev Modifier to make a function callable only when the contract is not paused.
182      */
183     modifier whenNotPaused() {
184         require(!paused);
185         _;
186     }
187 
188     /**
189      * @dev Modifier to make a function callable only when the contract is paused.
190      */
191     modifier whenPaused() {
192         require(paused);
193         _;
194     }
195 
196     /**
197      * @dev called by the owner to pause, triggers stopped state
198      */
199     function pause() public onlyOwner whenNotPaused {
200         paused = true;
201         emit Paused();
202     }
203 
204     /**
205      * @dev called by the owner to unpause, returns to normal state
206      */
207     function unpause() public onlyOwner whenPaused {
208         paused = false;
209         emit Unpaused();
210     }
211 
212 }
213 
214 
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
221  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, Pausable {
224     using SafeMath for uint256;
225 
226     mapping(address => uint256) private balances_;
227 
228     mapping(address => mapping(address => uint256)) private allowed_;
229 
230     uint256 private totalSupply_;
231 
232     /**
233     * @dev Total number of tokens in existence
234     */
235     function totalSupply() public view returns (uint256) {
236         return totalSupply_;
237     }
238 
239     /**
240     * @dev Gets the balance of the specified address.
241     * @param _owner The address to query the the balance of.
242     * @return An uint256 representing the amount owned by the passed address.
243     */
244     function balanceOf(address _owner) public view returns (uint256) {
245         return balances_[_owner];
246     }
247 
248     /**
249      * @dev Function to check the amount of tokens that an owner allowed to a spender.
250      * @param _owner address The address which owns the funds.
251      * @param _spender address The address which will spend the funds.
252      * @return A uint256 specifying the amount of tokens still available for the spender.
253      */
254     function allowance(
255         address _owner,
256         address _spender
257     )
258     public
259     view
260     returns (uint256)
261     {
262         return allowed_[_owner][_spender];
263     }
264 
265     /**
266     * @dev Transfer token for a specified address
267     * @param _to The address to transfer to.
268     * @param _value The amount to be transferred.
269     */
270     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
271         require(_value <= balances_[msg.sender]);
272         require(_to != address(0));
273 
274         balances_[msg.sender] = balances_[msg.sender].sub(_value);
275         balances_[_to] = balances_[_to].add(_value);
276         emit Transfer(msg.sender, _to, _value);
277         return true;
278     }
279 
280     /**
281      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282      * Beware that changing an allowance with this method brings the risk that someone may use both the old
283      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
284      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
285      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286      * @param _spender The address which will spend the funds.
287      * @param _value The amount of tokens to be spent.
288      */
289     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
290         allowed_[msg.sender][_spender] = _value;
291         emit Approval(msg.sender, _spender, _value);
292         return true;
293     }
294 
295     /**
296      * @dev Transfer tokens from one address to another
297      * @param _from address The address which you want to send tokens from
298      * @param _to address The address which you want to transfer to
299      * @param _value uint256 the amount of tokens to be transferred
300      */
301     function transferFrom(
302         address _from,
303         address _to,
304         uint256 _value
305     )
306     public
307     whenNotPaused
308     returns (bool)
309     {
310         require(_value <= balances_[_from]);
311         require(_value <= allowed_[_from][msg.sender]);
312         require(_to != address(0));
313 
314         balances_[_from] = balances_[_from].sub(_value);
315         balances_[_to] = balances_[_to].add(_value);
316         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
317         emit Transfer(_from, _to, _value);
318         return true;
319     }
320 
321     /**
322      * @dev Increase the amount of tokens that an owner allowed to a spender.
323      * approve should be called when allowed_[_spender] == 0. To increment
324      * allowed value is better to use this function to avoid 2 calls (and wait until
325      * the first transaction is mined)
326      * From MonolithDAO Token.sol
327      * @param _spender The address which will spend the funds.
328      * @param _addedValue The amount of tokens to increase the allowance by.
329      */
330     function increaseApproval(
331         address _spender,
332         uint256 _addedValue
333     )
334     public
335     whenNotPaused
336     returns (bool)
337     {
338         allowed_[msg.sender][_spender] = (
339         allowed_[msg.sender][_spender].add(_addedValue));
340         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
341         return true;
342     }
343 
344     /**
345      * @dev Decrease the amount of tokens that an owner allowed to a spender.
346      * approve should be called when allowed_[_spender] == 0. To decrement
347      * allowed value is better to use this function to avoid 2 calls (and wait until
348      * the first transaction is mined)
349      * From MonolithDAO Token.sol
350      * @param _spender The address which will spend the funds.
351      * @param _subtractedValue The amount of tokens to decrease the allowance by.
352      */
353     function decreaseApproval(
354         address _spender,
355         uint256 _subtractedValue
356     )
357     public
358     whenNotPaused
359     returns (bool)
360     {
361         uint256 oldValue = allowed_[msg.sender][_spender];
362         if (_subtractedValue >= oldValue) {
363             allowed_[msg.sender][_spender] = 0;
364         } else {
365             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
366         }
367         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
368         return true;
369     }
370 
371     /**
372      * @dev Internal function that mints an amount of the token and assigns it to
373      * an account. This encapsulates the modification of balances such that the
374      * proper events are emitted.
375      * @param _account The account that will receive the created tokens.
376      * @param _amount The amount that will be created.
377      */
378     function _mint(address _account, uint256 _amount) internal {
379         require(_account != 0);
380         totalSupply_ = totalSupply_.add(_amount);
381         balances_[_account] = balances_[_account].add(_amount);
382         emit Transfer(address(0), _account, _amount);
383     }
384 
385     /**
386      * @dev Internal function that burns an amount of the token of a given
387      * account.
388      * @param _account The account whose tokens will be burnt.
389      * @param _amount The amount that will be burnt.
390      */
391     function _burn(address _account, uint256 _amount) internal {
392         require(_account != 0);
393         require(_amount <= balances_[_account]);
394 
395         totalSupply_ = totalSupply_.sub(_amount);
396         balances_[_account] = balances_[_account].sub(_amount);
397         emit Transfer(_account, address(0), _amount);
398     }
399 
400     /**
401      * @dev Internal function that burns an amount of the token of a given
402      * account, deducting from the sender's allowance for said account. Uses the
403      * internal _burn function.
404      * @param _account The account whose tokens will be burnt.
405      * @param _amount The amount that will be burnt.
406      */
407     function _burnFrom(address _account, uint256 _amount) internal {
408         require(_amount <= allowed_[_account][msg.sender]);
409 
410         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
411         // this function needs to emit an event with the updated approval.
412         allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
413             _amount);
414         _burn(_account, _amount);
415     }
416 }
417 
418 
419 
420 /**
421  * @title Mintable token
422  * @dev Simple ERC20 Token example, with mintable token creation
423  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
424  */
425 contract MintableToken is StandardToken {
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
437   /**
438    * @dev Function to mint tokens
439    * @param _to The address that will receive the minted tokens.
440    * @param _amount The amount of tokens to mint.
441    * @return A boolean that indicates if the operation was successful.
442    */
443   function mint(
444     address _to,
445     uint256 _amount
446   )
447     public
448     canMint
449     returns (bool)
450   {
451     _mint(_to, _amount);
452     emit Mint(_to, _amount);
453     return true;
454   }
455 
456   /**
457    * @dev Function to stop minting new tokens.
458    * @return True if the operation was successful.
459    */
460   function finishMinting() public onlyOwner canMint returns (bool) {
461     mintingFinished = true;
462     emit MintFinished();
463     return true;
464   }
465 }
466 
467 
468 
469 /**
470  * @title Burnable Token
471  * @dev Token that can be irreversibly burned (destroyed).
472  */
473 contract BurnableToken is MintableToken {
474 
475   event TokensBurned(address indexed burner, uint256 value);
476 
477   /**
478    * @dev Burns a specific amount of tokens.
479    * @param _value The amount of token to be burned.
480    */
481   function burn(uint256 _value) public {
482     _burn(msg.sender, _value);
483   }
484 
485   /**
486    * @dev Burns a specific amount of tokens from the target address and decrements allowance
487    * @param _from address The address which you want to send tokens from
488    * @param _value uint256 The amount of token to be burned
489    */
490   function burnFrom(address _from, uint256 _value) public {
491     _burnFrom(_from, _value);
492   }
493 
494   /**
495    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
496    * an additional Burn event.
497    */
498   function _burn(address _who, uint256 _value) internal {
499     super._burn(_who, _value);
500     emit TokensBurned(_who, _value);
501   }
502 }
503 
504 
505 /**
506  * @title BUYToken
507  */
508 contract BuyToken is BurnableToken {
509     string public constant name = "BUY";
510     string public constant symbol = "BUY";
511     uint8 public constant decimals = 18;
512 
513     constructor(address _initialAccount, uint256 _initialSupply)
514     public
515     {
516         mint(_initialAccount, _initialSupply);
517     }
518 
519     /**
520     * @dev Allows the owner to take out wrongly sent tokens to this contract by mistake.
521     * @param _token The contract address of the token that is getting pulled out.
522     * @param _amount The amount to pull out.
523     */
524     function pullOut(ERC20 _token, uint256 _amount) external onlyOwner {
525         _token.transfer(owner, _amount);
526     }
527 
528     /**
529     * @dev 'tokenFallback' function in accordance to the ERC223 standard. Rejects all incoming ERC223 token transfers.
530     */
531 
532     function tokenFallback(
533         address _from,
534         uint256 _value,
535         bytes _data
536     )
537     external
538     pure
539     {
540         _from;
541         _value;
542         _data;
543         revert();
544     }
545 
546     function() external payable {
547         revert("This contract does not accept Ethereum!");
548     }
549 
550 }