1 pragma solidity ^0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
12         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (_a == 0) {
16             return 0;
17         }
18 
19         c = _a * _b;
20         assert(c / _a == _b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         // assert(_b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = _a / _b;
30         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
31         return _a / _b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         assert(_b <= _a);
39         return _a - _b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
46         c = _a + _b;
47         assert(c >= _a);
48         return c;
49     }
50 }
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipRenounced(address indexed previousOwner);
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66 
67     /**
68      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69      * account.
70      */
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     /**
84      * @dev Allows the current owner to relinquish control of the contract.
85      * @notice Renouncing to ownership will leave the contract without an owner.
86      * It will not be possible to call the functions with the `onlyOwner`
87      * modifier anymore.
88      */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipRenounced(owner);
91         owner = address(0);
92     }
93 
94     /**
95      * @dev Allows the current owner to transfer control of the contract to a newOwner.
96      * @param _newOwner The address to transfer ownership to.
97      */
98     function transferOwnership(address _newOwner) public onlyOwner {
99         _transferOwnership(_newOwner);
100     }
101 
102     /**
103      * @dev Transfers control of the contract to a newOwner.
104      * @param _newOwner The address to transfer ownership to.
105      */
106     function _transferOwnership(address _newOwner) internal {
107         require(_newOwner != address(0));
108         emit OwnershipTransferred(owner, _newOwner);
109         owner = _newOwner;
110     }
111 }
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117     event Pause();
118     event Unpause();
119 
120     bool public paused = false;
121 
122 
123     /**
124      * @dev Modifier to make a function callable only when the contract is not paused.
125      */
126     modifier whenNotPaused() {
127         require(!paused);
128         _;
129     }
130 
131     /**
132      * @dev Modifier to make a function callable only when the contract is paused.
133      */
134     modifier whenPaused() {
135         require(paused);
136         _;
137     }
138 
139     /**
140      * @dev called by the owner to pause, triggers stopped state
141      */
142     function pause() public onlyOwner whenNotPaused {
143         paused = true;
144         emit Pause();
145     }
146 
147     /**
148      * @dev called by the owner to unpause, returns to normal state
149      */
150     function unpause() public onlyOwner whenPaused {
151         paused = false;
152         emit Unpause();
153     }
154 }
155 /**
156  * @title ERC20Basic
157  * @dev Simpler version of ERC20 interface
158  * See https://github.com/ethereum/EIPs/issues/179
159  */
160 contract ERC20Basic {
161     function totalSupply() public view returns (uint256);
162     function balanceOf(address _who) public view returns (uint256);
163     function transfer(address _to, uint256 _value) public returns (bool);
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 }
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171     using SafeMath for uint256;
172 
173     mapping(address => uint256) internal balances;
174 
175     uint256 internal totalSupply_;
176 
177     /**
178     * @dev Total number of tokens in existence
179     */
180     function totalSupply() public view returns (uint256) {
181         return totalSupply_;
182     }
183 
184     /**
185     * @dev Transfer token for a specified address
186     * @param _to The address to transfer to.
187     * @param _value The amount to be transferred.
188     */
189     function transfer(address _to, uint256 _value) public returns (bool) {
190         require(_value <= balances[msg.sender]);
191         require(_to != address(0));
192 
193         balances[msg.sender] = balances[msg.sender].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         emit Transfer(msg.sender, _to, _value);
196         return true;
197     }
198 
199     /**
200     * @dev Gets the balance of the specified address.
201     * @param _owner The address to query the the balance of.
202     * @return An uint256 representing the amount owned by the passed address.
203     */
204     function balanceOf(address _owner) public view returns (uint256) {
205         return balances[_owner];
206     }
207 
208 }
209 /**
210  * @title ERC20 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/20
212  */
213 contract ERC20 is ERC20Basic {
214     function allowance(address _owner, address _spender)
215     public view returns (uint256);
216 
217     function transferFrom(address _from, address _to, uint256 _value)
218     public returns (bool);
219 
220     function approve(address _spender, uint256 _value) public returns (bool);
221     event Approval(
222         address indexed owner,
223         address indexed spender,
224         uint256 value
225     );
226 }
227 /**
228  * @title DetailedERC20 token
229  * @dev The decimals are only for visualization purposes.
230  * All the operations are done using the smallest and indivisible token unit,
231  * just as on Ethereum all the operations are done in wei.
232  */
233 contract DetailedERC20 is ERC20 {
234     string public name;
235     string public symbol;
236     uint8 public decimals;
237 
238     constructor(string _name, string _symbol, uint8 _decimals) public {
239         name = _name;
240         symbol = _symbol;
241         decimals = _decimals;
242     }
243 }
244 /**
245  * @title Standard ERC20 token
246  *
247  * @dev Implementation of the basic standard token.
248  * https://github.com/ethereum/EIPs/issues/20
249  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
250  */
251 contract StandardToken is ERC20, BasicToken {
252 
253     mapping (address => mapping (address => uint256)) internal allowed;
254 
255 
256     /**
257      * @dev Transfer tokens from one address to another
258      * @param _from address The address which you want to send tokens from
259      * @param _to address The address which you want to transfer to
260      * @param _value uint256 the amount of tokens to be transferred
261      */
262     function transferFrom(
263         address _from,
264         address _to,
265         uint256 _value
266     )
267     public
268     returns (bool)
269     {
270         require(_value <= balances[_from]);
271         require(_value <= allowed[_from][msg.sender]);
272         require(_to != address(0));
273 
274         balances[_from] = balances[_from].sub(_value);
275         balances[_to] = balances[_to].add(_value);
276         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
277         emit Transfer(_from, _to, _value);
278         return true;
279     }
280 
281     /**
282      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283      * Beware that changing an allowance with this method brings the risk that someone may use both the old
284      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      * @param _spender The address which will spend the funds.
288      * @param _value The amount of tokens to be spent.
289      */
290     function approve(address _spender, uint256 _value) public returns (bool) {
291         allowed[msg.sender][_spender] = _value;
292         emit Approval(msg.sender, _spender, _value);
293         return true;
294     }
295 
296     /**
297      * @dev Function to check the amount of tokens that an owner allowed to a spender.
298      * @param _owner address The address which owns the funds.
299      * @param _spender address The address which will spend the funds.
300      * @return A uint256 specifying the amount of tokens still available for the spender.
301      */
302     function allowance(
303         address _owner,
304         address _spender
305     )
306     public
307     view
308     returns (uint256)
309     {
310         return allowed[_owner][_spender];
311     }
312 
313     /**
314      * @dev Increase the amount of tokens that an owner allowed to a spender.
315      * approve should be called when allowed[_spender] == 0. To increment
316      * allowed value is better to use this function to avoid 2 calls (and wait until
317      * the first transaction is mined)
318      * From MonolithDAO Token.sol
319      * @param _spender The address which will spend the funds.
320      * @param _addedValue The amount of tokens to increase the allowance by.
321      */
322     function increaseApproval(
323         address _spender,
324         uint256 _addedValue
325     )
326     public
327     returns (bool)
328     {
329         allowed[msg.sender][_spender] = (
330         allowed[msg.sender][_spender].add(_addedValue));
331         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332         return true;
333     }
334 
335     /**
336      * @dev Decrease the amount of tokens that an owner allowed to a spender.
337      * approve should be called when allowed[_spender] == 0. To decrement
338      * allowed value is better to use this function to avoid 2 calls (and wait until
339      * the first transaction is mined)
340      * From MonolithDAO Token.sol
341      * @param _spender The address which will spend the funds.
342      * @param _subtractedValue The amount of tokens to decrease the allowance by.
343      */
344     function decreaseApproval(
345         address _spender,
346         uint256 _subtractedValue
347     )
348     public
349     returns (bool)
350     {
351         uint256 oldValue = allowed[msg.sender][_spender];
352         if (_subtractedValue >= oldValue) {
353             allowed[msg.sender][_spender] = 0;
354         } else {
355             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
356         }
357         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358         return true;
359     }
360 
361 }
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
424 /**
425  * @title Burnable Token
426  * @dev Token that can be irreversibly burned (destroyed).
427  */
428 contract BurnableToken is BasicToken {
429 
430     event Burn(address indexed burner, uint256 value);
431 
432     /**
433      * @dev Burns a specific amount of tokens.
434      * @param _value The amount of token to be burned.
435      */
436     function burn(uint256 _value) public {
437         _burn(msg.sender, _value);
438     }
439 
440     function _burn(address _who, uint256 _value) internal {
441         require(_value <= balances[_who]);
442         // no need to require value <= totalSupply, since that would imply the
443         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
444 
445         balances[_who] = balances[_who].sub(_value);
446         totalSupply_ = totalSupply_.sub(_value);
447         emit Burn(_who, _value);
448         emit Transfer(_who, address(0), _value);
449     }
450 }
451 contract BNXToken is  DetailedERC20, PausableToken,  BurnableToken {
452 
453     uint8 constant DECIMALS = 18;
454 
455     constructor(uint256 _initialSupply) DetailedERC20("BTCNEXT token", "BNX", DECIMALS) public {
456         totalSupply_ = _initialSupply * 10 ** uint256(DECIMALS);
457         balances[msg.sender] =  totalSupply_;
458         emit Transfer(this, msg.sender, totalSupply_);
459     }
460 }