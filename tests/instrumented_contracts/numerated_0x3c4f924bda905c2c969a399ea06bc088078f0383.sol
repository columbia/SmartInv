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
12     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (_a == 0) {
17             return 0;
18         }
19 
20         uint256 c = _a * _b;
21         assert(c / _a == _b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         // assert(_b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = _a / _b;
32         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41         assert(_b <= _a);
42         uint256 c = _a - _b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51         uint256 c = _a + _b;
52         assert(c >= _a);
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
67     event OwnershipRenounced(address indexed previousOwner);
68     event OwnershipTransferred(
69         address indexed previousOwner,
70         address indexed newOwner
71     );
72 
73     /**
74     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75     * account.
76     */
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     /**
82     * @dev Throws if called by any account other than the owner.
83     */
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     /**
90     * @dev Allows the current owner to relinquish control of the contract.
91     * @notice Renouncing to ownership will leave the contract without an owner.
92     * It will not be possible to call the functions with the `onlyOwner`
93     * modifier anymore.
94     */
95     function renounceOwnership() public onlyOwner {
96         emit OwnershipRenounced(owner);
97         owner = address(0);
98     }
99 
100     /**
101     * @dev Allows the current owner to transfer control of the contract to a newOwner.
102     * @param _newOwner The address to transfer ownership to.
103     */
104     function transferOwnership(address _newOwner) public onlyOwner {
105         _transferOwnership(_newOwner);
106     }
107 
108     /**
109     * @dev Transfers control of the contract to a newOwner.
110     * @param _newOwner The address to transfer ownership to.
111     */
112     function _transferOwnership(address _newOwner) internal {
113         require(_newOwner != address(0));
114         emit OwnershipTransferred(owner, _newOwner);
115         owner = _newOwner;
116     }
117 }
118 
119 
120 /**
121  * @title Pausable
122  * @dev Base contract which allows children to implement an emergency stop mechanism.
123  */
124 contract Pausable is Ownable {
125     event Pause();
126     event Unpause();
127 
128     bool public paused = false;
129 
130     /**
131     * @dev Modifier to make a function callable only when the contract is not paused.
132     */
133     modifier whenNotPaused() {
134         require(!paused);
135         _;
136     }
137 
138     /**
139     * @dev Modifier to make a function callable only when the contract is paused.
140     */
141     modifier whenPaused() {
142         require(paused);
143         _;
144     }
145 
146     /**
147     * @dev called by the owner to pause, triggers stopped state
148     */
149     function pause() public onlyOwner whenNotPaused {
150         paused = true;
151         emit Pause();
152     }
153 
154     /**
155     * @dev called by the owner to unpause, returns to normal state
156     */
157     function unpause() public onlyOwner whenPaused {
158         paused = false;
159         emit Unpause();
160     }
161 }
162 
163 
164 /**
165 * @title ERC20 interface
166 * @dev see https://github.com/ethereum/EIPs/issues/20
167 */
168 contract ERC20 {
169     function totalSupply() public view returns (uint256);
170 
171     function balanceOf(address _who) public view returns (uint256);
172 
173     function allowance(address _owner, address _spender)
174         public view returns (uint256);
175 
176     function transfer(address _to, uint256 _value) public returns (bool);
177 
178     function approve(address _spender, uint256 _value)
179         public returns (bool);
180 
181     function transferFrom(address _from, address _to, uint256 _value)
182         public returns (bool);
183 
184     event Transfer(
185         address indexed from,
186         address indexed to,
187         uint256 value
188     );
189 
190     event Approval(
191         address indexed owner,
192         address indexed spender,
193         uint256 value
194     );
195 }
196 
197 /**
198 * @title Standard ERC20 token
199 *
200 * @dev Implementation of the basic standard token.
201 * https://github.com/ethereum/EIPs/issues/20
202 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203 */
204 contract StandardToken is ERC20 {
205     using SafeMath for uint256;
206 
207     mapping(address => uint256) balances;
208 
209     mapping (address => mapping (address => uint256)) internal allowed;
210 
211     uint256 totalSupply_;
212 
213     /**
214     * @dev Total number of tokens in existence
215     */
216     function totalSupply() public view returns (uint256) {
217         return totalSupply_;
218     }
219 
220     /**
221     * @dev Gets the balance of the specified address.
222     * @param _owner The address to query the the balance of.
223     * @return An uint256 representing the amount owned by the passed address.
224     */
225     function balanceOf(address _owner) public view returns (uint256) {
226         return balances[_owner];
227     }
228 
229     /**
230     * @dev Function to check the amount of tokens that an owner allowed to a spender.
231     * @param _owner address The address which owns the funds.
232     * @param _spender address The address which will spend the funds.
233     * @return A uint256 specifying the amount of tokens still available for the spender.
234     */
235     function allowance(
236         address _owner,
237         address _spender
238     )
239         public
240         view
241         returns (uint256)
242     {
243         return allowed[_owner][_spender];
244     }
245 
246     /**
247     * @dev Transfer token for a specified address
248     * @param _to The address to transfer to.
249     * @param _value The amount to be transferred.
250     */
251     function transfer(address _to, uint256 _value) public returns (bool) {
252         require(_value <= balances[msg.sender]);
253         require(_to != address(0));
254 
255         balances[msg.sender] = balances[msg.sender].sub(_value);
256         balances[_to] = balances[_to].add(_value);
257         emit Transfer(msg.sender, _to, _value);
258         return true;
259     }
260 
261     /**
262     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263     * Beware that changing an allowance with this method brings the risk that someone may use both the old
264     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267     * @param _spender The address which will spend the funds.
268     * @param _value The amount of tokens to be spent.
269     */
270     function approve(address _spender, uint256 _value) public returns (bool) {
271         allowed[msg.sender][_spender] = _value;
272         emit Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     /**
277     * @dev Transfer tokens from one address to another
278     * @param _from address The address which you want to send tokens from
279     * @param _to address The address which you want to transfer to
280     * @param _value uint256 the amount of tokens to be transferred
281     */
282     function transferFrom(
283         address _from,
284         address _to,
285         uint256 _value
286     )
287         public
288         returns (bool)
289     {
290         require(_value <= balances[_from]);
291         require(_value <= allowed[_from][msg.sender]);
292         require(_to != address(0));
293 
294         balances[_from] = balances[_from].sub(_value);
295         balances[_to] = balances[_to].add(_value);
296         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
297         emit Transfer(_from, _to, _value);
298         return true;
299     }
300 
301     /**
302     * @dev Increase the amount of tokens that an owner allowed to a spender.
303     * approve should be called when allowed[_spender] == 0. To increment
304     * allowed value is better to use this function to avoid 2 calls (and wait until
305     * the first transaction is mined)
306     * From MonolithDAO Token.sol
307     * @param _spender The address which will spend the funds.
308     * @param _addedValue The amount of tokens to increase the allowance by.
309     */
310     function increaseApproval(
311         address _spender,
312         uint256 _addedValue
313     )
314         public
315         returns (bool)
316     {
317         allowed[msg.sender][_spender] = (
318         allowed[msg.sender][_spender].add(_addedValue));
319         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320         return true;
321     }
322 
323     /**
324     * @dev Decrease the amount of tokens that an owner allowed to a spender.
325     * approve should be called when allowed[_spender] == 0. To decrement
326     * allowed value is better to use this function to avoid 2 calls (and wait until
327     * the first transaction is mined)
328     * From MonolithDAO Token.sol
329     * @param _spender The address which will spend the funds.
330     * @param _subtractedValue The amount of tokens to decrease the allowance by.
331     */
332     function decreaseApproval(
333         address _spender,
334         uint256 _subtractedValue
335     )
336         public
337         returns (bool)
338     {
339         uint256 oldValue = allowed[msg.sender][_spender];
340         if (_subtractedValue >= oldValue) {
341             allowed[msg.sender][_spender] = 0;
342         } else {
343             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344         }
345         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346         return true;
347     }
348 
349 }
350 
351 
352 /**
353 * @title Pausable token
354 * @dev StandardToken modified with pausable transfers.
355 **/
356 contract PausableERC20Token is StandardToken, Pausable {
357 
358     function transfer(
359         address _to,
360         uint256 _value
361     )
362         public
363         whenNotPaused
364         returns (bool)
365     {
366         return super.transfer(_to, _value);
367     }
368 
369     function transferFrom(
370         address _from,
371         address _to,
372         uint256 _value
373     )
374         public
375         whenNotPaused
376         returns (bool)
377     {
378         return super.transferFrom(_from, _to, _value);
379     }
380 
381     function approve(
382         address _spender,
383         uint256 _value
384     )
385         public
386         whenNotPaused
387         returns (bool)
388     {
389         return super.approve(_spender, _value);
390     }
391 
392     function increaseApproval(
393         address _spender,
394         uint _addedValue
395     )
396         public
397         whenNotPaused
398         returns (bool success)
399     {
400         return super.increaseApproval(_spender, _addedValue);
401     }
402 
403     function decreaseApproval(
404         address _spender,
405         uint _subtractedValue
406     )
407         public
408         whenNotPaused
409         returns (bool success)
410     {
411         return super.decreaseApproval(_spender, _subtractedValue);
412     }
413 }
414 
415 
416 /**
417 * @title Burnable Pausable Token
418 * @dev Pausable Token that can be irreversibly burned (destroyed).
419 */
420 contract BurnablePausableERC20Token is PausableERC20Token {
421 
422     event Burn(address indexed burner, uint256 value);
423 
424     /**
425     * @dev Burns a specific amount of tokens.
426     * @param _value The amount of token to be burned.
427     */
428     function burn(
429         uint256 _value
430     ) 
431         public
432         whenNotPaused
433     {
434         _burn(msg.sender, _value);
435     }
436 
437     /**
438     * @dev Burns a specific amount of tokens from the target address and decrements allowance
439     * @param _from address The address which you want to send tokens from
440     * @param _value uint256 The amount of token to be burned
441     */
442     function burnFrom(
443         address _from, 
444         uint256 _value
445     ) 
446         public 
447         whenNotPaused
448     {
449         require(_value <= allowed[_from][msg.sender]);
450         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
451         // this function needs to emit an event with the updated approval.
452         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
453         _burn(_from, _value);
454     }
455 
456     function _burn(
457         address _who, 
458         uint256 _value
459     ) 
460         internal 
461         whenNotPaused
462     {
463         require(_value <= balances[_who]);
464         // no need to require value <= totalSupply, since that would imply the
465         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
466 
467         balances[_who] = balances[_who].sub(_value);
468         totalSupply_ = totalSupply_.sub(_value);
469         emit Burn(_who, _value);
470         emit Transfer(_who, address(0), _value);
471     }
472 }
473 
474 /**
475 * @title JPT
476 * @dev Token that is ERC20 compatible, Pausableb, Burnable, Ownable with SafeMath.
477 */
478 contract JPT is BurnablePausableERC20Token {
479 
480     /** Token Setting: You are free to change any of these
481     * @param name string The name of your token (can be not unique)
482     * @param symbol string The symbol of your token (can be not unique, can be more than three characters)
483     * @param decimals uint8 The accuracy decimals of your token (conventionally be 18)
484     * Read this to choose decimals: https://ethereum.stackexchange.com/questions/38704/why-most-erc-20-tokens-have-18-decimals
485     * @param INITIAL_SUPPLY uint256 The total supply of your token. Example default to be "10000". Change as you wish.
486     **/
487     string public constant name = "JPlay Token";
488     string public constant symbol = "JPT";
489     uint8 public constant decimals = 18;
490 
491     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
492 
493     /**
494     * @dev Constructor that gives msg.sender all of existing tokens.
495     * Literally put all the issued money in your pocket
496     */
497     constructor() public {
498         totalSupply_ = INITIAL_SUPPLY;
499         balances[msg.sender] = INITIAL_SUPPLY;
500         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
501     }
502 }