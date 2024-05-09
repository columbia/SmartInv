1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: contracts/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: contracts/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: contracts/Ownable.sol
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155 
156   event OwnershipRenounced(address indexed previousOwner);
157   event OwnershipTransferred(
158     address indexed previousOwner,
159     address indexed newOwner
160   );
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   constructor() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to relinquish control of the contract.
181    * @notice Renouncing to ownership will leave the contract without an owner.
182    * It will not be possible to call the functions with the `onlyOwner`
183    * modifier anymore.
184    */
185   function renounceOwnership() public onlyOwner {
186     emit OwnershipRenounced(owner);
187     owner = address(0);
188   }
189 
190   /**
191    * @dev Allows the current owner to transfer control of the contract to a newOwner.
192    * @param _newOwner The address to transfer ownership to.
193    */
194   function transferOwnership(address _newOwner) public onlyOwner {
195     _transferOwnership(_newOwner);
196   }
197 
198   /**
199    * @dev Transfers control of the contract to a newOwner.
200    * @param _newOwner The address to transfer ownership to.
201    */
202   function _transferOwnership(address _newOwner) internal {
203     require(_newOwner != address(0));
204     emit OwnershipTransferred(owner, _newOwner);
205     owner = _newOwner;
206   }
207 }
208 
209 // File: contracts/ERC20.sol
210 
211 /**
212  * @title ERC20 interface
213  * @dev see https://github.com/ethereum/EIPs/issues/20
214  */
215 contract ERC20 is ERC20Basic {
216   function allowance(address owner, address spender)
217     public view returns (uint256);
218 
219   function transferFrom(address from, address to, uint256 value)
220     public returns (bool);
221 
222   function approve(address spender, uint256 value) public returns (bool);
223   event Approval(
224     address indexed owner,
225     address indexed spender,
226     uint256 value
227   );
228 }
229 
230 // File: contracts/StandardToken.sol
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * https://github.com/ethereum/EIPs/issues/20
237  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
238  */
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(
251     address _from,
252     address _to,
253     uint256 _value
254   )
255     public
256     returns (bool)
257   {
258     require(_to != address(0));
259     require(_value <= balances[_from]);
260     require(_value <= allowed[_from][msg.sender]);
261 
262     balances[_from] = balances[_from].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265     emit Transfer(_from, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     emit Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(
291     address _owner,
292     address _spender
293    )
294     public
295     view
296     returns (uint256)
297   {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseApproval(
311     address _spender,
312     uint256 _addedValue
313   )
314     public
315     returns (bool)
316   {
317     allowed[msg.sender][_spender] = (
318       allowed[msg.sender][_spender].add(_addedValue));
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323   /**
324    * @dev Decrease the amount of tokens that an owner allowed to a spender.
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(
333     address _spender,
334     uint256 _subtractedValue
335   )
336     public
337     returns (bool)
338   {
339     uint256 oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue > oldValue) {
341       allowed[msg.sender][_spender] = 0;
342     } else {
343       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344     }
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349 }
350 
351 // File: contracts/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
357  */
358 contract MintableToken is StandardToken, Ownable {
359   event Mint(address indexed to, uint256 amount);
360   event MintFinished();
361 
362   bool public mintingFinished = false;
363 
364 
365   modifier canMint() {
366     require(!mintingFinished);
367     _;
368   }
369 
370   modifier hasMintPermission() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     hasMintPermission
386     canMint
387     public
388     returns (bool)
389   {
390     totalSupply_ = totalSupply_.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     emit Mint(_to, _amount);
393     emit Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() onlyOwner canMint public returns (bool) {
402     mintingFinished = true;
403     emit MintFinished();
404     return true;
405   }
406 }
407 
408 // File: contracts/CappedToken.sol
409 
410 /**
411  * @title Capped token
412  * @dev Mintable token with a token cap.
413  */
414 contract CappedToken is MintableToken {
415 
416   uint256 public cap;
417 
418   constructor(uint256 _cap) public {
419     require(_cap > 0);
420     cap = _cap;
421   }
422 
423   /**
424    * @dev Function to mint tokens
425    * @param _to The address that will receive the minted tokens.
426    * @param _amount The amount of tokens to mint.
427    * @return A boolean that indicates if the operation was successful.
428    */
429   function mint(
430     address _to,
431     uint256 _amount
432   )
433     public
434     returns (bool)
435   {
436     require(totalSupply_.add(_amount) <= cap);
437 
438     return super.mint(_to, _amount);
439   }
440 
441   /**
442    * @dev Function to mint tokens
443    * @param _cap cap amount
444    * @return A boolean that indicates if the operation was successful.
445    */
446   function changeCap(uint256 _cap) public onlyOwner {
447     require(_cap > totalSupply_);
448     cap = _cap;
449   }
450 
451 }
452 
453 // File: contracts/DetailedERC20.sol
454 
455 /**
456  * @title DetailedERC20 token
457  * @dev The decimals are only for visualization purposes.
458  * All the operations are done using the smallest and indivisible token unit,
459  * just as on Ethereum all the operations are done in wei.
460  */
461 contract DetailedERC20 is ERC20 {
462   string public name;
463   string public symbol;
464   uint8 public decimals;
465 
466   constructor(string _name, string _symbol, uint8 _decimals) public {
467     name = _name;
468     symbol = _symbol;
469     decimals = _decimals;
470   }
471 }
472 
473 // File: contracts/EmethToken.sol
474 
475 /**
476  * @title Emeth token
477  * @dev Mintable, Burnable ERC20 compliant token
478  */
479 contract EmethToken is DetailedERC20, CappedToken, BurnableToken {
480   string public icon = "QmVqVzW38emorVLx1sk9XBZZ2hQ5zEBCK392mavC9XY7TU";
481   constructor() public DetailedERC20("Emeth", "EMT", 18) CappedToken(20000000000000000000000000) {}
482 }