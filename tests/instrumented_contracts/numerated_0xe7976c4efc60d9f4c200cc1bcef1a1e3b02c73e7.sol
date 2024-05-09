1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 
49     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
50         return a >= b ? a : b;
51     }
52 
53     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
54         return a < b ? a : b;
55     }
56 
57     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a >= b ? a : b;
59     }
60 
61     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a < b ? a : b;
63     }
64 }
65 
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73     function totalSupply() public view returns (uint256);
74     function balanceOf(address who) public view returns (uint256);
75     function transfer(address to, uint256 value) public returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85     using SafeMath for uint256;
86 
87     mapping(address => uint256) balances;
88 
89     uint256 totalSupply_;
90 
91     /**
92     * @dev total number of tokens in existence
93     */
94     function totalSupply() public view returns (uint256) {
95         return totalSupply_;
96     }
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint256 _value) public returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106 
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         emit Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param _owner The address to query the the balance of.
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address _owner) public view returns (uint256 balance) {
119         return balances[_owner];
120     }
121 }
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129     function allowance(address owner, address spender) public view returns (uint256);
130     function transferFrom(address from, address to, uint256 value) public returns (bool);
131     function approve(address spender, uint256 value) public returns (bool);
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: 
142  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146     mapping (address => mapping (address => uint256)) internal allowed;
147 
148     /**
149      * @dev Transfer tokens from one address to another
150      * @param _from address The address which you want to send tokens from
151      * @param _to address The address which you want to transfer to
152      * @param _value uint256 the amount of tokens to be transferred
153      */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155         require(_to != address(0));
156         require(_value <= balances[_from]);
157         require(_value <= allowed[_from][msg.sender]);
158 
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         emit Transfer(_from, _to, _value);
163         return true;
164     }
165 
166     /**
167      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168      *
169      * Beware that changing an allowance with this method brings the risk that someone may use both the old
170      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      * @param _spender The address which will spend the funds.
174      * @param _value The amount of tokens to be spent.
175      */
176     function approve(address _spender, uint256 _value) public returns (bool) {
177         allowed[msg.sender][_spender] = _value;
178         emit Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param _owner address The address which owns the funds.
185      * @param _spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address _owner, address _spender) public view returns (uint256) {
189         return allowed[_owner][_spender];
190     }
191 
192     /**
193      * @dev Increase the amount of tokens that an owner allowed to a spender.
194      *
195      * approve should be called when allowed[_spender] == 0. To increment
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * @param _spender The address which will spend the funds.
200      * @param _addedValue The amount of tokens to increase the allowance by.
201      */
202     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      *
211      * approve should be called when allowed[_spender] == 0. To decrement
212      * allowed value is better to use this function to avoid 2 calls (and wait until
213      * the first transaction is mined)
214      * From MonolithDAO Token.sol
215      * @param _spender The address which will spend the funds.
216      * @param _subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219         uint oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229 }
230 
231 
232 /**
233  * @title Ownable
234  * @dev The Ownable contract has an owner address, and provides basic authorization control
235  * functions, this simplifies the implementation of "user permissions".
236  */
237 contract Ownable {
238     address public owner;
239 
240     event OwnershipRenounced(address indexed previousOwner);
241     event OwnershipTransferred(
242         address indexed previousOwner,
243         address indexed newOwner
244     );
245 
246     /**
247      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
248      * account.
249      */
250     constructor() public {
251         owner = msg.sender;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(msg.sender == owner);
259         _;
260     }
261 
262     /**
263      * @dev Allows the current owner to transfer control of the contract to a newOwner.
264      * @param newOwner The address to transfer ownership to.
265      */
266     function transferOwnership(address newOwner) public onlyOwner {
267         require(newOwner != address(0));
268         emit OwnershipTransferred(owner, newOwner);
269         owner = newOwner;
270     }
271 
272     /**
273      * @dev Allows the current owner to relinquish control of the contract.
274      */
275     function renounceOwnership() public onlyOwner {
276         emit OwnershipRenounced(owner);
277         owner = address(0);
278     }
279 }
280 
281 
282 /**
283  * @title Mintable token
284  * @dev Simple ERC20 Token example, with mintable token creation
285  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
286  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
287  */
288 contract MintableToken is StandardToken, Ownable {
289     event Mint(address indexed to, uint256 amount);
290     event MintFinished();
291 
292     bool public mintingFinished = false;
293 
294     modifier canMint() {
295         require(!mintingFinished);
296         _;
297     }
298 
299     /**
300      * @dev Function to mint tokens
301      * @param _to The address that will receive the minted tokens.
302      * @param _amount The amount of tokens to mint.
303      * @return A boolean that indicates if the operation was successful.
304      */
305     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
306         totalSupply_ = totalSupply_.add(_amount);
307         balances[_to] = balances[_to].add(_amount);
308         emit Mint(_to, _amount);
309         emit Transfer(address(0), _to, _amount);
310         return true;
311     }
312 
313     /**
314      * @dev Function to stop minting new tokens.
315      * @return True if the operation was successful.
316      */
317     function finishMinting() public onlyOwner canMint returns (bool) {
318         mintingFinished = true;
319         emit MintFinished();
320         return true;
321     }
322 }
323 
324 
325 /**
326  * @title Capped token
327  * @dev Mintable token with a token cap.
328  */
329 contract CappedToken is MintableToken {
330     
331     uint256 public cap;
332 
333     constructor(uint256 _cap) public {
334         require(_cap > 0);
335         cap = _cap;
336     }
337   
338     /**
339      * @dev Function to mint tokens
340      * @param _to The address that will receive the minted tokens.
341      * @param _amount The amount of tokens to mint.
342      * @return A boolean that indicates if the operation was successful.
343      */
344     function mint(address _to, uint256 _amount) public returns (bool) {
345         require(totalSupply_.add(_amount) <= cap);
346   
347         return super.mint(_to, _amount);
348     }
349 
350 }  
351 
352 
353 /**
354  * @title Burnable Token
355  * @dev Token that can be irreversibly burned (destroyed).
356  */
357 contract BurnableToken is StandardToken {
358 
359     event Burn(address indexed burner, uint256 value);
360 
361     /**
362     * @dev Burns a specific amount of tokens.
363     * @param _value The amount of token to be burned.
364     */
365     function burn(uint256 _value) public {
366         _burn(msg.sender, _value);
367     }
368 
369     function _burn(address _who, uint256 _value) internal {
370         require(_value <= balances[_who]);
371         // no need to require value <= totalSupply, since that would imply the
372         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
373 
374         balances[_who] = balances[_who].sub(_value);
375         totalSupply_ = totalSupply_.sub(_value);
376         emit Burn(_who, _value);
377         emit Transfer(_who, address(0), _value);
378     }
379 }
380 
381 
382 /**
383  * @title Pausable
384  * @dev Base contract which allows children to implement an emergency stop mechanism.
385  */
386 contract Pausable is Ownable {
387     event Pause();
388     event Unpause();
389 
390     bool public paused = false;
391 
392     /**
393      * @dev Modifier to make a function callable only when the contract is not paused.
394      */
395     modifier whenNotPaused() {
396         require(!paused);
397         _;
398     }
399 
400     /**
401      * @dev Modifier to make a function callable only when the contract is paused.
402      */
403     modifier whenPaused() {
404         require(paused);
405         _;
406     }
407 
408     /**
409      * @dev called by the owner to pause, triggers stopped state
410      */
411     function pause() public onlyOwner whenNotPaused {
412         paused = true;
413         emit Pause();
414     }
415 
416     /**
417      * @dev called by the owner to unpause, returns to normal state
418      */
419     function unpause() public onlyOwner whenPaused {
420         paused = false;
421         emit Unpause();
422     }
423 }
424 
425 
426 /**
427  * @title Pausable token
428  * @dev StandardToken modified with pausable transfers.
429  **/
430 contract PausableToken is StandardToken, Pausable {
431 
432     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
433         return super.transfer(_to, _value);
434     }
435 
436     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
437         return super.transferFrom(_from, _to, _value);
438     }
439 
440     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
441         return super.approve(_spender, _value);
442     }
443 
444     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
445         return super.increaseApproval(_spender, _addedValue);
446     }
447 
448     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
449         return super.decreaseApproval(_spender, _subtractedValue);
450     }
451 }
452 
453 
454 /**
455  * @title SafeERC20
456  * @dev Wrappers around ERC20 operations that throw on failure.
457  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
458  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
459  */
460 library SafeERC20 {
461     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
462         require(token.transfer(to, value));
463     }
464 
465     function safeTransferFrom(
466         ERC20 token,
467         address from,
468         address to,
469         uint256 value
470     )
471         internal
472     {
473         require(token.transferFrom(from, to, value));
474     }
475 
476     function safeApprove(ERC20 token, address spender, uint256 value) internal {
477         require(token.approve(spender, value));
478     }
479 }
480 
481 
482 /**
483  * @title TokenTimelock
484  * @dev TokenTimelock is a token holder contract that will allow a
485  * beneficiary to extract the tokens after a given release time
486  */
487 contract TokenTimelock {
488     using SafeERC20 for ERC20Basic;
489 
490     // ERC20 basic token contract being held
491     ERC20Basic public token;
492 
493     // beneficiary of tokens after they are released
494     address public beneficiary;
495 
496     // timestamp when token release is enabled
497     uint256 public releaseTime;
498 
499     constructor(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
500         require(_releaseTime > block.timestamp); // solium-disable-line security/no-block-members
501         token = _token;
502         beneficiary = _beneficiary;
503         releaseTime = _releaseTime;
504     }
505 
506     /**
507      * @notice Transfers tokens held by timelock to beneficiary.
508      */
509     function release() public {
510         require(block.timestamp >= releaseTime); // solium-disable-line security/no-block-members
511 
512         uint256 amount = token.balanceOf(this);
513         require(amount > 0);
514 
515         token.safeTransfer(beneficiary, amount);
516     }
517 }
518 
519 
520 /**
521  * @title MaxToken
522  * @dev MaxToken Token contract
523  */
524 contract MaxToken is PausableToken, CappedToken, BurnableToken {
525     using SafeMath for uint256;
526 
527     string public name = "MAX Token";
528     string public symbol = "MAX";
529     uint public decimals = 18;
530     
531     /**
532      * @dev The constructor sets the totol supply of the token
533      * account.
534      */
535     constructor() public CappedToken(5e8 * 1e18) {
536         
537     }
538 
539     /**
540      * @dev mint timelocked tokens
541      */
542     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public 
543     onlyOwner canMint returns (TokenTimelock) 
544     {
545 
546         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
547         mint(timelock, _amount);
548 
549         return timelock;
550     }
551 
552     /**
553      * @dev Limit burn functions to owner and reduce cap after burning
554      */
555     function _burn(address _who, uint256 _value) internal onlyOwner {
556         // no need to check _value <= cap since totalSupply <= cap and 
557         // _value <= totalSupply was checked in burn functions
558         super._burn(_who, _value);
559         cap = cap.sub(_value);
560     }
561 }