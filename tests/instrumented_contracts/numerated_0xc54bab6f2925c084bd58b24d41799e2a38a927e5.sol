1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address _owner, address _spender)
30     public view returns (uint256);
31 
32   function transferFrom(address _from, address _to, uint256 _value)
33     public returns (bool);
34 
35   function approve(address _spender, uint256 _value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
44 
45 pragma solidity ^0.4.24;
46 
47 
48 
49 /**
50  * @title DetailedERC20 token
51  * @dev The decimals are only for visualization purposes.
52  * All the operations are done using the smallest and indivisible token unit,
53  * just as on Ethereum all the operations are done in wei.
54  */
55 contract DetailedERC20 is ERC20 {
56   string public name;
57   string public symbol;
58   uint8 public decimals;
59 
60   constructor(string _name, string _symbol, uint8 _decimals) public {
61     name = _name;
62     symbol = _symbol;
63     decimals = _decimals;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 pragma solidity ^0.4.24;
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
82     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
83     // benefit is lost if 'b' is also tested.
84     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85     if (_a == 0) {
86       return 0;
87     }
88 
89     c = _a * _b;
90     assert(c / _a == _b);
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers, truncating the quotient.
96   */
97   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
98     // assert(_b > 0); // Solidity automatically throws when dividing by 0
99     // uint256 c = _a / _b;
100     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
101     return _a / _b;
102   }
103 
104   /**
105   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
108     assert(_b <= _a);
109     return _a - _b;
110   }
111 
112   /**
113   * @dev Adds two numbers, throws on overflow.
114   */
115   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
116     c = _a + _b;
117     assert(c >= _a);
118     return c;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
123 
124 pragma solidity ^0.4.24;
125 
126 
127 
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances.
132  */
133 contract BasicToken is ERC20Basic {
134   using SafeMath for uint256;
135 
136   mapping(address => uint256) internal balances;
137 
138   uint256 internal totalSupply_;
139 
140   /**
141   * @dev Total number of tokens in existence
142   */
143   function totalSupply() public view returns (uint256) {
144     return totalSupply_;
145   }
146 
147   /**
148   * @dev Transfer token for a specified address
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transfer(address _to, uint256 _value) public returns (bool) {
153     require(_value <= balances[msg.sender]);
154     require(_to != address(0));
155 
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     emit Transfer(msg.sender, _to, _value);
159     return true;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256) {
168     return balances[_owner];
169   }
170 
171 }
172 
173 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
174 
175 pragma solidity ^0.4.24;
176 
177 
178 
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * https://github.com/ethereum/EIPs/issues/20
185  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) internal allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(
199     address _from,
200     address _to,
201     uint256 _value
202   )
203     public
204     returns (bool)
205   {
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208     require(_to != address(0));
209 
210     balances[_from] = balances[_from].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213     emit Transfer(_from, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(
239     address _owner,
240     address _spender
241    )
242     public
243     view
244     returns (uint256)
245   {
246     return allowed[_owner][_spender];
247   }
248 
249   /**
250    * @dev Increase the amount of tokens that an owner allowed to a spender.
251    * approve should be called when allowed[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _addedValue The amount of tokens to increase the allowance by.
257    */
258   function increaseApproval(
259     address _spender,
260     uint256 _addedValue
261   )
262     public
263     returns (bool)
264   {
265     allowed[msg.sender][_spender] = (
266       allowed[msg.sender][_spender].add(_addedValue));
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To decrement
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _subtractedValue The amount of tokens to decrease the allowance by.
279    */
280   function decreaseApproval(
281     address _spender,
282     uint256 _subtractedValue
283   )
284     public
285     returns (bool)
286   {
287     uint256 oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue >= oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297 }
298 
299 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
300 
301 pragma solidity ^0.4.24;
302 
303 
304 /**
305  * @title Ownable
306  * @dev The Ownable contract has an owner address, and provides basic authorization control
307  * functions, this simplifies the implementation of "user permissions".
308  */
309 contract Ownable {
310   address public owner;
311 
312 
313   event OwnershipRenounced(address indexed previousOwner);
314   event OwnershipTransferred(
315     address indexed previousOwner,
316     address indexed newOwner
317   );
318 
319 
320   /**
321    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
322    * account.
323    */
324   constructor() public {
325     owner = msg.sender;
326   }
327 
328   /**
329    * @dev Throws if called by any account other than the owner.
330    */
331   modifier onlyOwner() {
332     require(msg.sender == owner);
333     _;
334   }
335 
336   /**
337    * @dev Allows the current owner to relinquish control of the contract.
338    * @notice Renouncing to ownership will leave the contract without an owner.
339    * It will not be possible to call the functions with the `onlyOwner`
340    * modifier anymore.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(owner);
344     owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address _newOwner) public onlyOwner {
352     _transferOwnership(_newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param _newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address _newOwner) internal {
360     require(_newOwner != address(0));
361     emit OwnershipTransferred(owner, _newOwner);
362     owner = _newOwner;
363   }
364 }
365 
366 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
367 
368 pragma solidity ^0.4.24;
369 
370 
371 
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
377  */
378 contract MintableToken is StandardToken, Ownable {
379   event Mint(address indexed to, uint256 amount);
380   event MintFinished();
381 
382   bool public mintingFinished = false;
383 
384 
385   modifier canMint() {
386     require(!mintingFinished);
387     _;
388   }
389 
390   modifier hasMintPermission() {
391     require(msg.sender == owner);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will receive the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(
402     address _to,
403     uint256 _amount
404   )
405     public
406     hasMintPermission
407     canMint
408     returns (bool)
409   {
410     totalSupply_ = totalSupply_.add(_amount);
411     balances[_to] = balances[_to].add(_amount);
412     emit Mint(_to, _amount);
413     emit Transfer(address(0), _to, _amount);
414     return true;
415   }
416 
417   /**
418    * @dev Function to stop minting new tokens.
419    * @return True if the operation was successful.
420    */
421   function finishMinting() public onlyOwner canMint returns (bool) {
422     mintingFinished = true;
423     emit MintFinished();
424     return true;
425   }
426 }
427 
428 // File: contracts/ATFToken.sol
429 
430 pragma solidity ^0.4.24;
431 
432 
433 
434 
435 
436 /**
437  * @title DetailedERC20 token
438  * @dev The decimals are only for visualization purposes.
439  * All the operations are done using the smallest and indivisible token unit,
440  * just as on Ethereum all the operations are done in wei.
441  */
442 contract ATFToken is StandardToken, MintableToken, DetailedERC20 {
443 
444     //We inherited the DetailedERC20
445     constructor(string _name, string _symbol, uint8 _decimals)
446     DetailedERC20(_name, _symbol, _decimals)
447     public {
448     }
449 
450 }