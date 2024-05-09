1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
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
58   event OwnershipRenounced(address indexed previousOwner);
59   event OwnershipTransferred(
60     address indexed previousOwner,
61     address indexed newOwner
62   );
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 }
99 
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 
114 /**
115  * @title Pausable
116  * @dev Base contract which allows children to implement an emergency stop mechanism.
117  */
118 contract Pausable is Ownable {
119   event Pause();
120   event Unpause();
121 
122   bool public paused = false;
123 
124 
125   /**
126    * @dev Modifier to make a function callable only when the contract is not paused.
127    */
128   modifier whenNotPaused() {
129     require(!paused);
130     _;
131   }
132 
133   /**
134    * @dev Modifier to make a function callable only when the contract is paused.
135    */
136   modifier whenPaused() {
137     require(paused);
138     _;
139   }
140 
141   /**
142    * @dev called by the owner to pause, triggers stopped state
143    */
144   function pause() onlyOwner whenNotPaused public {
145     paused = true;
146     emit Pause();
147   }
148 
149   /**
150    * @dev called by the owner to unpause, returns to normal state
151    */
152   function unpause() onlyOwner whenPaused public {
153     paused = false;
154     emit Unpause();
155   }
156 }
157 
158 /**
159  * @title Basic token
160  * @dev Basic version of StandardToken, with no allowances.
161  */
162 contract BasicToken is ERC20Basic {
163   using SafeMath for uint256;
164 
165   mapping(address => uint256) balances;
166 
167   uint256 totalSupply_;
168 
169   /**
170   * @dev total number of tokens in existence
171   */
172   function totalSupply() public view returns (uint256) {
173     return totalSupply_;
174   }
175 
176   /**
177   * @dev transfer token for a specified address
178   * @param _to The address to transfer to.
179   * @param _value The amount to be transferred.
180   */
181   function transfer(address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[msg.sender]);
184 
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     emit Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 /**
203  * @title ERC20 interface
204  * @dev see https://github.com/ethereum/EIPs/issues/20
205  */
206 contract ERC20 is ERC20Basic {
207   function allowance(address owner, address spender)
208     public view returns (uint256);
209 
210   function transferFrom(address from, address to, uint256 value)
211     public returns (bool);
212 
213   function approve(address spender, uint256 value) public returns (bool);
214   event Approval(
215     address indexed owner,
216     address indexed spender,
217     uint256 value
218   );
219 }
220 
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) internal allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(
241     address _from,
242     address _to,
243     uint256 _value
244   )
245     public
246     returns (bool)
247   {
248     require(_to != address(0));
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     emit Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    *
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value) public returns (bool) {
270     allowed[msg.sender][_spender] = _value;
271     emit Approval(msg.sender, _spender, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Function to check the amount of tokens that an owner allowed to a spender.
277    * @param _owner address The address which owns the funds.
278    * @param _spender address The address which will spend the funds.
279    * @return A uint256 specifying the amount of tokens still available for the spender.
280    */
281   function allowance(
282     address _owner,
283     address _spender
284    )
285     public
286     view
287     returns (uint256)
288   {
289     return allowed[_owner][_spender];
290   }
291 
292   /**
293    * @dev Increase the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To increment
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _addedValue The amount of tokens to increase the allowance by.
301    */
302   function increaseApproval(
303     address _spender,
304     uint _addedValue
305   )
306     public
307     returns (bool)
308   {
309     allowed[msg.sender][_spender] = (
310       allowed[msg.sender][_spender].add(_addedValue));
311     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315   /**
316    * @dev Decrease the amount of tokens that an owner allowed to a spender.
317    *
318    * approve should be called when allowed[_spender] == 0. To decrement
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _subtractedValue The amount of tokens to decrease the allowance by.
324    */
325   function decreaseApproval(
326     address _spender,
327     uint _subtractedValue
328   )
329     public
330     returns (bool)
331   {
332     uint oldValue = allowed[msg.sender][_spender];
333     if (_subtractedValue > oldValue) {
334       allowed[msg.sender][_spender] = 0;
335     } else {
336       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
337     }
338     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341 
342 }
343 
344 
345 /**
346  * @title Burnable Token
347  * @dev Token that can be irreversibly burned (destroyed).
348  */
349 contract BurnableToken is BasicToken {
350 
351   event Burn(address indexed burner, uint256 value);
352 
353   /**
354    * @dev Burns a specific amount of tokens.
355    * @param _value The amount of token to be burned.
356    */
357   function burn(uint256 _value) public {
358     _burn(msg.sender, _value);
359   }
360 
361   function _burn(address _who, uint256 _value) internal {
362     require(_value <= balances[_who]);
363     // no need to require value <= totalSupply, since that would imply the
364     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
365 
366     balances[_who] = balances[_who].sub(_value);
367     totalSupply_ = totalSupply_.sub(_value);
368     emit Burn(_who, _value);
369     emit Transfer(_who, address(0), _value);
370   }
371 }
372 
373 /**
374  * @title Pausable token
375  * @dev StandardToken modified with pausable transfers.
376  **/
377 contract PausableToken is StandardToken, Pausable {
378 
379   function transfer(
380     address _to,
381     uint256 _value
382   )
383     public
384     whenNotPaused
385     returns (bool)
386   {
387     return super.transfer(_to, _value);
388   }
389 
390   function transferFrom(
391     address _from,
392     address _to,
393     uint256 _value
394   )
395     public
396     whenNotPaused
397     returns (bool)
398   {
399     return super.transferFrom(_from, _to, _value);
400   }
401 
402   function approve(
403     address _spender,
404     uint256 _value
405   )
406     public
407     whenNotPaused
408     returns (bool)
409   {
410     return super.approve(_spender, _value);
411   }
412 
413   function increaseApproval(
414     address _spender,
415     uint _addedValue
416   )
417     public
418     whenNotPaused
419     returns (bool success)
420   {
421     return super.increaseApproval(_spender, _addedValue);
422   }
423 
424   function decreaseApproval(
425     address _spender,
426     uint _subtractedValue
427   )
428     public
429     whenNotPaused
430     returns (bool success)
431   {
432     return super.decreaseApproval(_spender, _subtractedValue);
433   }
434 
435   // inputs passed in to this function based on the parameters above.
436   function batchTransfer(address[] _receivers, uint256 _value) public  whenNotPaused returns (bool) {
437 
438       // cnt = 2
439       uint cnt = _receivers.length;
440       // the limit of uint before it overflows is 2**256-1
441       // which is 1.15792089237316195423570985008E+77
442       // so the value passed in is 5.78960446186580977117854925043E+76
443       // multipled by cnt(2), the amount is now overflowed, ie = 0.
444       uint256 amount = uint256(cnt).mul(_value);
445 
446       // cnt fulfils this condition
447       require(cnt > 0 && cnt <= 100);
448       // _value is > 0 and balances[msg.sender] always >= 0
449       require(_value > 0 && balances[msg.sender] >= amount);
450       // sender's acct not affected after it was subtracted by 0
451       balances[msg.sender] = balances[msg.sender].sub(amount);
452       // for loop is limited to 20. there will always be enough gas.
453       for (uint i = 0; i < cnt; i++) {
454           // both receiver address gets lots of free money here!
455           balances[_receivers[i]] = balances[_receivers[i]].add(_value);
456           emit Transfer(msg.sender, _receivers[i], _value);
457       }
458       return true;
459     }
460 }
461 
462 /**
463  * @title KaiGameCoin
464  * @dev KaiGameCoin is Pausable and Burnable.
465  **/
466 
467 contract KaiGameCoin is PausableToken, BurnableToken {
468   string public name = "KaiGameCoin";
469   string public symbol = "KGC";
470   uint public decimals = 18;
471   uint public INITIAL_SUPPLY = 1000000000 * (10 ** decimals);
472 
473   constructor() public {
474     totalSupply_ = INITIAL_SUPPLY;
475     balances[msg.sender] = INITIAL_SUPPLY;
476   }
477 }