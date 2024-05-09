1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
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
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipRenounced(address indexed previousOwner);
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
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
78    * @dev Allows the current owner to relinquish control of the contract.
79    * @notice Renouncing to ownership will leave the contract without an owner.
80    * It will not be possible to call the functions with the `onlyOwner`
81    * modifier anymore.
82    */
83   function renounceOwnership() public onlyOwner {
84     emit OwnershipRenounced(owner);
85     owner = address(0);
86   }
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param _newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address _newOwner) public onlyOwner {
93     _transferOwnership(_newOwner);
94   }
95 
96   /**
97    * @dev Transfers control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function _transferOwnership(address _newOwner) internal {
101     require(_newOwner != address(0));
102     emit OwnershipTransferred(owner, _newOwner);
103     owner = _newOwner;
104   }
105 }
106 
107 
108 contract Pausable is Ownable {
109   event Pause();
110   event Unpause();
111 
112   bool public paused = false;
113 
114 
115   /**
116    * @dev Modifier to make a function callable only when the contract is not paused.
117    */
118   modifier whenNotPaused() {
119     require(!paused);
120     _;
121   }
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is paused.
125    */
126   modifier whenPaused() {
127     require(paused);
128     _;
129   }
130 
131   /**
132    * @dev called by the owner to pause, triggers stopped state
133    */
134   function pause() onlyOwner whenNotPaused public {
135     paused = true;
136     emit Pause();
137   }
138 
139   /**
140    * @dev called by the owner to unpause, returns to normal state
141    */
142   function unpause() onlyOwner whenPaused public {
143     paused = false;
144     emit Unpause();
145   }
146 }
147 
148 
149 contract ERC20Basic {
150   function totalSupply() public view returns (uint256);
151   function balanceOf(address who) public view returns (uint256);
152   function transfer(address to, uint256 value) public returns (bool);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 }
155 
156 
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender)
159     public view returns (uint256);
160 
161   function transferFrom(address from, address to, uint256 value)
162     public returns (bool);
163 
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(
166     address indexed owner,
167     address indexed spender,
168     uint256 value
169   );
170 }
171 
172 
173 contract BasicToken is ERC20Basic {
174   using SafeMath for uint256;
175 
176   mapping(address => uint256) balances;
177 
178   uint256 totalSupply_;
179 
180   /**
181   * @dev Total number of tokens in existence
182   */
183   function totalSupply() public view returns (uint256) {
184     return totalSupply_;
185   }
186 
187   /**
188   * @dev Transfer token for a specified address
189   * @param _to The address to transfer to.
190   * @param _value The amount to be transferred.
191   */
192   function transfer(address _to, uint256 _value) public returns (bool) {
193     require(_to != address(0));
194     require(_value <= balances[msg.sender]);
195 
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     emit Transfer(msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203   * @dev Gets the balance of the specified address.
204   * @param _owner The address to query the the balance of.
205   * @return An uint256 representing the amount owned by the passed address.
206   */
207   function balanceOf(address _owner) public view returns (uint256) {
208     return balances[_owner];
209   }
210 
211 }
212 
213 
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) internal allowed;
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(
226     address _from,
227     address _to,
228     uint256 _value
229   )
230     public
231     returns (bool)
232   {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     emit Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     emit Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(
266     address _owner,
267     address _spender
268    )
269     public
270     view
271     returns (uint256)
272   {
273     return allowed[_owner][_spender];
274   }
275 
276   /**
277    * @dev Increase the amount of tokens that an owner allowed to a spender.
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _addedValue The amount of tokens to increase the allowance by.
284    */
285   function increaseApproval(
286     address _spender,
287     uint256 _addedValue
288   )
289     public
290     returns (bool)
291   {
292     allowed[msg.sender][_spender] = (
293       allowed[msg.sender][_spender].add(_addedValue));
294     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298   /**
299    * @dev Decrease the amount of tokens that an owner allowed to a spender.
300    * approve should be called when allowed[_spender] == 0. To decrement
301    * allowed value is better to use this function to avoid 2 calls (and wait until
302    * the first transaction is mined)
303    * From MonolithDAO Token.sol
304    * @param _spender The address which will spend the funds.
305    * @param _subtractedValue The amount of tokens to decrease the allowance by.
306    */
307   function decreaseApproval(
308     address _spender,
309     uint256 _subtractedValue
310   )
311     public
312     returns (bool)
313   {
314     uint256 oldValue = allowed[msg.sender][_spender];
315     if (_subtractedValue > oldValue) {
316       allowed[msg.sender][_spender] = 0;
317     } else {
318       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319     }
320     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321     return true;
322   }
323 
324 }
325 
326 
327 contract PausableToken is StandardToken, Pausable {
328 
329   function transfer(
330     address _to,
331     uint256 _value
332   )
333     public
334     whenNotPaused
335     returns (bool)
336   {
337     return super.transfer(_to, _value);
338   }
339 
340   function transferFrom(
341     address _from,
342     address _to,
343     uint256 _value
344   )
345     public
346     whenNotPaused
347     returns (bool)
348   {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   function approve(
353     address _spender,
354     uint256 _value
355   )
356     public
357     whenNotPaused
358     returns (bool)
359   {
360     return super.approve(_spender, _value);
361   }
362 
363   function increaseApproval(
364     address _spender,
365     uint _addedValue
366   )
367     public
368     whenNotPaused
369     returns (bool success)
370   {
371     return super.increaseApproval(_spender, _addedValue);
372   }
373 
374   function decreaseApproval(
375     address _spender,
376     uint _subtractedValue
377   )
378     public
379     whenNotPaused
380     returns (bool success)
381   {
382     return super.decreaseApproval(_spender, _subtractedValue);
383   }
384 }
385 
386 
387 contract TokenDestructible is Ownable {
388 
389   constructor() public payable { }
390 
391   /**
392    * @notice Terminate contract and refund to owner
393    * @notice The called token contracts could try to re-enter this contract. Only
394    supply token contracts you trust.
395    */
396   function destroy() onlyOwner public {
397     selfdestruct(owner);
398   }
399 }
400 
401 
402 contract Token is PausableToken, TokenDestructible {
403 
404   /**
405    * Variables that define basic token features
406    */ 
407   uint256 public decimals;
408   string public name;
409   string public symbol;
410   uint256 releasedAmount = 0;
411 
412   constructor(uint256 _totalSupply, uint256 _decimals, string _name, string _symbol) public {
413     require(_totalSupply > 0);
414     require(_decimals > 0);
415 
416     totalSupply_ = _totalSupply;
417     decimals = _decimals;
418     name = _name;
419     symbol = _symbol;
420 
421     balances[msg.sender] = _totalSupply;
422 
423     // transfer all supply to the owner
424     emit Transfer(address(0), msg.sender, _totalSupply);
425   }
426 }