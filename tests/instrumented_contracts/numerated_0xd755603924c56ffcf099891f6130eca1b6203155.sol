1 pragma solidity ^0.4.24;
2 
3 /** CEUZ - Effective Medium of Exchange, Stable Unit of Account and Reliable Store of Value
4  * 
5  * Stablecoin pegged to fiat EUR at 1:1 ratio
6 
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     /**
13     * @dev Multiplies two numbers, throws on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         // uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return a / b;
36     }
37 
38     /**
39     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50         c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
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
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender)
74         public view returns (uint256);
75 
76     function transferFrom(address from, address to, uint256 value)
77         public returns (bool);
78 
79     function approve(address spender, uint256 value) public returns (bool);
80     event Approval(
81         address indexed owner,
82         address indexed spender,
83         uint256 value
84     );
85 }
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93     address public owner;
94 
95 
96     event OwnershipRenounced(address indexed previousOwner);
97     event OwnershipTransferred(
98         address indexed previousOwner,
99         address indexed newOwner
100     );
101 
102 
103     /**
104      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105      * account.
106      */
107     constructor() public {
108         owner = msg.sender;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118 
119     /**
120      * @dev Allows the current owner to relinquish control of the contract.
121      * @notice Renouncing to ownership will leave the contract without an owner.
122      * It will not be possible to call the functions with the `onlyOwner`
123      * modifier anymore.
124      */
125     function renounceOwnership() public onlyOwner {
126         emit OwnershipRenounced(owner);
127         owner = address(0);
128     }
129 
130     /**
131      * @dev Allows the current owner to transfer control of the contract to a newOwner.
132      * @param _newOwner The address to transfer ownership to.
133      */
134     function transferOwnership(address _newOwner) public onlyOwner {
135         _transferOwnership(_newOwner);
136     }
137 
138     /**
139      * @dev Transfers control of the contract to a newOwner.
140      * @param _newOwner The address to transfer ownership to.
141      */
142     function _transferOwnership(address _newOwner) internal {
143         require(_newOwner != address(0));
144         emit OwnershipTransferred(owner, _newOwner);
145         owner = _newOwner;
146     }
147 }
148 
149 /**
150  * @title Basic token
151  * @dev Basic version of StandardToken, with no allowances.
152  */
153 contract BasicToken is ERC20Basic {
154     using SafeMath for uint256;
155 
156     mapping(address => uint256) balances;
157 
158     uint256 totalSupply_;
159 
160     /**
161     * @dev Total number of tokens in existence
162     */
163     function totalSupply() public view returns (uint256) {
164         return totalSupply_;
165     }
166 
167     /**
168     * @dev Transfer token for a specified address
169     * @param _to The address to transfer to.
170     * @param _value The amount to be transferred.
171     */
172     function transfer(address _to, uint256 _value) public returns (bool) {
173         require(_to != address(0));
174         require(_value <= balances[msg.sender]);
175 
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         emit Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     /**
183     * @dev Gets the balance of the specified address.
184     * @param _owner The address to query the the balance of.
185     * @return An uint256 representing the amount owned by the passed address.
186     */
187     function balanceOf(address _owner) public view returns (uint256) {
188         return balances[_owner];
189     }
190 
191 }
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/issues/20
198  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202     mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205     /**
206      * @dev Transfer tokens from one address to another
207      * @param _from address The address which you want to send tokens from
208      * @param _to address The address which you want to transfer to
209      * @param _value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(
212         address _from,
213         address _to,
214         uint256 _value
215     )
216         public
217         returns (bool)
218     {
219         require(_to != address(0));
220         require(_value <= balances[_from]);
221         require(_value <= allowed[_from][msg.sender]);
222 
223         balances[_from] = balances[_from].sub(_value);
224         balances[_to] = balances[_to].add(_value);
225         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226         emit Transfer(_from, _to, _value);
227         return true;
228     }
229 
230     /**
231      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232      * Beware that changing an allowance with this method brings the risk that someone may use both the old
233      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      * @param _spender The address which will spend the funds.
237      * @param _value The amount of tokens to be spent.
238      */
239     function approve(address _spender, uint256 _value) public returns (bool) {
240         allowed[msg.sender][_spender] = _value;
241         emit Approval(msg.sender, _spender, _value);
242         return true;
243     }
244 
245     /**
246      * @dev Function to check the amount of tokens that an owner allowed to a spender.
247      * @param _owner address The address which owns the funds.
248      * @param _spender address The address which will spend the funds.
249      * @return A uint256 specifying the amount of tokens still available for the spender.
250      */
251     function allowance(
252         address _owner,
253         address _spender
254      )
255         public
256         view
257         returns (uint256)
258     {
259         return allowed[_owner][_spender];
260     }
261 
262     /**
263      * @dev Increase the amount of tokens that an owner allowed to a spender.
264      * approve should be called when allowed[_spender] == 0. To increment
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * @param _spender The address which will spend the funds.
269      * @param _addedValue The amount of tokens to increase the allowance by.
270      */
271     function increaseApproval(
272         address _spender,
273         uint256 _addedValue
274     )
275         public
276         returns (bool)
277     {
278         allowed[msg.sender][_spender] = (
279             allowed[msg.sender][_spender].add(_addedValue));
280         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281         return true;
282     }
283 
284     /**
285      * @dev Decrease the amount of tokens that an owner allowed to a spender.
286      * approve should be called when allowed[_spender] == 0. To decrement
287      * allowed value is better to use this function to avoid 2 calls (and wait until
288      * the first transaction is mined)
289      * From MonolithDAO Token.sol
290      * @param _spender The address which will spend the funds.
291      * @param _subtractedValue The amount of tokens to decrease the allowance by.
292      */
293     function decreaseApproval(
294         address _spender,
295         uint256 _subtractedValue
296     )
297         public
298         returns (bool)
299     {
300         uint256 oldValue = allowed[msg.sender][_spender];
301         if (_subtractedValue > oldValue) {
302             allowed[msg.sender][_spender] = 0;
303         } else {
304             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305         }
306         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307         return true;
308     }
309 
310 }
311 
312 /**
313  * @title Pausable
314  * @dev Base contract which allows children to implement an emergency stop mechanism.
315  */
316 contract Pausable is Ownable {
317     event Pause();
318     event Unpause();
319 
320     bool public paused = false;
321 
322 
323     /**
324      * @dev Modifier to make a function callable only when the contract is not paused.
325      */
326     modifier whenNotPaused() {
327         require(!paused);
328         _;
329     }
330 
331     /**
332      * @dev Modifier to make a function callable only when the contract is paused.
333      */
334     modifier whenPaused() {
335         require(paused);
336         _;
337     }
338 
339     /**
340      * @dev called by the owner to pause, triggers stopped state
341      */
342     function pause() onlyOwner whenNotPaused public {
343         paused = true;
344         emit Pause();
345     }
346 
347     /**
348      * @dev called by the owner to unpause, returns to normal state
349      */
350     function unpause() onlyOwner whenPaused public {
351         paused = false;
352         emit Unpause();
353     }
354 }
355 
356 /**
357  * @title Pausable token
358  * @dev StandardToken modified with pausable transfers.
359  **/
360 contract PausableToken is StandardToken, Pausable {
361 
362     function transfer(
363         address _to,
364         uint256 _value
365     )
366         public
367         whenNotPaused
368         returns (bool)
369     {
370         return super.transfer(_to, _value);
371     }
372 
373     function transferFrom(
374         address _from,
375         address _to,
376         uint256 _value
377     )
378         public
379         whenNotPaused
380         returns (bool)
381     {
382         return super.transferFrom(_from, _to, _value);
383     }
384 
385     function approve(
386         address _spender,
387         uint256 _value
388     )
389         public
390         whenNotPaused
391         returns (bool)
392     {
393         return super.approve(_spender, _value);
394     }
395 
396     function increaseApproval(
397         address _spender,
398         uint _addedValue
399     )
400         public
401         whenNotPaused
402         returns (bool success)
403     {
404         return super.increaseApproval(_spender, _addedValue);
405     }
406 
407     function decreaseApproval(
408         address _spender,
409         uint _subtractedValue
410     )
411         public
412         whenNotPaused
413         returns (bool success)
414     {
415         return super.decreaseApproval(_spender, _subtractedValue);
416     }
417 }
418 
419 /**
420  * @title Burnable Token
421  * @dev Token that can be irreversibly burned (destroyed).
422  */
423 contract BurnableToken is BasicToken {
424 
425     event Burn(address indexed burner, uint256 value);
426 
427     /**
428      * @dev Burns a specific amount of tokens.
429      * @param _value The amount of token to be burned.
430      */
431     function burn(uint256 _value) public {
432         _burn(msg.sender, _value);
433     }
434 
435     function _burn(address _who, uint256 _value) internal {
436         require(_value <= balances[_who]);
437         // no need to require value <= totalSupply, since that would imply the
438         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
439 
440         balances[_who] = balances[_who].sub(_value);
441         totalSupply_ = totalSupply_.sub(_value);
442         emit Burn(_who, _value);
443         emit Transfer(_who, address(0), _value);
444     }
445 }
446 
447 /**
448  * @title Standard Burnable Token
449  * @dev Adds burnFrom method to ERC20 implementations
450  */
451 contract StandardBurnableToken is BurnableToken, StandardToken {
452 
453     /**
454      * @dev Burns a specific amount of tokens from the target address and decrements allowance
455      * @param _from address The address which you want to send tokens from
456      * @param _value uint256 The amount of token to be burned
457      */
458     function burnFrom(address _from, uint256 _value) public {
459         require(_value <= allowed[_from][msg.sender]);
460         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
461         // this function needs to emit an event with the updated approval.
462         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
463         _burn(_from, _value);
464     }
465 }
466 
467 /**
468  * @title Issuable token
469  */
470 contract IssuableToken is StandardToken, Ownable, Pausable {
471 
472     event Mint(address indexed to, uint256 amount);
473     event IssuerAdded(address indexed newIssuer);
474     event IssuerRemoved(address indexed removedIssuer);
475 
476     mapping (address => bool) public issuers;
477 
478     modifier onlyIssuer() {
479         require(issuers[msg.sender]);
480         _;
481     }
482 
483     /**
484      * @dev Authorize an issuer
485      */
486     function addIssuer(address newIssuer) onlyOwner public {
487         issuers[newIssuer] = true;
488         emit IssuerAdded(newIssuer);
489     }
490 
491     /**
492      * @dev Deauthorize an issuer
493      */
494     function removeIssuer(address removedIssuer) public onlyOwner {
495         issuers[removedIssuer] = false;
496         emit IssuerRemoved(removedIssuer);
497     }
498 
499     /**
500      * @dev Function to issue tokens to an address
501      * @param _to The address that will receive the minted tokens.
502      * @param _amount The amount of tokens to mint.
503      * @return A boolean that indicates if the operation was successful.
504      */
505     function issueTo(address _to, uint256 _amount) public onlyIssuer whenNotPaused returns (bool) {
506         totalSupply_ = totalSupply_.add(_amount);
507         balances[_to] = balances[_to].add(_amount);
508         emit Mint(_to, _amount);
509         emit Transfer(address(0), _to, _amount);
510         return true;
511     }
512 
513     /**
514      * @dev Function to issue tokens to the caller
515      */
516     function issue(uint256 _amount) public onlyIssuer whenNotPaused returns (bool) {
517         issueTo(msg.sender, _amount);
518         return true;
519     }
520 
521 }
522 
523 contract CEUZFiatToken is StandardBurnableToken, IssuableToken, PausableToken {
524 
525     string public name;
526     string public symbol;
527     uint public decimals;
528 
529     constructor (
530         uint256 initialSupply,
531         string tokenName,
532         string tokenSymbol,
533         uint tokenDecimals
534         ) {
535         balances[msg.sender] = initialSupply; 
536         totalSupply_ = initialSupply; 
537         name = tokenName; 
538         symbol = tokenSymbol; 
539         decimals = tokenDecimals;
540         emit Transfer(address(0), msg.sender, initialSupply);
541         emit Mint(msg.sender, initialSupply);
542     }
543 
544 }