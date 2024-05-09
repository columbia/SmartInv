1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12 
13   /*@CTK SafeMath_mul
14     @tag spec
15     @post __reverted == __has_assertion_failure
16     @post __has_assertion_failure == __has_overflow
17     @post __reverted == false -> c == a * b
18     @post msg == msg__post
19    */
20   /* CertiK Smart Labelling, for more details visit: https://certik.org */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     if (a == 0) {
23       return 0;
24     }
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   /*@CTK SafeMath_div
34     @tag spec
35     @pre b != 0
36     @post __reverted == __has_assertion_failure
37     @post __has_overflow == true -> __has_assertion_failure == true
38     @post __reverted == false -> __return == a / b
39     @post msg == msg__post
40    */
41   /* CertiK Smart Labelling, for more details visit: https://certik.org */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   /*@CTK SafeMath_sub
53     @tag spec
54     @post __reverted == __has_assertion_failure
55     @post __has_overflow == true -> __has_assertion_failure == true
56     @post __reverted == false -> __return == a - b
57     @post msg == msg__post
58    */
59   /* CertiK Smart Labelling, for more details visit: https://certik.org */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   /*@CTK SafeMath_add
69     @tag spec
70     @post __reverted == __has_assertion_failure
71     @post __has_assertion_failure == __has_overflow
72     @post __reverted == false -> c == a + b
73     @post msg == msg__post
74    */
75   /* CertiK Smart Labelling, for more details visit: https://certik.org */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94 
95   /**
96    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   /*@CTK owner_set_on_success
100     @pre __reverted == false -> __post.owner == owner
101    */
102   /* CertiK Smart Labelling, for more details visit: https://certik.org */
103   function Ownable() public {
104     owner = msg.sender;
105   }
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115   /**
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117    * @param newOwner The address to transfer ownership to.
118    */
119   /*@CTK transferOwnership
120     @post __reverted == false -> (msg.sender == owner -> __post.owner == newOwner)
121     @post (owner != msg.sender) -> (__reverted == true)
122     @post (newOwner == address(0)) -> (__reverted == true)
123    */
124   /* CertiK Smart Labelling, for more details visit: https://certik.org */
125   function transferOwnership(address newOwner) public onlyOwner {
126     require(newOwner != address(0));
127     emit OwnershipTransferred(owner, newOwner);
128     owner = newOwner;
129   }
130 
131 }
132 
133 /**
134  * @title Pausable
135  * @dev Base contract which allows children to implement an emergency stop mechanism.
136  */
137 contract Pausable is Ownable {
138   event Pause();
139   event Unpause();
140 
141   bool public paused = false;
142 
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is not paused.
146    */
147   modifier whenNotPaused() {
148     require(!paused);
149     _;
150   }
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is paused.
154    */
155   modifier whenPaused() {
156     require(paused);
157     _;
158   }
159 
160   /**
161    * @dev called by the owner to pause, triggers stopped state
162    */
163   function pause() onlyOwner whenNotPaused public {
164     paused = true;
165     emit Pause();
166   }
167 
168   /**
169    * @dev called by the owner to unpause, returns to normal state
170    */
171   function unpause() onlyOwner whenPaused public {
172     paused = false;
173     emit Unpause();
174   }
175 }
176 
177 
178 /**
179  * @title ERC20Basic
180  * @dev Simpler version of ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/179
182  */
183 contract ERC20Basic {
184   function totalSupply() public view returns (uint256);
185   function balanceOf(address who) public view returns (uint256);
186   function transfer(address to, uint256 value) public returns (bool);
187   event Transfer(address indexed from, address indexed to, uint256 value);
188 }
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 /**
202  * @title Basic token
203  * @dev Basic version of StandardToken, with no allowances.
204  */
205 contract BasicToken is ERC20Basic {
206   using SafeMath for uint256;
207 
208   mapping(address => uint256) balances;
209 
210   uint256 totalSupply_;
211 
212   /**
213   * @dev total number of tokens in existence
214   */
215   function totalSupply() public view returns (uint256) {
216     return totalSupply_;
217   }
218 
219   /**
220   * @dev transfer token for a specified address
221   * @param _to The address to transfer to.
222   * @param _value The amount to be transferred.
223   */
224   /*@CTK transfer_success
225     @pre _to != address(0)
226     @pre balances[msg.sender] >= _value
227     @pre __reverted == false
228     @post __reverted == false
229     @post __return == true
230    */
231   /*@CTK transfer_same_address
232     @tag no_overflow
233     @pre _to == msg.sender
234     @post this == __post
235    */
236   /*@CTK transfer_conditions
237     @tag assume_completion
238     @pre _to != msg.sender
239     @post __post.balances[_to] == balances[_to] + _value
240     @post __post.balances[msg.sender] == balances[msg.sender] - _value
241    */
242   /* CertiK Smart Labelling, for more details visit: https://certik.org */
243   function transfer(address _to, uint256 _value) public returns (bool) {
244     require(_to != address(0));
245     require(_value <= balances[msg.sender]);
246 
247     balances[msg.sender] = balances[msg.sender].sub(_value);
248     balances[_to] = balances[_to].add(_value);
249     emit Transfer(msg.sender, _to, _value);
250     return true;
251   }
252 
253   /**
254   * @dev Gets the balance of the specified address.
255   * @param _owner The address to query the the balance of.
256   * @return An uint256 representing the amount owned by the passed address.
257   */
258   /*@CTK balanceOf
259     @post __reverted == false
260     @post __return == balances[_owner]
261    */
262   /* CertiK Smart Labelling, for more details visit: https://certik.org */
263   function balanceOf(address _owner) public view returns (uint256) {
264     return balances[_owner];
265   }
266 
267 }
268 
269 /**
270  * @title Standard ERC20 token
271  *
272  * @dev Implementation of the basic standard token.
273  * @dev https://github.com/ethereum/EIPs/issues/20
274  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
275  */
276 contract StandardToken is ERC20, BasicToken {
277 
278   mapping (address => mapping (address => uint256)) internal allowed;
279 
280 
281   /**
282    * @dev Transfer tokens from one address to another
283    * @param _from address The address which you want to send tokens from
284    * @param _to address The address which you want to transfer to
285    * @param _value uint256 the amount of tokens to be transferred
286    */
287   /*@CTK transferFrom
288     @tag assume_completion
289     @pre _from != _to
290     @post __return == true
291     @post __post.balances[_to] == balances[_to] + _value
292     @post __post.balances[_from] == balances[_from] - _value
293     @post __has_overflow == false
294    */
295   /* CertiK Smart Labelling, for more details visit: https://certik.org */
296   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
297     require(_to != address(0));
298     require(_value <= balances[_from]);
299     require(_value <= allowed[_from][msg.sender]);
300 
301     balances[_from] = balances[_from].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304     emit Transfer(_from, _to, _value);
305     return true;
306   }
307 
308   /**
309    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310    *
311    * Beware that changing an allowance with this method brings the risk that someone may use both the old
312    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
313    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
314    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
315    * @param _spender The address which will spend the funds.
316    * @param _value The amount of tokens to be spent.
317    */
318   /*@CTK approve_success
319     @post _value == 0 -> __reverted == false
320     @post allowed[msg.sender][_spender] == 0 -> __reverted == false
321    */
322   /*@CTK approve
323     @tag assume_completion
324     @post __post.allowed[msg.sender][_spender] == _value
325    */
326   /* CertiK Smart Labelling, for more details visit: https://certik.org */
327   function approve(address _spender, uint256 _value) public returns (bool) {
328     allowed[msg.sender][_spender] = _value;
329     emit Approval(msg.sender, _spender, _value);
330     return true;
331   }
332 
333   /**
334    * @dev Function to check the amount of tokens that an owner allowed to a spender.
335    * @param _owner address The address which owns the funds.
336    * @param _spender address The address which will spend the funds.
337    * @return A uint256 specifying the amount of tokens still available for the spender.
338    */
339   function allowance(address _owner, address _spender) public view returns (uint256) {
340     return allowed[_owner][_spender];
341   }
342 
343   /**
344    * @dev Increase the amount of tokens that an owner allowed to a spender.
345    *
346    * approve should be called when allowed[_spender] == 0. To increment
347    * allowed value is better to use this function to avoid 2 calls (and wait until
348    * the first transaction is mined)
349    * From MonolithDAO Token.sol
350    * @param _spender The address which will spend the funds.
351    * @param _addedValue The amount of tokens to increase the allowance by.
352    */
353   /*@CTK CtkIncreaseApprovalEffect
354     @tag assume_completion
355     @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] + _addedValue
356     @post __has_overflow == false
357    */
358   /* CertiK Smart Labelling, for more details visit: https://certik.org */
359   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
360     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365   /**
366    * @dev Decrease the amount of tokens that an owner allowed to a spender.
367    *
368    * approve should be called when allowed[_spender] == 0. To decrement
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _subtractedValue The amount of tokens to decrease the allowance by.
374    */
375   /*@CTK CtkDecreaseApprovalEffect_1
376     @pre allowed[msg.sender][_spender] >= _subtractedValue
377     @tag assume_completion
378     @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] - _subtractedValue
379     @post __has_overflow == false
380    */
381    /*@CTK CtkDecreaseApprovalEffect_2
382     @pre allowed[msg.sender][_spender] < _subtractedValue
383     @tag assume_completion
384     @post __post.allowed[msg.sender][_spender] == 0
385     @post __has_overflow == false
386    */
387   /* CertiK Smart Labelling, for more details visit: https://certik.org */
388   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
389     uint oldValue = allowed[msg.sender][_spender];
390     if (_subtractedValue > oldValue) {
391       allowed[msg.sender][_spender] = 0;
392     } else {
393       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
394     }
395     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
396     return true;
397   }
398 
399 }
400 
401 contract IoTeXNetwork is StandardToken, Pausable {
402     string public constant name = "IoTeX Network";
403     string public constant symbol = "IOTX";
404     uint8 public constant decimals = 18;
405 
406     modifier validDestination(address to) {
407         require(to != address(0x0));
408         require(to != address(this) );
409         _;
410     }
411 
412     function IoTeXNetwork(uint tokenTotalAmount) {
413         totalSupply_ = tokenTotalAmount;
414         balances[msg.sender] = tokenTotalAmount;
415         emit Transfer(address(0x0), msg.sender, tokenTotalAmount);
416     }
417 
418     /*@CTK CtkTransferNoEffect
419       @post (_to == address(0)) \/ (paused == true) -> __reverted == true
420      */
421     /*@CTK CtkTransferEffect
422       @pre __reverted == false
423       @pre balances[msg.sender] >= _value
424       @pre paused == false
425       @pre __return == true
426       @pre msg.sender != _to
427       @post __post.balances[_to] == balances[_to] + _value
428       @post __has_overflow == false
429      */
430     /* CertiK Smart Labelling, for more details visit: https://certik.org */
431     function transfer(address _to, uint _value) whenNotPaused
432         validDestination(_to)
433         returns (bool) {
434         return super.transfer(_to, _value);
435     }
436 
437     /*@CTK CtkTransferFromNoEffect
438       @post (_to == address(0)) \/ (paused == true) -> __reverted == true
439      */
440     /*@CTK CtkTransferFromEffect
441       @tag assume_completion
442       @pre _from != _to
443       @post __post.balances[_to] == balances[_to] + _value
444       @post __post.balances[_from] == balances[_from] - _value
445       @post __has_overflow == false
446      */
447     /* CertiK Smart Labelling, for more details visit: https://certik.org */
448     function transferFrom(address _from, address _to, uint _value) whenNotPaused
449         validDestination(_to)
450         returns (bool) {
451         return super.transferFrom(_from, _to, _value);
452     }
453 
454     /*@CTK CtkApproveNoEffect
455       @post (paused == true) -> __post == this
456      */
457     /*@CTK CtkApprove
458       @tag assume_completion
459       @post __post.allowed[msg.sender][_spender] == _value
460      */
461     /* CertiK Smart Labelling, for more details visit: https://certik.org */
462     function approve(address _spender, uint256 _value) public whenNotPaused
463       returns (bool) {
464       return super.approve(_spender, _value);
465     }
466 
467     /*@CTK CtkIncreaseApprovalNoEffect
468       @post (paused == true) -> __reverted == true
469      */
470     /*@CTK CtkIncreaseApprovalEffect
471       @pre paused == false
472       @tag assume_completion
473       @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] + _addedValue
474       @post __has_overflow == false
475      */
476     /* CertiK Smart Labelling, for more details visit: https://certik.org */
477     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused
478       returns (bool success) {
479       return super.increaseApproval(_spender, _addedValue);
480     }
481 
482     /*@CTK CtkDecreaseApprovalNoEffect
483       @post (paused == true) -> __reverted == true
484      */
485     /*@CTK CtkDecreaseApprovalEffect
486       @pre allowed[msg.sender][_spender] >= _subtractedValue
487       @tag assume_completion
488       @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] - _subtractedValue
489       @post __has_overflow == false
490      */
491     /* CertiK Smart Labelling, for more details visit: https://certik.org */
492     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused
493       returns (bool success) {
494       return super.decreaseApproval(_spender, _subtractedValue);
495     }
496 }