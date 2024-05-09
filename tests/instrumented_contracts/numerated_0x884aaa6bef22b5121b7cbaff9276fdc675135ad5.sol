1 pragma solidity ^0.4.23;
2 
3 contract Migrations {
4     address public owner;
5     uint public last_completed_migration;
6 
7     modifier restricted() {
8         if (msg.sender == owner) _;
9     }
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     function setCompleted(uint completed) public restricted {
16         last_completed_migration = completed;
17     }
18 
19     function upgrade(address new_address) public restricted {
20         Migrations upgraded = Migrations(new_address);
21         upgraded.setCompleted(last_completed_migration);
22     }
23 }
24 
25 
26 contract ERC20Basic {
27     function totalSupply() public view returns (uint256);
28     function balanceOf(address who) public view returns (uint256);
29     function transfer(address to, uint256 value) public returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 is ERC20Basic {
38     function allowance(address owner, address spender) public view returns (uint256);
39     function transferFrom(address from, address to, uint256 value) public returns (bool);
40     function approve(address spender, uint256 value) public returns (bool);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50     /**
51     * @dev Multiplies two numbers, throws on overflow.
52     */
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two numbers, truncating the quotient.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // assert(b > 0); // Solidity automatically throws when dividing by 0
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69         return c;
70     }
71 
72     /**
73     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79 
80     /**
81     * @dev Adds two numbers, throws on overflow.
82     */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
89 
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances.
94  */
95 contract BasicToken is ERC20Basic {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) balances;
99 
100     uint256 totalSupply_;
101 
102     /**
103     * @dev total number of tokens in existence
104     */
105     function totalSupply() public view returns (uint256) {
106         return totalSupply_;
107     }
108 
109     /**
110     * @dev transfer token for a specified address
111     * @param _to The address to transfer to.
112     * @param _value The amount to be transferred.
113     */
114     function transfer(address _to, uint256 _value) public returns (bool) {
115         require(_to != address(0));
116         require(_value <= balances[msg.sender]);
117 
118         // SafeMath.sub will throw if there is not enough balance.
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         emit Transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     /**
126     * @dev Gets the balance of the specified address.
127     * @param _owner The address to query the the balance of.
128     * @return An uint256 representing the amount owned by the passed address.
129     */
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134 }
135 
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147     mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157         require(_to != address(0));
158         require(_value <= balances[_from]);
159         require(_value <= allowed[_from][msg.sender]);
160 
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164         emit Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      *
171      * Beware that changing an allowance with this method brings the risk that someone may use both the old
172      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      * @param _spender The address which will spend the funds.
176      * @param _value The amount of tokens to be spent.
177      */
178     function approve(address _spender, uint256 _value) public returns (bool) {
179         allowed[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param _owner address The address which owns the funds.
187      * @param _spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      */
190     function allowance(address _owner, address _spender) public view returns (uint256) {
191         return allowed[_owner][_spender];
192     }
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      *
197      * approve should be called when allowed[_spender] == 0. To increment
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * @param _spender The address which will spend the funds.
202      * @param _addedValue The amount of tokens to increase the allowance by.
203      */
204     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210     /**
211      * @dev Decrease the amount of tokens that an owner allowed to a spender.
212      *
213      * approve should be called when allowed[_spender] == 0. To decrement
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * @param _spender The address which will spend the funds.
218      * @param _subtractedValue The amount of tokens to decrease the allowance by.
219      */
220     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221         uint oldValue = allowed[msg.sender][_spender];
222         if (_subtractedValue > oldValue) {
223             allowed[msg.sender][_spender] = 0;
224         } else {
225             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226         }
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231 }
232 
233 
234 
235 /**
236  * @title Ownable
237  * @dev The Ownable contract has an owner address, and provides basic authorization control
238  * functions, this simplifies the implementation of "user permissions".
239  */
240 contract Ownable {
241     address public owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     /**
246      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247      * account.
248      */
249     constructor() public {
250         owner = msg.sender;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(msg.sender == owner);
258         _;
259     }
260 
261     /**
262      * @dev Allows the current owner to transfer control of the contract to a newOwner.
263      * @param newOwner The address to transfer ownership to.
264      */
265     function transferOwnership(address newOwner) public onlyOwner {
266         require(newOwner != address(0));
267         emit OwnershipTransferred(owner, newOwner);
268         owner = newOwner;
269     }
270 }
271 
272 
273 /**
274  * @title Transferable token
275  *
276  * @dev StandardToken modified with transfert on/off mechanism.
277  **/
278 contract TransferableToken is StandardToken,Ownable {
279 
280     /** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
281     * @dev TRANSFERABLE MECANISM SECTION
282     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
283 
284     event Transferable();
285     event UnTransferable();
286 
287     bool public transferable = false;
288     mapping (address => bool) public whitelisted;
289 
290     /**
291         CONSTRUCTOR
292     **/
293 
294     constructor()
295         StandardToken()
296         Ownable()
297         public
298     {
299         whitelisted[msg.sender] = true;
300     }
301 
302     /**
303         MODIFIERS
304     **/
305 
306     /**
307     * @dev Modifier to make a function callable only when the contract is not transferable.
308     */
309     modifier whenNotTransferable() {
310         require(!transferable);
311         _;
312     }
313 
314     /**
315     * @dev Modifier to make a function callable only when the contract is transferable.
316     */
317     modifier whenTransferable() {
318         require(transferable);
319         _;
320     }
321 
322     /**
323     * @dev Modifier to make a function callable only when the caller can transfert token.
324     */
325     modifier canTransfert() {
326         if(!transferable){
327             require (whitelisted[msg.sender]);
328         }
329         _;
330    }
331 
332     /**
333         OWNER ONLY FUNCTIONS
334     **/
335 
336     /**
337     * @dev called by the owner to allow transferts, triggers Transferable state
338     */
339     function allowTransfert() onlyOwner whenNotTransferable public {
340         transferable = true;
341         emit Transferable();
342     }
343 
344     /**
345     * @dev called by the owner to restrict transferts, returns to untransferable state
346     */
347     function restrictTransfert() onlyOwner whenTransferable public {
348         transferable = false;
349         emit UnTransferable();
350     }
351 
352     /**
353       @dev Allows the owner to add addresse that can bypass the transfer lock.
354     **/
355     function whitelist(address _address) onlyOwner public {
356         require(_address != 0x0);
357         whitelisted[_address] = true;
358     }
359 
360     /**
361       @dev Allows the owner to remove addresse that can bypass the transfer lock.
362     **/
363     function restrict(address _address) onlyOwner public {
364         require(_address != 0x0);
365         whitelisted[_address] = false;
366     }
367 
368 
369     /** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
370     * @dev Strandard transferts overloaded API
371     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
372 
373     function transfer(address _to, uint256 _value) public canTransfert returns (bool) {
374         return super.transfer(_to, _value);
375     }
376 
377     function transferFrom(address _from, address _to, uint256 _value) public canTransfert returns (bool) {
378         return super.transferFrom(_from, _to, _value);
379     }
380 
381   /**
382    * Beware that changing an allowance with this method brings the risk that someone may use both the old
383    * and the new allowance by unfortunate transaction ordering. We recommend to use use increaseApproval
384    * and decreaseApproval functions instead !
385    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263555598
386    */
387     function approve(address _spender, uint256 _value) public canTransfert returns (bool) {
388         return super.approve(_spender, _value);
389     }
390 
391     function increaseApproval(address _spender, uint _addedValue) public canTransfert returns (bool success) {
392         return super.increaseApproval(_spender, _addedValue);
393     }
394 
395     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfert returns (bool success) {
396         return super.decreaseApproval(_spender, _subtractedValue);
397     }
398 }
399 
400 
401 
402 contract KryllToken is TransferableToken {
403 //    using SafeMath for uint256;
404 
405     string public symbol = "EAST";
406     string public name = "EASON Token";
407     uint8 public decimals = 18;
408 
409 
410     uint256 constant internal DECIMAL_CASES    = (10 ** uint256(decimals));
411     uint256 constant public   SALE             =   10000000000 * DECIMAL_CASES; // Token sale
412     uint256 constant public   TEAM             =   10000000000 * DECIMAL_CASES; // TEAM (vested)
413 
414 
415     address public sale_address     = 0x0;
416     address public team_address     = 0x0;
417     bool public initialDistributionDone = false;
418 
419     /**
420     * @dev Setup the initial distribution addresses
421     */
422     function reset(address _saleAddrss, address _teamAddrss) public onlyOwner{
423         require(!initialDistributionDone);
424         team_address = _teamAddrss;
425         sale_address = _saleAddrss;
426     }
427 
428     /**
429     * @dev compute & distribute the tokens
430     */
431     function distribute() public onlyOwner {
432         // Initialisation check
433         require(!initialDistributionDone);
434         require(sale_address != 0x0 && team_address != 0x0);
435 
436         // Compute total supply
437         totalSupply_ = SALE.add(TEAM);
438 
439         // Distribute KRL Token
440         balances[owner] = totalSupply_;
441         emit Transfer(0x0, owner, totalSupply_);
442 
443         transfer(team_address, TEAM);
444         transfer(sale_address, SALE);
445         initialDistributionDone = true;
446         whitelist(sale_address); // Auto whitelist sale address
447         whitelist(team_address); // Auto whitelist team address (vesting transfert)
448     }
449 
450     /**
451     * @dev Allows owner to later update token name if needed.
452     */
453     function setName(string _name) onlyOwner public {
454         name = _name;
455     }
456 
457 }
458 /**
459  * @title KryllVesting
460  * @dev A token holder contract that can release its token balance gradually like a
461  * typical vesting scheme, with a cliff and vesting period.
462  */
463 contract KryllVesting is Ownable {
464     using SafeMath for uint256;
465 
466     event Released(uint256 amount);
467 
468     // beneficiary of tokens after they are released
469     address public beneficiary;
470     KryllToken public token;
471 
472     uint256 public startTime;
473     uint256 public cliff;
474     uint256 public released;
475 
476 
477     uint256 constant public   VESTING_DURATION    =  31536000; // 1 Year in second
478     uint256 constant public   CLIFF_DURATION      =   7776000; // 3 months (90 days) in second
479 
480 
481     /**
482     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
483     * _beneficiary, gradually in a linear fashion. By then all of the balance will have vested.
484     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
485     * @param _token The token to be vested
486     */
487     function setup(address _beneficiary,address _token) public onlyOwner{
488         require(startTime == 0); // Vesting not started
489         require(_beneficiary != address(0));
490         // Basic init
491         changeBeneficiary(_beneficiary);
492         token = KryllToken(_token);
493     }
494 
495     /**
496     * @notice Start the vesting process.
497     */
498     function start() public onlyOwner{
499         require(token != address(0));
500         require(startTime == 0); // Vesting not started
501         startTime = now;
502         cliff = startTime.add(CLIFF_DURATION);
503     }
504 
505     /**
506     * @notice Is vesting started flag.
507     */
508     function isStarted() public view returns (bool) {
509         return (startTime > 0);
510     }
511 
512 
513     /**
514     * @notice Owner can change beneficiary address
515     */
516     function changeBeneficiary(address _beneficiary) public onlyOwner{
517         beneficiary = _beneficiary;
518     }
519 
520 
521     /**
522     * @notice Transfers vested tokens to beneficiary.
523     */
524     function release() public {
525         require(startTime != 0);
526         require(beneficiary != address(0));
527 
528         uint256 unreleased = releasableAmount();
529         require(unreleased > 0);
530 
531         released = released.add(unreleased);
532         token.transfer(beneficiary, unreleased);
533         emit Released(unreleased);
534     }
535 
536     /**
537     * @dev Calculates the amount that has already vested but hasn't been released yet.
538     */
539     function releasableAmount() public view returns (uint256) {
540         return vestedAmount().sub(released);
541     }
542 
543     /**
544     * @dev Calculates the amount that has already vested.
545     */
546     function vestedAmount() public view returns (uint256) {
547         uint256 currentBalance = token.balanceOf(this);
548         uint256 totalBalance = currentBalance.add(released);
549 
550         if (now < cliff) {
551             return 0;
552         } else if (now >= startTime.add(VESTING_DURATION)) {
553             return totalBalance;
554         } else {
555             return totalBalance.mul(now.sub(startTime)).div(VESTING_DURATION);
556         }
557     }
558 }