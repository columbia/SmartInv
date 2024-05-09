1 pragma solidity 0.4.24;
2 
3 // File: node_modules/@tokenfoundry/token-contracts/contracts/TokenControllerI.sol
4 
5 /// @title Interface for token controllers. The controller specifies whether a transfer can be done.
6 contract TokenControllerI {
7 
8     /// @dev Specifies whether a transfer is allowed or not.
9     /// @return True if the transfer is allowed
10     function transferAllowed(address _from, address _to)
11         external
12         view 
13         returns (bool);
14 }
15 
16 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
78 
79 /**
80  * @title SafeMath
81  * @dev Math operations with safety checks that throw on error
82  */
83 library SafeMath {
84 
85   /**
86   * @dev Multiplies two numbers, throws on overflow.
87   */
88   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
89     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
90     // benefit is lost if 'b' is also tested.
91     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92     if (a == 0) {
93       return 0;
94     }
95 
96     c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     // uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return a / b;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
123     c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
130 
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20Basic {
137   function totalSupply() public view returns (uint256);
138   function balanceOf(address who) public view returns (uint256);
139   function transfer(address to, uint256 value) public returns (bool);
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
190 
191 /**
192  * @title ERC20 interface
193  * @dev see https://github.com/ethereum/EIPs/issues/20
194  */
195 contract ERC20 is ERC20Basic {
196   function allowance(address owner, address spender)
197     public view returns (uint256);
198 
199   function transferFrom(address from, address to, uint256 value)
200     public returns (bool);
201 
202   function approve(address spender, uint256 value) public returns (bool);
203   event Approval(
204     address indexed owner,
205     address indexed spender,
206     uint256 value
207   );
208 }
209 
210 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * @dev https://github.com/ethereum/EIPs/issues/20
217  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(
231     address _from,
232     address _to,
233     uint256 _value
234   )
235     public
236     returns (bool)
237   {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(
272     address _owner,
273     address _spender
274    )
275     public
276     view
277     returns (uint256)
278   {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * @dev Increase the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To increment
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _addedValue The amount of tokens to increase the allowance by.
291    */
292   function increaseApproval(
293     address _spender,
294     uint _addedValue
295   )
296     public
297     returns (bool)
298   {
299     allowed[msg.sender][_spender] = (
300       allowed[msg.sender][_spender].add(_addedValue));
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    *
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(
316     address _spender,
317     uint _subtractedValue
318   )
319     public
320     returns (bool)
321   {
322     uint oldValue = allowed[msg.sender][_spender];
323     if (_subtractedValue > oldValue) {
324       allowed[msg.sender][_spender] = 0;
325     } else {
326       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
327     }
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332 }
333 
334 // File: node_modules/@tokenfoundry/token-contracts/contracts/ControllableToken.sol
335 
336 /**
337  * @title Controllable ERC20 token
338  *
339  * @dev Token that queries a token controller contract to check if a transfer is allowed.
340  * @dev controller state var is going to be set with the address of a TokenControllerI contract that has 
341  * implemented transferAllowed() function.
342  */
343 contract ControllableToken is Ownable, StandardToken {
344     TokenControllerI public controller;
345 
346     /// @dev Executes transferAllowed() function from the Controller. 
347     modifier isAllowed(address _from, address _to) {
348         require(controller.transferAllowed(_from, _to));
349         _;
350     }
351 
352     /// @dev Sets the controller that is going to be used by isAllowed modifier
353     function setController(TokenControllerI _controller) onlyOwner public {
354         require(_controller != address(0));
355         controller = _controller;
356     }
357 
358     /// @dev It calls parent BasicToken.transfer() function. It will transfer an amount of tokens to an specific address
359     /// @return True if the token is transfered with success
360     function transfer(address _to, uint256 _value) 
361         isAllowed(msg.sender, _to)
362         public
363         returns (bool)
364     {
365         return super.transfer(_to, _value);
366     }
367 
368     /// @dev It calls parent StandardToken.transferFrom() function. It will transfer from an address a certain amount of tokens to another address 
369     /// @return True if the token is transfered with success 
370     function transferFrom(address _from, address _to, uint256 _value)
371         isAllowed(_from, _to) 
372         public 
373         returns (bool)
374     {
375         return super.transferFrom(_from, _to, _value);
376     }
377 }
378 
379 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
380 
381 /**
382  * @title DetailedERC20 token
383  * @dev The decimals are only for visualization purposes.
384  * All the operations are done using the smallest and indivisible token unit,
385  * just as on Ethereum all the operations are done in wei.
386  */
387 contract DetailedERC20 is ERC20 {
388   string public name;
389   string public symbol;
390   uint8 public decimals;
391 
392   constructor(string _name, string _symbol, uint8 _decimals) public {
393     name = _name;
394     symbol = _symbol;
395     decimals = _decimals;
396   }
397 }
398 
399 // File: node_modules/@tokenfoundry/token-contracts/contracts/Token.sol
400 
401 /**
402  * @title Token base contract - Defines basic structure for a token
403  *
404  * @dev ControllableToken is a StandardToken, an OpenZeppelin ERC20 implementation library. DetailedERC20 is also an OpenZeppelin contract.
405  * More info about them is available here: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20
406  */
407 contract Token is ControllableToken, DetailedERC20 {
408 
409 	/**
410 	* @dev Transfer is an event inherited from ERC20Basic.sol interface (OpenZeppelin).
411 	* @param _supply Total supply of tokens.
412     * @param _name Is the long name by which the token contract should be known
413     * @param _symbol The set of capital letters used to represent the token e.g. DTH.
414     * @param _decimals The number of decimal places the tokens can be split up into. This should be between 0 and 18.
415 	*/
416     constructor(
417         uint256 _supply,
418         string _name,
419         string _symbol,
420         uint8 _decimals
421     ) DetailedERC20(_name, _symbol, _decimals) public {
422         require(_supply != 0);
423         totalSupply_ = _supply;
424         balances[msg.sender] = _supply;
425         emit Transfer(address(0), msg.sender, _supply);  //event
426     }
427 }