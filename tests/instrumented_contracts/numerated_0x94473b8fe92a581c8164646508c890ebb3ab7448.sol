1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (_a == 0) {
17             return 0;
18         }
19 
20         uint256 c = _a * _b;
21         require(c / _a == _b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         require(_b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = _a / _b;
32         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41         require(_b <= _a);
42         uint256 c = _a - _b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51         uint256 c = _a + _b;
52         require(c >= _a);
53 
54         return c;
55     }
56 }
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     address public owner;
66 
67 
68     event OwnershipRenounced(address indexed previousOwner);
69     event OwnershipTransferred(
70         address indexed previousOwner,
71         address indexed newOwner
72     );
73 
74 
75     /**
76     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77     * account.
78     */
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83     /**
84     * @dev Throws if called by any account other than the owner.
85     */
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     /**
92     * @dev Allows the current owner to relinquish control of the contract.
93     * @notice Renouncing to ownership will leave the contract without an owner.
94     * It will not be possible to call the functions with the `onlyOwner`
95     * modifier anymore.
96     */
97     function renounceOwnership() public onlyOwner {
98         emit OwnershipRenounced(owner);
99         owner = address(0);
100     }
101 
102     /**
103     * @dev Allows the current owner to transfer control of the contract to a newOwner.
104     * @param _newOwner The address to transfer ownership to.
105     */
106     function transferOwnership(address _newOwner) public onlyOwner {
107         _transferOwnership(_newOwner);
108     }
109 
110     /**
111     * @dev Transfers control of the contract to a newOwner.
112     * @param _newOwner The address to transfer ownership to.
113     */
114     function _transferOwnership(address _newOwner) internal {
115         require(_newOwner != address(0));
116         emit OwnershipTransferred(owner, _newOwner);
117         owner = _newOwner;
118     }
119 }
120 
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126     event Pause();
127     event Unpause();
128 
129     bool public paused = false;
130 
131     /**
132     * @dev Modifier to make a function callable only when the contract is not paused.
133     */
134     modifier whenNotPaused() {
135         require(!paused);
136         _;
137     }
138 
139     /**
140     * @dev Modifier to make a function callable only when the contract is paused.
141     */
142     modifier whenPaused() {
143         require(paused);
144         _;
145     }
146 
147     /**
148     * @dev called by the owner to pause, triggers stopped state
149     */
150     function pause() public onlyOwner whenNotPaused {
151         paused = true;
152         emit Pause();
153     }
154 
155     /**
156     * @dev called by the owner to unpause, returns to normal state
157     */
158     function unpause() public onlyOwner whenPaused {
159         paused = false;
160         emit Unpause();
161     }
162 }
163 
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 {
170     function totalSupply() public view returns (uint256);
171 
172     function balanceOf(address _who) public view returns (uint256);
173 
174     function allowance(address _owner, address _spender)
175         public view returns (uint256);
176 
177     function transfer(address _to, uint256 _value) public returns (bool);
178 
179     function approve(address _spender, uint256 _value)
180         public returns (bool);
181 
182     function transferFrom(address _from, address _to, uint256 _value)
183         public returns (bool);
184 
185     event Transfer(
186         address indexed from,
187         address indexed to,
188         uint256 value
189     );
190 
191     event Approval(
192         address indexed owner,
193         address indexed spender,
194         uint256 value
195     );
196 }
197 
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * https://github.com/ethereum/EIPs/issues/20
204  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20,Pausable {
207     using SafeMath for uint256;
208 
209     mapping(address => uint256) balances;
210 
211     mapping (address => mapping (address => uint256)) internal allowed;
212 
213     uint256 totalSupply_;
214 
215     /**
216     * @dev Total number of tokens in existence
217     */
218     function totalSupply() public view returns (uint256) {
219         return totalSupply_;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param _owner The address to query the the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address _owner) public view returns (uint256) {
228         return balances[_owner];
229     }
230 
231     /**
232     * @dev Function to check the amount of tokens that an owner allowed to a spender.
233     * @param _owner address The address which owns the funds.
234     * @param _spender address The address which will spend the funds.
235     * @return A uint256 specifying the amount of tokens still available for the spender.
236     */
237     function allowance(
238         address _owner,
239         address _spender
240     )
241         public
242         view
243         returns (uint256)
244     {
245         return allowed[_owner][_spender];
246     }
247 
248     /**
249     * @dev Transfer token for a specified address
250     * @param _to The address to transfer to.
251     * @param _value The amount to be transferred.
252     */
253     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
254         require(_value <= balances[msg.sender]);
255         require(_to != address(0));
256 
257         balances[msg.sender] = balances[msg.sender].sub(_value);
258         balances[_to] = balances[_to].add(_value);
259         emit Transfer(msg.sender, _to, _value);
260         return true;
261     }
262 
263     /**
264     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265     * Beware that changing an allowance with this method brings the risk that someone may use both the old
266     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269     * @param _spender The address which will spend the funds.
270     * @param _value The amount of tokens to be spent.
271     */
272     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
273         allowed[msg.sender][_spender] = _value;
274         emit Approval(msg.sender, _spender, _value);
275         return true;
276     }
277 
278     /**
279     * @dev Transfer tokens from one address to another
280     * @param _from address The address which you want to send tokens from
281     * @param _to address The address which you want to transfer to
282     * @param _value uint256 the amount of tokens to be transferred
283     */
284     function transferFrom(
285         address _from,
286         address _to,
287         uint256 _value
288     )   
289         whenNotPaused
290         public
291         returns (bool)
292     {
293         require(_value <= balances[_from]);
294         require(_value <= allowed[_from][msg.sender]);
295         require(_to != address(0));
296 
297         balances[_from] = balances[_from].sub(_value);
298         balances[_to] = balances[_to].add(_value);
299         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
300         emit Transfer(_from, _to, _value);
301         return true;
302     }
303 
304     /**
305     * @dev Increase the amount of tokens that an owner allowed to a spender.
306     * approve should be called when allowed[_spender] == 0. To increment
307     * allowed value is better to use this function to avoid 2 calls (and wait until
308     * the first transaction is mined)
309     * From MonolithDAO Token.sol
310     * @param _spender The address which will spend the funds.
311     * @param _addedValue The amount of tokens to increase the allowance by.
312     */
313     function increaseApproval(
314         address _spender,
315         uint256 _addedValue
316     )   
317         whenNotPaused
318         public
319         returns (bool)
320     {
321         allowed[msg.sender][_spender] = (
322         allowed[msg.sender][_spender].add(_addedValue));
323         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324         return true;
325     }
326 
327     /**
328     * @dev Decrease the amount of tokens that an owner allowed to a spender.
329     * approve should be called when allowed[_spender] == 0. To decrement
330     * allowed value is better to use this function to avoid 2 calls (and wait until
331     * the first transaction is mined)
332     * From MonolithDAO Token.sol
333     * @param _spender The address which will spend the funds.
334     * @param _subtractedValue The amount of tokens to decrease the allowance by.
335     */
336     function decreaseApproval(
337         address _spender,
338         uint256 _subtractedValue
339     )
340         whenNotPaused
341         public
342         returns (bool)
343     {
344         uint256 oldValue = allowed[msg.sender][_spender];
345         if (_subtractedValue >= oldValue) {
346             allowed[msg.sender][_spender] = 0;
347         } else {
348             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
349         }
350         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351         return true;
352     }
353 
354     /**
355     * @dev Internal function that mints an amount of the token and assigns it to
356     * an account. This encapsulates the modification of balances such that the
357     * proper events are emitted.
358     * @param _account The account that will receive the created tokens.
359     * @param _amount The amount that will be created.
360     */
361     function _mint(address _account, uint256 _amount) internal {
362         require(_account != 0);
363         totalSupply_ = totalSupply_.add(_amount);
364         balances[_account] = balances[_account].add(_amount);
365         emit Transfer(address(0), _account, _amount);
366     }
367 
368     /**
369     * @dev Internal function that burns an amount of the token of a given
370     * account.
371     * @param _account The account whose tokens will be burnt.
372     * @param _amount The amount that will be burnt.
373     */
374     function _burn(address _account, uint256 _amount) internal {
375         require(_account != 0);
376         require(_amount <= balances[_account]);
377 
378         totalSupply_ = totalSupply_.sub(_amount);
379         balances[_account] = balances[_account].sub(_amount);
380         emit Transfer(_account, address(0), _amount);
381     }
382 
383     /**
384     * @dev Internal function that burns an amount of the token of a given
385     * account, deducting from the sender's allowance for said account. Uses the
386     * internal _burn function.
387     * @param _account The account whose tokens will be burnt.
388     * @param _amount The amount that will be burnt.
389     */
390     function _burnFrom(address _account, uint256 _amount) internal {
391         require(_amount <= allowed[_account][msg.sender]);
392 
393         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
394         // this function needs to emit an event with the updated approval.
395         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
396         _burn(_account, _amount);
397     }
398 }
399 
400 /**
401  * @title Burnable Token
402  * @dev Token that can be irreversibly burned (destroyed).
403  */
404 contract BurnableToken is StandardToken {
405     event Burn(address indexed burner, uint256 value);
406 
407     /**
408     * @dev Burns a specific amount of tokens.
409     * @param _value The amount of token to be burned.
410     */
411     function burn(uint256 _value) public {
412         _burn(msg.sender, _value);
413     }
414 
415     /**
416     * @dev Burns a specific amount of tokens from the target address and decrements allowance
417     * @param _from address The address which you want to send tokens from
418     * @param _value uint256 The amount of token to be burned
419     */
420     function burnFrom(address _from, uint256 _value) public {
421         _burnFrom(_from, _value);
422     }
423 
424     /**
425     * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
426     * an additional Burn event.
427     */
428     function _burn(address _who, uint256 _value) internal {
429         super._burn(_who, _value);
430         emit Burn(_who, _value);
431     }
432 }
433 
434 /**
435  * @title Mintable token
436  * @dev Simple ERC20 Token example, with mintable token creation
437  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
438  */
439 
440 contract MintableToken is BurnableToken {
441     event Mint(address indexed to, uint256 amount);
442     event MintFinished();
443 
444     bool public mintingFinished = false;
445 
446     modifier canMint() {
447         require(!mintingFinished);
448         _;
449     }
450 
451     modifier hasMintPermission() {
452         require(msg.sender == owner);
453         _;
454     }
455 
456     /**
457     * @dev Function to mint tokens
458     * @param _to The address that will receive the minted tokens.
459     * @param _amount The amount of tokens to mint.
460     * @return A boolean that indicates if the operation was successful.
461     */
462     function mint(
463         address _to,
464         uint256 _amount
465     )
466         public
467         hasMintPermission
468         canMint
469         returns (bool)
470     {
471         _mint(_to, _amount);
472         emit Mint(_to, _amount);
473         return true;
474     }
475 
476     /**
477     * @dev Function to stop minting new tokens.
478     * @return True if the operation was successful.
479     */
480     function finishMinting() public onlyOwner canMint returns (bool) {
481         mintingFinished = true;
482         emit MintFinished();
483         return true;
484     }
485 }
486 
487 
488 contract GUB is MintableToken {
489     // If ether is sent to this address, send it back.
490     function () public {
491         revert();
492     }
493 
494     string public constant name = "Ancient coins’ chain";
495     string public constant symbol = "GUB";
496     uint8 public constant decimals = 18;
497     uint256 public constant INITIAL_SUPPLY = 7000000000;
498     
499     /**
500     * @dev Constructor that gives msg.sender all of existing tokens.
501     */
502     constructor() public {
503         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
504         balances[msg.sender] = totalSupply_;
505         emit Transfer(address(0), msg.sender, totalSupply_);
506     }
507 }