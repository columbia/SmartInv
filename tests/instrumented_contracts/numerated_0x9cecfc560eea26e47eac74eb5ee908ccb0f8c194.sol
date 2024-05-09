1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 
119 /**
120  * @title ERC20Basic
121  * @dev Simpler version of ERC20 interface
122  * See https://github.com/ethereum/EIPs/issues/179
123  */
124 contract ERC20Basic {
125   function totalSupply() public view returns (uint256);
126   function balanceOf(address _who) public view returns (uint256);
127   function transfer(address _to, uint256 _value) public returns (bool);
128   event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address _owner, address _spender)
139     public view returns (uint256);
140 
141   function transferFrom(address _from, address _to, uint256 _value)
142     public returns (bool);
143 
144   function approve(address _spender, uint256 _value) public returns (bool);
145   event Approval(
146     address indexed owner,
147     address indexed spender,
148     uint256 value
149   );
150 }
151 
152 
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances.
157  */
158 contract BasicToken is ERC20Basic {
159   using SafeMath for uint256;
160 
161   mapping(address => uint256) internal balances;
162 
163   uint256 internal totalSupply_;
164 
165   /**
166   * @dev Total number of tokens in existence
167   */
168   function totalSupply() public view returns (uint256) {
169     return totalSupply_;
170   }
171 
172   /**
173   * @dev Transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public returns (bool) {
178     require(_value <= balances[msg.sender]);
179     require(_to != address(0));
180 
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     emit Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param _owner The address to query the the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address _owner) public view returns (uint256) {
193     return balances[_owner];
194   }
195 
196 }
197 
198 
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * https://github.com/ethereum/EIPs/issues/20
205  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(
219     address _from,
220     address _to,
221     uint256 _value
222   )
223     public
224     returns (bool)
225   {
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228     require(_to != address(0));
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(
259     address _owner,
260     address _spender
261    )
262     public
263     view
264     returns (uint256)
265   {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(
279     address _spender,
280     uint256 _addedValue
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
293    * approve should be called when allowed[_spender] == 0. To decrement
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _subtractedValue The amount of tokens to decrease the allowance by.
299    */
300   function decreaseApproval(
301     address _spender,
302     uint256 _subtractedValue
303   )
304     public
305     returns (bool)
306   {
307     uint256 oldValue = allowed[msg.sender][_spender];
308     if (_subtractedValue >= oldValue) {
309       allowed[msg.sender][_spender] = 0;
310     } else {
311       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312     }
313     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 }
318 
319 
320 
321 /**
322  * @title Mintable token
323  * @dev Simple ERC20 Token example, with mintable token creation
324  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
325  */
326 contract MintableToken is StandardToken, Ownable {
327   event Mint(address indexed to, uint256 amount);
328   event MintFinished();
329 
330   bool public mintingFinished = false;
331 
332 
333   modifier canMint() {
334     require(!mintingFinished);
335     _;
336   }
337 
338   modifier hasMintPermission() {
339     require(msg.sender == owner);
340     _;
341   }
342 
343   /**
344    * @dev Function to mint tokens
345    * @param _to The address that will receive the minted tokens.
346    * @param _amount The amount of tokens to mint.
347    * @return A boolean that indicates if the operation was successful.
348    */
349   function mint(
350     address _to,
351     uint256 _amount
352   )
353     public
354     hasMintPermission
355     canMint
356     returns (bool)
357   {
358     totalSupply_ = totalSupply_.add(_amount);
359     balances[_to] = balances[_to].add(_amount);
360     emit Mint(_to, _amount);
361     emit Transfer(address(0), _to, _amount);
362     return true;
363   }
364 
365   /**
366    * @dev Function to stop minting new tokens.
367    * @return True if the operation was successful.
368    */
369   function finishMinting() public onlyOwner canMint returns (bool) {
370     mintingFinished = true;
371     emit MintFinished();
372     return true;
373   }
374 }
375 
376 
377 
378 /**
379  * @title DetailedERC20 token
380  * @dev The decimals are only for visualization purposes.
381  * All the operations are done using the smallest and indivisible token unit,
382  * just as on Ethereum all the operations are done in wei.
383  */
384 contract DetailedERC20 is ERC20 {
385   string public name;
386   string public symbol;
387   uint8 public decimals;
388 
389   constructor(string _name, string _symbol, uint8 _decimals) public {
390     name = _name;
391     symbol = _symbol;
392     decimals = _decimals;
393   }
394 }
395 
396 
397 
398 /**
399  * @title KHDonToken
400  * @dev Very simple ERC20 Token that can be minted.
401  * It is meant to be used in a crowdsale contract.
402  */
403  
404 contract KHDonToken is MintableToken, DetailedERC20 {
405       constructor(string _name, string _symbol, uint8 _decimals)
406         DetailedERC20(_name, _symbol, _decimals)
407         public
408     {
409 
410     }
411 }