1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 /*
53  * Token related contracts
54  */
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/179
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
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93     using SafeMath for uint256;
94 
95     mapping(address => uint256) balances;
96 
97     uint256 totalSupply_;
98 
99     /**
100     * @dev total number of tokens in existence
101     */
102     function totalSupply() public view returns (uint256) {
103         return totalSupply_;
104     }
105 
106     /**
107     * @dev transfer token for a specified address
108     * @param _to The address to transfer to.
109     * @param _value The amount to be transferred.
110     */
111     function transfer(address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114 
115         balances[msg.sender] = balances[msg.sender].sub(_value);
116         balances[_to] = balances[_to].add(_value);
117         emit Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param _owner The address to query the the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address _owner) public view returns (uint256) {
127         return balances[_owner];
128     }
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143     /**
144      * @dev Transfer tokens from one address to another
145      * @param _from address The address which you want to send tokens from
146      * @param _to address The address which you want to transfer to
147      * @param _value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(
150         address _from,
151         address _to,
152         uint256 _value
153     )
154     public returns (bool)
155     {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169      *
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(
190         address _owner,
191         address _spender
192     )
193     public
194     view
195     returns (uint256)
196     {
197         return allowed[_owner][_spender];
198     }
199 
200     /**
201      * @dev Increase the amount of tokens that an owner allowed to a spender.
202      *
203      * approve should be called when allowed[_spender] == 0. To increment
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * @param _spender The address which will spend the funds.
208      * @param _addedValue The amount of tokens to increase the allowance by.
209      */
210     function increaseApproval(
211         address _spender,
212         uint _addedValue
213     )
214     public
215     returns (bool)
216     {
217         allowed[msg.sender][_spender] = (
218         allowed[msg.sender][_spender].add(_addedValue));
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223     /**
224      * @dev Decrease the amount of tokens that an owner allowed to a spender.
225      *
226      * approve should be called when allowed[_spender] == 0. To decrement
227      * allowed value is better to use this function to avoid 2 calls (and wait until
228      * the first transaction is mined)
229      * From MonolithDAO Token.sol
230      * @param _spender The address which will spend the funds.
231      * @param _subtractedValue The amount of tokens to decrease the allowance by.
232      */
233     function decreaseApproval(
234         address _spender,
235         uint _subtractedValue
236     )
237     public
238     returns (bool)
239     {
240         uint oldValue = allowed[msg.sender][_spender];
241         if (_subtractedValue > oldValue) {
242             allowed[msg.sender][_spender] = 0;
243         } else {
244             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245         }
246         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247         return true;
248     }
249 }
250 
251 
252 /*
253  * Ownable
254  *
255  * Base contract with an owner.
256  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
257  */
258 
259 contract Ownable {
260     address public owner;
261     address public newOwner;
262 
263     function Ownable() public {
264         owner = msg.sender;
265     }
266 
267     modifier onlyOwner() {
268         require(msg.sender == owner);
269         _;
270     }
271 
272     modifier onlyNewOwner() {
273         require(msg.sender == newOwner);
274         _;
275     }
276     /*
277     // This code is dangerous because an error in the newOwner
278     // means that this contract will be ownerless
279     function transfer(address newOwner) public onlyOwner {
280         require(newOwner != address(0));
281         owner = newOwner;
282     }
283    */
284 
285     function proposeNewOwner(address _newOwner) external onlyOwner {
286         require(_newOwner != address(0));
287         newOwner = _newOwner;
288     }
289 
290     function acceptOwnership() external onlyNewOwner {
291         require(newOwner != owner);
292         owner = newOwner;
293     }
294 }
295 
296 
297 
298 /**
299  * @title Mintable token
300  * @dev Simple ERC20 Token example, with mintable token creation
301  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
302  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
303  */
304 contract MintableToken is StandardToken, Ownable {
305     event Mint(address indexed to, uint256 amount);
306     event MintFinished();
307 
308     bool public mintingFinished = false;
309 
310 
311     modifier canMint() {
312         require(!mintingFinished);
313         _;
314     }
315 
316     modifier hasMintPermission() {
317         require(msg.sender == owner);
318         _;
319     }
320 
321     /**
322      * @dev Function to mint tokens
323      * @param _to The address that will receive the minted tokens.
324      * @param _amount The amount of tokens to mint.
325      * @return A boolean that indicates if the operation was successful.
326      */
327     function mint(
328         address _to,
329         uint256 _amount
330     )
331     hasMintPermission
332     canMint
333     public
334     returns (bool)
335     {
336         totalSupply_ = totalSupply_.add(_amount);
337         balances[_to] = balances[_to].add(_amount);
338         emit Mint(_to, _amount);
339         emit Transfer(address(0), _to, _amount);
340         return true;
341     }
342 
343     /**
344      * @dev Function to stop minting new tokens.
345      * @return True if the operation was successful.
346      */
347     function finishMinting() onlyOwner canMint public returns (bool) {
348         mintingFinished = true;
349         emit MintFinished();
350         return true;
351     }
352 }
353 
354 
355 /**
356  * @title Burnable Token
357  * @dev Token that can be irreversibly burned (destroyed).
358  */
359 contract BurnableToken is BasicToken {
360 
361     event Burn(address indexed burner, uint256 value);
362 
363     /**
364      * @dev Burns a specific amount of tokens.
365      * @param _value The amount of token to be burned.
366      */
367     function burn(uint256 _value) public {
368         _burn(msg.sender, _value);
369     }
370 
371     function _burn(address _who, uint256 _value) internal {
372         require(_value <= balances[_who]);
373         // no need to require value <= totalSupply, since that would imply the
374         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
375 
376         balances[_who] = balances[_who].sub(_value);
377         totalSupply_ = totalSupply_.sub(_value);
378         emit Burn(_who, _value);
379         emit Transfer(_who, address(0), _value);
380     }
381 }
382 
383 
384 
385 /**
386  * @title Pausable
387  * @dev Base contract which allows children to implement an emergency stop mechanism.
388  */
389 contract Pausable is Ownable {
390     event Pause();
391     event Unpause();
392 
393     bool public paused = false;
394 
395 
396     /**
397      * @dev Modifier to make a function callable only when the contract is not paused.
398      */
399     modifier whenNotPaused() {
400         require(!paused);
401         _;
402     }
403 
404     /**
405      * @dev Modifier to make a function callable only when the contract is paused.
406      */
407     modifier whenPaused() {
408         require(paused);
409         _;
410     }
411 
412     /**
413      * @dev called by the owner to pause, triggers stopped state
414      */
415     function pause() onlyOwner whenNotPaused public {
416         paused = true;
417         emit Pause();
418     }
419 
420     /**
421      * @dev called by the owner to unpause, returns to normal state
422      */
423     function unpause() onlyOwner whenPaused public {
424         paused = false;
425         emit Unpause();
426     }
427 }
428 
429 
430 /**
431  * @title Pausable token
432  * @dev StandardToken modified with pausable transfers.
433  **/
434 contract PausableToken is StandardToken, Pausable {
435 
436     function transfer(
437         address _to,
438         uint256 _value
439     )
440     public
441     whenNotPaused
442     returns (bool)
443     {
444         return super.transfer(_to, _value);
445     }
446 
447     function transferFrom(
448         address _from,
449         address _to,
450         uint256 _value
451     )
452     public
453     whenNotPaused
454     returns (bool)
455     {
456         return super.transferFrom(_from, _to, _value);
457     }
458 
459     function approve(
460         address _spender,
461         uint256 _value
462     )
463     public
464     whenNotPaused
465     returns (bool)
466     {
467         return super.approve(_spender, _value);
468     }
469 
470     function increaseApproval(
471         address _spender,
472         uint _addedValue
473     )
474     public
475     whenNotPaused
476     returns (bool success)
477     {
478         return super.increaseApproval(_spender, _addedValue);
479     }
480 
481     function decreaseApproval(
482         address _spender,
483         uint _subtractedValue
484     )
485     public
486     whenNotPaused
487     returns (bool success)
488     {
489         return super.decreaseApproval(_spender, _subtractedValue);
490     }
491 }
492 
493 
494 /*
495  * Actual token contract
496  */
497 
498 contract MoCoToken is BurnableToken, MintableToken, PausableToken {
499     using SafeMath for uint256;
500 
501     string public constant name = "MoCo Token";
502     string public constant symbol = "MoCo";
503     uint public constant decimals = 18;
504     uint256 public totalSupply;
505 
506     function MoCoToken() public {
507         totalSupply = 8000000000 ether;
508         balances[msg.sender] = totalSupply;
509         paused = true;
510     }
511 
512     function activate() external onlyOwner {
513         unpause();
514         finishMinting();
515     }
516 
517     // This method will be used by the crowdsale smart contract
518     // that owns the MoCoToken and will distribute
519     // the tokens to the contributors
520     function initialTransfer(address _to, uint _value) external onlyOwner returns (bool) {
521         require(_to != address(0));
522         require(_value <= balances[msg.sender]);
523 
524         balances[msg.sender] = balances[msg.sender].sub(_value);
525         balances[_to] = balances[_to].add(_value);
526         emit Transfer(msg.sender, _to, _value);
527         return true;
528     }
529 
530 //    function burn(uint256 _amount) public onlyOwner {
531 //        super.burn(_amount);
532 //    }
533 
534 }