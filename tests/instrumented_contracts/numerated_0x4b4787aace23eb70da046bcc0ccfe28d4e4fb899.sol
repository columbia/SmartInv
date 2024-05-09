1 pragma solidity >=0.5.0<0.6.0;
2 
3 //filename: contracts/Consts.sol
4 contract Consts {
5     string constant TOKEN_NAME = "Smathium";
6     string constant TOKEN_SYMBOL = "SMT";
7     uint8 constant TOKEN_DECIMALS = 18;
8     uint256 constant TOKEN_AMOUNT = 10000000000;
9 
10     address payable[] SALE_ETH_WALLET = [0x9fBFbBac0f1faF30d01FDc862CB750EbfA1cD61b, 0x9fBFbBac0f1faF30d01FDc862CB750EbfA1cD61b, 0x9fBFbBac0f1faF30d01FDc862CB750EbfA1cD61b, 0x9fBFbBac0f1faF30d01FDc862CB750EbfA1cD61b];
11     uint256[] SALE_HARD_CAP = [0, 0, 0, 3000000000];
12     uint256[] SALE_SOFT_CAP = [0, 0, 0, 0];
13     uint256[] SALE_RATE = [34826, 29915, 25926, 24561];
14     uint256[] SALE_OPENING_TIME = [0, 0, 0, 1557068400];
15     uint256[] SALE_CLOSING_TIME = [0, 0, 0, 1564412399];
16     uint256[] SALE_MIN_ETH = [5 ether, 5 ether, 1 ether, 1 ether];
17     uint256[] SALE_MAX_ETH = [500 ether, 500 ether, 500 ether, 500 ether];
18 }
19 
20 //filename: contracts/utils/Ownable.sol
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27     address public owner;
28 
29 
30     event OwnershipRenounced(address indexed previousOwner);
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34     /**
35      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36      * account.
37      */
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     /**
43      * @dev Throws if called by any account other than the owner.
44      */
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 
60     /**
61      * @dev Allows the current owner to relinquish control of the contract.
62      */
63     function renounceOwnership() public onlyOwner {
64         emit OwnershipRenounced(owner);
65         owner = address(0);
66     }
67 }
68 
69 //filename: contracts/tokens/ERC20Basic.sol
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76     function totalSupply() public view returns (uint256);
77     function balanceOf(address who) public view returns (uint256);
78     function transfer(address to, uint256 value) public returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 //filename: contracts/utils/SafeMath.sol
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88     /**
89       * @dev Multiplies two numbers, throws on overflow.
90       */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
92         if (a == 0) {
93             return 0;
94         }
95         c = a * b;
96         assert(c / a == b);
97         return c;
98     }
99 
100     /**
101     * @dev Integer division of two numbers, truncating the quotient.
102     */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         // assert(b > 0); // Solidity automatically throws when dividing by 0
105         // uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107         return a / b;
108     }
109 
110     /**
111     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112     */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         assert(b <= a);
115         return a - b;
116     }
117 
118     /**
119     * @dev Adds two numbers, throws on overflow.
120     */
121     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
122         c = a + b;
123         assert(c >= a);
124         return c;
125     }
126 }
127 
128 //filename: contracts/tokens/BasicToken.sol
129 /**
130  * @title Basic tokens
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134     using SafeMath for uint256;
135 
136     mapping(address => uint256) balances;
137 
138     uint256 totalSupply_;
139 
140     /**
141     * @dev total number of tokens in existence
142     */
143     function totalSupply() public view returns (uint256) {
144         return totalSupply_;
145     }
146 
147     /**
148     * @dev transfer tokens for a specified address
149     * @param _to The address to transfer to.
150     * @param _value The amount to be transferred.
151     */
152     function transfer(address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[msg.sender]);
155 
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         emit Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param _owner The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function balanceOf(address _owner) public view returns (uint256) {
168         return balances[_owner];
169     }
170 
171 }
172 
173 //filename: contracts/tokens/ERC20.sol
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179     function allowance(address owner, address spender) public view returns (uint256);
180     function transferFrom(address from, address to, uint256 value) public returns (bool);
181     function approve(address spender, uint256 value) public returns (bool);
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 //filename: contracts/tokens/StandardToken.sol
186 /**
187  * @title Standard ERC20 tokens
188  *
189  * @dev Implementation of the basic standard tokens.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194     mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207 
208         balances[_from] = balances[_from].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211         emit Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      *
218      * Beware that changing an allowance with this method brings the risk that someone may use both the old
219      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      * @param _spender The address which will spend the funds.
223      * @param _value The amount of tokens to be spent.
224      */
225     function approve(address _spender, uint256 _value) public returns (bool) {
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address _owner, address _spender) public view returns (uint256) {
238         return allowed[_owner][_spender];
239     }
240 
241     /**
242      * @dev Increase the amount of tokens that an owner allowed to a spender.
243      *
244      * approve should be called when allowed[_spender] == 0. To increment
245      * allowed value is better to use this function to avoid 2 calls (and wait until
246      * the first transaction is mined)
247      * From MonolithDAO Token.sol
248      * @param _spender The address which will spend the funds.
249      * @param _addedValue The amount of tokens to increase the allowance by.
250      */
251     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
252         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257     /**
258      * @dev Decrease the amount of tokens that an owner allowed to a spender.
259      *
260      * approve should be called when allowed[_spender] == 0. To decrement
261      * allowed value is better to use this function to avoid 2 calls (and wait until
262      * the first transaction is mined)
263      * From MonolithDAO Token.sol
264      * @param _spender The address which will spend the funds.
265      * @param _subtractedValue The amount of tokens to decrease the allowance by.
266      */
267     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
268         uint oldValue = allowed[msg.sender][_spender];
269         if (_subtractedValue > oldValue) {
270             allowed[msg.sender][_spender] = 0;
271         } else {
272             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273         }
274         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275         return true;
276     }
277 }
278 
279 //filename: contracts/tokens/TransferableToken.sol
280 /**
281  * @title TransferableToken
282  */
283 contract TransferableToken is StandardToken, Ownable {
284     bool public isLock;
285 
286     mapping (address => bool) public transferableAddresses;
287 
288     constructor() public {
289         isLock = true;
290         transferableAddresses[msg.sender] = true;
291     }
292 
293     event Unlock();
294     event TransferableAddressAdded(address indexed addr);
295     event TransferableAddressRemoved(address indexed addr);
296 
297     function unlock() public onlyOwner {
298         isLock = false;
299         emit Unlock();
300     }
301 
302     function isTransferable(address addr) public view returns(bool) {
303         return !isLock || transferableAddresses[addr];
304     }
305 
306     function addTransferableAddresses(address[] memory addrs) public onlyOwner returns(bool success) {
307         for (uint256 i = 0; i < addrs.length; i++) {
308             if (addTransferableAddress(addrs[i])) {
309                 success = true;
310             }
311         }
312     }
313 
314     function addTransferableAddress(address addr) public onlyOwner returns(bool success) {
315         if (!transferableAddresses[addr]) {
316             transferableAddresses[addr] = true;
317             emit TransferableAddressAdded(addr);
318             success = true;
319         }
320     }
321 
322     function removeTransferableAddresses(address[] memory addrs) public onlyOwner returns(bool success) {
323         for (uint256 i = 0; i < addrs.length; i++) {
324             if (removeTransferableAddress(addrs[i])) {
325                 success = true;
326             }
327         }
328     }
329 
330     function removeTransferableAddress(address addr) public onlyOwner returns(bool success) {
331         if (transferableAddresses[addr]) {
332             transferableAddresses[addr] = false;
333             emit TransferableAddressRemoved(addr);
334             success = true;
335         }
336     }
337 
338     /**
339     */
340     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
341         require(isTransferable(_from));
342         return super.transferFrom(_from, _to, _value);
343     }
344 
345     /**
346     */
347     function transfer(address _to, uint256 _value) public returns (bool) {
348         require(isTransferable(msg.sender));
349         return super.transfer(_to, _value);
350     }
351 }
352 
353 //filename: contracts/utils/Pausable.sol
354 /**
355  * @title Pausable
356  * @dev Base contract which allows children to implement an emergency stop mechanism.
357  */
358 contract Pausable is Ownable {
359     event Pause();
360     event Unpause();
361 
362     bool public paused = false;
363 
364 
365     /**
366      * @dev Modifier to make a function callable only when the contract is not paused.
367      */
368     modifier whenNotPaused() {
369         require(!paused);
370         _;
371     }
372 
373     /**
374      * @dev Modifier to makeWhitelist a function callable only when the contract is paused.
375      */
376     modifier whenPaused() {
377         require(paused);
378         _;
379     }
380 
381     /**
382      * @dev called by the owner to pause, triggers stopped state
383      */
384     function pause() onlyOwner whenNotPaused public {
385         paused = true;
386         emit Pause();
387     }
388 
389     /**
390      * @dev called by the owner to unpause, returns to normal state
391      */
392     function unpause() onlyOwner whenPaused public {
393         paused = false;
394         emit Unpause();
395     }
396 }
397 
398 //filename: contracts/tokens/PausableToken.sol
399 /**
400  * @title Pausable tokens
401  * @dev StandardToken modified with pausable transfers.
402  **/
403 contract PausableToken is StandardToken, Pausable {
404 
405     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
406         return super.transfer(_to, _value);
407     }
408 
409     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
410         return super.transferFrom(_from, _to, _value);
411     }
412 
413     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
414         return super.approve(_spender, _value);
415     }
416 
417     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
418         return super.increaseApproval(_spender, _addedValue);
419     }
420 
421     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
422         return super.decreaseApproval(_spender, _subtractedValue);
423     }
424 }
425 
426 //filename: contracts/tokens/BurnableToken.sol
427 /**
428  * @title Burnable Token
429  * @dev Token that can be irreversibly burned (destroyed).
430  */
431 contract BurnableToken is BasicToken, Pausable {
432 
433     event Burn(address indexed burner, uint256 value);
434 
435     /**
436      * @dev Burns a specific amount of tokens.
437      * @param _value The amount of tokens to be burned.
438      */
439     function burn(uint256 _value) whenNotPaused public {
440         _burn(msg.sender, _value);
441     }
442 
443     function _burn(address _who, uint256 _value) internal {
444         require(_value <= balances[_who]);
445         // no need to require value <= totalSupply, since that would imply the
446         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
447 
448         balances[_who] = balances[_who].sub(_value);
449         totalSupply_ = totalSupply_.sub(_value);
450         emit Burn(_who, _value);
451         emit Transfer(_who, address(0), _value);
452     }
453 }
454 
455 //filename: contracts/MainToken.sol
456 /**
457  * @title MainToken
458  */
459 contract MainToken is Consts
460     
461     , TransferableToken
462     , PausableToken
463     
464     , BurnableToken
465     {
466     string public constant name = TOKEN_NAME; // solium-disable-line uppercase
467     string public constant symbol = TOKEN_SYMBOL; // solium-disable-line uppercase
468     uint8 public constant decimals = TOKEN_DECIMALS; // solium-disable-line uppercase
469 
470     uint256 public constant INITIAL_SUPPLY = TOKEN_AMOUNT * (10 ** uint256(decimals));
471 
472     constructor() public {
473         totalSupply_ = INITIAL_SUPPLY;
474         balances[msg.sender] = INITIAL_SUPPLY;
475         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
476     }
477 }