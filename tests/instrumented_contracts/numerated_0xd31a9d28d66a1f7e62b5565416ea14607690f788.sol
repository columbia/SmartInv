1 pragma solidity >=0.5.0<0.6.0;
2 
3 //filename: contracts/Consts.sol
4 contract Consts {
5     string constant TOKEN_NAME = "HCUT";
6     string constant TOKEN_SYMBOL = "HCUT";
7     uint8 constant TOKEN_DECIMALS = 18;
8     uint256 constant TOKEN_AMOUNT = 10000000000;
9 }
10 
11 //filename: contracts/utils/Ownable.sol
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18     address public owner;
19 
20 
21     event OwnershipRenounced(address indexed previousOwner);
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25     /**
26      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27      * account.
28      */
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) public onlyOwner {
46         require(newOwner != address(0));
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 
51     /**
52      * @dev Allows the current owner to relinquish control of the contract.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipRenounced(owner);
56         owner = address(0);
57     }
58 }
59 
60 //filename: contracts/tokens/ERC20Basic.sol
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67     function totalSupply() public view returns (uint256);
68     function balanceOf(address who) public view returns (uint256);
69     function transfer(address to, uint256 value) public returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 //filename: contracts/utils/SafeMath.sol
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79     /**
80       * @dev Multiplies two numbers, throws on overflow.
81       */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83         if (a == 0) {
84             return 0;
85         }
86         c = a * b;
87         assert(c / a == b);
88         return c;
89     }
90 
91     /**
92     * @dev Integer division of two numbers, truncating the quotient.
93     */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         // assert(b > 0); // Solidity automatically throws when dividing by 0
96         // uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98         return a / b;
99     }
100 
101     /**
102     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103     */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         assert(b <= a);
106         return a - b;
107     }
108 
109     /**
110     * @dev Adds two numbers, throws on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113         c = a + b;
114         assert(c >= a);
115         return c;
116     }
117 }
118 
119 //filename: contracts/tokens/BasicToken.sol
120 /**
121  * @title Basic tokens
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125     using SafeMath for uint256;
126 
127     mapping(address => uint256) balances;
128 
129     uint256 totalSupply_;
130 
131     /**
132     * @dev total number of tokens in existence
133     */
134     function totalSupply() public view returns (uint256) {
135         return totalSupply_;
136     }
137 
138     /**
139     * @dev transfer tokens for a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) public view returns (uint256) {
159         return balances[_owner];
160     }
161 
162 }
163 
164 //filename: contracts/tokens/ERC20.sol
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170     function allowance(address owner, address spender) public view returns (uint256);
171     function transferFrom(address from, address to, uint256 value) public returns (bool);
172     function approve(address spender, uint256 value) public returns (bool);
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 //filename: contracts/tokens/StandardToken.sol
177 /**
178  * @title Standard ERC20 tokens
179  *
180  * @dev Implementation of the basic standard tokens.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185     mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188     /**
189      * @dev Transfer tokens from one address to another
190      * @param _from address The address which you want to send tokens from
191      * @param _to address The address which you want to transfer to
192      * @param _value uint256 the amount of tokens to be transferred
193      */
194     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195         require(_to != address(0));
196         require(_value <= balances[_from]);
197         require(_value <= allowed[_from][msg.sender]);
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202         emit Transfer(_from, _to, _value);
203         return true;
204     }
205 
206     /**
207      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208      *
209      * Beware that changing an allowance with this method brings the risk that someone may use both the old
210      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      * @param _spender The address which will spend the funds.
214      * @param _value The amount of tokens to be spent.
215      */
216     function approve(address _spender, uint256 _value) public returns (bool) {
217         allowed[msg.sender][_spender] = _value;
218         emit Approval(msg.sender, _spender, _value);
219         return true;
220     }
221 
222     /**
223      * @dev Function to check the amount of tokens that an owner allowed to a spender.
224      * @param _owner address The address which owns the funds.
225      * @param _spender address The address which will spend the funds.
226      * @return A uint256 specifying the amount of tokens still available for the spender.
227      */
228     function allowance(address _owner, address _spender) public view returns (uint256) {
229         return allowed[_owner][_spender];
230     }
231 
232     /**
233      * @dev Increase the amount of tokens that an owner allowed to a spender.
234      *
235      * approve should be called when allowed[_spender] == 0. To increment
236      * allowed value is better to use this function to avoid 2 calls (and wait until
237      * the first transaction is mined)
238      * From MonolithDAO Token.sol
239      * @param _spender The address which will spend the funds.
240      * @param _addedValue The amount of tokens to increase the allowance by.
241      */
242     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245         return true;
246     }
247 
248     /**
249      * @dev Decrease the amount of tokens that an owner allowed to a spender.
250      *
251      * approve should be called when allowed[_spender] == 0. To decrement
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * @param _spender The address which will spend the funds.
256      * @param _subtractedValue The amount of tokens to decrease the allowance by.
257      */
258     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
259         uint oldValue = allowed[msg.sender][_spender];
260         if (_subtractedValue > oldValue) {
261             allowed[msg.sender][_spender] = 0;
262         } else {
263             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264         }
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 }
269 
270 //filename: contracts/tokens/FreezableToken.sol
271 /**
272  * @title FreezableToken
273  * @dev Freeze transfer of the specific addresses, if the address is hacked
274  */
275 contract FreezableToken is StandardToken, Ownable {
276     mapping (address => bool) public freezeAddresses;
277 
278     event FreezableAddressAdded(address indexed addr);
279     event FreezableAddressRemoved(address indexed addr);
280 
281     function addFreezableAddresses(address[] memory addrs) public onlyOwner returns(bool success) {
282         for (uint256 i = 0; i < addrs.length; i++) {
283             if (addFreezableAddress(addrs[i])) {
284                 success = true;
285             }
286         }
287     }
288 
289     function addFreezableAddress(address addr) public onlyOwner returns(bool success) {
290         if (!freezeAddresses[addr]) {
291             freezeAddresses[addr] = true;
292             emit FreezableAddressAdded(addr);
293             success = true;
294         }
295     }
296 
297     function removeFreezableAddresses(address[] memory addrs) public onlyOwner returns(bool success) {
298         for (uint256 i = 0; i < addrs.length; i++) {
299             if (removeFreezableAddress(addrs[i])) {
300                 success = true;
301             }
302         }
303     }
304 
305     function removeFreezableAddress(address addr) public onlyOwner returns(bool success) {
306         if (freezeAddresses[addr]) {
307             freezeAddresses[addr] = false;
308             emit FreezableAddressRemoved(addr);
309             success = true;
310         }
311     }
312 
313     /**
314     */
315     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
316         require(!freezeAddresses[_from]);
317         require(!freezeAddresses[_to]);
318         return super.transferFrom(_from, _to, _value);
319     }
320 
321     /**
322     */
323     function transfer(address _to, uint256 _value) public returns (bool) {
324         require(!freezeAddresses[msg.sender]);
325         require(!freezeAddresses[_to]);
326         return super.transfer(_to, _value);
327     }
328 }
329 
330 //filename: contracts/tokens/TransferableToken.sol
331 /**
332  * @title TransferableToken
333  */
334 contract TransferableToken is StandardToken, Ownable {
335     bool public isLock;
336 
337     mapping (address => bool) public transferableAddresses;
338 
339     constructor() public {
340         isLock = true;
341         transferableAddresses[msg.sender] = true;
342     }
343 
344     event Unlock();
345     event TransferableAddressAdded(address indexed addr);
346     event TransferableAddressRemoved(address indexed addr);
347 
348     function unlock() public onlyOwner {
349         isLock = false;
350         emit Unlock();
351     }
352 
353     function isTransferable(address addr) public view returns(bool) {
354         return !isLock || transferableAddresses[addr];
355     }
356 
357     function addTransferableAddresses(address[] memory addrs) public onlyOwner returns(bool success) {
358         for (uint256 i = 0; i < addrs.length; i++) {
359             if (addTransferableAddress(addrs[i])) {
360                 success = true;
361             }
362         }
363     }
364 
365     function addTransferableAddress(address addr) public onlyOwner returns(bool success) {
366         if (!transferableAddresses[addr]) {
367             transferableAddresses[addr] = true;
368             emit TransferableAddressAdded(addr);
369             success = true;
370         }
371     }
372 
373     function removeTransferableAddresses(address[] memory addrs) public onlyOwner returns(bool success) {
374         for (uint256 i = 0; i < addrs.length; i++) {
375             if (removeTransferableAddress(addrs[i])) {
376                 success = true;
377             }
378         }
379     }
380 
381     function removeTransferableAddress(address addr) public onlyOwner returns(bool success) {
382         if (transferableAddresses[addr]) {
383             transferableAddresses[addr] = false;
384             emit TransferableAddressRemoved(addr);
385             success = true;
386         }
387     }
388 
389     /**
390     */
391     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
392         require(isTransferable(_from));
393         return super.transferFrom(_from, _to, _value);
394     }
395 
396     /**
397     */
398     function transfer(address _to, uint256 _value) public returns (bool) {
399         require(isTransferable(msg.sender));
400         return super.transfer(_to, _value);
401     }
402 }
403 
404 //filename: contracts/utils/Pausable.sol
405 /**
406  * @title Pausable
407  * @dev Base contract which allows children to implement an emergency stop mechanism.
408  */
409 contract Pausable is Ownable {
410     event Pause();
411     event Unpause();
412 
413     bool public paused = false;
414 
415 
416     /**
417      * @dev Modifier to make a function callable only when the contract is not paused.
418      */
419     modifier whenNotPaused() {
420         require(!paused);
421         _;
422     }
423 
424     /**
425      * @dev Modifier to makeWhitelist a function callable only when the contract is paused.
426      */
427     modifier whenPaused() {
428         require(paused);
429         _;
430     }
431 
432     /**
433      * @dev called by the owner to pause, triggers stopped state
434      */
435     function pause() onlyOwner whenNotPaused public {
436         paused = true;
437         emit Pause();
438     }
439 
440     /**
441      * @dev called by the owner to unpause, returns to normal state
442      */
443     function unpause() onlyOwner whenPaused public {
444         paused = false;
445         emit Unpause();
446     }
447 }
448 
449 //filename: contracts/tokens/PausableToken.sol
450 /**
451  * @title Pausable tokens
452  * @dev StandardToken modified with pausable transfers.
453  **/
454 contract PausableToken is StandardToken, Pausable {
455 
456     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
457         return super.transfer(_to, _value);
458     }
459 
460     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
461         return super.transferFrom(_from, _to, _value);
462     }
463 
464     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
465         return super.approve(_spender, _value);
466     }
467 
468     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
469         return super.increaseApproval(_spender, _addedValue);
470     }
471 
472     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
473         return super.decreaseApproval(_spender, _subtractedValue);
474     }
475 }
476 
477 //filename: contracts/tokens/MintableToken.sol
478 /**
479  * @title Mintable token
480  * @dev Simple ERC20 Token example, with mintable token creation
481  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
482  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
483  */
484 contract MintableToken is StandardToken, Ownable {
485     event Mint(address indexed to, uint256 amount);
486     event MintFinished();
487 
488     bool public mintingFinished = false;
489 
490 
491     modifier canMint() {
492         require(!mintingFinished);
493         _;
494     }
495 
496     /**
497      * @dev Function to mint tokens
498      * @param _to The address that will receive the minted tokens.
499      * @param _amount The amount of tokens to mint.
500      * @return A boolean that indicates if the operation was successful.
501      */
502     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
503         totalSupply_ = totalSupply_.add(_amount);
504         balances[_to] = balances[_to].add(_amount);
505         emit Mint(_to, _amount);
506         emit Transfer(address(0), _to, _amount);
507         return true;
508     }
509 
510     /**
511      * @dev Function to stop minting new tokens.
512      * @return True if the operation was successful.
513      */
514     function finishMinting() onlyOwner canMint public returns (bool) {
515         mintingFinished = true;
516         emit MintFinished();
517         return true;
518     }
519 }
520 
521 //filename: contracts/tokens/BurnableToken.sol
522 /**
523  * @title Burnable Token
524  * @dev Token that can be irreversibly burned (destroyed).
525  */
526 contract BurnableToken is BasicToken, Pausable {
527 
528     event Burn(address indexed burner, uint256 value);
529 
530     /**
531      * @dev Burns a specific amount of tokens.
532      * @param _value The amount of tokens to be burned.
533      */
534     function burn(uint256 _value) whenNotPaused public {
535         _burn(msg.sender, _value);
536     }
537 
538     function _burn(address _who, uint256 _value) internal {
539         require(_value <= balances[_who]);
540         // no need to require value <= totalSupply, since that would imply the
541         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
542 
543         balances[_who] = balances[_who].sub(_value);
544         totalSupply_ = totalSupply_.sub(_value);
545         emit Burn(_who, _value);
546         emit Transfer(_who, address(0), _value);
547     }
548 }
549 
550 //filename: contracts/MainToken.sol
551 /**
552  * @title MainToken
553  */
554 contract MainToken is Consts
555     , FreezableToken
556     , TransferableToken
557     , PausableToken
558     , MintableToken
559     , BurnableToken
560     {
561     string public constant name = TOKEN_NAME; // solium-disable-line uppercase
562     string public constant symbol = TOKEN_SYMBOL; // solium-disable-line uppercase
563     uint8 public constant decimals = TOKEN_DECIMALS; // solium-disable-line uppercase
564 
565     uint256 public constant INITIAL_SUPPLY = TOKEN_AMOUNT * (10 ** uint256(decimals));
566 
567     constructor() public {
568         totalSupply_ = INITIAL_SUPPLY;
569         balances[msg.sender] = INITIAL_SUPPLY;
570         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
571     }
572 }