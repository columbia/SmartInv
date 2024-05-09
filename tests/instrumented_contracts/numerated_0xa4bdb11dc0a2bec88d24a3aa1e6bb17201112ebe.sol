1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59     function totalSupply() public view returns (uint256);
60     function balanceOf(address who) public view returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender)
71         public view returns (uint256);
72 
73     function transferFrom(address from, address to, uint256 value)
74         public returns (bool);
75 
76     function approve(address spender, uint256 value) public returns (bool);
77     event Approval(
78         address indexed owner,
79         address indexed spender,
80         uint256 value
81     );
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90     address public owner;
91 
92 
93     event OwnershipRenounced(address indexed previousOwner);
94     event OwnershipTransferred(
95         address indexed previousOwner,
96         address indexed newOwner
97     );
98 
99 
100     /**
101      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102      * account.
103      */
104     constructor() public {
105         owner = msg.sender;
106     }
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115 
116     /**
117      * @dev Allows the current owner to relinquish control of the contract.
118      * @notice Renouncing to ownership will leave the contract without an owner.
119      * It will not be possible to call the functions with the `onlyOwner`
120      * modifier anymore.
121      */
122     function renounceOwnership() public onlyOwner {
123         emit OwnershipRenounced(owner);
124         owner = address(0);
125     }
126 
127     /**
128      * @dev Allows the current owner to transfer control of the contract to a newOwner.
129      * @param _newOwner The address to transfer ownership to.
130      */
131     function transferOwnership(address _newOwner) public onlyOwner {
132         _transferOwnership(_newOwner);
133     }
134 
135     /**
136      * @dev Transfers control of the contract to a newOwner.
137      * @param _newOwner The address to transfer ownership to.
138      */
139     function _transferOwnership(address _newOwner) internal {
140         require(_newOwner != address(0));
141         emit OwnershipTransferred(owner, _newOwner);
142         owner = _newOwner;
143     }
144 }
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151     using SafeMath for uint256;
152 
153     mapping(address => uint256) balances;
154 
155     uint256 totalSupply_;
156 
157     /**
158     * @dev Total number of tokens in existence
159     */
160     function totalSupply() public view returns (uint256) {
161         return totalSupply_;
162     }
163 
164     /**
165     * @dev Transfer token for a specified address
166     * @param _to The address to transfer to.
167     * @param _value The amount to be transferred.
168     */
169     function transfer(address _to, uint256 _value) public returns (bool) {
170         require(_to != address(0));
171         require(_value <= balances[msg.sender]);
172 
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /**
180     * @dev Gets the balance of the specified address.
181     * @param _owner The address to query the the balance of.
182     * @return An uint256 representing the amount owned by the passed address.
183     */
184     function balanceOf(address _owner) public view returns (uint256) {
185         return balances[_owner];
186     }
187 
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/issues/20
195  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199     mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202     /**
203      * @dev Transfer tokens from one address to another
204      * @param _from address The address which you want to send tokens from
205      * @param _to address The address which you want to transfer to
206      * @param _value uint256 the amount of tokens to be transferred
207      */
208     function transferFrom(
209         address _from,
210         address _to,
211         uint256 _value
212     )
213         public
214         returns (bool)
215     {
216         require(_to != address(0));
217         require(_value <= balances[_from]);
218         require(_value <= allowed[_from][msg.sender]);
219 
220         balances[_from] = balances[_from].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223         emit Transfer(_from, _to, _value);
224         return true;
225     }
226 
227     /**
228      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229      * Beware that changing an allowance with this method brings the risk that someone may use both the old
230      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      * @param _spender The address which will spend the funds.
234      * @param _value The amount of tokens to be spent.
235      */
236     function approve(address _spender, uint256 _value) public returns (bool) {
237         allowed[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241 
242     /**
243      * @dev Function to check the amount of tokens that an owner allowed to a spender.
244      * @param _owner address The address which owns the funds.
245      * @param _spender address The address which will spend the funds.
246      * @return A uint256 specifying the amount of tokens still available for the spender.
247      */
248     function allowance(
249         address _owner,
250         address _spender
251      )
252         public
253         view
254         returns (uint256)
255     {
256         return allowed[_owner][_spender];
257     }
258 
259     /**
260      * @dev Increase the amount of tokens that an owner allowed to a spender.
261      * approve should be called when allowed[_spender] == 0. To increment
262      * allowed value is better to use this function to avoid 2 calls (and wait until
263      * the first transaction is mined)
264      * From MonolithDAO Token.sol
265      * @param _spender The address which will spend the funds.
266      * @param _addedValue The amount of tokens to increase the allowance by.
267      */
268     function increaseApproval(
269         address _spender,
270         uint256 _addedValue
271     )
272         public
273         returns (bool)
274     {
275         allowed[msg.sender][_spender] = (
276             allowed[msg.sender][_spender].add(_addedValue));
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281     /**
282      * @dev Decrease the amount of tokens that an owner allowed to a spender.
283      * approve should be called when allowed[_spender] == 0. To decrement
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * @param _spender The address which will spend the funds.
288      * @param _subtractedValue The amount of tokens to decrease the allowance by.
289      */
290     function decreaseApproval(
291         address _spender,
292         uint256 _subtractedValue
293     )
294         public
295         returns (bool)
296     {
297         uint256 oldValue = allowed[msg.sender][_spender];
298         if (_subtractedValue > oldValue) {
299             allowed[msg.sender][_spender] = 0;
300         } else {
301             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302         }
303         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 
307 }
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314     event Pause();
315     event Unpause();
316 
317     bool public paused = false;
318 
319 
320     /**
321      * @dev Modifier to make a function callable only when the contract is not paused.
322      */
323     modifier whenNotPaused() {
324         require(!paused);
325         _;
326     }
327 
328     /**
329      * @dev Modifier to make a function callable only when the contract is paused.
330      */
331     modifier whenPaused() {
332         require(paused);
333         _;
334     }
335 
336     /**
337      * @dev called by the owner to pause, triggers stopped state
338      */
339     function pause() onlyOwner whenNotPaused public {
340         paused = true;
341         emit Pause();
342     }
343 
344     /**
345      * @dev called by the owner to unpause, returns to normal state
346      */
347     function unpause() onlyOwner whenPaused public {
348         paused = false;
349         emit Unpause();
350     }
351 }
352 
353 /**
354  * @title Pausable token
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 contract PausableToken is StandardToken, Pausable {
358 
359     function transfer(
360         address _to,
361         uint256 _value
362     )
363         public
364         whenNotPaused
365         returns (bool)
366     {
367         return super.transfer(_to, _value);
368     }
369 
370     function transferFrom(
371         address _from,
372         address _to,
373         uint256 _value
374     )
375         public
376         whenNotPaused
377         returns (bool)
378     {
379         return super.transferFrom(_from, _to, _value);
380     }
381 
382     function approve(
383         address _spender,
384         uint256 _value
385     )
386         public
387         whenNotPaused
388         returns (bool)
389     {
390         return super.approve(_spender, _value);
391     }
392 
393     function increaseApproval(
394         address _spender,
395         uint _addedValue
396     )
397         public
398         whenNotPaused
399         returns (bool success)
400     {
401         return super.increaseApproval(_spender, _addedValue);
402     }
403 
404     function decreaseApproval(
405         address _spender,
406         uint _subtractedValue
407     )
408         public
409         whenNotPaused
410         returns (bool success)
411     {
412         return super.decreaseApproval(_spender, _subtractedValue);
413     }
414 }
415 
416 /**
417  * @title Burnable Token
418  * @dev Token that can be irreversibly burned (destroyed).
419  */
420 contract BurnableToken is BasicToken {
421 
422     event Burn(address indexed burner, uint256 value);
423 
424     /**
425      * @dev Burns a specific amount of tokens.
426      * @param _value The amount of token to be burned.
427      */
428     function burn(uint256 _value) public {
429         _burn(msg.sender, _value);
430     }
431 
432     function _burn(address _who, uint256 _value) internal {
433         require(_value <= balances[_who]);
434         // no need to require value <= totalSupply, since that would imply the
435         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
436 
437         balances[_who] = balances[_who].sub(_value);
438         totalSupply_ = totalSupply_.sub(_value);
439         emit Burn(_who, _value);
440         emit Transfer(_who, address(0), _value);
441     }
442 }
443 
444 /**
445  * @title Standard Burnable Token
446  * @dev Adds burnFrom method to ERC20 implementations
447  */
448 contract StandardBurnableToken is BurnableToken, StandardToken {
449 
450     /**
451      * @dev Burns a specific amount of tokens from the target address and decrements allowance
452      * @param _from address The address which you want to send tokens from
453      * @param _value uint256 The amount of token to be burned
454      */
455     function burnFrom(address _from, uint256 _value) public {
456         require(_value <= allowed[_from][msg.sender]);
457         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
458         // this function needs to emit an event with the updated approval.
459         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
460         _burn(_from, _value);
461     }
462 }
463 
464 /**
465  * @title Issuable token
466  */
467 contract IssuableToken is StandardToken, Ownable, Pausable {
468 
469     event Mint(address indexed to, uint256 amount);
470     event IssuerAdded(address indexed newIssuer);
471     event IssuerRemoved(address indexed removedIssuer);
472 
473     mapping (address => bool) public issuers;
474 
475     modifier onlyIssuer() {
476         require(issuers[msg.sender]);
477         _;
478     }
479 
480     /**
481      * @dev Authorize an issuer
482      */
483     function addIssuer(address newIssuer) onlyOwner public {
484         issuers[newIssuer] = true;
485         emit IssuerAdded(newIssuer);
486     }
487 
488     /**
489      * @dev Deauthorize an issuer
490      */
491     function removeIssuer(address removedIssuer) public onlyOwner {
492         issuers[removedIssuer] = false;
493         emit IssuerRemoved(removedIssuer);
494     }
495 
496     /**
497      * @dev Function to issue tokens to an address
498      * @param _to The address that will receive the minted tokens.
499      * @param _amount The amount of tokens to mint.
500      * @return A boolean that indicates if the operation was successful.
501      */
502     function issueTo(address _to, uint256 _amount) public onlyIssuer whenNotPaused returns (bool) {
503         totalSupply_ = totalSupply_.add(_amount);
504         balances[_to] = balances[_to].add(_amount);
505         emit Mint(_to, _amount);
506         emit Transfer(address(0), _to, _amount);
507         return true;
508     }
509 
510     /**
511      * @dev Function to issue tokens to the caller
512      */
513     function issue(uint256 _amount) public onlyIssuer whenNotPaused returns (bool) {
514         issueTo(msg.sender, _amount);
515         return true;
516     }
517 
518 }
519 
520 contract StablyFiatToken is StandardBurnableToken, IssuableToken, PausableToken {
521 
522     string public name;
523     string public symbol;
524     uint public decimals;
525 
526     constructor (
527         uint256 initialSupply,
528         string tokenName,
529         string tokenSymbol,
530         uint tokenDecimals
531         ) {
532         balances[msg.sender] = initialSupply; 
533         totalSupply_ = initialSupply; 
534         name = tokenName; 
535         symbol = tokenSymbol; 
536         decimals = tokenDecimals;
537         emit Transfer(address(0), msg.sender, initialSupply);
538         emit Mint(msg.sender, initialSupply);
539     }
540 
541 }