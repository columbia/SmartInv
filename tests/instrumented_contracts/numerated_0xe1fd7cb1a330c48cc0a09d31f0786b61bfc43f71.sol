1 pragma solidity ^0.4.24;
2 
3 // Based on https://github.com/OpenZeppelin/zeppelin-solidity
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62     function totalSupply() public view returns (uint256);
63     function balanceOf(address who) public view returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74     function allowance(address owner, address spender)
75     public view returns (uint256);
76 
77     function transferFrom(address from, address to, uint256 value)
78     public returns (bool);
79 
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 }
87 
88 
89 /**
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances.
92  */
93 contract BasicToken is ERC20Basic {
94     using SafeMath for uint256;
95 
96     mapping(address => uint256) balances;
97 
98     uint256 totalSupply_;
99 
100     /**
101     * @dev Total number of tokens in existence
102     */
103     function totalSupply() public view returns (uint256) {
104         return totalSupply_;
105     }
106 
107     /**
108     * @dev Transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114         require(_value <= balances[msg.sender]);
115 
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         emit Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param _owner The address to query the the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address _owner) public view returns (uint256) {
128         return balances[_owner];
129     }
130 
131 }
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * https://github.com/ethereum/EIPs/issues/20
139  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143     mapping (address => mapping (address => uint256)) internal allowed;
144 
145 
146     /**
147      * @dev Transfer tokens from one address to another
148      * @param _from address The address which you want to send tokens from
149      * @param _to address The address which you want to transfer to
150      * @param _value uint256 the amount of tokens to be transferred
151      */
152     function transferFrom(
153         address _from,
154         address _to,
155         uint256 _value
156     )
157     public
158     returns (bool)
159     {
160         require(_to != address(0));
161         require(_value <= balances[_from]);
162         require(_value <= allowed[_from][msg.sender]);
163 
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167         emit Transfer(_from, _to, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param _spender The address which will spend the funds.
178      * @param _value The amount of tokens to be spent.
179      */
180     function approve(address _spender, uint256 _value) public returns (bool) {
181         allowed[msg.sender][_spender] = _value;
182         emit Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Function to check the amount of tokens that an owner allowed to a spender.
188      * @param _owner address The address which owns the funds.
189      * @param _spender address The address which will spend the funds.
190      * @return A uint256 specifying the amount of tokens still available for the spender.
191      */
192     function allowance(
193         address _owner,
194         address _spender
195     )
196     public
197     view
198     returns (uint256)
199     {
200         return allowed[_owner][_spender];
201     }
202 
203     /**
204      * @dev Increase the amount of tokens that an owner allowed to a spender.
205      * approve should be called when allowed[_spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * @param _spender The address which will spend the funds.
210      * @param _addedValue The amount of tokens to increase the allowance by.
211      */
212     function increaseApproval(
213         address _spender,
214         uint256 _addedValue
215     )
216     public
217     returns (bool)
218     {
219         allowed[msg.sender][_spender] = (
220         allowed[msg.sender][_spender].add(_addedValue));
221         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225     /**
226      * @dev Decrease the amount of tokens that an owner allowed to a spender.
227      * approve should be called when allowed[_spender] == 0. To decrement
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * @param _spender The address which will spend the funds.
232      * @param _subtractedValue The amount of tokens to decrease the allowance by.
233      */
234     function decreaseApproval(
235         address _spender,
236         uint256 _subtractedValue
237     )
238     public
239     returns (bool)
240     {
241         uint256 oldValue = allowed[msg.sender][_spender];
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248         return true;
249     }
250 
251 }
252 
253 
254 /**
255  * @title Ownable
256  * @dev The Ownable contract has an owner address, and provides basic authorization control
257  * functions, this simplifies the implementation of "user permissions".
258  */
259 contract Ownable {
260     address public owner;
261 
262 
263     event OwnershipRenounced(address indexed previousOwner);
264     event OwnershipTransferred(
265         address indexed previousOwner,
266         address indexed newOwner
267     );
268 
269 
270     /**
271      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
272      * account.
273      */
274     constructor() public {
275         owner = msg.sender;
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         require(msg.sender == owner);
283         _;
284     }
285 
286     /**
287      * @dev Allows the current owner to relinquish control of the contract.
288      * @notice Renouncing to ownership will leave the contract without an owner.
289      * It will not be possible to call the functions with the `onlyOwner`
290      * modifier anymore.
291      */
292     function renounceOwnership() public onlyOwner {
293         emit OwnershipRenounced(owner);
294         owner = address(0);
295     }
296 
297     /**
298      * @dev Allows the current owner to transfer control of the contract to a newOwner.
299      * @param _newOwner The address to transfer ownership to.
300      */
301     function transferOwnership(address _newOwner) public onlyOwner {
302         _transferOwnership(_newOwner);
303     }
304 
305     /**
306      * @dev Transfers control of the contract to a newOwner.
307      * @param _newOwner The address to transfer ownership to.
308      */
309     function _transferOwnership(address _newOwner) internal {
310         require(_newOwner != address(0));
311         emit OwnershipTransferred(owner, _newOwner);
312         owner = _newOwner;
313     }
314 }
315 
316 
317 /**
318  * @title Pausable
319  * @dev Base contract which allows children to implement an emergency stop mechanism.
320  */
321 contract Pausable is Ownable {
322     event Pause();
323     event Unpause();
324 
325     bool public paused = false;
326 
327 
328     /**
329      * @dev Modifier to make a function callable only when the contract is not paused.
330      */
331     modifier whenNotPaused() {
332         require(!paused);
333         _;
334     }
335 
336     /**
337      * @dev Modifier to make a function callable only when the contract is paused.
338      */
339     modifier whenPaused() {
340         require(paused);
341         _;
342     }
343 
344     /**
345      * @dev called by the owner to pause, triggers stopped state
346      */
347     function pause() onlyOwner whenNotPaused public {
348         paused = true;
349         emit Pause();
350     }
351 
352     /**
353      * @dev called by the owner to unpause, returns to normal state
354      */
355     function unpause() onlyOwner whenPaused public {
356         paused = false;
357         emit Unpause();
358     }
359 }
360 
361 
362 /**
363  * @title Pausable token
364  * @dev StandardToken modified with pausable transfers.
365  **/
366 contract PausableToken is StandardToken, Pausable {
367 
368     function transfer(
369         address _to,
370         uint256 _value
371     )
372     public
373     whenNotPaused
374     returns (bool)
375     {
376         return super.transfer(_to, _value);
377     }
378 
379     function transferFrom(
380         address _from,
381         address _to,
382         uint256 _value
383     )
384     public
385     whenNotPaused
386     returns (bool)
387     {
388         return super.transferFrom(_from, _to, _value);
389     }
390 
391     function approve(
392         address _spender,
393         uint256 _value
394     )
395     public
396     whenNotPaused
397     returns (bool)
398     {
399         return super.approve(_spender, _value);
400     }
401 
402     function increaseApproval(
403         address _spender,
404         uint _addedValue
405     )
406     public
407     whenNotPaused
408     returns (bool success)
409     {
410         return super.increaseApproval(_spender, _addedValue);
411     }
412 
413     function decreaseApproval(
414         address _spender,
415         uint _subtractedValue
416     )
417     public
418     whenNotPaused
419     returns (bool success)
420     {
421         return super.decreaseApproval(_spender, _subtractedValue);
422     }
423 }
424 
425 
426 /**
427  * @title Mintable token
428  * @dev Simple ERC20 Token example, with mintable token creation
429  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
430  */
431 contract MintableToken is StandardToken, Ownable {
432     event Mint(address indexed to, uint256 amount);
433     event MintFinished();
434 
435     bool public mintingFinished = false;
436 
437 
438     modifier canMint() {
439         require(!mintingFinished);
440         _;
441     }
442 
443     modifier hasMintPermission() {
444         require(msg.sender == owner);
445         _;
446     }
447 
448     /**
449      * @dev Function to mint tokens
450      * @param _to The address that will receive the minted tokens.
451      * @param _amount The amount of tokens to mint.
452      * @return A boolean that indicates if the operation was successful.
453      */
454     function mint(
455         address _to,
456         uint256 _amount
457     )
458     hasMintPermission
459     canMint
460     public
461     returns (bool)
462     {
463         totalSupply_ = totalSupply_.add(_amount);
464         balances[_to] = balances[_to].add(_amount);
465         emit Mint(_to, _amount);
466         emit Transfer(address(0), _to, _amount);
467         return true;
468     }
469 
470     /**
471      * @dev Function to stop minting new tokens.
472      * @return True if the operation was successful.
473      */
474     function finishMinting() onlyOwner canMint public returns (bool) {
475         mintingFinished = true;
476         emit MintFinished();
477         return true;
478     }
479 }
480 
481 
482 /**
483  * @title Burnable Token
484  * @dev Token that can be irreversibly burned (destroyed).
485  */
486 contract BurnableToken is BasicToken {
487 
488     event Burn(address indexed burner, uint256 value);
489 
490     /**
491      * @dev Burns a specific amount of tokens.
492      * @param _value The amount of token to be burned.
493      */
494     function burn(uint256 _value) public {
495         _burn(msg.sender, _value);
496     }
497 
498     function _burn(address _who, uint256 _value) internal {
499         require(_value <= balances[_who]);
500         // no need to require value <= totalSupply, since that would imply the
501         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
502 
503         balances[_who] = balances[_who].sub(_value);
504         totalSupply_ = totalSupply_.sub(_value);
505         emit Burn(_who, _value);
506         emit Transfer(_who, address(0), _value);
507     }
508 }
509 
510 
511 /**
512  * @title ABOToken
513  * @dev ABOToken Mintable Token with migration from legacy contract
514  */
515 contract ABOToken is PausableToken, MintableToken, BurnableToken {
516     using SafeMath for uint256;
517 
518     // Public variables of the token
519     string public name;
520     string public symbol;
521     uint256 public decimals;
522 
523     // Creator of contract
524     address public creator;
525 
526     /**
527      * Set up the initialization parameter
528      */
529     constructor() public {
530         // Init contract variables
531         name = "ABOChain Token";
532         symbol = "ABO";
533         decimals = 18;
534         // 1 ether equal 10^18(decimals)
535         totalSupply_ = 50 * 10000 * 10000 * 1 ether;
536 
537         // Give all init tokens to creator
538         balances[msg.sender] = totalSupply_;
539         creator = msg.sender;
540     }
541 
542 
543     // Send back eth to msg.sender
544     function () external payable {
545         revert();
546     }
547 }