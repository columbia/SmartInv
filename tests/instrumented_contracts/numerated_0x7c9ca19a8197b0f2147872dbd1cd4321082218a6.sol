1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipRenounced(address indexed previousOwner);
70   event OwnershipTransferred(
71     address indexed previousOwner,
72     address indexed newOwner
73   );
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    * @notice Renouncing to ownership will leave the contract without an owner.
95    * It will not be possible to call the functions with the `onlyOwner`
96    * modifier anymore.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address _newOwner) public onlyOwner {
108     _transferOwnership(_newOwner);
109   }
110 
111   /**
112    * @dev Transfers control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function _transferOwnership(address _newOwner) internal {
116     require(_newOwner != address(0));
117     emit OwnershipTransferred(owner, _newOwner);
118     owner = _newOwner;
119   }
120 }
121 
122 // File: zeppelin-solidity/contracts/math/SafeMath.sol
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that throw on error
127  */
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, throws on overflow.
132   */
133   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
134     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
135     // benefit is lost if 'b' is also tested.
136     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137     if (_a == 0) {
138       return 0;
139     }
140 
141     c = _a * _b;
142     assert(c / _a == _b);
143     return c;
144   }
145 
146   /**
147   * @dev Integer division of two numbers, truncating the quotient.
148   */
149   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
150     // assert(_b > 0); // Solidity automatically throws when dividing by 0
151     // uint256 c = _a / _b;
152     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
153     return _a / _b;
154   }
155 
156   /**
157   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
158   */
159   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
160     assert(_b <= _a);
161     return _a - _b;
162   }
163 
164   /**
165   * @dev Adds two numbers, throws on overflow.
166   */
167   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
168     c = _a + _b;
169     assert(c >= _a);
170     return c;
171   }
172 }
173 
174 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181   using SafeMath for uint256;
182 
183   mapping(address => uint256) internal balances;
184 
185   uint256 internal totalSupply_;
186 
187   /**
188   * @dev Total number of tokens in existence
189   */
190   function totalSupply() public view returns (uint256) {
191     return totalSupply_;
192   }
193 
194   /**
195   * @dev Transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_value <= balances[msg.sender]);
201     require(_to != address(0));
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     emit Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * https://github.com/ethereum/EIPs/issues/20
227  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
248     require(_value <= balances[_from]);
249     require(_value <= allowed[_from][msg.sender]);
250     require(_to != address(0));
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
261    * Beware that changing an allowance with this method brings the risk that someone may use both the old
262    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
263    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
264    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265    * @param _spender The address which will spend the funds.
266    * @param _value The amount of tokens to be spent.
267    */
268   function approve(address _spender, uint256 _value) public returns (bool) {
269     allowed[msg.sender][_spender] = _value;
270     emit Approval(msg.sender, _spender, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Function to check the amount of tokens that an owner allowed to a spender.
276    * @param _owner address The address which owns the funds.
277    * @param _spender address The address which will spend the funds.
278    * @return A uint256 specifying the amount of tokens still available for the spender.
279    */
280   function allowance(
281     address _owner,
282     address _spender
283    )
284     public
285     view
286     returns (uint256)
287   {
288     return allowed[_owner][_spender];
289   }
290 
291   /**
292    * @dev Increase the amount of tokens that an owner allowed to a spender.
293    * approve should be called when allowed[_spender] == 0. To increment
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _addedValue The amount of tokens to increase the allowance by.
299    */
300   function increaseApproval(
301     address _spender,
302     uint256 _addedValue
303   )
304     public
305     returns (bool)
306   {
307     allowed[msg.sender][_spender] = (
308       allowed[msg.sender][_spender].add(_addedValue));
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Decrease the amount of tokens that an owner allowed to a spender.
315    * approve should be called when allowed[_spender] == 0. To decrement
316    * allowed value is better to use this function to avoid 2 calls (and wait until
317    * the first transaction is mined)
318    * From MonolithDAO Token.sol
319    * @param _spender The address which will spend the funds.
320    * @param _subtractedValue The amount of tokens to decrease the allowance by.
321    */
322   function decreaseApproval(
323     address _spender,
324     uint256 _subtractedValue
325   )
326     public
327     returns (bool)
328   {
329     uint256 oldValue = allowed[msg.sender][_spender];
330     if (_subtractedValue >= oldValue) {
331       allowed[msg.sender][_spender] = 0;
332     } else {
333       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
334     }
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339 }
340 
341 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
347  */
348 contract MintableToken is StandardToken, Ownable {
349   event Mint(address indexed to, uint256 amount);
350   event MintFinished();
351 
352   bool public mintingFinished = false;
353 
354 
355   modifier canMint() {
356     require(!mintingFinished);
357     _;
358   }
359 
360   modifier hasMintPermission() {
361     require(msg.sender == owner);
362     _;
363   }
364 
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will receive the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(
372     address _to,
373     uint256 _amount
374   )
375     public
376     hasMintPermission
377     canMint
378     returns (bool)
379   {
380     totalSupply_ = totalSupply_.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     emit Mint(_to, _amount);
383     emit Transfer(address(0), _to, _amount);
384     return true;
385   }
386 
387   /**
388    * @dev Function to stop minting new tokens.
389    * @return True if the operation was successful.
390    */
391   function finishMinting() public onlyOwner canMint returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 // File: contracts/Boost.sol
399 
400 contract Boost is MintableToken, DetailedERC20("Boost", "BST", 18) {
401 }