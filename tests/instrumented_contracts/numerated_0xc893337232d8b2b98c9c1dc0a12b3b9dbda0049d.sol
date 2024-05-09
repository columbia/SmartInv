1 /**
2  * @author https://github.com/Dmitx
3  */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * See https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13     function totalSupply() public view returns (uint256);
14 
15     function balanceOf(address _who) public view returns (uint256);
16 
17     function transfer(address _to, uint256 _value) public returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29     /**
30     * @dev Multiplies two numbers, throws on overflow.
31     */
32     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (_a == 0) {
37             return 0;
38         }
39 
40         c = _a * _b;
41         assert(c / _a == _b);
42         return c;
43     }
44 
45     /**
46     * @dev Integer division of two numbers, truncating the quotient.
47     */
48     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49         // assert(_b > 0); // Solidity automatically throws when dividing by 0
50         // uint256 c = _a / _b;
51         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52         return _a / _b;
53     }
54 
55     /**
56     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59         assert(_b <= _a);
60         return _a - _b;
61     }
62 
63     /**
64     * @dev Adds two numbers, throws on overflow.
65     */
66     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67         c = _a + _b;
68         assert(c >= _a);
69         return c;
70     }
71 }
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) internal balances;
82 
83     uint256 internal totalSupply_;
84 
85     /**
86     * @dev Total number of tokens in existence
87     */
88     function totalSupply() public view returns (uint256) {
89         return totalSupply_;
90     }
91 
92     /**
93     * @dev Transfer token for a specified address
94     * @param _to The address to transfer to.
95     * @param _value The amount to be transferred.
96     */
97     function transfer(address _to, uint256 _value) public returns (bool) {
98         require(_value <= balances[msg.sender]);
99         require(_to != address(0));
100 
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     /**
108     * @dev Gets the balance of the specified address.
109     * @param _owner The address to query the the balance of.
110     * @return An uint256 representing the amount owned by the passed address.
111     */
112     function balanceOf(address _owner) public view returns (uint256) {
113         return balances[_owner];
114     }
115 
116 }
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124     function allowance(address _owner, address _spender) public view returns (uint256);
125 
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
127 
128     function approve(address _spender, uint256 _value) public returns (bool);
129 
130     event Approval(
131         address indexed owner,
132         address indexed spender,
133         uint256 value
134     );
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147     mapping(address => mapping(address => uint256)) internal allowed;
148 
149 
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(
157         address _from,
158         address _to,
159         uint256 _value
160     )
161     public
162     returns (bool)
163     {
164         require(_value <= balances[_from]);
165         require(_value <= allowed[_from][msg.sender]);
166         require(_to != address(0));
167 
168         balances[_from] = balances[_from].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171         emit Transfer(_from, _to, _value);
172         return true;
173     }
174 
175     /**
176      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177      * Beware that changing an allowance with this method brings the risk that someone may use both the old
178      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      * @param _spender The address which will spend the funds.
182      * @param _value The amount of tokens to be spent.
183      */
184     function approve(address _spender, uint256 _value) public returns (bool) {
185         allowed[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     /**
191      * @dev Function to check the amount of tokens that an owner allowed to a spender.
192      * @param _owner address The address which owns the funds.
193      * @param _spender address The address which will spend the funds.
194      * @return A uint256 specifying the amount of tokens still available for the spender.
195      */
196     function allowance(
197         address _owner,
198         address _spender
199     )
200     public
201     view
202     returns (uint256)
203     {
204         return allowed[_owner][_spender];
205     }
206 
207     /**
208      * @dev Increase the amount of tokens that an owner allowed to a spender.
209      * approve should be called when allowed[_spender] == 0. To increment
210      * allowed value is better to use this function to avoid 2 calls (and wait until
211      * the first transaction is mined)
212      * From MonolithDAO Token.sol
213      * @param _spender The address which will spend the funds.
214      * @param _addedValue The amount of tokens to increase the allowance by.
215      */
216     function increaseApproval(
217         address _spender,
218         uint256 _addedValue
219     )
220     public
221     returns (bool)
222     {
223         allowed[msg.sender][_spender] = (
224         allowed[msg.sender][_spender].add(_addedValue));
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     /**
230      * @dev Decrease the amount of tokens that an owner allowed to a spender.
231      * approve should be called when allowed[_spender] == 0. To decrement
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * @param _spender The address which will spend the funds.
236      * @param _subtractedValue The amount of tokens to decrease the allowance by.
237      */
238     function decreaseApproval(
239         address _spender,
240         uint256 _subtractedValue
241     )
242     public
243     returns (bool)
244     {
245         uint256 oldValue = allowed[msg.sender][_spender];
246         if (_subtractedValue >= oldValue) {
247             allowed[msg.sender][_spender] = 0;
248         } else {
249             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250         }
251         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 
255 }
256 
257 
258 /**
259  * @title Ownable
260  * @dev The Ownable contract has an owner address, and provides basic authorization control
261  * functions, this simplifies the implementation of "user permissions".
262  */
263 contract Ownable {
264     address public owner;
265 
266 
267     event OwnershipRenounced(address indexed previousOwner);
268     event OwnershipTransferred(
269         address indexed previousOwner,
270         address indexed newOwner
271     );
272 
273 
274     /**
275      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
276      * account.
277      */
278     constructor() public {
279         owner = msg.sender;
280     }
281 
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         require(msg.sender == owner);
287         _;
288     }
289 
290     /**
291      * @dev Allows the current owner to relinquish control of the contract.
292      * @notice Renouncing to ownership will leave the contract without an owner.
293      * It will not be possible to call the functions with the `onlyOwner`
294      * modifier anymore.
295      */
296     function renounceOwnership() public onlyOwner {
297         emit OwnershipRenounced(owner);
298         owner = address(0);
299     }
300 
301     /**
302      * @dev Allows the current owner to transfer control of the contract to a newOwner.
303      * @param _newOwner The address to transfer ownership to.
304      */
305     function transferOwnership(address _newOwner) public onlyOwner {
306         _transferOwnership(_newOwner);
307     }
308 
309     /**
310      * @dev Transfers control of the contract to a newOwner.
311      * @param _newOwner The address to transfer ownership to.
312      */
313     function _transferOwnership(address _newOwner) internal {
314         require(_newOwner != address(0));
315         emit OwnershipTransferred(owner, _newOwner);
316         owner = _newOwner;
317     }
318 }
319 
320 
321 /**
322  * @title Mintable token
323  * @dev Simple ERC20 Token example, with mintable token creation
324  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
325  */
326 contract MintableToken is StandardToken, Ownable {
327     event Mint(address indexed to, uint256 amount);
328     event MintFinished();
329 
330     bool public mintingFinished = false;
331 
332 
333     modifier canMint() {
334         require(!mintingFinished);
335         _;
336     }
337 
338     modifier hasMintPermission() {
339         require(msg.sender == owner);
340         _;
341     }
342 
343     /**
344      * @dev Function to mint tokens
345      * @param _to The address that will receive the minted tokens.
346      * @param _amount The amount of tokens to mint.
347      * @return A boolean that indicates if the operation was successful.
348      */
349     function mint(
350         address _to,
351         uint256 _amount
352     )
353     public
354     hasMintPermission
355     canMint
356     returns (bool)
357     {
358         totalSupply_ = totalSupply_.add(_amount);
359         balances[_to] = balances[_to].add(_amount);
360         emit Mint(_to, _amount);
361         emit Transfer(address(0), _to, _amount);
362         return true;
363     }
364 
365     /**
366      * @dev Function to stop minting new tokens.
367      * @return True if the operation was successful.
368      */
369     function finishMinting() public onlyOwner canMint returns (bool) {
370         mintingFinished = true;
371         emit MintFinished();
372         return true;
373     }
374 }
375 
376 
377 /**
378  * @title Capped token
379  * @dev Mintable token with a token cap.
380  */
381 contract CappedToken is MintableToken {
382 
383     uint256 public cap;
384 
385     constructor(uint256 _cap) public {
386         require(_cap > 0);
387         cap = _cap;
388     }
389 
390     /**
391      * @dev Function to mint tokens
392      * @param _to The address that will receive the minted tokens.
393      * @param _amount The amount of tokens to mint.
394      * @return A boolean that indicates if the operation was successful.
395      */
396     function mint(
397         address _to,
398         uint256 _amount
399     )
400     public
401     returns (bool)
402     {
403         require(totalSupply_.add(_amount) <= cap);
404 
405         return super.mint(_to, _amount);
406     }
407 
408 }
409 
410 
411 /**
412  * @title Pausable
413  * @dev Base contract which allows children to implement an emergency stop mechanism.
414  */
415 contract Pausable is Ownable {
416     event Pause();
417     event Unpause();
418 
419     bool public paused = false;
420 
421 
422     /**
423      * @dev Modifier to make a function callable only when the contract is not paused.
424      */
425     modifier whenNotPaused() {
426         require(!paused);
427         _;
428     }
429 
430     /**
431      * @dev Modifier to make a function callable only when the contract is paused.
432      */
433     modifier whenPaused() {
434         require(paused);
435         _;
436     }
437 
438     /**
439      * @dev called by the owner to pause, triggers stopped state
440      */
441     function pause() public onlyOwner whenNotPaused {
442         paused = true;
443         emit Pause();
444     }
445 
446     /**
447      * @dev called by the owner to unpause, returns to normal state
448      */
449     function unpause() public onlyOwner whenPaused {
450         paused = false;
451         emit Unpause();
452     }
453 }
454 
455 
456 /**
457  * @title Pausable token
458  * @dev StandardToken modified with pausable transfers.
459  **/
460 contract PausableToken is StandardToken, Pausable {
461 
462     function transfer(
463         address _to,
464         uint256 _value
465     )
466     public
467     whenNotPaused
468     returns (bool)
469     {
470         return super.transfer(_to, _value);
471     }
472 
473     function transferFrom(
474         address _from,
475         address _to,
476         uint256 _value
477     )
478     public
479     whenNotPaused
480     returns (bool)
481     {
482         return super.transferFrom(_from, _to, _value);
483     }
484 
485     function approve(
486         address _spender,
487         uint256 _value
488     )
489     public
490     whenNotPaused
491     returns (bool)
492     {
493         return super.approve(_spender, _value);
494     }
495 
496     function increaseApproval(
497         address _spender,
498         uint _addedValue
499     )
500     public
501     whenNotPaused
502     returns (bool success)
503     {
504         return super.increaseApproval(_spender, _addedValue);
505     }
506 
507     function decreaseApproval(
508         address _spender,
509         uint _subtractedValue
510     )
511     public
512     whenNotPaused
513     returns (bool success)
514     {
515         return super.decreaseApproval(_spender, _subtractedValue);
516     }
517 }
518 
519 
520 /**
521  * @title Powerchain Token
522  * @dev Final token for Powerchain project.
523  */
524 contract PowerchainToken is PausableToken, CappedToken {
525 
526     string public constant name = "POWERCHAIN Token";
527 
528     string public constant symbol = "POWEC";
529 
530     uint8 public constant decimals = 18;
531 
532     // set Max Total Supply in 100 000 000 000 tokens
533     constructor() public
534         CappedToken(1e11 * 1e18) {}
535 
536 }