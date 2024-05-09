1 pragma solidity ^0.5.7;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   /*@CTK SafeMath_mul
11     @tag spec
12     @post __reverted == __has_assertion_failure
13     @post __has_assertion_failure == __has_overflow
14     @post __reverted == false -> c == a * b
15     @post msg == msg__post
16    */
17   /* CertiK Smart Labelling, for more details visit: https://certik.org */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19     if (a == 0) {
20       return 0;
21     }
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   /*@CTK SafeMath_div
30     @tag spec
31     @pre b != 0
32     @post __reverted == __has_assertion_failure
33     @post __has_overflow == true -> __has_assertion_failure == true
34     @post __reverted == false -> __return == a / b
35     @post msg == msg__post
36    */
37   /* CertiK Smart Labelling, for more details visit: https://certik.org */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   /*@CTK SafeMath_sub
48     @tag spec
49     @post __reverted == __has_assertion_failure
50     @post __has_overflow == true -> __has_assertion_failure == true
51     @post __reverted == false -> __return == a - b
52     @post msg == msg__post
53    */
54   /* CertiK Smart Labelling, for more details visit: https://certik.org */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   /*@CTK SafeMath_add
63     @tag spec
64     @post __reverted == __has_assertion_failure
65     @post __has_assertion_failure == __has_overflow
66     @post __reverted == false -> c == a + b
67     @post msg == msg__post
68    */
69   /* CertiK Smart Labelling, for more details visit: https://certik.org */
70   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 /**
77  * @title Ownable
78  * @dev The Ownable contract has an owner address, and provides basic authorization control
79  * functions, this simplifies the implementation of "user permissions".
80  */
81 contract Ownable {
82   address public owner;
83   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   /*@CTK owner_set_on_success
89     @pre __reverted == false -> __post.owner == owner
90    */
91   /* CertiK Smart Labelling, for more details visit: https://certik.org */
92   constructor() public {
93     owner = msg.sender;
94   }
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param newOwner The address to transfer ownership to.
105    */
106   /*@CTK transferOwnership
107     @post __reverted == false -> (msg.sender == owner -> __post.owner == newOwner)
108     @post (owner != msg.sender) -> (__reverted == true)
109     @post (newOwner == address(0)) -> (__reverted == true)
110    */
111   /* CertiK Smart Labelling, for more details visit: https://certik.org */
112   function transferOwnership(address newOwner) public onlyOwner {
113     require(newOwner != address(0));
114     emit OwnershipTransferred(owner, newOwner);
115     owner = newOwner;
116   }
117 }
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123   event Pause();
124   event Unpause();
125   bool public paused = false;
126   /**
127    * @dev Modifier to make a function callable only when the contract is not paused.
128    */
129   modifier whenNotPaused() {
130     require(!paused);
131     _;
132   }
133   /**
134    * @dev Modifier to make a function callable only when the contract is paused.
135    */
136   modifier whenPaused() {
137     require(paused);
138     _;
139   }
140   /**
141    * @dev called by the owner to pause, triggers stopped state
142    */
143   function pause() onlyOwner whenNotPaused public {
144     paused = true;
145     emit Pause();
146   }
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     emit Unpause();
153   }
154 }
155 /**
156  * @title ERC20Basic
157  * @dev Simpler version of ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/179
159  */
160 contract ERC20Basic {
161   function totalSupply() public view returns (uint256);
162   function balanceOf(address who) public view returns (uint256);
163   function transfer(address to, uint256 value) public returns (bool);
164   event Transfer(address indexed from, address indexed to, uint256 value);
165 }
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public view returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181   using SafeMath for uint256;
182   mapping(address => uint256) balances;
183   uint256 totalSupply_;
184   /**
185   * @dev total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256) {
188     return totalSupply_;
189   }
190   /**
191   * @dev transfer token for a specified address
192   * @param _to The address to transfer to.
193   * @param _value The amount to be transferred.
194   */
195   /*@CTK transfer_success
196     @pre _to != address(0)
197     @pre balances[msg.sender] >= _value
198     @pre __reverted == false
199     @post __reverted == false
200     @post __return == true
201    */
202   /*@CTK transfer_same_address
203     @tag no_overflow
204     @pre _to == msg.sender
205     @post this == __post
206    */
207   /*@CTK transfer_conditions
208     @tag assume_completion
209     @pre _to != msg.sender
210     @post __post.balances[_to] == balances[_to] + _value
211     @post __post.balances[msg.sender] == balances[msg.sender] - _value
212    */
213   /* CertiK Smart Labelling, for more details visit: https://certik.org */
214   function transfer(address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[msg.sender]);
217     balances[msg.sender] = balances[msg.sender].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     emit Transfer(msg.sender, _to, _value);
220     return true;
221   }
222   /**
223   * @dev Gets the balance of the specified address.
224   * @param _owner The address to query the the balance of.
225   * @return An uint256 representing the amount owned by the passed address.
226   */
227   /*@CTK balanceOf
228     @post __reverted == false
229     @post __return == balances[_owner]
230    */
231   /* CertiK Smart Labelling, for more details visit: https://certik.org */
232   function balanceOf(address _owner) public view returns (uint256) {
233     return balances[_owner];
234   }
235 }
236 /**
237  * @title Standard ERC20 token
238  *
239  * @dev Implementation of the basic standard token.
240  * @dev https://github.com/ethereum/EIPs/issues/20
241  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
242  */
243 contract StandardToken is ERC20, BasicToken {
244   mapping (address => mapping (address => uint256)) internal allowed;
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   /*@CTK transferFrom
252     @tag assume_completion
253     @pre _from != _to
254     @post __return == true
255     @post __post.balances[_to] == balances[_to] + _value
256     @post __post.balances[_from] == balances[_from] - _value
257     @post __has_overflow == false
258    */
259   /* CertiK Smart Labelling, for more details visit: https://certik.org */
260   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
261     require(_to != address(0));
262     require(_value <= balances[_from]);
263     require(_value <= allowed[_from][msg.sender]);
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270   /**
271    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
272    *
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   /*@CTK approve_success
281     @post _value == 0 -> __reverted == false
282     @post allowed[msg.sender][_spender] == 0 -> __reverted == false
283    */
284   /*@CTK approve
285     @tag assume_completion
286     @post __post.allowed[msg.sender][_spender] == _value
287    */
288   /* CertiK Smart Labelling, for more details visit: https://certik.org */
289   function approve(address _spender, uint256 _value) public returns (bool) {
290     allowed[msg.sender][_spender] = _value;
291     emit Approval(msg.sender, _spender, _value);
292     return true;
293   }
294   /**
295    * @dev Function to check the amount of tokens that an owner allowed to a spender.
296    * @param _owner address The address which owns the funds.
297    * @param _spender address The address which will spend the funds.
298    * @return A uint256 specifying the amount of tokens still available for the spender.
299    */
300   function allowance(address _owner, address _spender) public view returns (uint256) {
301     return allowed[_owner][_spender];
302   }
303   /**
304    * @dev Increase the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To increment
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _addedValue The amount of tokens to increase the allowance by.
312    */
313   /*@CTK CtkIncreaseApprovalEffect
314     @tag assume_completion
315     @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] + _addedValue
316     @post __has_overflow == false
317    */
318   /* CertiK Smart Labelling, for more details visit: https://certik.org */
319   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
320     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324   /**
325    * @dev Decrease the amount of tokens that an owner allowed to a spender.
326    *
327    * approve should be called when allowed[_spender] == 0. To decrement
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol
331    * @param _spender The address which will spend the funds.
332    * @param _subtractedValue The amount of tokens to decrease the allowance by.
333    */
334   /*@CTK CtkDecreaseApprovalEffect_1
335     @pre allowed[msg.sender][_spender] >= _subtractedValue
336     @tag assume_completion
337     @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] - _subtractedValue
338     @post __has_overflow == false
339    */
340    /*@CTK CtkDecreaseApprovalEffect_2
341     @pre allowed[msg.sender][_spender] < _subtractedValue
342     @tag assume_completion
343     @post __post.allowed[msg.sender][_spender] == 0
344     @post __has_overflow == false
345    */
346   /* CertiK Smart Labelling, for more details visit: https://certik.org */
347   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
348     uint oldValue = allowed[msg.sender][_spender];
349     if (_subtractedValue > oldValue) {
350       allowed[msg.sender][_spender] = 0;
351     } else {
352       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
353     }
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 }
358 contract FrankToken is StandardToken, Pausable {
359     string public constant name = "Frank Token";
360     string public constant symbol = "FT";
361     uint8 public constant decimals = 0;
362     modifier validDestination(address to) {
363         require(to != address(0x0));
364         require(to != address(this));
365         _;
366     }
367     constructor(uint tokenTotalAmount) public {
368         totalSupply_ = tokenTotalAmount;
369         balances[msg.sender] = tokenTotalAmount;
370         emit Transfer(address(0x0), msg.sender, tokenTotalAmount);
371     }
372     /*@CTK CtkTransferNoEffect
373       @post (_to == address(0)) \/ (paused == true) -> __reverted == true
374      */
375     /*@CTK CtkTransferEffect
376       @pre __reverted == false
377       @pre balances[msg.sender] >= _value
378       @pre paused == false
379       @pre __return == true
380       @pre msg.sender != _to
381       @post __post.balances[_to] == balances[_to] + _value
382       @post __has_overflow == false
383      */
384     /* CertiK Smart Labelling, for more details visit: https://certik.org */
385     function transfer(address _to, uint _value) public whenNotPaused
386         validDestination(_to)
387         returns (bool) {
388         return super.transfer(_to, _value);
389     }
390     /*@CTK CtkTransferFromNoEffect
391       @post (_to == address(0)) \/ (paused == true) -> __reverted == true
392      */
393     /*@CTK CtkTransferFromEffect
394       @tag assume_completion
395       @pre _from != _to
396       @post __post.balances[_to] == balances[_to] + _value
397       @post __post.balances[_from] == balances[_from] - _value
398       @post __has_overflow == false
399      */
400     /* CertiK Smart Labelling, for more details visit: https://certik.org */
401     function transferFrom(address _from, address _to, uint _value) public whenNotPaused
402         validDestination(_to)
403         returns (bool) {
404         return super.transferFrom(_from, _to, _value);
405     }
406     /*@CTK CtkApproveNoEffect
407       @post (paused == true) -> __post == this
408      */
409     /*@CTK CtkApprove
410       @tag assume_completion
411       @post __post.allowed[msg.sender][_spender] == _value
412      */
413     /* CertiK Smart Labelling, for more details visit: https://certik.org */
414     function approve(address _spender, uint256 _value) public whenNotPaused
415       returns (bool) {
416       return super.approve(_spender, _value);
417     }
418     /*@CTK CtkIncreaseApprovalNoEffect
419       @post (paused == true) -> __reverted == true
420      */
421     /*@CTK CtkIncreaseApprovalEffect
422       @pre paused == false
423       @tag assume_completion
424       @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] + _addedValue
425       @post __has_overflow == false
426      */
427     /* CertiK Smart Labelling, for more details visit: https://certik.org */
428     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused
429       returns (bool success) {
430       return super.increaseApproval(_spender, _addedValue);
431     }
432     /*@CTK CtkDecreaseApprovalNoEffect
433       @post (paused == true) -> __reverted == true
434      */
435     /*@CTK CtkDecreaseApprovalEffect
436       @pre allowed[msg.sender][_spender] >= _subtractedValue
437       @tag assume_completion
438       @post __post.allowed[msg.sender][_spender] == allowed[msg.sender][_spender] - _subtractedValue
439       @post __has_overflow == false
440      */
441     /* CertiK Smart Labelling, for more details visit: https://certik.org */
442     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused
443       returns (bool success) {
444       return super.decreaseApproval(_spender, _subtractedValue);
445     }
446 }