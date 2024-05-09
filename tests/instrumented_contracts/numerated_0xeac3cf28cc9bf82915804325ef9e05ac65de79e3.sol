1 pragma solidity ^0.4.19;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function totalSupply() public view returns (uint256);
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 /**
157    @title ERC827 interface, an extension of ERC20 token standard
158 
159    Interface of a ERC827 token, following the ERC20 standard with extra
160    methods to transfer value and data and execute calls in transfers and
161    approvals.
162  */
163 contract ERC827 is ERC20 {
164 
165   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
166   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
167   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
168 
169 }
170 
171 /**
172  * @title Basic token
173  * @dev Basic version of StandardToken, with no allowances.
174  */
175 contract BasicToken is ERC20Basic {
176   using SafeMath for uint256;
177 
178   mapping(address => uint256) balances;
179 
180   uint256 totalSupply_;
181 
182   /**
183   * @dev total number of tokens in existence
184   */
185   function totalSupply() public view returns (uint256) {
186     return totalSupply_;
187   }
188 
189   /**
190   * @dev transfer token for a specified address
191   * @param _to The address to transfer to.
192   * @param _value The amount to be transferred.
193   */
194   function transfer(address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[msg.sender]);
197 
198     // SafeMath.sub will throw if there is not enough balance.
199     balances[msg.sender] = balances[msg.sender].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     Transfer(msg.sender, _to, _value);
202     return true;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param _owner The address to query the the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address _owner) public view returns (uint256 balance) {
211     return balances[_owner];
212   }
213 
214 }
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, BasicToken {
224 
225   mapping (address => mapping (address => uint256)) internal allowed;
226 
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param _from address The address which you want to send tokens from
231    * @param _to address The address which you want to transfer to
232    * @param _value uint256 the amount of tokens to be transferred
233    */
234   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235     require(_to != address(0));
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
248    *
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(address _owner, address _spender) public view returns (uint256) {
269     return allowed[_owner][_spender];
270   }
271 
272   /**
273    * @dev Increase the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
299     uint oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue > oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 /**
312    @title ERC827, an extension of ERC20 token standard
313 
314    Implementation the ERC827, following the ERC20 standard with extra
315    methods to transfer value and data and execute calls in transfers and
316    approvals.
317    Uses OpenZeppelin StandardToken.
318  */
319 contract ERC827Token is ERC827, StandardToken {
320 
321   /**
322      @dev Addition to ERC20 token methods. It allows to
323      approve the transfer of value and execute a call with the sent data.
324 
325      Beware that changing an allowance with this method brings the risk that
326      someone may use both the old and the new allowance by unfortunate
327      transaction ordering. One possible solution to mitigate this race condition
328      is to first reduce the spender's allowance to 0 and set the desired value
329      afterwards:
330      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331 
332      @param _spender The address that will spend the funds.
333      @param _value The amount of tokens to be spent.
334      @param _data ABI-encoded contract call to call `_to` address.
335 
336      @return true if the call function was executed successfully
337    */
338   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
339     require(_spender != address(this));
340 
341     super.approve(_spender, _value);
342 
343     require(_spender.call(_data));
344 
345     return true;
346   }
347 
348   /**
349      @dev Addition to ERC20 token methods. Transfer tokens to a specified
350      address and execute a call with the sent data on the same transaction
351 
352      @param _to address The address which you want to transfer to
353      @param _value uint256 the amout of tokens to be transfered
354      @param _data ABI-encoded contract call to call `_to` address.
355 
356      @return true if the call function was executed successfully
357    */
358   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
359     require(_to != address(this));
360 
361     super.transfer(_to, _value);
362 
363     require(_to.call(_data));
364     return true;
365   }
366 
367   /**
368      @dev Addition to ERC20 token methods. Transfer tokens from one address to
369      another and make a contract call on the same transaction
370 
371      @param _from The address which you want to send tokens from
372      @param _to The address which you want to transfer to
373      @param _value The amout of tokens to be transferred
374      @param _data ABI-encoded contract call to call `_to` address.
375 
376      @return true if the call function was executed successfully
377    */
378   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
379     require(_to != address(this));
380 
381     super.transferFrom(_from, _to, _value);
382 
383     require(_to.call(_data));
384     return true;
385   }
386 
387   /**
388    * @dev Addition to StandardToken methods. Increase the amount of tokens that
389    * an owner allowed to a spender and execute a call with the sent data.
390    *
391    * approve should be called when allowed[_spender] == 0. To increment
392    * allowed value is better to use this function to avoid 2 calls (and wait until
393    * the first transaction is mined)
394    * From MonolithDAO Token.sol
395    * @param _spender The address which will spend the funds.
396    * @param _addedValue The amount of tokens to increase the allowance by.
397    * @param _data ABI-encoded contract call to call `_spender` address.
398    */
399   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
400     require(_spender != address(this));
401 
402     super.increaseApproval(_spender, _addedValue);
403 
404     require(_spender.call(_data));
405 
406     return true;
407   }
408 
409   /**
410    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
411    * an owner allowed to a spender and execute a call with the sent data.
412    *
413    * approve should be called when allowed[_spender] == 0. To decrement
414    * allowed value is better to use this function to avoid 2 calls (and wait until
415    * the first transaction is mined)
416    * From MonolithDAO Token.sol
417    * @param _spender The address which will spend the funds.
418    * @param _subtractedValue The amount of tokens to decrease the allowance by.
419    * @param _data ABI-encoded contract call to call `_spender` address.
420    */
421   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
422     require(_spender != address(this));
423 
424     super.decreaseApproval(_spender, _subtractedValue);
425 
426     require(_spender.call(_data));
427 
428     return true;
429   }
430 
431 }
432 
433 /**
434  * @title JOYToken
435  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
436  * Note they can later distribute these tokens as they wish using `transfer` and other
437  * `StandardToken` functions.
438  */
439 contract JOYToken is Pausable, ERC827Token {
440 
441     string public constant name = "BLOCK JOY";
442     string public constant symbol = "JOY";
443     uint256 public constant decimals = 18;
444 
445     uint256 public constant exchangeRatio = 10000;
446     uint256 public constant sellCut = 1000;
447 
448     uint256 public incomeFees;
449     address public cfoAddress;
450 
451     event Buy(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);
452     event Sell(address indexed seller, uint256 tokenAmount, uint256 ethAmount);
453 
454     function JOYToken() public {
455         cfoAddress = msg.sender;
456     }
457 
458     // @dev sell token
459     function sell(uint256 _tokenCount) external {
460         require(_tokenCount > 0);
461         require(_tokenCount <= balances[msg.sender]);
462         balances[msg.sender] = balances[msg.sender].sub(_tokenCount);
463         totalSupply_ = totalSupply_.sub(_tokenCount);
464         Transfer(msg.sender, 0x0, _tokenCount);
465         uint256 value = _tokenCount.div(exchangeRatio);
466         uint256 cut = value.div(sellCut);
467         value = value.sub(cut);
468         Sell(msg.sender, _tokenCount, value);
469         if (cut > 0) {
470             incomeFees = incomeFees.add(cut);
471         }
472         if (value > 0) {
473             msg.sender.transfer(value);
474         }
475     }
476 
477     function setCFO(address _newCFO) external onlyOwner {
478         require(_newCFO != address(0));
479 
480         cfoAddress = _newCFO;
481     }
482 
483     modifier onlyCFO() {
484         require(msg.sender == cfoAddress);
485         _;
486     }
487 
488     /// @dev Remove all fees from the contract
489     function withdrawFees(uint256 _value) external onlyCFO {
490 
491         // We are using this boolean method to make sure that even if one fails it will still work
492         require(_value <= incomeFees);
493         incomeFees = incomeFees.sub(_value);
494         cfoAddress.transfer(_value);
495     }
496 
497     // @dev buy token
498     function() external payable whenNotPaused {
499         require(msg.value > 0);
500         uint256 _count = msg.value;
501         uint256 tokenCount = _count.mul(exchangeRatio);
502         
503         totalSupply_ = totalSupply_.add(tokenCount);
504         balances[msg.sender] = balances[msg.sender].add(tokenCount);
505         Buy(msg.sender, _count, tokenCount);
506         Transfer(0x0, msg.sender, tokenCount);
507     }
508 }