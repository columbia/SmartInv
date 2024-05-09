1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 /**
251  * @title Ownable
252  * @dev The Ownable contract has an owner address, and provides basic authorization control
253  * functions, this simplifies the implementation of "user permissions".
254  */
255 contract Ownable {
256   address public owner;
257 
258 
259   event OwnershipRenounced(address indexed previousOwner);
260   event OwnershipTransferred(
261     address indexed previousOwner,
262     address indexed newOwner
263   );
264 
265 
266   /**
267    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
268    * account.
269    */
270   constructor() public {
271     owner = msg.sender;
272   }
273 
274   /**
275    * @dev Throws if called by any account other than the owner.
276    */
277   modifier onlyOwner() {
278     require(msg.sender == owner);
279     _;
280   }
281 
282   /**
283    * @dev Allows the current owner to relinquish control of the contract.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   modifier hasMintPermission() {
328     require(msg.sender == owner);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(
339     address _to,
340     uint256 _amount
341   )
342     hasMintPermission
343     canMint
344     public
345     returns (bool)
346   {
347     totalSupply_ = totalSupply_.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     emit Mint(_to, _amount);
350     emit Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyOwner canMint public returns (bool) {
359     mintingFinished = true;
360     emit MintFinished();
361     return true;
362   }
363 }
364 
365 /**
366  * @title Pausable
367  * @dev Base contract which allows children to implement an emergency stop mechanism.
368  */
369 contract Pausable is Ownable {
370   event Pause();
371   event Unpause();
372 
373   bool public paused = false;
374 
375 
376   /**
377    * @dev Modifier to make a function callable only when the contract is not paused.
378    */
379   modifier whenNotPaused() {
380     require(!paused);
381     _;
382   }
383 
384   /**
385    * @dev Modifier to make a function callable only when the contract is paused.
386    */
387   modifier whenPaused() {
388     require(paused);
389     _;
390   }
391 
392   /**
393    * @dev called by the owner to pause, triggers stopped state
394    */
395   function pause() onlyOwner whenNotPaused public {
396     paused = true;
397     emit Pause();
398   }
399 
400   /**
401    * @dev called by the owner to unpause, returns to normal state
402    */
403   function unpause() onlyOwner whenPaused public {
404     paused = false;
405     emit Unpause();
406   }
407 }
408 
409 /**
410  * @title Pausable token
411  * @dev StandardToken modified with pausable transfers.
412  **/
413 contract PausableToken is StandardToken, Pausable {
414 
415   function transfer(
416     address _to,
417     uint256 _value
418   )
419     public
420     whenNotPaused
421     returns (bool)
422   {
423     return super.transfer(_to, _value);
424   }
425 
426   function transferFrom(
427     address _from,
428     address _to,
429     uint256 _value
430   )
431     public
432     whenNotPaused
433     returns (bool)
434   {
435     return super.transferFrom(_from, _to, _value);
436   }
437 
438   function approve(
439     address _spender,
440     uint256 _value
441   )
442     public
443     whenNotPaused
444     returns (bool)
445   {
446     return super.approve(_spender, _value);
447   }
448 
449   function increaseApproval(
450     address _spender,
451     uint _addedValue
452   )
453     public
454     whenNotPaused
455     returns (bool success)
456   {
457     return super.increaseApproval(_spender, _addedValue);
458   }
459 
460   function decreaseApproval(
461     address _spender,
462     uint _subtractedValue
463   )
464     public
465     whenNotPaused
466     returns (bool success)
467   {
468     return super.decreaseApproval(_spender, _subtractedValue);
469   }
470 }
471 
472 contract WirebitsToken is MintableToken, PausableToken {
473   string  public name;
474   string  public symbol;
475   uint256 public decimals;
476 
477   constructor() public {
478     name = "Wirebits";
479     symbol = "WRBT";
480     decimals = 18;
481   }
482 }