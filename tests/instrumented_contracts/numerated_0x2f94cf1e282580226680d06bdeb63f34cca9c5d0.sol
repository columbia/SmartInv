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
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71 
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
90     * @dev Allows the current owner to transfer control of the contract to a newOwner.
91     * @param _newOwner The address to transfer ownership to.
92     */
93     function transferOwnership(address _newOwner) public onlyOwner {
94         _transferOwnership(_newOwner);
95     }
96 
97     /**
98     * @dev Transfers control of the contract to a newOwner.
99     * @param _newOwner The address to transfer ownership to.
100     */
101     function _transferOwnership(address _newOwner) internal {
102         require(_newOwner != address(0));
103         emit OwnershipTransferred(owner, _newOwner);
104         owner = _newOwner;
105     }
106 }
107 
108 /**
109  * @title Pausable
110  * @dev Base contract which allows children to implement an emergency stop mechanism.
111  */
112 contract Pausable is Ownable {
113     event Pause();
114     event Unpause();
115 
116     bool public paused = false;
117 
118     /**
119     * @dev Modifier to make a function callable only when the contract is not paused.
120     */
121     modifier whenNotPaused() {
122         require(!paused);
123         _;
124     }
125 
126     /**
127     * @dev Modifier to make a function callable only when the contract is paused.
128     */
129     modifier whenPaused() {
130         require(paused);
131         _;
132     }
133 
134     /**
135     * @dev called by the owner to pause, triggers stopped state
136     */
137     function pause() public onlyOwner whenNotPaused {
138         paused = true;
139         emit Pause();
140     }
141 
142     /**
143     * @dev called by the owner to unpause, returns to normal state
144     */
145     function unpause() public onlyOwner whenPaused {
146         paused = false;
147         emit Unpause();
148     }
149 }
150 
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 {
157     function totalSupply() public view returns (uint256);
158 
159     function balanceOf(address _who) public view returns (uint256);
160 
161     function allowance(address _owner, address _spender)
162         public view returns (uint256);
163 
164     function transfer(address _to, uint256 _value) public returns (bool);
165 
166     function approve(address _spender, uint256 _value)
167         public returns (bool);
168 
169     function transferFrom(address _from, address _to, uint256 _value)
170         public returns (bool);
171 
172     event Transfer(
173         address indexed from,
174         address indexed to,
175         uint256 value
176     );
177 
178     event Approval(
179         address indexed owner,
180         address indexed spender,
181         uint256 value
182     );
183 }
184 
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * https://github.com/ethereum/EIPs/issues/20
191  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20,Pausable {
194     using SafeMath for uint256;
195 
196     mapping(address => uint256) balances;
197 
198     mapping (address => mapping (address => uint256)) internal allowed;
199 
200     uint256 totalSupply_;
201 
202     /**
203     * @dev Total number of tokens in existence
204     */
205     function totalSupply() public view returns (uint256) {
206         return totalSupply_;
207     }
208 
209     /**
210     * @dev Gets the balance of the specified address.
211     * @param _owner The address to query the the balance of.
212     * @return An uint256 representing the amount owned by the passed address.
213     */
214     function balanceOf(address _owner) public view returns (uint256) {
215         return balances[_owner];
216     }
217 
218     /**
219     * @dev Function to check the amount of tokens that an owner allowed to a spender.
220     * @param _owner address The address which owns the funds.
221     * @param _spender address The address which will spend the funds.
222     * @return A uint256 specifying the amount of tokens still available for the spender.
223     */
224     function allowance(
225         address _owner,
226         address _spender
227     )
228         public
229         view
230         returns (uint256)
231     {
232         return allowed[_owner][_spender];
233     }
234 
235     /**
236     * @dev Transfer token for a specified address
237     * @param _to The address to transfer to.
238     * @param _value The amount to be transferred.
239     */
240     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
241         require(_value <= balances[msg.sender]);
242         require(_to != address(0));
243 
244         balances[msg.sender] = balances[msg.sender].sub(_value);
245         balances[_to] = balances[_to].add(_value);
246         emit Transfer(msg.sender, _to, _value);
247         return true;
248     }
249 
250     /**
251     * @dev Transfer tokens from one address to another
252     * @param _from address The address which you want to send tokens from
253     * @param _to address The address which you want to transfer to
254     * @param _value uint256 the amount of tokens to be transferred
255     */
256     function transferFrom(
257         address _from,
258         address _to,
259         uint256 _value
260     )   
261         whenNotPaused
262         public
263         returns (bool)
264     {
265         require(_value <= balances[_from]);
266         require(_value <= allowed[_from][msg.sender]);
267         require(_to != address(0));
268 
269         balances[_from] = balances[_from].sub(_value);
270         balances[_to] = balances[_to].add(_value);
271         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
272         emit Transfer(_from, _to, _value);
273         return true;
274     }
275 
276     /**
277     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278     * Beware that changing an allowance with this method brings the risk that someone may use both the old
279     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282     * @param _spender The address which will spend the funds.
283     * @param _value The amount of tokens to be spent.
284     */
285     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
286         require(_value == 0 || (allowed[msg.sender][_spender] == 0));
287         
288         allowed[msg.sender][_spender] = _value;
289         emit Approval(msg.sender, _spender, _value);
290         return true;
291     }
292 
293     /**
294     * @dev Increase the amount of tokens that an owner allowed to a spender.
295     * approve should be called when allowed[_spender] == 0. To increment
296     * allowed value is better to use this function to avoid 2 calls (and wait until
297     * the first transaction is mined)
298     * From MonolithDAO Token.sol
299     * @param _spender The address which will spend the funds.
300     * @param _addedValue The amount of tokens to increase the allowance by.
301     */
302     function increaseApproval(
303         address _spender,
304         uint256 _addedValue
305     )   
306         whenNotPaused
307         public
308         returns (bool)
309     {
310         allowed[msg.sender][_spender] = (
311         allowed[msg.sender][_spender].add(_addedValue));
312         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313         return true;
314     }
315 
316     /**
317     * @dev Decrease the amount of tokens that an owner allowed to a spender.
318     * approve should be called when allowed[_spender] == 0. To decrement
319     * allowed value is better to use this function to avoid 2 calls (and wait until
320     * the first transaction is mined)
321     * From MonolithDAO Token.sol
322     * @param _spender The address which will spend the funds.
323     * @param _subtractedValue The amount of tokens to decrease the allowance by.
324     */
325     function decreaseApproval(
326         address _spender,
327         uint256 _subtractedValue
328     )
329         whenNotPaused
330         public
331         returns (bool)
332     {
333         uint256 oldValue = allowed[msg.sender][_spender];
334         if (_subtractedValue >= oldValue) {
335             allowed[msg.sender][_spender] = 0;
336         } else {
337             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338         }
339         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340         return true;
341     }
342 
343     /**
344     * @dev Internal function that mints an amount of the token and assigns it to
345     * an account. This encapsulates the modification of balances such that the
346     * proper events are emitted.
347     * @param _account The account that will receive the created tokens.
348     * @param _amount The amount that will be created.
349     */
350     function _mint(address _account, uint256 _amount) internal {
351         require(_account != 0);
352         totalSupply_ = totalSupply_.add(_amount);
353         balances[_account] = balances[_account].add(_amount);
354         emit Transfer(address(0), _account, _amount);
355     }
356 
357     /**
358     * @dev Internal function that burns an amount of the token of a given
359     * account.
360     * @param _account The account whose tokens will be burnt.
361     * @param _amount The amount that will be burnt.
362     */
363     function _burn(address _account, uint256 _amount) internal {
364         require(_account != 0);
365         require(_amount <= balances[_account]);
366 
367         totalSupply_ = totalSupply_.sub(_amount);
368         balances[_account] = balances[_account].sub(_amount);
369         emit Transfer(_account, address(0), _amount);
370     }
371 
372     /**
373     * @dev Internal function that burns an amount of the token of a given
374     * account, deducting from the sender's allowance for said account. Uses the
375     * internal _burn function.
376     * @param _account The account whose tokens will be burnt.
377     * @param _amount The amount that will be burnt.
378     */
379     function _burnFrom(address _account, uint256 _amount) internal {
380         require(_amount <= allowed[_account][msg.sender]);
381 
382         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
383         // this function needs to emit an event with the updated approval.
384         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
385         _burn(_account, _amount);
386     }
387 }
388 
389 /**
390  * @title Burnable Token
391  * @dev Token that can be irreversibly burned (destroyed).
392  */
393 contract BurnableToken is StandardToken {
394     event Burn(address indexed burner, uint256 value);
395 
396     /**
397     * @dev Burns a specific amount of tokens.
398     * @param _value The amount of token to be burned.
399     */
400     function burn(uint256 _value) public {
401         _burn(msg.sender, _value);
402     }
403 
404     /**
405     * @dev Burns a specific amount of tokens from the target address and decrements allowance
406     * @param _from address The address which you want to send tokens from
407     * @param _value uint256 The amount of token to be burned
408     */
409     function burnFrom(address _from, uint256 _value) public {
410         _burnFrom(_from, _value);
411     }
412 
413     /**
414     * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
415     * an additional Burn event.
416     */
417     function _burn(address _who, uint256 _value) internal {
418         super._burn(_who, _value);
419         emit Burn(_who, _value);
420     }
421 }
422 
423 /**
424  * @title Mintable token
425  * @dev Simple ERC20 Token example, with mintable token creation
426  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
427  */
428 
429 contract MintableToken is BurnableToken {
430     event Mint(address indexed to, uint256 amount);
431     event MintFinished();
432 
433     bool public mintingFinished = false;
434 
435     modifier canMint() {
436         require(!mintingFinished);
437         _;
438     }
439 
440     modifier hasMintPermission() {
441         require(msg.sender == owner);
442         _;
443     }
444 
445     /**
446     * @dev Function to mint tokens
447     * @param _to The address that will receive the minted tokens.
448     * @param _amount The amount of tokens to mint.
449     * @return A boolean that indicates if the operation was successful.
450     */
451     function mint(
452         address _to,
453         uint256 _amount
454     )
455         public
456         hasMintPermission
457         canMint
458         returns (bool)
459     {
460         _mint(_to, _amount);
461         emit Mint(_to, _amount);
462         return true;
463     }
464 
465     /**
466     * @dev Function to stop minting new tokens.
467     * @return True if the operation was successful.
468     */
469     function finishMinting() public onlyOwner canMint returns (bool) {
470         mintingFinished = true;
471         emit MintFinished();
472         return true;
473     }
474 
475     /**
476     * @dev Function to start minting new tokens.
477     * @return True if the operation was successful.
478     */
479     function startMinting() public onlyOwner returns (bool) {
480         mintingFinished = false;
481         return true;
482     }
483 }
484 
485 contract GUCN is MintableToken {
486     // If ether is sent to this address, send it back.
487     function () public {
488         revert();
489     }
490 
491     string public constant name = "Ancient coins’ chain";
492     string public constant symbol = "GUCN";
493     uint8 public constant decimals = 18;
494     uint256 public constant INITIAL_SUPPLY = 10000000000;
495     
496     /**
497     * @dev Constructor that gives msg.sender all of existing tokens.
498     */
499     constructor() public {
500         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
501         balances[msg.sender] = totalSupply_;
502         emit Transfer(address(0), msg.sender, totalSupply_);
503     }
504 }