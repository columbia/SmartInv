1 pragma solidity ^0.4.23;
2 
3 
4 
5 contract Consts {
6     string constant TOKEN_NAME = "AmonD";
7     string constant TOKEN_SYMBOL = "AMON";
8     uint8 constant TOKEN_DECIMALS = 18;
9     uint256 constant TOKEN_AMOUNT = 7600000000;
10 }
11 
12 
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20     address public owner;
21 
22 
23     event OwnershipRenounced(address indexed previousOwner);
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27     /**
28      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29      * account.
30      */
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44      * @dev Allows the current owner to transfer control of the contract to a newOwner.
45      * @param newOwner The address to transfer ownership to.
46      */
47     function transferOwnership(address newOwner) public onlyOwner {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 
53     /**
54      * @dev Allows the current owner to relinquish control of the contract.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipRenounced(owner);
58         owner = address(0);
59     }
60 }
61 
62 
63 
64 
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72     function totalSupply() public view returns (uint256);
73     function balanceOf(address who) public view returns (uint256);
74     function transfer(address to, uint256 value) public returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 
79 /**
80  * @title SafeMath
81  * @dev Math operations with safety checks that throw on error
82  */
83 library SafeMath {
84     /**
85       * @dev Multiplies two numbers, throws on overflow.
86       */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88         if (a == 0) {
89             return 0;
90         }
91         c = a * b;
92         assert(c / a == b);
93         return c;
94     }
95 
96     /**
97     * @dev Integer division of two numbers, truncating the quotient.
98     */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         // assert(b > 0); // Solidity automatically throws when dividing by 0
101         // uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103         return a / b;
104     }
105 
106     /**
107     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108     */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         assert(b <= a);
111         return a - b;
112     }
113 
114     /**
115     * @dev Adds two numbers, throws on overflow.
116     */
117     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118         c = a + b;
119         assert(c >= a);
120         return c;
121     }
122 }
123 
124 
125 /**
126  * @title Basic tokens
127  * @dev Basic version of StandardToken, with no allowances.
128  */
129 contract BasicToken is ERC20Basic {
130     using SafeMath for uint256;
131 
132     mapping(address => uint256) balances;
133 
134     uint256 totalSupply_;
135 
136     /**
137     * @dev total number of tokens in existence
138     */
139     function totalSupply() public view returns (uint256) {
140         return totalSupply_;
141     }
142 
143     /**
144     * @dev transfer tokens for a specified address
145     * @param _to The address to transfer to.
146     * @param _value The amount to be transferred.
147     */
148     function transfer(address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[msg.sender]);
151 
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         emit Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     /**
159     * @dev Gets the balance of the specified address.
160     * @param _owner The address to query the the balance of.
161     * @return An uint256 representing the amount owned by the passed address.
162     */
163     function balanceOf(address _owner) public view returns (uint256) {
164         return balances[_owner];
165     }
166 
167 }
168 
169 
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176     function allowance(address owner, address spender) public view returns (uint256);
177     function transferFrom(address from, address to, uint256 value) public returns (bool);
178     function approve(address spender, uint256 value) public returns (bool);
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 /**
183  * @title Standard ERC20 tokens
184  *
185  * @dev Implementation of the basic standard tokens.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190     mapping (address => mapping (address => uint256)) internal allowed;
191 
192 
193     /**
194      * @dev Transfer tokens from one address to another
195      * @param _from address The address which you want to send tokens from
196      * @param _to address The address which you want to transfer to
197      * @param _value uint256 the amount of tokens to be transferred
198      */
199     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200         require(_to != address(0));
201         require(_value <= balances[_from]);
202         require(_value <= allowed[_from][msg.sender]);
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207         emit Transfer(_from, _to, _value);
208         return true;
209     }
210 
211     /**
212      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213      *
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param _spender The address which will spend the funds.
219      * @param _value The amount of tokens to be spent.
220      */
221     function approve(address _spender, uint256 _value) public returns (bool) {
222         allowed[msg.sender][_spender] = _value;
223         emit Approval(msg.sender, _spender, _value);
224         return true;
225     }
226 
227     /**
228      * @dev Function to check the amount of tokens that an owner allowed to a spender.
229      * @param _owner address The address which owns the funds.
230      * @param _spender address The address which will spend the funds.
231      * @return A uint256 specifying the amount of tokens still available for the spender.
232      */
233     function allowance(address _owner, address _spender) public view returns (uint256) {
234         return allowed[_owner][_spender];
235     }
236 
237     /**
238      * @dev Increase the amount of tokens that an owner allowed to a spender.
239      *
240      * approve should be called when allowed[_spender] == 0. To increment
241      * allowed value is better to use this function to avoid 2 calls (and wait until
242      * the first transaction is mined)
243      * From MonolithDAO Token.sol
244      * @param _spender The address which will spend the funds.
245      * @param _addedValue The amount of tokens to increase the allowance by.
246      */
247     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253     /**
254      * @dev Decrease the amount of tokens that an owner allowed to a spender.
255      *
256      * approve should be called when allowed[_spender] == 0. To decrement
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * @param _spender The address which will spend the funds.
261      * @param _subtractedValue The amount of tokens to decrease the allowance by.
262      */
263     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264         uint oldValue = allowed[msg.sender][_spender];
265         if (_subtractedValue > oldValue) {
266             allowed[msg.sender][_spender] = 0;
267         } else {
268             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269         }
270         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271         return true;
272     }
273 }
274 
275 
276 /**
277  * @title FreezableToken
278  * @dev Freeze transfer of the specific addresses, if the address is hacked
279  */
280 contract FreezableToken is StandardToken, Ownable {
281     mapping (address => bool) public freezeAddresses;
282 
283     event FreezableAddressAdded(address indexed addr);
284     event FreezableAddressRemoved(address indexed addr);
285 
286     function addFreezableAddresses(address[] addrs) public onlyOwner returns(bool success) {
287         for (uint256 i = 0; i < addrs.length; i++) {
288             if (addFreezableAddress(addrs[i])) {
289                 success = true;
290             }
291         }
292     }
293 
294     function addFreezableAddress(address addr) public onlyOwner returns(bool success) {
295         if (!freezeAddresses[addr]) {
296             freezeAddresses[addr] = true;
297             emit FreezableAddressAdded(addr);
298             success = true;
299         }
300     }
301 
302     function removeFreezableAddresses(address[] addrs) public onlyOwner returns(bool success) {
303         for (uint256 i = 0; i < addrs.length; i++) {
304             if (removeFreezableAddress(addrs[i])) {
305                 success = true;
306             }
307         }
308     }
309 
310     function removeFreezableAddress(address addr) public onlyOwner returns(bool success) {
311         if (freezeAddresses[addr]) {
312             freezeAddresses[addr] = false;
313             emit FreezableAddressRemoved(addr);
314             success = true;
315         }
316     }
317 
318     /**
319     */
320     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
321         require(!freezeAddresses[_from]);
322         require(!freezeAddresses[_to]);
323         return super.transferFrom(_from, _to, _value);
324     }
325 
326     /**
327     */
328     function transfer(address _to, uint256 _value) public returns (bool) {
329         require(!freezeAddresses[msg.sender]);
330         require(!freezeAddresses[_to]);
331         return super.transfer(_to, _value);
332     }
333 }
334 
335 
336 
337 /**
338  * @title TransferableToken
339  */
340 contract TransferableToken is StandardToken, Ownable {
341     bool public isLock;
342 
343     mapping (address => bool) public transferableAddresses;
344 
345     constructor() public {
346         isLock = true;
347         transferableAddresses[msg.sender] = true;
348     }
349 
350     event Unlock();
351     event TransferableAddressAdded(address indexed addr);
352     event TransferableAddressRemoved(address indexed addr);
353 
354     function unlock() public onlyOwner {
355         isLock = false;
356         emit Unlock();
357     }
358 
359     function isTransferable(address addr) public view returns(bool) {
360         return !isLock || transferableAddresses[addr];
361     }
362 
363     function addTransferableAddresses(address[] addrs) public onlyOwner returns(bool success) {
364         for (uint256 i = 0; i < addrs.length; i++) {
365             if (addTransferableAddress(addrs[i])) {
366                 success = true;
367             }
368         }
369     }
370 
371     function addTransferableAddress(address addr) public onlyOwner returns(bool success) {
372         if (!transferableAddresses[addr]) {
373             transferableAddresses[addr] = true;
374             emit TransferableAddressAdded(addr);
375             success = true;
376         }
377     }
378 
379     function removeTransferableAddresses(address[] addrs) public onlyOwner returns(bool success) {
380         for (uint256 i = 0; i < addrs.length; i++) {
381             if (removeTransferableAddress(addrs[i])) {
382                 success = true;
383             }
384         }
385     }
386 
387     function removeTransferableAddress(address addr) public onlyOwner returns(bool success) {
388         if (transferableAddresses[addr]) {
389             transferableAddresses[addr] = false;
390             emit TransferableAddressRemoved(addr);
391             success = true;
392         }
393     }
394 
395     /**
396     */
397     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
398         require(isTransferable(_from));
399         return super.transferFrom(_from, _to, _value);
400     }
401 
402     /**
403     */
404     function transfer(address _to, uint256 _value) public returns (bool) {
405         require(isTransferable(msg.sender));
406         return super.transfer(_to, _value);
407     }
408 }
409 
410 
411 
412 
413 /**
414  * @title Pausable
415  * @dev Base contract which allows children to implement an emergency stop mechanism.
416  */
417 contract Pausable is Ownable {
418     event Pause();
419     event Unpause();
420 
421     bool public paused = false;
422 
423 
424     /**
425      * @dev Modifier to make a function callable only when the contract is not paused.
426      */
427     modifier whenNotPaused() {
428         require(!paused);
429         _;
430     }
431 
432     /**
433      * @dev Modifier to makeWhitelist a function callable only when the contract is paused.
434      */
435     modifier whenPaused() {
436         require(paused);
437         _;
438     }
439 
440     /**
441      * @dev called by the owner to pause, triggers stopped state
442      */
443     function pause() onlyOwner whenNotPaused public {
444         paused = true;
445         emit Pause();
446     }
447 
448     /**
449      * @dev called by the owner to unpause, returns to normal state
450      */
451     function unpause() onlyOwner whenPaused public {
452         paused = false;
453         emit Unpause();
454     }
455 }
456 
457 
458 /**
459  * @title Pausable tokens
460  * @dev StandardToken modified with pausable transfers.
461  **/
462 contract PausableToken is StandardToken, Pausable {
463 
464     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
465         return super.transfer(_to, _value);
466     }
467 
468     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
469         return super.transferFrom(_from, _to, _value);
470     }
471 
472     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
473         return super.approve(_spender, _value);
474     }
475 
476     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
477         return super.increaseApproval(_spender, _addedValue);
478     }
479 
480     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
481         return super.decreaseApproval(_spender, _subtractedValue);
482     }
483 }
484 
485 
486 
487 /**
488  * @title Mintable token
489  * @dev Simple ERC20 Token example, with mintable token creation
490  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
491  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
492  */
493 contract MintableToken is StandardToken, Ownable {
494     event Mint(address indexed to, uint256 amount);
495     event MintFinished();
496 
497     bool public mintingFinished = false;
498 
499 
500     modifier canMint() {
501         require(!mintingFinished);
502         _;
503     }
504 
505     /**
506      * @dev Function to mint tokens
507      * @param _to The address that will receive the minted tokens.
508      * @param _amount The amount of tokens to mint.
509      * @return A boolean that indicates if the operation was successful.
510      */
511     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
512         totalSupply_ = totalSupply_.add(_amount);
513         balances[_to] = balances[_to].add(_amount);
514         emit Mint(_to, _amount);
515         emit Transfer(address(0), _to, _amount);
516         return true;
517     }
518 
519     /**
520      * @dev Function to stop minting new tokens.
521      * @return True if the operation was successful.
522      */
523     function finishMinting() onlyOwner canMint public returns (bool) {
524         mintingFinished = true;
525         emit MintFinished();
526         return true;
527     }
528 }
529 
530 
531 
532 /**
533  * @title Burnable Token
534  * @dev Token that can be irreversibly burned (destroyed).
535  */
536 contract BurnableToken is BasicToken, Pausable {
537 
538     event Burn(address indexed burner, uint256 value);
539 
540     /**
541      * @dev Burns a specific amount of tokens.
542      * @param _value The amount of tokens to be burned.
543      */
544     function burn(uint256 _value) whenNotPaused public {
545         _burn(msg.sender, _value);
546     }
547 
548     function _burn(address _who, uint256 _value) internal {
549         require(_value <= balances[_who]);
550         // no need to require value <= totalSupply, since that would imply the
551         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
552 
553         balances[_who] = balances[_who].sub(_value);
554         totalSupply_ = totalSupply_.sub(_value);
555         emit Burn(_who, _value);
556         emit Transfer(_who, address(0), _value);
557     }
558 }
559 
560 
561 /**
562  * @title MainToken
563  */
564 contract MainToken is Consts, FreezableToken, TransferableToken, PausableToken, MintableToken, BurnableToken {
565     string public constant name = TOKEN_NAME; // solium-disable-line uppercase
566     string public constant symbol = TOKEN_SYMBOL; // solium-disable-line uppercase
567     uint8 public constant decimals = TOKEN_DECIMALS; // solium-disable-line uppercase
568 
569     uint256 public constant INITIAL_SUPPLY = TOKEN_AMOUNT * (10 ** uint256(decimals));
570 
571     constructor() public {
572         totalSupply_ = INITIAL_SUPPLY;
573         balances[msg.sender] = INITIAL_SUPPLY;
574         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
575     }
576 }