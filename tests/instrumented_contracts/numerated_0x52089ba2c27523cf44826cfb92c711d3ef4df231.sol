1 pragma solidity ^0.4.13;
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
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract Pausable is Ownable {
104   event Pause();
105   event Unpause();
106 
107   bool public paused = false;
108 
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is not paused.
112    */
113   modifier whenNotPaused() {
114     require(!paused);
115     _;
116   }
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is paused.
120    */
121   modifier whenPaused() {
122     require(paused);
123     _;
124   }
125 
126   /**
127    * @dev called by the owner to pause, triggers stopped state
128    */
129   function pause() onlyOwner whenNotPaused public {
130     paused = true;
131     emit Pause();
132   }
133 
134   /**
135    * @dev called by the owner to unpause, returns to normal state
136    */
137   function unpause() onlyOwner whenPaused public {
138     paused = false;
139     emit Unpause();
140   }
141 }
142 
143 contract ERC20Basic {
144   function totalSupply() public view returns (uint256);
145   function balanceOf(address who) public view returns (uint256);
146   function transfer(address to, uint256 value) public returns (bool);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   uint256 totalSupply_;
156 
157   /**
158   * @dev total number of tokens in existence
159   */
160   function totalSupply() public view returns (uint256) {
161     return totalSupply_;
162   }
163 
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171     require(_value <= balances[msg.sender]);
172 
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     emit Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 contract ERC20 is ERC20Basic {
191   function allowance(address owner, address spender)
192     public view returns (uint256);
193 
194   function transferFrom(address from, address to, uint256 value)
195     public returns (bool);
196 
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(
199     address indexed owner,
200     address indexed spender,
201     uint256 value
202   );
203 }
204 
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(
217     address _from,
218     address _to,
219     uint256 _value
220   )
221     public
222     returns (bool)
223   {
224     require(_to != address(0));
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227 
228     balances[_from] = balances[_from].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
231     emit Transfer(_from, _to, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
237    *
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     emit Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(
258     address _owner,
259     address _spender
260    )
261     public
262     view
263     returns (uint256)
264   {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(
279     address _spender,
280     uint _addedValue
281   )
282     public
283     returns (bool)
284   {
285     allowed[msg.sender][_spender] = (
286       allowed[msg.sender][_spender].add(_addedValue));
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(
302     address _spender,
303     uint _subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     uint oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue > oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 contract MintableToken is StandardToken, Ownable {
321   event Mint(address indexed to, uint256 amount);
322   event MintFinished();
323 
324   bool public mintingFinished = false;
325 
326 
327   modifier canMint() {
328     require(!mintingFinished);
329     _;
330   }
331 
332   modifier hasMintPermission() {
333     require(msg.sender == owner);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(
344     address _to,
345     uint256 _amount
346   )
347     hasMintPermission
348     canMint
349     public
350     returns (bool)
351   {
352     totalSupply_ = totalSupply_.add(_amount);
353     balances[_to] = balances[_to].add(_amount);
354     emit Mint(_to, _amount);
355     emit Transfer(address(0), _to, _amount);
356     return true;
357   }
358 
359   /**
360    * @dev Function to stop minting new tokens.
361    * @return True if the operation was successful.
362    */
363   function finishMinting() onlyOwner canMint public returns (bool) {
364     mintingFinished = true;
365     emit MintFinished();
366     return true;
367   }
368 }
369 
370 contract CappedToken is MintableToken {
371 
372   uint256 public cap;
373 
374   constructor(uint256 _cap) public {
375     require(_cap > 0);
376     cap = _cap;
377   }
378 
379   /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385   function mint(
386     address _to,
387     uint256 _amount
388   )
389     onlyOwner
390     canMint
391     public
392     returns (bool)
393   {
394     require(totalSupply_.add(_amount) <= cap);
395 
396     return super.mint(_to, _amount);
397   }
398 
399 }
400 
401 contract PausableToken is StandardToken, Pausable {
402 
403   function transfer(
404     address _to,
405     uint256 _value
406   )
407     public
408     whenNotPaused
409     returns (bool)
410   {
411     return super.transfer(_to, _value);
412   }
413 
414   function transferFrom(
415     address _from,
416     address _to,
417     uint256 _value
418   )
419     public
420     whenNotPaused
421     returns (bool)
422   {
423     return super.transferFrom(_from, _to, _value);
424   }
425 
426   function approve(
427     address _spender,
428     uint256 _value
429   )
430     public
431     whenNotPaused
432     returns (bool)
433   {
434     return super.approve(_spender, _value);
435   }
436 
437   function increaseApproval(
438     address _spender,
439     uint _addedValue
440   )
441     public
442     whenNotPaused
443     returns (bool success)
444   {
445     return super.increaseApproval(_spender, _addedValue);
446   }
447 
448   function decreaseApproval(
449     address _spender,
450     uint _subtractedValue
451   )
452     public
453     whenNotPaused
454     returns (bool success)
455   {
456     return super.decreaseApproval(_spender, _subtractedValue);
457   }
458 }
459 
460 contract OMIToken is CappedToken, PausableToken {
461   string public constant name = "Ecomi Token";
462   string public constant symbol = "OMI";
463   uint256 public decimals = 18;
464 
465   function OMIToken() public CappedToken(1000000000*1e18) {}
466 
467   /// @dev Function to call from other contracts to ensure that this is the proper contract
468   function isOMITokenContract()
469     public 
470     pure 
471     returns(bool)
472   { 
473     return true; 
474   }
475 }