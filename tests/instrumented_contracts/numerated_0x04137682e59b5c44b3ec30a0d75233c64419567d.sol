1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender)
138     public view returns (uint256);
139 
140   function transferFrom(address from, address to, uint256 value)
141     public returns (bool);
142 
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
152 
153 /**
154  * @title SafeERC20
155  * @dev Wrappers around ERC20 operations that throw on failure.
156  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
157  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
158  */
159 library SafeERC20 {
160   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
161     require(token.transfer(to, value));
162   }
163 
164   function safeTransferFrom(
165     ERC20 token,
166     address from,
167     address to,
168     uint256 value
169   )
170     internal
171   {
172     require(token.transferFrom(from, to, value));
173   }
174 
175   function safeApprove(ERC20 token, address spender, uint256 value) internal {
176     require(token.approve(spender, value));
177   }
178 }
179 
180 // File: @tokenfoundry/token-contracts/contracts/TokenControllerI.sol
181 
182 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
183 contract TokenControllerI {
184 
185     /// @dev Specifies whether a transfer is allowed or not.
186     /// @return True if the transfer is allowed
187     function transferAllowed(address _from, address _to)
188         external
189         view 
190         returns (bool);
191 }
192 
193 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
194 
195 /**
196  * @title Basic token
197  * @dev Basic version of StandardToken, with no allowances.
198  */
199 contract BasicToken is ERC20Basic {
200   using SafeMath for uint256;
201 
202   mapping(address => uint256) balances;
203 
204   uint256 totalSupply_;
205 
206   /**
207   * @dev total number of tokens in existence
208   */
209   function totalSupply() public view returns (uint256) {
210     return totalSupply_;
211   }
212 
213   /**
214   * @dev transfer token for a specified address
215   * @param _to The address to transfer to.
216   * @param _value The amount to be transferred.
217   */
218   function transfer(address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[msg.sender]);
221 
222     balances[msg.sender] = balances[msg.sender].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     emit Transfer(msg.sender, _to, _value);
225     return true;
226   }
227 
228   /**
229   * @dev Gets the balance of the specified address.
230   * @param _owner The address to query the the balance of.
231   * @return An uint256 representing the amount owned by the passed address.
232   */
233   function balanceOf(address _owner) public view returns (uint256) {
234     return balances[_owner];
235   }
236 
237 }
238 
239 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
240 
241 /**
242  * @title Standard ERC20 token
243  *
244  * @dev Implementation of the basic standard token.
245  * @dev https://github.com/ethereum/EIPs/issues/20
246  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
247  */
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_to != address(0));
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
280    *
281    * Beware that changing an allowance with this method brings the risk that someone may use both the old
282    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
283    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
284    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285    * @param _spender The address which will spend the funds.
286    * @param _value The amount of tokens to be spent.
287    */
288   function approve(address _spender, uint256 _value) public returns (bool) {
289     allowed[msg.sender][_spender] = _value;
290     emit Approval(msg.sender, _spender, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Function to check the amount of tokens that an owner allowed to a spender.
296    * @param _owner address The address which owns the funds.
297    * @param _spender address The address which will spend the funds.
298    * @return A uint256 specifying the amount of tokens still available for the spender.
299    */
300   function allowance(
301     address _owner,
302     address _spender
303    )
304     public
305     view
306     returns (uint256)
307   {
308     return allowed[_owner][_spender];
309   }
310 
311   /**
312    * @dev Increase the amount of tokens that an owner allowed to a spender.
313    *
314    * approve should be called when allowed[_spender] == 0. To increment
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _addedValue The amount of tokens to increase the allowance by.
320    */
321   function increaseApproval(
322     address _spender,
323     uint _addedValue
324   )
325     public
326     returns (bool)
327   {
328     allowed[msg.sender][_spender] = (
329       allowed[msg.sender][_spender].add(_addedValue));
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334   /**
335    * @dev Decrease the amount of tokens that an owner allowed to a spender.
336    *
337    * approve should be called when allowed[_spender] == 0. To decrement
338    * allowed value is better to use this function to avoid 2 calls (and wait until
339    * the first transaction is mined)
340    * From MonolithDAO Token.sol
341    * @param _spender The address which will spend the funds.
342    * @param _subtractedValue The amount of tokens to decrease the allowance by.
343    */
344   function decreaseApproval(
345     address _spender,
346     uint _subtractedValue
347   )
348     public
349     returns (bool)
350   {
351     uint oldValue = allowed[msg.sender][_spender];
352     if (_subtractedValue > oldValue) {
353       allowed[msg.sender][_spender] = 0;
354     } else {
355       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
356     }
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361 }
362 
363 // File: @tokenfoundry/token-contracts/contracts/ControllableToken.sol
364 
365 /**
366  * @title Controllable ERC20 token
367  *
368  * @dev Token that queries a token controller contract to check if a transfer is allowed.
369  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
370  * implemented transferAllowed() function.
371  */
372 contract ControllableToken is Ownable, StandardToken {
373     TokenControllerI public controller;
374 
375     /// @dev Executes transferAllowed() function from the Controller. 
376     modifier isAllowed(address _from, address _to) {
377         require(controller.transferAllowed(_from, _to), "Token Controller does not permit transfer.");
378         _;
379     }
380 
381     /// @dev Sets the controller that is going to be used by isAllowed modifier
382     function setController(TokenControllerI _controller) onlyOwner public {
383         require(_controller != address(0), "Controller address should not be zero.");
384         controller = _controller;
385     }
386 
387     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
388     /// @return True if the token is transfered with success
389     function transfer(address _to, uint256 _value) 
390         isAllowed(msg.sender, _to)
391         public
392         returns (bool)
393     {
394         return super.transfer(_to, _value);
395     }
396 
397     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
398     /// @return True if the token is transfered with success 
399     function transferFrom(address _from, address _to, uint256 _value)
400         isAllowed(_from, _to) 
401         public 
402         returns (bool)
403     {
404         return super.transferFrom(_from, _to, _value);
405     }
406 }
407 
408 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
409 
410 /**
411  * @title DetailedERC20 token
412  * @dev The decimals are only for visualization purposes.
413  * All the operations are done using the smallest and indivisible token unit,
414  * just as on Ethereum all the operations are done in wei.
415  */
416 contract DetailedERC20 is ERC20 {
417   string public name;
418   string public symbol;
419   uint8 public decimals;
420 
421   constructor(string _name, string _symbol, uint8 _decimals) public {
422     name = _name;
423     symbol = _symbol;
424     decimals = _decimals;
425   }
426 }
427 
428 // File: @tokenfoundry/token-contracts/contracts/Token.sol
429 
430 /**
431  * @title Token base contract - Defines basic structure for a token
432  *
433  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
434  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
435  */
436 contract Token is ControllableToken, DetailedERC20 {
437 
438 	/**
439 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
440 	* @param _supply Total supply of tokens.
441     * @param _name Is the long name by which the token contract should be known
442     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
443     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
444 	*/
445     constructor(
446         uint256 _supply,
447         string _name,
448         string _symbol,
449         uint8 _decimals
450     ) DetailedERC20(_name, _symbol, _decimals) public {
451         require(_supply != 0, "Supply should be greater than 0.");
452         totalSupply_ = _supply;
453         balances[msg.sender] = _supply;
454         emit Transfer(address(0), msg.sender, _supply);  //event
455     }
456 }