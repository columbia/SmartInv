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
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74     /**
75      * @dev Multiplies two numbers, throws on overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
78         if (a == 0) {
79             return 0;
80         }
81         c = a * b;
82         assert(c / a == b);
83         return c;
84     }
85     /**
86      * @dev Integer division of two numbers, truncating the quotient.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         // assert(b > 0); // Solidity automatically throws when dividing by 0
90         // uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92         return a / b;
93     }
94     /**
95      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101     /**
102      * @dev Adds two numbers, throws on overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105         c = a + b;
106         assert(c >= a);
107         return c;
108     }
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  */
115 contract ERC20Token is ERC20 {
116     using SafeMath for uint256;
117     mapping(address => mapping(address => uint256)) internal allowed;
118     mapping(address => uint256) balances;
119     uint256 totalSupply_;
120     /**
121      * @dev total number of tokens in existence
122      */
123     function totalSupply() public view returns (uint256) {
124         return totalSupply_;
125     }
126     /**
127      * @dev transfer token for a specified address
128      * @param _to The address to transfer to.
129      * @param _value The amount to be transferred.
130      */
131     function transfer(address _to, uint256 _value) public returns (bool) {
132         require(_to != address(0));
133         require(_value <= balances[msg.sender]);
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(msg.sender, _to, _value);
137         return true;
138     }
139     /**
140      * @dev Gets the balance of the specified address.
141      * @param _owner The address to query the the balance of.
142      * @return An uint256 representing the amount owned by the passed address.
143      */
144     function balanceOf(address _owner) public view returns (uint256) {
145         return balances[_owner];
146     }
147     /**
148      * @dev Transfer tokens from one address to another
149      * @param _from address The address which you want to send tokens from
150      * @param _to address The address which you want to transfer to
151      * @param _value uint256 the amount of tokens to be transferred
152      */
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154         require(_to != address(0));
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160         emit Transfer(_from, _to, _value);
161         return true;
162     }
163     /**
164      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165      */
166     function approve(address _spender, uint256 _value) public returns (bool) {
167         allowed[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param _owner address The address which owns the funds.
174      * @param _spender address The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address _owner, address _spender) public view returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180     /**
181      * @dev Increase the amount of tokens that an owner allowed to a spender.
182      *
183      * approve should be called when allowed[_spender] == 0. To increment
184      * allowed value is better to use this function to avoid 2 calls (and wait until
185      * the first transaction is mined)
186      * From MonolithDAO Token.sol
187      * @param _spender The address which will spend the funds.
188      * @param _addedValue The amount of tokens to increase the allowance by.
189      */
190     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193         return true;
194     }
195     /**
196      * @dev Decrease the amount of tokens that an owner allowed to a spender.
197      *
198      * approve should be called when allowed[_spender] == 0. To decrement
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * @param _spender The address which will spend the funds.
203      * @param _subtractedValue The amount of tokens to decrease the allowance by.
204      */
205     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206         uint oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 }
216 
217 /**
218  * @title ERC827, an extension of ERC20 token standard
219  *
220  * @dev Implementation the ERC827, following the ERC20 standard with extra
221  * @dev methods to transfer value and data and execute calls in transfers and
222  * @dev approvals.
223  *
224  * @dev Uses OpenZeppelin StandardToken.
225  */
226 contract ERC827Token is ERC827, ERC20Token {
227     /**
228      * @dev Addition to ERC20 token methods. It allows to
229      * @dev approve the transfer of value and execute a call with the sent data.
230      *
231      * @dev Beware that changing an allowance with this method brings the risk that
232      * @dev someone may use both the old and the new allowance by unfortunate
233      * @dev transaction ordering. One possible solution to mitigate this race condition
234      * @dev is to first reduce the spender's allowance to 0 and set the desired value
235      * @dev afterwards:
236      * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      *
238      * @param _spender The address that will spend the funds.
239      * @param _value The amount of tokens to be spent.
240      * @param _data ABI-encoded contract call to call `_to` address.
241      *
242      * @return true if the call function was executed successfully
243      */
244     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool) {
245         require(_spender != address(this));
246         super.approve(_spender, _value);
247         // solium-disable-next-line security/no-call-value
248         require(_spender.call.value(msg.value)(_data));
249         return true;
250     }
251     /**
252      * @dev Addition to ERC20 token methods. Transfer tokens to a specified
253      * @dev address and execute a call with the sent data on the same transaction
254      *
255      * @param _to address The address which you want to transfer to
256      * @param _value uint256 the amout of tokens to be transfered
257      * @param _data ABI-encoded contract call to call `_to` address.
258      *
259      * @return true if the call function was executed successfully
260      */
261     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
262         require(_to != address(this));
263         super.transfer(_to, _value);
264         require(_to.call.value(msg.value)(_data));
265         return true;
266     }
267     /**
268      * @dev Addition to ERC20 token methods. Transfer tokens from one address to
269      * @dev another and make a contract call on the same transaction
270      *
271      * @param _from The address which you want to send tokens from
272      * @param _to The address which you want to transfer to
273      * @param _value The amout of tokens to be transferred
274      * @param _data ABI-encoded contract call to call `_to` address.
275      *
276      * @return true if the call function was executed successfully
277      */
278     function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public payable returns (bool) {
279         require(_to != address(this));
280         super.transferFrom(_from, _to, _value);
281         require(_to.call.value(msg.value)(_data));
282         return true;
283     }
284     /**
285      * @dev Addition to StandardToken methods. Increase the amount of tokens that
286      * @dev an owner allowed to a spender and execute a call with the sent data.
287      *
288      * @dev approve should be called when allowed[_spender] == 0. To increment
289      * @dev allowed value is better to use this function to avoid 2 calls (and wait until
290      * @dev the first transaction is mined)
291      * @dev From MonolithDAO Token.sol
292      *
293      * @param _spender The address which will spend the funds.
294      * @param _addedValue The amount of tokens to increase the allowance by.
295      * @param _data ABI-encoded contract call to call `_spender` address.
296      */
297     function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
298         require(_spender != address(this));
299         super.increaseApproval(_spender, _addedValue);
300         require(_spender.call.value(msg.value)(_data));
301         return true;
302     }
303     /**
304      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
305      * @dev an owner allowed to a spender and execute a call with the sent data.
306      *
307      * @dev approve should be called when allowed[_spender] == 0. To decrement
308      * @dev allowed value is better to use this function to avoid 2 calls (and wait until
309      * @dev the first transaction is mined)
310      * @dev From MonolithDAO Token.sol
311      *
312      * @param _spender The address which will spend the funds.
313      * @param _subtractedValue The amount of tokens to decrease the allowance by.
314      * @param _data ABI-encoded contract call to call `_spender` address.
315      */
316     function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
317         require(_spender != address(this));
318         super.decreaseApproval(_spender, _subtractedValue);
319         require(_spender.call.value(msg.value)(_data));
320         return true;
321     }
322 }
323 
324 /**
325  * @title  Burnable and Pause Token
326  * @dev    StandardToken modified with pausable transfers.
327  */
328 contract PauseBurnableERC827Token is ERC827Token, Ownable {
329     using SafeMath for uint256;
330     event Pause();
331     event Unpause();
332     event PauseOperatorTransferred(address indexed previousOperator, address indexed newOperator);
333     event Burn(address indexed burner, uint256 value);
334 
335     bool public paused = false;
336     address public pauseOperator;
337     /**
338      * @dev Throws if called by any account other than the owner.
339      */
340     modifier onlyPauseOperator() {
341         require(msg.sender == pauseOperator || msg.sender == owner);
342         _;
343     }
344     /**
345      * @dev Modifier to make a function callable only when the contract is not paused.
346      */
347     modifier whenNotPaused() {
348         require(!paused);
349         _;
350     }
351     /**
352      * @dev Modifier to make a function callable only when the contract is paused.
353      */
354     modifier whenPaused() {
355         require(paused);
356         _;
357     }
358     /**
359      * @dev The constructor sets the original `owner` of the contract to the sender
360      * account.
361      */
362     constructor() public {
363         pauseOperator = msg.sender;
364     }
365     /**
366      * @dev called by the operator to set the new operator to pause the token
367      */
368     function transferPauseOperator(address newPauseOperator) onlyPauseOperator public {
369         require(newPauseOperator != address(0));
370         emit PauseOperatorTransferred(pauseOperator, newPauseOperator);
371         pauseOperator = newPauseOperator;
372     }
373     /**
374      * @dev called by the owner to pause, triggers stopped state
375      */
376     function pause() onlyPauseOperator whenNotPaused public {
377         paused = true;
378         emit Pause();
379     }
380     /**
381      * @dev called by the owner to unpause, returns to normal state
382      */
383     function unpause() onlyPauseOperator whenPaused public {
384         paused = false;
385         emit Unpause();
386     }
387 
388     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
389         return super.transfer(_to, _value);
390     }
391 
392     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
393         return super.transferFrom(_from, _to, _value);
394     }
395 
396     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
397         return super.approve(_spender, _value);
398     }
399 
400     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
401         return super.increaseApproval(_spender, _addedValue);
402     }
403 
404     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
405         return super.decreaseApproval(_spender, _subtractedValue);
406     }
407     /**
408      * @dev Burns a specific amount of tokens.
409      * @param _value The amount of token to be burned.
410      */
411     function burn(uint256 _value) public whenNotPaused {
412         _burn(msg.sender, _value);
413     }
414 
415     function _burn(address _who, uint256 _value) internal {
416         require(_value <= balances[_who]);
417         // no need to require value <= totalSupply, since that would imply the
418         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
419         balances[_who] = balances[_who].sub(_value);
420         // Subtract from the sender
421         totalSupply_ = totalSupply_.sub(_value);
422         emit Burn(_who, _value);
423         emit Transfer(_who, address(0), _value);
424     }
425     /**
426      * @dev Burns a specific amount of tokens from the target address and decrements allowance
427      * @param _from address The address which you want to send tokens from
428      * @param _value uint256 The amount of token to be burned
429      */
430     function burnFrom(address _from, uint256 _value) public whenNotPaused {
431         require(_value <= allowed[_from][msg.sender]);
432         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
433         _burn(_from, _value);
434     }
435 }
436 
437 contract FckAirdrop is PauseBurnableERC827Token {
438     string  public constant name = "fck.com FCK";
439     string  public constant symbol = "fck.com FCK";
440     uint8   public constant decimals = 18;
441     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
442     /**
443      * @dev Constructor that gives msg.sender all of existing tokens.
444      */
445     constructor() public {
446         totalSupply_ = INITIAL_SUPPLY;
447         balances[msg.sender] = INITIAL_SUPPLY;
448         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
449     }
450     function batchTransfer(address[] _tos, uint256 _value) public whenNotPaused returns (bool) {
451         uint256 all = _value.mul(_tos.length);
452         require(balances[msg.sender] >= all);
453         for (uint i = 0; i < _tos.length; i++) {
454             require(_tos[i] != address(0));
455             require(_tos[i] != msg.sender);
456             balances[_tos[i]] = balances[_tos[i]].add(_value);
457             emit Transfer(msg.sender, _tos[i], _value);
458         }
459         balances[msg.sender] = balances[msg.sender].sub(all);
460         return true;
461     }
462 
463     function multiTransfer(address[] _tos, uint256[] _values) public whenNotPaused returns (bool) {
464         require(_tos.length == _values.length);
465         uint256 all = 0;
466         for (uint i = 0; i < _tos.length; i++) {
467             require(_tos[i] != address(0));
468             require(_tos[i] != msg.sender);
469             all = all.add(_values[i]);
470             balances[_tos[i]] = balances[_tos[i]].add(_values[i]);
471             emit Transfer(msg.sender, _tos[i], _values[i]);
472         }
473         balances[msg.sender] = balances[msg.sender].sub(all);
474         return true;
475     }
476 }