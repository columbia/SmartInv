1 pragma solidity ^ 0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender)
23     public view returns (uint256);
24 
25   function transferFrom(address from, address to, uint256 value)
26     public returns (bool);
27 
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipRenounced(address indexed previousOwner);
46   event OwnershipTransferred(
47     address indexed previousOwner,
48     address indexed newOwner
49   );
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to relinquish control of the contract.
70    * @notice Renouncing to ownership will leave the contract without an owner.
71    * It will not be possible to call the functions with the `onlyOwner`
72    * modifier anymore.
73    */
74   function renounceOwnership() public onlyOwner {
75     emit OwnershipRenounced(owner);
76     owner = address(0);
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address _newOwner) public onlyOwner {
84     _transferOwnership(_newOwner);
85   }
86 
87   /**
88    * @dev Transfers control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function _transferOwnership(address _newOwner) internal {
92     require(_newOwner != address(0));
93     emit OwnershipTransferred(owner, _newOwner);
94     owner = _newOwner;
95   }
96 }
97 
98 /**
99  * @title Pausable
100  * @dev Base contract which allows children to implement an emergency stop mechanism.
101  */
102 contract Pausable is Ownable {
103   event Pause();
104   event Unpause();
105 
106   bool public paused = false;
107 
108 
109   /**
110    * @dev Modifier to make a function callable only when the contract is not paused.
111    */
112   modifier whenNotPaused() {
113     require(!paused);
114     _;
115   }
116 
117   /**
118    * @dev Modifier to make a function callable only when the contract is paused.
119    */
120   modifier whenPaused() {
121     require(paused);
122     _;
123   }
124 
125   /**
126    * @dev called by the owner to pause, triggers stopped state
127    */
128   function pause() onlyOwner whenNotPaused public {
129     paused = true;
130     emit Pause();
131   }
132 
133   /**
134    * @dev called by the owner to unpause, returns to normal state
135    */
136   function unpause() onlyOwner whenPaused public {
137     paused = false;
138     emit Unpause();
139   }
140 }
141 
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   uint256 totalSupply_;
153 
154   /**
155   * @dev Total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * https://github.com/ethereum/EIPs/issues/20
193  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(
207     address _from,
208     address _to,
209     uint256 _value
210   )
211     public
212     returns (bool)
213   {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     emit Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(
267     address _spender,
268     uint256 _addedValue
269   )
270     public
271     returns (bool)
272   {
273     allowed[msg.sender][_spender] = (
274       allowed[msg.sender][_spender].add(_addedValue));
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Decrease the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed[_spender] == 0. To decrement
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _subtractedValue The amount of tokens to decrease the allowance by.
287    */
288   function decreaseApproval(
289     address _spender,
290     uint256 _subtractedValue
291   )
292     public
293     returns (bool)
294   {
295     uint256 oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 /**
307  * @title Pausable token
308  * @dev StandardToken modified with pausable transfers.
309  **/
310 contract PausableToken is StandardToken, Pausable {
311 
312   function transfer(
313     address _to,
314     uint256 _value
315   )
316     public
317     whenNotPaused
318     returns (bool)
319   {
320     return super.transfer(_to, _value);
321   }
322 
323   function transferFrom(
324     address _from,
325     address _to,
326     uint256 _value
327   )
328     public
329     whenNotPaused
330     returns (bool)
331   {
332     return super.transferFrom(_from, _to, _value);
333   }
334 
335   function approve(
336     address _spender,
337     uint256 _value
338   )
339     public
340     whenNotPaused
341     returns (bool)
342   {
343     return super.approve(_spender, _value);
344   }
345 
346   function increaseApproval(
347     address _spender,
348     uint _addedValue
349   )
350     public
351     whenNotPaused
352     returns (bool success)
353   {
354     return super.increaseApproval(_spender, _addedValue);
355   }
356 
357   function decreaseApproval(
358     address _spender,
359     uint _subtractedValue
360   )
361     public
362     whenNotPaused
363     returns (bool success)
364   {
365     return super.decreaseApproval(_spender, _subtractedValue);
366   }
367 }
368 
369 /**
370  * @title SafeMath
371  * @dev Math operations with safety checks that throw on error
372  */
373 library SafeMath {
374 
375   /**
376   * @dev Multiplies two numbers, throws on overflow.
377   */
378   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
379     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
380     // benefit is lost if 'b' is also tested.
381     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
382     if (a == 0) {
383       return 0;
384     }
385 
386     c = a * b;
387     assert(c / a == b);
388     return c;
389   }
390 
391   /**
392   * @dev Integer division of two numbers, truncating the quotient.
393   */
394   function div(uint256 a, uint256 b) internal pure returns (uint256) {
395     // assert(b > 0); // Solidity automatically throws when dividing by 0
396     // uint256 c = a / b;
397     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
398     return a / b;
399   }
400 
401   /**
402   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
403   */
404   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
405     assert(b <= a);
406     return a - b;
407   }
408 
409   /**
410   * @dev Adds two numbers, throws on overflow.
411   */
412   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
413     c = a + b;
414     assert(c >= a);
415     return c;
416   }
417 }
418 
419 
420 /**
421  * @title Burnable Token
422  * @dev Token that can be irreversibly burned (destroyed).
423  */
424 contract BurnableToken is BasicToken {
425 
426   event Burn(address indexed burner, uint256 value);
427 
428   /**
429    * @dev Burns a specific amount of tokens.
430    * @param _value The amount of token to be burned.
431    */
432   function burn(uint256 _value) public {
433     _burn(msg.sender, _value);
434   }
435 
436   function _burn(address _who, uint256 _value) internal {
437     require(_value <= balances[_who]);
438     // no need to require value <= totalSupply, since that would imply the
439     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
440 
441     balances[_who] = balances[_who].sub(_value);
442     totalSupply_ = totalSupply_.sub(_value);
443     emit Burn(_who, _value);
444     emit Transfer(_who, address(0), _value);
445   }
446 }
447 
448 contract USDBToken is PausableToken,BurnableToken {
449     string public name;
450     string public symbol;
451     uint8 public decimals;
452 
453     constructor(uint _initialSupply, string _tokenname, string _tokensymbol, uint8 _tokendecimals) public {
454         totalSupply_ = _initialSupply;
455         name = _tokenname;
456         symbol = _tokensymbol;
457         decimals = _tokendecimals;
458         balances[msg.sender] = totalSupply_;
459     }
460 
461     function changeTokenName(string _tokenname, string _tokensymbol) public onlyOwner
462     {
463         name = _tokenname;
464         symbol = _tokensymbol;
465     }
466     
467     modifier onlyPayloadSize(uint size) {
468         require(!(msg.data.length < size + 4));
469         _;
470     }
471 
472     address public manager = address(0);
473 
474 
475     function changeManager(address newManager) public onlyOwner {
476         manager = newManager;
477     }
478 
479 
480     modifier onlyOwnerOrManager() {
481         require((msg.sender == owner) || (msg.sender == manager));
482         _;
483     }
484 
485 
486     event Issue(address indexed _to, uint256 value);
487  
488 
489     event Profit(uint256 value);
490 
491     function issue(uint256 amount) public onlyOwnerOrManager {
492         require(totalSupply_ + amount > totalSupply_);
493         require(balances[owner] + amount > balances[owner]);
494 
495         balances[owner] = balances[owner].add(amount);
496         totalSupply_ = totalSupply_.add(amount);
497         emit Issue(owner, amount);  
498         emit Transfer(owner, address(0), amount);
499     }
500  
501 
502     
503     function profit(uint256 amount) public onlyOwnerOrManager{
504         require(amount <= balances[owner]);
505         emit Profit(amount);
506     }
507 
508     function easyCommit(uint256 _issue, uint256 _redeem, uint256 _profit) public returns(bool)
509     {
510         issue(_issue);
511         burn(_redeem);
512         profit(_profit);
513         return true;
514     }
515 
516 
517     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool)
518     {
519         require(!isBlackListed[msg.sender]);
520         return super.transfer(_to, _value);
521     }
522 
523     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns(bool)
524     {
525         require(!isBlackListed[_from]);
526         return super.transferFrom(_from, _to, _value);
527     }
528 
529     function getBlackListStatus(address _maker) public view returns(bool) {
530         return isBlackListed[_maker];
531     }
532 
533     mapping(address => bool) public isBlackListed;
534 
535     function addBlackList(address _evilUser) public onlyOwner {
536         isBlackListed[_evilUser] = true;
537         emit AddedBlackList(_evilUser);
538     }
539 
540     function removeBlackList(address _clearedUser) public onlyOwner {
541         isBlackListed[_clearedUser] = false;
542         emit RemovedBlackList(_clearedUser);
543     }
544 
545     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
546         require(isBlackListed[_blackListedUser]);
547         uint dirtyFunds = balanceOf(_blackListedUser);
548         balances[_blackListedUser] = 0;
549         totalSupply_ = totalSupply_.sub(dirtyFunds);
550         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
551     }
552 
553     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
554 
555     event AddedBlackList(address _user);
556 
557     event RemovedBlackList(address _user);
558 }