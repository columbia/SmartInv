1 pragma solidity ^0.4.25;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint256);
5 
6     function balanceOf(address who) public view returns (uint256);
7 
8     function transfer(address to, uint256 value) public returns (bool);
9 
10     function allowance(address owner, address spender) public view returns (uint256);
11 
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14     function approve(address spender, uint256 value) public returns (bool);
15 
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26     address public owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29     /**
30      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31      * account.
32      */
33     constructor() public {
34         owner = msg.sender;
35     }
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43     /**
44      * @dev Allows the current owner to transfer control of the contract to a newOwner.
45      * @param newOwner The address to transfer ownership to.
46      */
47     function transferOwnership(address newOwner) public onlyOwner {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 }
53 
54 /**
55  * @title ERC827 interface, an extension of ERC20 token standard
56  *
57  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
58  * @dev methods to transfer value and data and execute calls in transfers and
59  * @dev approvals.
60  */
61 contract ERC827 is ERC20 {
62     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool);
63 
64     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool);
65 
66     function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public payable returns (bool);
67 }
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that revert on error
72  */
73 library SafeMath {
74 
75     /**
76     * @dev Multiplies two numbers, reverts on overflow.
77     */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
94     */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0);
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99         uint256 c = a / b;
100         return c;
101     }
102 
103     /**
104     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105     */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b <= a);
108         uint256 c = a - b;
109 
110         return c;
111     }
112 
113     /**
114     * @dev Adds two numbers, reverts on overflow.
115     */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a);
119 
120         return c;
121     }
122 
123     /**
124     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
125     * reverts when dividing by zero.
126     */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b != 0);
129         return a % b;
130     }
131 }
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  */
138 contract ERC20Token is ERC20 {
139     using SafeMath for uint256;
140     mapping(address => mapping(address => uint256)) internal allowed;
141     mapping(address => uint256) balances;
142     uint256 totalSupply_;
143     /**
144      * @dev total number of tokens in existence
145      */
146     function totalSupply() public view returns (uint256) {
147         return totalSupply_;
148     }
149     /**
150      * @dev transfer token for a specified address
151      * @param _to The address to transfer to.
152      * @param _value The amount to be transferred.
153      */
154     function transfer(address _to, uint256 _value) public returns (bool) {
155         require(_to != address(0));
156         require(_value <= balances[msg.sender]);
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         emit Transfer(msg.sender, _to, _value);
160         return true;
161     }
162     /**
163      * @dev Gets the balance of the specified address.
164      * @param _owner The address to query the the balance of.
165      * @return An uint256 representing the amount owned by the passed address.
166      */
167     function balanceOf(address _owner) public view returns (uint256) {
168         return balances[_owner];
169     }
170     /**
171      * @dev Transfer tokens from one address to another
172      * @param _from address The address which you want to send tokens from
173      * @param _to address The address which you want to transfer to
174      * @param _value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180         balances[_from] = balances[_from].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183         emit Transfer(_from, _to, _value);
184         return true;
185     }
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      */
189     function approve(address _spender, uint256 _value) public returns (bool) {
190         allowed[msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _value);
192         return true;
193     }
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param _owner address The address which owns the funds.
197      * @param _spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(address _owner, address _spender) public view returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203     /**
204      * @dev Increase the amount of tokens that an owner allowed to a spender.
205      *
206      * approve should be called when allowed[_spender] == 0. To increment
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      * @param _spender The address which will spend the funds.
211      * @param _addedValue The amount of tokens to increase the allowance by.
212      */
213     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218     /**
219      * @dev Decrease the amount of tokens that an owner allowed to a spender.
220      *
221      * approve should be called when allowed[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 }
239 
240 /**
241  * @title ERC827, an extension of ERC20 token standard
242  *
243  * @dev Implementation the ERC827, following the ERC20 standard with extra
244  * @dev methods to transfer value and data and execute calls in transfers and
245  * @dev approvals.
246  *
247  * @dev Uses OpenZeppelin StandardToken.
248  */
249 contract ERC827Token is ERC827, ERC20Token {
250     /**
251      * @dev Addition to ERC20 token methods. It allows to
252      * @dev approve the transfer of value and execute a call with the sent data.
253      *
254      * @dev Beware that changing an allowance with this method brings the risk that
255      * @dev someone may use both the old and the new allowance by unfortunate
256      * @dev transaction ordering. One possible solution to mitigate this race condition
257      * @dev is to first reduce the spender's allowance to 0 and set the desired value
258      * @dev afterwards:
259      * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      *
261      * @param _spender The address that will spend the funds.
262      * @param _value The amount of tokens to be spent.
263      * @param _data ABI-encoded contract call to call `_to` address.
264      *
265      * @return true if the call function was executed successfully
266      */
267     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
268         require(_spender != address(this));
269         super.approve(_spender, _value);
270         // solium-disable-next-line security/no-call-value
271         require(_spender.call.value(msg.value)(_data));
272         return true;
273     }
274     /**
275      * @dev Addition to ERC20 token methods. Transfer tokens to a specified
276      * @dev address and execute a call with the sent data on the same transaction
277      *
278      * @param _to address The address which you want to transfer to
279      * @param _value uint256 the amout of tokens to be transfered
280      * @param _data ABI-encoded contract call to call `_to` address.
281      *
282      * @return true if the call function was executed successfully
283      */
284     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
285         require(_to != address(this));
286         super.transfer(_to, _value);
287         require(_to.call.value(msg.value)(_data));
288         return true;
289     }
290     /**
291      * @dev Addition to ERC20 token methods. Transfer tokens from one address to
292      * @dev another and make a contract call on the same transaction
293      *
294      * @param _from The address which you want to send tokens from
295      * @param _to The address which you want to transfer to
296      * @param _value The amout of tokens to be transferred
297      * @param _data ABI-encoded contract call to call `_to` address.
298      *
299      * @return true if the call function was executed successfully
300      */
301     function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public payable returns (bool) {
302         require(_to != address(this));
303         super.transferFrom(_from, _to, _value);
304         require(_to.call.value(msg.value)(_data));
305         return true;
306     }
307     /**
308      * @dev Addition to StandardToken methods. Increase the amount of tokens that
309      * @dev an owner allowed to a spender and execute a call with the sent data.
310      *
311      * @dev approve should be called when allowed[_spender] == 0. To increment
312      * @dev allowed value is better to use this function to avoid 2 calls (and wait until
313      * @dev the first transaction is mined)
314      * @dev From MonolithDAO Token.sol
315      *
316      * @param _spender The address which will spend the funds.
317      * @param _addedValue The amount of tokens to increase the allowance by.
318      * @param _data ABI-encoded contract call to call `_spender` address.
319      */
320     function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
321         require(_spender != address(this));
322         super.increaseApproval(_spender, _addedValue);
323         require(_spender.call.value(msg.value)(_data));
324         return true;
325     }
326     /**
327      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
328      * @dev an owner allowed to a spender and execute a call with the sent data.
329      *
330      * @dev approve should be called when allowed[_spender] == 0. To decrement
331      * @dev allowed value is better to use this function to avoid 2 calls (and wait until
332      * @dev the first transaction is mined)
333      * @dev From MonolithDAO Token.sol
334      *
335      * @param _spender The address which will spend the funds.
336      * @param _subtractedValue The amount of tokens to decrease the allowance by.
337      * @param _data ABI-encoded contract call to call `_spender` address.
338      */
339     function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
340         require(_spender != address(this));
341         super.decreaseApproval(_spender, _subtractedValue);
342         require(_spender.call.value(msg.value)(_data));
343         return true;
344     }
345 }
346 
347 /**
348  * @title  Burnable and Pause Token
349  * @dev    StandardToken modified with pausable transfers.
350  */
351 contract PauseBurnableERC827Token is ERC827Token, Ownable {
352     using SafeMath for uint256;
353     event Pause();
354     event Unpause();
355     event PauseOperatorTransferred(address indexed previousOperator, address indexed newOperator);
356     event Burn(address indexed burner, uint256 value);
357 
358     bool public paused = false;
359     address public pauseOperator;
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyPauseOperator() {
364         require(msg.sender == pauseOperator || msg.sender == owner);
365         _;
366     }
367     /**
368      * @dev Modifier to make a function callable only when the contract is not paused.
369      */
370     modifier whenNotPaused() {
371         require(!paused);
372         _;
373     }
374     /**
375      * @dev Modifier to make a function callable only when the contract is paused.
376      */
377     modifier whenPaused() {
378         require(paused);
379         _;
380     }
381     /**
382      * @dev The constructor sets the original `owner` of the contract to the sender
383      * account.
384      */
385     constructor() public {
386         pauseOperator = msg.sender;
387     }
388     /**
389      * @dev called by the operator to set the new operator to pause the token
390      */
391     function transferPauseOperator(address newPauseOperator) onlyPauseOperator public {
392         require(newPauseOperator != address(0));
393         emit PauseOperatorTransferred(pauseOperator, newPauseOperator);
394         pauseOperator = newPauseOperator;
395     }
396     /**
397      * @dev called by the owner to pause, triggers stopped state
398      */
399     function pause() onlyPauseOperator whenNotPaused public {
400         paused = true;
401         emit Pause();
402     }
403     /**
404      * @dev called by the owner to unpause, returns to normal state
405      */
406     function unpause() onlyPauseOperator whenPaused public {
407         paused = false;
408         emit Unpause();
409     }
410 
411     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
412         return super.transfer(_to, _value);
413     }
414 
415     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
416         return super.transferFrom(_from, _to, _value);
417     }
418 
419     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
420         return super.approve(_spender, _value);
421     }
422 
423     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
424         return super.increaseApproval(_spender, _addedValue);
425     }
426 
427     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
428         return super.decreaseApproval(_spender, _subtractedValue);
429     }
430     /**
431      * @dev Burns a specific amount of tokens.
432      * @param _value The amount of token to be burned.
433      */
434     function burn(uint256 _value) public whenNotPaused {
435         _burn(msg.sender, _value);
436     }
437 
438     function _burn(address _who, uint256 _value) internal {
439         require(_value <= balances[_who]);
440         // no need to require value <= totalSupply, since that would imply the
441         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
442         balances[_who] = balances[_who].sub(_value);
443         // Subtract from the sender
444         totalSupply_ = totalSupply_.sub(_value);
445         emit Burn(_who, _value);
446         emit Transfer(_who, address(0), _value);
447     }
448     /**
449      * @dev Burns a specific amount of tokens from the target address and decrements allowance
450      * @param _from address The address which you want to send tokens from
451      * @param _value uint256 The amount of token to be burned
452      */
453     function burnFrom(address _from, uint256 _value) public whenNotPaused {
454         require(_value <= allowed[_from][msg.sender]);
455         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
456         _burn(_from, _value);
457     }
458 }
459 
460 contract XCoin is PauseBurnableERC827Token {
461     string  public  name;
462     string  public  symbol;
463     uint8   public constant decimals = 18;
464 
465     constructor(string _name, string _symbol, uint256 _totalSupply, address _owner) public {
466         if (_owner != address(0x0)) {
467             pauseOperator = _owner;
468             owner = _owner;
469         }
470         totalSupply_ = _totalSupply;
471         name = _name;
472         symbol = _symbol;
473         balances[msg.sender] = _totalSupply;
474         emit Transfer(0x0, msg.sender, _totalSupply);
475     }
476     function batchTransfer(address[] _tos, uint256 _value) public whenNotPaused returns (bool) {
477         uint256 all = _value.mul(_tos.length);
478         require(balances[msg.sender] >= all);
479         for (uint i = 0; i < _tos.length; i++) {
480             require(_tos[i] != address(0));
481             require(_tos[i] != msg.sender);
482             balances[_tos[i]] = balances[_tos[i]].add(_value);
483             emit Transfer(msg.sender, _tos[i], _value);
484         }
485         balances[msg.sender] = balances[msg.sender].sub(all);
486         return true;
487     }
488 
489     function multiTransfer(address[] _tos, uint256[] _values) public whenNotPaused returns (bool) {
490         require(_tos.length == _values.length);
491         uint256 all = 0;
492         for (uint i = 0; i < _tos.length; i++) {
493             require(_tos[i] != address(0));
494             require(_tos[i] != msg.sender);
495             all = all.add(_values[i]);
496             balances[_tos[i]] = balances[_tos[i]].add(_values[i]);
497             emit Transfer(msg.sender, _tos[i], _values[i]);
498         }
499         balances[msg.sender] = balances[msg.sender].sub(all);
500         return true;
501     }
502 }