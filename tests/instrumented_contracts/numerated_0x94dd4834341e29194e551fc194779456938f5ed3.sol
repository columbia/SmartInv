1 pragma solidity ^0.4.24;
2 
3 // based on https://github.com/OpenZeppelin/openzeppelin-solidity/
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256) {
101     return balances[_owner];
102   }
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender)
111     public view returns (uint256);
112 
113   function transferFrom(address from, address to, uint256 value)
114     public returns (bool);
115 
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(
118     address indexed owner,
119     address indexed spender,
120     uint256 value
121   );
122 }
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint256 the amount of tokens to be transferred
140    */
141   function transferFrom(
142     address _from,
143     address _to,
144     uint256 _value
145   )
146     public
147     returns (bool)
148   {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     emit Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     emit Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(
183     address _owner,
184     address _spender
185    )
186     public
187     view
188     returns (uint256)
189   {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(
204     address _spender,
205     uint _addedValue
206   )
207     public
208     returns (bool)
209   {
210     allowed[msg.sender][_spender] = (
211       allowed[msg.sender][_spender].add(_addedValue));
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 
246 /**
247  * @title Ownable
248  * @dev The Ownable contract has an owner address, and provides basic authorization control
249  * functions, this simplifies the implementation of "user permissions".
250  */
251 contract Ownable {
252   address public owner;
253 
254   event OwnershipRenounced(address indexed previousOwner);
255   event OwnershipTransferred(
256     address indexed previousOwner,
257     address indexed newOwner
258   );
259 
260 
261   /**
262    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
263    * account.
264    */
265   constructor() public {
266     owner = msg.sender;
267   }
268 
269   /**
270    * @dev Throws if called by any account other than the owner.
271    */
272   modifier onlyOwner() {
273     require(msg.sender == owner);
274     _;
275   }
276 
277   /**
278    * @dev Allows the current owner to transfer control of the contract to a newOwner.
279    * @param newOwner The address to transfer ownership to.
280    */
281   function transferOwnership(address newOwner) public onlyOwner {
282     require(newOwner != address(0));
283     emit OwnershipTransferred(owner, newOwner);
284     owner = newOwner;
285   }
286 }
287 
288 /**
289  * @title Mintable token
290  * @dev Simple ERC20 Token example, with mintable token creation
291  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
292  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
293  */
294 contract MintableToken is StandardToken, Ownable {
295   event Mint(address indexed to, uint256 amount);
296 
297   bool public mintingFinished = false;
298   uint public mintTotal = 0;
299 
300   modifier canMint() {
301     require(!mintingFinished);
302     _;
303   }
304 
305   modifier hasMintPermission() {
306     require(msg.sender == owner);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(
317     address _to,
318     uint256 _amount
319   )
320     hasMintPermission
321     canMint
322     public
323     returns (bool)
324   {
325     uint tmpTotal = mintTotal.add(_amount);
326     require(tmpTotal <= totalSupply_);
327     mintTotal = mintTotal.add(_amount);
328     balances[_to] = balances[_to].add(_amount);
329     emit Mint(_to, _amount);
330     emit Transfer(address(0), _to, _amount);
331     return true;
332   }
333 }
334 
335 
336 /**
337  * @title Pausable
338  * @dev Base contract which allows children to implement an emergency stop mechanism.
339  */
340 contract Pausable is Ownable {
341   event Pause();
342   event Unpause();
343 
344   bool public paused = false;
345 
346 
347   /**
348    * @dev Modifier to make a function callable only when the contract is not paused.
349    */
350   modifier whenNotPaused() {
351     require(!paused);
352     _;
353   }
354 
355   /**
356    * @dev Modifier to make a function callable only when the contract is paused.
357    */
358   modifier whenPaused() {
359     require(paused);
360     _;
361   }
362 
363   /**
364    * @dev called by the owner to pause, triggers stopped state
365    */
366   function pause() onlyOwner whenNotPaused public {
367     paused = true;
368     emit Pause();
369   }
370 
371   /**
372    * @dev called by the owner to unpause, returns to normal state
373    */
374   function unpause() onlyOwner whenPaused public {
375     paused = false;
376     emit Unpause();
377   }
378 }
379 
380 
381 /**
382  * @title Pausable token
383  * @dev StandardToken modified with pausable transfers.
384  **/
385 contract PausableToken is StandardToken, Pausable {
386 
387   function transfer(
388     address _to,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.transfer(_to, _value);
396   }
397 
398   function transferFrom(
399     address _from,
400     address _to,
401     uint256 _value
402   )
403     public
404     whenNotPaused
405     returns (bool)
406   {
407     return super.transferFrom(_from, _to, _value);
408   }
409 
410   function approve(
411     address _spender,
412     uint256 _value
413   )
414     public
415     whenNotPaused
416     returns (bool)
417   {
418     return super.approve(_spender, _value);
419   }
420 
421   function increaseApproval(
422     address _spender,
423     uint _addedValue
424   )
425     public
426     whenNotPaused
427     returns (bool success)
428   {
429     return super.increaseApproval(_spender, _addedValue);
430   }
431 
432   function decreaseApproval(
433     address _spender,
434     uint _subtractedValue
435   )
436     public
437     whenNotPaused
438     returns (bool success)
439   {
440     return super.decreaseApproval(_spender, _subtractedValue);
441   }
442 }
443 
444 contract DecentralizedInternetProtocolToken is PausableToken, MintableToken {
445     // public variables
446     string public name = "Decentralized Internet Protocol Token";
447     string public symbol = "DIPT";
448     uint8 public decimals = 18;
449 
450     constructor() public {
451         totalSupply_ = 4294967296 * (10 ** uint256(decimals));
452     }
453     
454     function () public payable {
455         revert();
456     }
457 }