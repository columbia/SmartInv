1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-11
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 // based on https://github.com/OpenZeppelin/openzeppelin-solidity/tree/v1.10.0
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
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
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(
146     address _from,
147     address _to,
148     uint256 _value
149   )
150     public
151     returns (bool)
152   {
153     require(_to != address(0));
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     emit Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    *
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseApproval(
208     address _spender,
209     uint _addedValue
210   )
211     public
212     returns (bool)
213   {
214     allowed[msg.sender][_spender] = (
215       allowed[msg.sender][_spender].add(_addedValue));
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(
231     address _spender,
232     uint _subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 
250 /**
251  * @title Ownable
252  * @dev The Ownable contract has an owner address, and provides basic authorization control
253  * functions, this simplifies the implementation of "user permissions".
254  */
255 contract Ownable {
256   address public owner;
257 
258   event OwnershipRenounced(address indexed previousOwner);
259   event OwnershipTransferred(
260     address indexed previousOwner,
261     address indexed newOwner
262   );
263 
264 
265   /**
266    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
267    * account.
268    */
269   constructor() public {
270     owner = msg.sender;
271   }
272 
273   /**
274    * @dev Throws if called by any account other than the owner.
275    */
276   modifier onlyOwner() {
277     require(msg.sender == owner);
278     _;
279   }
280 
281   /**
282    * @dev Allows the current owner to transfer control of the contract to a newOwner.
283    * @param newOwner The address to transfer ownership to.
284    */
285   function transferOwnership(address newOwner) public onlyOwner {
286     require(newOwner != address(0));
287     emit OwnershipTransferred(owner, newOwner);
288     owner = newOwner;
289   }
290 }
291 
292 /**
293  * @title Mintable token
294  * @dev Simple ERC20 Token example, with mintable token creation
295  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
296  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
297  */
298 contract MintableToken is StandardToken, Ownable {
299   event Mint(address indexed to, uint256 amount);
300 
301   bool public mintingFinished = false;
302   uint public mintTotal = 0;
303 
304   modifier canMint() {
305     require(!mintingFinished);
306     _;
307   }
308 
309   modifier hasMintPermission() {
310     require(msg.sender == owner);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(
321     address _to,
322     uint256 _amount
323   )
324     hasMintPermission
325     canMint
326     public
327     returns (bool)
328   {
329     uint tmpTotal = mintTotal.add(_amount);
330     require(tmpTotal <= totalSupply_);
331     mintTotal = mintTotal.add(_amount);
332     balances[_to] = balances[_to].add(_amount);
333     emit Mint(_to, _amount);
334     emit Transfer(address(0), _to, _amount);
335     return true;
336   }
337 }
338 
339 
340 /**
341  * @title Pausable
342  * @dev Base contract which allows children to implement an emergency stop mechanism.
343  */
344 contract Pausable is Ownable {
345   event Pause();
346   event Unpause();
347 
348   bool public paused = true;
349 
350 
351   /**
352    * @dev Modifier to make a function callable only when the contract is not paused.
353    */
354   modifier whenNotPaused() {
355     require(!paused);
356     _;
357   }
358 
359   /**
360    * @dev Modifier to make a function callable only when the contract is paused.
361    */
362   modifier whenPaused() {
363     require(paused);
364     _;
365   }
366 
367   /**
368    * @dev called by the owner to pause, triggers stopped state
369    */
370   function pause() onlyOwner whenNotPaused public {
371     paused = true;
372     emit Pause();
373   }
374 
375   /**
376    * @dev called by the owner to unpause, returns to normal state
377    */
378   function unpause() onlyOwner whenPaused public {
379     paused = false;
380     emit Unpause();
381   }
382 }
383 
384 
385 /**
386  * @title Pausable token
387  * @dev StandardToken modified with pausable transfers.
388  **/
389 contract PausableToken is StandardToken, Pausable {
390 
391   function transfer(
392     address _to,
393     uint256 _value
394   )
395     public
396     whenNotPaused
397     returns (bool)
398   {
399     return super.transfer(_to, _value);
400   }
401 
402   function transferFrom(
403     address _from,
404     address _to,
405     uint256 _value
406   )
407     public
408     whenNotPaused
409     returns (bool)
410   {
411     return super.transferFrom(_from, _to, _value);
412   }
413 
414   function approve(
415     address _spender,
416     uint256 _value
417   )
418     public
419     whenNotPaused
420     returns (bool)
421   {
422     return super.approve(_spender, _value);
423   }
424 
425   function increaseApproval(
426     address _spender,
427     uint _addedValue
428   )
429     public
430     whenNotPaused
431     returns (bool success)
432   {
433     return super.increaseApproval(_spender, _addedValue);
434   }
435 
436   function decreaseApproval(
437     address _spender,
438     uint _subtractedValue
439   )
440     public
441     whenNotPaused
442     returns (bool success)
443   {
444     return super.decreaseApproval(_spender, _subtractedValue);
445   }
446 }
447 
448 contract MATHToken is PausableToken, MintableToken {
449     // public variables
450     string public name = "MATH Token";
451     string public symbol = "MATH";
452     uint8 public decimals = 18;
453 
454     constructor() public {
455         totalSupply_ = 200000000 * (10 ** uint256(decimals));
456     }
457     
458     function () public payable {
459         revert();
460     }
461 }